#!/bin/bash

if [[ "`tty`" = /dev/tty[1-9] && $(ps -o comm= -p $PPID) = login ]]; then
  clear_console
fi
