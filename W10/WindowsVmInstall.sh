#!/bin/sh
SPICE_PORT=3001
qemu-system-x86_64 \
	-enable-kvm \
	-daemonize \
	-object rng-random,filename=/dev/random,id=rng0 \
	-device virtio-rng-pci,rng=rng0 \
	-machine type=q35,accel=kvm \
	-m 16G,slots=2,maxmem=32G \
	-cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
	-smp 4 \
	-vga qxl \
	-drive file=w10.img,index=0,media=disk,if=virtio,format=raw \
	-drive file=18362.1.190318-1202.19H1_RELEASE_CLIENTENTERPRISE_VOL_X64FRE_EN-US.ISO,index=2,media=cdrom \
	-drive file=virtio-win-0.1.173.iso,index=3,media=cdrom \
	-device virtio-net,netdev=vmnic -netdev user,id=vmnic \
	-soundhw all \
	-usb \
	-device usb-tablet \
	-chardev socket,path=/tmp/qga.sock,server,nowait,id=qga0 \
	-device virtio-serial \
	-device virtserialport,chardev=qga0,name=org.qemu.guest_agent.0 
