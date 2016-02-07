
_DEBUG=1
--_root_path='/home/happy/workspace/spt/src/'
local function get_pwd()
	local cur_dir

	cur_dir=debug.getinfo(1,'S').source:sub(2)

	return cur_dir
end
local function get_project_dir()
	local pwd=get_pwd()
	pwd=string.gsub(pwd,'\\','/')
	pwd=string.gsub(pwd,'//','/')
	pwd=string.match(pwd,'^(.+)/[^/]+/[^/]+/[^/]+$')
	if(string.match(pwd,'^/cygdrive'))then
		local driver=string.match(pwd,'^/cygdrive/([^/]+)/.+$')
		local addition=string.match(pwd,'^/cygdrive/[^/]+(/.+)$')
		pwd=(driver and string.upper(driver)..':'..addition) or pwd
	end
	--	pwd=string.match(pwd,'^\@(.+)[\\/].+[\\/].+$',init)
	pwd=pwd..'/'
	return pwd
end

local platform=os.platform and os.platform()
local default_pj_dir=( platform=='win32' and 'F:/User/workspace/gdh/spt/')
	or (platform=='linux' and '/home/happy/workspace/spt/')
	or nil

_project_path=get_project_dir() or default_pj_dir
_root_path=_project_path..'src/'

--print('project path :',_project_path)

_rd_config={
	preset_rd_path_list={
		_project_path..'rdlib/',
	},
	preset_rd_ext_list={
		'.rd',
		'/init.rd',
	},
}
