#!/bin/sh

battery_path=`upower -e | grep BAT`
#tmp_icon=`upower -i $battery_path | grep icon | cut -b 26-`
#tmp_icon_cnt=`echo \"\`echo $tmp_icon | wc -c\` - 2\" | bc`
battery_icon=`echo $tmp_icon | cut -b 1-$tmp_icon_cnt`

state=`upower -i $battery_path | grep state | cut -b 26-`
percentage=`upower -i $battery_path | grep percentage | cut -b 26- | cut -b -2`

percentage_icon=

discharging_notify ()
{
    if [ "$percentage" -lt 10 ]; then
        percentage_icon="notification-battery-000"
    elif [ "$percentage" -lt 20 ]; then
        percentage_icon="notification-battery-010"
    elif [ "$percentage" -lt 30 ]; then
        percentage_icon="notification-battery-020"
    elif [ "$percentage" -lt 40 ]; then
        percentage_icon="notification-battery-030"
    elif [ "$percentage" -lt 50 ]; then
        percentage_icon="notification-battery-040"
    elif [ "$percentage" -lt 60 ]; then
        percentage_icon="notification-battery-050"
    elif [ "$percentage" -lt 70 ]; then
        percentage_icon="notification-battery-060"
    elif [ "$percentage" -lt 80 ]; then
        percentage_icon="notification-battery-070"
    elif [ "$percentage" -lt 90 ]; then
        percentage_icon="notification-battery-080"
    elif [ "$percentage" -lt 100 ]; then
        percentage_icon="notification-battery-090"
    elif [ "$percentage" -eq 100 ]; then
        percentage_icon="notification-battery-100"
    fi
}

charging_notify ()
{
    if [ "$percentage" -lt 10 ]; then
        percentage_icon="notification-battery-000-plugged"
    elif [ "$percentage" -lt 20 ]; then
        percentage_icon="notification-battery-010-plugged"
    elif [ "$percentage" -lt 30 ]; then
        percentage_icon="notification-battery-020-plugged"
    elif [ "$percentage" -lt 40 ]; then
        percentage_icon="notification-battery-030-plugged"
    elif [ "$percentage" -lt 50 ]; then
        percentage_icon="notification-battery-040-plugged"
    elif [ "$percentage" -lt 60 ]; then
        percentage_icon="notification-battery-050-plugged"
    elif [ "$percentage" -lt 70 ]; then
        percentage_icon="notification-battery-060-plugged"
    elif [ "$percentage" -lt 80 ]; then
        percentage_icon="notification-battery-070-plugged"
    elif [ "$percentage" -lt 90 ]; then
        percentage_icon="notification-battery-080-plugged"
    elif [ "$percentage" -lt 100 ]; then
        percentage_icon="notification-battery-090-plugged"
    elif [ "$percentage" -eq 100 ]; then
        percentage_icon="notification-battery-100-plugged"
    fi
}

parse_state () {
    if [ "$state" = "fully-charged" ]; then
        charging_notify
    elif [ "$state" = "discharging" ]; then
        discharging_notify
    elif [ "$state" = "charging" ]; then
        charging_notify
    fi
}

parse_state
notify-send "percentage" -u critical -t 2000 -i $percentage_icon -h int:value:$percentage -h string:x-canonical-private-synchronous:0

#notification-battery-empty
#notification-battery-low
