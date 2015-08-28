
function set_recursor(symbol,recursor)
	assert(type(symbol)=='table','')

	setmetatable(symbol,{__index=recursor})
	
end
	