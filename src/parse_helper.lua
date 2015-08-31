
local names={'str','chars','and','or','not','line','redef'}

local func
for k,v in ipairs(names)do
	func=_G['ch_'..v]
	_G['cho_'..v]=function(name,list,range,...)
		func(list,name,range,...)
	end
end
