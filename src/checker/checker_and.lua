
module('checker_and',package.seeall)

init_checker(checker_and)

function list_relative(checker,env)
	_setenv(env)
	local result=checker:check(lineinfo_back)
	if(result.matched)then
		matched=true
		--		sub_result_list[checker.alias]=result
		if(#sub_rawline_list==0)then
			model._record_check_result(cur_sub_result,result)
			sub_rawline_list[#sub_rawline_list+1]=result.rawline
			--			lineinfo_back:skip_by(result.rawline)
		end
	else
		matched=false
		return true
	end
end
