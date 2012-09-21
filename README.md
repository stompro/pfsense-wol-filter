pfsense-wol-filter
==================

Perl script that accesses the wol functionality of a pfsense firewall and wakes machines based on various criteria.

Requirements
------------

pfSense 2.0 or higher.

Perl

Perl Modules
* HTTP::Mechanize
* HTML::TableExtract

pfSense Setup
-------------
You must create a pfsense user specifically for use with this script that only
has access to the wake on lan functionality.

1. Log in to the pfSense GUI and go to Setup -> User Manager

2. First select the group tab and use the + icon to create a new group.

3. Name the group WOL or whatever you want.
   Description "Wake On LAN". 
   Click Save.

4. Now click the E for edit icon next to the group you just created so you can
assigne privileges to that group.

5. In the Assign Privileges section, press the + icon.
6. Select only WebCfg - Services: Wake on LAN page.
7. Press Save
8. Press save again at the groups page.

9. Now switch to the Users tab.
10. Click the + icon to add a new user.

11. Set the Username, password and full name to whatever you want.

12. Select your WOL group from the "Not Member Of" selction, and press the
right arrow button to move the group to the "Member Of" section.

13. Click Save to finish adding the user.

14. Lastly, edit the wol-filter.pl script and add the username and password you setup.

