# wifidog-auth-luci
This package contains LuCI configuration pages for wifidog and basic Lua auth server.

## Features
1. Luci configuration page for wifidog
2. Bulit-in local authentication server

## Install
1. Git clone this respository in your `package` directory.
2. `make menuconfig` and select wifidog-auth-luci in LUCI category and save.
3. `make wifidog-auth-luci/compile` with a single package.
