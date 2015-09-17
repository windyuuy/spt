
rload('exlist_meta')

create= function(self,...)
	return exlist_meta:create(...)
end

local function _index_extends(t,k)
	local meta=getmetatable(t)

	local result
	local org_index=meta.__org_index
	if(type(org_index)=='table')then
		result=org_index[k]
	elseif(type(org_index)=='function')then
		result=meta.__org_index(t,k)
	end

	if(result)then return result end

	for i, v in ipairs(rawget(meta,'extlist')) do
		if(v[k])then
			return v[k]
		end
	end
	return nil
end

function extend(base,...)
	local meta=getmetatable(base)
	if(not meta)then
		meta={extlist=nil,__index=_index_extends}
		setmetatable(base,meta)
	end

	local original_index=meta.__index
	local extlist=meta.extlist

	assert(meta.extlist==nil or (meta.extlist~=nil and meta.__index==_index_extends))

	local v_extlist = {...}
	if(extlist==nil or #extlist==0)then
		extlist={...}
		meta.extlist=extlist
	else
		table.iextend(extlist,v_extlist)
	end

	local tmeta
	for k, v in ipairs(v_extlist) do
		tmeta=getmetatable(v_extlist)
		if(tmeta and tmeta._index_extends)then
			table.iextend(extlist,tmeta.extlist)
		end
	end

	if(meta.__index~=_index_extends)then
		meta.__org_index=meta.__index
		meta.__index=_index_extends
	end

	return base
end

function unextend(base,...)
	local v_extlist= {...}
	local meta=getmetatable(base)
	local extlist=meta.extlist
	for k, v in ipairs(v_extlist) do
		table.remove_value(extlist,v)
	end
	return base
end

function combine(...)
	return extend({},...)
end
