
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

function index_func(tl)
	return function(t,k)
		local value
		if(rawget(t,k)~=nil)then return rawget(t,k) end
		for i,vt in pairs(tl)do
			if(vt[k]~=nil)then
				return vt[k]
			end
		end
		return nil
	end
end