
module('parse_checker',package.seeall)

require('sparser.helper')

function parse(self,line)
	--sump = $line(){bracket op $or(){$$sump word}[3,(4,5),(7,+)] un_bracket()[1]}[1]
	--chars={/lklwef/}
	--op = $or{[/=/ /&/ /+/]}
	--$name(alias){list}[range_list] -> cho_name(alias,{list},{range_list})

	local result=string.match(line,'%w+=$%w+')
	result=result or string.match(line,'%w+=[[]/.+/]')
	result=result or string.match(line,'%w+={/.+/}[[][^]]-]')
	result=result or string.match(line,'%w+={/.+/}[^[]')
	local result2=string.match(line,'$%w+{')
	result2=result2 or string.match(line,'[[]/.+/]')
	--	result2=result2 or string.match(line,'{/.+/}')
	result2=result2 or string.match(line,'{/.+/}[[][^]]-]')
	result2=result2 or string.match(line,'{/.+/}[^[]')

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
	-- 1). $name{ -> $name(){
	-- 2). }<whitespace or endofline> -> }[]
	-- 3). name[ -> name()[
	-- 4). name(alias)<whitespace or }> -> name(alias)[]

	--	sline=gsub(sline,'^{/(.+)/}$',"ch_chars('%1'")

	sline=gsub(sline,'$(%w+){','$%1(){')
	sline=gsub(sline,'} ','}[]')
	sline=gsub(sline,'}$','}[]')
	sline=gsub(sline,'([^$]%w+)[[]','%1()[')
	sline=gsub(sline,'([^$][(]%w+[)])[ }]','%1[]')

	--	print(sline)

	--------------
	--0). {/.../} -> cho_chars('...',
	-- 1). [/.../ /.../] -> cho_rstr('...'),cho_rstr('...')
	-- 2). $$name -> recursion
	-- 3). (-,+) -> ('-','+')
	-- 4). $name(alias){ -> cho_name(alias,{
	-- 5). name(alias) -> name:create(alias
	-- 6). [] -> ,nil)
	-- 7). [(),()] -> ,{{},{}})
	-- 8). (, -> (nil,
	-- 9). whitespace -> ,

	sline=gsub(sline,'{/(.-)/}[[]',"ch_chars('%1',nil[")

	--	sline=gsub(sline,'/ /',"'),cho_rstr('")
	sline=gsub(sline,'[[]/',"cho_rstr('")
	sline=gsub(sline,'/]',"')")

	sline=gsub(sline,'$$%w+','recursion')

	sline=gsub(sline,'([(,])([+-])([),])',"%1'%2'%3")

	sline=gsub(sline,'$(%w+)[(](%w-)[)]{','cho_%1(%2,{')
	sline=gsub(sline,'([^$])(%w+)[(](%w-)[)]','%1%2:create(%3')

	sline=gsub(sline,'[[][]]',',nil)')

	sline=gsub(sline,',[(]',',{')
	sline=gsub(sline,'[)],','},')
	sline=gsub(sline,'[[][(]',',{{')
	sline=gsub(sline,'[)][]]','}})')
	sline=gsub(sline,'[[]',',{')
	sline=gsub(sline,']','})')

	-----
	--
	sline=gsub(sline,'/ /',"'),cho_rstr('")

	sline=gsub(sline,'[(],','(nil,')

	sline=gsub(sline,' ',',')

	if(result)then
		sline=table.concat({'local ',markline,'=',sline})
	end
	return sline
end
