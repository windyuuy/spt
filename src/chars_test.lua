
require('lua_ext')

require('checker_init')

local function main()
	local info_hello=lineinfo:create('hello hellohallohellohellohellohellohellohello world')

	local ch_c=ch_chars('abcdefghijklmnopqrstuvwxyz',nil,{'n'})
	local ds=ch_c:create('wef',{{3,7}})
	local rs=ds:check(info_hello)
	rdump(rs)
	
end

main()
