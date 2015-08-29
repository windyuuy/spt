
require('checker_preload')

checker_is=load('checker_is')
checker_line=load('checker_line')
checker_or=load('checker_or')
checker_and=load('checker_and')
checker_not=load('checker_not')

checker_chars=load('checker_chars')

checker_redef=load('checker_redef')

checker_recurse=load('checker_recursion')

result_indexer=load('result_indexer')

require('join_funcs')

function ch_str(str,...)
	local ch_hello=checker_is:create(str,...)
	return ch_hello
end

function ch_chars(str,...)
	local ch_hello=checker_chars:create(str,...)
	return ch_hello
end

local names={'and','or','not','line','redef'}
local funcs={}
for k,v in ipairs(names)do
	funcs['ch_'..v]=function(list,...)
		local ch_hello=_G['checker_'..v]:create(list,...)
		return ch_hello
	end
end
table.copy(_G,funcs)

function ch_repeat(unit,...)
	return ch_line({unit},...)
end

function r_index(result)
	local obj=result_indexer:create(result)
	return obj
end
