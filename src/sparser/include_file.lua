
function parse(self,line)
	local result
	result=string.match(line,'^#([%w\.]+)$')
	if(result)then
		local name=result
--		local refer_func_str,result=rdload(name)
		local line='refer_rule_module(\"'..name..'\",getfenv(1),\"'.._G._sparser_space['$_current_file_path']..'\")'
		return line,false
	else
		return nil
	end
end
