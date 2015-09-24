
//string = [/(+ a b (+ c (+e f) k))/]

//chars={/lklwef/}[2,(3,4)]

//op = @rawset{= & + - * / %}

string = '(+ a b (+ c (+e f) k))'
op = $or{[/=/ /&/ /+/]}
sump = $line(ljk){bracket op $or{$$sump word}[3,(4,5),(7,+)] un_bracket[1]}

result = @check<string,sump>

line = result.@rawline<>
line = result.@repeat_times<>
line = result.bracket

// 最小匹配使用数值范围内加 'min' 指示

// 预定义关系符：$line $or $not $is $and
// 关系符=符号引用+递归调用+循环调用计数
// 循环调用计数采用范围内，单纯最大匹配或最小匹配，因为适度匹配的条件太相对
// 循环计数范围使用静态数，由外部生成表达串时引入动态性（仍然损失了一层动态性），不考虑效率，且一般用不到复杂范围
// 代号静态确定
// 引用顺序表:以元检查子或检查子为基本单位
// 检查子=引用顺序表+关系符
// 检查子操作: 
  // 1.接收临时检查树当前节点，检查子按照关系符定义引用顺序表，
  // 2.递归调用顺序表内引用的检查子，传入临时检查树当前节点
  // 3.每次引用完检查子，根据关系符定义校验判断检查子返回结果
  // 4.检查完毕，将检查结果以对应代号挂入临时检查树，给父级返回检查结果
检查子原型:
	checker(data):
		@check<lineinfo,count_ranges> return 结果树节点
		alias=name
		preset_count_range=1
		
结果树节点原型：
	alias={matched,checker,rawline,subrawline_list[],repeat_times,sub_result_list[],lineinfo_snapshot}
	
外围节点原型：
	直接使用检查子原型
	
结果索引封装：
	1.结果节点索引
	2.结果节点属性索引法一套


解释器规则：
	1.$and{...} -> checker_and({...})
	2.[/../ /../] -> ch_str('..') ch_str('..')
	3.递归
		local recursion=checker_recurse:create()
		local ch_line=checker_line:create({ch_str('hello'),checker_or:create({recurs
ion,checker_not:create({ch_hello})})})
		recursion:set_recursor(ch_line)
	4.='...' -> ='...'
	5.=[/.../] -> =ch_str('...')
	6.=@check<checker,lineinfo,...> -> =checker_check(checker,lineinfo,...)
	7.=result.... -> =result:index('...')
	8.使用loadfile 和 loadstring 两种
	
检测：
	1.mark_string	='...' -> ='...'
	2.parse_checker	$name{...} -> checker_name({...})
	3.mark_checker	=$name{...} -> =checker_name({...})
	4.parse_string_checker	[/.../ /.../] -> ch_str('..') ch_str('..')
	5.mark_string_checker	=[/.../] -> =ch_str('..')
	6.parse_recursion	$$name -> 
	7.parse_check	=@check<checker,lineinfo,...> -> =checker_check(checker,lineinfo,...)
	8.mark_result	name=@ -> name=
	9.parse_result_index	=result.... -> =result:index('...')
	10.loadstring
	11.loadfile
	12.parse_regular_checker [`^...] -> ch_regular('...')
	
pre-convert:
	1.自顶向下引用
	2.内嵌

frame-run{checker->parser->runtime-coder}

<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-----			improve		----->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

1.补加recursion功能并详测


<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-----			over		----->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

增加矩阵
从外部增加组件
丰富库
稳固测试
lisp(scheme or clojure) style

<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-----			plan		----->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


regular-map with ui or ui-interface[input,output]:
	1.visio? shell? mind_manager? onenote? notepad?


regular-tree(line-or-reg(filt_set-and-not){logic-sign:$@#})

grammar-tree-template
