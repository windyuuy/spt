
module('checker_chars',package.seeall)

init_checker(checker_chars)

function get_compare_func(self,sub_result_list)
	local function compare(lineinfo)
		local sub_result_list=sub_result_list
		local data=self.checker_list
		local matched=false
		local str_obj

		local cc=lineinfo:cutline(1)
--		matched=lineinfo:compare(data)
		matched=(string.find(data,cc,nil,true)~=nil)
		str_obj=cc

		--sub_result_list

		return matched,str_obj
	end

	return compare
end
