---
layout: post
title: 'Using the WorkXpress API: AddItem'
category: blog
created: 1253837524
---
[![WorkXpress](/assets/images/workxpress-logo.png){: .post-image .image-right }](http://www.workxpress.com)
Earlier I introduced you to the
[WorkXpress API]({% post_url 2009-07-16-introducing-the-workxpress-api %}). If
you have not read it already you should do so before reading this post. Once you
have a basic understanding of what it is and how it works, it's time to start
diving into the API.

This post will cover how to add Items to a WorkXpress application using the
AddItem API function. AddItem allows you to set Fields and create Relationships
while adding the new Item. Like the LookupData function, you can make many
AddItem requests in one call using data sets.

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
			  Contains a single AddItem request. You may have as many data sets as you
			  would like.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
          <li>
            reference (string): An identifier that will be returned in the
            request document to distinguish between different data sets. If this
            attribute is left blank, a random string will be generated.
          </li>
        </ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/item</td>
			<td>
			  Used to specify the item type id of the new item.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
          <li>
            itemTypeId (string): The item type id of the new item. Should be in
            the format a# (ie. a123).
          </li>
        </ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/fields</td>
			<td>Root node for the fields that should be set on the new item.</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/fields/field</td>
			<td>
			  A single field to be set on the new item.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
          <li>
            fieldId (string): Id of the field to set. Should be in the format a#
            (ie. a123).
          </li>
        </ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/fields/field/value</td>
			<td>Value to set into the field.</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/relations</td>
			<td>
			  Root node for relations that should be created along with the new item.
      </td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/relations/relation</td>
			<td>
			  Defines a relation to be created.
			  <br /><br />
			  <em>Attributes:</em>
			  <ul>
          <li>
            action (string): The action to perform for this relation. This
            should always be set to "add" for AddItem requests.
          </li>
          <li>
            oppositeItemId (string): Id of the item on the opposite side of the
            relation. For example, if the item being created is an account and
            you want to relate it to a contact, this would be the id of the
            contact. Should be in the format u# (ie. u123).
          </li>
          <li>
            reference (string): An identifier that will be returned with the
            response to identify each relation.
          </li>
          <li>
            relationType (string): Relation type of the new relation. Should be
            in the format a# (ie. a123).
          </li>
          <li>
            startingSide (string): Defines which side of the relation that the
            item defined above should be on. Valid values are base and target.
          </li>
        </ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/relations/relation/fields</td>
			<td>Root node for the fields that should be set on the new relation.</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/relations/relation/fields/field</td>
			<td>
			  A single field to be set on the new relation.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
          <li>
            fieldId (string): Id of the field to set. Should be in the format a#
            (ie. a123).
          </li>
        </ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/relations/relation/fields/field/value</td>
			<td>Value to set into the field.</td>
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
			  Defines the item that was added to the WorkXpress application.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
          <li>
            itemId (string): Id of the item that was added, in the format u#
            (ie. u123).
          </li>
          <li>
            itemTypeId (string): Item type id of the item that was added, in the
            format a# (ie. a123).
          </li>
        </ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/item/relation</td>
			<td>
			  Defines a relation that was added to the WorkXpress application.
			  <br /><br />
			  <em>Attributes:</em>
			  <ul>
          <li>
            reference (string): The identifier of the relation that was assigned
            to the relation in the request.
          </li>
          <li>
            relationId (string): Id of the relation that was added, in the
            format u# (ie. u123).
          </li>
        </ul>
			</td>
		</tr>
	</tbody>
</table>

### Examples
Below is an example of a basic AddItem request document:

{% highlight xml %}
<wxrequest>
  <dataset reference="workxpress">
    <item itemtypeid="a35234"></item>
    <fields>
      <field fieldid="a66969">
        <value>WorkXpress</value>
      </field>
      <field fieldid="a36314">
        <value>http://www.workxpress.com</value>
      </field>
    </fields>
    <relations>
      <relation action="”add”" oppositeitemid="u7436" reference="”account_to_contact”" relationtype="a36495" startingside="”base”">
        <fields>
          <field fieldid="a36498">
            <value>Developer</value>
          </field>
        </fields>
      </relation>
    </relations>
  </dataset>
</wxrequest>
{% endhighlight %}

Below is the corresponding response document for the above example:

{% highlight xml %}
<wxresponse>
  <callstatus status="success"></callstatus>
  <compatibilitylevel>1</compatibilitylevel>
  <dataset reference="workxpress">
    <item itemid="u7563" itemtypeid="a35234">
      <relation reference="account_to_contact" relationid="u7564">
    </relation></item>
  </dataset>
</wxresponse>
{% endhighlight %}

If you have any questions or would like assistance making some AddItem requests
of your own, please feel free to comment below. My next post will be on how to
use the UpdateItem request.
