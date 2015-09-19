
checker_recursion=checker_recurse
ch_reg=ch_regular

function ch_repeat(unit,...)
	return ch_line({unit},...)
end

function ch_min_prefix(prefix_condition,condition,...)
	return ch_line({ch_line({prefix_condition,ch_not(condition)},...),condition})
end
function ch_min_match(prefix_condition,condition,...) end
ch_min_match=ch_min_prefix

function r_index(result)
	local obj=result_indexer:create(result)
	return obj
end
