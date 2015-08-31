 
module('checker_is',package.seeall)

init_checker(checker_is)

--local checker_false=load("checker_false")

--copy_module(checker_is,checker_false)

function get_compare_func(self,sub_result_list)
	local function compare(lineinfo)
--		local sub_result_list=sub_result_list
		local data=self.checker_list
		local matched=false
		local str_obj

		matched=lineinfo:compare(data)
		str_obj=data

		--sub_result_list

		return matched,str_obj
	end

	return compare
end
