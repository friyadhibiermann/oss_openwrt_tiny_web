##############################################
# OpenWrt Makefile for oss program
# #
# #
# # Most of the variables used here are defined in
# # the include directives below. We just need to
# # specify a basic description of the package,
# # where to build our program, where to find
# # the source files, and where to install the
# # compiled program on the router.
# #
# # Be very careful of spacing in this file.
# # Indents should be tabs, not spaces, and
# # there should be no trailing whitespace in
# # lines that are not commented.
# #
# ##############################################
#
include $(TOPDIR)/rules.mk

PKG_VERSION:=1.0.4
PKG_NAME:=oss_$(PKG_VERSION)
PKG_MAINTAINER:=Bandung, ONIVERSAL <friyadhibiermann>, indonesian
DEPENDS:=+libwolfssl24 +uhttpd +libustream-wolfssl +libuhttpd-wolfssl

# # directory in your OpenWrt SDK directory

PKG_BUILD_DIR:= $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

# # variable below and uncomment the Kamikaze defin
# # directive for the description below

define Package/$(PKG_NAME)
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:= oss
	URL:=
endef

define Package/$(PKG_NAME)/description
	This tool generates a stripped binary executable version of the script specified at command line
endef

# Specify what needs to be done to prepare for building the package.
# # In our case, we need to copy the source files to the build directory.
# # This is NOT the default.  The default uses the PKG_SOURCE_URL and the
# # PKG_SOURCE which is not defined here to download the source from the web.
# # In order to just build a simple program that we have just written, it is
# # much easier to do it this way.
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
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/oss $(1)/www/cgi-bin
endef

#
#
#         # This line executes the necessary commands to compile our program.
# The above define directives specify all the information needed, but this
# # line calls BuildPackage which in turn actually uses this information to
# # build a package.
$(eval $(call BuildPackage,$(PKG_NAME)))
