
module('runner',package.seeall)

local parsers=require('sparser.parsers')

function runline(line)
	local result,type,rtype
	local results={}
	for k,v in pairs(parsers)do
		result,type=v:parse(line)
		if(result~=nil)then
			results[#results+1]=result
			rtype=type
		end
	end
	assert(#results==1,'')
	return results[1],rtype
end
