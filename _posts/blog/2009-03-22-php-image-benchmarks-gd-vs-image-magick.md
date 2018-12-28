---
layout: post
title: PHP Image Benchmarks, GD Vs. Image Magick
category: blog
section-type: post
created: 1237776265
tags:
  - Benchmark
  - Images
  - PHP
---
Earlier this week I ran into an issue resizing bitmap images inside of
WorkXpress. We currently use [GD](http://us3.php.net/manual/en/book.image.php)
for our image resizing needs. Unknown to us, GD has plenty of issues resizing
bitmaps, and all of our bitmap files we becoming corrupted. I modified our
resize code to use [Image Magick](http://us3.php.net/imagick) if the image is a
bitmap and continue using GD for other image types. The next step of course is
to do some research and testing to see if we should switch over to Image Magick
completely, leaving GD behind.

<!--more-->

After doing some research, I found plenty of claims that GD is faster than Image
Magick. But how much faster?  I was on a quest to find out. I took a rather
large jpeg image (3504 x 2336 pixels) and converted it to three other popular
formats, png, gif, and bitmap. I then wrote a script that resizes each one to
300 x 200 pixels (png shown below) using both GD and Image Magick. The script
performs each resize 100 times and prints out the averages. I wanted to provide
a working link to each format's resize code in action, but GoDaddy does not
support Image Magick. The benchmark results were quite interesting, as seen
below (results are in seconds).

![Resized PNG](/img/blog/2009/03/tugofwar.png)

**PNG**<br />
GD: 0.572078313828<br />
Image Magick: 0.851119382381

**JPEG**<br />
GD: 0.524123055935<br />
Image Magick: 0.873931562901

**GIF**<br />
GD: 0.497557456493<br />
Image Magick: 1.15288033009

**Bitmap**<br />
GD: 0.00230557203293 _(Image Corrupted)_<br />
Image Magick: 0.523070528507

As you can see, GD out performed Image Magick by 48-131%, excluding the bitmap
results. So it looks like we'll be sticking with GD for now, with the exception
of bitmaps.
