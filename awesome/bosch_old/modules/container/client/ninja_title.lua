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
local SIGNAL_DELAY = 0.05

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
      gears.timer.weak_start_new
      (
         SIGNAL_DELAY,
         function()
            if not c.bosch_table then
               naughty.notify({text = c.bosch_table.tiling.default })
               bosch.core.boschiman(c)
            end
            local mod_table = conf.modules.client.ninja_title
            awful.titlebar.hide(c, mod_table.position)
            c.first_tag = c.first_tag or mouse.screen.tags[1]
            local has_def_layout, has_def_prop = false, false
            for _, l_name in ipairs (mod_table.def_layouts) do
               has_def_layout = has_def_layout or c.first_tag.layout == layouts[l_name]
            end
            for _, p_name in ipairs (mod_table.def_props) do 
               has_def_prop = has_def_prop or c[p_name]
            end
            if
               ( has_def_layout or has_def_prop )
               and not ( c.bosch_table and c.bosch_table.no_titlebar )
            then
               awful.titlebar.show(c, mod_table.position)
            else
               awful.titlebar.hide(c, mod_table.position)
            end
         end
      )
   end
)
client.connect_signal
(
   "property::floating",
   function(c)
      gears.timer.weak_start_new
      (
         SIGNAL_DELAY,
         function()
            if c.floating then
               if not ( c.bosch_table and c.bosch_table.no_titlebar ) then
                  awful.titlebar.show(c, mod_table.position)
               else
                  awful.titlebar.hide(c, mod_table.position)
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
      gears.timer.weak_start_new
      (
         SIGNAL_DELAY,
         function()
            if t.selected then
               local show_it = false
               for _, l_name in ipairs (mod_table.def_layouts) do
                  show_it = show_it or t.layout == layouts[l_name]
               end
               if show_it then
                  for i, c in ipairs(t:clients()) do
                     if c.bosch_table.no_titlebar then
                        awful.titlebar.hide(c, mod_table.position)
                     else
                        awful.titlebar.show(c, mod_table.position)
                     end
                  end
               else
                  for i, c in pairs(t:clients()) do
                     awful.titlebar.hide(c, mod_table.position)
                     for _, p_name in ipairs (mod_table.def_props) do
                        if
                           c[p_name]
                           and not
                           (
                              c.bosch_table
                              and c.bosch_table.no_titlebar
                           )
                        then
                           awful.titlebar.show(c, mod_table.position)
                        else
                           awful.titlebar.hide(c, mod_table.position)
                        end
                     end
                  end
               end
            end
         end
      )
   end
)


return ninja_title
