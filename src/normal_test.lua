
require('lua_ext')

require('checker_init')

local function main()
	local ch_hello=ch_str('hello')
	local ch_world=ch_str('world','wd')
	local ch_blanket=ch_str(' ','bk')
	local ch_hallo=ch_str('hallo')
	local ch_hh=checker_or:create({ch_hello,ch_hallo})
	local ch_not=checker_not:create({ch_blanket,ch_world,ch_world,ch_hallo})
	local ch_and=checker_and:create({ch_hello,ch_hello,ch_not})
	local ch_line=checker_line:create({ch_hello,ch_and,ch_hh},'kljl',{3})
	local ch_line2=checker_line:create({ch_line,ch_blanket,ch_world},'kjlk')
	local info_hello=lineinfo.create('hellohellohallohellohellohellohellohellohello world')
	local result=ch_line2:check(info_hello,{1})
	vdump(result)
--	local i_result=r_index(result)
	local rline=result:index('kljl.@rawline')
	local rworld=result:index('wd')
	rdump(rworld,3)
	local cc=join_results({rline,rworld,'kwelk',rworld})
	print(cc)
	
	local rs=result:index('kljl'):raw_index()
	rdump(rs)
	print(rs['$is'])
	
end

main()