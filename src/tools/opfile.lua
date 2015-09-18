require('lua_ext')
require('lfs')

local _current_file_path='$_current_file_path'

function lines_in_file(name,...)
	return io.open(name,'r'):lines(...)
end

function runfile(name,env)
	--	return runner.runfile(name,env)
	name=fspath.abs_path(name,3)
	local f=io.open(name,'r')
	local content=f:read('*all')
	f:close()
	content=content:gsub('%s+<<<.-\n','\n')
	content=content:gsub('%s+<<<.+$','')
	content=content:gsub('%s+>>>.-\n','\n')
	content=content:gsub('%s+>>>.+$','')
	content=content:gsub('%s+>>>.-\n','\n')
	content=content:gsub('\n%s-\n','\n')
	content=content:gsub('%s+\n','\n')
	content=content:gsub('%s+$','')
	content=content:gsub('\n\t',' ')
	content=content:gsub('\n}','}')
	content=content:gsub('([{\[\(]) ','%1')
	local lines=string.gmatch(content,'[^\n]+')
	local _sparser_space=_G._sparser_space
	local last_path=_sparser_space[_current_file_path]
	_sparser_space[_current_file_path]=name
	local env,content=runner.runcontent(lines,env)
	_sparser_space[_current_file_path]=nil
	_sparser_space[_current_file_path]=last_path
	return env,content
end

function checkfile(rule,objname)
	objname=fspath.abs_path(objnamej)
	return rule:check(lineinfo:create(io.open(objname,'r'):read()))
end

function matchline(...) return runner.matchline(...) end
function can_match(...) return runner.can_match(...) end
function evalline(...) return runner.evalline(...) end
