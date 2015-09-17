
module('checker_true',package.seeall)

init_checker(checker_true)

function get_max_repeat_times(compare,lineinfo,count_ranges)
	local repeat_times=0
	local sub_rawline_list={}

	local lineinfo_copy=lineinfo:clone()
	local matched

	repeat_times=count_ranges[#count_ranges][2]
	local rawline=lineinfo_copy:cutline(repeat_times)
	sub_rawline_list[#sub_rawline_list+1]=rawline

	matched=true

	return matched,repeat_times,sub_rawline_list,lineinfo_copy
end

function compare_func(env)
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
