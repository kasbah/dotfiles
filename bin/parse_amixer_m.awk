BEGIN { FS="["; OFS=""}
#/Front Left:/ {left_vol= substr($2,1,length($2) - 3)}
/Front Left:/ {left_on= substr($4,1,length($4) - 1)}
#/Front Right:/ {right_vol= substr($2,1,length($2) - 2); right_on= substr($4,1,length($4) - 1)}
END {print left_on}
#END {print "Sound: left-", left_vol, left_on, "  right-" right_vol, right_on}
