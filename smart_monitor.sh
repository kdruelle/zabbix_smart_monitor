#!/bin/bash
#
# AUTHOR: Kevin Druelle
#
# DATE: 2014-06-17

#echo "OPTIND is now $OPTIND"

while getopts ":Dd:v:t" optname
do
    case "$optname" in
    "D")
        # Discovery
        if [ -z "$disks" ]; then
            disks=`ls -l /dev/sd* | awk '{print $NF}' | sed 's/[0-9]//g' | uniq`
        fi
        typeset -i nbLines
        typeset -i cntLines=0
        if [ -z "$nbLines" ]; then
            nbLines=`ls -l /dev/sd* | awk '{print $NF}' | sed 's/[0-9]//g' | uniq | wc -l`
        fi
        echo "{"
        echo "\"data\":["
        for disk in $disks
        do
            cntLines=${cntLines}+1
            if [ ${cntLines} -eq ${nbLines} ]; then
                echo "    {\"{#DISKNAME}\":\"$disk\",\"{#SHORTDISKNAME}\":\"${disk:5}\"}"
            else
                echo "    {\"{#DISKNAME}\":\"$disk\",\"{#SHORTDISKNAME}\":\"${disk:5}\"},"
            fi
        done
        echo "]"
        echo "}"
        exit 0
    ;;
    "d")
        # Which device
        Device=$OPTARG
        disks=`ls -l /dev/sd* | grep $OPTARG | awk '{print $NF}' | sed 's/[0-9]//g' | uniq`
        nbLines=`ls -l /dev/sd* | grep $OPTARG | awk '{print $NF}' | sed 's/[0-9]//g' | uniq | wc -l`
    ;;
    "v")
        # Which value to get
        /usr/sbin/smartctl -A /dev/$Device | grep $OPTARG | awk '{print $10}'
        exit 0
    ;;
    "t")
        /usr/sbin/smartctl -a -d ata /dev/$Device | grep "SMART overall-health" | cut -d " " -f 6
        exit 0
    ;;
    "?")
        echo "Unknown option $OPTARG"
        exit 1
    ;;
    ":")
        echo "No argument value for option $OPTARG"
        exit 1
    ;;
    *)
        # Should not occur
        echo "Unknown error while processing options"
        exit 1
    ;;
    esac
done
