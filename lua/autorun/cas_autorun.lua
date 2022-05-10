CAS = CAS or {}

local FileCl = SERVER and AddCSLuaFile or include
local FileSv = SERVER and include or function() end

FileSv( 'cas/sv_init.lua' )
FileCl( 'cas/cl_init.lua' )
