---
layout: post
title: Sending Mail In PHP Through SMTP
category: blog
section-type: post
created: 1226791387
tags:
  - Mail
  - PEAR
  - PHP
  - SMTP
---
Sending mail is a common task for many applications today. Whether sending mail
through a webform or as an automated tasks, sending mail can be simple using PHP
and PEAR. Using the sendMail() function below, you can send HTML formatted mail
through any smtp server.

<!--more-->

_**Update March 11, 2009:** Removed the demo since GoDaddy does not support
external SMTP servers._
_**Update July 06, 2009:** Updated variables for the usage example to be less
confusing. Thanks to David for pointing this out._

This function requires the following [PEAR](http://pear.php.net) classes along
any of their dependencies.

* [Mail](http://pear.php.net/package/Mail)
* [Mail_Mime](http://pear.php.net/package/Mail_Mime)
* [Net_SMTP](http://pear.php.net/package/Net_SMTP)

This function assumes that you have your pear include path set correctly. You
can download the function [here](/sites/default/files/blog/sendmail.php) (right
click -> Save Link As) or copy the code from below. Scroll down for some
examples/documentation.

{% highlight php startinline %}
/**
 * Sends mail by connecting to an smtp server
 * 
 * @param string $subject
 * @param string $smtp_server
 * @param string $smtp_username
 * @param string $smtp_password
 * @param string $html html portion of the message body
 * @param string $text text portion of the message body
 * @param string|array $to
 * @param string $from
 * @param array $cc
 * @param array $bcc
 * @return boolean|string
 */
function sendMail($subject, $smtp_server, $smtp_username, $smtp_password,
    $html, $text, $to, $from, $cc = array(), $bcc = array()) {
    // require pear classes
    require_once 'Mail.php';
    require_once 'Mail/mime.php';
    
    // create the heaers
    $to = is_array($to) ? $to : explode(',', $to);
    $headers = array(
        'Subject' => $subject,
        'From' => $from,
        'To' => implode(',', $to),
    ); // end $headers
    
    // create the message
    $mime = new Mail_mime("\n");
    $mime->addCc(implode(',', $cc));
    $mime->addBcc(implode(',', $bcc));
    $mime->setTXTBody($text);
    $mime->setHTMLBody($html);
    
    // always call these methods in this order
    $body = $mime->get();
    $headers = $mime->headers($headers);
    
    // create the smtp mail object
    $smtp_params = array(
        'host' => $smtp_server,
        'auth' => true,
        'username' => $smtp_username,
        'password' => $smtp_password,
        'timeout' => 20,
        'localhost' => $_SERVER['SERVER_NAME'],
    ); // end $smtp_params
    $smtp = Mail::factory('smtp', $smtp_params);
    
    // send the message
    $recipients = array_merge($to, $cc, $bcc);
    $mail = $smtp->send($recipients, $headers, $body);
    
    // check to make sure there was no error
    if (PEAR::isError($mail)) {
        return $mail->getMessage();
    } // end if there was an error
    
    return true;
}
{% endhighlight %}

Using this function is simple. Simply pass in the parameters as described below:

* $subject (required): Subject for the email message.
* $smtp_server (required): SMTP Server host (ie. smtp.hostname.com).
* $smtp_username (required): SMTP username.
* $smtp_password (required): SMTP password.
* $html (required): HTML version of the message body.
* $text (required): Text version of the message body.
* $to (required): String or array of email address to send the message to
(string may be comma separated list).
* $from (required): Email address that the email is being sent from.
* $cc (optional): Array of Cc email addresses.
* $bcc (optional): Array of Bcc email addresses.

For example:
{% highlight php startinline %}
// set all of the parameters
$subject = 'This is an HTML email.';
$smtp_server = 'smtp.hostname.com';
$from = $smtp_username = 'user@hostname.com';
$smtp_password = 'password';
$html = 'This is an <strong>HTML</strong> <i>formatted</i> email!';
$text = strip_tags($html);
$to = 'email@example.com';
$cc = array('foo@example.com');
$bcc  array('bar@example.com', 'baz@example.com');

// send the message
$result = sendMail($subject, $smtp_server, $smtp_username, $smtp_password, $html, $text, $to, $cc, $bcc);

// check to see if the message was sent properly
if ($result !== true) {
    echo 'There was an error sending the message. ('.$result.')';
} // end if the message was not sent properly
else {
    echo 'Message sent successfully.';
} // end else the message was sent properly
{% endhighlight %}
