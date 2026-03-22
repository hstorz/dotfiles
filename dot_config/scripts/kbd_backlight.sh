#!/bin/bash

# Control keyboard backlight handling on T2 MacBook Pro  with Fedora Workstation and Niri

if [ "$1" = "on" ]; then
    echo 1000 > /sys/class/leds/:white:kbd_backlight/brightness
elif [ "$1" = "off" ]; then
    echo 0 > /sys/class/leds/:white:kbd_backlight/brightness
fi