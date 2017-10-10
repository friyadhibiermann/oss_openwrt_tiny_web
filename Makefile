# Copyright (C) 2014 WRTnode machine team.
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# noel<noel@wrtnode.com>
#

include $(TOPDIR)/rules.mk

PKG_NAME:=fdi
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define Package/fdi
  SECTION:=shcbash
  CATEGORY:=shc bash
  SUBMENU :=fdi
  TITLE:=shc script
  DEPENDS :=
endef

define Package/fdi/description
	WRTnode test program for opencv lib
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		$(TARGET_CONFIGURE_OPTS)
endef

define Package/fdi/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/fdi $(1)/usr/bin/
endef

$(eval $(call BuildPackage,fdi))
