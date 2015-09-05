
function sheet(name)
	local index=2
	local hello={}
	if(name)then
		hello[name]=hello
	end
	hello._NAME=name or ''
	hello._M=hello
	setmetatable(hello,{__index=_G})
	setfenv(index,hello)
	return hello
end

function clear_mem(count)
	count=count or 2
	for i=1,count do
		collectgarbage()
	end
	print('collected')
end

function show_mem()
	local i=collectgarbage('count')
	print(i)
	return i
end

function count_mem()
	return collectgarbage('count')
end

function cs_mem()
	clear_mem()
	return show_mem()
end

local raw_list_meta={__index=function (t,k)
	if(k<=t._rawline:len())then
		return t._rawline:sub(k,k)
	else
		return nil
	end
end}
function raw_string(rawline)
	local raw_list={_rawline=rawline}
	setmetatable(raw_list,raw_list_meta)
	return raw_list

end

function table.makeclone(self,tt)
	assert(type(self)=='table','')
	tt=tt or {}
	for k,v in pairs(self) do
		tt[k]=v
	end
	return tt
end

function table.copy(self,tt)
	table.makeclone(tt,self)
end

function copy_module(t1,t2)
	local t3=table.makeclone(t2)
	t3._M=nil
	t3._NAME=nil
	t3._PACKAGE=nil

	table.copy(t1,t3)

end
--
--function string.split(s,d)
--	local lines={}
--	if(string.find(s,'([^'..d..']+)')~=1)then
--		lines[#lines+1]=''
--	end
--	for w in string.gmatch(s,'([^'..d..']+)')do
--		lines[#lines+1]=w
--	end
--	return lines
--end

function index_func(tl)
	return function(t,k)
		local value
		if(rawget(t,k)~=nil)then return rawget(t,k) end
		for i,vt in ipairs(tl)do
			if(vt[k]~=nil)then
				return vt[k]
			end
		end
		return nil
	end
end