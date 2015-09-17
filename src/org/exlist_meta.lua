
function get_exlist(self,...)
	return getmetatable(self).__extend_list
end
function set_exlist(self,exlist)
	getmetatable(self).__extend_list=exlist
end

function extend(self,...)
	local exlist =self:get_exlist()
	if(exlist==nil)then
		exlist={...}
	else
		exlist={unpack(exlist),...}
	end
	self:set_exlist(exlist)
	return self
end

function _get_type_index(self,obj)
	local exlist = self:get_exlist()
	return table.index_of_value(exlist,obj)
end

function unextend(self,...)
	local exclude_list={...}
	local exlist=self:get_exlist()
	table.exclude_by_value(exlist,exclude_list)
end
--
--function indexvalue(self,k)
--	local result
--	result=rawget(self,k)
--	if(result~=nil)then return result end
--	local meta=getmetatable(self)
--	local exlist=meta.get_exlist(self)
--	if(exlist)then
--		for _,item in ipairs(exlist) do
--			result=item[k]
--			if(result)then return result end
--		end
--	end
--	return meta[k]
--
--end

function indexvalue(self,k)
	local result
--	result=rawget(self,k)
--	if(result~=nil)then return result end
--	local meta=getmetatable(self)
	local exlist=exlist_meta.get_exlist(self)
	if(exlist)then
		for _,item in ipairs(exlist) do
			result=item[k]
			if(result)then return result end
		end
	end
	return exlist_meta[k]

end

--local org_meta=exlist_meta
function create(self,...)
	local t={}
--	local meta={__index=org_meta.indexvalue}
--	setmetatable(meta,{__index=org_meta})
--	setmetatable(t,meta)
	local meta={__index=self.indexvalue}
	setmetatable(t,meta)
	t:extend(self,...)
	return t
end
