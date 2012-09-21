#!/usr/bin/perl
#
#    Copyright 2012 Josh Stompro <code47@stompro.org>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#Wake up computers that match a certain pattern via the pfsense web interface
#Author: Josh Stompro, Lake Agassiz Regional Library, Moorhead MN
#Version: 0.1
#
#The script accepts arguments from the command line.
# first argument is the ip or hostname of the pfsense firewall
# the next arguments are filters of either the network name, the MAC address or a
# regular expression of which computer description to match
#
#wol.filter.pl dl-firewall.larl.org "dl-740-circ2" "dl-740-pub.." 00:aa:bb:cc:dd:93 staffwireless
#
#Changelog:
#9/21/2012: Initial Release Version 0.1
#
#

#Modify the following variables to match your pfsense system.  
# You must create a dedicated login just for accessing the WOL page.
my $username = "wol";
my $password = "putyourpasswordhere";

# Set $DEBUG to 1 for more output
my $DEBUG = 0;

#only need data dumper when debuging
#use Data::Dumper;

use WWW::Mechanize;
my $mech = WWW::Mechanize->new();
use HTML::TableExtract;
my $te = HTML::TableExtract->new(headers => [qw(Interface MAC Description)]);

#Process Arguments
#print $#ARGV;
if($#ARGV < 1){
	print "Arguments missing. \n usage: wol-filter.pl HOSTNAME MACADDRESS or REGEXPRESSION [MAC or REG]...\n";
	exit;
}

#first argument is the hostname or IP.
my $host = shift(@ARGV);

#Collect the 


my $startpage = "https://$host";
$mech->get( $startpage );
print "Loading $startpage\n";

$mech->submit_form(
		   form_number => 1,
		   fields => {
			usernamefld => $username,
			passwordfld => $password,
		   },
       button => "login",
		   );
print "Logging In\n";

if($mech->content =~ /Username or Password incorrect/){
  print "Login failed\n";
  exit;
}

if($mech->content =~ /Enter username and password to login/){
  print "Back at login page, login failed\n";
  exit;
}

#visit the wol page
#$mech->get( "https:\\$host\services_wol.php" );
#print $mech->content;

#Get list of interfaces and setup a lookup hash.
my ($listbox) = $mech->find_all_inputs(name => 'interface' );
my %name_lookup;
@name_lookup{ $listbox->value_names } = $listbox->possible_values;


#print Dumper($listbox);

$woltables = $te->parse($mech->content);


#Grab the table that contains all the WOL entrys.
$table = $te->first_table_found;
foreach $row ($table->rows) {
  $interface = ${$row}[0];
  $interface =~ s/[\n\r\s\240]+//g;
  $MAC = ${$row}[1];
  $MAC =~ s/[\n\r\s\240]+//g;
  $description = ${$row}[2];
  $description =~ s/[\n\r\s\240]+//g;
  $interface_internal = $name_lookup{ $interface };
  print "\n$description \tInterface = $interface, Internal = $interface_internal, MAC = $MAC, Description = $description\n";
  foreach $argument (@ARGV){
    print "\tArgument = $argument\n"  if $DEBUG;
    if($MAC eq $argument){
      print "\t\tMAC matches - submit wake request\n";
      $mech->get( "https://$host/services_wol.php?mac=${MAC}&if=${interface_internal}" );
      print "\t\thttps://$host/services_wol.php?mac=${MAC}&if=${interface_internal}\n"  if $DEBUG;
    }
    elsif(lc($description) =~ /$argument/){
      print "\t\tRE matches - submit wake command\n";
      $mech->get( "https://$host/services_wol.php?mac=${MAC}&if=${interface_internal}" );
      print "\t\thttps://$host/services_wol.php?mac=${MAC}&if=${interface_internal}\n"  if $DEBUG;
    }
    elsif(lc($interface) eq lc($argument)){
      print "\t\tInterface matches - submit wake command\n";
      $mech->get( "https://$host/services_wol.php?mac=${MAC}&if=${interface_internal}" );
      print "\t\thttps://$host/services_wol.php?mac=${MAC}&if=${interface_internal}\n"  if $DEBUG;
    }
  }
} 
 
exit;       

