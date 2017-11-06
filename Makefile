# Copyright (C) 2017 FDI machine team.
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# noel<noel@wrtnode.com>
#

include $(TOPDIR)/rules.mk

PKG_NAME:=fdi
PKG_RELEASE:=1.0.3

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define Package/fdi
  SECTION:=MYSCRIPT
  CATEGORY:=FDI
  SUBMENU :=fdi
  TITLE:=FDI_LEDES_SCRIPT
  DEPENDS:=
endef

define Package/fdi/description
	fdi script - for do everything
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)"
		CXXFLAGS="$(CFLAGS)"
endef

define Package/fdi/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/www/cgi-bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/fdi $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/html $(1)/www/cgi-bin/
endef

$(eval $(call BuildPackage,fdi))
