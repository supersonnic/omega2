#------------------------------------------------------------
# Author: Shervin Oloumi - 10/06/2017 -----------------------
# Script for setting up SD boot on Omega2 -------------------
#------------------------------------------------------------

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

printf "\n${GREEN}Installing kmod...${NC}\n"
opkg update
#opkg upgrade
opkg install kmod-usb-storage-extras e2fsprogs kmod-fs-ext4

printf "\n${GREEN}Formatting the SD card...${NC}\n"
umount /mnt/mmcblk0p1
mkfs.ext4 /dev/mmcblk0p1

printf "\n${GREEN}Mounting the SD card...${NC}\n" 
mkdir /mnt/mmcblk0p1
mount /dev/mmcblk0p1 /mnt/mmcblk0p1

printf "\n${GREEN}Duplicating the overlay directory...${NC}\n"
tar -C /overlay -cf - . | tar -C /mnt/mmcblk0p1 -xf -
umount /mnt/mmcblk0p1/

printf "\n${GREEN}Finishing up...${NC}\n"
#opkg install block-mount
block detect > /etc/config/fstab
block detect > /etc/config/fstab
sed -i '/enabled/s/0/1/g' /etc/config/fstab
sed -i 's/mnt\/mmcblk0p1/overlay/g' /etc/config/fstab
printf "\n${RED}DONE! Now reboot the system!${NC}\n"
