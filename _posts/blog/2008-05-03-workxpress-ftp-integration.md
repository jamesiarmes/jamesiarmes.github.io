---
layout: post
title: WorkXpress FTP Integration
category: blog
created: 1209832441
tags:
  - FTP
  - Linux
  - WorkXpress
---
After some configuration issues, I completed the server setup for the WorkXpress
FTP Integration this week. Most of the issues were with the FTP Server. There
was also a minor vhost issue with Apache.

<!--more-->

### What is the WorkXpress FTP Integration?
The WorkXpress FTP Integrations allows users of
[WorkXpress](http://www.workxpress.com) to add and modify users of an FTP
Server. Files uploaded to the FTP Server can then be viewed inside of
WorkXpress. Files can also be added through WorkXpress that would appear to FTP
users.

The FTP Integration also includes a Quick Upload page. This page displays a
login screen for WorkXpress on the left and a file upload section on the right.
The file upload section contains Fields for Company Name, Full Name, Phone
Number, Email Address, and five File Upload Fields. The data Fields are used for
the log file in the Quick Upload Field.

{% include image-caption.html url="/assets/images/2008/05/quick_upload.png" description="FTP Integration Quick Upload" %}

### Issues & Solutions
The Apache issue was quite simple. There are two copies of the integration on
the server. The first copy, ftp.example.com, is used to integrate with the
production application. The second copy, ftpqa.example.com, is used to integrate
with the QA (testing) application. The problem was when browsing to the QA
Integration, the Production Integration was returned instead. Adding
"NameVirtualHost *:80" to the apache2.conf file took care of this.

The FTP issues were a little harder to track down. The first issues was allowing
multiple instances of vsftpd to run on different ports. All of the tutorials
that I found while searching the Internet involved a different IP Address for
each instance. After some more research, i discovered the "listen_port" option
for vsftpd.conf.

I setup two different configuration files, vsftpd.conf and vsftpd.qa.conf. I
added the following lines to the files:

{% highlight text %}
# vsftpd.conf
listen_port=21

# vsftpd.qa.conf
listen_port=8021
{% endhighlight %}

I then started the multiple instances using the following:

{% highlight console %}
$ sudo vsftpd /etc/vsftpd.conf &
[1] 6898
$ sudo vsftpd /etc/vsftpd.qa.conf &
[2] 6899
{% endhighlight %}

The second FTP issue dealt with user navigation. Currently, the home path for
users is /home/ftp/[Company Name] and /home/ftpqa/[Company Name]. The problem
was that a user from Company A could go back up the tree and modify files from
Company B. After a lot of research, I discovered the "chroot_local_user"
configuration option for vsftpd. This option locks users into their home
directory and its contents. I added the following line to both vsftpd.conf and
vsftpd.qa.conf:

{% highlight text %}
chroot_local_user=Yes
{% endhighlight %}
