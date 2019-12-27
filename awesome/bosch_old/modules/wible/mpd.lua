local mpd =
{
   _NAME = "bosch.modules.wible.mpd";
   new  = function()
      bosch.modules.wible("mpd")
   end
}

local wibox = { widget = wibox.widget }

setmetatable
(
   mpd,                              -- this is the table
   {                                   -- this is the metatable
      __call = function(cls, ...)
         return cls.new(...)
      end,
   }
)




beautiful.init(conf.dir.core .. "theme.lua")

mpd.conf              = 
{
   refresh_time         = 5,
   view                 = 
   {
      locale            = beautiful.audio_mpd_local,
      youtube           = beautiful.audio_mpd_youtube,
      soundcloud        = beautiful.audio_mpd_soundcloud,
      default_pic       = beautiful.widget_void,
      default_txt       = "",
      separator         = "/"
   },
}

-- requires pacmd command installed
mpd.command =
[[
echo -e "status\ncurrentsong\nclose" | curl telnet://127.0.0.1:6600 -fsm 1 | grep -e "^state: " -e "^file: " -e "^Name: " -e "^Title: " -e "^Artist: " -e "^AlbumArtist: "
]]



function mpd.create(mconf)
   local view = mconf.view
   return
   {
      wibox.widget.imagebox(view.default_pic),
      wibox.widget.textbox(view.default_txt)
   }
end

function mpd.exec(output, mconf, widgets)
-- Expected output variable:


   if output and output ~= "" then
      local z = mconf.view.separator
      local output_strings = tricks.rows(output)
      local state,file,name,artist,title,albumartist
      for i, line in ipairs(output_strings) do
         if string.match(line, "state: ") then
            state = tricks.split(line,"state: ")[2]
         elseif string.match(line, "file: ") then
            file = tricks.split(line, "file: ")[2]
         elseif string.match(line, "Name: ") then
            name = tricks.split(line, "Name: ")[2]
         elseif string.match(line, "AlbumArtist: ") then
            albumartist = tricks.split(line, "AlbumArtist: ")[2]
         elseif string.match(line, "Artist: ") then
            artist = tricks.split(line, "Artist: ")[2]
         elseif string.match(line, "Title: ") then
            title = tricks.split(line, "Title: ")[2]
         end
      end

      local song = " "
      if state == "stop" then
         song = ""
      else
         if string.match(file, "https://api.soundcloud.com/") then
            widgets[1]:set_image(mconf.view.soundcloud)
         elseif not string.match(file, "http") then
            widgets[1]:set_image(mconf.view.locale)
         end
         if name ~= nil then
            song = song .. name .. " "
         elseif (artist or albumartist) and title ~= nil then
            artist = (albumartist ~= "" and albumartist) or artist
            song = song .. artist .. z .. title .. " "
         end
      end
   widgets[2]:set_text(song)
   else
      widgets[1]:set_image(mconf.view.default_pic)
      widgets[2]:set_text(mconf.view.default_txt)
   end
end
   --naughty.notify({text = line})

return mpd
