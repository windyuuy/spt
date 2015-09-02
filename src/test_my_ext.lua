
require('my_ext')

local function d()
	local s=sheet('hello')
	
	h=34
	
	function e()
		print(h)
	end
	return s
end

local hello=d()
--d()
hello.e()
