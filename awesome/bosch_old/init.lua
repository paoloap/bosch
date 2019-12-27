---------------------------------------------------------------------------
--- BOSCH - init.lua
--- Bosch main file
-- Released under GPL v3
-- @author barrotes
-- @copyright 2016-2019 Paolo Porcedda - porcedda(at)gmail.com
-- @module bosch
-- @release 0.9.0
---------------------------------------------------------------------------

package.loaded.bosch = nil

bosch          = { _NAME = "bosch" }

awful          = require("awful")
gears          = require("gears")
naughty        = require("naughty")
beautiful      = require("beautiful")
lain           = require("lain")
tricks         = require("bosch.tricks")
conf           = require("bosch.conf")


bosch.modules  = require("bosch.modules")
bosch.core     = require("bosch.core")
bosch.actions  =
{
   global      = require("bosch.actions.global"),
   client      = require("bosch.actions.client")
}
bosch.engine   = 
{
   unconscious = require("bosch.engine.unconscious"),
   bad_news    = require("bosch.engine.bad_news"),
   conscious   = require("bosch.engine.conscious")
}


-- Handle error notifications
bosch.engine.bad_news()

-- Handle screens, tags, layouts, clients, modules
-- and in generaly any "automatic" behaviour
bosch.engine.unconscious()

-- Handle input management
bosch.engine.conscious()


return bosch
