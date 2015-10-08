---
layout: post
title: 'Using the WorkXpress API: Display Formats'
category: blog
created: 1260678243
---
[![WorkXpress](/assets/images/workxpress-logo.png){: .post-image .image-right }](http://www.workxpress.com)
You have learned about all of the functions. You understand the data formats.
What could possibly be left before mastering the
[WorkXpress](http://www.workxpress.com) API? Display formats is the answer.

<!--more-->

Display formats allow you to pull out data in different formats. For example,
instead of pulling a file field as XML (stored value) or just the filename (text
value), you could get the download URL. When using display formats, the format
type must be set to "text". Not all Fields have display formats, while others
have several. Many of the available formats match the available parts for
multi-part fields. For more information on these parts, see my previous post on
[data formats]({% post_url blog/2009-10-26-using-workxpress-api-data-formats %}).

## Address
The [Address](http://www.workxpress.com/training/library/address) Field Type
exposes a number of display formats to match the available parts of the field.

*	Type
*	Street
*	Street2
*	Street3
*	City
*	State
*	ZipCode
*	Country

These formats can be combined to create you own format. For example, let's say
you want to display only the city, state and zip code of the address. Your
format string would look as follows:

{% highlight php startinline %}
$format = 'City, State ZipCode';
{% endhighlight %}

You can even add your own text to the string, just make sure not to use any of
the format parts in your custom text (display formats are case sensitive).

{% highlight php startinline %}
$format = 'You live in City, State Country';

// Since display formats are case sensitive, you could also do something like
// the following.
$format = 'This client hails from the city of City';
{% endhighlight %}

## Currency
[Currency](http://www.workxpress.com/training/library/currency-us) Fields
usually return the currency symbol ($) when using the text only version. Using
the NumberOnly format allows you to pull the value without the currency symbol
(ie. "3.12" instead of "$3.12"). You can get the same result from using the
stored format type instead of text.

## Phone Number
[Phone Number](http://www.workxpress.com/training/library/phone-number) Fields
are similar to Address Fields. The display formats for Phone Number Fields match
the available parts.

*	Type
*	CountryCode
*	AreaCode
*	Prefix
*	LineNumber
*	Extension

## Select - Select One
[Select - Select One](http://www.workxpress.com/training/library/select-one)
Fields provide display formats that allow access to some of their special
features. No display format will return the title of the currently selected
Select Option.

*	AltTitle: Alternate title of the currently selected Select Option.
*	WithOther: Title of the currently selected Select Option as well as the value
of the "Other" Field for the Select Option (if any).
*	OtherOnly: Returns only the value of the "Other" Field of the currently
selected Select Option (if any).

## Check Box
[Check Box](http://www.workxpress.com/training/library/checkbox) Fields provide
a few different formats to handle their unique on/off nature. Most of your
requirements for this Field Type can be handled using the stored format type.

*	Checked: Returns the values "CHECKED" or "UNCHECKED".
*	FieldLabel: Either the Field's label or empty.
*	WithOther: Returns the same as the Checked display format followed by a hyphen and the value of the "Other" Field for the current state (if any).
*	OtherOnly: Returns only the value of the "Other" Field for the current state (if any).

## Date and Date Time
[Date](http://www.workxpress.com/training/library/date) and
[Date Time](http://www.workxpress.com/training/library/date-and-time) Fields
provide display formats that can be useful for displaying their values in
different formats. Many of these formats correspond to the formats provided by
PHP's [date](http://us.php.net/manual/en/function.date.php) function.

*	AMPMLowercase: Lowercase ante meridiem or post meridiem value.
*	AMPMUppercase: Uppercase ante meridiem or port meridiem value.
*	DayOfMonth: Day of the month without leading zeros.
*	DayOfMonthSuffix: Two character English ordinal day of the month (ie. st for 1st or th for 13th).
*	DayOfMonthLeadingZero: Two digit day of the month with leading zeros.
*	DayOfWeek: Full day of the week title (ie. Monday).
*	DayOfWeekAbbreviated: Three character day of the week title (ie. Mon).
*	DayOfWeekNumber: <a href="http://en.wikipedia.org/wiki/ISO-8601#Week_dates">ISO-8601</a> numeric day of the week.
*	DayOfYear: Day of the year starting with zero.
*	Hour: 12-hour formatted hour without leading zero.
*	Hour24: 24-hour formatted hour without leading zero.
*	Hour24LeadingZero: 24-hour formatted hour with leading zero.
*	HourLeadingZero: 12-hour formatted hour with leading zero.
*	Minute: Two digit minutes with leading zeros.
*	MonthName: Full month title (ie. January).
*	MonthNameAbbreviated: Three character month title (ie. Jan).
*	MonthOfYear: Numeric representation of the month without leading zero.
*	MonthOfYearLeadingZero: Numeric representation of the month with leading zero.
*	Second: Two digit seconds with leading zero.
*	Timestamp: Seconds since the Unix epoch (January 1, 1970 00:00:00 GMT).
*	WeekOfYear: ISO-8601 numeric week number of the year.
*	Year: Four digit year.
*	YearShort: Two digit year.

## File
[File](<a href="http://www.workxpress.com/training/library/file-attachment)
Fields can be difficult to deal with. Display formats are here to help. Using
the display formats below, File Fields can be much easier to deal with.

*	DownloadURL: The URL that can be used to download the file. If the Field is
configured to be private, this URL will require a user to be logged in.
*	Filename: Name of the file, including the extension.
*	FileSize: Size of the file in bytes.
*	Height: If the file is an image, this will return the height of the image in
pixels.
*	Image: If the file is an image, this will return the image tag that can be
used in an HTML document. The image must be public for this to be used outside
of the Application.
*	MimeType: The file's mime-type (ie.image/png).
*	Thumbnail: Similar to the Image display format, but the src attribute will be
pointed at the thumbnail.
*	ThumbnailURL: If the file is an image, this will return the same as the
DownloadURL display format but for the thumbnail image.
*	Width: If the file is an image, this will return the width of the image in
pixels.

## Social Security
[Social Security](http://www.workxpress.com/training/library/social-security-number)
Fields provide only a single display format part. By using the LastFour format,
you can retrieve only the last four digits of a social security number. With no
display format, this Field Type will return the value as "\*\*\*-\*\*-####".

## Now You're Ready!
That's all folks. You have everything you need to master the WorkXpress API. The
API opens up a lot of possibilities for you and your application. Current uses
of the API include integrating with FedEx shipping services, data imports with
HarrisData and administration of FTP servers. Once you have had a chance to
explore the power of the API, come back here and let me know how you used it. As
always, if you have any questions, leave a comment below.
