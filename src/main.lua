
require('lua_ext')

require('checker_init')

require('runner')

local function main()
	local sd=runner.runline("ss = '(+ a b (+ c (+e f) k))'")
end

main()
