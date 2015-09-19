
if(not __)then
	__=require
end

require('config')

require('lua_ext.pks')

requirelist({'unique','thirdpart','dump','debug','version_fix','own','fspath','os_ext','lineinfo'},'lua_ext')

package.preload['lua_ext']=package.loaded['ext']

log(_VERSION)
