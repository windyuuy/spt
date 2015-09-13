
require('lua_ext')

assert(
	require_tests({
		'test_debug_ext',
		'test_my_ext',
		'test_chars',
		'test_normal',
		'test_recursion',
		'test_min_match',
		'test_parsers',
		'test_true',
		'test_tools_runfile',
	},
	'test'),'')
