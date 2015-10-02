---
layout: post
title: 'Using the WorkXpress API: LookupData'
created: 1251938664
---
<p><a href="http://www.workxpress.com"><img src="/sites/default/files/blog/workxpress-logo.png" style="float: right;"></a>&nbsp;&nbsp;&nbsp;&nbsp;Last week I introduced you to the <a href="/blog/2009/08/introducing-workxpress-api">WorkXpress API</a>. If you have not read it already you should do so before reading this post. Once you have a basic understanding of what it is and how it works, it's time to start diving into the API.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;This post will cover how to read data from a WorkXpress Application using the LookupData function. LookupData allows you to retrieve values from items and relationships. If you know the item or relation id, you can retrieve the data directly from the Item. If you don't have an id, you can use a map to search for items and relationships. The WorkXpress API allows you to make many LookupData requests in the same function call using data sets.</p>
<p>&nbsp;</p>
<h3>Request XML</h3>
<p>&nbsp;&nbsp;&nbsp;&nbsp;First, let's get an understanding of how the request XML should be formed.</p>
<table colpadding="0" colspan="0" style="border: 2px solid black; border-collapse: collapse;">
	<thead>
		<tr>
			<th style="font-weight: bold; border: 2px solid black; width: 100px;">Element</th>
			<th style="font-weight: bold; border: 2px solid black;">Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest</td>
			<td style="font-weight: bold; border: 2px solid black;">The root node for all request documents.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet</td>
			<td style="font-weight: bold; border: 2px solid black;">Contains a single LookupData request. You may have as many data sets as you would like.<br>
				<em>Attributes:</em>
				<table colpadding="0" colspan="0" style="border: none;">
					<thead>
						<tr>
							<th style="font-weight: bold; font-style: italic;">Name</th>
							<th style="font-weight: bold; font-style: italic;">Type</th>
							<th style="font-weight: bold; font-style: italic;">Description</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>reference</td>
							<td>string</td>
							<td>An identifier that will be returned in the request document to distinguish between different data sets. If this attribute is left blank, a random string will be generated.</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				items</td>
			<td style="font-weight: bold; border: 2px solid black;">Root node for the items that should be retrieved.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				items/item</td>
			<td style="font-weight: bold; border: 2px solid black;">A single item to be retrieved. There is no limit to the number of item nodes allowed in a data set.<br>
				<em>Attributes:</em>
				<table colpadding="0" colspan="0" style="border: none;">
					<thead>
						<tr>
							<th style="font-weight: bold; font-style: italic;">Name</th>
							<th style="font-weight: bold; font-style: italic;">Type</th>
							<th style="font-weight: bold; font-style: italic;">Description</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>itemId</td>
							<td>string</td>
							<td>The item id of the item to retrieve data from. Should be in the format u# (ie. u123).</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				items/map</td>
			<td style="font-weight: bold; border: 2px solid black;">The root node for a map definition.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				items/map/definition</td>
			<td style="font-weight: bold; border: 2px solid black;">The actual definition for a map. The map XML must have its HTML entities encoded.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/fields</td>
			<td style="font-weight: bold; border: 2px solid black;">Root node for the fields that should be read from the items that were found in the items node.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				fields/field</td>
			<td style="font-weight: bold; border: 2px solid black;">A single field to read data from.<br>
				<em>Attributes:</em>
				<table colpadding="0" colspan="0" style="border: none;">
					<thead>
						<tr>
							<th style="font-weight: bold; font-style: italic;">Name</th>
							<th style="font-weight: bold; font-style: italic;">Type</th>
							<th style="font-weight: bold; font-style: italic;">Description</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>fieldId</td>
							<td>string</td>
							<td>Id of the field containing the data you wish to pull. Should be in the format a# (ie. a123).</td>
						</tr>
						<tr>
							<td>reference</td>
							<td>string</td>
							<td>An identifier that will be returned with the response to identify each field.</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				fields/field/<br>
				format</td>
			<td style="font-weight: bold; border: 2px solid black;">Display format for the defined field. Display formats will be explained in a later post. For now we will pull the "text" value of all fields.<br>
				<em>Attributes:</em>
				<table colpadding="0" colspan="0" style="border: none;">
					<thead>
						<tr>
							<th style="font-weight: bold; font-style: italic;">Name</th>
							<th style="font-weight: bold; font-style: italic;">Type</th>
							<th style="font-weight: bold; font-style: italic;">Description</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>type</td>
							<td>string</td>
							<td>The type of format that should be returned. Must be one of the following.<br>
								<ul>
									<li>html: Includes any HTML used when rendering the Field in view mode within the Application.</li>
									<li>stored: The format of the field when it is stored in the WorkXpress database. This may contain XML for multi-part fields, item ids for item pickers, etc. Stay tuned for a future post on special field values.</li>
									<li>text: Returns the plain text value. This is the recommended format.</li>
								</ul>
							</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				relations</td>
			<td style="font-weight: bold; border: 2px solid black;">Root node for relations that should be looked up from the items found in the items node.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				relations/relation</td>
			<td style="font-weight: bold; border: 2px solid black;">Root node for relations that should be looked up from the items found in the items node. <em>Attributes:</em>
				<table colpadding="0" colspan="0" style="border: none;">
					<thead>
						<tr>
							<th style="font-weight: bold; font-style: italic;">Name</th>
							<th style="font-weight: bold; font-style: italic;">Type</th>
							<th style="font-weight: bold; font-style: italic;">Description</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>relationType</td>
							<td>string</td>
							<td>Id of the relation type to search for. Should be in the format a# (ie. a123).</td>
						</tr>
						<tr>
							<td>from</td>
							<td>string</td>
							<td>Defines which side of the relation that the search should start from. Valid values are base and target.</td>
						</tr>
						<tr>
							<td>reference</td>
							<td>string</td>
							<td>An identifier that will be returned with the response to identify each relation.</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				relations/relation/<br>
				fields</td>
			<td style="font-weight: bold; border: 2px solid black;">Root node for the fields that should be read from the relations that were found in the items node.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				relations/relation/<br>
				fields/field</td>
			<td style="font-weight: bold; border: 2px solid black;">A single field to read data from.<br>
				<em>Attributes:</em>
				<table colpadding="0" colspan="0" style="border: none;">
					<thead>
						<tr>
							<th style="font-weight: bold; font-style: italic;">Name</th>
							<th style="font-weight: bold; font-style: italic;">Type</th>
							<th style="font-weight: bold; font-style: italic;">Description</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>fieldId</td>
							<td>string</td>
							<td>Id of the field containing the data you wish to pull. Should be in the format a# (ie. a123).</td>
						</tr>
						<tr>
							<td>reference</td>
							<td>string</td>
							<td>An identifier that will be returned with the response to identify each field.</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				relations/relation/<br>
				fields/field/<br>
				format</td>
			<td style="font-weight: bold; border: 2px solid black;">Display format for the defined field. Display formats will be explained in a later post. For now we will pull the "text" value of all fields.<br>
				<em>Attributes:</em>
				<table colpadding="0" colspan="0" style="border: none;">
					<thead>
						<tr>
							<th style="font-weight: bold; font-style: italic;">Name</th>
							<th style="font-weight: bold; font-style: italic;">Type</th>
							<th style="font-weight: bold; font-style: italic;">Description</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>type</td>
							<td>string</td>
							<td>The type of format that should be returned. Must be one of the following.<br>
								<ul>
									<li>html: Includes any HTML used when rendering the Field in view mode within the Application.</li>
									<li>stored: The format of the field when it is stored in the WorkXpress database. This may contain XML for multi-part fields, item ids for item pickers, etc. Stay tuned for a future post on special field values.</li>
									<li>text: Returns the plain text value. This is the recommended format.</li>
								</ul>
							</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</tbody>
</table>
<h3>Response XML</h3>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Now let's get an understanding of how the response XML will be formed.</p>
<table colpadding="0" colspan="0" style="border: 2px solid black; border-collapse: collapse;">
	<thead>
		<tr>
			<th style="font-weight: bold; border: 2px solid black; width: 100px;">Element</th>
			<th style="font-weight: bold; border: 2px solid black;">Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxResponse</td>
			<td style="font-weight: bold; border: 2px solid black;">The root node for all response documents.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/callStatus</td>
			<td style="font-weight: bold; border: 2px solid black;">The status of the SOAP call as it was processed by WorkXpress.<br>
				<em>Attributes:</em>
				<table colpadding="0" colspan="0" style="border: none;">
					<thead>
						<tr>
							<th style="font-weight: bold; font-style: italic;">Name</th>
							<th style="font-weight: bold; font-style: italic;">Type</th>
							<th style="font-weight: bold; font-style: italic;">Description</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>status</td>
							<td>string</td>
							<td>The call's status. Values include success and failure.</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxResponse/compatibilityLevel</td>
			<td style="font-weight: bold; border: 2px solid black;">The version of the API that was used to process the request.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet</td>
			<td style="font-weight: bold; border: 2px solid black;">One data set is returned for each data set in the request document.<br>
				<em>Attributes:</em>
				<table colpadding="0" colspan="0" style="border: none;">
					<thead>
						<tr>
							<th style="font-weight: bold; font-style: italic;">Name</th>
							<th style="font-weight: bold; font-style: italic;">Type</th>
							<th style="font-weight: bold; font-style: italic;">Description</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>reference</td>
							<td>string</td>
							<td>The identifier that was assigned to the data set in the request.</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				item</td>
			<td style="font-weight: bold; border: 2px solid black;">A single item found based on the items defined in the request.<br>
				<em>Attributes:</em>
				<table colpadding="0" colspan="0" style="border: none;">
					<thead>
						<tr>
							<th style="font-weight: bold; font-style: italic;">Name</th>
							<th style="font-weight: bold; font-style: italic;">Type</th>
							<th style="font-weight: bold; font-style: italic;">Description</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>itemId</td>
							<td>string</td>
							<td>The item id of the item that was found, in the format u# (ie. u123).</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				item/field</td>
			<td style="font-weight: bold; border: 2px solid black;">A single field that was retrieved based on the request.<br>
				<em>Attributes:</em>
				<table colpadding="0" colspan="0" style="border: none;">
					<thead>
						<tr>
							<th style="font-weight: bold; font-style: italic;">Name</th>
							<th style="font-weight: bold; font-style: italic;">Type</th>
							<th style="font-weight: bold; font-style: italic;">Description</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>fieldId</td>
							<td>string</td>
							<td>Id of the field, in the format a# (ie. a123).</td>
						</tr>
						<tr>
							<td>reference</td>
							<td>string</td>
							<td>The identifier that was assigned to the field in the request document.</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				item/field/<br>
				value</td>
			<td style="font-weight: bold; border: 2px solid black;">The value of the current field, in the format defined in the request.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				item/relation</td>
			<td style="font-weight: bold; border: 2px solid black;">Contains the data for a single relation that was found. <em>Attributes:</em>
				<table colpadding="0" colspan="0" style="border: none;">
					<thead>
						<tr>
							<th style="font-weight: bold; font-style: italic;">Name</th>
							<th style="font-weight: bold; font-style: italic;">Type</th>
							<th style="font-weight: bold; font-style: italic;">Description</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>relationType</td>
							<td>string</td>
							<td>Id of the relation type for the current relation, in the format a# (ie. a123).</td>
						</tr>
						<tr>
							<td>id</td>
							<td>string</td>
							<td>Id of the current relation, in the format u# (ie. u123).</td>
						</tr>
						<tr>
							<td>reference</td>
							<td>string</td>
							<td>The identifier of the relation that was assigned to the relation in the request.</td>
						</tr>
						<tr>
							<td>baseItemTypeId</td>
							<td>string</td>
							<td>Item type id of the item on the base side of the relation, in the format a# (ie. a123).</td>
						</tr>
						<tr>
							<td>baseItemId</td>
							<td>string</td>
							<td>Item id of the item on the base side of the relation, in the format u# (ie. u123).</td>
						</tr>
						<tr>
							<td>targetItemTypeId</td>
							<td>string</td>
							<td>Item type id of the item on the target side of the relation, in the format a# (ie. a123).</td>
						</tr>
						<tr>
							<td>targetItemId</td>
							<td>string</td>
							<td>Item id of the item on the target side of the relation, in the format u# (ie. u123).</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				item/relation/<br>
				field</td>
			<td style="font-weight: bold; border: 2px solid black;">A single field that was retrieved based on the request.<br>
				<em>Attributes:</em>
				<table colpadding="0" colspan="0" style="border: none;">
					<thead>
						<tr>
							<th style="font-weight: bold; font-style: italic;">Name</th>
							<th style="font-weight: bold; font-style: italic;">Type</th>
							<th style="font-weight: bold; font-style: italic;">Description</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>fieldId</td>
							<td>string</td>
							<td>Id of the field, in the format a# (ie. a123).</td>
						</tr>
						<tr>
							<td>reference</td>
							<td>string</td>
							<td>The identifier that was assigned to the field in the request document.</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				item/relation/<br>
				field/value</td>
			<td style="font-weight: bold; border: 2px solid black;">The value of the current field, in the format defined in the request.</td>
		</tr>
	</tbody>
</table>
<h3>Examples</h3>
<p>Below is an example of a basic LookupData request document:</p>
<pre class="brush: xml; toolbar: false;"><wxrequest>
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
</wxrequest>
</pre>
<p>Below is the corresponding response document for the above example:</p>
<pre class="brush: xml; toolbar: false;"><wxresponse>
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
</pre>
<p>&nbsp;&nbsp;&nbsp;&nbsp;If you have any questions or would like assistance making some LookupData requests of your own, please feel free to comment below. My next post will be on how to use the AddItem request.</p>
