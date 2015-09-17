
require('lua_ext')
requirelist({
	'lfs','socket'
})
print(socket.gettime())
requirelist({
	'checker','sparser',
	'tools',
--	'lfs','socket'
})
print(socket.gettime())

local function main()
	sheet('kkk')
	lfs.chdir('./src/test')

	--	print('klwjlej')
	local _,content=runfile('rule2.rd',kkk)
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
