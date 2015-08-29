
module('runner',package.seeall)

local parsers=require('parsers')

function runline(line)
	local result
	local results={}
	for k,v in pairs(parsers)do
		result=v:parse(line)
		if(result~=nil)then
			results[#results+1]=result
		end
	end
	assert(#results==1,'')
	return results[1]
end
