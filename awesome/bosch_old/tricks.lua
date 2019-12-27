---------------------------------------------------------------------------
--- BOSCH - tricks.lua
--- Some lua tricks to manipulate data structures
-- Released under GPL v3
-- @author barrotes
-- @copyright 2016-2019 Paolo Porcedda - porcedda(at)gmail.com
-- @module bosch
-- @release 0.9.0
---------------------------------------------------------------------------

local tricks = { _NAME = "bosch.tricks" }

--- split takes a string and a delimiter, and returns an array with the string splitted
--- basing on delimiter, and the array size (an integer)
-- @param s the string we want to split
-- @param delimiter the string or char we want as split delimiter
-- @return result a string array which we get from splitting
-- @return i the number of strings contained in 'result'
function tricks.split(s, delimiter)
   local result = {}
   local i = 0
   if s then
      for match in (s..delimiter):gmatch("(.-)"..delimiter) do
         table.insert(result, match)
   	   i = i + 1
      end
      if result[i] == "" or result[i] == nil then
          table.remove(result)
          i = i - 1
      end
      return result, i;
   end
end

--- readonlytable takes a table and returns the same table but with immutable fields
-- @param table the table we want to make read-only
-- @return the read-only version of table
function tricks.readonlytable(table)
   return setmetatable({}, {
      __index = table,
      __newindex = function(table, key, value)
        error("Attempt to modify read-only table")
      end,
      __metatable = false
   });
end

--- unpack takes a table and returns all its elements separately
-- @param t the table we want to unpack
-- @param i optional start index
-- @return table elements
function unpack (t, i)
   i = i or 1
   if t[i] ~= nil then
      return t[i], unpack(t, i + 1)
   end
end

function tricks.unpack (t, i)
   i = i or 1
   if t[i] ~= nil then
      return t[i], unpack(t, i + 1)
   end
end

function tricks.table_tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, tricks.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        tricks.key_to_str( k ) .. "=" .. tricks.val_to_str( v ) )
    end
  end
  return "{\n" .. table.concat( result, ",\n" ) .. "\n}"
end

function tricks.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and tricks.table_tostring( v ) or
      tostring( v )
  end
end

function tricks.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return "   " .. k
  else
    return "[" .. tricks.val_to_str( k ) .. "]"
  end
end

function tricks.table_keys( tbl )
   local keyset = {}
   local n = 0
   for k,v in pairs(tbl) do
      n = n + 1
      keyset[n] = k
   end
   if n == 0 then
      return nil
   else
      naughty.notify({text = tricks.table_tostring(keyset)})
      return keyset
   end
end

function tricks.table_size( tbl )
  local count = 0
  for _ in pairs(tbl) do
	  count = count + 1
  end
  return count
end

function tricks.rows(s)
   local rows = tricks.split(s, "\n")
   return rows, tricks.table_size(rows)
end

function tricks.lua_in_dir(dir_path)
   local lua_list = { }
   local pfile = assert(io.popen('ls ' .. dir_path ))
   local tt = pfile:lines()
   for filename in tt do
      splitted_name = tricks.split(filename, "%.")
      if tricks.table_size(splitted_name) == 2 and splitted_name[2] == "lua%" then
   --naughty.notify({text = splitted_name[2] .. "   " .. tricks.table_size(splitted_name)})
         local name_without_ext = splitted_name[1]
         if name_without_ext ~= "init" then
            lua_list[name_without_ext] = true
         end
      end
   end
   pfile:close()
   return lua_list
end

function tricks.start_from(s, delimiter)
   local array, n = tricks.split(s, delimiter)
   local result = ""
   if n == 1 then
      result = ""
   elseif n == 2 then
      result = array[2]
   else
      for i = 2, n, 1 do
         result = result .. array[i]
      end
   end
   return result
end

function tricks.table_to_file(t, path, name)
   --local file = conf.dir.cache .. "tiling_status.lua"
   local file = path .. name .. ".lua"
   tiling_status_file = io.open (file, "a")
   tiling_status_file:write("return " .. tricks.table_tostring(t),"\n")
   tiling_status_file:close()
end

function tricks.table_from_file(path, name)
   local full_name = path .. name .. ".lua"
   local t
   if io.open(full_name, "a") then
      t = dofile(full_name)
   end
   os.execute ("rm " .. full_name)
   return t
end


return tricks
