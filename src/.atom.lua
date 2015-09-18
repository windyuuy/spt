
local fullpath=debug.getinfo(1).source
local curpath=fspath.getdir(fullpath)
print("add search path :"..curpath)
package.path=package.path..';'..curpath..'?.lua;'
package.path=package.path..curpath..'?/init.lua;'
