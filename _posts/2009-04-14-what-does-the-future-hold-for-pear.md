---
layout: post
title: What Does The Future Hold For PEAR?
created: 1239755683
---
<a href="http://pear.php.net"><img  alt="PEAR Logo" title="PEAR Logo" src="/sites/default/files/blog/pearlogo.png" style="float: right;" /></a>&nbsp;&nbsp;&nbsp; With PHP 5.3 just over the horizon, I decided to see how well prepared <a href="http://www.workxpress.com">WorkXpress</a> was.   Our coding standard is pretty strict and was developed to ensure that our application conforms to E_STRICT standards.  However, we all know that some things are inevitably going to fall through the cracks.

&nbsp;&nbsp;&nbsp; The results of my research uncovered a few missed "is_a()"s and "=&amp;"s, but for the most part our code was clean.  I was pointed to a large amount of code that failed E_STRICT, <a href="http://pear.php.net">PEAR</a>.  Because PEAR and many of its packages are written in PHP 4, it is missing many things that would make it E_STRICT compliant.  Some, but not all, of these are listed below:

<ul>
  <li>Using the static keyword to define static functions</li>
  <li>Using public/protected/private to define class methods</li>
  <li>Using public/protected/private to define class properties (var is deprecated)</li>
  <li>Using instance of in place of is_a() (is_a() is deprecated)</li>
  <li>Eliminating the use of the deprecated =&amp; assignment operator</li>
  <li>Not sure if there are any, but removing any PHP short tags (ie. <?) (deprecated)</li>
</ul>

&nbsp;&nbsp;&nbsp; Fortunately, PEAR appears to be focusing more on future proofing their code rather than backwards compatibility.  Unfortunately, there are still many packages still written in PHP 4 (<a href="http://pear.php.net/package/Mail">Mail</a> and <a href="http://pear.php.net/package/Mail_Mime">Mail_Mime</a> for example).  While a visit to <a href="http://pear.php.net/packages.php?php=5">http://pear.php.net/packages.php?php=5</a> shows there are 121 PEAR packages written in PHP 5, there are still 314 written in PHP 4.  It sounds like PEAR still has a ways to go in order to be E_STRICT compliant.
