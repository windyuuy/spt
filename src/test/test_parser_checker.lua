
require('lua_ext')

require('checker')

require('sparser')

local function main()

--	local sd=runner.runline("kk=$line(){[/kjwlef/ /lkjwlekjf/] bracket op $or(){$$sump word}[3,(4,5),(7,+)] un_bracket()[1]}[]")
--	sd=runner.runline('kk=$str(){"lkjlk"}[]')
--	sd=runner.runline('kk=$line(){[/kjwlef/ /lkjwlekjf/] $str(){"lkwjelf"}[]}[]')
--	local sd=runner.runline('kk=[/wfewef/]')

--	local sd2=runner.runline("kk=$line{[/kjwlef/ /lkjwlekjf/] bracket op $or{$$sump word}[3,(4,5),(7,+)] un_bracket[1]}")
--	local sd2=runner.runline("kk=$line{bracket op $or{$$sump word}[3,(4,5),(7,+)] un_bracket[1]}")
--	sd2=runner.runline('kk=$str(){"lkjlk"}')
--	sd2=runner.runline('kk=$line(){[/kjwlef/ /lkjwlekjf/] $str(){"lkwjelf"}[]}[]')
--	local sd2=runner.runline('kk=[/wfewef/]')
--	local sd2=runner.runline('[/wfewef/]')
	local sd2=runner.runline('{/wfewef/}[2,45]')
--	print(sd==sd2)
	print(sd2)
	local sd=eval(sd2)
--	local sd=ch_chars('wfewef',nil,{2,3})
	local wddf=lineinfo:create('wefwje')
	local sd=sd:check(wddf)
--	local sd=cho_rstr('wfewef')
--	local sd=cho_rstr('wfewef')
	rdump(sd)
end

cs_mem()

main()

show_mem()
