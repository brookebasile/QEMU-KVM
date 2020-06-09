#!/bin/sh
qemu-img create -f raw -o preallocation=full w10.img 120G
