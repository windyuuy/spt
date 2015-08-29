
local parsers={}

local parser_name_list={
	'mark_string',
}

for k,v in ipairs(parser_name_list)do
	parsers[v]=load(v)
end

return parsers
