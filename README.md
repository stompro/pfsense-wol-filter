pfsense-wol-filter
==================

Perl script that accesses the wol functionality of a pfsense firewall and wakes machines based on various criteria.

This script was created to make an easy to use, easy to schedule and easy to maintain method of starting up computers behind a pfSense firewall.  The author had been using wget to trigger the wake all command via scripts, but he wanted something that could target specific computers, without needing to hard code MAC addresses into the script, which makes maintenance tedious.

Requirements
------------

pfSense 2.0 or higher.

Perl

Perl Modules
* HTTP::Mechanize
* HTML::TableExtract

pfSense Computer Setup
----------------------

Every machine that you want to be able to start has to have a saved entry on the
pfSense Wake on LAN page.

pfSense User Setup
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

Features
-------------

The wol-filter.pl script needs a minimum of 2 arguments, with an unlimited maximum.

wol-filter.pl HOSTNAME FILTERSTRING [FILTERSTRING...]

 * HOSTNAME is the hostname or ip address of your pfsense system.
 * FILTERSTRING is one of 3 different options.
  * Option one is the MAC address of a computer.
  * Option two is the name of an interface, all wake on lan entries for that interface will be started.
  * Option three is a regular expression to match computer name[s].

MAC Address

  Enter the MAC Address in the standard format of 00:11:22:33:44:aa.

wol-filter.pl firewall.example.com 00:11:22:33:44:aa

Interface Name

  Enter the name of the interface to start all machines on that interface.

wol-filter.pl firewall.example.com lan

Regular Expression

 Enter a regular expression that will match the description column from the Wake on LAN page.  This is usually the computer hostname, but it can be set to whatever you want.  All entries that match will be started.  All descriptions are lowercased before the comparison, so you don't have to worry about correct case.

wol-filter.pl firewall.example.com '.*-pub..'

This would match AB-740-Pub01, AB-740-Pub02, DC-450-Pub03, etc.

Combinations

You can combine any of the three methods, any number of times.

wol-filter.pl firewall.example.com wireless 00:11:22:33:44:aa '.*-staff1'

This would start all computers listed for the wireless interface, the computer with the MAC address 00:11:22:33:44:aa, and the computer MD-280-staff1 which matches the regular expression.

