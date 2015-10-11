---
layout: post
title: 'Why I Can''t Wait For PHP 6: Part 1'
category: blog
created: 1213125511
tags:
  - charset
  - PHP
  - UTF-8
---
Today I decided to take the initiative to add UTF-8 support to our Item Import
and Update tools. Easier said than done. I have had my share of Unicode issues
with PHP, as I am sure everyone has. This is the first one that I have not been
able to conquer.

<!--more-->

Our tools use an uploaded CSV file to both import new and update existing items
in the WorkXpress application. The file can be in either a comma or tab
delimited list formats. The Unicode problem arises when the uploaded file
contains any UTF-8 characters. We use
[fopen](http://us2.php.net/manual/en/function.fopen.php) to open the files and
[fgetcsv](http://us2.php.net/manual/en/function.fgetcsv.php) to parse the file.
However, fgetcsv does not support UTF-8 characters. After an hour of play, I
could not get any function to read the UTF-8 characters properly, not even
[file_get_contents](http://us2.php.net/manual/en/function.file-get-contents.php). 

For my test, I used a three line file I called utf_import.csv. The file looked
similar to the following:

{% highlight php startinline %}
"cafe Good","bold1"
"café Not So Good","bold2"
"cafae Okay I Guess","bold3"
{% endhighlight %}

However, I received the following results:

{% highlight php startinline %}
array
  0 => string 'cafe Good'
  1 => string 'bold1'

array
  0 => string 'caf� Not So Good'
  1 => string 'bold2'

array
  0 => string 'cafae Okay I Guess'
  1 => string 'bold3'
{% endhighlight %}

The Internet returned little help. I found several post suggesting to use
`setlocale(LC_ALL, 'en_US.UTF-8');` which would make sense based on this note in
the fgetcsv documentation:

> **Note:** Locale setting is taken into account by this function. If LANG is
> e.g. en_US.UTF-8, files in one-byte encoding are read wrong by this function.

Unfortunately, even this does not work. Some time later, I came across
[PHP Bug #38471: fgetcsv(): locale dependency of delimiter / enclosure arg](http://bugs.php.net/bug.php?id=38471).
The response to this bug:

> We're working Unicode support in PHP6. but it won't appear in previous
> versions.
