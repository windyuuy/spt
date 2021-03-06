
module('checker_str',package.seeall)

init_checker(checker_str)

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

function get_sub_result_list(self)
	if(#self.sub_result_list==0)then
		self.sub_result_list={{[self.alias]={rawline=self.rawline}}}
	end
	return self.sub_result_list
end

function get_sub_result(self,index)
	return self:get_sub_result_list()[1]
end

function raw_index(self,index)
	local raw_list={}
	setmetatable(raw_list,{__index=function(t,k)
		if(k<=self.repeat_times)then
			return self.rawline
		else
			return nil
		end
	end})
	return raw_list
end
