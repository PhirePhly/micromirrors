#!/bin/bash
# MicroMirror Interlocked Update Script
# Kenneth Finnegan, 2022
#
# If run without arguments, assumes you want all projects updated
# If run with arguments, parse them as the invoke from mqtt-exec

UPSTREAM="mirror.fcix.net"
LOGDIR="/var/log/mirror"



PROJECT=""
FLOCK_ARGS=""

if [[ -z $1 ]]; then
	PROJECT="all"
	FLOCK_ARGS="-w 5"
elif [[ $1 = "all" ]]; then
	PROJECT="all"
elif [[ $1 = "rsync/$UPSTREAM/almalinux" ]]; then
	PROJECT="almalinux"
elif [[ $1 = "rsync/$UPSTREAM/archlinux" ]]; then
	PROJECT="archlinux"
elif [[ $1 = "rsync/$UPSTREAM/centos" ]]; then
	PROJECT="centos"
elif [[ $1 = "rsync/$UPSTREAM/centos-altarch" ]]; then
	PROJECT="centos-altarch"
elif [[ $1 = "rsync/$UPSTREAM/centos-stream" ]]; then
	PROJECT="centos-stream"
elif [[ $1 = "rsync/$UPSTREAM/epel" ]]; then
	PROJECT="epel"
elif [[ $1 = "rsync/$UPSTREAM/manjaro" ]]; then
	PROJECT="manjaro"
elif [[ $1 = "rsync/$UPSTREAM/opensuse" ]]; then
	PROJECT="opensuse"
elif [[ $1 = "rsync/$UPSTREAM/rocky" ]]; then
	PROJECT="rocky"
else
	# We don't understand the project invoked
	exit 1
fi

LOGFILE="$LOGDIR/mirror.`date '+%Y%m%d%H%M%S'`.$PROJECT.log"

exec 1>$LOGFILE
exec 2>&1

update_almalinux() {
	exec {lock_fd}>/run/lock/mirror.almalinux
	flock $FLOCK_ARGS "$lock_fd" || return
	echo "Updating Alma Linux"
	sleep 30
	echo "Done updating Alma Linux"
	flock -u "$lock_fd"
}


{% if "almalinux" in hostedprojects %}
if [[ $PROJECT = "all" ]] || [[ $PROJECT = "almalinux" ]]; then
	update_almalinux
fi

{% endif %}
