
require('lua_ext')
requirelist({
	'lfs','socket'
})
print(socket.gettime())
requirelist({
	'checker','sparser',
--	'lfs','socket'
})
print(socket.gettime())

local function main()
	sheet('kkk')
	lfs.chdir('./src/test')

	--	print('klwjlej')
--	local _,content=runner.runfile('rule.rd',kkk)
	local _,content=runner.runfile('/home/happy/workspace/spt/src/test/rule.rd',kkk)
	print(content)
	--	local f=io.open('rule.rd')
	--	runner.runcontent(f:lines())

	local hf=io.open('hello.c')
	local info=lineinfo:create(hf:lines()())

	result=dd:check(info)

	print(result:index('krk>@rawline'))

	hf:close()
end

print(socket.gettime())
main()
print(socket.gettime())
