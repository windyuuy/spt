
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

local function f()
	cs_mem()
	for i=1,10000000 do
		sheet()
	end
	show_mem()
	cs_mem()
end

f()
show_mem()
cs_mem()
