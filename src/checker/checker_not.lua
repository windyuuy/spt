
module('checker_not',package.seeall)

init_checker(checker_not)

function proc_relation(checker,env)
	_setenv(env)
	matched=true
	local result=checker:check(lineinfo_back)
	if(result.matched)then
		matched=false
		--		sub_result_list[checker.alias]=result
		model._record_check_result(cur_sub_result,result)
		sub_rawline_list[#sub_rawline_list+1]=result.rawline
		lineinfo_back:skip_by(result.rawline)
		return true
	else
		sub_rawline_list[#sub_rawline_list+1]=lineinfo_back:cutline(1)
	end
end
