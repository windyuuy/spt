
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
	mod_env[name]=mod_env
	--	setmetatable(mod_env,{__index=_G})
	if(f)then
		f(mod_env)
	end
	package.loaded[name]=mod_env
	setfenv(2,mod_env)
	_G[name]=mod_env
end

local package_register=package.loaded

function create_raw_loader(config)
	local preset_path_list=config.preset_path_list
	local ext_list=config.ext_list
	local inline_mod_name=config.inline_mod_name
	local module_loader=config.module_loader
	local package_register=config.package_register
	
	for k,v in ipairs(preset_path_list) do
		if(string.match(v,'[^/\\]$'))then
			preset_path_list[k]=v..'/'
		end
	end

	local function _get_loaded_module(mod_full_path)
		mod_full_path=mod_full_path:gsub('[/\\]\s+[/\\]+','/')
		mod_full_path=mod_full_path:gsub('[/\\]+','/')
		return package_register[mod_full_path]
	end

	local function raw_load(name,level,caller_path)
		level=getflevel(level)
		--		level=2
		name=name or ''
		local mod_name=name:match('[\.](%w+)$') or name
		name=name:gsub('[\.]','/')
		if(caller_path)then
--			caller_path=lfs.absolute_path(caller_path)
		else
			local caller_info=debug.getinfo(level)
			caller_path=caller_info.source
		end
		local sub_path=caller_path:match('^@?(.*[^/]+)[\.]%w+') or caller_path
		local caller_mod_path=sub_path:gsub('^@?(.-/)[^/]+$','%1')
		local caller_name=sub_path:sub(caller_mod_path:len()+1)
		if(caller_name==inline_mod_name)then
			caller_name=caller_mod_path:match('/([^/]+)/$')
			sub_path=caller_mod_path
			caller_mod_path=caller_mod_path:sub(1,caller_mod_path:len()-caller_name:len()-2)
		end

		local path_list={
			sub_path,
			caller_mod_path,
		--		_root_path,
		}
		table.iextend(path_list,preset_path_list)

		--	local ext_list={
		--		'.lua',
		--		'.so',
		--		'/init.lua',
		--		'/init.so',
		--	}

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

		local result=module_loader(mod_full_path,mod_name,name,level)

		return result,true

	end
	return raw_load
end

local function module_loader(mod_full_path,mod_name,name,level)
	level=getflevel(level)

	local var_org=_G[mod_name]
	assert(var_org==nil)
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
	package_register[mod_full_path]=result

	if(type(result)=='table' and getmetatable(result)==_G)then
		setmetatable(result,nil)
	end

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
