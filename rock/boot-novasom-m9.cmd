setenv load_addr "0x09000000"
# default values
pxefile_addr_r=0x00600000
setenv kernel_addr_r 0x02080000
setenv ramdisk_addr_r 0x04000000
setenv fdt_addr_r 0x01f00000
setenv rootdev "/dev/ram"
setenv fdtfile "dtb.dtb"
setenv consoleargs "console=ttyFIQ0,115200 tty1"
setenv bootdev "mmc 1:1"

echo "NOVAsom M9 Boot script loaded from ${devtype} ${devnum}"

setenv bootargs "root=${rootdev} rootwait ramdisk_size=512000 ${consoleargs} consoleblank=0 earlycon=ttyS2,115200 ${mac}"

load ${bootdev} ${ramdisk_addr_r} uInitrd
load ${bootdev} ${kernel_addr_r} Image
load ${bootdev} ${fdt_addr_r} ${fdtfile}
booti ${kernel_addr_r} ${ramdisk_addr_r} ${fdt_addr_r}

# Recompile with:
# mkimage -C none -A arm -T script -d boot-novasom-m7.cmd boot.scr

