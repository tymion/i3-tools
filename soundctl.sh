#!/bin/sh

default_sink_tag="Default Sink:"
default_sink_tag_cnt=`echo $default_sink_tag | wc -c`
default_sink=`pactl info | grep "$default_sink_tag" | cut -c $default_sink_tag_cnt-`
volume=
volume_icon=
volume_text=
volume_ext=
cmd=
step=10

volume_notify () {
    volume=`pactl list sinks | perl -000ne 'if(/#1/){/(Volume:.*)/; print "$1\n"}' | awk '{ print $5 }' | sed 's/%//g'`
    if [ "$volume" -lt 33 ]; then
        volume_icon="notification-audio-volume-low"
    elif [ "$volume" -lt 66 ]; then
        volume_icon="notification-audio-volume-medium"
    else
        volume_icon="notification-audio-volume-high"
    fi
    notify-send "Volume" -u critical -t 2000 -i $volume_icon -h int:value:$volume -h string:x-canonical-private-synchronous:
}

mute_notify () {
    notify-send "Volume muted" -u critical -t 2000 -i notification-audio-volume-muted -h int:value:0 -h string:x-canonical-private-synchronous:
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

if [ "$cmd" = "mute" ]; then
    pactl set-sink-mute $default_sink toggle
    mute=`pactl list sinks | perl -000ne 'if(/#1/){/(Mute:.*)/; print "$1\n"}' | cut -c 7-`
    if [ "$mute" = "yes" ]; then
        mute_notify
    else
        volume_notify
    fi
fi

if [ "$cmd" = "up" ]; then
    pactl set-sink-volume $default_sink +$step%
    volume_notify
elif [ "$cmd" = "down" ]; then
    pactl set-sink-volume $default_sink -$step%
    volume_notify
fi
