
module('checker_redef',package.seeall)

init_checker(checker_redef)

function create(self,checker,alias,preset_count_ranges)
	local copy={}
	table.copy(copy,{alias,preset_count_ranges})
	setmetatable(copy,{__index=checker})
	return copy
end
