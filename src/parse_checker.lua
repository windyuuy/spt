
module('parse_checker',package.seeall)

function parse(self,line)
	--sump = $line(){bracket op $or(){$$sump word}[3,(4,5),(7,+)] un_bracket()[1]}[1]
	--op = $or{[/=/ /&/ /+/]}
	--$name(alias){list}[range_list] -> cho_name(alias,{list},{range_list})
	--------------
	-- 1). [/.../ /.../] -> ch_str('...'),ch_str('...')
	-- 2). $$name -> recursion
	-- 0). (-,+) -> ('-','+')
	-- 3). $name(alias){ -> cho_name(alias,{
	-- 5). name(alias) -> name:create(alias
	-- 5). [] -> ,nil)
	-- 4). [(),()] -> ,{{},{}})
	-- 6). (, -> (nil,
	-- 7). whitespace -> ,

	local lines=string.split(line,'=',1)
	local markline=lines[1]
	local sline=lines[2]

	sline=string.gsub(sline,'/ /',"'),cho_str('")
	sline=string.gsub(sline,'[[]/',"cho_str('")
	sline=string.gsub(sline,'/]',")")

	sline=string.gsub(sline,'$$%w+','recursion')

	sline=string.gsub(sline,'([(,])([+-])([),])',"%1'%2'%3")

	sline=string.gsub(sline,'$(%w+)[(](%w-)[)]{','cho_%1(%2,{')
	sline=string.gsub(sline,'([^$])(%w+)[(](%w-)[)]','%1%2:create(%3')

	sline=string.gsub(sline,'[[][]]',',nil)')

	sline=string.gsub(sline,',[(]',',{')
	sline=string.gsub(sline,'[)],','},')
	sline=string.gsub(sline,'[[][(]',',{{')
	sline=string.gsub(sline,'[)][]]','}})')
	sline=string.gsub(sline,'[[]',',{')
	sline=string.gsub(sline,']','})')

	sline=string.gsub(sline,'[(],','(nil,')

	sline=string.gsub(sline,' ',',')
	
	sline=table.concat({'local ',markline,'=',sline})
	return sline
end
