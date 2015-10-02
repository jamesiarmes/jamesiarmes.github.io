---
layout: post
title: 'Selenium: Waiting For AJAX'
created: 1246491064
---
<img src="/sites/default/files/blog/selenium-rc-logo.png" alt="Selenium RC" title="" style="float: right" /><p>&nbsp;&nbsp;&nbsp; I was playing around with <a href="http://seleniumhq.org/">Selenium RC</a> a little while ago and ran into a little problem that I thought I would share with everyone.&nbsp; I was writing a test that bounced around <a href="http://www.workxpress.com">WorkXpress</a> to give me some performance benchmarks.&nbsp; My test added a new item that had a list layout of related items on it.&nbsp; I wanted to be able to follow a link to add items to that list.&nbsp; Seems easy enough right?</p>
<p>&nbsp;&nbsp;&nbsp; The difficult part came when I needed to wait for the layout to be reloaded after adding the Items to it.&nbsp; I knew that when the layout reloaded there was going to be a specific element on the page that was not there before.&nbsp; I tried using Testing_Selenium::waitForCondition() but that always returned right away and let the processing continue.&nbsp; After a little help from the documentation and <a href="http://stackoverflow.com">Stack Overflow</a>, I decided to give Testing_Selenium::getAttribute() a shot.</p><p>&nbsp;&nbsp;&nbsp; When I tried calling getAttribute() after waitForCondition(), I received a string back informing me that the element did not exist.&nbsp; This confirmed my suspicions that waitForConidtion() was coming back too early.&nbsp; I could have added a call to sleep() before continuing, but that would have defeated the purpose of my test.&nbsp; Without a better solution, I resorted to a while loop that exited when the element finally existed.&nbsp; The code I used is included below:</p>
<pre class="brush: php; toolbar: false;">
$selenium = new Testing_Selenium($browser, $url, $host, $port, $timeout);

// body of test

/**
 * waiForCondition() doesn't seem to be working for detecting if the content
 * has been loaded in the div, but this gets around it.
 */
getAttribute('element_id@attribute');
while (strpos($attr, 'not found') !== false) {
	$attr = $selenium->getAttribute('element_id@attribute');
} // end while

// remainder of test
</pre>
<p>&nbsp;&nbsp;&nbsp; Be very careful when attempting to do anything like this.  If the element never appears on screen, you will find yourself with an infinite loop.  Let me know what you think, or if you have a better solution.</p>
