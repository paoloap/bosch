---------------------------------------------------------------------------
--- BOSCH - various.lua
--- Misc widgets for Bosch top wibox
-- Released under GPL v3
-- NOTE: mail widget works only for maildir boxes
-- To Do: Comments
-- @author schuppenflektor
-- @copyright 2016 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.6
-- @module bosch.bwibox.various
---------------------------------------------------------------------------

local various = { _NAME = "bosch.bwibox.various" }

local wibox = require("wibox")
local awful = require ("awful")
local beautiful = require("beautiful")

function various.mail()
  local mailtimer = timer({ timeout = 30})
  local mailwidget = wibox.widget.textbox()
  local mailicon = wibox.widget.imagebox()
  mailtimer:connect_signal("timeout", function ()
    local fmail = assert(io.popen("find " .. config.mail .. " -type f | grep -vE ',[^,]*S[^,]*$' | wc -l"))
    local newmail = fmail:read("*l")
    if newmail == "0" then
      mailwidget:set_text("")
      mailicon:set_image(beautiful.widget_nomail)
    else
      mailwidget:set_text(" " .. newmail)
      mailicon:set_image(beautiful.widget_newmail)
    end
  end)
  mailtimer:start()
  return mailicon, mailwidget
end

return various
