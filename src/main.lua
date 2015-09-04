
require('lua_ext')

require('checker')

require('parser')

require('lfs')

local function main()
	lfs.chdir('./src')
	local f=io.open('main.lua')
	for line in f:lines() do
		print(line)
	end
end

cs_mem()

main()

show_mem()
