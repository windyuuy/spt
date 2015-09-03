
-- sudo mount -t ntfs-3g /dev/sda5 /home/happy/devs/proc -ro force

--require('socket')

package.path=package.path..';/home/happy/devs/proc/PCOM/lua/5.1/lua/?.lua;D:/PCOM/lua/5.1/lua/?.lua;'
--requirelist({'socket','strbuf','list','string_ext','dump'})
requirelist({'strbuf','list','string_ext'})
