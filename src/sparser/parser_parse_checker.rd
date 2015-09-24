
# basic:	$?(word_name)!{$recurse}?[num_range_list]
# def_str:	?(word_name)![/str/ `^/reg/]
# def_chars:	?(word_name)!{/charset or reg_charset/}?[num_range_list]
# whole_line= $line{$or{basic,def_str,def_char}['n']}


checker=$line{$or{basic def_str def_char word}['n']}
	basic=$line{[/$/] word_name['?'] lbracket_l {$$checker blankets} lbracket_r num_range_list}
		num_range_list=$line{mbracket_l $or{$line{mbracket p_number dot p_number mbracket} $line{mbracket p_number mbracket}} mbracket}
			p_number=$or{$line{{/'/} {/n?+-/} {/'/}} number}
	def_str=$line{word_name mbracket $or{$line{slash raw_str_body slash} $line{/`^/ slash str_body slash}} mbracket}
	def_char=$line{word_name $line{lbracket_l slash raw_str_body slash lbracket_r}['?'] num_range_list}
	word_name=$line{bracket_l word bracket_r}
	str_body=$not{str_end_sign}['n']
	str_end_sign=
	
	>>>增加 blankets
	>>>