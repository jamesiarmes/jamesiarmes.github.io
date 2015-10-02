---
layout: post
title: Accessing HarrisData (IBM iSeries) In PHP
created: 1226281673
---
<a href="http://www.harrisdata.com"><img  alt="HarrisData Logo" src="/sites/default/files/blog/harrisdata_logo.png" style="float: right;" /></a>&nbsp;&nbsp;&nbsp; I have recently been working on a project to integrate with a HarrisData ERP Application.&nbsp; The Application runs on an IBM iSeries (AS/400).&nbsp; I used PHP's built in PDO object with the ODBC extension.&nbsp; Using PDO, I was able to execute SQL Queries on the server.&nbsp; IBM systems use IBM's DB2 syntax.&nbsp; This entry will outline some of the basic steps, in PHP, to communicate with the system.
<br /><br />
&nbsp;&nbsp;&nbsp; I will be assuming that you already have the ODBC driver installed and setup.&nbsp; I will also be assuming that your ODBC connection is called "AS400".
<br /><br />
&nbsp;&nbsp;&nbsp; I created a class called HarrisData.&nbsp; The constructor creates a PDO Object and assigns it to a class property called $database.
<pre class="brush: php; toolbar: false;">
$this->database = new PDO('odbc:AS400', 'USERNAME', 'password');
</pre>
&nbsp;&nbsp;&nbsp; Method in the class can use this object to run queries on the database.&nbsp; For example, let's say we want the first 10 rows of a table called "HDCUST".
<pre class="brush: php; toolbar: false;">
$query = 'SELECT * FROM DBNAME.HDCUST FETCH FIRST 10 ROWS ONLY';
$results = $this->database->query($query);

// check to make sure the query did not fail
if (!$results) {
    return false;
}

while ($row = $results->fetch()) {
    // do stuff..
}
</pre>
&nbsp;&nbsp;&nbsp; I have had to modify the columns being pulled several times.&nbsp; To make this easier and make the code cleaner and easier to maintain, I created an array of columns to be selected before each select statement.&nbsp; Note that I have placed the column names in the array in my example, but I used constants for the actual code.
<pre class="brush: php; toolbar: false;">
$select_array = array(
    'CMBLTO',
    'CMUDF3',
    'CMCMLU',
    'CMCUST',
    'CMSLTO',
); // end $select_array

$query = 'SELECT '.implode(',', $select_array).' FROM DBNAME.HDCUST FETCH FIRST 10 ROWS ONLY';
$results = $this->database->query($query);
</pre>
&nbsp;&nbsp;&nbsp; That's all there is to it.&nbsp; I have not had a need to write to the database at this time.&nbsp; If the need should arise, I will be sure to write a new entry about some of the techniques I used.
