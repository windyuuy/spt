
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

function table.iindex_by_value(t,v)
	for k, v2 in ipairs(t) do
		if(v2==v)then return k end
	end
	return nil
end

function table.index_by_value(t,v)
	for k, v2 in pairs(t) do
		if(v2==v)then return k end
	end
	return nil
end

function table.make_iexclude(t1,t2)
	local t3={}
	for k, v in ipairs(t1) do
		if(table.iindex_by_value(t2,v)==nil)then
			t3[#t3+1]=v
		end
	end
	return t3
end

function table.make_exclude(t1,t2)
	local t3={}
	for k, v in pairs(t1) do
		if(t2[k]~=v)then
			t3[k]=v
		end
	end
	return t3
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

function table.icontent_eq(t1,t2)
	local t3={}
	for k, v in ipairs(t1) do
		if(table.iindex_by_value(t2,v)==nil)then
			return false
		end
	end
	return true
end
