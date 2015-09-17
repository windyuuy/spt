require('lua_ext')
require('lfs')

function lines_in_file(name,...)
	return io.open(name,'r'):lines(...)
end

function runfile(name,env)
	--	return runner.runfile(name,env)
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
	return runner.runcontent(lines,env)
end

function checkfile(rule,objname)
	return rule:check(lineinfo:create(io.open(objname,'r'):read()))
end
