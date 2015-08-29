
function requirelist(list)
	for i,v in ipairs(list) do
		require(v)
	end
end

requirelist({'strbuf','list','string_ext','dump'})

function table.makeclone(self,tt)
	assert(type(self)=='table','')
	tt=tt or {}
	for k,v in pairs(self) do
		tt[k]=v
	end
	return tt
end

function table.copy(self,tt)
	table.makeclone(tt,self)
end

function copy_module(t1,t2)
	local t3=table.makeclone(t2)
	t3._M=nil
	t3._NAME=nil
	t3._PACKAGE=nil

	table.copy(t1,t3)

end
--
--function string.split(s,d)
--	local lines={}
--	if(string.find(s,'([^'..d..']+)')~=1)then
--		lines[#lines+1]=''
--	end
--	for w in string.gmatch(s,'([^'..d..']+)')do
--		lines[#lines+1]=w
--	end
--	return lines
--end

function load(name)
	local back=_G[name]
	require(name)
	local mod=package.loaded[name]
	_G[name]=nil
	_G[name]=back
	return mod
end
