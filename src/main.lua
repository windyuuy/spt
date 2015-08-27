
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

function init_checker(module)

	local checker_false=load("checker_false")

	copy_module(module,checker_false)

end

requirelist({'lineinfo','dump'})

local checker_is=load("checker_is")
local checker_line=load("checker_line")
local checker_or=load("checker_or")

local function ch_str(str)
	local ch_hello=checker_is:create(str)
	return ch_hello
end

local function main()
	local ch_hello=ch_str('hello')
	local ch_world=ch_str('world')
	local ch_blanket=ch_str(' ')
	local ch_hallo=ch_str('hallo')
	local ch_hh=checker_or:create({ch_hello,ch_hallo})
	local ch_line=checker_line:create({ch_hello,ch_hello,ch_hh},'kljl',{3})
	local ch_line2=checker_line:create({ch_line,ch_blanket,ch_world},'kjlk')
	local info_hello=lineinfo.create('hellohellohallohellohellohellohellohellohello world')
	local result=ch_line2:check(info_hello,{1})
	vdump(result)
end

main()
