include $(TOPDIR)/rules.mk

PKG_NAME:=wifidog-auth-luci
PKG_VERSION=1.0
PKG_RELEASE:=0

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/wifidog-auth-luci
	SUBMENU:=Captive Portals
	SECTION:=luci
	CATEGORY:=LuCI
	URL:=https://github.com/DavBfr/wifidog-auth-luci
	MAINTAINER:=David <dev.nfet.net@gmail.com>
	SUBMENU:=3. Applications
	DEPENDS:=+wifidog
	TITLE:=Wifidog configuration for LuCI and auth server
	PKGARCH:=all
endef

define Package/wifidog-auth-luci/description
	This package contains LuCI configuration pages for wifidog and basic Lua auth server.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/wifidog-auth-luci/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/wifidog-auth
	
	$(INSTALL_CONF) ./files/root/etc/config/wifidog $(1)/etc/config/
	
	$(INSTALL_BIN) ./files/root/etc/init.d/wifidog $(1)/etc/init.d/
	$(INSTALL_BIN) ./files/root/etc/uci-defaults/luci-wifidog $(1)/etc/uci-defaults/
	
	$(INSTALL_DATA) ./files/root/usr/lib/lua/luci/model/cbi/wifidog.lua $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_DATA) ./files/root/usr/lib/lua/luci/controller/wifidog.lua $(1)/usr/lib/lua/luci/controller/
	
	$(INSTALL_DATA) ./files/root/usr/lib/lua/luci/controller/wifidog-auth/auth.lua $(1)/usr/lib/lua/luci/controller/wifidog-auth/
	$(INSTALL_DATA) ./files/root/usr/lib/lua/luci/controller/wifidog-auth/login.lua $(1)/usr/lib/lua/luci/controller/wifidog-auth/
	$(INSTALL_DATA) ./files/root/usr/lib/lua/luci/controller/wifidog-auth/gw_message.lua $(1)/usr/lib/lua/luci/controller/wifidog-auth/
	$(INSTALL_DATA) ./files/root/usr/lib/lua/luci/controller/wifidog-auth/ping.lua $(1)/usr/lib/lua/luci/controller/wifidog-auth/
	$(INSTALL_DATA) ./files/root/usr/lib/lua/luci/controller/wifidog-auth/portal.lua $(1)/usr/lib/lua/luci/controller/wifidog-auth/
endef

define Package/wifidog-auth-luci/postinst
#!/bin/sh
[ -n "${IPKG_INSTROOT}" ] || {
	( . /etc/uci-defaults/luci-wifidog ) && rm -f /etc/uci-defaults/luci-wifidog
	chmod 755 /etc/init.d/wifidog >/dev/null 2>&1
	/etc/init.d/wifidog enable >/dev/null 2>&1
	exit 0
}
endef

$(eval $(call BuildPackage,wifidog-auth-luci))
