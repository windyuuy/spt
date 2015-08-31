local sline="$line{bracket op(kk)[3] $or{$$sump word}[3,(4,5),(7,+)] un_bracket[1] ew(we)}[2]"
sline=string.gsub(sline,'/ /',"'),cho_str('")
sline=string.gsub(sline,'[[]/',"cho_str('")
sline=string.gsub(sline,'/]',")")

sline=string.gsub(sline,'$$%w+','recursion')

sline=string.gsub(sline,',[(]',',{')
sline=string.gsub(sline,'[)],','},')
sline=string.gsub(sline,'[[][(]',',{{')
sline=string.gsub(sline,'[)][]] ','}}) ')
sline=string.gsub(sline,'[[]',',{')
sline=string.gsub(sline,'[]] ','}) ')
--sline=string.gsub(sline,'([^$])(%w+)[[](%w+)[]]','%1%2:create(nil,{%3},nil)')
--sline=string.gsub(sline,'([^$])(%w+)[(](%w+)[)]','%1%2:create(%3,nil,nil)')
sline=string.gsub(sline,'([^$])(%w+)[(](%w+)[)]({[^ ]+})',"%1%2:create('%3',nil,%4)")
sline=string.gsub(sline,'([^$])(%w+)[(](%w+)[)]',"%1%2:create('%3',nil,nil)")
sline=string.gsub(sline,'([^$])(%w+)({[^ ]+})',"%1%2:create(nil,nil,%3)")

sline=string.gsub(sline,'$(%w+)[(](%w+)[)]{','cho_%1(%2,{')
sline=string.gsub(sline,'$(%w+){','cho_%1(nil,{')

--sline=string.gsub(sline,' ',',')

print(sline)
