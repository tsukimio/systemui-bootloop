ui_print "- Setting up module..."
unzip -o "$ZIPFILE" "saver.exec" -d "$MODPATH" &>/dev/null
chmod 750 "$MODPATH/saver.exec"
ui_print "- Module log is /cache/systemui-bootloop.log"
