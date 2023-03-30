---
layout: post
title:  STI, Associations, and Polymorphism‽ Oh my!
date:   2023-01-25 01:06:00 -0400
image:  /assets/img/covers/rails.preview.png
category: blog
cover:
  image: /assets/img/covers/rails.svg
  title: Ruby on Rails logo
tags:
  - programming
  - rails
  - ruby
  - software
---
For much of 2022 I was working on an open data classification tool built in Ruby
on Rails. Although initially developed to help classify emergency call data, the
tool could be used for any type of data, with some modification.

When describing a data set, the user uploads a CSV file and that file is parsed
to generate some basic statistics and get the list of headers. After mapping
fields from the data set to a common schema, the CSV is again parsed looking for
unique values that need to be classified.

Many open data platforms expose a public API that could be used instead of
uploading a CSV. These APIs would require more information and code for each
platform to get the same information as the CSV. However, this information could
be acquired more quickly and with far fewer resources. Using an API would also
allow for future updates to the data set.

My experience with Rails before this project was minimal. I could visualize how
I'd implement multiple data source types in general, but I need to learn how to
do it "the Rails way." I'm not certain I accomplished that completely, but I did
learn some things about Rails models and associations along the way.

![Entity relationship diagram before refactor][er-diag-before]

## What is STI?

[Single Table Inheritance][sti] (STI)[^1] is a design pattern in Ruby on Rails that
allows you to use a single database table to store multiple types of objects
that share some common attributes. This is accomplished by adding a type column
to the table that's used to store the class name of each object.

For example, you might have a `Person` class that has a `name` attribute and a
`type` attribute. You could then create two subclasses of `Person`: `Employee`
and `Student`. In the database, all the `Employee` and `Student` objects would
be stored in the same table as `Person` objects. The `type` column would be used
to differentiate between the different types of objects.

```ruby
class Person < ApplicationRecord; end

class Employee < Person; end

class Student < Person; end
```

Subclasses can share any number of attributes (as long as the type remains the
same) as well as have their own attributes. Each attribute will be added as a
column on the table, which can make it difficult to scale if you have many
subclasses with differing attributes. This is important to consider when
deciding to implement STI over MTI (Multiple Table Inheritance).

## What are associations?

[Associations][associations] are a way to define relationships between Active
Record models. These relationships allow you to specify how one model is related
to another, and how the models should interact with each other.

There are several types of associations that you can use in Rails:

* `belongs_to`: used for relationships where the current model will store the
  reference to a related model. For example, a `Profile` model that `belongs_to`
  a `User`.
* `has_one`[^2]: used for one-to-one relationships where the related model includes
  a reference to the current model. For example, a `User` model that `has_one`
  `Profile`.
* `has_many`[^2]: used for one-to-many relationships where the related models
  include a reference to the current model. For example, a `User` model that
  `has_many` `Notifications`.
* `has_and_belongs_to_many`: used for many-to-many relationships and uses a
  junction table to store the references. For example: an `Author` model that
  `has_and_belongs_to_many` `Books`.

## What are polymorphic associations?

[Polymorphic][polymorphic] associations allow a model to belong to more than one
other model using the same association. This is done by adding a type column to
reference the model, along with the standard id column. For example, you could
have a Comment model that can belong to either a Post or a Product:

```ruby
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
end

class Post < ApplicationRecord
  has_many :comments, as :commentable
end

class Product < ApplicationRecord
  has_many :comments, as :commentable
end
```

With this association, you can use call `.commentable` on a comment to get the
comment's parent, regardless of whether it is a post or product.

## Why?

I opted to use STI to represent the data source models, which would all inherit
from DataSource. To begin with, there'd be two children: CsvFile and Socrata (an
[open data platform][socrata]). There are a few reasons for the decision[^3]:

* The number of shared fields between data sources is likely to be high, but 
  split between two types: file sources and API sources.
* Does not increase database complexity with each new data source.
* Extensibility and modularity: data sources could be packed as gems and
  contributed by third-parties.

Polymorphic associations made this a breeze:

<figure>
  <figcaption>migration.rb</figcaption>
{% highlight ruby %}
class CreateDataSources < ActiveRecord::Migration[7.0]
  def change
    create_table :data_sources do |t|
      t.string :type
      t.string :name
      t.string :api_domain
      t.string :api_resource
      t.string :api_key

      t.timestamps
    end

    add_reference :data_sets, :data_source, null: false, polymorphic: true
  end
end
{% endhighlight %}
</figure>

<figure>
  <figcaption>models.rb</figcaption>
{% highlight ruby %}
class DataSet < ApplicationRecord
  belongs_to :data_source, polymorphic: true, optional: false, dependent: :destroy
end

class DataSource < ApplicationRecord
  has_one :data_set, as: :data_source
end

class CsvFile < DataSource
  has_many_attached :files, dependent: :destroy
  
  validates :files, attached: true
end

class Socrata < DataSource
  validates :api_domain, presence: true
  validates :api_resource, presence: true
end
{% endhighlight %}
</figure>

And with that, we've created this relationship:

![Entity relationship diagram after refactor][er-diag-after]

## Final thoughts

Single table inheritance lets you separate logic without repeating code or
complicating the database schema. Polymorphic associations make this pattern
even more powerful. However, it can also result in large tables with lots of
empty columns. If you expect your child models to differ significantly in their
field, you should consider a different implementation.

[associations]: https://guides.rubyonrails.org/association_basics.html
[er-diag-before]: /assets/img/sti-associations-polymorphism/er-before.svg
[er-diag-after]: /assets/img/sti-associations-polymorphism/er-after.svg
[polymorphic]: https://guides.rubyonrails.org/association_basics.html#polymorphic-associations
[socrata]: https://dev.socrata.com/
[sti]: https://api.rubyonrails.org/classes/ActiveRecord/Inheritance.html

[^1]: Yes, I know what else STI stands for, but I'm not going to repeat "single
      table inheritance" seven times.

[^2]: These associations also have a `through` option that uses an additional
      model in the middle.

[^3]: If I come to regret this decision, you can expect a post titled
      "Refactoring your way out of STI."
