bracket={/()/}
single_quote={/'/}
double_quote={/"/}
quote={/"'/}
___test={/e"f\\e'/}
___test=/[_%w+]/
___test=$line{[/wef/ `^/_%w+/]}
word={/abcdefghijklmnopqrstuvwxyz_1234567890/}[5]
tab={/\t/}
ednd=$not{tab}
whitespace={/ /}
