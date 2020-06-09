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
        -drive file=w10.img,index=0,media=disk,format=raw,if=virtio,aio=native,cache.direct=on \
        -device virtio-net,netdev=vmnic -netdev user,id=vmnic \
        -soundhw hda \
        -usb \
	-vga qxl \
	-net nic -net user,smb=/home/sleepy/hdd/vmshare \
        -chardev socket,path=/tmp/qga.sock,server,nowait,id=qga0 \
        -device virtio-serial \
        -device virtserialport,chardev=qga0,name=org.qemu.guest_agent.0 \
        -spice port=${SPICE_PORT},disable-ticketing -soundhw hda \
        -device virtio-serial -chardev spicevmc,id=vdagent,debug=0,name=vdagent \
        -device virtserialport,chardev=vdagent,name=com.redhat.spice.0 \
	-device usb-tablet \
        -device vfio-pci,sysfsdev=/sys/bus/mdev/devices/746afefa-89af-481d-ad4e-52e0d9f5f2e6  
	"$@"
exec remote-viewer --title Windows spice://127.0.0.1:${SPICE_PORT}
