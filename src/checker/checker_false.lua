
result_proto={}

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

local function convert_name(name)
	local name='$'..name:sub(9)
	return name
end

function _record_check_result(sub_result_list,result)
	local checker=result.checker
	sub_result_list[checker.alias]=result
	if(not sub_result_list[checker.name])then sub_result_list[checker.name]=result end
end

function arrange_count_ranges(count_ranges)

	for k,v in ipairs(count_ranges)do
		local max,min
		if(type(v)=='table')then
		elseif(type(v)=='number')then
			max=v
			min=v
			count_ranges[k]={min,max}
		elseif(type(v)=='string')then
			if(v=='n')then
				max='+'
				min='-'
			end
			count_ranges[k]={min,max}
		end

	end
	return count_ranges
end

function _setenv(env)
	--	if(setfenv)then return end
	if(env)then
		setfenv(2,env)
	else
		setfenv(2,getfenv(3))
	end
end
_G._setenv=_setenv

function get_max_repeat_times(compare,lineinfo,count_ranges)
	local repeat_times=0
	local sub_rawline_list={}

	local lineinfo_copy=lineinfo:clone()
	local repeat_times_copy=repeat_times
	local matched
	local last_statu={matched=false,repeat_time=0}
	for i,v in ipairs(count_ranges)do
		local max,min
		max=v[2]
		min=v[1]

		local inc_sub_rawline_list={}
		local str_obj
		while(bigger_than(max,repeat_times_copy) and lineinfo_copy:onway())do
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

function proc_relation(checker,env)
end

function compare_func(env)
	_setenv(env)
	cur_sub_result={}
	sub_result_list[#sub_result_list+1]=cur_sub_result
	local proc_relation=model.proc_relation
	local env_original=getfenv(proc_relation)
	setfenv(proc_relation,getfenv(1))
	for k,checker in ipairs(checker_list)do
		if(proc_relation(checker,getfenv(1)))then break end
	end
	setfenv(proc_relation,env_original)

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
		local env=table.makeclone(env_original)
		local env_extra={
			matched=matched,
			str_obj=str_obj,
			sub_result_list=sub_result_list,
			cur_sub_result={},
			checker_list=checker_list,
			lineinfo_back=lineinfo_back,
			sub_rawline_list=sub_rawline_list,
			model=self.model
		}
		table.copy(env,env_extra)
		setmetatable(env,getmetatable(env_original))

		setfenv(compare_func,env)
		matched,str_obj=compare_func(env)
		setfenv(compare_func,env_original)

		return matched,str_obj
	end

	return compare
end

function get_sub_result_list(self)
	return self.sub_result_list
end

function get_sub_result(self,index)
	return get_sub_result_list(self)[index]
end

function check(self,lineinfo,count_ranges)

	count_ranges=count_ranges or self.preset_count_ranges

	local sub_result_list={}
	local compare=self.model.get_compare_func(self,sub_result_list)

	arrange_count_ranges(count_ranges)

	local matched,repeat_times,sub_rawline_list,lineinfo_copy=self.model.get_max_repeat_times(compare,lineinfo,count_ranges)

	local rawline
	rawline=table.concat(sub_rawline_list)

	local checker={checker_name=self.name,checker_alias=self.alias}
	setmetatable(checker,{__index=self})

	local result={
		matched=matched,
		checker=checker,
		rawline=rawline,
		sub_rawline_list=sub_rawline_list,
		repeat_times=repeat_times,
		sub_result_list=sub_result_list,
		lineinfo_snapshot=lineinfo_copy:snapshot(),

		get_sub_result_list=self.model.get_sub_result_list,
		get_sub_result=self.model.get_sub_result,
		raw_index=self.model.raw_index,
	}

	setmetatable(result,{__index=result_proto})

	self.t_result=result
	return result
end

function raw_check(self,lineinfo,count_ranges,index)
	local result=self:check(lineinfo,count_ranges)
	if(result.matched)then
		return result:raw_index(index)
	else
		return nil
	end
end

local function _create(self,checker_list,alias,preset_count_ranges)
	local function create(self,alias,preset_count_ranges)
		if(preset_count_ranges==nil and type(alias)=='table')then
			alias=nil
			preset_count_ranges=alias
		end

		local copyi={}
		table.copy(copyi,self)
		setmetatable(copyi,getmetatable(self))
		copyi.alias=alias or self.alias
		copyi.preset_count_ranges=preset_count_ranges or self.preset_count_ranges
		return copyi
	end

	local model={}
	setmetatable(model,{__index=self})

	local the_checker={
		checker_list=checker_list,

		check=self.check,
		raw_check=self.raw_check,
		alias=alias or convert_name(self._NAME),
		preset_count_ranges=preset_count_ranges or {1},

		name=convert_name(self._NAME),
		model=model,
		create=create,

	}
	return the_checker
end

function create(self,checker_list,alias,preset_count_ranges)
	if(preset_count_ranges==nil and type(alias)=='table')then
		preset_count_ranges=alias
		alias=nil
	end
	return _create(self,checker_list,alias,preset_count_ranges)
end
