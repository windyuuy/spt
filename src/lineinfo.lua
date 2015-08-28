
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
	if(self.curpos>self.endpos+1)then
		self.overflowpos=self.curpos
		self.curpos=self.endpos+1
	end
end

local function snapshot(self)
	local s=table.clone(self)
	for k,v in pairs(s) do
		if(type(v)=='function')then
			s[k]=nil
		end
	end
	return s
end

function create(line)
	return {
		rawline=line,
		curpos=1,
		endpos=line:len(),

		compare=compare,
		clone=clone,
		skip_by=skip_by,
		snapshot=snapshot,
	}
end
