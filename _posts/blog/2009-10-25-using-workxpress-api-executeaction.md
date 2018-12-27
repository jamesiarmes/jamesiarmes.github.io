---
layout: post
title: 'Using the WorkXpress API: ExecuteAction'
category: blog
created: 1256602701
tags:
  - API
  - PHP
  - SOAP
  - Web Services
  - WorkXpress
---
[![WorkXpress](/img/blog/workxpress-logo.png){: .post-image .image-right }](http://www.workxpress.com)
Earlier I introduced you to the
[WorkXpress API]({% post_url /blog/2009-07-16-introducing-workxpress-api %}). If
you have not read it already you should do so before reading this post. Once you
have a basic understanding of what it is and how it works, it's time to start
diving into the API.

<!--more-->

This post will cover how to run specfic Actions on specific Items. You can find
the id of an Action at the end of its description in the Event Manager (see
below). Like the other functions, you can make many ExecuteAction requests in
one call using data sets.

{% include image-caption.html url="/img/blog/2009/10/workxpress_action_id.png" description="WorkXpress Event Manager" %}

### Request XML
First, let's get an understanding of how the request XML should be formed.

<table class="workxpress-table">
	<thead>
		<tr>
			<th>Element</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>/wxRequest</td>
			<td>The root node for all request documents.</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet</td>
			<td>
			  Contains a single ExecuteAction request. You may have as many data sets
			  as you would like.
			  <br /><br />
			  <em>Attributes:</em>
			  <ul>
			    <li>
			      reference (string): An identifier that will be returned in the
			      response document to distinguish between different data sets. If
			      this attribute is left blank, a random string will be generated.
			    </li>
			  </ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/items</td>
			<td>Root node for the items that the Action(s) should be run on.</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/items/item</td>
			<td>
			  A single item to execute the action on. There is no limit to the numbe
			  of item nodes allowed in a data set.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
				  <li>
				    itemId (string): The item id of the item to execute the action on.
				    Should be in the format u# (ie. u123).
				  </li>
				</ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/items/map</td>
			<td>The root node for a map definition.</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/items/map/definition</td>
			<td>
			  The actual definition for a map. The map XML must have its HTML entities
			  encoded.
      </td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/actions</td>
			<td>Root node for the Actions to be executed.</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/actions/action</td>
			<td>
			  A single Action to be executed on the Items defined above. There is no
			  limit to the number of action nodes allowed in a data set.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
				  <li>
				    actionId (string): Id of a single Action to run. Should be in the
				    format a# (ie. a123).
				  </li>
				</ul>
			</td>
		</tr>
	</tbody>
</table>

### Response XML
Now let's get an understanding of how the response XML will be formed.

<table class="workxpress-table">
	<thead>
		<tr>
			<th>Element</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>/wxResponse</td>
			<td>The root node for all response documents.</td>
		</tr>
		<tr>
			<td>/wxRequest/callStatus</td>
			<td>
			  The status of the SOAP call as it was processed by WorkXpress.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
				  <li>
				    status (string): The call's status. Values include success and
				    failure.
				  </li>
				</ul>
			</td>
		</tr>
		<tr>
			<td>/wxResponse/compatibilityLevel</td>
			<td>The version of the API that was used to process the request.</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet</td>
			<td>
			  One data set is returned for each data set in the request document.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
				  <li>
				    reference (string): The identifier that was assigned to the data set
				    in the request.
				  </li>
				</ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/item</td>
			<td>
			  Defines an item that the Action(s) was executed on. One item node is
			  returned for each item that an Action was run on.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
				  <li>
				    itemId (string): Id of the item, in the format u# (ie. u123).
				  </li>
				</ul>
			</td>
		</tr>
	</tbody>
</table>

### Examples
Below is an example of a basic ExecuteAction request document:

{% highlight xml %}
<wxrequest>
  <dataset reference="accounts">
    <items>
      <item itemid="u3541"></item>
      <item itemid="u511"></item>
    </items>
    <actions>
      <action actionid="a314558"></action>
    </actions>
  </dataset>
</wxrequest>
{% endhighlight %}

Below is the corresponding response document for the above example:

{% highlight xml %}
<wxresponse>
  <callstatus status="success"></callstatus>
  <compatibilitylevel>1</compatibilitylevel>
  <dataset reference="accounts">
    <item itemid="u3541"></item>
    <item itemid="u511"></item>
  </dataset>
</wxresponse>
{% endhighlight %}

If you have any questions or would like assistance making some ExecuteAction
requests of your own, please feel free to comment below. My next post will be on
some more advanced concepts such as display formats and stored values.
