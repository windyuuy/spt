
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
