
require('lua_ext')

require('checker')

local function main()
	local info_hello=lineinfo:create('hklphklpoij pion;nl')
	local info_hello2=lineinfo:create('dce')

	local ch_c=ch_charset('c-d',nil,{'n'})
	local ds=ch_c:create('wef')
	local rs=ds:check(info_hello2,{2})
	rdump(rs)

	local rrs=ds:raw_check(info_hello)
	--	rdump(rrs)

	local ch_sew=ch_str('hklp','wle',{2})
	local rs2=ch_sew:raw_check(info_hello)
	--	rdump(rs2)

	local chd=ch_line({ch_sew})
	chd:check(info_hello)

end

main()
