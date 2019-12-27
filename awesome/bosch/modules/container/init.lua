
local container =
{
   _NAME = "bosch.modules.container",
}

wibox = require("wibox")

local modules_dir = conf.dir.bosch .. "modules/container/"
local def_objects =
{
   screen = "index",
   client = "window"
}

container.defined = { }
setmetatable
(
   container,
   {
      __call = function(cls, ...)
         return cls.new(...)
      end,
   }
)

local function explode_property(prop)
   local explode_prop = tricks.split(prop, "!")
   local negate = explode_prop[1] == ""
   return 
      explode_prop[2] or (not negate and explode_prop[1]) or prop,
      negate
end
local function toggle_container(c, t, name, signal_delay)
   gears.timer.weak_start_new
   (
      signal_delay,
      function()
         local cont = c.bosch_table and c.bosch_table.containers[name]
            if cont then
            local show = true
            for _, cflag in ipairs(cont.conf.flags) do
               if show then
                  local flag, negate = explode_property(cflag)
                  if 
                  (
                     not negate 
                     and not (c.bosch_table and c.bosch_table[flag] )
                  ) or
                  (
                     negate
                     and c.bosch_table
                     and c.bosch_table[flag]
                  ) then
                     show = false
                  end
               end
            end
            if show then
               for _, cprop in ipairs(cont.conf.props) do
                  if show then
                     local prop, negate = explode_property(cprop)
                     if
                     (
                        not negate
                        and not c[prop]
                     ) or
                     (
                        negate
                        and c[prop]
                     ) then
                        show = false
                     end
                  end
               end
               if not show and t and t.layout then
                  for _, clayout in ipairs(cont.conf.layouts) do
                     if not show then
                        local layout, negate = explode_property(clayout)
                        if
                        (
                           negate
                           and layouts[layout] ~= t.layout
                        ) or
                        (
                           not negate
                           and layouts[layout] == t.layout
                        ) then
                           show = true
                        end
                     end
                  end
               end
            end
            if show then
            --naughty.notify({text = "show" })
               container.show(cont, c)
            else
            --naughty.notify({text = "hide" })
               container.hide(cont, c)
            end
         end
      end
   )
end
      
      


for obj, id_key in pairs(def_objects) do
   local def_table = tricks.lua_in_dir(modules_dir .. obj .. "/")
   container[obj] =
   {
      _NAME    = "bosch.modules.container." .. obj,
      defined  = { }
   }
   
   if obj == "screen" then function container.screen.generate_signals(name) end
   elseif obj == "client" then
      function container.client.generate_signals(name)
      
         local cconf = container.client.defined[name].conf
      
         for _, cprop in ipairs(cconf.props) do
            local prop, negate = explode_property(cprop)
            client.connect_signal
            (
               "property::" .. prop,
               function(c)
                  if
                  (
                     (negate and c[prop])
                     or (not negate and not c[prop])
                  ) and c.bosch_table then
                     container.hide(c.bosch_table.containers[name], c)
                  else
                     toggle_container(c, c.first_tag, name, cconf.signal_delay)
                  end
               end
            )
         end
         client.connect_signal
         (
            "manage",
            function(c)
               toggle_container(c, c.first_tag, name, cconf.signal_delay)
            end
         )
         tag.connect_signal
         (
            "property::selected",
            function(t)
	       --naughty.notify({text = t.name })
               if t.selected then
                  for _, c in ipairs(t:clients()) do
                     toggle_container(c, t, name, cconf.signal_delay)
                  end
               end
            end
         )
      end
   end
   for name, def in pairs(def_table) do
      container[obj].defined[name] = require(container._NAME .. "." .. obj .. ".".. name)
      container[obj].generate_signals(name)
   end
end

container.new = function(name, conf_table)
   self = setmetatable({}, container)
   self.name = name
   self.conf = conf_table

   for obj, id_key in pairs(def_objects) do
      local instance = container[obj].defined[name]
      if instance then
         local cont = instance.create(conf_table)
         self.element = cont.element
         self.children = cont.children
         self.conf = instance.conf
         local target = conf_table.apply_to

         if target then
            target.bosch_table = target.bosch_table or { }
            target.bosch_table.containers = target.bosch_table.containers or { }
            target.bosch_table.containers[name] = self
            --toggle_container(target, target.first_tag, name, self.conf.signal_delay)
         end
         --container.hide(self, target)
         return self
      end
   end
end

function container:show(o)
   for obj, key in pairs(def_objects) do
      local def = container[obj].defined[self.name]
      if def then
         def.show(o)
         return true
      end
   end
   return false
end

function container:hide(o)
   for obj, key in pairs(def_objects) do
      local def = container[obj].defined[self.name]
      if def then
         def.hide(o)
         return true
      end
   end
   return false
end

function container:toggle(o)
   for obj, key in pairs(def_objects) do
      local def = container[obj].defined[self.name]
      if def then
         def.toggle(o)
         return true
      end
   end
   return false
end

function container:refresh(signal_name)
   for i, w in ipairs(self.children) do
      -- if not signal_name refresh all wibles in container except not refreshables
      if
         not w.conf.not_refreshable
         and ( ( w.conf.signal and w.conf.signal == signal_name ) or not signal_name )
      then
         w:refresh()
      end
   end
end

return container
