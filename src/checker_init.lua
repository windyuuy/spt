
require('checker_preload')

checker_is=load("checker_is")
checker_line=load("checker_line")
checker_or=load("checker_or")

function ch_str(str)
	local ch_hello=checker_is:create(str)
	return ch_hello
end
