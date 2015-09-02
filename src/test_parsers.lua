
require('lua_ext')

local function main()
	requirelist({'test_parser_conststring','test_parser_checker'})
end

cs_mem()

main()

show_mem()
