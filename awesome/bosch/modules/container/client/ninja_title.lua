local ninja_title =
{
   _NAME = "bosch.modules.container.client.ninja_title",
   init   = function(custom_conf)
      bosch.modules.container.client("ninja_title", custom_conf)
   end
}


setmetatable
(
   ninja_title,
   {
      __call = function(cls, ...)
         return cls.init(...)
      end,
   }
)


local mod_table = conf.modules.client and conf.modules.client.ninja_title

ninja_title.conf =
{
   signal_delay   = 0.10,
   props          = { "floating", "!fullscreen", "!maximized" },
   flags          = { "!ghost" }, -- necessario e non sufficiente
   layouts        = { "float", "switcher" } -- sufficiente se rispetta i flag
}

function ninja_title.show(c)
   awful.titlebar.show(c, mod_table.position)
end
function ninja_title.hide(c)
   awful.titlebar.hide(c, mod_table.position)
end

function ninja_title.create(conf_table)
   local self = setmetatable({}, ninja_title)
   local c = conf_table.apply_to
   self.element = awful.titlebar
   (
      c,
      {
         position = conf_table.position,
         height   = conf_table.size,
         fg       = conf.makeup.colorbg,
         bg       = conf.makeup.color07,
         fg_focus = conf.makeup.colorbg,
         bg_focus = conf.makeup.color09
      }
   )
   local buttons = gears.table.join
   (
      awful.button
      (
         { },
         1,
         function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
         end
      ),
      awful.button
      (
         { },
         3,
         function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
         end
      )
   )
   self.element:setup
   {
      { -- Left
          awful.titlebar.widget.iconwidget(c),
          buttons = buttons,
          layout  = wibox.layout.fixed.horizontal
      },
      { -- Middle
          { -- Title
              align  = 'center',
              widget = awful.titlebar.widget.titlewidget(c)
          },
          buttons = buttons,
          layout  = wibox.layout.flex.horizontal
      },
      { -- Right
          awful.titlebar.widget.floatingbutton     (c),
          awful.titlebar.widget.maximizedbutton    (c),
          awful.titlebar.widget.stickybutton       (c),
          awful.titlebar.widget.ontopbutton        (c),
          awful.titlebar.widget.closebutton        (c),
          layout = wibox.layout.fixed.horizontal   ( )
      },
      layout = wibox.layout.align.horizontal
   }
   --naughty.notify({text = "ok" })

   return self
end

return ninja_title
