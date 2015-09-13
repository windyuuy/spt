
local space=sheet()
local names={'str','chars','and','or','not','line','redef','true'}

for k,v in ipairs(names)do
	local func
	func=_G['ch_'..v]
	_G['cho_'..v]=function(name,list,range,...)
		return func(list,name,range,...)
	end
end

cho_str=function(name,list,range,...)
	return ch_str(list[1],name,range,...)
end

cho_rstr=function(ss,...)
	return ch_str(ss,nil,nil,...)
end

cho_end=cho_true

return space
