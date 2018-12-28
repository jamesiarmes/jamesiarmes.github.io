---
layout: post
title: Accessing HarrisData (IBM iSeries) In PHP
category: blog
section-type: post
created: 1226281673
tags:
  - AS/400
  - HarrisData
  - iSeries
  - ODBC
  - PDO
  - PHP
---
![HarrisData](/img/blog/2008/11/harrisdata_logo.png){: .post-image .image-right }
I have recently been working on a project to integrate with a
[HarrisData](http://www.harrisdata.com) ERP Application. The Application runs on
an IBM iSeries (AS/400). I used PHP's built in PDO object with the ODBC
extension. Using PDO, I was able to execute SQL Queries on the server. IBM
systems use IBM's DB2 syntax. This entry will outline some of the basic steps,
in PHP, to communicate with the system

<!--more-->

I will be assuming that you already have the ODBC driver installed and setup. I
will also be assuming that your ODBC connection is called "AS400".

I created a class called HarrisData. The constructor creates a PDO Object and
assigns it to a class property called $database.

{% highlight php startinline %}
$this->database = new PDO('odbc:AS400', 'USERNAME', 'password');
{% endhighlight %}

Method in the class can use this object to run queries on the database. For
example, let's say we want the first 10 rows of a table called "HDCUST".

{% highlight php startinline %}
$query = 'SELECT * FROM DBNAME.HDCUST FETCH FIRST 10 ROWS ONLY';
$results = $this->database->query($query);

// Check to make sure the query did not fail.
if (!$results) {
    return false;
}

while ($row = $results->fetch()) {
    // Do stuff...
}
{% endhighlight %}

I had to modify the columns being pulled several times. To make this easier and
make the code cleaner and easier to maintain, I created an array of columns to
be selected before each select statement. Note that I have placed the column
names in the array in my example, but I used constants for the actual code.

{% highlight php startinline %}
$select_array = array(
  'CMBLTO',
  'CMUDF3',
  'CMCMLU',
  'CMCUST',
  'CMSLTO',
);

$query = 'SELECT ' . implode(',', $select_array) . ' FROM DBNAME.HDCUST FETCH FIRST 10 ROWS ONLY';
$results = $this->database->query($query);
{% endhighlight %}

That's all there is to it. I have not had a need to write to the database at
this time. If the need should arise, I will be sure to write a new entry about
some of the techniques I used.
