
require('lua_ext')
requirelist({
	'checker','sparser',
	'lfs'
	})

local function main()
	sheet('kkk')
	lfs.chdir('./src/test')

	local f=io.open('rule.rd')
	runner.runcontent(f:lines())

	local hf=io.open('hello.c')
	local info=lineinfo:create(hf:lines()())
	
	result=dd:check(info)

	print(result:index('krk>@rawline'))

	hf:close()
	f:close()
end

main()
