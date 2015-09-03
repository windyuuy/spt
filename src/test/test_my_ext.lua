
require('lua_ext.own')

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
	for i=1,100000 do
		sheet()
	end
	show_mem()
	cs_mem()
end

f()
show_mem()
cs_mem()
