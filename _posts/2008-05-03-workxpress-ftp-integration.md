---
layout: post
title: WorkXpress FTP Integration
created: 1209832441
---
&nbsp;&nbsp;&nbsp;&nbsp;After some configuration issues, I completed the server setup for the WorkXpress FTP Integration this week.  Most of the issues were with the FTP Server.  There was also a minor vhost issue with Apache.
<strong>What is the WorkXpress FTP Integration?</strong>
&nbsp;&nbsp;&nbsp;&nbsp;The WorkXpress FTP Integrations allows users of <a href="http://www.workxpress.com">WorkXpress</a> to add and modify users of an FTP Server.  Files uploaded to the FTP Server can then be viewed inside of WorkXpress.  Files can also be added through WorkXpress that would appear to FTP users.

&nbsp;&nbsp;&nbsp;&nbsp;The FTP Integration also includes a Quick Upload page.  This page displays a login screen for WorkXpress on the left and a file upload section on the right.  The file upload section contains Fields for Company Name, Full Name, Phone Number, Email Address, and five File Upload Fields.  The data Fields are used for the log file in the Quick Upload Field.

<strong>FTP Integration Quick Upload</strong>
<a href="/sites/default/files/blog/quick_upload.png" rel="lightbox">
<img src="/sites/default/files/blog/quick_upload_thumb.png" alt="Quick Upload" title="Click for full size" border="0" /></a>

<strong>Issues &amp; Solutions</strong>
&nbsp;&nbsp;&nbsp;&nbsp;The Apache issue was quite simple.  There are two copies of the integration on the server.  The first copy, ftp.[Customer].com, is used to integrate with the production application.  The second copy, ftpqa.[Customer].com, is used to integrate with the QA (testing) application.  The problem was when browsing to the QA Integration, the Production Integration was returned instead.  Adding "NameVirtualHost *:80" to the apache2.conf file took care of this.

&nbsp;&nbsp;&nbsp;&nbsp;The FTP issues were a little harder to track down.  The first issues was allowing multiple instances of vsftpd to run on different ports.  All of the tutorials that I found while searching the Internet involved a different IP Address for each instance.  After some more research, i discovered the "listen_port" option for vsftpd.conf.

&nbsp;&nbsp;&nbsp;&nbsp;I setup two different configuration files, vsftpd.conf and vsftpd.qa.conf.  I added the following lines to the files:
<pre class="brush: bash; toolbar: false;">
# vsftpd.conf
listen_port=21

# vsftpd.qa.conf
listen_port=8021
</pre>
I then started the multiple instances using the following:
<pre class="brush: bash; toolbar: false;">
$ sudo vsftpd /etc/vsftpd.conf &
[1] 6898
$ sudo vsftpd /etc/vsftpd.qa.conf &
[2] 6899
</pre>

&nbsp;&nbsp;&nbsp;&nbsp;The second FTP issue dealt with user navigation.  Currently, the home path for users is /home/ftp/[Company Name] and /home/ftpqa/[Company Name].  The problem was that a user from Company A could go back up the tree and modify files from Company B.  After a lot of research, I discovered the "chroot_local_user" configuration option for vsftpd.  This option locks users into their home directory and its contents.  I added the following line to both vsftpd.conf and vsftpd.qa.conf:
<pre class="brush: bash; toolbar: false;">
chroot_local_user=Yes
</pre>
