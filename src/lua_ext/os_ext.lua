
require('lfs')

--__('lua_ext.fspath')

function lfs.exist(fn)
	local f=io.open(fn,'r')
	if(f)then
		f:close()
		return true
	else
		return false
	end
end
