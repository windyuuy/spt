
require('lua_ext')

require('checker_init')

require('runner')

local function main()
--	local sd=runner.runline("ss = '(+ a b (+ c (+e f) k))'")
	local sd=runner.runline("kk=$line(){bracket op $or(){$$sump word}[3,(4,5),(7,+)] un_bracket()[1]}[]")
--	sd=runner.runline('kk=$str(){hello}[]')
	print(sd)
end

main()
