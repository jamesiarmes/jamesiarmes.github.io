---
layout: post
title: 'Using the WorkXpress API: ExecuteAction'
created: 1256602701
---
<p><a href="http://www.workxpress.com"><img alt="WorkXpress Logo" src="/sites/default/files/blog/workxpress-logo.png" style="float: right;"></a>&nbsp;&nbsp;&nbsp;&nbsp;Earlier I introduced you to the <a href="/blog/2009/08/introducing-workxpress-api">WorkXpress API</a>. If you have not read it already you should do so before reading this post. Once you have a basic understanding of what it is and how it works, it's time to start diving into the API.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;This post will cover how to run specfic Actions on specific Items. You can find the id of an Action at the end of its description in the Event Manager (see below). Like the other functions, you can make many ExecuteAction requests in one call using data sets.</p>
<p>&nbsp;</p>
<div style="text-align: center;"><a href="/sites/default/files/blog/wxapi/workxpress_action_id.png" rel="lightbox" title="WorkXpress Event Manager"><img alt="WorkXpress Event Manager" src="/sites/default/files/blog/wxapi/workxpress_action_id.png" title="WorkXpress Event Manager"></a> <strong>WorkXpress Event Manager</strong></div>
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
			<td style="font-weight: bold; border: 2px solid black;">Contains a single ExecuteAction request. You may have as many data sets as you would like.<br>
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
							<td>An identifier that will be returned in the reponse document to distinguish between different data sets. If this attribute is left blank, a random string will be generated.</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				items</td>
			<td style="font-weight: bold; border: 2px solid black;">Root node for the items that the Action(s) should be run on.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				items/item</td>
			<td style="font-weight: bold; border: 2px solid black;">A single item to execute the action on. There is no limit to the number of item nodes allowed in a data set.<br>
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
							<td>The item id of the item to execute the action on. Should be in the format u# (ie. u123).</td>
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
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				actions</td>
			<td style="font-weight: bold; border: 2px solid black;">Root node for the Actions to be executed.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/wxRequest/dataSet/<br>
				actions/action</td>
			<td style="font-weight: bold; border: 2px solid black;">A single Action to be executed on the Items defined above. There is no limit to the number of action nodes allowed in a data set.<br>
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
							<td>actionId</td>
							<td>string</td>
							<td>Id of a single Action to run. Should be in the format a# (ie. a123).</td>
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
			<td style="font-weight: bold; border: 2px solid black;">Defines an item that the Action(s) was executed on. One item node is returned for each item that an Action was run on.<br>
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
							<td>Id of the item, in the format u# (ie. u123).</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</tbody>
</table>
<h3>Examples</h3>
<p>Below is an example of a basic ExecuteAction request document:</p>
<pre class="brush: xml; toolbar: false;"><wxrequest>
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
</pre>
<p>Below is the corresponding response document for the above example:</p>
<p>&nbsp;</p>
<pre class="brush: xml; toolbar: false;"><wxresponse>
  <callstatus status="success"></callstatus>
  <compatibilitylevel>1</compatibilitylevel>
  <dataset reference="accounts">
    <item itemid="u3541"></item>
    <item itemid="u511"></item>
  </dataset>
</wxresponse>
</pre>
<p>&nbsp;&nbsp;&nbsp;&nbsp;If you have any questions or would like assistance making some ExecuteAction requests of your own, please feel free to comment below. My next post will be on some more advanced concepts such as display formats and stored values.</p>
