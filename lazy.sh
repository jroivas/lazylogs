#!/bin/bash

# Copyright (c)2015 Jouni Roivas <jroivas@iki.fi>
# MIT license, see COPYING

TEMP=$(getopt -o hl:s:r:t:d --long help,log:,server:,rotate:,target:,default -n "$0" -- "$@")
eval set -- "$TEMP"

function usage {
    echo "Usage: $0 [options]"
    echo "    -d|--default  Default logs"
    echo "                     syslog"
    echo "                     messages"
    echo "                     auth"
    echo "                     nginx"
    echo "    -l|--log      Log file to fetch"
    echo "    -s|--server   Server to connect"
    echo "    -r|--rotate   Rotate interval"
    echo "                     always"
    echo "                     minutely"
    echo "                     hourly"
    echo "                     daily"
    echo "                     weekly"
    echo "                     monthly"
    echo "    -t|--target   Target folder"
    echo "                  Default: current"
}

logs=
servers=
location=$PWD
rotate=daily
while true; do
    case "$1" in
        -d|--default)
            logs="syslog messages auth nginx"
            ;;
        -l|--log)
            shift
            logs="${logs} $1"
            ;;
        -s|--server)
            shift
            servers="${servers} $1"
            ;;
        -t|--target)
            shift
            location=$1
            ;;
        -r|--rotate)
            shift
            rotate=$1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            usage
            exit 0
            ;;
    esac
    shift
done

if [ -z "${logs}" ]; then
    echo "ERROR: No logs defined"
    usage
    exit 1
fi
if [ -z "${servers}" ]; then
    echo "ERROR: No servers defined"
    usage
    exit 1
fi

extra=
case "${rotate}" in
    monthly)
        extra=$(date +%Y%m)
        ;;
    weekly)
        extra=$(date +%Y%m-w%W)
        ;;
    daily)
        extra=$(date +%Y%m%d)
        ;;
    hourly)
        extra=$(date +%Y%m%d-%H)
        ;;
    minutely)
        extra=$(date +%Y%m%d-%H%M)
        ;;
    always)
        extra=$(date +%Y%m%d-%H%M%S.%N)
        ;;
    *)
        echo "Invalid rotate interval: ${rotate}"
        exit 1
        ;;
esac

for server in ${servers}; do
    serv_location="${location}/${server}"
    echo "Backuping ${server} to ${location}/${server}/${extra}..."
    mkdir -p "${serv_location}/${extra}"
    for log in ${logs}; do
        rsync -aqP "${server}:/var/log/${log}*" "${serv_location}/${extra}/"
    done
done
