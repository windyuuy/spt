
require('lua_ext')

require('checker_init')

local function main()
	local ch_hello=ch_str('hello')
	local ch_world=ch_str('world','wd')
	local ch_blanket=ch_str(' ','bk')
	local ch_hallo=ch_str('hallo')
	local recursion={}
	local ch_line=checker_line:create({ch_hello,checker_or:create({recursion,checker_not:create({ch_hello})})})
	setmetatable(recursion,{__index=ch_line})
	
	-- ch_line=$line{['hello'],$or{$$ch_line,$not{ch_hello}}}
	
	local info_hello=lineinfo.create('hellohellohellohelloworld')
	
	local result=ch_line:check(info_hello)
	print(result.rawline)

end

main()
