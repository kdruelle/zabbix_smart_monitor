zabbix_smart_monitor
====================

Template and script for monitoring HDD S.M.A.R.T data from Zabbix on Linux OS

S.M.A.R.T. items description copied from Wikipedia (https://en.wikipedia.org/wiki/S.M.A.R.T.)

Features
--------

- Auto-discovery for all sdX drives
- Creating a host item for all discovered disk
- trigger alert on disk failure

Installation
------------

### Zabbix Agent side

First you need to install **smartmontools** package.

Append this to zabbix agent configuration file :

```
UserParameter=smartmonitor.discovery,sudo /usr/local/bin/smart_monitor.sh -D
UserParameter=smartmonitor.discovery_disk[*],sudo /usr/local/bin/smart_monitor.sh -d $1 -D
UserParameter=smartmonitor.value[*],sudo /usr/local/bin/smart_monitor.sh -d $1 -v $2
UserParameter=smartmonitor.health[*],sudo /usr/local/bin/smart_monitor.sh -d $1 -t
UserParameter=smartmonitor.model[*],sudo smartctl -i /dev/$1 | grep "Device Model" | cut -f2 -d:
UserParameter=smartmonitor.sn[*],sudo smartctl -i /dev/$1 | grep "Serial Number" | cut -f2 -d:
UserParameter=smartmonitor.capacity[*],sudo smartctl -i /dev/$1 | grep "User Capacity" | cut -f2 -d:
UserParameter=smartmonitor.family[*],sudo smartctl -i /dev/$1 | grep "Family" | cut -f2 -d:
```

**Make sure zabbix can perform sudo.**

Example:
```
cat /etc/sudoers.d/zabbix
Defaults:zabbix !requiretty
Defaults:zabbix !syslog

zabbix ALL=(ALL) NOPASSWD: /usr/local/bin/smart_monitor.sh *
zabbix ALL=(ALL) NOPASSWD: /usr/sbin/smartctl -i *
```

### Zabbix Server side

Import the **zbx_smart_monitor.xml** file.
Attach the "Template S.M.A.R.T" template to a host (e.g.: Zabbix server)

TODO
----

- Check all S.M.A.R.T data



