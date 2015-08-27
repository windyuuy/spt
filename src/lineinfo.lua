
module('lineinfo',package.seeall)

local function compare(self,str)
	local cut=self.rawline:sub(self.curpos,str:len()+self.curpos-1)
	return (cut==str)
end

function clone(self)
	local self_copy={}
	for k,v in pairs(self)do
		self_copy[k]=v
	end
	
	return self_copy
end

function skip_by(self,str_obj)
	local len=str_obj:len()
	self.curpos=self.curpos+len
	if(self.curpos>self.endpos)then
		self.curpos=self.endpos+1
	end
end

function create(line)
	return {
		rawline=line,
		curpos=1,
		endpos=line:len(),

		compare=compare,
		clone=clone,
		skip_by=skip_by,
	}
end
