#!/bin/sh

while true ; do
    battery_path=`acpi_listen -t 1 | grep ac_adapter`
    if [ ! -z "$battery_path" ]; then
        ./batteryctl.sh
    fi
done
