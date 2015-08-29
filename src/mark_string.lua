
module('mark_string',package.seeall)

function parse(line)
--	string = '(+ a b (+ c (+e f) k))'
	local chars_letters=ch_chars('abcdefghijklmnopqrstuvwxyz')
	local chars_words=ch_chars('abcdefghijklmnopqrstuvwxyz_',{'n'})
	local str_sign=ch_chars("'")
	local string_line_checker=ch_line({chars_words:create('wef'),ch_str('='),str_sign,chars_words:create('kllwe'),str_sign})
	local sline=lineinfo:create("lkjwelk='kljwe'")
	local sd=string_line_checker:check(sline)
	rdump(sd)
	local sdd=sd:raw_index()
	print(sdd.wef,sdd.kllwe)
	return sd.rawline
end 
