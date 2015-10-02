---
layout: post
title: Debugging With Xdebug
created: 1208933667
---
&nbsp;&nbsp;&nbsp;&nbsp;Xdebug is an amazing extension for PHP.  It makes debugging your websites and web applications much easier.  Let's take a look some debug before install Xdebug.

First, let's use var_dump() on a variable that happens to be an array:

<code language="php">var_dump($response);</code>

This produces the following output:
<code>
array(1) { ["Response"]=>  array(4) { ["TransactionReference"]=>  array(1) { ["XpciVersion"]=>  string(6) "1.0001" } ["ResponseStatusCode"]=>  string(1) "0" ["ResponseStatusDescription"]=>  string(7) "Failure" ["Error"]=>  array(4) { ["ErrorSeverity"]=>  string(4) "Hard" ["ErrorCode"]=>  string(5) "10002" ["ErrorDescription"]=>  string(61) "The XML document is well formed but the document is not valid" ["ErrorLocation"]=>  array(1) { ["ErrorLocationElementName"]=>  string(37) "TimeInTransitRequest/InvoiceLineTotal" } } } }
</code>
Now, let's cause a PHP Error (Notice the missing semicolon).

<pre class="brush: php; toolbar: false;">
var_dump($response)
</pre>

This produces the following output:
<pre class="brush: php; toolbar: false;">
Parse error: syntax error, unexpected '}' in /usr/dev/workspace/ups_api/tests/time_in_transit_test.php on line 57
</pre>

As you can see, the output of the previous examples can make debugging difficult.  In the first example, the output is very difficult to read.  If the array contained more elements, this could be nearly impossible to find the data that you require.

Now, let's look at these examples with xdebug installed.

<pre class="brush: php; toolbar: false;">
var_dump($response);
</pre>

Will now reproduce the following output:
<pre dir="ltr">
<b>array</b>
  'Response' <font color="#888a85">=&gt;</font> 
    <b>array</b>
      'TransactionReference' <font color="#888a85">=&gt;</font> 
        <b>array</b>
          'XpciVersion' <font color="#888a85">=&gt;</font> <small>string</small> <font color="#cc0000">'1.0001'</font> <i>(length=6)</i>
      'ResponseStatusCode' <font color="#888a85">=&gt;</font> <small>string</small> <font color="#cc0000">'0'</font> <i>(length=1)</i>
      'ResponseStatusDescription' <font color="#888a85">=&gt;</font> <small>string</small> <font color="#cc0000">'Failure'</font> <i>(length=7)</i>
      'Error' <font color="#888a85">=&gt;</font> 
        <b>array</b>
          'ErrorSeverity' <font color="#888a85">=&gt;</font> <small>string</small> <font color="#cc0000">'Hard'</font> <i>(length=4)</i>
          'ErrorCode' <font color="#888a85">=&gt;</font> <small>string</small> <font color="#cc0000">'10002'</font> <i>(length=5)</i>
          'ErrorDescription' <font color="#888a85">=&gt;</font> <small>string</small> <font color="#cc0000">'The XML document is well formed but the document is not valid'</font> <i>(length=61)</i>
          'ErrorLocation' <font color="#888a85">=&gt;</font> 
            <b>array</b>
              'ErrorLocationElementName' <font color="#888a85">=&gt;</font> <small>string</small> <font color="#cc0000">'TimeInTransitRequest/InvoiceLineTotal'</font> <i>(length=37)</i>
</pre>

Now, let's cause a PHP Error again.

<pre class="brush: php; toolbar: false;">
var_dump($response)
</pre>

This now produces the following output:
<table dir="ltr" border="1" cellspacing="0" cellpadding="1"><tbody>
<tr>
    <th style="background: #f57900; text-align: left;"' colspan="5">
        <span style="background-color: #cc0000; color: #fce94f; font-size: x-large;">( ! )</span> Parse error: syntax error, unexpected '}' in /usr/dev/workspace/ups_api/tests/time_in_transit_test.php on line <i>57</i>
    </th>
</tr>
</tbody></table>

<strong>Installing Xdebug On Kubuntu 7.10:</strong>
These instructions are specifically written for Kubuntu 7.10 Gutsy Gibbon. However, they should work for any Linux distrobution as long as the php-pear package is installed.

First, let's install the php-pear package, if it is not already.
<pre class="brush: bash; toolbar: false;">
$ sudo apt-get install php-pear
</pre>

Now it's time to install xdebug.
<pre class="brush: bash; toolbar: false;">
$ sudo pecl install xdebug-beta
</pre>

Now we need to add the extension and some settings in the PHP configuration files.  Open php.ini in your favorite text editor as root.  I prefer vim, but any editor will do.  Just add the lines below, you may have to modify the path to your xdebug extension.
<pre class="brush: bash; toolbar: false;">
$ sudo vim /etc/php5/apache2/php.ini

; Add the following lines to configure xdebug
zend_extension=/usr/lib/php5/20060613/xdebug.so

; xdebug settings
xdebug.var_display_max_children = 128
xdebug.var_display_max_data = 1024
xdebug.var_display_max_depth = 16
</pre>

&nbsp;&nbsp;&nbsp;&nbsp;It really that simple.  Now you can easily debug your web sites and web applications.  For more configuration options, view the xdebug documentation at <a href="http://xdebug.org/docs/">http://xdebug.org/docs/</a>.
