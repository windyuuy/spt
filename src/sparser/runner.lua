
module('runner',package.seeall)

local parsers=require('sparser.parsers')

function parseline(line)
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

function runcontent(lines,index)
	index=index or 1
	index=index+1
	local codeline,content
	local codelines={}
	if(type(lines)=="table")then
		lines=ipairs(lines)
	end
	for line in lines do
		if(string.match(line,'^%s.$'))then
		else
			codeline=parseline(line)
			codelines[#codelines+1]=codeline
		end
	end
	content=table.concat(codelines,'\n')
	return exec(content,false,index)

end

function exec(content,type,index)
	index=index or 1
	index=index+1
	if(type)then
		return eval(content)
	else
		if(_DEBUG==1)then
			print(content)
		end
		local func=loadstring(content)
		if(func)then
			setfenv(func,getfenv(index)._M or getfenv(index))
			return func()
		else
			debug_execfunc(content,index+1)
			return nil
		end
	end
end

function debug_execfunc(content,index)
	index=index or nil
	index=index+1
	if(string.byte(content,#content)~=string.byte('\n',1))then
		content=content..'\n'
	end
	local line_number=1
	local broken=false
	local broken_line
	local func
	if(not content)then
		print('break at first')
	end
	for line in string.gmatch(content,'(.-)\n')do
		func=loadstring(line)
		--		assert(func,'line:\t'..line_number..', '..line)
		if(not func)then
			broken=true
			broken_line=line
			break
		end
		line_number=line_number+1
	end
	if(broken)then
		print('break in line:',line_number,broken_line)
	else
		print('break by unknown reason')
	end
	assert(false,'')
end

function runfile(name,index)
	index=(index or 1)+1
	local f=io.open(name)
	if(f)then
		runner.runcontent(f:lines(),index)
		f:close()
	else
		print('file not exist:'..name)
		assert(f,'')
	end
end
