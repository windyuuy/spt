
module('checker_false',package.seeall)

local function bigger_than(n1,n2)

	-- n1==n2=='+' or n1==n2=='-' is impossible
	assert((n1~='+' and n1~='-') or n1~=n2,'')

	if(n1=='-' or n2=='+')then
		return false
	elseif(n1=='+'or n2=='-')then
		return true
	else
		return n1>n2
	end

end

local function little_than(n1,n2)
	return bigger_than(n2,n1)
end

function get_max_repeat_times(compare,lineinfo,count_ranges)
	local repeat_times=0
	local sub_rawline_list={}

	local lineinfo_copy=lineinfo:clone()
	local repeat_times_copy=repeat_times
	local matched
	local last_statu={matched=false,repeat_time=0}
	for _,v in ipairs(count_ranges)do
		local max,min
		if(type(v)=='number')then
			max=v
			min=v
		else
			max=v[2]
			min=v[1]
		end

		local inc_sub_rawline_list={}
		local str_obj
		--while(max=='+' or repeat_times_copy<max)do
		while(bigger_than(max,repeat_times_copy))do
			matched,str_obj=compare(lineinfo_copy)
			if(matched==true)then
				repeat_times_copy=repeat_times_copy+1
				lineinfo_copy:skip_by(str_obj)
				inc_sub_rawline_list[#inc_sub_rawline_list+1]=str_obj
			else
				break
			end
		end

		if(matched or not last_statu.matched)then
			for _,v in ipairs(inc_sub_rawline_list)do
				sub_rawline_list[#sub_rawline_list+1]=v
			end
		end

		if(repeat_times_copy==max and matched)then
			matched=true
			repeat_times=repeat_times_copy
			last_statu.matched=true
			last_statu.repeat_time=repeat_times
			--continue
		elseif(not little_than(repeat_times_copy,min) and little_than(repeat_times_copy,max))then
			matched=true
			repeat_times=repeat_times_copy
			break
		else
			matched=false
			repeat_times=repeat_times_copy

			if(last_statu.matched)then
				matched=last_statu.matched
				repeat_times=last_statu.repeat_time
			end
			break
		end

	end

	return matched,repeat_times,sub_rawline_list,lineinfo_copy
end

function list_relative(checker)
--	matched=result.matched
--	if(result.matched)then
--		sub_result_list[checker.alias]=result
--		sub_rawline_list[#sub_rawline_list+1]=result.rawline
--		lineinfo_back:skip_by(result.rawline)
--	end
end

function compare_func()
	local list_relative=model.list_relative
	local env_original=getfenv(list_relative)
	setfenv(list_relative,getfenv(1))
	for k,checker in ipairs(checker_list)do
		if(list_relative(checker))then break end
	end
	setfenv(list_relative,env_original)

	if(matched)then
		str_obj=table.concat(sub_rawline_list)
	end

	return matched,str_obj
end

function get_compare_func(self,sub_result_list)
	local function compare(lineinfo)
		local sub_result_list=sub_result_list
		local checker_list=self.checker_list

		local lineinfo_back=lineinfo:clone()
		local sub_rawline_list={}
		local matched=false
		local str_obj

		local compare_func=self.model.compare_func
		local env_original=getfenv(compare_func)
		local env=table.clone(env_original)
		local env_extra={
			matched=matched,
			str_obj=str_obj,
			sub_result_list=sub_result_list,
			checker_list=checker_list,
			lineinfo_back=lineinfo_back,
			sub_rawline_list=sub_rawline_list,
			model=self.model
		}
		table.copy(env,env_extra)
		setmetatable(env,getmetatable(env_original))

		setfenv(compare_func,env)
		matched,str_obj=compare_func()
		setfenv(compare_func,env_original)

		return matched,str_obj
	end

	return compare
end
--
--function get_compare_func(self,sub_result_list)
--	local function compare(lineinfo)
--		return false,''
--	end
--
--	return compare
--end

function check(self,lineinfo,count_ranges)

	count_ranges=count_ranges or self.preset_count_ranges

	local sub_result_list={}
	local compare=self.model.get_compare_func(self,sub_result_list)

	local matched,repeat_times,sub_rawline_list,lineinfo_copy=self.model.get_max_repeat_times(compare,lineinfo,count_ranges)

	local rawline
	rawline=table.concat(sub_rawline_list)

	local result={
		matched=matched,
		checker=self,
		rawline=rawline,
		sub_rawline_list=sub_rawline_list,
		repeat_times=repeat_times,
		sub_result_list=sub_result_list,
		lineinfo_snapshot=lineinfo_copy,
	}


	self.t_result=result
	return result
end

function create(self,checker_list,alias,preset_count_ranges)
	return {
		checker_list=checker_list,

		check=self.check,
		alias=alias or self._NAME,
		preset_count_ranges=preset_count_ranges or {1},

		name=self._NAME,
		model=self,
	}
end
