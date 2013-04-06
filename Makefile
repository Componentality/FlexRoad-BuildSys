TOPDIR:=         $(shell pwd)
CFGDIR:=         $(TOPDIR)/config

BINARY_OUT:=     ./out

top_intro:
	@echo please call directly with one of the following configurations:
	@echo
	@echo "make initramfs                  - initramfs image"
	@echo "make image TARGET=router        - BATMAN<->LAN router"
	@echo "make image TARGET=router-ppp    - BATMAN<->LAN<->UMTS router"
	@echo "make image TARGET=custom        - Build image with your own configuration"

-include config-$(TARGET).mk

ifeq ($(OPENWRT_RELEASE),backfire)
RELEASE:=  backfire
PACKAGES:= $(TOPDIR)/packages_backfire

# base .config files
ROOTFS_PRE_CONFIG:=bf-saha-rootfs_defconfig
INITRAMFS_PRE_CONFIG:=bf-saha-ramfs_defconfig

ROOTFS_IMAGE:=    openwrt-ar71xx-rootfs.tar.gz
KERNEL_IMAGE:=    openwrt-ar71xx-vmlinux.elf
INITRAMFS_IMAGE:= openwrt-ar71xx-vmlinux-initramfs.elf

else
RELEASE:=  attitude_adjustment
PACKAGES:= $(TOPDIR)/packages_attitude

#base .config files
ROOTFS_PRE_CONFIG:=aa-saha-rootfs_defconfig
INITRAMFS_PRE_CONFIG:=aa-saha-ramfs_defconfig

#images
ROOTFS_IMAGE:=    openwrt-ar71xx-nand-rootfs.tar.gz
KERNEL_IMAGE:=    openwrt-ar71xx-nand-vmlinux-lzma.elf
INITRAMFS_IMAGE:= openwrt-ar71xx-nand-vmlinux-initramfs.elf

endif

OPENWRT_AA:=     ./$(RELEASE)
OPENWRT_CONFIG:= $(OPENWRT_AA)/.config

FEED_CONF=       $(OPENWRT_AA)/feeds.conf.default

include $(CFGDIR)/saha.mk

$(BINARY_OUT):
	@mkdir -p $@

TARGET_DIR:=$(BINARY_OUT)/$(TARGET)

target-dir: $(BINARY_OUT)
	@mkdir -p $(TARGET_DIR)

$(INITRAMFS_IMAGE):
	@mkdir -p $(BINARY_OUT)/initramfs
	@cp $(OPENWRT_AA)/bin/ar71xx/$@ $(BINARY_OUT)/initramfs
	@chmod -x $(BINARY_OUT)/initramfs/$@
	@cp $(OPENWRT_AA)/bin/ar71xx/$@ $(BINARY_OUT)
	@chmod -x $(BINARY_OUT)/$@
	@echo $^ is ready, check $(BINARY_OUT) for image

$(ROOTFS_IMAGE): target-dir
	@cp $(OPENWRT_AA)/bin/ar71xx/$@ $(TARGET_DIR)
	@cp $(OPENWRT_AA)/bin/ar71xx/$@ $(BINARY_OUT)
	@echo $^ is ready, check $(BINARY_OUT) for image

$(KERNEL_IMAGE): target-dir
	@cp $(OPENWRT_AA)/bin/ar71xx/$@ $(TARGET_DIR)
	@chmod -x $(TARGET_DIR)/$@
	@cp $(OPENWRT_AA)/bin/ar71xx/$@ $(BINARY_OUT)
	@chmod -x $(BINARY_OUT)/$@
	@echo $^ is ready, check $(BINARY_OUT) for image

copy_initramfs: $(INITRAMFS_IMAGE)
copy_rootfs: $(KERNEL_IMAGE) $(ROOTFS_IMAGE)

prepare-base: 
	@mkdir -p $(BINARY_OUT)
	@mv $(FEED_CONF) $(FEED_CONF).orig
	@echo src-link packages $(PACKAGES) > $(FEED_CONF)
	@make -C $(OPENWRT_AA) package/symlinks &> ./_pack.log
	@$(OPENWRT_AA)/scripts/feeds install -a -d n &> ./_pack.log

prepare_rootfs_config: $(ROOTFS_PRE_CONFIG)
	@cp $^ $(OPENWRT_CONFIG)


build_rootfs:
	@echo [CC] build rootfs
	@make -C $(OPENWRT_AA) V=99 &> _build.log

update_feed:
	@$(FEED) update -i &> /dev/null

# 'software' target MUST be defined in image configuration file
configure: apply_settings software

image-check:
	$(if $(TARGET),,$(error "$$TARGET not specified"))

image: intro image-check prepare_rootfs_config prepare-base configure \
	build_rootfs \
	copy_rootfs

clean:
	@make -C $(OPENWRT_AA) distclean
	@rm -rf $(BINARY_OUT)

prepare_initramfs_config: $(INITRAMFS_PRE_CONFIG)
	@cp $^ $(OPENWRT_CONFIG)

build_initramfs:
	@echo [CC] build initramfs
	@make -C $(OPENWRT_AA) V=99 &> _initramfs.log

initramfs: prepare_initramfs_config prepare-base build_initramfs \
	copy_initramfs


