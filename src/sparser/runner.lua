
module('runner',package.seeall)

rload('org.exlist')

local parsers=require('sparser.parsers')

local _current_file_path='$_current_file_path'

function parseline(line)
	local result,type,rtype
	local results={}
	for k,v in pairs(parsers)do
		result,type=v:parse(line)
		if(result~=nil)then
			results[#results+1]=result
			rtype=type
		end
	end
	if(#results~=1)then
		look(results)
		error('result num ~= 1')
		assert(#results==1,'')
	end
	return results[1],rtype
end

function parsecontent(lines)
	--	env=env or {}
	local codeline,content
	local codelines={}
	if(type(lines)=="table")then
		lines=ipairs(lines)
	end
	for line in lines do
		if(string.match(line,'^%s.$'))then
		else
			codeline=parseline(line)
			codelines[#codelines+1]=codeline
		end
	end
	content=table.concat(codelines,'\n')
	return content
end

function runcontent(lines,env)
	local content=parsecontent(lines,env)
	return exec(content,false,env),content

end

function evalline(content,env)
	local parsed_line=parseline(content)
	local _,v=exec("return "..parsed_line,nil,env)
	return v,env
end

function matchline(s,content,env)
	content=content:gsub('%s-\n%s*}','}')
	content=content:gsub('{%s-\n%s*','{')
	content=content:gsub('%s-\n%s*{','{')
	content=content:gsub('%s-\n%s*',' ')
	content=string.strip(content)
	--	content=content:gsub('^%s+','')
	--	content=content:gsub('%s+$','')
	local v,env=evalline(content,env)
	if(_DEBUG==2)then
		print(parseline(content))
	end
	local sinfo=lineinfo:create(s)
	local result=v:check(sinfo)
	return result,result:index('@matched') and result:index('@rawline')
end

function can_match(s,content,env)
	local result,matched=matchline(s,content,env)
	return matched,result
end

function exec(content,type,env)
	env=env or {}
	if(type)then
		return eval(content)
	else
		if(_DEBUG==1)then
			print(content)
		end
		local func=loadstring(content)
		if(func)then
			--			local meta=getmetatable(env)
			--			if(not meta or not meta.__index)then
			--				setmetatable(env,{__index=_G._sparser_space})
			--			else
			--				setmetatable(env,{__index=index_func({meta.__index,_G._sparser_space}) } )
			--			end
			local envt=exlist.extend({},env,_G._sparser_space)
			setfenv(func,envt)
			local ret=func()
			setmetatable(envt,nil)
			exlist.extend(env,envt)
			--			setmetatable(env,meta)
			return env,ret
		else
			return debug_execfunc(content)
		end
	end
end

function debug_execfunc(content,env)
	env=env or {}
	if(string.byte(content,#content)~=string.byte('\n',1))then
		content=content..'\n'
	end
	local line_number=1
	local broken=false
	local broken_line
	local func
	if(not content)then
		print('break at first')
	end
	for line in string.gmatch(content,'(.-)\n')do
		func=loadstring(line)
		--		assert(func,'line:\t'..line_number..', '..line)
		if(not func)then
			broken=true
			broken_line=line
			break
		end
		line_number=line_number+1
	end
	if(broken)then
		print('break in line:',line_number,broken_line)
	else
		print('break by unknown reason')
	end
	assert(false,'')
	return env
end

function parsefile(name,level)
	level=getflevel(level)
	local _,content
	name=fspath.abs_path(name,level+1)
	local f=io.open(name)
	if(f)then
		local _sparser_space=_G._sparser_space
		local last_path=_sparser_space[_current_file_path]
		_sparser_space[_current_file_path]=name
		content=runner.parsecontent(f:lines())
		f:close()
		_sparser_space[_current_file_path]=nil
		_sparser_space[_current_file_path]=last_path
	else
		print('file not exist:'..name)
		assert(f,'')
	end
	return content
end

function runfile(name,env,level)
	level=getflevel(level)
	local _,content
	env=env or {}
	name=fspath.abs_path(name,level+1)
	local f=io.open(name)
	if(f)then
		local _sparser_space=_G._sparser_space
		local last_path=_sparser_space[_current_file_path]
		_sparser_space[_current_file_path]=name
		_,content=runner.runcontent(f:lines(),env)
		f:close()
		_sparser_space[_current_file_path]=nil
		_sparser_space[_current_file_path]=last_path
	else
		print('file not exist:'..name)
		assert(f,'')
	end
	return env,content
end

local rd_package_register={}

local function module_loader(mod_full_path,mod_name,name)
	local result={runfile(mod_full_path,{})}
	rd_package_register[mod_full_path]=result
	return result
end

local rdload=create_raw_loader({

		preset_path_list=_rd_config.preset_rd_path_list,

		ext_list=_rd_config.preset_rd_ext_list,

		inline_mod_name='init',

		module_loader=module_loader,

		package_register=rd_package_register,

})

function refer_rule_module(name,env)
	--local extra_env,content=unpack(rdload(name,2,'/home/happy/workspace/spt/src/test/rule.rd') or {})
	local cur_path=_G._sparser_space[_current_file_path]
	local extra_env,content=unpack(rdload(name,2,cur_path) or {})
	if(env)then
		exlist.extend(env,extra_env)
	end
end

_G.refer_rule_module=refer_rule_module
