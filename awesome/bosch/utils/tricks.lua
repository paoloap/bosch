---------------------------------------------------------------------------
--- BOSCH - tricks.lua
--- Some lua tricks to manipulate data structures
-- Released under GPL v3
-- NOTE: depends on pulseaudio package (pacmd command)
-- @author schuppenflektor
-- @copyright 2016-2018 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.8
-- @module bosch.utils.tricks
---------------------------------------------------------------------------

local tricks = { _NAME = "bosch.utils.tricks" }
local naughty = require("naughty")

--- split takes a string and a delimiter, and returns an array with the string splitted
--- basing on delimiter, and the array size (an integer)
-- @param s the string we want to split
-- @param delimiter the string or char we want as split delimiter
-- @return result a string array which we get from splitting
-- @return i the number of strings contained in 'result'
function tricks.split(s, delimiter)
   local result = {}
   local i = 0
   for match in (s..delimiter):gmatch("(.-)"..delimiter) do
      table.insert(result, match)
	   i = i + 1
   end
   if result[i] == "" or result[i] == nil then
       table.remove(result)
   end
   return result, i - 1;
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
  return "{" .. table.concat( result, "," ) .. "}"
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
    return k
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

return tricks
