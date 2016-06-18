#!/bin/bash
echo -n "Input Aruba AP serial: "
read SERIAL
 
(echo -n CCODE-UNRST-;echo -n "UNRST-${SERIAL}"|sha1sum)|hexdump -e '"%06.6_ax " 4/1 "%02x" "\n"'|head -n -1
 
