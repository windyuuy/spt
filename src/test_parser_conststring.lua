
require('lua_ext')

require('checker_init')

require('runner')

local function main()
	local sd2,rtype=runner.runline("sd = '(+ a b (+ c (+e f) k))'")
	--	print(sd2)
	--	local sd
	loadstring(sd2)()
	print(sd)
	-- try upvalues

	local func = debug.getinfo(1).func
	i = 1
	while true do
		local n, v = debug.getlocal(func, i)
		if not n then break end
		if n == name then return v end
		i = i + 1
	end
	
	if(rtype)then
	else
		sd=eval(sd2)
	end
	--	rdump(sd)
end

cs_mem()

main()

show_mem()
