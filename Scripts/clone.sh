#!/bin/bash
#
# Clone bootable backup
# To be run as root
# Requires rsync 3
# Adapted from http://nicolasgallagher.com/mac-osx-bootable-backup-drive-with-rsync

dst="/Volumes/Backup/" 	# Destination disk
src="/" 		# Source
mnt=0 			# 1: Mount disk and unmount when finished / 0: No mount/unmount

# Disk mounter
mount() {
	if [ $mnt = 1 ]; then
		case "$1" in
		attach)
			# Mount backup disk if not mounted
			if [ ! -d "$dst" ]; then
				diskutil mount $(basename "$dst")
			fi
			;;
		detach)
			# Unmount backup disk if mounted
			if [ -d "$dst" ]; then
        			diskutil unmount $(basename "$dst")
			fi
			;;
		esac
	fi
}

mount attach

# Checks
if [ ! -r "$src" ]; then
	echo "Clone: Source $src not readable - Cannot start the sync process" 1>&2
	exit 1
fi
if [ ! -w "$dst" ]; then
	echo "Clone: Destination $dst not writeable - Cannot start the sync process" 1>&2
	exit 1
fi

# Clone
# --acls 		Update the destination ACLs to be the same as the source ACLs
# --archive 		Turn on archive mode (recursive copy + retain attributes)
# --delete 		Delete any files that have been deleted locally
# --delete-excluded 	Delete any files (on dst) that are part of the list of excluded files
# --hard-links 		Preserve hard-links
# --info=progress2 	Progress of transfer
# --one-file-system 	Don't cross device boundaries (ignore mounted volumes)
# --sparse 		Handle sparse files efficiently
# --xattrs 		Update the remote extended attributes to be the same as the local ones

# Excludes
files=(
	.Spotlight-*/
	.Trashes
	/afs/*
	/automount/*
	/cores/*
	/dev/*
	/Network/*
	/private/tmp/*
	/private/var/run/*
	/private/var/spool/postfix/*
	/private/var/vm/*
	"/Previous Systems.localized"
	/tmp/*
	/Volumes/*
	*/.Trash
)
excludes=()
for f in "${files[@]}"; do
	excludes+=(--exclude "$f")
done

echo "Start rsync"

rsync --acls \
	--archive \
	--delete \
	--delete-excluded \
	"${excludes[@]}" \
	--hard-links \
	--one-file-system \
	--sparse \
	--xattrs \
	"$src" "$dst"

echo "End rsync"

# Set disk as bootable
if bless --info "$dst" | grep -q "No Blessed System Folder"; then # Test if not bootable
	sudo bless -folder "$dst"/System/Library/CoreServices
	echo "Disk $dst set as bootable"
fi

mount detach
