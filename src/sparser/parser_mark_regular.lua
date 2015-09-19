
function parse(self,line)
	local result,result2
	result=string.match(line,'^[_%w]+=/.+/$')
	result2=string.match(line,'^/.+/$')
	if(result or result2)then
		local head=string.match(line,'^([_%w]+=)')
		if(not result2)then
			line=string.match(line,'^[_%w]+=(.+)$',init)
		end

		local oline=line
		local line=string.gsub(line,'^/([\'\"])(.+[\'\"])/$','%1^%2')
		local line=string.gsub(line,'^/(.+)/$','\"^%1\"')
		assert(line~=oline and (line:len()==(oline:len()+1) or line:len()==(oline:len()-1)))
		line='cho_regular(nil,'..line..',nil)'
		if(result2)then
			return line,false
		else
			return head..line,true
		end
	else
		return nil
	end
end
