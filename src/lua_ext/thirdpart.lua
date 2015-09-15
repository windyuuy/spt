
-------------------------
-- third-part lua packages mainly come from official site
--// I use the lua version 5.1 with ext-lib from https://www.baidu.com/link?url=KE2tM1rwftxWNDx2990C9SG3klTg3E7kVmK3QqwVVdJAoBxz0MuCwz00Rxe-1By-&wd=&eqid=c2bc4581000057c30000000355e988b4
-- then I use luarocks instead
--

-- sudo mount -t ntfs-3g /dev/sda5 /home/happy/devs/proc -ro force

--require('socket')

-- config path of lua ext-lib manualy there
if(_VERSION=='Lua 5.1')then
--	package.path=package.path..';/home/happy/devs/proc/PCOM/lua/5.1/lua/?.lua;D:/PCOM/lua/5.1/lua/?.lua;'
	package.cpath=';/home/happy/.luarocks/lib/lua/5.1/?.so;'..package.cpath
	package.path=';/home/happy/.luarocks/share/lua/5.1/?.lua;'..package.path
	package.cpath=package.cpath..';/home/happy/softs/lua-5.1.4/lib/lua/5.1/?.so;'
	package.cpath=package.cpath..';/usr/lib/lua/5.1/?.so;'
--	package.cpath=package.cpath..';D:/PCOM/lua/5.1/clibs/?.dll;'
elseif(_VERSION=='Lua 5.2')then
	package.path=package.path..';/home/happy/devs/proc/PCOM/lua/5.1/lua/?.lua;D:/PCOM/lua/5.1/lua/?.lua;'
	package.cpath=package.cpath..';/usr/lib/lua/5.2/?.so;'
elseif(_VERSION=='Lua 5.3')then
	package.path=package.path..';/home/happy/devs/proc/PCOM/lua/5.1/lua/?.lua;D:/PCOM/lua/5.1/lua/?.lua;'
	package.cpath=package.cpath..';/usr/lib/lua/5.3/?.so;'
end

-- considering replace all with luarocks
--requirelist({'strbuf','list','string_ext'})

local stringy=require('stringy')
table.copy(string,stringy,{
	'split',
	'count',
	'startswith',
	'endswith',
})

function eval(ss)
	return loadstring('return '..ss)()
end
