
require('lua_ext')

require('checker_init')

require('runner')

local function main()
--	local sd=runner.runline("ss = '(+ a b (+ c (+e f) k))'")
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
--	print(sd==sd2)
	print(sd2)
end

main()
