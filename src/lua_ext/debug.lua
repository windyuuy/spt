
function getflevel(level)
	level=level or 1
	if(type(level)=='number')then
		level=level+1
	end
	return level
end

function getinternalvalue(name,level)
	level=getflevel(level)
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
	level=getflevel(level)
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
	level=getflevel(level)

	-- try upvalues
	local func
	if(type(level)=='number')then
		func = debug.getinfo(level).func
	else
		func=level
	end
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
	level=getflevel(level)

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
	level=getflevel(level)
	local result
	result=getinternalvalue(name,level)
	if(result==nil)then
		result=getupvalue(name,level)
	end
	return result
end

function setlocalvalue(name,value,level)
	level=getflevel(level)
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
	level=getflevel(level)
	local result
	result=getlocalvalue(name,level)
	if(result==nil)then
		result=getglobalvalue(name)
	end
	return result
end

function setvarvalue (name,value,level)
	level=getflevel(level)
	if(getlocalvalue(name,level))then
		setlocalvalue(name,value,level)
	end

	if(getglobalvalue(name,value))then
		setglobalvalue(name,value)
	end
end

function log(tip)
	print(debug.getinfo(2).source..': ')
	print(tip)
	print('@@')
end
