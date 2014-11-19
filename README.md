zabbix_smart_monitor
====================

Template and script for monitoring HDD S.M.A.R.T data from Zabbix on Linux OS


Features
--------

- Auto-discovery for all sdX drives
- trigger alert on disk failure

Installation
------------

### Zabbix Agent side

First you need to install **smartmontools** package.

Append this to zabbix agent configuration file :

```
UserParameter=smartmonitor.discovery,sudo /usr/local/bin/smart_monitor.sh -D
UserParameter=smartmonitor.value[*],sudo /usr/local/bin/smart_monitor.sh -d $1 -v $2
UserParameter=smartmonitor.health[*],sudo /usr/local/bin/smart_monitor.sh -d $1 -t
```

**Make sure zabbix can perform sudo.**

### Zabbix Server side

Import the **zbx_smart_monitor.xml** file.


TODO
----

- Check all S.M.A.R.T data



