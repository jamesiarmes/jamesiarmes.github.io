---
layout: post
title: 'Using the WorkXpress API: Data Formats'
created: 1256606610
---
<p><a href="http://www.workxpress.com"><img alt="WorkXpress Logo" src="/sites/default/files/blog/workxpress-logo.png" style="float: right;"></a>&nbsp;&nbsp;&nbsp;&nbsp;Now that you know how to use the <a href="http://www.workxpress.com">WorkXpress</a> API, it's time to learn about some more advanced concepts. Data formats define how Field values are stored within WorkXpress. These values can be useful for finding out more information about certain values, and will need to be used when storing data into certain Field Types.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;The WorkXpress Engine tries hard to store data in simple, easy, logical formats. Below is a description of some of the less straightforward Field Types, and what format their data is expected in.</p>
<h2>Item Pickers</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.workxpress.com/training/library/item-picker-select-one">Item Picker</a> Fields store references to other Items. They can be used to manage Relationships, display links and other Fields attached to the referenced Item or to simply reference the Item in Actions.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Item Pickers are split into two primary types: single and multi. Single Item Pickers store a reference to only one Item at a time. Multi Item Pickers can store a reference to multiple Items at a time. Each of these types of Item Pickers is then broken down into Select Item Pickers and Pick Item Pickers. Select Item Pickers display as either a single select box or a multi-select Field. Single and Multi Item Pickers have slightly different stored values; however, there is no difference in the stored value of Select Item Pickers and Pick Item Pickers.</p>
<p>&nbsp;</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Single Item Pickers store their value as follows:</p>
<div style="padding-left: 40px; margin-top: 0px;"><span style="font-family: courier;">&lt;ItemTypeId&gt;|&lt;ItemId&gt;</span> (ex. a1325|u15)</div>
<p>&nbsp;</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Multi Item Pickers store their value as follows:</p>
<div style="padding-left: 40px; margin-top: 0px;"><span style="font-family: courier;">&lt;ItemTypeId&gt;|&lt;ItemId&gt;,&lt;ItemTypeId&gt;|&lt;ItemId&gt;,...</span> (ex. a1325|u15,a1325|u28,a1325|u193)</div>
<p>&nbsp;</p>
<h2>Selects</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.workxpress.com/training/library/select-one">Select</a> Fields are very similar to Item Picker Fields. They are split into single and multi selects. Select also store Items; however, they only store Items of type "Select Option" and these Items are pre-defined and related to the Field. The Item Type id of Select Options is e11, so all Select Field values will be prefixed with this id.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Single Selects store their value as follows:</p>
<div style="padding-left: 40px; margin-top: 0px;"><span style="font-family: courier;">e11|&lt;ItemId&gt;</span> (ex. e11|a32859)</div>
<p>&nbsp;</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Multi Selects store their value as follows:</p>
<div style="padding-left: 40px; margin-top: 0px;"><span style="font-family: courier;">e11|&lt;ItemId&gt;,e11|&lt;ItemId&gt;,...</span> (ex. e11|a49462,e11|a28957,e11|a1337)</div>
<p>&nbsp;</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Select Fields can also be set by passing in the title or alt title of the Select Option(s). For example let's say you the two options below available for a Single Select:</p>
<div style="text-align: center;"><a href="/sites/default/files/blog/wxapi/selectoptions.png" rel="lightbox" title="Select Options"><img alt="Select Options" src="/sites/default/files/blog/wxapi/selectoptions.png" title="Select Options"></a> <strong>Select Options</strong></div>
<p>You could set this Field to the value "Open" by passing in either "Open" or "O". For Multi Selects, you can mix and match the values. If the previous example was a Multi Select Field, you could set it by passing in "Open,C" or even "O,e11|a295456".</p>
<p>&nbsp;</p>
<h2>Check Box</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.workxpress.com/training/library/checkbox">Check box</a> Fields work like boolean values. When a check box Field is "on" or "true", the stored value will be 1. Any non-empty value may be passed in to set a check box to "on". When a check box Field is "off" or "false", the stored value will be empty. An empty value should be passed in to set a check box to "off".</p>
<h2>Date, Time &amp; Date Time</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.workxpress.com/training/library/date">Date</a>, <a href="http://www.workxpress.com/training/library/time">Time</a> and <a href="http://www.workxpress.com/training/library/date-and-time">Date Time</a> Fields are all stored as a Unix time stamp. A <a href="http://en.wikipedia.org/wiki/Unix_timestamp">Unix time stamp</a> represents the number of seconds since the Unix epoch (January 1, 1970), excluding leap seconds. This makes adding and subtracting time a simple arithmetic operation. PHP can easily handle and manipulate these values using its built in <a href="http://us2.php.net/manual/en/ref.datetime.php">date</a> functions.</p>
<pre class="brush: php; toolbar: false;">// convert a standard date into a unix time stamp and back again
$value = '01/29/1985';
$timestamp = strtotime($date);
$formatted = date('m/d/Y');

// convert a date and time value into a unix time stamp and back again
$value = '01/29/1985 11:35am';
$timestamp = strtotime($date);
$formatted = date('m/d/Y h:ia');

// convert a time only value into a unix time stamp and back again
$value = '11:35am';
$timestamp = strtotime('January 1, 1970 '.$time);
$formatted = date('h:ia');
</pre>
<p>&nbsp;</p>
<h2>File Attachment</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.workxpress.com/training/library/file-attachment">File Attachment</a> Fields are what WorkXpress refers to as a multi-part Field. Multi-part Fields are stored as XML so that each part can be referenced separately. There are two different ways of setting a File Attachment Field though the API:</p>
<ul>
	<li>Pass in XML with the encoded_file and filename parts set</li>
	<li>Pass in XML with the download_url set</li>
</ul>
<p>To base 64 encode a file in PHP, use the code below:</p>
<pre class="brush: php; toolbar: false;">$filename = '/home/jarmes/example.png';
$binary_data = file_get_contents($filename);
$encoded_file = base64_encode($binary_data);

// this could also be done on one line
$encoded_file = base64_encode(file_get_contents('/home/jarmes/example.png'));
</pre>
<p>The XML for a File Attachment Field should be structured using the below definition.</p>
<table colpadding="0" colspan="0" style="border: 2px solid black; border-collapse: collapse;">
	<thead>
		<tr>
			<th style="font-weight: bold; border: 2px solid black; width: 100px;">Element</th>
			<th style="font-weight: bold; border: 2px solid black;">Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/multi_part_field<!--</td--></td>
			<td style="font-weight: bold; border: 2px solid black;">The root node for all multi-part Fields.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/multi_part_field/part</td>
			<td style="font-weight: bold; border: 2px solid black;">Defines the value for a single part of the Field.<br>
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
							<td>id</td>
							<td>string</td>
							<td>Id of the current part. Valid values for File Attachment Fields include:
								<ul>
									<li>filename: The filename to be given to the file when it is saved on the WorkXpress file system.</li>
									<li>mime_type: The mime-type of the file (ie. image/jpeg)</li>
									<li>size: The file's size in bytes</li>
									<li>encoded_file: The base 64 encoded binary data of the file</li>
									<li>download_url: When retrieving a stored value, this will have a URL that can be used to download the file. If the Field is not configured to allow public files, this URL will require a valid login to the application. When setting a Field, this value may be set to a URL that WorkXpress should use to retrieve the file.</li>
								</ul>
							</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</tbody>
</table>
<p>Example:</p>
<pre class="brush: xml; toolbar: false;"><multi_part_field>
  <part id="filename">example.png</part>
  <part id="mime_type">image/png</part>
  <part id="size">364544</part>
  <part id="encoded_file">$encoded_file</part>
  <part id="download_url">http://www.example.com/example.png</part>
</multi_part_field>
</pre>
<h2>Address</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.workxpress.com/training/library/address">Address</a> Fields are also multi-part. Address Fields have two different types: US and International. If the "type" part of an address value is not set, it is assumed to be US.</p>
<p>The XML for an Address Field should be structured using the below definition.</p>
<table colpadding="0" colspan="0" style="border: 2px solid black; border-collapse: collapse;">
	<thead>
		<tr>
			<th style="font-weight: bold; border: 2px solid black; width: 100px;">Element</th>
			<th style="font-weight: bold; border: 2px solid black;">Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/multi_part_field<!--</td--></td>
			<td style="font-weight: bold; border: 2px solid black;">The root node for all multi-part Fields.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/multi_part_field/part</td>
			<td style="font-weight: bold; border: 2px solid black;">Defines the value for a single part of the Field.<br>
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
							<td>id</td>
							<td>string</td>
							<td>Id of the current part. Valid values for Address Fields include:
								<ul>
									<li>street: The first street value.</li>
									<li>street2: The second street value.</li>
									<li>street: The third street value (International values only).</li>
									<li>city: The city value.</li>
									<li>state: The state value. International values may have up to three characters. US values must have exactly two characters.</li>
									<li>zip_code: The postal code value. Should be five character numeric for US values.</li>
									<li>country: The country value. This value is required for International values. United States will be used for US values regardless of any value passed in. Should be the full country name (ie. Canada, South Africa) or the <a href="http://en.wikipedia.org/wiki/ISO_3166-1_alpha-3#Officially_assigned_code_elements">ISO 3166-1 alpha-3</a> formatted country code.</li>
									<li>type: Should be either International or United States.</li>
									<li>sort_value: Defines which street part will be used when sorting this value. Valid values include street, street2, and street3. This part is required for International values. US values will always use street.</li>
								</ul>
							</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</tbody>
</table>
<p>Example:</p>
<pre class="brush: xml; toolbar: false;"><multi_part_field>
  <part id="street">Ostvorstadt</part>
  <part id="street2">Hauptstraße 5</part>
  <part id="street3"></part>
  <part id="city">Musterstadt</part>
  <part id="state"></part>
  <part id="zip_code">01234</part>
  <part id="country">Germany</part>
  <part id="type">International</part>
  <part id="sort_value">street2</part>
</multi_part_field>
</pre>
<h2>Phone Number</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.workxpress.com/training/library/phone-number">Phone Numer</a> Fields are the last of the multi-part Fields. Like Address Fields, Phone Numbers can have two types: International and US. If the "type" part is not defined, it is assumed to be US.</p>
<p>The XML for a Phone Number Field should be structured using the below definition.</p>
<table colpadding="0" colspan="0" style="border: 2px solid black; border-collapse: collapse;">
	<thead>
		<tr>
			<th style="font-weight: bold; border: 2px solid black; width: 100px;">Element</th>
			<th style="font-weight: bold; border: 2px solid black;">Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/multi_part_field<!--</td--></td>
			<td style="font-weight: bold; border: 2px solid black;">The root node for all multi-part Fields.</td>
		</tr>
		<tr>
			<td style="font-weight: bold; border: 2px solid black;">/multi_part_field/part</td>
			<td style="font-weight: bold; border: 2px solid black;">Defines the value for a single part of the Field.<br>
				<em>Attributes:</em>
				<table style="border: none;">
					<thead>
						<tr>
							<th style="font-weight: bold; font-style: italic;">Name</th>
							<th style="font-weight: bold; font-style: italic;">Type</th>
							<th style="font-weight: bold; font-style: italic;">Description</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>id</td>
							<td>string</td>
							<td>Id of the current part. Valid values for Phone Number Fields include:
								<ul>
									<li>area_code: The area code value. Should be three digits for US values and up to five alpha-numeric characters for International values.</li>
									<li>prefix: The first three digits of a US phone number (US values only).</li>
									<li>line_numer: The last four digits of a US phone number. For International values, this is used for the remainder of the phone number (everything after the area code).</li>
									<li>extension: The optional extension value. Phone Number Fields can be set up to not display this value even if it has been set.</li>
									<li>country_code: The country calling code for International values. This will always be set to 1 for US values.</li>
									<li>type: Should be either International or United States.</li>
								</ul>
							</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</tbody>
</table>
<p>Example:</p>
<pre class="brush: xml toolbar: false;"><multi_part_field>
  <part id="area_code">717</part>
  <part id="prefix">609</part>
  <part id="line_number">0029</part>
  <part id="extension">123</part>
  <part id="country_code">1</part>
  <part id="type">United States</part>
</multi_part_field>
</pre>
<p>&nbsp;&nbsp;&nbsp;&nbsp;That's it for the WorkXpress Data Formats. All other Fields use simple storage types (ie. Currency stores as a number, Short Text stores as text). If you have any questions about these data formats, please feel free to leave a comment below. My next and final post on the WorkXpress API will cover display formats.</p>
