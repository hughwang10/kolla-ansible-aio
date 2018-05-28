#!/bin/sh
### BEGIN EXPANDISK INFO
# Provides:          Expand the 1st disk partition to availbale disk space (assumes only one partition)
# Required-Start:    
# Description:       Resizes disk partition to available disk space, resize of file system happens automatically after reboot required by this function
### END EXPANDISK INFO

arg1=$1""

if [ "$arg1" == "ts" ]
then
  dev=$(mount | grep --regexp='^/dev/[a-z]+[0-9]+\s+[a-zA-Z]\s+/boot')
#  echo "$dev"
#  echo "$dev" | grep --regexp='^/dev/[a-z]+[0-9]+\s+[a-zA-Z]\s+/boot' | awk '{ if(NR==1) gsub("[0-9]",""); printf("%s", "fdisk "$1" <<EOF\nd\n2\nn\np\n\n\n\nw\nEOF")}' | xargs -0 bash -c
#  echo "Now run partprobe:"
#  echo "$dev" | grep --regexp='^/dev/[a-z]\+[0-9]\+\s\+' | awk '{ if(NR==1) gsub("1","2"); printf("%s", "partprobe "$1"\n")}' | xargs -0 bash -c
#  echo "Now run pvresize:"
#  echo "$dev" | grep --regexp='^/dev/[a-z]\+[0-9]\+\s\+' | awk '{ if(NR==1) gsub("1","2"); printf("%s", "pvresize "$1"\n")}' | xargs -0 bash -c
#  echo "Now run lvresize:"
#  lvresize -l +100%FREE /dev/logs-volume/LVRoot
#  echo "And finally pvresize:"
#  resize2fs /dev/logs-volume/LVRoot
elif [ "$arg1" == "tsafter" ];
then
  dev=$(mount | grep --regexp='^/dev/[a-z]+[0-9]+\s+[a-zA-Z]\s+/boot')
#  echo "Now run pvresize:"
#  echo "$dev" | grep --regexp='^/dev/[a-z]+[0-9]+\s+' | awk '{ if(NR==1) gsub("1","2"); printf("%s", "pvresize "$1"\n")}' | xargs -0 bash -c
#  echo "Now run lvresize:"
#  lvresize -l +100%FREE /dev/logs-volume/LVRoot
#  echo "And finally pvresize:"
#  resize2fs /dev/logs-volume/LVRoot
else
mount | grep --regexp='^/dev/[a-z]*[0-9]*\W*on\W*/\W' | awk '{ if(NR==1) gsub("[0-9]",""); printf("%s", "fdisk "$1" <<EOF\nd\nn\np\n\n\n\na\n1\nw\nEOF")}' | xargs -0 bash -c
mount | grep --regexp='^/dev/[a-z]*[0-9]*\W*on\W*/\W' | awk '{ printf("%s", "partprobe "$1"\n")}' | xargs -0 bash -c
#  cat /etc/fstab | grep --regexp='^/dev/[a-z,0-9]*\W*'$2'\W' | awk '{ printf("%s", "growpart "$1)}' | xargs -0 bash -c
fi
#cat /etc/fstab | grep --regexp='^/dev/[a-z,0-9]*\W*'$2'\W' | awk '{ printf("%s", "growpart "$1)}' | xargs -0 bash -c
#mount | grep --regexp='^/dev/[a-z,0-9]*\W*on\W*'$1'\W' | awk '{ printf("%s", "fdisk "$1" <<EOF\nd\nn\np\n\n\n\na\n1\nw\nEOF")}' | xargs -0 bash -c


