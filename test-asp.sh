#!/bin/sh

ipaddress="10.253.1.15"
apikey="LUFRPT1yMEd0amdDYjdRVytaSC9nbkxMNXgxTk1lWFU9eXpZeVFhYnE2S2szUTRaY3BXMUV6Qk5MME45cDdjMXd0SHBsWWpXb1ptMD0="

curl -k "https://$ipaddress/api/?key=$apikey&type=op&cmd=%3Cshow%3E%3Ccounter%3E%3Cglobal%3E%3Cname%3Eflow_tcp_non_syn_drop%3C%2Fname%3E%3C%2Fglobal%3E%3C%2Fcounter%3E%3C%2Fshow%3E"
