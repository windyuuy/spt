

module('result_indexer',package.seeall)

function index(self,node_path,...)
	local aliases=string.split(node_path,'[.]')
	--	local end_alias,attr_name=unpack(string.split(aliases[#aliases],'@'))
	local attr_name
	if(aliases[#aliases]:sub(1,1)=='@')then
		attr_name=aliases[#aliases]:sub(2)
		aliases[#aliases]=nil
	end

	local node=self
	local cur_node
	for _,alias in ipairs(aliases) do
		cur_node=node.sub_result_list[alias]
		node=cur_node
		if(node==nil)then break end
	end

	if(node==nil)then return nil end

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
		--		return result_indexer:create(node)
		return node
	end

end

function raw_index(self)
	local raw_list={}
	for k,v in pairs(self.sub_result_list) do
		raw_list[k]=v.rawline
	end
	return raw_list
end

--
--function add_result(self,result,alias)
--	self.sub_result_list[alias]=result
--end
--
--function create(self,result,alias)
--	local node
--	if(result)then
--		alias=alias or result.checker.alias
--		assert(alias,'')
--		--	local name =result.checker.name or alias
--		node={
----			result=result,
--			sub_result_list={
--				--			[name]=result,
--				[alias]=result,
--			},
--			index=self.index,
--		}
--	else
--		node={}
--	end
--	setmetatable(node,{__index=result_indexer})
--	return node
--end

--result_proto.index=index

table.copy(result_proto,result_indexer)
