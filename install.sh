#!/bin/bash

sleep 30
mkdir -p /drive1
mount /drive1
# Check that the disk is attached
mountpoint /drive1
if [ $? -ne 0 ]; then # The data disk is not mounted at drive1

    echo "mounted drive not found at /drive1"
    # lets first try to manually mount it
    mount /dev/disk/azure/scsi1/lun0 /drive1
    if [ $? -ne 0 ]; then # Manual mount failed. Let's format it
        mkfs.ext4 -F /dev/disk/azure/scsi1/lun0
        date > /drive1/formattime
    fi
    echo "/dev/disk/azure/scsi1/lun0 /drive1 ext4 defaults,nofail 0 2" >> /etc/fstab
    mount /drive1
fi

#check if the systemd module is there
if [ ! -f /etc/systemd/system/multi-user.target.wants/simpleserver.service ]; then
    cp simpleserver.service /etc/systemd/system/
    systemctl enable simpleserver.service
fi

systemctl start simpleserver.service

