---
layout: post
title: 'Selenium: Waiting For AJAX'
category: blog
created: 1246491064
---
![Selenium RC](/assets/images/2009/07/selenium-rc-logo.png){: .post-image .image-right }
I was playing around with [Selenium RC](http://seleniumhq.org/) a little while
ago and ran into a little problem that I thought I would share with everyone.
I was writing a test that bounced around [WorkXpress](http://www.workxpress.com)
to give me some performance benchmarks. My test added a new item that had a list
layout of related items on it. I wanted to be able to follow a link to add items
to that list.&nbsp; Seems easy enough right?

<!--more-->

The difficult part came when I needed to wait for the layout to be reloaded
after adding the Items to it.&nbsp; I knew that when the layout reloaded there
was going to be a specific element on the page that was not there before. I
tried using `Testing_Selenium::waitForCondition()` but that always returned right
away and let the processing continue. After a little help from the documentation
and [Stack Overflow](http://stackoverflow.com), I decided to give
`Testing_Selenium::getAttribute()`

When I tried calling `getAttribute()` after `waitForCondition()`, I received a
string back informing me that the element did not exist. This confirmed my
suspicions that `waitForConidtion()` was coming back too early. I could have
added a call to `sleep()` before continuing, but that would have defeated the
purpose of my test.&nbsp; Without a better solution, I resorted to a while loop
that exited when the element finally existed. The code I used is included below:

{% highlight php startinline %}
$selenium = new Testing_Selenium($browser, $url, $host, $port, $timeout);

// Body of test.

/**
 * waiForCondition() doesn't seem to be working for detecting if the content
 * has been loaded in the div, but this gets around it.
 */
getAttribute('element_id@attribute');
while (strpos($attr, 'not found') !== false) {
	$attr = $selenium->getAttribute('element_id@attribute');
} // end while

// Remainder of test.
{% endhighlight %}

Be very careful when attempting to do anything like this. If the element never
appears on screen, you will find yourself with an infinite loop. Let me know
what you think, or if you have a better solution.
