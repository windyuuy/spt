
require('checker_preload')

checker_is=load('checker_is')
checker_line=load('checker_line')
checker_or=load('checker_or')
checker_and=load('checker_and')
checker_not=load('checker_not')

checker_recurse=load('checker_recursion')

result_indexer=load('result_indexer')

require('join_funcs')

function ch_str(str,...)
	local ch_hello=checker_is:create(str,...)
	return ch_hello
end

function r_index(result)
	local obj=result_indexer:create(result)
	return obj
end
