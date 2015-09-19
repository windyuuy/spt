
module('fspath',package.seeall)

require('lfs')

local f=io.popen('pwd','r')
local current_execute_path=f:read()..'/'
f:close()

--local start_script_execute_full_path=debug.getinfo(6).source
--print(start_script_execute_full_path)
--local start_script_execute_path=start_script_execute_full_path:match('^@?(.+)[/\\][^/\\]+$')

function getdir(fullpath)
	return fullpath:match('^@?(.+[/\\])[^/\\]-$')
end
dir=getdir

function is_abspath(name)
	return (name:find(':') or name:match('^/'))
end

function abs_path(name,level)
	level=getflevel(level)
	local fullpath
	if(is_abspath(name))then
		fullpath=name
	else
		fullpath=debug.getinfo(level).source
		fullpath=getdir(fullpath)
		if(fullpath)then
			fullpath=fullpath..name
		else
			fullpath=current_execute_path..name
		end
	end
	return fullpath
end

local WORD_PATTERN='[_%w]+'

function getname(name)
	return name:match('^.-/([^/\\]+)$') or name
end

function purename(name)
	return name:match('^.-/([^/]-)[\.]'..WORD_PATTERN..'$') or getname(name)
end

function pathstyle_of_modstyle(name)
	return name:gsub('[\.]','/')
end

function get_callerpath(level)
	level=getflevel(level)
	local caller_info=debug.getinfo(level)
	local caller_path=caller_info.source
	return caller_path:match('^@?(.*[^/]+[\.]'..WORD_PATTERN..')$') or caller_path
end

function purepath(callpath)
	return callpath:gsub('^(.*)[\.]'..WORD_PATTERN..'$','%1/')
end
--
--function moddir_of_callpath(callpath)
--	return callpath:gsub('^(.-/)[^/]+$','%1') or callpath
--end

function modname_of_modpath(modpath)
	return modpath:match('([\.]('..WORD_PATTERN..')$') or modpath
end

function curfoldername(dir)
	dir:match('/([^/]+)/$')
end

function strip_enddir(dir)
	return dir:match('^(.+)/[^/]+/?$') or ''
end
parentdir=strip_enddir

function tidy_path(path)
		path=path:gsub('[/\\]\s+[/\\]+','/')
		path=path:gsub('[/\\]+','/')
	return path
end
