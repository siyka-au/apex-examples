#
# Busybox
#

TYPE := custom
TARGET := busybox

busybox_CFLAGS := $(CFLAGS) $(CONFIG_USER_CFLAGS)

busybox/.config: $(CONFIG_SRCDIR)/busybox/config conf/config.mk| $(CURDIR)/busybox/
	cp $< $@
ifeq ($(origin CONFIG_MMU),undefined)
	echo "CONFIG_NOMMU=y" >> $@
else
	echo "# CONFIG_NOMMU is not set" >> $@
endif
	echo "CONFIG_CROSS_COMPILER_PREFIX=\"$(CROSS_COMPILE)\"" >> $@
	echo "CONFIG_EXTRA_CFLAGS=\"$(busybox_CFLAGS)\"" >> $@

busybox/.copied:
	cp -rs $(CONFIG_SRCDIR)/busybox/src/* busybox
	touch $@

busybox/busybox: busybox/.config busybox/.copied
	MAKEFLAGS="$(_MFLAGS)" $(MAKE) -C busybox LD=$(CROSS_COMPILE)ld AR=$(CROSS_COMPILE)gcc-ar $(SHUTUP_IF_SILENT)

busybox/busybox_CLEAN :=

.PHONY: busybox/busybox_clean2
clean: busybox/busybox_clean2
busybox/busybox_clean2:
	rm -rf busybox
