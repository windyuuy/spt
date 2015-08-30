
require('lua_ext')

require('checker_init')

local function main()
	local info_hello=lineinfo:create('hklpoij pion;nl')

	local ch_c=ch_chars('abcdefghijklmnopqrstuvwxyz',nil,{'n'})
	local ds=ch_c:create('wef')
	local rs=ds:check(info_hello)
	rdump(rs)
	
	local rrs=ds:raw_check(info_hello)
	rdump(rrs)
	

end

main()
