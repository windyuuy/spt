
require('lua_ext')

require('checker')

local function main()
	local info_hello=lineinfo:create('hklphklpoij pion;nl')

	local ch_c=ch_chars('abcdefghijklmnopqrstuvwxyz',nil,{'n'})
	local ds=ch_c:create('wef')
	local rs=ds:check(info_hello,{3})
	--	rdump(rs)

	local rrs=ds:raw_check(info_hello)
	--	rdump(rrs)

	local ch_sew=ch_str('hklp','wle',{2})
	local rs2=ch_sew:raw_check(info_hello)
		-- rdump(rs2)

	local chd=ch_line({ch_sew})
	chd:check(info_hello)

end

main()
