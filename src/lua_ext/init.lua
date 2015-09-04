
require('config')

require('lua_ext.pks')

requirelist({'thirdpart','dump','debug','own','lineinfo'},'lua_ext')

package.preload['lua_ext']=package.loaded['ext']
