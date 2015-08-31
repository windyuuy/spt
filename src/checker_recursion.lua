
module('checker_recursion',package.seeall)

function set_recursor(symbol,recursor)
	assert(type(symbol)=='table','')

	setmetatable(symbol,{__index=recursor})

end

function create(self,alias,preset_count_ranges)

	return {
		alias=alias,
		count_ranges=count_ranges,
		set_recursor=set_recursor,
		create=_create,
	}
end


