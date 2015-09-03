
require('lua_ext')
require('lfs')

for file in lfs.dir('./')do
	print(file)
	if(file~='.')then
		rdump(lfs.attributes('./'..file))
	end
end
