---
layout: post
title: 'Using the WorkXpress API: UpdateItem'
category: blog
created: 1256170671
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

This post will cover how to update existing Items in a WorkXpress application
using the UpdateItem API function. UpdateItem allows you to set Fields, create
Relationships and recycle and delete Items &amp; Relationships. Like the other
functions, you can make many UpdateItem requests in one call using data sets.

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
			  Contains a single UpdateItem request. You may have as many data sets as
			  you would like.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
				  <li>
				    reference (string): An identifier that will be returned in the
				    request document to distinguish between different data sets. If this
				    attribute is left blank, a random string will be generated.
				  </li>
				  <li>
				    action (string): The operation to be performed on the requested
				    action.
				    <ul>
              <li>
                delete: Once an Item has been deleted from WorkXpress, it can
                only be retrieved by restoring an earlier backup. You should
                only delete Items if you know for sure that you will not need it
                in the future. Deleting an Item will also delete any
                Relationships to other Items.
              </li>
              <li>
                recycle: Recycled Items can be restored using the restore action
                (see below). When an Item is recycled, it will no longer be
                returned in search results; this includes (but is not limited
                to) Actions and List Layouts. All Relationships to other Items
                will also be recycled.
              </li>
              <li>
                restore: Restoring a recycled Item will make it available to
                searching again. Restoring an Item will also restore any
                recycled Relations to other Items.
              </li>
              <li>update: Updates an existing Item.</li>
            </ul>
				  </li>
				</ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/items</td>
			<td>Root node for the items that should be retrieved.</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/items/item</td>
			<td>
			  A single item to be updated. There is no limit to the number of item
			  nodes allowed in a data set.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
				  <li>
				    itemId (string): The item id of the item to update from. Should be
				    in the format u# (ie. u123).
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
			<td>/wxRequest/dataSet/fields</td>
			<td>
			  Root node for any fields that should be updated on the items that were
			  found in the items node.
      </td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/fields/field</td>
			<td>
			  A single field to update on the Item.
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
			  Root node for relations that should be added or updated with the current
			  item.
      </td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/relations/relation</td>
			<td>
			  Defines a single relation to be added or updated. If the action is not
			  "add", the attributes will be used to look up an existing relation.
			  <br /><br />
			  <em>Attributes:</em>
			  <ul>
          <li>
            action (string): The action to perform for this relation.
            <ul>
              <li>
                add: Creates a new relationship using the other attributes to
                define the new relationship.
              </li>
              <li>
                delete: Similar to items, deleted relationships are completely
                removed from WorkXpress and can only be retrieved by restoring a
                previous backup.
              </li>
              <li>
                recycle: Recycled relationships are <em>not</em> removed from
                WorkXpress and can be restored using the restore action.
              </li>
              <li>
                restore: Restores a relationship that was previously recycled.
              </li>
              <li>update: Updates an existing relation.</li>
            </ul>
          </li>
          <li>
            oppositeItemId (string): Id of the item on the opposite side of the
            relation. For example, if the item being updated is an account and
            you want to relate it to a contact (or update an existing
            relationship to a contact), this would be the id of the contact.
            Should be in the format u# (ie. u123).
          </li>
          <li>
            reference (string): An identifier that will be returned with the
            response to identify each relationship.
          </li>
          <li>
            relationType (string): Relation type of the relationship. Should be
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
			<td>Root node for the fields that should be set on the relationship.</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/relations/relation/fields/field</td>
			<td>
			  A single field to be set on the relationship.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
          <li>
            fieldId (string): Id of the field to set. Should be in the format a# 
            ie. a123).
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
			  Defines an item that was updated. One item node is returned for each
			  item that was updated by WorkXpress.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
          <li>
            itemId (string): Id of the item that was updated, in the format u#
            (ie. u123).
          </li>
        </ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/item/relation</td>
			<td>
			  Defines a relationship that was added or updated. Returns one relation
			  node for each relationship from the item that was added or updated by
			  WorkXpress.
			  <br /><br />
			  <em>Attributes:</em>
			  <ul>
          <li>
            reference (string): The identifier of the relation that was assigned
            to the relation in the request.
          </li>
          <li>
            relationId (string): Id of the relation that was added or updated,
            in the format u# (ie. u123).
          </li>
        </ul>
			</td>
		</tr>
	</tbody>
</table>

### Examples
Below is an example of a basic UpdateItem request document:

{% highlight xml %}
<wxrequest>
  <dataset action="update" reference="account_update">
    <items>
      <item itemid="u7563"></item>
    </items>
    <fields>
      <field fieldid="a66969">
        <value>WorkXpress</value>
      </field>
    </fields>
    <relations>
      <relation action="update" oppositeitemid="u7436" reference="account_to_contact" relationtype="a36495" startingside="base">
        <fields>
          <field fieldid="a36498">
            <value>Intern</value>
          </field>
          <field fieldid="a36513">
            <value>foo@example.com</value>
          </field>
        </fields>
      </relation>
    </relations>
  </dataset>
  <dataset action="recycle" reference="account_recycle">
    <items><map>
        <definition>
          &amp;lt;?xml version="1.0" encoding="UTF-8"?&amp;gt;
          &amp;lt;wxQuery xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="wxQuery.xsd" id="root"&amp;gt;
            &amp;lt;data for="root"&amp;gt;
              &amp;lt;item/&amp;gt;
            &amp;lt;/data&amp;gt;
            &amp;lt;startingTypes&amp;gt;
              &amp;lt;startingType&amp;gt;a5543&amp;lt;/startingType&amp;gt;
            &amp;lt;/startingTypes&amp;gt;
            &amp;lt;paramGroup id="wx4adfb3c227d12"&amp;gt;
              &amp;lt;join&amp;gt;and&amp;lt;/join&amp;gt;
              &amp;lt;fieldSearch id="wx4adfb3d738a91"&amp;gt;
                &amp;lt;fieldId&amp;gt;a39651&amp;lt;/fieldId&amp;gt;
                &amp;lt;operator&amp;gt;fieldLessThanEqualTo&amp;lt;/operator&amp;gt;
                &amp;lt;input&amp;gt;
                  &amp;amp;lt;?xml version="1.0"?&amp;amp;gt;
                  &amp;amp;lt;search_value&amp;amp;gt;
                    &amp;amp;lt;first_value&amp;amp;gt; -1 years &amp;amp;lt;/first_value&amp;amp;gt;
                  &amp;amp;lt;/search_value&amp;amp;gt;
                &amp;lt;/input&amp;gt;
              &amp;lt;/fieldSearch&amp;gt;
            &amp;lt;/paramGroup&amp;gt;
          &amp;lt;/wxQuery&amp;gt;
        </definition></map>
    </items>
  </dataset>
</wxrequest>
{% endhighlight %}

Below is the corresponding response document for the above example:

{% highlight xml %}
<wxresponse>
  <callstatus status="success"></callstatus>
  <compatibilitylevel>1</compatibilitylevel>
  <dataset reference="account_update">
    <item itemid="u7563">
      <relation reference="account_to_contact" relationid="u7564"></relation>
    </item>
  </dataset>
  <dataset reference="account_recycle">
    <item itemid="u1782"></item>
  </dataset>
</wxresponse>
{% endhighlight %}

If you have any questions or would like assistance making some UpdateItem
requests of your own, please feel free to comment below. My next post will be on
how to use the ExecuteAction request.
