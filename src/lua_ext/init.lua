
require('config')

require('lua_ext.pks')

requirelist({'thirdpart','dump','debug','version_fix','own','os_ext','lineinfo'},'lua_ext')

package.preload['lua_ext']=package.loaded['ext']

log(_VERSION)
