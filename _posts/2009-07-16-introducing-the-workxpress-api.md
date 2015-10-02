---
layout: post
title: Introducing the WorkXpress API
created: 1247735339
---
<p><a href="http://www.workxpress.com"><img src="/sites/default/files/blog/workxpress-logo.png" style="float: right;"></a>&nbsp;&nbsp;&nbsp;&nbsp;I recently finished documenting the <a href="http://www.workxpress.com">WorkXpress</a> API and thought I would share some of the details.  First of all, the documentation can be downloaded at <a href="http://www.workxpress.com/sites/default/files/WorkXpress%20API_1.pdf">http://www.workxpress.com/sites/default/files/WorkXpress%20API_1.pdf</a> (PDF).  For PHP, there is a PEAR package that makes working with the API easier.  Look for that in a later post.</p>
<h3><strong>Available Functions</strong></h3>
<p>
&nbsp;&nbsp;&nbsp;&nbsp;The WorkXpress API provides four different SOAP calls that allow access to four of the five building blocks (there is no way to interact with Layouts through the API).
    <ul>
        <li>
            <strong>LookupData:</strong> Allows you to lookup existing Items and Relations inside of the application.  Can be used to retrieve Field data and Item/Relation ids.
        </li>
        <li>
            <strong>AddItem:</strong> Allows you to add new Items/Relations to the application.  You can set Fields on the Items/Relations while adding them.
        </li>
        <li>
            <strong>UpdateItem:</strong> Allows you to update existing Items/Relations inside of the Application.
        </li>
        <li>
            <strong>ExecuteAction:</strong> Allows you to execute specific Actions on existing Items/Relations inside of the application.
        </li>
    </ul>
</p>
<h3><strong>Creating Your Authentication Key</strong></h3>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Before using the API, you need to create an authentication key.  You will need a seperate key for each role of your application.  In your project, you can click on the "Tools" tab of the Block Creator (see below) where you will find the "Create Auth Key" Link.  On testing and production applications, you can visit http://example.workxpress.com/im_tools/create_auth_key.php to create your keys.
<div style="text-align: center;">
<a href="/sites/default/files/blog/wxapi/tools_tab.png" rel="lightbox" title="Tools Tab of the WorkXpress Block Creator"><img src="/sites/default/files/blog/wxapi/tools_tab.thumb.png" alt="Tools Tab of the WorkXpress Block Creator" /></a>
<strong>Tools Tab of the WorkXpress Block Creator</strong>
</div>
</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Once the page has loaded, you will be presented with two fields used to generate the key.  The first is the user that the key should be associated with.  When using the API, this user will be the "current user" for the session.  The second field is the password for the selected user.  This allows the API to log in as that user.  After hitting the "Save" button, the page will reload and the Auth Key field will contain your authentication key.
<div style="text-align: center;">
<a href="/sites/default/files/blog/wxapi/create_auth_key.png" rel="lightbox" title="Creating a WorkXpress Auth Key"><img src="/sites/default/files/blog/wxapi/create_auth_key.thumb.png" alt="Create Auth Key" /></a>
<strong>Creating a WorkXpress Auth Key</strong>
</div>
</p>
<h3><strong>Connecting To Your Application</strong></h3>
<p>
&nbsp;&nbsp;&nbsp;&nbsp;To connect to your WorkXpress application, you will need to point your SOAP client at http://example.workxpress.com/api/api.php?wsdl.  In PHP, you would pass this in as the first parameter to <a href="http://us.php.net/manual/en/soapclient.soapclient.php">SoapClient::__construct()</a>.
<pre class="brush: php; toolbar: false; auto-links: false;">
$soap = new SoapClient('http://example.workxpress.com/api/api.php?wsdl');
var_dump($soap->__getFunctions());
$response = $soap->UpdateItem(1, $auth_code, $xml);
</pre>
&nbsp;&nbsp;&nbsp;&nbsp;In Java, you would pass this URL to the wsimport function on the command line.  This will produce two files that will allow you to connect to your application: com\workxpress\workxpressapi\WorkXpressAPIPortType.java and com\workxpress\workxpressapi\WorkXpressAPIService.java.
<pre class="brush: bash; toolbar: false;">
$ wsimport -verbose -keep http://fsip.workxpress.com/api/api.php?wsdl
</pre>
</p>
<h3><strong>Building Maps</strong></h3>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Maps are available for three out of the four available functions (AddItem does not use a map).  Maps allow you to search for Items within the application instead of having to know the item ids.  Maps are XML strings that will need to have any HTML entities encoded (for PHP see <a href="http://us.php.net/manual/en/function.htmlentities.php">htmlentities</a>).
</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;To make generating maps easier, WorkXpress has created a map builder tool.  To access the tool, log into your project and click on the "Tools" tab of the Block Creator (see above) where you will find the "Build Maps For API Calls" link.
</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;The map builder functions like a normal WorkXpress query builder.  You can jump across relations, filter on field values, etc.  However, after making modifications to the map, there are two text areas that update with the XML version of the map.  The first text area contains the human readable XML.  The second text area contains the encoded XML, this is the value that will need to be placed into the XML for your API call.
<div style="text-align: center;">
<a href="/sites/default/files/blog/wxapi/map_builder.png" rel="lightbox" title="WorkXpress Map Builder"><img src="/sites/default/files/blog/wxapi/map_builder.thumb.png" alt="WorkXpress Map Builder" /></a>
<strong>WorkXpress Map Builder</strong>
</div>
</p>
<h3><strong>More To Come</strong></h3>
<p>&nbsp;&nbsp;&nbsp;&nbsp;The WorkXpress API allows for some very complex interactions with WorkXpress.  For this reason, I am splitting this post into several smaller post.  In my next post, I will cover the LookupData function.  To ensure that you catch the post as soon as it is up, subscribe to the <a href="/blog/feed">Jimmy's Sandbox RSS feed</a>.</p>
