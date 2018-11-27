---------------------------------------------------------------------------
--- BOSCH - various.lua
--- Misc widgets for Bosch top wibox
-- Released under GPL v3
-- NOTE: mail widget works only for maildir boxes
-- To Do: Comments
-- @author schuppenflektor
-- @copyright 2016-2018 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.7
-- @module bosch.bwibox.various
---------------------------------------------------------------------------

local various = { _NAME = "bosch.bwibox.various" }

local wibox = require("wibox")
local awful = require ("awful")
local beautiful = require("beautiful")

--- various.mail returns the number of incoming mails, and a mail status icon
-- @return first mail icon
-- @return second unread mails widget
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

--- various.capslock returns an icon if caps lock is activated. If not, it returns an empty icon
-- @return caps lock icon, or an empty icon
function various.capslock()
  local capstimer = timer({ timeout = 1 })
  local capsicon = wibox.widget.imagebox()
  capstimer:connect_signal("timeout", function ()
    local fcaps = assert(io.popen("cat /sys/class/leds/input4::capslock/brightness"))
    local capstatus = fcaps:read("*l")
    if capstatus == "1" then
      capsicon:set_image(beautiful.widget_capslock_on)
    else
      capsicon:set_image(beautiful.widget_void)
    end
  end)
  capstimer:start()
  return capsicon
end

return various
