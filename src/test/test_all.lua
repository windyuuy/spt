
require('lua_ext')

local function detect_submodules(dir,filter)
	local cur_dir=dir
	local names={}

	dir=dir or 1
	if(type(dir)=='number')then
		dir=dir+1
		cur_dir=debug.getinfo(dir,'S').source
		cur_dir=string.match(cur_dir,'^@(.+[\\/])')
	end

	filter=filter or '^[^/.].+'

	for filename in lfs.dir(cur_dir)do
		local name=string.match(filename,filter)
		if(name)then
			names[#names+1]=name
		end
	end
	return names
end

local names=detect_submodules(1,'^(test_.+).lua$')

local exclude_list={
	'test_all',
}

names=table.make_iexclude(names,exclude_list)

if(_DEBUG>1)then
	print('test items: ')
	look(names)
	print('')
end

--
--assert(
--	require_tests({
--		'test_debug_ext',
--		'test_my_ext',
--		'test_org',
--		'test_chars',
--		'test_charset',
--		'test_normal',
--		'test_recursion',
--		'test_min_match',
--		'test_parsers',
--		'test_true',
--		'test_tools_runfile',
--	},
--	'test'),'')

assert(require_tests(names,'test'),'')
