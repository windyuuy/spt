local line="$line(){bracket op $or(){$$sump word}[3,(4,5),(7,+)] un_bracket()[1]}[1]"
local sline=line
sline=string.gsub(sline,'/ /',"'),cho_str('")
sline=string.gsub(sline,'[[]/',"cho_str('")
sline=string.gsub(sline,'/]',")")

sline=string.gsub(sline,'$$%w+','recursion')

sline=string.gsub(sline,'$(%w+)[(](%w-)[)]{','cho_%1(%2,{')
sline=string.gsub(sline,'([^$])(%w+)[(](%w-)[)]','%1%2:create(%3')

sline=string.gsub(sline,'([(,])([+-])([),])',"%1'%2'%3")

sline=string.gsub(sline,',[(]',',{')
sline=string.gsub(sline,'[)],','},')
sline=string.gsub(sline,'[[][(]',',{{')
sline=string.gsub(sline,'[)][]]','}})')
sline=string.gsub(sline,'[[]',',{')
sline=string.gsub(sline,']','})')

sline=string.gsub(sline,'[(],','(nil,')

sline=string.gsub(sline,' ',',')
print(sline)
