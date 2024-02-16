include $(TOPDIR)/rules.mk

PKG_NAME:=ez-5gcpe-settings
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_LICENSE:=GPL-3.0

include $(INCLUDE_DIR)/package.mk

define Package/ez-5gcpe-settings
  SECTION:=luci
  CATEGORY:=LuCI
  TITLE:= EZ 5G CPE Settings and auto connecting for FM150 FM650
  DEPENDS:=+luci
  PKGARCH:=all
endef



define Build/Compile
endef

define Package/ez-5gcpe-settings/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) ./files/fibercom_connect.sh $(1)/usr/bin/
	$(INSTALL_BIN) ./files/init_3ginfo_modemband.sh $(1)/usr/bin/
	$(INSTALL_BIN) ./files/reboot5gmodule.sh $(1)/usr/bin/
endef

$(eval $(call BuildPackage,ez-5gcpe-settings))
