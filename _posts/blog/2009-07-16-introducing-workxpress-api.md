---
layout: post
title: Introducing the WorkXpress API
category: blog
redirect_from:
  - /blog/2009/08/introducing-workxpress-api/
created: 1247735339
tags:
  - API
  - PHP
  - Java
  - SOAP
  - Web Services
  - WorkXpress
---
[![WorkXpress](/img/blog/workxpress-logo.png){: .post-image .image-right }](http://www.workxpress.com)
I recently finished documenting the [WorkXpress](http://www.workxpress.com) API
and thought I would share some of the details. First of all, the documentation
can be downloaded at
<http://www.workxpress.com/sites/default/files/WorkXpress%20API_1.pdf> (PDF).
For PHP, there is a PEAR package that makes working with the API easier. Look
for that in a later post.

<!--more-->

### Available Functions
The WorkXpress API provides four different SOAP calls that allow access to four
of the five building blocks (there is no way to interact with Layouts through
the API).

* **LookupData:** Allows you to lookup existing Items and Relations inside of
the application. Can be used to retrieve Field data and Item/Relation ids.
* **AddItem:** Allows you to add new Items/Relations to the application. You can set
Fields on the Items/Relations while adding them.
* **UpdateItem:** Allows you to update existing Items/Relations inside of the
Application.
* **ExecuteAction:** Allows you to execute specific Actions on existing
Items/Relations inside of the application.

### Creating Your Authentication Key
Before using the API, you need to create an authentication key. You will need a
separate key for each role of your application. In your project, you can click
on the "Tools" tab of the Block Creator (see below) where you will find the
"Create Auth Key" Link. On testing and production applications, you can visit
http://example.workxpress.com/im_tools/create_auth_key.php to create your keys.

{% include image-caption.html url="/img/blog/2009/07/tools_tab.png" description="Tools Tab of the WorkXpress Block Creator" %}

Once the page has loaded, you will be presented with two fields used to generate
the key. The first is the user that the key should be associated with. When
using the API, this user will be the "current user" for the session. The second
field is the password for the selected user. This allows the API to log in as
that user. After hitting the "Save" button, the page will reload and the Auth
Key field will contain your authentication key.

{% include image-caption.html url="/img/blog/2009/07/create_auth_key.png" description="Creating a WorkXpress Auth Key" %}

### Connecting To Your Application
To connect to your WorkXpress application, you will need to point your SOAP
client at http://example.workxpress.com/api/api.php?wsdl. In PHP, you would pass
this in as the first parameter to
[SoapClient::__construct()](http://us.php.net/manual/en/soapclient.soapclient.php)

{% highlight php startinline %}
$soap = new SoapClient('http://example.workxpress.com/api/api.php?wsdl');
var_dump($soap->__getFunctions());
$response = $soap->UpdateItem(1, $auth_code, $xml);
{% endhighlight %}

In Java, you would pass this URL to the wsimport function on the command line.
This will produce two files that will allow you to connect to your application:
com\workxpress\workxpressapi\WorkXpressAPIPortType.java and
com\workxpress\workxpressapi\WorkXpressAPIService.java.

{% highlight console %}
$ wsimport -verbose -keep http://fsip.workxpress.com/api/api.php?wsdl
{% endhighlight %}

### Building Maps
Maps are available for three out of the four available functions (AddItem does
not use a map). Maps allow you to search for Items within the application
instead of having to know the item ids. Maps are XML strings that will need to
have any HTML entities encoded (for PHP see
[htmlentities](http://us.php.net/manual/en/function.htmlentities.php).)

To make generating maps easier, WorkXpress has created a map builder tool.
To access the tool, log into your project and click on the "Tools" tab of the
Block Creator (see above) where you will find the "Build Maps For API Calls"
link.

The map builder functions like a normal WorkXpress query builder. You can jump
across relations, filter on field values, etc. However, after making
modifications to the map, there are two text areas that update with the XML
version of the map. The first text area contains the human readable XML. The
second text area contains the encoded XML, this is the value that will need to
be placed into the XML for your API call.

{% include image-caption.html url="/img/blog/2009/07/map_builder.png" description="WorkXpress Map Builder" %}

### More To Come
The WorkXpress API allows for some very complex interactions with WorkXpress.
For this reason, I am splitting this post into several smaller post. In my next
post, I will cover the LookupData function. To ensure that you catch the post as
soon as it is up, subscribe to the [feed](/blog/feed).
