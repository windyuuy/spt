
module('checker_chars',package.seeall)

init_checker(checker_chars)

function get_compare_func(self,sub_result_list)
	local function compare(lineinfo)
		--		local sub_result_list=sub_result_list
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

function get_sub_result_list(self)
	if(#self.sub_result_list==0)then
		self.sub_result_list={{rawline=self.rawline}}
	end
	return self.sub_result_list
end

function get_sub_result(self,index)
	return {rawline=self.rawline:sub(index,index)}
end

function raw_index(self,index)
	local raw_list=raw_string(self.rawline)
	return raw_list
end
