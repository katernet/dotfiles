#!/bin/bash
#
# Clone bootable backup
# To be run as root
# Requires rsync 3
# Adapted from http://nicolasgallagher.com/mac-osx-bootable-backup-drive-with-rsync

dst="/Volumes/Backup" 	# Destination disk
src="/"                 # Source
mnt=0 			# 1: Mount disk and unmount when finished | 0: No mount/unmount

# Disk mounter
mount() {
	dName=$(basename "$dst")
	if [ $mnt = 1 ]; then
		case "$1" in
		attach)
			# Mount backup disk if not mounted
			if [ ! -d "$dst" ]; then
				diskutil mount "$dName"
			fi
			;;
		detach)
			# Unmount backup disk if mounted
			if [ -d "$dst" ]; then
				# Wait until disk unmount succeeds
				while ! diskutil unmount "$dName" 2>/dev/null; do
					true
				done
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

# Excludes
files=(
	.DocumentRevisions-V*
	.fseventsd
	.hotfiles.btree
	.Spotlight-V*/
	.TemporaryItems
	.Trashes
	/.vol/*
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
for f in "${files[@]}"; do
	excludes+=(--exclude "$f")
done

echo "Start clone..."

# Clone
# --acls 		Update the destination ACLs to be the same as the source ACLs
# --archive 		Turn on archive mode (recursive copy + retain attributes)
# --delete 		Delete any files that have been deleted locally
# --delete-excluded 	Delete any files (on dst) that are part of the list of excluded files
# --exclude		Exclude files matching pattern
# --hard-links 		Preserve hard-links
# --info=progress2 	Progress of transfer
# --one-file-system 	Don't cross device boundaries (ignore mounted volumes)
# --sparse 		Handle sparse files efficiently
# --xattrs 		Update the remote extended attributes to be the same as the local ones

rsync --acls \
      --archive \
      --delete \
      --delete-excluded \
      "${excludes[@]}" \
      --hard-links \
      --info=progress2 \
      --one-file-system \
      --sparse \
      --xattrs \
      "$src" "$dst"

echo "Finished clone"

# Turn off Time Machine on clone
plutil -replace AutoBackup -bool false "$dst"/Library/Preferences/com.apple.TimeMachine.plist

# Set disk as bootable
if bless --info "$dst" | grep -q "No Blessed System Folder"; then # Test if not bootable
	sudo bless -folder "$dst"/System/Library/CoreServices
	[ $? = 0 ] && echo "Clone: Set disk $dName as bootable" || echo "Clone: Failed to set disk $dName as bootable" 1>&2
fi

mount detach
