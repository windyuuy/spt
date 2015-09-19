
require('lua_ext')
requirelist({
	'checker','sparser',
	'lfs'
})

local function main()
	sheet('kkk')
--	lfs.chdir('./src/test')

	--	print('klwjlej')
	runner.runfile('./test/rule.rd')
	--	local f=io.open('rule.rd')
	--	runner.runcontent(f:lines())

	local hf=io.open('./test/hello.c')
	local info=lineinfo:create(hf:lines()())

	result=dd:check(info)

	print(result:index('krk>@rawline'))

	hf:close()
end

main()
