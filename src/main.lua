
require('lua_ext')

require('checker_init')

local function main()
	local ch_hello=ch_str('hello')
	local ch_world=ch_str('world')
	local ch_blanket=ch_str(' ')
	local ch_hallo=ch_str('hallo')
	local ch_hh=checker_or:create({ch_hello,ch_hallo})
	local ch_line=checker_line:create({ch_hello,ch_hello,ch_hh},'kljl',{3})
	local ch_line2=checker_line:create({ch_line,ch_blanket,ch_world},'kjlk')
	local info_hello=lineinfo.create('hellohellohallohellohellohellohellohellohello world')
	local result=ch_line2:check(info_hello,{1})
	vdump(result)
end

main()
