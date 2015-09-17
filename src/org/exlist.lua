
rload('exlist_meta')

create= function(self,...)
	return exlist_meta:create(...)
end

local function _index_extends(t,k)
	local meta=getmetatable(t)

	for i, v in ipairs(rawget(meta,'extlist')) do
		if(v[k])then
			return v[k]
		end
	end
	return nil
end

function extend(base,...)
	local v_extlist = {...}
	local extlist=table.makeclone(v_extlist)

	for k, v in ipairs(v_extlist) do
		table.iextend(extlist,v_extlist)
	end

	local meta={extlist=extlist,__index=_index_extends}
	setmetatable(base,meta)
	return base
end

function combine(...)
	return extend({},...)
end
