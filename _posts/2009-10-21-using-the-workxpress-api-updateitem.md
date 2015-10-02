---
layout: post
title: 'Using the WorkXpress API: UpdateItem'
created: 1256170671
---
<p><a href="http://www.workxpress.com"><img alt="WorkXpress Logo" src="/sites/default/files/blog/workxpress-logo.png" style="float: right;"></a>&nbsp;&nbsp;&nbsp;&nbsp;Earlier I introduced you to the <a href="/blog/2009/08/introducing-workxpress-api">WorkXpress API</a>. If you have not read it already you should do so before reading this post. Once you have a basic understanding of what it is and how it works, it's time to start diving into the API.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;This post will cover how to update existing Items in a WorkXpress application using the UpdateItem API function. UpdateItem allows you to set Fields, create Relationships and recycle and delete Items &amp; Relationships. Like the other functions, you can make many UpdateItem requests in one call using data sets.</p>
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
			<td style="font-weight: bold; border: 2px solid black;">Contains a single UpdateItem request. You may have as many data sets as you would like.<br>
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
						<tr>
							<td>action</td>
							<td>string</td>
							<td>The operation to be performed on the requested action<br>
								<ul>
									<li>delete: Once an Item has been deleted from WorkXpress, it can only be retrieved by restoring an earlier backup. You should only delete Items if you know for sure that you will not need it in the future. Deleting an Item will also delete any Relationships to other Items.</li>
									<li>recycle: Recycled Items can be restored using the restore action (see below). When an Item is recycled, it will no longer be returned in search results; this includes (but is not limited to) Actions and List Layouts. All Relationships to other Items will also be recycled.</li>
									<li>restore: Restoring a recycled Item will make it available to searchng again. Restoring an Item will also restore any recycled Relations to other Items.</li>
									<li>update: Updates an existing Item.</li>
								</ul>
							</td>
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
			<td style="font-weight: bold; border: 2px solid black;">A single item to be updated. There is no limit to the number of item nodes allowed in a data set.<br>
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
							<td>The item id of the item to update from. Should be in the format u# (ie. u123).</td>
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
			<td style="font-weight: bold; border: 2px solid black;">Root node for any fields that should be updated on the items that were found in the items node.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				fields/field</td>
			<td style="font-weight: bold; border: 2px solid black;">A single field to update on the Item.<br>
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
							<td>Id of the field to set. Should be in the format a# (ie. a123).</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				fields/field/<br>
				value</td>
			<td style="font-weight: bold; border: 2px solid black;">Value to set into the field.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				relations</td>
			<td style="font-weight: bold; border: 2px solid black;">Root node for relations that should be added or updated with the current item.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				relations/relation</td>
			<td style="font-weight: bold; border: 2px solid black;">Defines a single relation to be added or updated. If the action is not "add", the attributes will be used to look up an existing relation. <em>Attributes:</em>
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
							<td>action</td>
							<td>string</td>
							<td>The action to perform for this relation.<br>
								<ul>
									<li>add: Creates a new relationship using the other attributes to define the new relationship.</li>
									<li>delete: Similar to items, deleted relationships are completely removed from WorkXpress and can only be retrieved by restoring a previous backup.</li>
									<li>recycle: Recycled relationships are <em>not</em> removed from WorkXpress and can be restored using the restore action.</li>
									<li>restore: Restores a relationship that was previously recycled.</li>
									<li>update: Updates an existing relation.</li>
								</ul>
							</td>
						</tr>
						<tr>
							<td>oppositeItemId</td>
							<td>string</td>
							<td>Id of the item on the opposite side of the relation. For example, if the item being updated is an account and you want to relate it to a contact (or update an existing relationship to a contact), this would be the id of the contact. Should be in the format u# (ie. u123).</td>
						</tr>
						<tr>
							<td>reference</td>
							<td>string</td>
							<td>An identifier that will be returned with the response to identify each relationship.</td>
						</tr>
						<tr>
							<td>relationType</td>
							<td>string</td>
							<td>Relation type of the relationship. Should be in the format a# (ie. a123).</td>
						</tr>
						<tr>
							<td>startingSide</td>
							<td>string</td>
							<td>Defines which side of the relation that the item defined above should be on. Valid values are base and target.</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				relations/relation/<br>
				fields</td>
			<td style="font-weight: bold; border: 2px solid black;">Root node for the fields that should be set on the relationship.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				relations/relation/<br>
				fields/field</td>
			<td style="font-weight: bold; border: 2px solid black;">A single field to be set on the relationship.<br>
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
							<td>Id of the field to set. Should be in the format a# (ie. a123).</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				relations/relation/<br>
				fields/field/<br>
				value</td>
			<td style="font-weight: bold; border: 2px solid black;">Value to set into the field.</td>
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
			<td style="font-weight: bold; border: 2px solid black;">Defines an item that was updated. One item node is returned for each item that was updated by WorkXpress.<br>
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
							<td>Id of the item that was updated, in the format u# (ie. u123).</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				item/relation</td>
			<td style="font-weight: bold; border: 2px solid black;">Defines a relationship that was added or updated. Returns one relation node for each relationship from the item that was added or updated by WorkXpress. <em>Attributes:</em>
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
							<td>The identifier of the relation that was assigned to the relation in the request.</td>
						</tr>
						<tr>
							<td>relationId</td>
							<td>string</td>
							<td>Id of the relation that was added or updated, in the format u# (ie. u123).</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</tbody>
</table>
<h3>Examples</h3>
<p>Below is an example of a basic UpdateItem request document:</p>
<pre class="brush: xml; toolbar: false;"><wxrequest>
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
</pre>
<p>Below is the corresponding response document for the above example:</p>
<pre class="brush: xml; toolbar: false;"><wxresponse>
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
</pre>
<p>&nbsp;&nbsp;&nbsp;&nbsp;If you have any questions or would like assistance making some UpdateItem requests of your own, please feel free to comment below. My next post will be on how to use the ExecuteAction request.</p>
