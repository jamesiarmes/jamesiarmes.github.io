---
layout: post
title: 'Using the WorkXpress API: LookupData'
category: blog
created: 1251938664
---
[![WorkXpress](/assets/images/workxpress-logo.png){: .post-image .image-right }](http://www.workxpress.com)
Last week I introduced you to the
[WorkXpress API]({% post_url 2009-07-16-introducing-workxpress-api %}). If
you have not read it already you should do so before reading this post. Once you
have a basic understanding of what it is and how it works, it's time to start
diving into the API.

This post will cover how to read data from a WorkXpress Application using the
LookupData function. LookupData allows you to retrieve values from items and
relationships. If you know the item or relation id, you can retrieve the data
directly from the Item. If you don't have an id, you can use a map to search for
items and relationships. The WorkXpress API allows you to make many LookupData
requests in the same function call using data sets.

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
			  Contains a single LookupData request. You may have as many data sets as
			  you would like.
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
			<td>/wxRequest/dataSet/items</td>
			<td>Root node for the items that should be retrieved.</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/items/item</td>
			<td>
			  A single item to be retrieved. There is no limit to the number of item
			  nodes allowed in a data set.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
          <li>
            itemId (string): The item id of the item to retrieve data from.
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
			<td>/wxRequest/dataSet/fields</td>
			<td>
			  Root node for the fields that should be read from the items that were
			  found in the items node.
      </td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/fields/field</td>
			<td>
			  A single field to read data from.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
          <li>
            fieldId (string): Id of the field containing the data you wish to
            pull. Should be in the format a# (ie. a123).
          </li>
          <li>
            reference (string): An identifier that will be returned with the
            response to identify each field.
          </li>
        </ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/fields/field/format</td>
			<td>
			  Display format for the defined field. Display formats will be explained
			  in a later post. For now we will pull the "text" value of all fields.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
          <li>
            type (string): The type of format that should be returned. Must be
            one of the following:
            <ul>
              <li>
                html: Includes any HTML used when rendering the Field in view
                mode within the Application.
              </li>
              <li>
                stored: The format of the field when it is stored in the
                WorkXpress database. This may contain XML for multi-part fields,
                item ids for item pickers, etc. Stay tuned for a future post on
                special field values.
              </li>
              <li>
                text: Returns the plain text value. This is the recommended
                format.
              </li>
            </ul>
          </li>
        </ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/relations</td>
			<td>
			  Root node for relations that should be looked up from the items found in
			  the items node.
      </td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/relations/relation</td>
			<td>
        Root node for relations that should be looked up from the items found in
        the items node.
        <br /><br />
        <em>Attributes:</em>
        <ul>
          <li>
            relationType (string): Id of the relation type to search for. Should
            be in the format a# (ie. a123).
          </li>
          <li>
            from (string): Defines which side of the relation that the search
            should start from. Valid values are base and target.
          </li>
          <li>
            reference (string): An identifier that will be returned with the
            response to identify each relation.
          </li>
        </ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/relations/relation/fields</td>
			<td>
			  Root node for the fields that should be read from the relations that
			  were found in the items node.
      </td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/relations/relation/fields/field</td>
			<td>
			  A single field to read data from.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
          <li>
            fieldId (string): Id of the field containing the data you wish to
            pull. Should be in the format a# (ie. a123).
          </li>
          <li>
            reference (string): An identifier that will be returned with the
            response to identify each field.
          </li>
        </ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/relations/relation/fields/field/format</td>
			<td>
			  Display format for the defined field. Display formats will be explained
			  in a later post. For now we will pull the "text" value of all fields.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
          <li>
            type (string): The type of format that should be returned. Must be
            one of the following:
            <ul>
              <li>
                html: Includes any HTML used when rendering the Field in view
                mode within the Application.
              </li>
              <li>
                stored: The format of the field when it is stored in the
                WorkXpress database. This may contain XML for multi-part fields,
                item ids for item pickers, etc. Stay tuned for a future post on
                special field values.
              </li>
              <li>
                text: Returns the plain text value. This is the recommended
                format.
              </li>
            </ul>
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
			  A single item found based on the items defined in the request.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
          <li>
            itemId (string): The item id of the item that was found, in the
            format u# (ie. u123).
          </li>
        </ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/item/field</td>
			<td>
			  A single field that was retrieved based on the request.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
          <li>
            fieldId (string): Id of the field, in the format a# (ie. a123).
          </li>
          <li>
            reference (string): The identifier that was assigned to the field in
            the request document.
          </li>
        </ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/item/field/value</td>
			<td>
			  The value of the current field, in the format defined in the request.
      </td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/item/relation</td>
			<td>
			  Contains the data for a single relation that was found.
			  <br /><br />
			  <em>Attributes:</em>
			  <ul>
          <li>
            relationType (string): Id of the relation type for the current
            relation, in the format a# (ie. a123).
          </li>
          <li>
            id (string): Id of the current relation, in the format u# (ie.
            u123).
          </li>
          <li>
            reference (string): The identifier of the relation that was assigned
            to the relation in the request.
          </li>
          <li>
            baseItemTypeId (string): Item type id of the item on the base side
            of the relation, in the format a# (ie. a123).
          </li>
          <li>
            baseItemId (string): Item id of the item on the base side of the
            relation, in the format u# (ie. u123).
          </li>
          <li>
            targetItemTypeId (string): Item type id of the item on the target
            side of the relation, in the format a# (ie. a123).
          </li>
          <li>
            targetItemId (string): Item id of the item on the target side of the
            relation, in the format u# (ie. u123).
          </li>
        </ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/item/relation/field</td>
			<td>
			  A single field that was retrieved based on the request.
			  <br /><br />
				<em>Attributes:</em>
				<ul>
          <li>
            fieldId (string): Id of the field, in the format a# (ie. a123).
          </li>
          <li>
            reference (string): The identifier that was assigned to the field in
            the request document.
          </li>
        </ul>
			</td>
		</tr>
		<tr>
			<td>/wxRequest/dataSet/item/relation/field/value</td>
			<td>
			  The value of the current field, in the format defined in the request.
      </td>
		</tr>
	</tbody>
</table>

### Examples
Below is an example of a basic LookupData request document:

{% highlight xml %}
<wxrequest>
  <dataset reference="accounts">
    <items><map>
        <definition>
          &amp;lt;?xml version="1.0" encoding="UTF-8"?&amp;gt;
          &amp;lt;wxQuery xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="wxQuery.xsd" id="root"&amp;gt;
            &amp;lt;data for="root"&amp;gt;
              &amp;lt;item/&amp;gt;
            &amp;lt;/data&amp;gt;
            &amp;lt;startingTypes&amp;gt;
              &amp;lt;startingType&amp;gt;a35234&amp;lt;/startingType&amp;gt;
            &amp;lt;/startingTypes&amp;gt;
          &amp;lt;/wxQuery&amp;gt;
        </definition></map>
    </items>
    <fields>
      <field fieldid="a66969" reference="name">
        <format type="text">
      </format></field>
    </fields>
    <relations>
      <relation from="base" reference="account_to_contact" relationtype="a36495">
        <fields>
          <field fieldid="a36498" reference="position">
            <format type="text">
          </format></field>
        </fields>
      </relation>
    </relations>
  </dataset>
</wxresponse>
{% endhighlight %}

Below is the corresponding response document for the above example:
{% highlight xml %}
<wxresponse>
  <callstatus status="success"></callstatus>
  <compatibilitylevel>1</compatibilitylevel>
  <dataset reference="accounts">
    <item itemid="u7324">
      <field fieldid="a66969" reference="name">
        <value>WorkXpress</value>
      </field>
      <relation baseitemid="u7324" baseitemtypeid="a35234" id="u7437" reference="account_to_contact" relationtype="a36495" targetitemid="u7436" targetitemtypeid="a35334">
        <field fieldid="a36498" reference="position">
          <value>Developer</value>
        </field>
      </relation>
    </item>
  </dataset>
</wxresponse>
{% endhighlight %}

If you have any questions or would like assistance making some LookupData
requests of your own, please feel free to comment below. My next post will be on
how to use the AddItem request.
