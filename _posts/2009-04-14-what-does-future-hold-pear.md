---
layout: post
title: What Does The Future Hold For PEAR?
category: blog
created: 1239755683
---
![PEAR](/assets/images/2009/04/pearlogo.png){: .post-image .image-right } With
PHP 5.3 just over the horizon, I decided to see how well prepared
[WorkXpress](http://www.workxpress.com) was. Our coding standard is pretty
strict and was developed to ensure that our application conforms to E_STRICT
standards. However, we all know that some things are inevitably going to fall
through the cracks.

The results of my research uncovered a few missed `is_a()`s and `=&`s, but
for the most part our code was clean. I was pointed to a large amount of code
that failed E_STRICT, [PEAR](http://pear.php.net). Because PEAR and many of its packages are written in PHP 4, it is missing many things that would make it E_STRICT compliant. Some, but not all, of these are listed below:

* Using the static keyword to define static functions
* Using public/protected/private to define class methods
* Using public/protected/private to define class properties (var is deprecated)
* Using instance of in place of is_a() (is_a() is deprecated)
* Eliminating the use of the deprecated =&amp; assignment operator
* Not sure if there are any, but removing any PHP short tags (ie. <?) (deprecated)

Fortunately, PEAR appears to be focusing more on future proofing their code
rather than backwards compatibility. Unfortunately, there are still many
packages still written in PHP 4 ([Mail](http://pear.php.net/package/Mail) and
[Mail_Mime](http://pear.php.net/package/Mail_Mime) for example). While a visit
<http://pear.php.net/packages.php?php=5> shows there are 121 PEAR packages
written in PHP 5, there are still 314 written in PHP 4. It sounds like PEAR
still has a ways to go in order to be E_STRICT compliant.
