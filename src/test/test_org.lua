
__'lua_ext'

rload('org.exlist')

local sdf=exlist:create()
function sdf:dsd(kl)
	print(kl,self.b)
end

local klwj=exlist:create()
klwj.b='weklf'

local c=exlist:create(sdf)
c:extend(sdf,klwj)

c:dsd(23)

a={32445,234234,34534}
b={32445,345,4564,47}
c={3254,34656,}

d={}
table.iextend(d,a)
table.iextend(d,b)
look(d)

a={sdf=23,fwe=345}
b={e3=23,qew=23,34,345}
c={234,346,345,546,wef3=34,ewf='lkwejf',e3=34}
d=exlist.combine(a,b,c)
look(d)
for i=1,5 do
	print(d[i])
end
print(d.sdf,d.e3,d.qew,d.ewf)

setmetatable(a,{__index={454,qew=45}})
e=exlist.extend(a,b,c)
look(e)
assert(e[1]==454)
for i=1,5 do
	print(e[i])
end
print(e.sdf,e.e3,e.qew,e.ewf)
