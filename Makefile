include $(TOPDIR)/rules.mk

PKG_VERSION:=1.0.4
PKG_NAME:=oss_$(PKG_VERSION)
PKG_MAINTAINER:=Bandung, ONIVERSAL <friyadhibiermann>, indonesian
DEPENDS:=+libwolfssl24 +uhttpd +libustream-wolfssl +libuhttpd-wolfssl +tinyproxy

# directory in your OpenWrt SDK directory

PKG_BUILD_DIR:= $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:= oss
	URL:=oniversal.duckdns.org
endef

define Package/$(PKG_NAME)/description
	wifi management simple and powerfull
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/compile
	$(MAKE) -C $(PKG_BUILD_DIR)
endef

define Package/$(PKG_NAME)/install
	$(CP) ./files/* $(1)/
	$(INSTALL_DIR) $(1)/www/cgi-bin
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/oss $(1)/www/cgi-bin
	$(CP) $(PKG_BUILD_DIR)/uhttpd.key $(1)/etc
	$(CP) $(PKG_BUILD_DIR)/uhttpd.crt $(1)/etc
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
