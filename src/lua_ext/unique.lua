
function table.makeclone(self,tt)
	assert(type(self)=='table','')
	tt=tt or {}
	for k,v in pairs(self) do
		tt[k]=v
	end
	return tt
end

function table.copy(self,tt,tlist)
	if(type(tlist)=='table')then
		for k,v in ipairs(tlist)do
			self[v]=tt[v]
		end
	else
		table.makeclone(tt,self)
	end
end

function table.iextend(t1,t2)
	for k, v in ipairs(t2) do
		t1[#t1+1]=v
	end
end

function table.exclude_by_value(t,exclude_list)
	for _, item in ipairs(exclude_list) do
		table.remove_value(t,item)
	end
end

function table.remove_value(t,value)
	for i,v in pairs(t) do
		if(v==value)then
			if(type(i)=="number")then
				repeat
					table.remove(t,i)
				until(t[i]~=value)
			else
				rils[#rils+1]=i
			end
		end
	end
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
