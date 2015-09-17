
require('lfs')

local f=io.popen('pwd','r')
local current_execute_path=f:read()..'/'
f:close()

--local start_script_execute_full_path=debug.getinfo(6).source
--print(start_script_execute_full_path)
--local start_script_execute_path=start_script_execute_full_path:match('^@?(.+)[/\\][^/\\]+$')

_G.fspath={}

function fspath.getdir(fullpath)
	return fullpath:match('^@?(.+[/\\])[^/\\]-$')
end

function fspath.is_abspath(name)
	return (name:find(':') or name:match('^/'))
end

function fspath.abs_path(name,level)
	level=getflevel(level)
	local fullpath
	if(fspath.is_abspath(name))then
		fullpath=name
	else
		fullpath=debug.getinfo(level).source
		fullpath=fspath.getdir(fullpath)
		if(fullpath)then
			fullpath=fullpath..name
		else
			fullpath=current_execute_path..name
		end
	end
	return fullpath
end

function detect_submodules(dir,filter)
	local cur_dir=dir
	local names={}

	dir=dir or 1
	if(type(dir)=='number')then
		dir=dir+1
		cur_dir=debug.getinfo(dir,'S').source
		cur_dir=string.match(cur_dir,'^@(.+[\\/])')
	end

	filter=filter or '^[^/.].+'

	for filename in lfs.dir(cur_dir)do
		local name=string.match(filename,filter)
		if(name)then
			names[#names+1]=name
		end
	end
	return names
end

function lfs.exist(fn)
	local f=io.open(fn,'r')
	if(f)then
		f:close()
		return true
	else
		return false
	end
end
