
require('lua_ext.debug')

-- test internal
local function c()
	return function()
		local d=5
		print(d)
		local c=223
		--	d=5
		local e=getvarvalue('d')
		print(e)
		setvarvalue('d',22)
		local e=getvarvalue('d')
		print(e)
	end
end
local b=c()
b()

local function c(d)
	return function()
		print(d)
		local c=223
		--	d=5
		local e=getvarvalue('d')
		print(e)
		setvarvalue('d',22)
		local e=getvarvalue('d')
		print(e)
	end
end
local b=c(4)
b()

assert(d==nil,'')
d=23
local function c()
	return function()
		print(d)
		local c=223
		--	d=5
		local e=getvarvalue('d')
		print(e)
		setvarvalue('d',22)
		local e=getvarvalue('d')
		print(e)
	end
end
local b=c()
b()
d=nil
