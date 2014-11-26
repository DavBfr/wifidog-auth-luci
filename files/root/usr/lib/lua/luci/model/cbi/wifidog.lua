local sys = require "luci.sys"
local fs = require "nixio.fs"
local uci = require "luci.model.uci".cursor()
local nw = require "luci.model.network"

local wan_ifname = luci.util.exec("uci get network.wan.ifname")
local lan_ifname = luci.util.exec("uci get network.lan.ifname")

local m

m = Map("wifidog", "Captive portal", translate("Forced portal is a restricted network connection, all client HTTP requests are redirected to the specified site"))

nw.init(m.uci)

if fs.access("/usr/bin/wifidog") then
	s = m:section(TypedSection, "settings", "Authentication site configuration")
	s.anonymous = true
	s.addremove = false
	s:tab("jbsz", translate("basic settings"))
	s:tab("bmd", translate("whitelist"))
	s:tab("gjsz", translate("advanced settings"))

	wifidog_enable = s:taboption("jbsz", Flag, "wifidog_enable", translate("Enable authentication"), translate("Turn authentication on or off"))
	wifidog_enable.rmempty = false
	deamo_enable = s:taboption("jbsz", Flag, "deamo_enable", translate("Daemon"), "Turn on the monitoring certification process to ensure the certification process from time to time")
	deamo_enable:depends("wifidog_enable", "1")
	ssl_enable = s:taboption("gjsz", Flag, "ssl_enable", translate("Encrypted transmission"), "Enable Secure Sockets Layer protocol transmission and improve network transmission security")
	ssl_enable.default = false
	ssl_enable.rmempty = false
	sslport = s:taboption("gjsz", Value, "sslport", "SSL transport port number", "Default 443")
	sslport.default = "443"
	sslport:depends("ssl_enable", "1")
	gateway_interface = s:taboption("gjsz", Value, "gateway_interface", "Intranet interface", "Set the internal network interface, the default 'br-lan'.")
	gateway_interface.default = "br-lan"
	gateway_interface:value(wan_ifname, wan_ifname .. "")
	gateway_interface:value(lan_ifname, lan_ifname .. "")
	gateway_address = s:taboption("gjsz", Value, "gateway_address", "Interface IP address", "Set the internal network interface ip address.")
	gateway_address.default = "192.168.1.1"

	for _, e in ipairs(nw.get_networks()) do
		if e ~= "lo" then gateway_interface:value(e) end
	end

	gateway_host = s:taboption("jbsz", Value, "gateway_host", "Certification site address", "Domain name or IP")
	offline_enable = s:taboption("jbsz", Flag, "offline_enable", translate("Enable offline authentication"), "Local built-in authentication server")
	offline_enable.rmempty = false
	gateway_hostname = s:taboption("jbsz", Value, "gateway_hostname", "Certification site name", "The content that appears on the title bar")
	gateway_hostname:depends("offline_enable", "1")
	gatewayport = s:taboption("gjsz", Value, "gatewayport", "Authentication gateway port number", "The default port number is 2060")
	gateway_httpport = s:taboption("gjsz", Value, "gateway_httpport", "HTTP port number", "The default port 80")
	gateway_path = s:taboption("gjsz", Value, "gateway_path", "Authentication server path", "Finally add /, for example: '/', '/wifidog/'")
	gateway_connmax = s:taboption("gjsz", Value, "gateway_connmax", "The maximum number of user access", "According to the router performance, the default 50")
	gateway_connmax.default = "50"
	check_interval = s:taboption("gjsz", Value, "check_interval", "Check interval", "Access client online detection interval, the default 60 seconds")
	check_interval.default = "60"
	client_timeout = s:taboption("gjsz", Value, "client_timeout", "Client timeout", "Access client authentication timeout, the default 5 minutes")
	client_timeout.default = "5"
	client_time_limit = s:taboption("gjsz", Value, "client_time_limit", "Client quotas", "Access client limit the use of time, the default 60 minutes")
	client_time_limit.default = "60"
	client_time_limit:depends("offline_enable", "1")
	--[whitelist]--
	bmd_url = s:taboption("bmd", Value, "bmd_url", "Website URL whitelist", "url that can be opened without authentication, without 'http://' separated with ','. Such as: 'duckduckgo.com, www.wikipedia.org'")
	myz_mac = s:taboption("bmd", Value, "myz_mac", "Free certification equipment", "Fill in the device's MAC address, multiple devices separated with ','. Such as '11:22:33:44:55:66, aa:bb:cc:dd:ff:00'")

else
	m.pageaction = false
end


return m
