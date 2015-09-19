
module('checker_regular',package.seeall)

init_checker(checker_regular,load('checker_chars','checker'))

function get_compare_func(self,sub_result_list)
	local function compare(lineinfo)
		--		local sub_result_list=sub_result_list
		local data=self.checker_list
		local matched=false
		local str_obj
		
		local line=lineinfo:get_rest()
		local cs=string.match(line,data)
--		if(cs~=nil)then
--			lineinfo:skip_by(cs)
--		end

		matched=(cs~=nil)
		str_obj=cs

		return matched,str_obj
	end

	return compare
end
