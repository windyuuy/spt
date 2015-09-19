
require('checker.preload')

local names=detect_submodules(1,'checker_([_%w]+)')

__checker_list=names

--local names={'str','chars','recurse','and','or','not','line','redef','true'}

------------------------------------
-- preload checkers
--
for k,name in ipairs(names)do
	_G['checker_'..name]=load('checker_'..name,'checker')
end

------------------------------------
-- define checker alias names
--
local funcs={}
for k,v in ipairs(names)do
	funcs['ch_'..v]=function(list,...)
		local ch_hello=_G['checker_'..v]:create(list,...)
		return ch_hello
	end
end
table.copy(_G,funcs)

result_indexer=rload('result.indexer')

require('result.join')

require('checker.extra_define')
