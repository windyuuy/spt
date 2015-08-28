
module('checker_not',package.seeall)

init_checker(checker_not)

function list_relative(checker)
	local result=checker:check(lineinfo_back)
	if(result.matched)then
		matched=true
--		sub_result_list[checker.alias]=result
		model._record_check_result(sub_result_list,result)
		sub_rawline_list[#sub_rawline_list+1]=result.rawline
		lineinfo_back:skip_by(result.rawline)
	else
		matched=false
		return true
	end
end
