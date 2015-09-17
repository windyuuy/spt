
require('lfs')
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
