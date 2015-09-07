require('lua_ext')
require('lfs')

function lines_in_file(name,...)
	return io.open(name,'r'):lines(...)
end

function runfile(name,env)
	return runner.runfile(name,env)
end

function checkfile(rule,objname)
	return rule:check(lineinfo:create(io.open(objname,'r'):read()))
end
