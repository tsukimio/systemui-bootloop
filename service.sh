#!/system/bin/sh
#SystemUI bootloop saver by n3rd3x3, huge thanks to HuskyDG

MODDIR=${0%/*}
FILE="$0"; NAME="$1"; VALUE="$2"; MODID="/data/adb/modules/systemui-bootloop"; VX="$@"
abort(){ echo "$1"; exit 1; }

# based on canyie dreamland framework script


write_log(){ 
TEXT=$@; echo "[`date +%d%m%y` `date +%T`]: $TEXT" >>/cache/systemui-bootloop.log 
}

exit_log(){
write_log "$@"; exit 0;
}

disable_modules(){
write_log "SystemUI is having trouble, so disable all modules and restart"

list="$(find /data/adb/modules/* -prune -type d)"
IFS=$"
"
for module in $list; do
echo -n >> $module/disable
done
reboot
exit
}



rm -rf /cache/systemui-bootloop.log.bak
mv -f /cache/systemui-bootloop.log /cache/systemui-bootloop.log.bak 2>/dev/null
write_log "systemui bootloop saver started"
SYSTEMUI_NICENAME=systemui

while [ "$(getprop sys.boot_completed)" != 1 ]; then sleep 1

SYSTEMUI_PID1=$(pgrep  "$SYSTEMUI_NICENAME" | awk '{ print $1 '})
write_log "pid of systemui stage 1: $SYSTEMUI_PID1"
sleep 15
SYSTEMUI_PID2=$(pgrep "$SYSTEMUI_NICENAME" | awk '{ print $1 '})
write_log "pid of systemui stage 2: $SYSTEMUI_PID2"
sleep 15
SYSTEMUI_PID3=$(pgrep "$SYSTEMUI_NICENAME" | awk '{ print $1 '})
write_log "pid of systemui stage 3: $SYSTEMUI_PID3"


if [ "$SYSTEMUI_PID1" = "$SYSTEMUI_PID2" ] && [ "$SYSTEMUI_PID2" = "$SYSTEMUI_PID3" ]; then
    if [ -z "$SYSTEMUI_PID1" ]; then
        write_log "rip systemui, disabling modules"
        disable_modules
    else
        exit_log "pid of 3rd stage systemui is the same"
    fi
else
    write_log "pid of 3rd stage systemui is different, continue check to make sure... "
fi




sleep 15
SYSTEMUI_PID4=$(pgrep "$SYSTEMUI_NICENAME" | awk '{ print $1 '})
write_log "pid of systemui stage 4: $SYSTEMUI_PID4"
[ "$SYSTEMUI_PID3" = "$SYSTEMUI_PID4" ] && exit_log "pid of systemui stage 3 and 4 is the same."

disable_modules

