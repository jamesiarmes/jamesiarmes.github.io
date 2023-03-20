---
layout: post
title:  Bidirectional replication in PostgreSQL using pglogical
date:   2023-03-08 01:14:00 -0500
category: blog
tags:
- databases
- docker
- postgresql
- replication
---
![Cover image][cover-image]{: .post-image.full-width }
I was recently working on a database migration from {% glossary AWS %} GovCloud
to AWS Commercial. We had a production database that was initially launched in
GovCloud despite not being a {% glossary FISMA %} High workload. Other pieces of
the stack had already been migrated, and the database, the most difficult piece
to move, was the last piece remaining.

Our options were more limited as we were going across partitions and AWS
services can't communicate across partitions. This includes IAM trust
relationships. Both the source and destination were RDS Postgres clusters.

After reviewing a number of options, replication using [pglogical][pglogical]
was an easy choice. To minimize downtime and allow for easier rollback, we opted
to use bidirectional replication. This is where each cluster replicates changes
in both directions. In our case, the GovCloud cluster would replicate changes to
the Commercial cluster, and vice-versa.

## What is replication?

Replication is the process of creating and maintaining one or more copies of a
database. These copies are kept in sync with each other. Replication can be used
to achieve high availability, improve performance, provide backups,  allow for
faster disaster recovery, and enable geo-distribution.

There are different types of database replication, including:

* **Physical replication:** The entire database is replicated, including all
  data and schema objects, at the file system level. Binary replication is a
  form of physical replication.
* **Logical replication:** Only selected tables and data changes are replicated
  to the secondary database.
* **Synchronous replication:** Changes made to the primary database are
  replicated to the secondaries immediately. The transaction on the primary is
  not committed until it has been successfully replicated to all secondaries.
  This is useful to eliminate race conditions caused by replication lag, but can
  have a significant performance impact.
* **Snapshot replication:** A snapshot of the primary database is taken and
  replicated to the secondary database at a regular interval. This type of
  replication is useful for maintaining a point-in-time copy of a database.

### Unidirectional vs. bidirectional

Unidirectional replication creates copies of a single, primary database to one
or more replicas. These replicas could be used as read-only servers to help
distribute database load, or one of them could be promoted if the primary goes
down or requires maintenance. Unidirectional replication is the most common
replication configuration.

![Diagram showing three nodes in unidirectional replication][unidirectional-diagram]

Bidirectional replication creates copies in each direction. Each database is
replicated to the others and vice-versa. This can create conflicts, especially
if one or more nodes fall behind. Bidirectional replication is useful for
geo-distribution, improved write performance by distributing queries, and
migrations where you need the ability to quickly roll back without data loss.

![Diagram showing three nodes in bidirectional replication][bidirectional-diagram]

{% aside {"title":"A note about language", "type":"social", "icon":"<i class=\"fa-solid fa-comment-dots\"></i>"} %}
You may sometimes see unidirectional replication referred to as master-slave or
single-master, and bidirectional replication as master-master or multi-master.
As we've grown as a community, we've come to recognize the harm caused by this
terminology and have evolved our language. As such, these terms are considered
outdated.
{% endaside %}

### How many nodes?

The total number of nodes that you'll need in your database cluster depends on
your needs, and this is further complicated by {% glossary DBaaS %} providers
that often have their own replicas. In fact, if you're using a DBaaS provider,
you may not need to configure replication unless you're looking to migrate your
database.

In general, the recommended number of nodes for ongoing replication is an odd
number of three or more. The importance of an odd number is that clusters can
participate in elections, where each node gets a vote. An odd number of nodes
helps to avoid a tie that could result in data loss. These elections can be
initiated in the case of a conflict during replication, when determining if a
node is down, and promoting a node to primary.

## How does pglogical support bidirectional replication?

pglogical is a PostgreSQL extension that provides logical replication
capabilities. It supports both unidirectional, and bidirectional replication, as
well as replication between different versions of PostgreSQL. This makes it a
great option for database migrations.

There are some limitations to replication with pglogical (not an exhaustive
list):

* Temporary tables can't be replicated
* DDL (Database Definition Language) isn't automatically replicated
* Foreign keys aren't enforced
* Sequences require additional configuration and are only updated periodically

To set up replication using pglogical, you first need to install the pglogical
extension on all databases that'll be participating in replication. You should
be able to find pglogical (it may be listed as "pg_logical") in your systems
package manager. For Ubuntu, you can use the following command to install
pglogical for PostgreSQL 14:

```bash
apt install -y postgresql-14-pglogical
```

Once installed, you'll need to configure PostgreSQL to load the extension and
use logical replication. This can be done by configuring the following settings
in your postgresql.conf:

```text
wal_level = logical
shared_preload_libraries = 'pglogical'
```

{% aside {"type":"note", "icon":"<i class=\"fa-solid fa-sticky-note\"></i>"} %}
shared_preload_libraries may have multiple comma-separated values. If you
are loading other libraries already, simply add pglogical to the list. For
example:

```text
shared_preload_libraries = 'pg_transport,pglogical'
```
{% endaside %}

You'll also need to allow scram-sha-256 authentication. Add the following to
your pg_hba.conf:

```text
host all all all scram-sha-256
```

{% aside {"type":"caution", "icon":"<i class=\"fa-solid fa-circle-exclamation\"></i>"} %}
This is overly open. You may want to review the documentation for 
[host-based authentication][hba] to make it more restrictive.

[hba]: https://www.postgresql.org/docs/14/auth-pg-hba-conf.html
{% endaside %}

After making these changes, you'll need to restart PostgreSQL before they'll be
applied.

For RDS, you can modify these settings in the database parameter group.

```text
rds.logical_replication=1
shared_preload_libraries = 'pglogical'
```

## Configure pglogical for unidirectional replication

Before we jump into bidirectional replication, let's get unidirectional
replication setup. Since we're trying to migrate a database, we'll setup this up
on two nodes called "source" and "destination."

You will need to create a replication user on each node and that user will
require the superuser privileges. For this example, we'll connect to each node
using basic authentication (username and password) as this is the only option
available on AWS without being able to use IAM roles.

Connect to the source database and load the extension:

```sql
CREATE EXTENSION pglogical;
```

Now add this node to pglogical. This will need to match the settings we use when
subscribing from the destination.

{% aside {"type":"note", "icon":"<i class=\"fa-solid fa-sticky-note\"></i>"} %}
We place this statement in a BEGIN/COMMIT block so that we can disable
logging. This will prevent the password from being logged in plain text.
{% endaside %}

```sql
BEGIN;
SET LOCAL log_statement = 'none';
SET LOCAL log_min_duration_statement = -1;
SELECT pglogical.create_node(
         node_name := 'source',
         dsn := 'host=source.example.com port=5432
                 sslmode=require dbname=databasename
                 user=replication password=********'
         );
COMMIT;
```

When you load pglogical, it creates three replication sets:

* default: All statements for all tables in the set.
* default_insert_only: Only INSERT statements for tables in the set. Primarily
  used for tables without primary keys.
* ddl_sql: Replicates DDL commands. See the section on DDL below.

We're going to be using the default replication set, which should be sufficient
for most situations. You can also define your own replication sets. See the
pglogical documentation for more information on that.

We can add all existing tables to the default replication set with a single
command, adding any schemas that you want to replicate to the array:

```sql
SELECT pglogical.replication_set_add_all_tables('default', ARRAY['public']);
```

{% aside {"type":"note", "icon":"<i class=\"fa-solid fa-sticky-note\"></i>"} %}
If you're using sequences (aka autoincrement columns), check the section
on [sequences](#lets-talk-sequences) below before moving on.
{% endaside %}

Our source node is now ready to replicate data to any subscribers! Before we're
done with the source, you'll need the database schema to exist on the
destination. If you already have a SQL file or some other way of building it on
your destination, then great! If not, you can grab it from the source using
pg_dump (make sure to add any necessary connection flags):

```bash
pg_dump --schema-only databasename > schema.sql
```

Okay, now we're done with the source (for now). On the destination, start by
adding the schema. If you used the pg_dump command above, you can feed that file
to the psql client:

```bash
psql databasename < schema.sql
```

Now, let's repeat the first few steps from source. We're going to load the
extension and add the node:

```sql
CREATE
EXTENSION pglogical;
BEGIN;
SET LOCAL log_statement = 'none';
SET LOCAL log_min_duration_statement = -1;
SELECT pglogical.create_node(
         node_name := 'destination',
         dsn := 'host=destination.example.com port=5432
                 sslmode=require dbname=databasename
                 user=replication password=********'
         );
COMMIT;
```

Since we're only setting up unidirectional replication at this point, we don't
need to setup any replication sets. We do, however, need to subscribe to the
source database:

```sql
BEGIN;
SET LOCAL log_statement = 'none';
SET LOCAL log_min_duration_statement = -1;
SELECT pglogical.create_subscription(
         subscription_name := 'source',
         provider_dsn := 'host=source.example.com port=5432
                          sslmode=require dbname=databasename
                          user=replication password=********'
         );
COMMIT;
```

Data should now begin replicating from the source to the destination. You can
monitor progress using the [`pg_stat_replication` view][view].

## Configure pglogical for bidirectional replication

Now that our destination has caught up, let's start replicating data the other
way. We're going to be repeating some steps from above, just on different nodes.

To start, let's add our tables from the destination to the default replication
set (I did say "yet"). Once again, you can add all the schemas to be replicated
to the array.

```sql
SELECT pglogical.replication_set_add_all_tables('default', ARRAY['public']);
```

{% aside {"type":"note", "icon":"<i class=\"fa-solid fa-sticky-note\"></i>"} %}
If you're using sequences (aka autoincrement columns), check the section
on [sequences](#lets-talk-sequences) below before moving on.
{% endaside %}

Now let's hop over to the source database and subscribe to the destination:

```sql
BEGIN;
SET LOCAL log_statement = 'none';
SET LOCAL log_min_duration_statement = -1;
SELECT pglogical.create_subscription(
         subscription_name := 'destination',
         provider_dsn := 'host=destination.example.com port=5432
                          sslmode=require dbname=databasename
                          user=replication password=********'
         );
COMMIT;
```

And that's it! We've just setup bidirectional replication between two PostgreSQL
databases. Like anything else though, it's not quite that simple.

## Let's talk sequences

Sequences, sometimes called autoincrement columns, are commonly used to create
unique ids as a primary key. On the backend, the database keeps track of the
current value for the field. When a new record is added, it uses the latest
available value and increments the counter.

This gets complicated when you have multiple places that writes can happen. Not
only do new records need to be synced, but also the current state of the
counter. Two records could be written to different nodes in close enough
proximity that they end up with the same id.

pglogical handles sequences separate from tables. You need to explicitly add
sequences to the replication set in addition to the tables. This can be done by
adding all sequences at once:

```sql
SELECT pglogical.replication_set_add_all_sequences('default', ARRAY['public']);
```

When new nodes subscribe to the replication set, it will sync the sequences and
create an offset for each node. This way, there won't be any overlap. The
sequences are then re-synced on a periodic basis.

### An example

Let's say we have a table called people with columns id and name. id is a
sequence column. This table is empty at the time that we setup replication, so
the sequences have been synced before any data has been added.

If we create our first record in the source database, we'll get something like
the following:

| id | name  |
| -- | ----- |
| 1  | James |

If we then create our second record, but this time on the destination database,
we get something similar to:

| id   | name     |
|------|----------|
| 1    | James    |
| 1001 | Naimothy |

You can see that the record we added to the primary was replicated over and we
have a new record with the id 1001. This gives us some breathing room before we
would have to deal with a sequence collision.

A sequence is a database object in PostgreSQL that's used to generate unique
numeric identifiers. Sequences are often used to generate primary key values for
tables. When you create a new table, you can specify that the primary key column
should use a sequence for its default value.

If you want to manually trigger a sync of sequences, you can use the following
to synchronize a single sequence:

```sql
SELECT pglogical.synchronize_sequence(sequence_id)
```

Or all sequences:

```sql
SELECT pglogical.synchronize_sequence(seqoid) FROM pglogical.sequence_state;
```

## What about DDL?

DDL, or Data Definition Language, is a subset of SQL for creating and modifying
objects in a database schema. This includes statements such as CREATE, ALTER,
and DROP. These statements aren't replicated by pglogical unless it is
explicitly told to do so.

If you want to replicate a DDL statement, such as ALTER TABLE, you'll need to do
so using the replicate_ddl_command function. For example:

```sql
SELECT pglogical.replicate_ddl_command('ALTER TABLE public.people ADD COLUMN notes TEXT');
```

This will add the column to the table locally, then add it to the ddl_sql
replication set for any subscribers.

## How to test it out

In order to test these configurations, I put together a
[docker compose][compose] file. It launches two containers running PostgreSQL
with pglogical installed and loaded. A container with [pgAdmin][pgadmin], a
web-based management interface, is launched and exposed over localhost port
8080.

I have made this [available][repo] on GitHub for anyone who'd like to give it a
try. The default credentials are documented in the README along with other
details.

[bidirectional-diagram]: /assets/img/postgres-replication/bidirectional-replication.svg
[compose]: https://docs.docker.com/compose/
[cover-image]: /assets/img/postgres-replication/cover.png
[pgadmin]: https://www.pgadmin.org/
[pglogical]: https://www.2ndquadrant.com/en/resources-old/pglogical/pglogical-docs/
[repo]: https://github.com/jamesiarmes/postgres-pglogical-bdr-docker
[unidirectional-diagram]: /assets/img/postgres-replication/unidirectional-replication.svg
[view]: https://www.postgresql.org/docs/current/monitoring-stats.html#MONITORING-PG-STAT-REPLICATION-VIEW
