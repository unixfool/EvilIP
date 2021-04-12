#!/bin/bash

# EvilNet DNSBL Search 1.1 (Beta) [EvilIP]
# Check IP is Listed in EvilNET
# Request Removal IP: https://dnsbl.evilnet.org/request-removal
# Search for IP: https://dnsbl.evilnet.org/ip-search
# FAQ: https://dnsbl.evilnet.org/faq
# Created by: y2k

#COLORS
RED="\e[31m"
GREEN="\e[92m"
YELLOW="\e[93m"
WHITE="\e[97m"
NORMAL="\e[39m"

#EvilNET DNSBL URL
DNSBL="rbl.evilnet.org"

#Read IP address
ERROR() 
{
	  echo "$0" ERROR: "$1" >&2
	    exit 2
    }

echo -e "${RED}" 
[ $# -ne 1 ] && ERROR "Please specify a single IP address!"
echo -e "${WHITE}"; 
 
reverse=$(echo "$1" |
	  sed -ne "s~^\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)$~\4.\3.\2.\1~p")
 
if [ "x${reverse}" = "x" ] ; then
		  echo "${RED}"; 
		        ERROR  " '$1' This is NOT a valid IP address"
				  echo -e "${WHITE}"; 
				        exit 1
fi

HostToIP()
{
	 if ( echo "$host" | grep -q "[a-zA-Z]" ); then
		    IP=$(host "$host" | awk '/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/ {print$NF}')
		     else
			        IP="$host"
				 fi
			 }

		 Repeat()
		 {
			  printf "%${2}s\n" | sed "s/ /${1}/g"
		  }

	  #Reverse HOST from IP
	  REVERSE_DNS=$(dig +short -x "$1")

	  Reverse()
	  {
		   echo "$1" | awk -F. '{print$4"."$3"."$2"."$1}'
	   }

   #Check if the IP is listed or not in EvilNet DNSBL
   Check()
   {
	    result=$(dig +short -t a "$rIP"."$BL")
	     if [ -n "$result" ]; then
		        echo  "${RED} IS LISTED :(" 
			   echo "${NORMAL}" "$BL" "${RED}" "(answer = $result)""${NORMAL}"
			      grep "$result" rbl.txt
			         echo "${RED} More info about your IP:" "${NORMAL} https://dnsbl.evilnet.org/your?ipaddress=""$IP"
				    echo "${RED} Request Removal:" "${NORMAL} https://dnsbl.evilnet.org/request-removal"
				     else
					        echo "${GREEN} NOT LISTED :) \t ${NORMAL}" "$BL"
						 fi
					 }

				 if [ -n "$1" ]; then
					   hosts=$*
				 fi

				 if [ -z "$hosts" ]; then
					   hosts=$(netstat -tn | awk '$4 ~ /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/ && $4 !~ /127.0.0/ {gsub(/:[0-9]+/,"",$4);} END{print$4}')
				 fi

				 for host in $hosts; do
					   HostToIP
					     rIP=$(Reverse "$IP")
					       echo; Repeat - 100
					         echo -e "${YELLOW}" "Your" IP "Address is:" "${NORMAL}" "$IP"  "${YELLOW}" "\t Your" HOST "is:" "${NORMAL}" "${REVERSE_DNS}" "${NORMAL}"
						   Repeat - 100
						     for BL in $DNSBL; do
							         Check
								   done
							   done

