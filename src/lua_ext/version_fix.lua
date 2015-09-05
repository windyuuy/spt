--require('lua_ext.debug')

if(not getfenv)then
	function getfenv(f)
		if(type(f)=='number')then
			f=f+1
		end
		local env=getupvalue('_ENV',f)
		return env
	end
end

if(not setfenv)then
	setfenv=function (f,env)
		if(type(f)=='number')then
			f=f+1
		end
		setupvalue('_ENV',env,f)
	end
end

local function ddd()
	
end

local function t()
--	print(_getfenv(ddd))
	local a={}
	setmetatable(a,{__index=_G})
--	_ENV=a
	setfenv(1,a)
	c=23
--	local env=_ENV--getfenv(1)
	local env=getfenv(1)
--	print(c==env.c)
--	print(_G.c)
	
end

t()
