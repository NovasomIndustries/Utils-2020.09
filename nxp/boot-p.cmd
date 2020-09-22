# default values
setenv kernel_addr 	"0x10800000"
setenv ramdisk_addr 	"0x14800000"
setenv fdt_addr 	"0x18000000"
setenv script_addr 	"0x12000000"
setenv rdsize		"128000"
setenv consoleargs 	"console=ttymxc2,115200"
setenv mmcdev 		"0"
setenv mmcpart 		"1"
setenv rootdev 		"/dev/ram rootwait rw"
setenv disp_mode 	"1920x1080m60,if=RGB24,bpp=32"
setenv disp_dev 	"mxcfb0:dev=hdmi"

echo "NOVAsom P Boot script loaded from mmc ${mmcdev}:${mmcpart}"
if fatload mmc ${mmcdev}:${mmcpart} ${script_addr} uEnv.txt; then
	env import -t ${script_addr} ${filesize}
	echo "NOVAsom P uEnv.txt file loaded from mmc ${mmcdev}:${mmcpart}"
fi

setenv extraparams "coherent_pool=2M cma=256M@2G rd.dm=0 rd.luks=0 rd.lvm=0 raid=autodetect pci=nomsi vt.global_cursor_default=0"
setenv bootargs "root=${rootdev} ramdisk_size=${rdsize} ${consoleargs} consoleblank=0 video=${disp_dev},${disp_mode} ${extraparams}"

fatload mmc ${mmcdev}:${mmcpart} ${kernel_addr} ${image}
fatload mmc ${mmcdev}:${mmcpart} ${ramdisk_addr} ${initrd}
fatload mmc ${mmcdev}:${mmcpart} ${fdt_addr} ${fdt_file}

bootz ${kernel_addr} ${ramdisk_addr} ${fdt_addr}

# Recompile with:
# mkimage -C none -A arm -T script -d boot-p.cmd /tmp/boot.scr

