#!/bin/bash


#####################################################################################
#### FEDERAL UNIVERSITY OF SANTA CATARINA -- UFSC
#### Prof. Wyllian Bezerra da Silva


#####################################################################################
#### Dependencies: freerdp-x11 gawk x11-utils yad zenity

string=""
if ! hash xfreerdp 2>/dev/null; then
    string="\nfreerdp-x11"
fi
if ! hash awk 2>/dev/null; then
    string="\ngawk"
fi
if ! hash xdpyinfo 2>/dev/null; then
    string="${string}\nx11-utils"
fi
if ! hash yad 2>/dev/null; then
    string="${string}\nyad"
fi
if [ -n "$string" ]; then
  if hash amixer 2>/dev/null; then
    amixer set Master 80% > /dev/null 2>&1; 
  else
    pactl set-sink-volume 0 80%
  fi
  if hash speaker-test 2>/dev/null; then
    ((speaker-test -t sine -f 880 > /dev/null 2>&1)& pid=$!; sleep 0.2s; kill -9 $pid) > /dev/null 2>&1 
  else 
    if hash play 2>/dev/null; then
      play -n synth 0.1 sin 880 > /dev/null 2>&1 
    else
      cat /dev/urandom | tr -dc '0-9' | fold -w 32 | sed 60q | aplay -r 9000 > /dev/null 2>&1
    fi
  fi
  (zenity --info --title="Requirements" --width=300 --text="\
  You need to install this(ese) package(s):

  <b>$string</b>

  ") > /dev/null 2>&1 
  exit
fi


#####################################################################################
#### Get informations
dim=$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')
w=$(($(echo $dim | sed -r 's/x.*//')-70))
h=$(($(echo $dim | sed -r 's/.*x//')-70))
wxh=$w"x"$h

while true
do

  LOGIN=
  PASSWORD=
  DOMAIN=
  SERVER=
  PORT=
  RESOLUTION=
  GEOMETRY=
  BPP=
  NAMEDIR=
  DIR=
  [ -n "$LOGIN" ] && until xdotool search "xfreerdp-gui" windowactivate key Right Tab 2>/dev/null ; do sleep 0.05; done &
    FORMULARY=$(yad --center --width=380 \
        --window-icon="gtk-execute" --image="debian-logo" --item-separator=","                                      \
        --title "xfreerdp-gui"                                                                                      \
        --form                                                                                                      \
        --field="Server" $SERVER "academico.terminal.ufsc.br"                                                       \
        --field="Port" $PORT "3389"                                                                                 \
        --field="Domain" $DOMAIN ""                                                                                 \
        --field="User name" $LOGIN "USER@ufsc.br"                                                                   \
        --field="Password ":H $PASSWORD ""                                                                          \
        --field="Resolution":CBE $RESOLUTION "$wxh,640x480,720x480,800x600,1024x768,1280x1024,1600x1200,1920x1080," \
        --field="BPP":CBE $BPP "24,16,32,"                                                                          \
        --field="Name of Shared Directory" $NAMEDIR "Shared"                                                        \
        --field="Shared Directory" $DIR $HOME/Downloads                                                             \
        --field="Full Screen":CHK $varFull                                                                          \
        --field="Show Log":CHK $varLog)
    [ $? != 0 ] && exit
    SERVER=$(echo $FORMULARY     | awk -F '|' '{ print $1 }')
    PORT=$(echo $FORMULARY       | awk -F '|' '{ print $2 }')
    DOMAIN=$(echo $FORMULARY     | awk -F '|' '{ print $3 }')
    LOGIN=$(echo $FORMULARY | awk -F '|' '{ print $4 }')
    PASSWORD=$(echo $FORMULARY   | awk -F '|' '{ print $5 }')
    RESOLUTION=$(echo $FORMULARY | awk -F '|' '{ print $6 }')
    BPP=$(echo $FORMULARY        | awk -F '|' '{ print $7 }')
    NAMEDIR=$(echo $FORMULARY    | awk -F '|' '{ print $8 }')
    DIR=$(echo $FORMULARY        | awk -F '|' '{ print $9 }')
    varFull=$(echo $FORMULARY    | awk -F '|' '{ print $10 }')
    if [ "$varFull" = "TRUE" ]; then
        GEOMETRY="/f"
    else
        GEOMETRY=""
    fi
    varLog=$(echo $FORMULARY | awk -F '|' '{ print $11 }')
    
    RES=$(xfreerdp                            \
                    /v:"$SERVER":$PORT        \
                    /cert-ignore              \
                    /t:"$SERVER"              \
                    /sec-tls $GEOMETRY        \
                    /plugin cliprdr           \
                    /d:"$DOMAIN"              \
                    /u:"$LOGIN"               \
                    /p:"$PASSWORD"            \
                    /bpp:$BPP                 \
                    /size:$RESOLUTION         \
                    /vc:rdpsnd,sys:alsa       \
                    /dvc:tsmf,sys:alsa        \
                    /decorations /window-drag \
                    /drive:$NAMEDIR,$DIR      \
                    /compression /drive:$DIR  \
                    /kbd:0x00010416           \
                    +compression +clipboard -menu-anims +fonts 2>&1)
                    
    echo $RES | grep -q "Authentication failure" && \
    yad --center --image="error" --window-icon="error" --title "Authentication failure" \
    --text="<b>Could not authenticate to server\!</b>\n\n<i>Please check your password.</i>" \
    --text-align=center --width=320 --button=gtk-ok --buttons-layout=spread && \
    continue 
    
    echo $RES | grep -q "connection failure" && \
    yad --center --image="error" --window-icon="error" --title "Connection failure" \
    --text="<b>Could not connect to the server\!</b>\n\n<i>Please check the network connection.</i>" \
    --text-align=center --width=320 --button=gtk-ok --buttons-layout=spread
    
    if [ "$varLog" = "TRUE" ]; then
        yad --text "$RES" --title "Log of Events" --width=600 --wrap --no-buttons
    fi
    
done
