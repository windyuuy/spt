
require('lua_ext')

require('checker')

require('sparser')

local function main()
	sheet()

	local sd2,rtype=runner.runline("sd = '(+ a b (+ c (+e f) k))'")
	print(sd2)

	if(rtype)then
		loadstring(sd2)()
	else
		sd=eval(sd2)
	end
	rdump(sd)
end

cs_mem()

main()

show_mem()
