
-- a-z => {x:char|a<=x<=z}

module('checker_charset',package.seeall)

init_checker(checker_charset,load('checker_chars','checker'))

function get_compare_func(self,sub_result_list)
	local function compare(lineinfo)
		--		local sub_result_list=sub_result_list
		local data=self.checker_list
		local matched=false
		local str_obj

--		local charsets,extra_data=self:parse_charsrange(data)
		data=data:gsub('([\[\]\(\)]\'"])','\%1')

		local cc=lineinfo:cutline(1)

		matched=(string.match(cc,'['..data..']')~=nil)
--
--		local function belong_to_charsets(cc)
--			for i,v in ipairs(charsets)do
--				if(v[1]<=cc<=v[2])then
--					matched=true
--					break
--				end
--			end
--		end
--		
--		matched=matched or belong_to_charsets(cc)

		str_obj=cc

		--sub_result_list

		return matched,str_obj
	end

	return compare
end
