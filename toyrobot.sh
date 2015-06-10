#!/usr/bin/env bash
x=0;y=0;
nx=0;ny=0;
facing=0;
placed=0;
NORTH=0;EAST=1;SOUTH=2;WEST=3;
DIRS=("NORTH" "EAST" "SOUTH" "WEST");
NUMDIRS=$((${#DIRS[@]}-1))

newmove () {
  nx=$x;
  ny=$y;
  case $facing in
    0) ny=$((y+1));;
    1) nx=$((x+1));;
    2) ny=$((y-1));;
    3) nx=$((x-1));;
  esac;
}

ontable () {
  (( nx >= 0 && ny >= 0 && nx < 5 && ny < 5 ));
}

left () {
  (( facing == 0 )) && facing=NUMDIRS || facing=$((facing-1))
}

right () {
  (( facing == NUMDIRS )) && facing=0 || facing=$((facing+1))
}

move () {
  newmove && ontable && x=$nx && y=$ny;
}

place () {
  ontable && x=$nx && y=$ny && placed=1;
}

report () {
  (( placed == 1 )) && echo "$x,$y,${DIRS[facing]}";
}

usage () {
  echo "usage: ./toyrobot.sh comannds.txt";
  exit 1;
}

[[ -f $1 ]] && input=$1 || input=/dev/stdin;
while read
do
  case $REPLY in
    'MOVE') move;;
    'LEFT') left;;
    'RIGHT') right;;
    'REPORT') report;;
    *) [[ $REPLY =~ ^PLACE' '([[:digit:]]),([[:digit:]]),(NORTH|EAST|SOUTH|WEST)$ ]] \
        && nx=${BASH_REMATCH[1]} && ny=${BASH_REMATCH[2]} \
        && facing=${!BASH_REMATCH[3]} && place;;
  esac
done <$input
