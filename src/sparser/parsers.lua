
local parsers={}

local parser_name_list={
	'include_file',
	'mark_string',
	'parse_checker',
}

for k,v in ipairs(parser_name_list)do
	parsers[v]=rload(v)
end

return parsers
