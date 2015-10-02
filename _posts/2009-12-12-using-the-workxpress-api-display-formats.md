---
layout: post
title: 'Using the WorkXpress API: Display Formats'
created: 1260678243
---
<p><a href="http://www.workxpress.com"><img alt="WorkXpress Logo" src="/sites/default/files/blog/workxpress-logo.png" style="float: right;"></a>&nbsp;&nbsp;&nbsp;&nbsp;You have learned about all of the functions. You understand the data formats. What could possibly be left before mastering the <a href="http://www.workxpress.com">WorkXpress</a> API? Display formats is the answer.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Display formats allow you to pull out data in different formats. For example, instead of pulling a file field as XML (stored value) or just the filename (text value), you could get the download URL. When using display formats, the format type must be set to "text". Not all Fields have display formats, while others have several. Many of the available formats match the available parts for multi-part fields. For more information on these parts, see my previous post on <a href="/blog/2009/10/using-workxpress-api-data-formats">data formats</a>.</p>
<h2>Address</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;The <a href="http://www.workxpress.com/training/library/address">Address</a> Field Type exposes a number of display formats to match the available parts of the field.</p>
<ul>
	<li>Type</li>
	<li>Street</li>
	<li>Street2</li>
	<li>Street3</li>
	<li>City</li>
	<li>State</li>
	<li>ZipCode</li>
	<li>Country</li>
</ul>
<p>&nbsp;</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;These formats can be combined to create you own format. For example, let's say you want to display only the city, state and zip code of the address. Your format string would look as follows:</p>
<pre class="brush: php; toobar: false;">$format = 'City, State ZipCode';</pre>
<p>You can even add your own text to the string, just make sure not to use any of the format parts in your custom text (display formats are case sensitive).</p>
<pre class="brush: php; toolbar: false;">$format = 'You live in City, State Country';
// since display formats are case sensitive, you could also do something like the following
$format = 'This client hails from the city of City';
</pre>
<h2>Currency</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.workxpress.com/training/library/currency-us">Currency</a> Fields usually return the currency symbol ($) when using the text only version. Using the NumberOnly format allows you to pull the value without the currency symbol (ie. "3.12" instead of "$3.12"). You can get the same result from using the stored format type instead of text.</p>
<h2>Phone Number</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.workxpress.com/training/library/phone-number">Phone Number</a> Fields are similar to Address Fields. The display formats for Phone Number Fields match the available parts.</p>
<ul>
	<li>Type</li>
	<li>CountryCode</li>
	<li>AreaCode</li>
	<li>Prefix</li>
	<li>LineNumber</li>
	<li>Extension</li>
</ul>
<p>&nbsp;</p>
<h2>Select - Select One</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.workxpress.com/training/library/select-one">Select - Select One</a> Fields provide display formats that allow access to some of their special features. No display format will return the title of the currently selected Select Option.</p>
<ul>
	<li>AltTitle: Alternate title of the currently selected Select Option.</li>
	<li>WithOther: Title of the currently selected Select Option as well as the value of the "Other" Field for the Select Option (if any).</li>
	<li>OtherOnly: Returns only the value of the "Other" Field of the currently selected Select Option (if any).</li>
</ul>
<p>&nbsp;</p>
<h2>Check Box</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.workxpress.com/training/library/checkbox">Check Box</a> Fields provide a few different formats to handle their unique on/off nature. Most of your requirements for this Field Type can be handled using the stored format type.</p>
<ul>
	<li>Checked: Returns the values "CHECKED" or "UNCHECKED".</li>
	<li>FieldLabel: Either the Field's label or empty.</li>
	<li>WithOther: Returns the same as the Checked display format followed by a hyphen and the value of the "Other" Field for the current state (if any).</li>
	<li>OtherOnly: Returns only the value of the "Other" Field for the current state (if any).</li>
</ul>
<p>&nbsp;</p>
<h2>Date and Date Time</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.workxpress.com/training/library/date">Date</a> and <a href="http://www.workxpress.com/training/library/date-and-time">Date Time</a> Fields provide display formats that can be useful for displaying their values in different formats. Many of these formats correspond to the formats provided by PHP's <a href="http://us.php.net/manual/en/function.date.php">date</a> function.</p>
<ul>
	<li>AMPMLowercase: Lowercase ante meridiem or post meridiem value.</li>
	<li>AMPMUppercase: Uppercase ante meridiem or port meridiem value.</li>
	<li>DayOfMonth: Day of the month without leading zeros.</li>
	<li>DayOfMonthSuffix: Two character English ordinal day of the month (ie. st for 1st or th for 13th).</li>
	<li>DayOfMonthLeadingZero: Two digit day of the month with leading zeros.</li>
	<li>DayOfWeek: Full day of the week title (ie. Monday).</li>
	<li>DayOfWeekAbbreviated: Three character day of the week title (ie. Mon).</li>
	<li>DayOfWeekNumber: <a href="http://en.wikipedia.org/wiki/ISO-8601#Week_dates">ISO-8601</a> numeric day of the week.</li>
	<li>DayOfYear: Day of the year starting with zero.</li>
	<li>Hour: 12-hour formatted hour without leading zero.</li>
	<li>Hour24: 24-hour formatted hour without leading zero.</li>
	<li>Hour24LeadingZero: 24-hour formatted hour with leading zero.</li>
	<li>HourLeadingZero: 12-hour formatted hour with leading zero.</li>
	<li>Minute: Two digit minutes with leading zeros.</li>
	<li>MonthName: Full month title (ie. January).</li>
	<li>MonthNameAbbreviated: Three character month title (ie. Jan).</li>
	<li>MonthOfYear: Numeric representation of the month without leading zero.</li>
	<li>MonthOfYearLeadingZero: Numeric representation of the month with leading zero.</li>
	<li>Second: Two digit seconds with leading zero.</li>
	<li>Timestamp: Seconds since the Unix epoch (January 1, 1970 00:00:00 GMT).</li>
	<li>WeekOfYear: ISO-8601 numeric week number of the year.</li>
	<li>Year: Four digit year.</li>
	<li>YearShort: Two digit year.</li>
</ul>
<p>&nbsp;</p>
<h2>File</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.workxpress.com/training/library/file-attachment">File</a> Fields can be difficult to deal with. Display formats are here to help. Using the display formats below, File Fields can be much easier to deal with.</p>
<ul>
	<li>DownloadURL: The URL that can be used to download the file. If the Field is configured to be private, this URL will require a user to be logged in.</li>
	<li>Filename: Name of the file, including the extension.</li>
	<li>FileSize: Size of the file in bytes.</li>
	<li>Height: If the file is an image, this will return the height of the image in pixels.</li>
	<li>Image: If the file is an image, this will return the image tag that can be used in an HTML document. The image must be public for this to be used outside of the Application.</li>
	<li>MimeType: The file's mime-type (ie.image/png).</li>
	<li>Thumbnail: Similar to the Image display format, but the src attribute will be pointed at the thumbnail.</li>
	<li>ThumbnailURL: If the file is an image, this will return the same as the DownloadURL display format but for the thumbnail image.</li>
	<li>Width: If the file is an image, this will return the width of the image in pixels.</li>
</ul>
<p>&nbsp;</p>
<h2>Social Security</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.workxpress.com/training/library/social-security-number">Social Security</a> Fields provide only a single display format part. By using the LastFour format, you can retrieve only the last four digits of a social security number. With no display format, this Field Type will return the value as "***-**-####".</p>
<h2>Now You're Ready</h2>
<p>&nbsp;&nbsp;&nbsp;&nbsp;That's all folks. You have everything you need to master the WorkXpress API. The API opens up a lot of possibilities for you and your application. Current uses of the API include integrating with FedEx shipping services, data imports with HarrisData and administration of FTP servers. Once you have had a chance to explore the power of the API, come back here and let me know how you used it. As always, if you have any questions, leave a comment below.</p>
