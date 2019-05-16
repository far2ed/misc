#!/bin/bash
echo "Please install XMLSTARLET before running this script"
echo "sudo apt install xmlstarlet"

if [[ $EUID -ne 0 ]]; then
	echo "Please run this script as root" 1>&2
	exit 1
fi

if [ $# -eq 1 ]; then

mkdir report-$1
mkdir report-$1/portlist
mkdir report-$1/tmp

echo "------------------------------------------------------------------------------------------------------"
echo "TCP SynSCAN"
echo "------------------------------------------------------------------------------------------------------"

nmap -sS -p- -T5 -v -oX report-$1/tmp/TCPscan.xml -Pn $1

echo "------------------------------------------------------------------------------------------------------"
echo "UDP SCAN"
echo "------------------------------------------------------------------------------------------------------"

nmap -sU --top-ports 1000 -T5 -v -oX report-$1/tmp/UDPscan.xml -Pn $1

echo "------------------------------------------------------------------------------------------------------"
echo "DATA PARSING"
echo "------------------------------------------------------------------------------------------------------"

xmlstarlet sel -t -m '//port/state[@state="open"]/parent::port' -v './@portid' -n report-$1/tmp/TCPscan.xml > report-$1/tmp/opentcp && echo "TCP Portlist exported in file : opentcp"
xmlstarlet sel -t -m '//port/state[@state="open"]/parent::port' -v './@portid' -n report-$1/tmp/UDPscan.xml > report-$1/tmp/openudp && echo "UDP portlist exported in file : openudp"

echo "------------------------------------------------------------------------------------------------------"
echo "BANNER GRABBING + VULNERS SCRIPT"
echo "------------------------------------------------------------------------------------------------------"

nmap -p $(tr '\n' , <report-$1/tmp/opentcp) -sV --script vulners --script-args mincvss=5.0 $1 -oA report-$1/tmp/tcpbanners

nmap -p $(tr '\n' , <report-$1/tmp/openudp) -sU -sV --script vulners --script-args mincvss=5.0 $1 -oA report-$1/tmp/udpbanners

echo "------------------------------------------------------------------------------------------------------"
echo "SEARCHSPLOIT MINING"
echo "------------------------------------------------------------------------------------------------------"

searchsploit --nmap report-$1/tmp/tcpbanners.xml -v --colour -w 2>/dev/null > report-$1/tmp/searchsploit_tcp
searchsploit --nmap report-$1/tmp/udpbanners.xml -v --colour -w 2>/dev/null > report-$1/tmp/searchsploit_udp

echo "------------------------------------------------------------------------------------------------------"
echo "DONE"

cp report-$1/tmp/searchsploit_tcp report-$1/
cp report-$1/tmp/searchsploit_tcp report-$1/
cp report-$1/tmp/tcpbanners.nmap report-$1/
cp report-$1/tmp/udpbanners.nmap report-$1/
cp report-$1/tmp/opentcp report-$1/portlist/
cp report-$1/tmp/openudp report-$1/portlist/
rm -f tmp/*

echo "Reports copied in reports-$1"
echo "The searchsploits reports need to be parsed again because the exploit-db was queried with 'large' criterias" 
echo "You should also use opentcp and openudp to configure OpenVAS or a third party program, while importing them you won't waste time scanning the whole server again" 
echo "------------------------------------------------------------------------------------------------------"

else
    echo "Please provide an IP or Hostname to scan"
fi
