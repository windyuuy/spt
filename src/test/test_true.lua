
require('lua_ext')

require('checker')

local function main()
	local info_hello=lineinfo:create('hklphklpoij pion;nl')
	
	local ch_t=ch_true('','we',{2})
	
	local result=ch_t:check(info_hello,{3})
	
	rdump(result)
	
	print(result:index('@rawline'))
	
	local rresult=ch_t:raw_check(info_hello,{3})
	rdump(rresult)
	print(rresult[3])
	assert(rresult[3]~=nil)
	assert(rresult[4]==nil)

	for i=1,info_hello:len() do
		local result=ch_t:check(info_hello,{i})
		local rr=result:index('@rawline')
		assert(rr==info_hello:cutline(i))
	end

end

main()
