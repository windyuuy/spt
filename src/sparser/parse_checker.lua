
module('parse_checker',package.seeall)

local space=require('sparser.helper')
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

	local result=string.match(line,'^%w+=$%w+')
	result=result or string.match(line,'^%w+='..str_reg)
	result=result or string.match(line,'^%w+={/.+/}[[][^]]-]')
	result=result or string.match(line,'^%w+={/.+/}[^[]')
	-- above cannot detect line end with eof,like {/wef/} but {/wef/}aqwe
	result=result or string.match(line,'^%w+={/.+/}$')
	local result2=string.match(line,'^$%w+{')
	result2=result2 or string.match(line,''..str_reg)
	--	result2=result2 or string.match(line,'{/.+/}')
	result2=result2 or string.match(line,'{/.+/}[[][^]]-]')
	result2=result2 or string.match(line,'{/.+/}[^[]')
	result2=result2 or string.match(line,'{/.+/}[^[]$')

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
	-- 0). ^/.../$ ->  cho_chars('...')
	-- 1). $name<whitespace or }> -> $name{}<$1>
	-- 1). $name{ -> $name(){
	-- 2). }} -> } }
	-- 2). }<whitespace or endofline> -> }[]
	-- 3). name[ -> name()[
	-- 4). name(alias)<whitespace or }> -> name(alias)[]

	--	sline=gsub(sline,'^{/(.+)/}$',"ch_charset('%1'")
	sline=gsub(sline,'$(%w+)([ }])','$%1(){}[]%2')
	sline=gsub(sline,'$(%w+){','$%1(){')
	sline=gsub(sline,'}}','} }')
	sline=gsub(sline,'} ','}[]')
	sline=gsub(sline,'}$','}[]')
	sline=gsub(sline,'([^$]%w+)[[]','%1()[')
	sline=gsub(sline,'([^$][(][%w\'\"]+[)])[ }]','%1[] ')

	--	print(sline)

	--------------
	-- 2). $$name -> recursion
	-- 3). (-,+) -> ('-','+')
	-- 4). $name(alias){ -> cho_name(alias,{
	-- 5). name(alias) -> name:create(alias
	--0). {/.../} -> cho_chars('...',
	-- 1). [/.../ /.../] -> cho_rstr('...'),cho_rstr('...')
	-- 6). [] -> ,nil)
	-- 7). [(),()] -> ,{{},{}})
	-- 8). (, -> (nil,
	-- 9). whitespace -> ,

	-- 2). $$name -> recursion
	sline=gsub(sline,'$$%w+','recursion')

	-- 3). (-,+) -> ('-','+')
	sline=gsub(sline,'([(,])([+-])([),])',"%1'%2'%3")

	-- 4). $name(alias){ -> cho_name(alias,{
	sline=gsub(sline,'$(%w+)[(]([%w\"\']-)[)]{','cho_%1(%2,{')
	-- 5). name(alias) -> name:create(alias
	sline=gsub(sline,'([^$])(%w+)[(]([%w\'\"]-)[)]','%1%2:create(%3')

	--0). {/.../} -> cho_chars('...',
	sline=gsub(sline,'{/(.-)([(\\\\)]-)/}[[]',"ch_charset('%1%2',nil[")

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

	sline=gsub(sline,'/ /',"'),cho_rstr('")

	-- 8). (, -> (nil,
	sline=gsub(sline,'[(],','(nil,')

	-- 9). whitespace -> ,
	sline=gsub(sline,' ',',')

	if(result)then
		sline=table.concat({markline,'=',sline})
	end
	return sline
end

