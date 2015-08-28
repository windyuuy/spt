
function join_results(results)
	local rawline_list={}
	for _,v in ipairs(results) do
		assert(v~=nil,'')
		if(type(v)=='string')then
			rawline_list[#rawline_list+1]=v
		else
			rawline_list[#rawline_list+1]=v.result.rawline
		end
	end

	local rawline=table.concat(rawline_list)

	return rawline
end
