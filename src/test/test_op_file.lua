
require('lua_ext')

require('checker')

require('sparser')

require('lfs')

local function main()
	sheet('kkk')
	lfs.chdir('./src/test')
	local f=io.open('rule.rd')
--	for line in f:lines() do
--		ssline=runner.runline(line)
----##dd=$line{[/print/] bracket word['n'] bracket}
----		g=_G
----		_G=_M
--		func=assert(loadstring(ssline),ssline)
--		setfenv(func,getfenv(1))
--		func()
--	end
--	
	runner.runcontent(f:lines())
	local hf=io.open('hello.c')
	local sfd=lineinfo:create(hf:lines()())
--	print(sfd)
	result=dd:check(sfd)
--	rdump(result)
--	result=dd:check(lineinfo:create('print(hello)'))
--	rdump(result)

	print(result:index('krk>@rawline'))

	f:close()
end

main()
