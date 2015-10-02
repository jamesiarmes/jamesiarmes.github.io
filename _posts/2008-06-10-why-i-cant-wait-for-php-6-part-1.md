---
layout: post
title: 'Why I Can''t Wait For PHP 6: Part 1'
created: 1213125511
---
&nbsp;&nbsp;&nbsp;&nbsp;Today I decided to take the initiative to add UTF-8 support to our Item Import and Update tools.  Easier said than done.  I have had my share of Unicode issues with PHP, as I am sure everyone has.  This is the first one that I have not been able to conquer.
&nbsp;&nbsp;&nbsp;&nbsp;Our tools use an uploaded *.csv file to both import new and update existing items in the WorkXpress application.  The file can be in either a comma or tab delimited list formats.  The Unicode problem arises when the uploaded file contains any UTF-8 characters.  We use <a href="http://us2.php.net/manual/en/function.fopen.php">fopen</a> to open the files and <a href="http://us2.php.net/manual/en/function.fgetcsv.php">fgetcsv</a> to parse the file.  However, fgetcsv does not support UTF-8 characters.  After an hour of play, I could not get any function to read the UTF-8 characters properly, not even <a href="http://us2.php.net/manual/en/function.file-get-contents.php">file_get_contents</a>.  

&nbsp;&nbsp;&nbsp;&nbsp;For my test, I used a three line file I called utf_import.csv.  The file looked similar to the following:
<pre class="brush: plain; toolbar: false;">
"cafe Good","bold1"
"café Not So Good","bold2"
"cafae Okay I Guess","bold3"
</pre>
However, I received the following results:
<pre class="brush: php; toolbar: false;">
array
  0 => string 'cafe Good'
  1 => string 'bold1'

array
  0 => string 'caf� Not So Good'
  1 => string 'bold2'

array
  0 => string 'cafae Okay I Guess'
  1 => string 'bold3'
</pre>

&nbsp;&nbsp;&nbsp;&nbsp;The Internet returned little help.  I found several post suggesting to use <code type="php">setlocale(LC_ALL, 'en_US.UTF-8');</code> which would make sense based on this note in the <a href="http://us2.php.net/manual/en/function.fgetcsv.php">fgetcsv documentation</a>:
<blockquote>
<strong>Note:</strong> Locale setting is taken into account by this function. If LANG is e.g. en_US.UTF-8, files in one-byte encoding are read wrong by this function.
</blockquote>
Unfortunately, even this does not work.  Some time later, I came across <a href="http://bugs.php.net/bug.php?id=38471">PHP Bug #38471: fgetcsv(): locale dependency of delimiter / enclosure arg</a>.  The response to this bug:
<blockquote>
We're working Unicode support in PHP6. but it won't appear in previous
versions.
</blockquote>
