#!/bin/sh
# Lockdown rpc access from remote hosts

echo "rpcbind: ALL" >> /etc/hosts.deny
echo "rcpbind: 10. 192.168. 127." >> /etc/hosts.allow

svccfg -s rpc/bind setprop config/enable_tcpwrappers=true
svcadm refresh rpc/bind
