---------------------------------------------------------------------------
--- Bosch library: just some network, system, audio and taskbar functions
--
-- @author paoloap
-- @copyright 2016 Paolo Porcedda
-- @release 0.1
-- @module bosch
---------------------------------------------------------------------------

package.loaded.bosch = nil

local bosch =
{
  network = require("bosch.network"),
  system = require("bosch.system"),
  audio = require("bosch.audio"),
  taskbar = require("bosch.taskbar")
}

return bosch
