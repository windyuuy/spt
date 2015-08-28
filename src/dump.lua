--- @brief ����ʱ��ӡ������ֵ
--- @param data Ҫ��ӡ���ַ�
--- @param [max_level] tableҪչ����ӡ�ļ���Ĭ��nil��ʾȫ��չ��
--- @param [prefix] �����ڵݹ�ʱ��������ò����û�ʹ����
--- @ref http://dearymz.blog.163.com/blog/static/205657420089251655186/
function var_dump(data, max_level, prefix)
	assert(var_dump~=print,'')
	if type(prefix) ~= "string" then
		prefix = ""
	end
	if type(data) ~= "table" then
		print(prefix .. tostring(data))
	else
		print(data)
		if max_level ~= 0 then
			local prefix_next = prefix .. "    "
			print(prefix .. "{")
			for k,v in pairs(data) do

				if(type(k)=='number')then
					io.stdout:write(prefix_next .. '[' .. k .. ']' .. " = ")
				else
					io.stdout:write(prefix_next .. k .. " = ")
				end

				if type(v) ~= "table" or (type(max_level) == "number" and max_level <= 1) then
					if(type(v)=='string')then
						print('\''..v..'\'')
					else
						print(v)
					end
				else
					if max_level == nil then
						var_dump(v, nil, prefix_next)
					else
						var_dump(v, max_level - 1, prefix_next)
					end
				end
			end
			print(prefix .. "}")
		end
	end
end

function vdump(data, max_level)
	var_dump(data, max_level or 5)
end

function rdump(data,max_level)
	var_dump(data, max_level or 2)
end
