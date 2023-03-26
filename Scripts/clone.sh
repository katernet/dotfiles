#!/bin/bash
#
# Clone a backup using Carbon Copy Cloner command line

disk='Backup' 		# Set the name of your backup disk
task='CCC Backup Task'  # Create a backup task in CCC GUI

diskutil mountDisk $disk
sleep 5 # Wait for disk to mount

/Applications/Carbon\ Copy\ Cloner.app/Contents/MacOS/ccc --start=$task

if [ ! -f /Volumes/$disk/.metadata* ]; then
	touch /Volumes/$disk/.metadata_never_index_unless_rootfs # Prevent Spotlight indexing disk
fi

diskutil unmountDisk $disk
