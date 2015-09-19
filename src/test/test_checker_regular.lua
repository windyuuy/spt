
require('lua_ext')
requirelist({
	'lfs','socket'
})
print(socket.gettime())
requirelist({
	'checker','sparser',
--	'lfs','socket'
})

local str_list={
	'lkwjef',
	' wefkljl',
	'wefkljl@',
	'#wefkljl@',
}

local reg_list={
	[[
		/"[_%w]+"/
	]]
}

for k2, regline in ipairs(reg_list) do
	for k, line in ipairs(str_list) do
		print(runner.matchline(line,regline))
	end
end
