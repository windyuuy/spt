
__('lua_ext')

rload('checker')

rload('sparser')
rload('sparser.runner')

local function main()
	sheet()

	local sd2,rtype=runner.parseline("sd = '(+ a b (+ c (+e f) k))'")
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
