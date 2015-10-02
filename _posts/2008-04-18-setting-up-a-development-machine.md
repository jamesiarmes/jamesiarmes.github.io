---
layout: post
title: Setting Up A Development Machine
created: 1208563339
---
&nbsp;&nbsp;&nbsp;&nbsp;So I just finished setting up my PC to be a development machine. I need some more RAM for it to be truly what I need, but it will have to do for now. I though I would post a quick tutorial to how I set up my machine.

&nbsp;&nbsp;&nbsp;&nbsp;First, I should list my specifications.
<ul>
 <li><strong>CPU:</strong> AMD 64 3400+</li>
 <li><strong>RAM:</strong> 512MB PC4000</li>
 <li><strong>Storage:</strong> 500 GB SATA</li>
 <li><strong>Operating Systems:</strong> Windows XP x64 Edition, Kubuntu 7.10 AMD64</li>
 <li><strong>Video Card:</strong> Nvidia GeForce 4 Ti 4600</li>
</ul>
I have 80 GB dedicated to Windows, just for testing and using the few applications that I have not been able to replace in Linux. My development system has been setup on my primary partition, which contains the Kubuntu install.

<strong>Installing MySQL, Apache, and PHP:</strong>
Open up a command prompt, I use Konsole. After the first sudo command, you will be prompted for your password

<pre class="brush: bash; toolbar: false;">
$ sudo apt-get install mysql-client-5.0 mysql-server-5.0
$ sudo apt-get install apache2 apache2.2-common apache2-doc apache2-mpm-prefork apache2-utils libapr1 libexpat1 ssl-cert
$ sudo apt-get install autoconf automake1.9 autotools-dev libapache2-mod-php5 php5 php5-common php5-curl php5-dev php5-gd php-pear php5-ldap php5-mhash php5-mysql php5-snmp php-sqlite3 php5-xmlrpc php5-xsl php5-imap php5-mcrypt php5-pspell
$ sudo vim /etc/apache2/apache2.conf
</pre>

Locate DirectoryIndex in your Apache Config by typing /DirectoryIndex into vim. If it does not exist, you can add it. It should look something like this (Note, to start editing in vim, press "Insert" or "I":
<pre class="brush: bash; toolbar: false;">
DirectoryIndex index.html index.htm index.shtml index.php
</pre>
Now save and exit the Apache config file by pressing "Esc" followed by "Ctrl"+"X". If you have not modified the file you can just quit using "Ctrl"+"Q".

<pre class="brush: bash; toolbar: false;">
$ sudo vim /etc/apache2/ports.conf
</pre>

Your Apache ports config should contain 443 if you want to enable SSL. It may look something like this:
<pre class="brush: bash; toolbar: false;">
<ifmodule mod_ssl.c="">
 Listen 443
</ifmodule>
</pre>
If you modified your Apache ports config, make sure you save it before closing. 

<pre class="brush: bash; toolbar: false;">
$ sudo a2enmod ssl
$ sudo a2enmod rewrite
$ sudo a2enmod suexec
$ sudo a2enmod include
$ sudo /etc/init.d/apache2 force-reload
</pre>

Now you're good to go. Your default server root is /var/www, but you can change this in the Apache config.
