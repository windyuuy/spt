# spt
string parser toolkit


//string = [/(+ a b (+ c (+e f) k))/]

//op = @rawset{= & + - * / %}

string = '(+ a b (+ c (+e f) k))'
op = $or{'=' '&' '+'}
sump = $line{bracket op $or{$$sump word}[3,(4,5),(7,+)] un_bracket[1]}

result = @involve<string,sump>

line = result.@rawline<>
line = result.@repeat_times<>
line = result.$line.bracket

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
	