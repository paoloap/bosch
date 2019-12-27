--- init.lua // Bosch main file
-- @author barrotes
-- @license GPL v3
-- @copyright 2016-2019 Paolo Porcedda - porcedda(at)gmail.com
-- @module bosch
-- @release 0.9.0

-- Clear environment
package.loaded.bosch = nil

-- Load standard AwesomeWM libraries that we call in Bosch functions
awful          = require("awful")
gears          = require("gears")
naughty        = require("naughty")
beautiful      = require("beautiful")

-- Lain is a non-standard library, but we need it for some nice layouts it has
lain           = require("lain")

-- bosch.tricks is a library where I collect some custom LUA functions that might be
-- useful to manipulate data (i.e. splitting strings) or debugging purposes (i.e. printing
-- tables content). Into Bosch functions I simply refer to it as "tricks", and that's why
-- I'm storing it in a global variable.
tricks         = require("bosch.tricks")

-- bosch.conf is the global user configuration table, where we store custom values that
-- a user might want to set, like color palette, font, panels and titlebars configuration,
-- keybindings, and all the tiling logic. The related lua file (bosch/conf.lua) is the
-- only file a user should edit to customize the aspect and the behaviour of Bosch
-- (unless he wants to add custom functionalities or fix bugs.Into Bosch functions I
-- simply refer to it as "conf", and that's why I'm storing it in a global variable.
conf           = require("bosch.conf")

local bosch = { }

-- bosch.modules are custom Bosch objects (dependent to AwesomeWM core objects and
-- libraries, like wibox, awful.titlebar, awful.wibar, naughty etc.). There are two
-- types of bosch.modules: container and wible.
-- A wible is a set of widgets that follow the same timer and can be bound with input
-- command through conf.commands table.
-- Containers are panels and bars that contain wibles and can be customized through
-- conf.modules table.
bosch.modules  = require("bosch.modules")

-- bosch.core is a collection of functions used by Bosch engine: say_cheese saves a
-- snapshot of clients and tags into a temporary file that can be reloaded later. In
-- default Bosch implementation is used by global.wm_restart action, and the temporary
-- tables are read into engine.unconscious.rebosch and engine.unconscious.tagging_logic.
-- bosch.core.boschiman is a function that generates a c.bosch_table property to all
-- clients, basing on conf.clients table. bosch.core.send_to sends a client to a tag,
-- basing on c.bosch_table values. core.pimp_client gives focus to a client, raises it,
-- and puts mouse cursor at the center of clients's area in screen. core.weak_focus gives
-- focus to the client under mouse pointer (but doesn't raise it).
bosch.core     = require("bosch.core")

-- bosch.actions are the actions that are related to conf.keybindings table, except the
-- ones that refer to an element in conf.commands. Should be merged in
-- bosch.engine.conscious.
bosch.actions  =
{
   global      = require("bosch.actions.global"),
   client      = require("bosch.actions.client")
}

-- bosch.engine is the library 
bosch.engine   = 
{
   unconscious = require("bosch.engine.unconscious"),
   bad_news    = require("bosch.engine.bad_news"),
   conscious   = require("bosch.engine.conscious")
}

function bosch.init()
   -- Handle error notifications
   bosch.engine.bad_news()
   
   -- Handle screens, tags, layouts, clients, modules
   -- and in generaly any "automatic" behaviour
   bosch.engine.unconscious()
   
   -- Handle input management
   bosch.engine.conscious()
end


return bosch
