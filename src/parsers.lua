
local parsers={}

local parser_name_list={
	'mark_string',
	'parse_checker',
}

for k,v in ipairs(parser_name_list)do
	parsers[v]=load(v)
end

return parsers
