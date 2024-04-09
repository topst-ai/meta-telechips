#!/bin/sh

rm /tmp/session_amgr
dbus-daemon --session --print-address --fork > /tmp/session_amgr
sed -i 's/^/DBUS_SESSION_BUS_ADDRESS=/' /tmp/session_amgr

