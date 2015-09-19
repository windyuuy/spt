
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

local package_register=package.loaded

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
	mod_env[name]=mod_env
	if(f)then
		f(mod_env)
	end
	
	package_register[name]=mod_env
	setfenv(2,mod_env)
	_G[name]=mod_env
end

function create_raw_loader(config)
	local preset_path_list=config.preset_path_list
	local ext_list=config.ext_list
	local inline_mod_name=config.inline_mod_name
	local module_loader=config.module_loader
	local package_register=config.package_register

	local function getname(name)
		return name:match('^.-/([^/\\]+)$') or name
	end

	for k,v in ipairs(preset_path_list) do
		if(getname(v))then
			preset_path_list[k]=v..'/'
		end
	end

	local function _get_loaded_module(mod_full_path)
		return package_register[fspath.tidy_path(mod_full_path)]
	end

	local function raw_load(name,level,caller_path)
		assert(name)

		level=getflevel(level)

		name=fspath.pathstyle_of_modstyle(name)
		local mod_name=fspath.purename(name)

		caller_path=caller_path or fspath.get_callerpath(level)
		local sub_dir=fspath.purepath(caller_path)
		local caller_mod_dir=fspath.dir(caller_path)
		local caller_name=fspath.purename(caller_path)
		if(caller_name==inline_mod_name)then
			sub_dir=caller_mod_dir
			caller_mod_dir=fspath.parentdir(caller_mod_dir)
			caller_name=fspath.curfoldername(caller_mod_dir)
		end

		local path_list={
			sub_dir,
			caller_mod_dir,
		}
		table.iextend(path_list,preset_path_list)

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
			assert(false)
			return nil,false
		end

		local result=module_loader(mod_full_path,mod_name,name,level)

		return result,true

	end
	return raw_load
end

local function module_loader(mod_full_path,mod_name,name,level)
	level=getflevel(level)

	local var_org=_G[mod_name]
	local mod=loadfile(mod_full_path)
	local result

	local using_module_func=false
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

		if(type(_G[mod_name])=='table' and _G[mod_name]._M==_G[mod_name])then
			using_module_func=true
			mod_env=_G[mod_name]
		end

		if(result==nil)then
			result=mod_env
		end
	end
	assert(var_org==nil or var_org==result)

	mod_full_path=fspath.tidy_path(mod_full_path)
	package_register[mod_full_path]=result

--	if(type(result)=='table' and getmetatable(result).__index==_G)then
--		setmetatable(result,nil)
--	end

	local caller_env=getfenv(level)
	if(type(caller_env)=='table' or type(caller_env)=='userdata')then
		caller_env[mod_name]=result
	end

	return result
end

rload=create_raw_loader({

		preset_path_list={
			--		sub_path,
			--		caller_mod_path,
			_root_path,
		},

		ext_list={
			'.lua',
			'.so',
			'/init.lua',
			'/init.so',
		},

		inline_mod_name='init',

		module_loader=module_loader,

		package_register=package_register,

})

function rloadlist(list,caller_path,level)
	level=getflevel(level)
	for _,name in ipairs(list)do
		rload(name,level,caller_path)
	end
end
