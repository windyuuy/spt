require('lua_ext')
require('lfs')

function lines_in_file(name,...)
	return io.open(name,'r'):lines(...)
end
