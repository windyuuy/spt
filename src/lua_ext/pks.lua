
------------
-- package support
--

local function get_pkname(pkname)
	if(pkname)then
		pkname=pkname .. '.'
	else
		pkname=''
	end
	return pkname
end

function requirelist(list,pkname)
	pkname=get_pkname(pkname)
	for i,v in ipairs(list) do
		require(pkname .. v)
	end
end

function require_tests(list,pkname)
	pkname=get_pkname(pkname)
	for i,v in ipairs(list) do
		if(not require(pkname .. v))then
			return false
		end
	end
	return true
end

function load(name,pkname)
	pkname=get_pkname(pkname)
	local back=_G[name]
	require(pkname..name)
	local mod=package.loaded[name]
	_G[name]=nil
	_G[name]=back
	return mod
end
