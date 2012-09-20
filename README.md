pfsense-wol-filter
==================

Perl script that accesses the wol functionality of a pfsense firewall and wakes machines based on various criteria.

Requirements
============

pfSense 2.0 or higher.

Perl

HTTP::Mechanize

pfSense Setup
=============
You must create a pfsense user specifically for use with this script that only
has access to the wake on lan functionality.

Setup -> User Manager

First select the group tab and use the + icon to create a new group.
Name the group WOL or whatever you want.
Description Wake On LAN
Click Save

Now click the E for edit icon next to the group you just created so you can
assigne privileges to that group.

In the Assign Privileges section, press the + icon.
Select only WebCfg - Services: Wake on LAN page.
Press Save
Press save again at the groups page.

Now switch to the Users tab.
Click the + icon to add a new user.

Set the Username, password and full name to whatever you want.

Select your WOL group from the "Not Member Of" selction, and press the
right arrow button to move the group to the "Member Of" section.

Click Save to finish adding the user.

Lastly, edit the wol-filter.pl script and add the username and password you setup.

