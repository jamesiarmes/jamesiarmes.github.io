---
layout: post
title: The Browser Is Mightier Than The Rich Text Area
category: blog
section-type: post
created: 1211465495
tags:
  - Browsers
  - Firefox
  - Rich-Text
  - TinyMCE
---
Since Firefox 3 Beta 5 was released, there has been some problems with our Rich
Text Areas in WorkXpress. The control renders but remains gray; there is no way
for users to enter text. This problem persist in Firefox 3 Release Candidate 1.

<!--more-->

To resolve this issue, I have been tasked with updating our TinyMCE code from
2.0.2 to 3.0.7. This is no easy task, as the API for TinyMCE 3 is very different
than the API for version 2.

I am currently in the process of converting all of our custom plugins to
function with the new version. I will be sure to update once I complete this
task.
