
require('lua_ext')

requirelist({
	'checker','sparser',
})

local function main()
	local ch_hello=ch_str('hello')
	local ch_world=ch_str('world','wd')
	local ch_blanket=ch_str(' ','bk')
	local ch_hallo=ch_str('hallo')
	local recursion=checker_recurse:create()
	local ch_line=checker_line:create({ch_str('hello'),checker_or:create({recursion,checker_not:create({ch_hello})})})
	recursion:set_recursor(ch_line)

	-- ch_line=$line{[/hello/],$or{$$ch_line,$not{ch_hello}}}
	local raw_ch_line=runner.parseline('$line{[/hello/],$or{$$ch_line,$not{ch_hello}}}')
	print(raw_ch_line)

	local info_hello=lineinfo:create('hellohellohellohelloworld')

	local result=ch_line:check(info_hello)
	print(result.rawline)

end

main()
