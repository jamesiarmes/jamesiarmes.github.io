---
layout: post
title: External Links and GeSHi Filter
created: 1259980929
---
<p>&nbsp;&nbsp;&nbsp;&nbsp;On my site I use the <a href="http://drupal.org/project/extlink">External links</a> to add the <img src="/sites/default/files/blog/external-links-and-geshi-filter/extlink.png" alt="External Link Icon" /> image next to any external links.  I also use the <a href="http://drupal.org/project/geshifilter">GeSHi Filter</a> module for syntax highlighting.  These two modules together were causing some undesirable effects.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;The GeSHi Filter module adds links to the <a href="http://php.net">PHP manual</a> entry for functions.  Because this is an external link, it receives the image from above.  This doesn't look quite right:
<img src="/sites/default/files/blog/external-links-and-geshi-filter/external-link-geshi-filter.png" alt="GeSHi Filter with external link" /></p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;So what did I do about it?  I added the following lines to me themes CSS file (sandbox.css for those who were wondering):
<pre class="brush: css; toolbar: false;">
div.geshifilter span.ext {
  background: none;
  padding-right:0;
}
</pre>
As you can see by the following screen shot, the icon no longer appears in my code:
<img src="/sites/default/files/blog/external-links-and-geshi-filter/geshi-filter-clean.png" alt="GeSHi Filter with no icon" />
I hope this was able to help somebody else out</p>
