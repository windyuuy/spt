
function getinternalvalue(name,level)
	level=level or 2
	local value, found
	-- try local variables
	local i = 1
	while true do
		local n, v = debug.getlocal(level, i)
		if not n then break end
		if n == name then
			value = v
			found = true
		end
		i = i + 1
	end
	if found then return value end
	return nil
end

function setinternalvalue(name,value,level)
	level=level or 2
	local varvalue, found,vindex
	-- try local variables
	local i = 1
	while true do
		local n, v = debug.getlocal(level, i)
		if not n then break end
		if n == name then
			varvalue = v
			found = true
			vindex=i
		end
		i = i + 1
	end

	--	if found then return value end
	if found then
		debug.setlocal(level,vindex,value)
		return
	end

end

function getupvalue(name,level)
	level=level or 2

	-- try upvalues
	local func = debug.getinfo(level).func
	local i = 1
	while true do
		local n, v = debug.getupvalue(func, i)
		if not n then break end
		if n == name then return v end
		i = i + 1
	end
	return nil
end

function setupvalue(name,value,level)
	level=level or 2

	-- try upvalues
	local func = debug.getinfo(level).func
	local i = 1
	while true do
		local n, v = debug.getupvalue(func, i)
		if not n then break end
		if n == name then
			debug.setupvalue(func,i,value)
			return
		end
		i = i + 1
	end

end

function getlocalvalue(name,level)
	level=level or 2
	level=level+1
	local result
	result=getinternalvalue(name,level)
	if(result==nil)then
		result=getupvalue(name,level)
	end
	return result
end

function setlocalvalue(name,value,level)
	level=level or 2
	level=level+1
	if(getinternalvalue(name,level))then
		setinternalvalue(name,value,level)
	end

	if(getupvalue(name,level))then
		setupvalue(name,value,level)
	end
end

function getglobalvalue(name)
	-- not found; get global
	return getfenv(func)[name]
end

function setglobalvalue(name,value)
	-- not found; get global
	getfenv(func)[name]=value
end

function getvarvalue (name,level)
	level=level or 2
	level=level+1
	local result
	result=getlocalvalue(name,level)
	if(result==nil)then
		result=getglobalvalue(name)
	end
	return result
end

function setvarvalue (name,value,level)
	level=level or 2
	level=level+1
	if(getlocalvalue(name,level))then
		setlocalvalue(name,value,level)
	end

	if(getglobalvalue(name,value))then
		setglobalvalue(name,value)
	end
end

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
