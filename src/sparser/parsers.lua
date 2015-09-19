
local parsers={}

local parser_name_list
if(_DEBUG<2)then
	parser_name_list=detect_submodules(1,'(parser_[_%w]+)')
else
	parser_name_list=detect_submodules(1,'(parser_[_%w]+)')
	local exclude_list={
--		'include_file',
--		'mark_string',
--		'parse_checker',
	}
	table.foreach(exclude_list,function(k,v) exclude_list[k]='parser_'..v end)
	parser_name_list=table.make_iexclude(parser_name_list,exclude_list)
end

for k,v in ipairs(parser_name_list)do
	parsers[v]=rload(v)
end

return parsers
