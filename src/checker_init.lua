
require('checker_preload')

checker_is=load("checker_is")
checker_line=load("checker_line")
checker_or=load("checker_or")

result_indexer=load("result_indexer")

function ch_str(str,...)
	local ch_hello=checker_is:create(str,...)
	return ch_hello
end

function r_index(result)
	local obj=result_indexer:create(result)
	return obj
end
