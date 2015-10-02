---
layout: post
title: Drupal 6 Performance on GoDaddy
created: 1262820205
---
<div><img src="/sites/default/files/blog/drupal-6-performance-godaddy/goingdown.jpg" alt="Going Down" class="blog-image" /></div>
<p>&nbsp;&nbsp;&nbsp;&nbsp;I have been using Google's <a href="http://code.google.com/speed/page-speed/">Page Speed</a> tool to help improve the the load times of this site.  In doing so, I discovered that I never configured any of the performance settings provided by Drupal.  I also discovered that GoDaddy does not use mod_gzip or mod_deflate to compress the documents being requested.</p>
<h2>Drupal's Performance Settings</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Drupal comes prepackaged with performance tuning options.  These options include caching and CSS/JavaScript optimization.  By enabling these features, I saw a dramatic decrease in load times for Jimmy's Sandbox.  You can view the performance settings for your site at /admin/settings/performance.</p>
<h3>Caches</h3>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Drupal provides both a page cache and a block cache.  The page cache only affects anonymous users.  While enabled, it will cache pages so that it does not need to re-render them for each request.  When a page is updated, the cache is cleared.  There are three levels of page caching:
<ul>
  <li><strong>Disabled</strong>: No caching will occur and each request will have to wait for the page to be rendered.</li>
  <li><strong>Normal</strong>: Recommend for most sites and does not cause any side effects.</li>
  <li><strong>Aggressive </strong>: Skips the loading and unloading of all modules when serving a cached page.  This can cause side effects with modules that rely on this behavior (ie. Statistics).  If you visit the performance settings of your site, you will be notified of any modules that are incompatible with aggressive caching (see below).</li>
</ul>
<img src="/sites/default/files/blog/drupal-6-performance-godaddy/aggressive-cache-incompat.png" alt="Aggressive Cache Incompatibilities" />
</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Drupal also allows you to provide a minimum cache lifetime.  This will prevent the cache for both pages and blocks from being cleared before that time.  The available options range from one minute to one day.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;The page compression option will allow Drupal to compress cached pages as they are sent to the browser.  This saves on bandwidth and can provide quite a performance boost for larger pages.  Since HTML is text, it compresses quite well.  Enabling this option helps to mitigate the fact that GoDaddy does not have any compression of their own.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Unlike the page cache, the block cache can provide a performance boost to all users. The block cache is similar to the page cache in that it prevents individual blocks from having to be rendered on each page load.  If you have any modules that define content access restrictions, such as Node Privacy By Role, this setting cannot be enabled.  I have several blocks on that provide dynamic content and have not run into any issues by enabling the block cache.</p>
<h3>CSS/JavaScript Optimizations</h3>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Drupal's CSS and JavaScript optimizations are really quite simple.  When enabled, they combine all JavaScript into a single file and all CSS into a single file.  Both files are then cached and the CSS file is compressed.  If you have not created your files directory, or have configured your files to be private, these options cannot be enabled.</p>
<h2>Google Analytics Optimizations</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If you are using the <a href="http://drupal.org/project/google_analytics">Google Analytics</a> module by budda, you can cache the JavaScript file that is normally stored on Google's servers.  This prevents the browser from having to perform an additional DNS lookup.  The cache is updated once a day and can be enabled from the "Advanced settings" field group at /admin/settings/googleanalytics.  It is important that you wait until Google has validated your site before enabling this option.</p>
<h2>JavaScript Compression</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Unlike the CSS cache, cached JavaScript is not compressed.  To get around this, I use the <a href="http://drupal.org/project/smartcache">SmartCache</a> module.  The module requires your Apache server to have mod_rewrite enabled to redirect requests for all JavaScript and CSS files to a script provided by the module.  When a file is requested, the script creates a compressed version of the file and serves that up instead of the plain text version.  The compressed file is then cached</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;This requires some manual setup to get working.  There is no .info file so Drupal will not recognize it as an actual module, but that's okay since the module doesn't actually interact with Drupal.  There are some configuration options in the load.php file that need setup and a line will need to be added to you .htaccess file.  To clear the cache before the next scheduled cache clear, just clear the files out of the cache directory.  Basically just read the README.txt file that comes packaged with the module and you will be fine.</p>
<h2>What Performance Tips Do You Have?</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;That's just a quick run through of the performance improvements I have used here on Jimmy's Sandbox.  The are certainly other options out there, such as minifying JavaScript.  So what do you use to improve performance on your site?  Let us know by leaving a comment below.  While you're at it, while not subscribe to the Jimmy's Sandbox <a href="/blog/feed">feed</a> and be notified of new posts that may include other performance improvements.</p>
