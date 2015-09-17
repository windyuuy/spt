
------------
-- package support
--

local function get_pkname(pkname)
	if(pkname)then
		pkname=pkname .. '.'
	else
		pkname=''
	end
	return pkname
end

function requirelist(list,pkname)
	pkname=get_pkname(pkname)
	for i,v in ipairs(list) do
		require(pkname .. v)
	end
end

function require_tests(list,pkname)
	pkname=get_pkname(pkname)
	for i,v in ipairs(list) do
		if(not require(pkname .. v))then
			return false
		end
	end
	return true
end

function load(name,pkname)
	pkname=get_pkname(pkname)
	local back=_G[name]
	_G[name]=nil
	require(pkname..name)
	local mod=package.loaded[name]
	--	local mod=_G[name]
	_G[name]=nil
	_G[name]=back
	return mod
end

function module(name,f)
	f=f or package.seeall
	local mod_env
	mod_env={
		_NAME=name,
	}
	mod_env._M=mod_env
--	mod_env[name]=mod_env
	--	setmetatable(mod_env,{__index=_G})
	if(f)then
		f(mod_env)
	end
	package.loaded[name]=mod_env
	setfenv(2,mod_env)
	_G[name]=mod_env
end

local function _get_loaded_module(mod_full_path)
	mod_full_path=mod_full_path:gsub('[/\\]\s+[/\\]+','/')
	mod_full_path=mod_full_path:gsub('[/\\]+','/')
	return package.loaded[mod_full_path]
end

local function raw_load(name,level)
	--	level=getflevel(level)
	level=2
	name=name or ''
	local mod_name=name:match('[\.](%w+)$') or name
	name=name:gsub('[\.]','/')
	local caller_info=debug.getinfo(level)
	local caller_path=caller_info.source
	local sub_path=caller_path:match('^@?(.*[^/]+)[\.]%w+') or caller_path
	local caller_mod_path=sub_path:gsub('^@?(.-/)[^/]+$','%1')
	local caller_name=sub_path:sub(caller_mod_path:len()+1)
	if(caller_name=='init')then
		caller_name=caller_mod_path:match('/([^/]+)/$')
		sub_path=caller_mod_path
		caller_mod_path=caller_mod_path:sub(1,caller_mod_path:len()-caller_name:len()-2)
	end

	local path_list={
		sub_path,
		caller_mod_path,
		_root_path,
	}

	local ext_list={
		'.lua',
		'.so',
		'/init.lua',
		'/init.so',
	}

	local mod_full_path,loaded_module,mod_exist
	for _,lpath in ipairs(path_list)do
		for _,ext in ipairs(ext_list)do
			mod_full_path=lpath..name..ext
			loaded_module=_get_loaded_module(mod_full_path)
			if(loaded_module~=nil)then return loaded_module,true end

			if(lfs.exist(mod_full_path))then
				mod_exist=true
				break
			end
		end
		if(mod_exist)then break end
	end

	if(not mod_exist)then
		return nil,false
	end

	local var_org=_G[mod_name]
	assert(var_org==nil)
	local mod=loadfile(mod_full_path)
	local result

	if(mod~=nil)then
		local mod_env
		mod_env={
			_NAME=mod_name,
		}
		mod_env._M=mod_env
		mod_env[mod_name]=mod_env
		setmetatable(mod_env,{__index=_G})
		setfenv(mod,mod_env)
		result=mod()
		if(result==nil)then
			result=mod_env
		end
	end
	package.loaded[mod_full_path]=result

	if(type(result)=='table' and getmetatable(result)==_G)then
		setmetatable(result,nil)
	end

	local caller_env=getfenv(2)
	if(type(caller_env)=='table' or type(caller_env)=='userdata')then
		caller_env[mod_name]=result
	end

	return result,true

end
rload=raw_load
