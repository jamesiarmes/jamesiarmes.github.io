---
layout: post
title: PHP Image Benchmarks, GD Vs. Image Magick
created: 1237776265
---
&nbsp;&nbsp;&nbsp; Earlier this week I ran into an issue resizing bitmap images inside of WorkXpress.  We currently use <a href="http://us3.php.net/manual/en/book.image.php">GD</a> for our image resizing needs.  Unknown to us, GD has plenty of issues resizing bitmaps, and all of our bitmap files we becoming corrupted.  I modified our resize code to use <a href="http://us3.php.net/imagick">Image Magick</a> if the image is a bitmap and continue using GD for other image types.  The next step of course is to do some research and testing to see if we should switch over to Image Magick completely, leaving GD behind.

&nbsp;&nbsp;&nbsp; After doing some research, I found plenty of claims that GD is faster than Image Magick.  But how much faster?  I was on a quest to find out.  I took a rather large jpeg image (3504 x 2336 pixels) and converted it to three other popular formats, png, gif, and bitmap.  I then wrote a script that resizes each one to 300 x 200 pixels (png shown below) using both GD and Image Magick.  The script performs each resize 100 times and prints out the averages.  I wanted to provide a working link to each format's resize code in action, but GoDaddy does not support Image Magick.  The benchmark results were quite interesting, as seen below (results are in seconds).

<img src="/sites/default/files/blog/imagebenchmark/tugofwar_thumb.png" alt="Resized PNG" />

<strong>PNG</strong>
GD: 0.572078313828
Image Magick: 0.851119382381

<strong>JPEG</strong>
GD: 0.524123055935
Image Magick: 0.873931562901

<strong>GIF</strong>
GD: 0.497557456493
Image Magick: 1.15288033009

<strong>Bitmap</strong>
GD: 0.00230557203293 <i>(Image Corrupted)</i>
Image Magick: 0.523070528507

As you can see, GD out performed Image Magick by 48-131%, not including the bitmap results.  So it looks like we'll be sticking with GD for now, with the exception of bitmaps.
