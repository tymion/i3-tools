#!/bin/sh

brightness=
brightness_icon=
cmd=
step=10

brightness_notify () {
    brightness=`echo "\`xbacklight\` / 1" | bc`
    if [ "$brightness" -eq 0 ]; then
        brightness_icon="notification-display-brightness-off"
    elif [ "$brightness" -lt 33 ]; then
        brightness_icon="notification-display-brightness-low"
    elif [ "$brightness" -lt 66 ]; then
        brightness_icon="notification-display-brightness-medium"
    elif [ "$brightness" -lt 100 ]; then
        brightness_icon="notification-display-brightness-high"
    else
        brightness_icon="notification-display-brightness-full"
    fi
#    gdbus call --session --dest org.freedesktop.Notifications --object-path "/org/freedesktop/Notifications" --method org.freedesktop.Notifications.Notify soundctl 0 $volume_icon "Volume" "" [] "{\"urgency\": <byte 2>, \"value\": <int32 $volume>, \"x-canonical-private-synchronous\": <string \"0\">}" "int32 2000"
    notify-send "Brightness" -u critical -t 2000 -i $brightness_icon -h int:value:$brightness -h string:x-canonical-private-synchronous:0
}

while [ "$1" != "" ]; do
    case $1 in
        -c | --cmd )        shift
                            cmd=$1
                            ;;
        -s | --step )       shift
                            step=$1
                            ;;
        -h | --help )       usage
                            exit
                            ;;
        * )                 usage
                            exit 1
    esac
    shift
done

if [ "$cmd" = "" ]; then
    echo "Invalid arguments was passed. Command [-c|--cmd] parameter is mandatory."
    exit 1;
fi

if [ "$cmd" = "up" ]; then
    xbacklight -inc $step
    brightness_notify
elif [ "$cmd" = "down" ]; then
    xbacklight -dec $step
    brightness_notify
fi
