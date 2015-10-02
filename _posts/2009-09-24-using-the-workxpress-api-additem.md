---
layout: post
title: 'Using the WorkXpress API: AddItem'
created: 1253837524
---
<p><a href="http://www.workxpress.com"><img alt="WorkXpress Logo" src="/sites/default/files/blog/workxpress-logo.png" style="float: right;"></a>&nbsp;&nbsp;&nbsp;&nbsp;Earlier I introduced you to the <a href="/blog/2009/08/introducing-workxpress-api">WorkXpress API</a>. If you have not read it already you should do so before reading this post. Once you have a basic understanding of what it is and how it works, it's time to start diving into the API.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;This post will cover how to add Items to a WorkXpress application using the AddItem API function. AddItem allows you to set Fields and create Relationships while adding the new Item. Like the LookupData function, you can make many AddItem requests in one call using data sets.</p>
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
			<td style="font-weight: bold; border: 2px solid black;">Contains a single AddItem request. You may have as many data sets as you would like.<br>
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
				item</td>
			<td style="font-weight: bold; border: 2px solid black;">Used to specify the item type id of the new item.<br>
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
							<td>itemTypeId</td>
							<td>string</td>
							<td>The item type id of the new item. Should be in the format a# (ie. a123).</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/fields</td>
			<td style="font-weight: bold; border: 2px solid black;">Root node for the fields that should be set on the new item.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				fields/field</td>
			<td style="font-weight: bold; border: 2px solid black;">A single field to be set on the new item.<br>
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
							<td>Id of the field containing to set. Should be in the format a# (ie. a123).</td>
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
			<td style="font-weight: bold; border: 2px solid black;">Root node for relations that should be created along with the new item.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				relations/relation</td>
			<td style="font-weight: bold; border: 2px solid black;">Defines a relation to be created. <em>Attributes:</em>
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
							<td>The action to perform for this relation. This should always be set to "add" for AddItem requests.</td>
						</tr>
						<tr>
							<td>oppositeItemId</td>
							<td>string</td>
							<td>Id of the item on the opposite side of the relation. For example, if the item being created is an account and you want to relate it to a contact, this would be the id of the contact. Should be in the format u# (ie. u123).</td>
						</tr>
						<tr>
							<td>reference</td>
							<td>string</td>
							<td>An identifier that will be returned with the response to identify each relation.</td>
						</tr>
						<tr>
							<td>relationType</td>
							<td>string</td>
							<td>Relation type of the new relation. Should be in the format a# (ie. a123).</td>
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
			<td style="font-weight: bold; border: 2px solid black;">Root node for the fields that should be set on the new relation.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				relations/relation/<br>
				fields/field</td>
			<td style="font-weight: bold; border: 2px solid black;">A single field to be set on the new relation.<br>
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
							<td>Id of the field containing to set. Should be in the format a# (ie. a123).</td>
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
			<td style="font-weight: bold; border: 2px solid black;">Defines the item that was added to the WorkXpress application.<br>
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
							<td>Id of the item that was added, in the format u# (ie. u123).</td>
						</tr>
						<tr>
							<td>itemTypeId</td>
							<td>string</td>
							<td>Item type id of the item that was added, in the format a# (ie. a123).</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				item/relation</td>
			<td style="font-weight: bold; border: 2px solid black;">Defines a relation that was added to the WorkXpress application. <em>Attributes:</em>
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
							<td>Id of the relation that was added, in the format u# (ie. u123).</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</tbody>
</table>
<h3>Examples</h3>
<p>Below is an example of a basic AddItem request document:</p>
<pre class="brush: xml; toolbar: false;"><wxrequest>
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
</pre>
<p>Below is the corresponding response document for the above example:</p>
<pre class="brush: xml; toolbar: false;"><wxresponse>
  <callstatus status="success"></callstatus>
  <compatibilitylevel>1</compatibilitylevel>
  <dataset reference="workxpress">
    <item itemid="u7563" itemtypeid="a35234">
      <relation reference="account_to_contact" relationid="u7564">
    </relation></item>
  </dataset>
</wxresponse></pre>
<p>&nbsp;&nbsp;&nbsp;&nbsp;If you have any questions or would like assistance making some AddItem requests of your own, please feel free to comment below. My next post will be on how to use the UpdateItem request.</p>
