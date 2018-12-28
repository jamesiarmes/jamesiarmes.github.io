---
layout: post
title: Add Viddler Videos To Your Drupal Site
category: blog
section-type: post
created: 1239502202
tags:
  - Drupal
  - Viddler
  - Videos
---
Have a [Viddler](http://www.viddler.com) account and looking to embed videos on
your website?  You could embed the videos directly into the body of your nodes,
but that doesn't give you as much control as you may desire. You could use
[CCK](http://drupal.org/project/cck) and the
[Embedded Media Field (emfield)](http://drupal.org/project/emfield) module, but
that doesn't support Viddler. Or does it?

<!--more-->

For [WorkXpress.com](http://www.workxpress.com) we needed a service that we
could use to host our videos. We originally used
[Google Video](http://video.google.com), but Google reduced the quality of the
videos too much. I looked at [YouTube](http://www.youtube.com), but I didn't
like how it recommends other videos to watch at the end of the current video.
After some research, I found that Viddler does not reduce the quality of the
video or recommend other user's videos.

Our website already had the emfield module installed for the videos hosted on
Google Video. However, the module did not support Viddler. Since we wanted full
control of the video, the best option was to take the time to add Viddler
support. You can see the results at <http://www.workxpress.com/tour>. I have
submitted my code for inclusion in the module, but I have yet to hear back. You
can check the status of this at <http://drupal.org/node/421164>.

_**Update June 7, 2009:** Removed installation instructions for the patch and
added the following section regarding the Media: Viddler module._

As of May 3, 2009, my submitted patch has been moved into the
[Media: Viddler](http://drupal.org/project/media_viddler) module. This module
will add Viddler support to the emfield module. I have CVS access to this module
and will be monitoring the issue queue.
