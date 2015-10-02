---
layout: post
title: Sending Mail In PHP Through SMTP
created: 1226791387
---
&nbsp;&nbsp;&nbsp; Sending mail is a common task for many applications today.&nbsp; Whether sending mail through a webform or as an automated tasks, sending mail can be simple using PHP and PEAR.&nbsp; Using the sendMail() function below, you can send HTML formatted mail through any smtp server.

&nbsp;&nbsp;&nbsp; <i><strong>Update March 11, 2009:</strong> Removed the demo since GoDaddy does not support external SMTP servers.</i>
&nbsp;&nbsp;&nbsp; <i><strong>Update July 06, 2009:</strong> Updated variables for the usage example to be less confusing.&nbsp; Thanks to <a href="#comment-5">David</a> for pointing this out.</i>

&nbsp;&nbsp;&nbsp; This function requires the following <a href="http://pear.php.net">PEAR</a> classes: <a href="http://pear.php.net/package/Mail">Mail</a>, <a href="http://pear.php.net/package/Mail_Mime">Mail_Mime</a>, <a href="http://pear.php.net/package/Net_SMTP/">Net_SMTP</a> and any of their dependencies.&nbsp; This function assumes that you have your pear include path set correctly.&nbsp; You can download the function <a href="/sites/default/files/blog/sendmail.php" type="text/plain">here</a> (right click -> Save Link As) or copy the code from below.&nbsp; Scroll down for some examples/documentation.
<pre class="brush: php; toolbar: false;">
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
} // end function sendMail()
</pre>
&nbsp;&nbsp;&nbsp; Using this function is simple.&nbsp; Simply pass in the parameters as described below:
<ul>
    <li>$subject <strong>(required)</strong>: Subject for the email message.</li>
    <li>$smtp_server <strong>(required)</strong>: SMTP Server host (ie. smtp.hostname.com).</li>
    <li>$smtp_username <strong>(required)</strong>: SMTP username.</li>
    <li>$smtp_password <strong>(required)</strong>: SMTP password.</li>
    <li>$html <strong>(required)</strong>: HTML version of the message body.</li>
    <li>$text <strong>(required)</strong>: Text version of the message body.</li>
    <li>$to <strong>(required)</strong>: String or array of email address to send the message to (string may be comma separated list).</li>
    <li>$from <strong>(required)</strong>: Email address that the email is being sent from.</li>
    <li>$cc <strong>(optional)</strong>: Array of Cc email addresses.</li>
    <li>$bcc <strong>(optional)</strong>: Array of Bcc email addresses.</li>
</ul>
For example:
<pre class="brush: php; toolbar: false;">
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
</pre>
