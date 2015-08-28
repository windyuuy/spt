
module('result_indexer',package.seeall)

function index(self,node_path,...)
	local aliases=string.split(node_path,'.')
	local end_alias,attr_name=unpack(string.split(aliases[#aliases],'@'))
	aliases[#aliases]=end_alias

	local node=self
	local cur_node
	for _,alias in ipairs(aliases) do
		cur_node=node.sub_result_list[alias]
		node=cur_node
	end

	local attr
	if(attr_name)then
		attr=node[attr_name]
		if(attr and type(attr)=='function')then
			attr=attr(node,...)
		end
		if(not attr)then
			local attr_func=result_indexer[attr_name]
			attr=attr_func(node,...)
		end

		assert(attr~=nil,'')
	end

	if(attr_name~=nil)then
		return attr
	else
		return node
	end

end

function create(self,result,alias)
	alias=alias or result.checker.alias
	local name =result.checker.name or alias
	local node={
		sub_result_list={
			[name]=result,
			[alias]=result,
		},
		index=self.index,
	}
	setmetatable(node,{__index=result_indexer})
	return node
end


