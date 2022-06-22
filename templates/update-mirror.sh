#!/bin/bash
# MicroMirror Interlocked Update Script
# Kenneth Finnegan, 2022
#
# If run without arguments, assumes you want all projects updated
# If run with arguments, parse them as the invoke from mqtt-exec

UPSTREAM="mirror.fcix.net"
LOGDIR="/var/log/mirror"
LOCKDIR="/home/mirror/lock"


PROJECT=""
FLOCK_ARGS=""
RSYNC_ARGS=(-avSH '--filter=R .~tmp~' --delete-delay --delay-updates --bwlimit=25M)

find $LOGDIR -mtime +2 -name "*.log" -delete

if [[ -z $1 ]]; then
	# If run without arguments, update all projects but skip any that are locked
	PROJECT="all"
	FLOCK_ARGS="-w 5"
elif [[ $1 = "all" ]]; then
	PROJECT="all"
{% if "almalinux" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/almalinux" ]]; then
	PROJECT="almalinux"
{% endif %}
{% if "archlinux" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/archlinux" ]]; then
	PROJECT="archlinux"
{% endif %}
{% if "centos" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/centos" ]]; then
	PROJECT="centos"
{% endif %}
{% if "centos-altarch" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/centos-altarch" ]]; then
	PROJECT="centos-altarch"
{% endif %}
{% if "centos-stream" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/centos-stream" ]]; then
	PROJECT="centos-stream"
{% endif %}
{% if "epel" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/fedora" ]]; then
	PROJECT="fedora"
{% endif %}
{% if "fedora-amd64" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/fedora" ]]; then
	PROJECT="fedora"
{% endif %}
{% if "kdeftp-stable" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/kdeftp" ]]; then
	PROJECT="kdeftp"
{% endif %}
{% if "manjaro" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/manjaro" ]]; then
	PROJECT="manjaro"
{% endif %}
{% if "opensuse" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/opensuse" ]]; then
	PROJECT="opensuse"
{% endif %}
{% if "raspbian" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/raspbian" ]]; then
	PROJECT="raspbian"
{% endif %}
{% if "rocky" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/rocky" ]]; then
	PROJECT="rocky"
{% endif %}
{% if "ubuntu-releases" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/ubuntu-releases" ]]; then
	PROJECT="ubuntu-releases"
{% endif %}
else
	# We don't understand the project invoked
	exit 1
fi

LOGFILE="$LOGDIR/mirror.`date '+%Y%m%d%H%M%S'`.$PROJECT.log"

exec 1>$LOGFILE
exec 2>&1




{% if "almalinux" in hostedprojects %}
update_almalinux() {
	exec {lock_fd}>$LOCKDIR/mirror.almalinux
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING ALMA LINUX ###\n"
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/almalinux/ /data/mirror/almalinux/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "almalinux" ]]; then
	update_almalinux
fi

{% endif %}
{% if "archlinux" in hostedprojects %}
update_archlinux() {
	exec {lock_fd}>$LOCKDIR/mirror.archlinux
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING ARCH LINUX ###\n"
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/archlinux/ /data/mirror/archlinux/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "archlinux" ]]; then
	update_archlinux
fi

{% endif %}
{% if "centos" in hostedprojects %}
update_centos() {
	exec {lock_fd}>$LOCKDIR/mirror.centos
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING CENTOS ###\n"
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/centos/ /data/mirror/centos/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "centos" ]]; then
	update_centos
fi

{% endif %}
{% if "centos-altarch" in hostedprojects %}
update_centos-altarch() {
	exec {lock_fd}>$LOCKDIR/mirror.centos-altarch
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING CENTOS ALTARCH ###\n"
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/centos-altarch/ /data/mirror/centos-altarch/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "centos-altarch" ]]; then
	update_centos-altarch
fi

{% endif %}
{% if "centos-stream" in hostedprojects %}
update_centos-stream() {
	exec {lock_fd}>$LOCKDIR/mirror.centos-stream
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING CENTOS STREAM ###\n"
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/centos-stream/ /data/mirror/centos-stream/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "centos-stream" ]]; then
	update_centos-stream
fi

{% endif %}
{% if "epel" in hostedprojects %}
update_epel() {
	exec {lock_fd}>$LOCKDIR/mirror.epel
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING EPEL ###\n"
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/fedora-epel/ /data/mirror/epel/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "fedora" ]]; then
	update_epel
fi

{% endif %}
{% if "fedora-amd64" in hostedprojects %}
update_fedora() {
	exec {lock_fd}>$LOCKDIR/mirror.fedora
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING FEDORA AMD64 ###\n"
	rsync -avSH --delete-delay --delay-updates --exclude '**/source/**' --exclude '**/armhfp/**' --exclude '**/aarch64/**' --exclude '**/debug/**' --exclude '**/test/**' --exclude '**/testing/**' --delete-excluded --bwlimit=25M rsync://$UPSTREAM/fedora-buffet/fedora/ /data/mirror/fedora/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "fedora" ]]; then
	update_fedora
fi

{% endif %}
{% if "kdeftp-stable" in hostedprojects %}
update_kdeftp_stable() {
	exec {lock_fd}>$LOCKDIR/mirror.kdeftp
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING KDEFTP ###\n"
	mkdir -p /data/mirror/kdeftp/stable
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/kdeftp/stable/ /data/mirror/kdeftp/stable/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "kdeftp" ]]; then
	update_kdeftp_stable
fi

{% endif %}
{% if "manjaro" in hostedprojects %}
update_manjaro() {
	exec {lock_fd}>$LOCKDIR/mirror.manjaro
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING MANJARO ###\n"
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/manjaro/ /data/mirror/manjaro/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "manjaro" ]]; then
	update_manjaro
fi

{% endif %}
{% if "opensuse" in hostedprojects %}
update_opensuse() {
	exec {lock_fd}>$LOCKDIR/mirror.opensuse
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING OPENSUSE TUMBLEWEED ###\n"
	mkdir -p /data/mirror/opensuse/tumbleweed
	rsync -avSH '--filter=R .~tmp~' --no-links --delay-updates --bwlimit=25M rsync://$UPSTREAM/opensuse/tumbleweed/ /data/mirror/opensuse/tumbleweed/
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/opensuse/tumbleweed/ /data/mirror/opensuse/tumbleweed/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "opensuse" ]]; then
	update_opensuse
fi

{% endif %}
{% if "raspbian" in hostedprojects %}
update_raspbian() {
	exec {lock_fd}>$LOCKDIR/mirror.raspbian
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING RASPBIAN ###\n"
	rsync --recursive -v --times --links --safe-links --hard-links --stats --exclude 'Packages*' --exclude 'Sources*' --exclude 'Release*' --exclude 'InRelease' rsync://$UPSTREAM/raspbian/ /data/mirror/raspbian/
	rsync --recursive -v --times --links --safe-links --hard-links --stats --delete --delete-after rsync://$UPSTREAM/raspbian/ /data/mirror/raspbian/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "raspbian" ]]; then
	update_raspbian
fi

{% endif %}
{% if "rocky" in hostedprojects %}
update_rocky() {
	exec {lock_fd}>$LOCKDIR/mirror.rocky
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING ROCKY ###\n"
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/rocky/ /data/mirror/rocky/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "rocky" ]]; then
	update_rocky
fi

{% endif %}
{% if "ubuntu-releases" in hostedprojects %}
update_ubuntu_releases() {
	exec {lock_fd}>$LOCKDIR/mirror.ubuntu-releases
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING UBUNTU-RELEASES ###\n"
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/ubuntu-releases/ /data/mirror/ubuntu-releases/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "ubuntu-releases" ]]; then
	update_ubuntu_releases
fi

{% endif %}

