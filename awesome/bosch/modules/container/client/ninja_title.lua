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

   return self
end
--if
client.connect_signal
(
   "manage",
   function (c) --, startup)
      if not c.bosch_table then
         core.boschiman(c)
      end
      
      c.first_tag = c.first_tag or mouse.screen.tags[1]
      local show_it = false
      for _, l_name in ipairs (mod_table.excluded_layouts) do
         show_it = show_it or c.first_tag.layout == l_name
      end
      for _, p_name in ipairs (mod_table.excluded_props) do
         show_it = show_it or c[p_name]
      end
      show_it = show_it and not c.bosch_table.no_titlebar
      if show_it then
         awful.titlebar.show(c, mod_table.position)
      else
         awful.titlebar.hide(c, mod_table.position)
      end
      client.connect_signal
      (
         "property::floating",
         function(c)
            if c.floating then
               if not ( conf_table and conf_table.no_titlebar ) then
                  awful.titlebar.show(c, mod_table.position)
               end
            else
               awful.titlebar.hide(c, mod_table.position)
            end
         end
      )

   end
)

tag.connect_signal
(
   "property::selected",
   function(t)
      if t.selected then
         local show_it = false
         for _, l_name in ipairs (mod_table.excluded_layouts) do
            show_it = show_it or t.layout == l_name
         end
         if show_it then
            for i, c in ipairs(t:clients()) do
               awful.titlebar.show(c, mod_table.position)
            end
         else
            for i, c in pairs(t:clients()) do
               for _, p_name in ipairs (mod_table.excluded_props) do
                  if not c[p_name] then
                     ifawful.titlebar.hide(c, mod_table.position)
                  end
               end
            end
         end
      end
   end
)


return ninja_title
