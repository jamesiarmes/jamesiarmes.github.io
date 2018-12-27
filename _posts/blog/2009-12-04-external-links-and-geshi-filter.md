---
layout: post
title: External Links and GeSHi Filter
category: blog
created: 1259980929
tags:
  - CSS
  - Drupal
---
On my site I use the [External links](http://drupal.org/project/extlink) to add
the ![external link icon](/assets/images/2009/12/extlink.png) image next to any
external links. I also use the
[GeSHi Filter](http://drupal.org/project/geshifilter) module for syntax
highlighting. These two modules together were causing some undesirable effects.

<!--more-->

The GeSHi Filter module adds links to the [PHP manual](http://php.net) entry for
functions. Because this is an external link, it receives the image from above.
This doesn't look quite right:

![GeSHi Filter with external link](/assets/images/2009/12/external-link-geshi-filter.png)

So what did I do about it? I added the following lines to me themes CSS file
(sandbox.css for those who were wondering):

{% highlight css %}
div.geshifilter span.ext {
  background: none;
  padding-right:0;
}
{% endhighlight %}

As you can see by the following screen shot, the icon no longer appears in my
code:

![GeSHi Filter with no icon](/assets/images/2009/12/geshi-filter-clean.png)

I hope this was able to help somebody else out.
