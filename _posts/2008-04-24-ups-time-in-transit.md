---
layout: post
title: UPS Time In Transit
category: blog
created: 1209088279
---
Time In Transit has been committed to the UPS API repository. Time in transit
allow you to check the amount of time it would take to ship a package using
different UPS Services. From the
[UPS OnlineTools Website](http://www.ups.com/onlinetools):

> **With UPS Time in Transit, You Can:**
>
> * Improve customer service by providing consistent, up-to-date shipping information based on the origin and destination addresses and the date the shipment is needed.</li>
> * Plan and manage inventory levels by controlling when your company receives merchandise.</li>
>
> **Your Customers Can:**
>
> * Review delivery options when placing their order at your Web site.</li>
> * Synchronize the arrival of multiple packages with different points of origin.</li>

Besides the usual `buildRequest()` method, UpsAPI_TimeInTransit contains two
specialized methods. `getServices()` returns an array of the UPS shipping
services and their transit times. `getNumberOrServices()` returns the number of
services that were returned by UPS.

The web interface for wikis on Google Code is currently down. Once the interface
is back up, expect more information about the new class, including examples. In
the mean time, please feel free to get the latest revision from the
[subversion repository](http://code.google.com/p/php-ups-api/source/checkout).
Please use the
[issue tracker](http://code.google.com/p/php-ups-api/issues/list) for any issues
you may come across.
