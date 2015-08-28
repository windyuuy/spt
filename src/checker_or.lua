
module('checker_or',package.seeall)

init_checker(checker_or)

function list_relative(checker)
	local result=checker:check(lineinfo_back)
	matched=matched or result.matched
	if(result.matched)then
--		sub_result_list[checker.alias]=result
		model._record_check_result(sub_result_list,result)
		sub_rawline_list[#sub_rawline_list+1]=result.rawline
		lineinfo_back:skip_by(result.rawline)
		return true
	end
end
