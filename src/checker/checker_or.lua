
module('checker_or',package.seeall)

init_checker(checker_or)

function list_relative(checker,env)
	_setenv(env)
	local result=checker:check(lineinfo_back)
	matched=matched or result.matched
	if(result.matched)then
		--		sub_result_list[checker.alias]=result
		model._record_check_result(cur_sub_result,result)
		sub_rawline_list[#sub_rawline_list+1]=result.rawline
		lineinfo_back:skip_by(result.rawline)
		return true
	end
end
