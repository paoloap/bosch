---------------------------------------------------------------------------
--- BOSCH - bosch init.lua
--- Bosch modules initialization
-- Released under GPL v3
-- To do: rules and signals modules
-- @author schuppenflektor
-- @copyright 2016 Paolo Porcedda - porcedda(at)gmail.com
-- @module bosch
-- @release 0.6
---------------------------------------------------------------------------

package.loaded.bosch = nil

local bosch =
{
  bwibox = require("bosch.bwibox"),
  switcher = require("bosch.switcher"),
  tiling = require("bosch.tiling"),
  config = require("bosch.config"),
  keys = require("bosch.keys")
}

return bosch
