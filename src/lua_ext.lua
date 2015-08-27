
function load(name)
	local back=_G[name]
	require(name)
	local mod=package.loaded[name]
	_G[name]=nil
	_G[name]=back
	return mod
end

function requirelist(list)
	for i,v in ipairs(list) do
		require(v)
	end
end

function table.clone(self,tt)
	assert(type(self)=='table','')
	tt=tt or {}
	for k,v in pairs(self) do
		tt[k]=v
	end
	return tt
end

function table.merge(self,tt)
	table.clone(tt,self)
end
table.copy=table.merge

function copy_module(t1,t2)
	local t3=table.clone(t2)
	t3._M=nil
	t3._NAME=nil
	t3._PACKAGE=nil

	table.copy(t1,t3)

end

requirelist({'dump'})
