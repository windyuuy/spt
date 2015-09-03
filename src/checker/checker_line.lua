
module('checker_line',package.seeall)

init_checker(checker_line)

function list_relative(checker)
	local result=checker:check(lineinfo_back)
	matched=result.matched
	if(result.matched)then
--		sub_result_list[checker.alias]=result
--		if(not sub_result_list[checker.name])then sub_result_list[checker.name]=result end
		model._record_check_result(cur_sub_result,result)
		sub_rawline_list[#sub_rawline_list+1]=result.rawline
		lineinfo_back:skip_by(result.rawline)
	else
		return true
	end
end

