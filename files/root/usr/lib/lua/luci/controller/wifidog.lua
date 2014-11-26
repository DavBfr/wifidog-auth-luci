module("luci.controller.wifidog", package.seeall)


function index()
	local fs = require "nixio.fs"
	if fs.access("/usr/bin/wifidog") then
		entry({"admin", "services", "wifidog"}, cbi("wifidog"), "Wifidog", 4)
	end
end
