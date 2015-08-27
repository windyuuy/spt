
function init_checker(module)

	local checker_false=load("checker_false")

	copy_module(module,checker_false)

end

requirelist({'lineinfo'})
