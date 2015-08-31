
module('parse_checker',package.seeall)

function parse(self,line)
--sump = $line{bracket op $or{$$sump word}[3,(4,5),(7,+)] un_bracket[1]}
--op = $or{[/=/ /&/ /+/]}
--$name(alias){list}[range_list] -> cho_name(alias,{list},{range_list})
	--------------
	-- 1). [/.../ /.../] -> ch_str('...'),ch_str('...')
	-- 2). $$name -> recursion
	-- 3). $name(alias){ -> cho_name(alias,{
	-- 4). }[(),()] -> },{{},{}}
	-- 5). whitespace -> ,
	
	local sline=line
	sline=string.gsub(sline,'/ /',"'),cho_str('")
	sline=string.gsub(sline,'\[/',"cho_str('")
	sline=string.gsub(sline,'/]',")")

	sline=string.gsub(sline,'$$w+','recursion')
	
	sline=string.gsub(sline,'$(w+)[(](w+)[)]{','cho_%1(%2,{')
	sline=string.gsub(sline,'$(w+){','cho_%1(nil,{')

	sline=string.gsub(sline,',[(]',',{')
	sline=string.gsub(sline,'[)],',',}')
	sline=string.gsub(sline,'\[[(]','{{')
	sline=string.gsub(sline,'\][)]','}}')

	sline=string.gsub(sline,' ',',')
	return sline
end
