
--module('parse_checker',package.seeall)

--local space=require('sparser.helper')
local space=rload('helper')

_G._sparser_space=space

function parse(self,line)
	--sump = $line(){bracket op $or(){$$sump word}[3,(4,5),(7,+)] un_bracket()[1]}[1]
	--chars={/lklwef/}
	--op = $or{[/=/ /&/ /+/]}
	--$name(alias){list}[range_list] -> cho_name(alias,{list},{range_list})

	local str_zend_reg='[^\\][(\\\\)]-'
	local str_end_reg=str_zend_reg..'/]'
	local str_body_reg='[^('..str_end_reg..')]'
	local str_reg='[[]/.+'..str_end_reg

	local chars_zend_reg=str_zend_reg
	local chars_end_reg=chars_zend_reg..'/}'
	local chars_body_reg='[^('..chars_end_reg..')]'

	local BEGIN_WITH='^'
	local WITH_END='$'
	local WORD_PATTERN='[_%w]+'
	local result=string.match(line,BEGIN_WITH..WORD_PATTERN..'=$'..WORD_PATTERN..'')
	result=result or string.match(line,BEGIN_WITH..WORD_PATTERN..'='..str_reg)
	result=result or string.match(line,BEGIN_WITH..WORD_PATTERN..'={/.+/}[[][^]]-]')
	result=result or string.match(line,BEGIN_WITH..WORD_PATTERN..'={/.+/}[^[]')
	-- above cannot detect line end with eof,like {/wef/} but {/wef/}aqwe
	result=result or string.match(line,BEGIN_WITH..WORD_PATTERN..'={/.+/}'..WITH_END)
	local result2=string.match(line,'^$'..WORD_PATTERN..'{')
	result2=result2 or string.match(line,''..str_reg)
	--	result2=result2 or string.match(line,'{/.+/}')
	result2=result2 or string.match(line,'{/.+/}[[][^]]-]')
	result2=result2 or string.match(line,'{/.+/}[^[]')
	result2=result2 or string.match(line,'{/.+/}[^[]'..WITH_END)

	if(not (result or result2))then
		return nil
	end

	local gsub=string.gsub

	local lines=string.split(line,'=',1)
	local markline,sline
	if(result)then
		markline=lines[1]
		sline=lines[2]
	else
		sline=lines[1]
	end

	--------------
	-- 6). <[{>/'"/<}]> -> <[{>/\'\"<}]>
	-- 5). <whitespace>}<whitespace><endofline> -> }
	-- 0). ^/.../$ ->  cho_chars('...')
	-- 1). $name<whitespace or }> -> $name{}<$1>
	-- 1). $name{ -> $name(){
	-- 2). }} -> } }
	-- 2). }<whitespace or endofline> -> }[]
	-- 3). name[ -> name()[
	-- 4). name(alias)<whitespace or }> -> name(alias)[]

	--	sline=gsub(sline,'^{/(.+)/}$',"ch_charset('%1'")
--	local cur_pos=1
--	local tlines={}
--	for seg,i,j in string.gmatch(sline,'{/('..chars_body_reg..'+)'..str_zend_reg..'/}') do
--		tlines[#tlines+1]=sline:sub(cur_pos,i)
--		tlines[#tlines+1]=sline:sub(i,j):gsub('('..str_zend_reg..')([\'\"])','%1\\%2')
--		cur_pos=j
--	end
	sline=gsub(sline,'({/[^\\]-[\\]-[^\\]-)([\'\"])(.-/})','%1\\%2%3')
	sline=gsub(sline,'({/[^\\]-[\\]-[^\\]-\\[\'\"][^\\]-[\\]-[^\\]-)([\'\"])(.-/})','%1\\%2%3')
	
	sline=gsub(sline,'%s+}%s-'..WITH_END,'}')
	sline=gsub(sline,'$('..WORD_PATTERN..')([ }])','$%1(){}[]%2')
	sline=gsub(sline,'$('..WORD_PATTERN..'){','$%1(){')
	sline=gsub(sline,'}}','} }')
	sline=gsub(sline,'} ','}[]')
	sline=gsub(sline,'}'..WITH_END,'}[]')
	sline=gsub(sline,'([^$]'..WORD_PATTERN..')[[]','%1()[')
	sline=gsub(sline,'([^$][(][%w\'\"]+[)])[ }]','%1[] ')

	--	print(sline)

	--------------
	-- 2). $$name -> recursion
	-- 3). (-,+) -> ('-','+')
	-- 4). $name(alias){ -> cho_name(alias,{
	-- 5). name(alias) -> name:create(alias
	--10). $chars(name){/.../} -> cho_chars('...',
	--0). {/.../} -> cho_chars('...',
	--11). [/`...`/] -> cho_regular('...',
	-- 1). [/.../ /.../] -> cho_rstr('...'),cho_rstr('...')
	-- 6). [] -> ,nil)
	-- 7). [(),()] -> ,{{},{}})
	-- 8). (, -> (nil,
	-- 9). whitespace -> ,

	-- collect recursor names
	local recursion_name_list={}
	for name in string.gmatch(sline,'$$('..WORD_PATTERN..')')do
		recursion_name_list[#recursion_name_list+1]=name
	end
	local in_recursion=(#recursion_name_list>0)
	
	-- 2). $$name -> recursion
	sline=gsub(sline,'$$'..'('..WORD_PATTERN..')'..'','recursion_%1')

	-- 3). (-,+) -> ('-','+')
	sline=gsub(sline,'([(,])([+-])([),])',"%1'%2'%3")

	-- 10). $chars(name){/.../} -> cho_chars('...',
	sline=gsub(sline,'$chars[\(]([%w\'"]+)[\)]{/(.-)([(\\\\)]-)/}[[]',"ch_charset('%2%3','%1'[")
	-- 4). $name(alias){ -> cho_name(alias,{
	sline=gsub(sline,'$('..WORD_PATTERN..')[(]([%w\"\']-)[)]{','cho_%1(%2,{')
	-- 5). name(alias) -> name:create(alias
	sline=gsub(sline,'([^$])('..WORD_PATTERN..')[(]([%w\'\"]-)[)]','%1%2:create(%3')

	--0). {/.../} -> cho_chars('...',
	sline=gsub(sline,'{/(.-)([(\\\\)]-)/}[[]',"ch_charset('%1%2',nil[")

	-- 1). [/`...`/ /`...`/] -> cho_regular('...'),cho_regular('...')
	--	sline=gsub(sline,'`/ /`',"'),cho_regular('")
	sline=gsub(sline,'[[]`^/',"cho_regular('")
	sline=gsub(sline,'('..str_zend_reg..')`/]',"%1')")
	
	-- 1). [/.../ /.../] -> cho_rstr('...'),cho_rstr('...')
	--	sline=gsub(sline,'/ /',"'),cho_rstr('")
	sline=gsub(sline,'[[]/',"cho_rstr('")
	sline=gsub(sline,'('..str_zend_reg..')/]',"%1')")

	-- 6). [] -> ,nil)
	sline=gsub(sline,'[[][]]',',nil)')

	-- 7). [(),()] -> ,{{},{}})
	sline=gsub(sline,',[(]',',{')
	sline=gsub(sline,'[)],','},')
	sline=gsub(sline,'[[][(]',',{{')
	sline=gsub(sline,'[)][]]','}})')
	sline=gsub(sline,'[[]',',{')
	sline=gsub(sline,']','})')

	sline=gsub(sline,'/ `^/',"'),cho_regular('")
	sline=gsub(sline,'/ /',"'),cho_rstr('")

	-- 8). (, -> (nil,
	sline=gsub(sline,'[(],','(nil,')

	-- 9). whitespace -> ,
	sline=gsub(sline,'([^\'"]) ([^\'"])','%1,%2')

	if(result)then
		sline=table.concat({markline,'=',sline})
	end
	
	if(in_recursion and #recursion_name_list>0)then
--		if
	end
	return sline
end

