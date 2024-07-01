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
RSYNC_ARGS=(-avSH '--filter=R .~tmp~' --delete-delay --fuzzy --delay-updates --bwlimit=25M --timeout=600)

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
{% if "cvebin" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/cvebin" ]]; then
	PROJECT="cvebin"
{% endif %}
{% if "epel" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/fedora" ]]; then
	PROJECT="fedora"
{% endif %}
{% if "epel-amd64" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/fedora" ]]; then
	PROJECT="fedora"
{% endif %}
{% if "fdroid-repo" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/fdroid" ]]; then
	PROJECT="fdroid"
{% endif %}
{% if "fedora" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/fedora" ]]; then
	PROJECT="fedora"
{% endif %}
{% if "fedora-amd64" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/fedora" ]]; then
	PROJECT="fedora"
{% endif %}
{% if "gimp" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/gimp" ]]; then
	PROJECT="gimp"
{% endif %}
{% if "kali-images" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/kali-images" ]]; then
	PROJECT="kali-images"
{% endif %}
{% if "kdeftp-stable" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/kde" ]]; then
	PROJECT="kdeftp"
{% endif %}
{% if "linuxmint-images" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/linuxmint-images" ]]; then
	PROJECT="linuxmint-images"
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
{% if "rpmfusion-nonfree" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/rpmfusion" ]]; then
	PROJECT="rpmfusion"
{% endif %}
{% if "tdf" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/tdf" ]]; then
	PROJECT="tdf"
{% endif %}
{% if "ubuntu" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/ubuntu" ]]; then
	PROJECT="ubuntu"
{% endif %}
{% if "ubuntu-releases" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/ubuntu-releases" ]]; then
	PROJECT="ubuntu-releases"
{% endif %}
{% if "videolan" in hostedprojects %}
elif [[ $1 = "rsync/$UPSTREAM/videolan" ]]; then
	PROJECT="videolan"
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
	find /data/mirror/archlinux/ -type d -name ".~tmp~" -exec rm -rf {} +
	rsync -avSH --delete-delay --fuzzy --delay-updates --bwlimit=10M --timeout=600 rsync://$UPSTREAM/archlinux/ /data/mirror/archlinux/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "archlinux" ]]; then
	update_archlinux
fi

{% endif %}
{% if "cvebin" in hostedprojects %}
update_cvebin() {
	exec {lock_fd}>$LOCKDIR/mirror.cvebin
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING CVEBIN ###\n"
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/cvebin/ /data/mirror/cvebin/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "cvebin" ]]; then
	update_cvebin
fi

{% endif %}
{% if "epel" in hostedprojects %}
update_epel() {
	exec {lock_fd}>$LOCKDIR/mirror.epel
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING EPEL ###\n"
	find /data/mirror/epel/ -type d -name ".~tmp~" -exec rm -rf {} +
	rsync -avSH --fuzzy --delete-delay --delay-updates --exclude '**/source/**' --exclude '**/s390x/**' --exclude '**/playground/**' --exclude '**/debug/**' --delete-excluded --bwlimit=25M --timeout=600 rsync://$UPSTREAM/fedora-epel/ /data/mirror/epel/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "fedora" ]]; then
	update_epel
fi

{% endif %}
{% if "epel-amd64" in hostedprojects %}
update_epel() {
	exec {lock_fd}>$LOCKDIR/mirror.epel
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING EPEL ###\n"
	find /data/mirror/epel/ -type d -name ".~tmp~" -exec rm -rf {} +
	rsync -avSH --fuzzy --delete-delay --delay-updates --exclude '**/source/**' --exclude '**/armhfp/**' --exclude '**/aarch64/**' --exclude '**/ppc64/**' --exclude '**/ppc64le/**' --exclude '**/s390x/**' --exclude '**/testing/**' --exclude '**/playground/**' --exclude '**/next/**' --exclude '**/debug/**' --delete-excluded --bwlimit=25M --timeout=600 rsync://$UPSTREAM/fedora-epel/ /data/mirror/epel/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "fedora" ]]; then
	update_epel
fi

{% endif %}
{% if "fdroid-repo" in hostedprojects %}
update_fdroid-repo() {
	exec {lock_fd}>$LOCKDIR/mirror.fdroid
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING FDROID ###\n"
	mkdir -p /data/mirror/fdroid
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/fdroid/repo/ /data/mirror/fdroid/repo/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "fdroid" ]]; then
	update_fdroid-repo
fi

{% endif %}
{% if "fedora" in hostedprojects %}
update_fedora() {
	exec {lock_fd}>$LOCKDIR/mirror.fedora
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING FEDORA ###\n"
	find /data/mirror/fedora/ -type d -name ".~tmp~" -exec rm -rf {} +
	rsync -avSH --fuzzy --delete-delay --delay-updates --exclude '**/source/**' --exclude '**/debug/**' --delete-excluded --bwlimit=25M --timeout=600 rsync://$UPSTREAM/fedora-enchilada0/ /data/mirror/fedora/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "fedora" ]]; then
	update_fedora
fi

{% endif %}
{% if "fedora-amd64" in hostedprojects %}
update_fedora() {
	exec {lock_fd}>$LOCKDIR/mirror.fedora
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING FEDORA AMD64 ###\n"
	find /data/mirror/fedora/ -type d -name ".~tmp~" -exec rm -rf {} +
	rsync -avSH --fuzzy --delete-delay --delay-updates --exclude '**/source/**' --exclude '**/armhfp/**' --exclude '**/aarch64/**' --exclude '**/debug/**' --exclude '**/test/**' --exclude '**/testing/**' --exclude '**/Spins/**' --exclude '**/Kinoite/**' --exclude '**/Sericea/**' --exclude '**/Silverblue/**' --delete-excluded --bwlimit=25M --timeout=600 rsync://$UPSTREAM/fedora-enchilada0/ /data/mirror/fedora/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "fedora" ]]; then
	update_fedora
fi

{% endif %}
{% if "gimp" in hostedprojects %}
update_gimp() {
	exec {lock_fd}>$LOCKDIR/mirror.gimp
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING GIMP ###\n"
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/gimp/ /data/mirror/gimp/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "gimp" ]]; then
	update_gimp
fi

{% endif %}
{% if "kali-images" in hostedprojects %}
update_kali_images() {
	exec {lock_fd}>$LOCKDIR/mirror.kali-images
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING KALI-IMAGES ###\n"
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/kali-images/ /data/mirror/kali-images/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "kali-images" ]]; then
	update_kali_images
fi

{% endif %}
{% if "kdeftp-stable" in hostedprojects %}
update_kdeftp_stable() {
	exec {lock_fd}>$LOCKDIR/mirror.kdeftp
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING KDEFTP ###\n"
	mkdir -p /data/mirror/kdeftp/stable
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/kdeftp/last-updated /data/mirror/kdeftp/last-updated
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/kdeftp/stable/ /data/mirror/kdeftp/stable/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "kdeftp" ]]; then
	update_kdeftp_stable
fi

{% endif %}
{% if "linuxmint-images" in hostedprojects %}
update_linuxmint_images() {
	exec {lock_fd}>$LOCKDIR/mirror.linuxmint-images
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING LINUXMINT IMAGES ###\n"
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/linuxmint-images/ /data/mirror/linuxmint-images/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "linuxmint-images" ]]; then
	update_linuxmint_images
fi

{% endif %}
{% if "manjaro" in hostedprojects %}
update_manjaro() {
	exec {lock_fd}>$LOCKDIR/mirror.manjaro
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING MANJARO ###\n"
	find /data/mirror/manjaro/ -type d -name ".~tmp~" -exec rm -rf {} +
	rsync -avSH --delete-delay --fuzzy --delay-updates --bwlimit=10M --timeout=600 rsync://$UPSTREAM/manjaro/ /data/mirror/manjaro/
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
	rsync -avSH --fuzzy '--filter=R .~tmp~' --no-links --delay-updates --bwlimit=25M --timeout=600 rsync://$UPSTREAM/opensuse/tumbleweed/ /data/mirror/opensuse/tumbleweed/
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
	rsync --recursive --fuzzy -v --times --links --safe-links --hard-links --stats --exclude 'Packages*' --exclude 'Sources*' --exclude 'Release*' --exclude 'InRelease' --timeout=600 rsync://$UPSTREAM/raspbian/ /data/mirror/raspbian/
	rsync --recursive -v --times --links --safe-links --hard-links --stats --delete --delete-after --timeout=600 rsync://$UPSTREAM/raspbian/ /data/mirror/raspbian/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "raspbian" ]]; then
	update_raspbian
fi

{% endif %}
{% if "rpmfusion-nonfree" in hostedprojects %}
update_rpmfusion_nonfree() {
	exec {lock_fd}>$LOCKDIR/mirror.rpmfusion
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING RPMFUSION NONFREE ###\n"
	mkdir -p /data/mirror/rpmfusion/nonfree
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/rpmfusion/nonfree/ /data/mirror/rpmfusion/nonfree/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "rpmfusion" ]]; then
	update_rpmfusion_nonfree
fi

{% endif %}
{% if "tdf" in hostedprojects %}
update_tdf() {
	exec {lock_fd}>$LOCKDIR/mirror.tdf
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING THE DOCUMENT FOUNDATION ###\n"
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/tdf-pub/ /data/mirror/tdf/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "tdf" ]]; then
	update_tdf
fi

{% endif %}
{% if "ubuntu" in hostedprojects %}
update_ubuntu() {
	exec {lock_fd}>$LOCKDIR/mirror.ubuntu
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING UBUNTU ###\n"
	rsync  -v --recursive --times --links --safe-links --hard-links --stats --exclude "Packages*" --exclude "Sources*" --exclude "Release*" --exclude "InRelease" --bwlimit=25M rsync://$UPSTREAM/ubuntu/ /data/mirror/ubuntu/ &&\
	rsync -v --recursive --times --links --safe-links --hard-links --stats --delete --delete-after --bwlimit=25M rsync://$UPSTREAM/ubuntu/ /data/mirror/ubuntu/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "ubuntu" ]]; then
	update_ubuntu
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
{% if "videolan" in hostedprojects %}
update_videolan() {
	exec {lock_fd}>$LOCKDIR/mirror.videolan
	flock $FLOCK_ARGS "$lock_fd" || return
	echo -e "\n\n### UPDATING VIDEOLAN-FTP ###\n"
	rsync "${RSYNC_ARGS[@]}" rsync://$UPSTREAM/videolan-ftp/ /data/mirror/videolan-ftp/
	sleep 10
	flock -u "$lock_fd"
}

if [[ $PROJECT = "all" ]] || [[ $PROJECT = "videolan" ]]; then
	update_videolan
fi

{% endif %}

