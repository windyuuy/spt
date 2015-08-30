
module('mark_string',package.seeall)

function parse(self,line)
	local chars_letters=ch_chars('abcdefghijklmnopqrstuvwxyz')
	local chars_words=ch_chars('abcdefghijklmnopqrstuvwxyz_',{'n'})
	local str_sign=ch_chars("\"")
	local sentence=ch_not({str_sign},{'n'})
	local blankets=ch_str(' ',{'n'})
	local string_line_checker=ch_line({chars_words:create('varname'),blankets,ch_str('='),blankets,str_sign,sentence:create('body'),str_sign})
	local sline=lineinfo:create(line)
	local rawresult=string_line_checker:check(sline)
	if(true)then
		return 'local '..line
	else
		return nil
	end
end
