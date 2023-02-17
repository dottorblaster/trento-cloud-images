ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

build:
	sudo kiwi-ng system build \
	    --description . \
	    --set-repo obs://openSUSE:Leap:15.4/standard \
	    --target-dir ./target
	sudo chmod -R 777 target/*

run:
	qemu-system-x86_64 -boot c -drive file=$(ROOT_DIR)/target/kiwi-test-image-disk.x86_64-1.15.3.raw,format=raw,if=virtio -m 4096 -serial stdio

clean:
	rm -rf target
