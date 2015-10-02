---
layout: post
title: UPS Time In Transit
created: 1209088279
---
&nbsp;&nbsp;&nbsp;&nbsp;Time In Transit has been committed to the UPS API repository.  Time in transit allow you to check the amount of time it would take to ship a package using different UPS Services.  From the <a href="http://www.ups.com/onlinetools">UPS OnlineTools Website</a>:
<blockquote>
    <strong>With UPS Time in Transit, You Can:</strong>
    <br /><br />
    <ul>
        <li>Improve customer service by providing consistent, up-to-date shipping information based on the origin and destination addresses and the date the shipment is needed.</li>
        <li>Plan and manage inventory levels by controlling when your company receives merchandise.</li>
    </ul>
    <br /><br />
    <strong>Your Customers Can:</strong>
    <br /><br />
    <ul>
        <li>Review delivery options when placing their order at your Web site.</li>
        <li>Synchronize the arrival of multiple packages with different points of origin.</li>
    </ul>
</blockquote>

&nbsp;&nbsp;&nbsp;&nbsp;Besides the usual buildRequest() method, UpsAPI_TimeInTransit contains two specialized methods.  getServices() returns an array of the UPS shipping services and their transit times.  getNumberOrServices() returns the number of services that were returned by UPS.

&nbsp;&nbsp;&nbsp;&nbsp;The web interface for wikis on Google Code is currently down.  Once the interface is back up, expect more information about the new class, including examples.  In the mean time, please feel free to get the latest revision from the <a href="http://code.google.com/p/php-ups-api/source/checkout">subversion repository</a>.  If you have any questions, please post them here or email me at <a href="mailto:jamesiarmes@gmail.com">jamesiarmes@gmail.com</a>.  Please use the <a href="http://code.google.com/p/php-ups-api/issues/list">Issue Tracker</a> for any issues you may come across.
