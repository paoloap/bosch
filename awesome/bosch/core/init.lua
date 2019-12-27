---------------------------------------------------------------------------
--- BOSCH - core/init.lua
--- Bosch core functions
-- Released under GPL v3
-- @author barrotes
-- @copyright 2016-2019 Paolo Porcedda - porcedda(at)gmail.com
-- @module bosch
-- @release 0.9.0
---------------------------------------------------------------------------


local core = { _NAME = "bosch.core" }

-- Global layouts table: every layout that we can use is declared here
layouts  =
{
   float       = awful.layout.suit.floating,
   tile        = awful.layout.suit.tile,
   termfair    = lain.layout.termfair.center,
   centerwork  = lain.layout.centerwork,
   spiral      = awful.layout.suit.spiral.dwindle,
   max         = awful.layout.suit.max,
   switcher    = lain.layout.termfair,
}


-- Tag properties list: used to store and recall the actual exact
-- configuration for every tag (so that we can find the same situation
-- when we restart AwesomeWM)
core.prop_list =
{
   "selected",
   "activated",
   "index",
   "master_width_factor",
   "volatile",
   "gap",
   "gap_single_client",
   "master_fill_policy",
   "master_count",
   "column_count",
}

-- Save tags and clients status in two temporary files that will be
-- used after AwesomeWM restart to put everything in its place.
function core.say_cheese()
   local tiling_status_table = { }

   for s in screen do
      tiling_status_table[s.index] = { }
      for i, t in ipairs(s.tags) do
         if t.selected then
            tiling_status_table[s.index].selected_tag = i
         end
         local actual_layout_index = 1
         for i, l in ipairs(conf.tiling.tags[t.name].layout_set) do
            if layouts[l] == t.layout then
               actual_layout_index = i
            end
         end
         tiling_status_table[s.index][i] = { }
         for j, prop in ipairs(core.prop_list) do
            tiling_status_table[s.index][i][prop] = t[prop]
         end
         tiling_status_table[s.index][i].layout = actual_layout_index
      end
   end
   tricks.table_to_file(tiling_status_table, conf.dir.cache, "tiling_status")
   local file = conf.dir.cache .. "clients_status.lua"
   os.execute("rm " .. file)
   clients_list_file = io.open (file, "a")
   clients_list_file:write('return ',"\n")
   clients_list_file:write('{',"\n")
   for s in screen do
      local clients_list = s.all_clients
      if clients_list then
         for i, c in ipairs(clients_list) do
            local window = c.window
            --local tag = c.first_tag
            clients_list_file:write("   [" .. c.window .. "] = true;", "\n")
         end
      end
   end
   clients_list_file:write('}',"\n")
end

-- Send a client c to the right tag, basing on Bosch logic
function core.send_to(c, args)
   local args = args or { }
   local client_table = c.bosch_table or { }
   local background = client_table.background or args.background
   local tiling_table = client_table.tiling
   local choosen_screen = screen.primary
   if
      not args.ignore_screen
      and tiling_table
      and tiling_table.screen
      and conf.tiling.displays[tiling_table.screen]
   then
      for s in screen do
         if s.outputs[tiling_table.screen] then
            choosen_screen = s
         end
      end
   end
   local choosen_tag
   if tiling_table then
      for i, t in ipairs(choosen_screen.tags) do
         if t.name == tiling_table.default then
            choosen_tag = t
         end
      end
   end
   if args.force_default then
      if not choosen_tag then
         choosen_tag = mouse.screen.selected_tag
      end
   else
      local candidate_tag = choosen_screen.selected_tag or mouse.screen.tags[1]
      local forbidden
      if tiling_table then
         for i, tag in ipairs(tiling_table.forbidden) do
            if candidate_tag.name == tag then
               forbidden = true
            end
         end
      end
      if not forbidden then
         choosen_tag = candidate_tag
      end
   end
   c:move_to_tag(choosen_tag)
   return choosen
end

-- Popolate client c "bosch_table" field
function core.boschiman(c)
   local same_class = { }
   for name, ctable in pairs(conf.clients) do
      local class = ctable.rule.class or ""
      local client_class = (c and c.class) or ""
      if client_class == class or client_class:find(class) then
         local name = ctable.rule.name
         local role = ctable.rule.role
         if not name and not role then
            same_class = ctable
         elseif
         (
            name
            and c.name
            and
            (
               c.name == name
               or c.name:find(name)
            )
         ) or
         (
            role
            and c.role
            and
            (
               c.role == role
               or c.role:find(role)
            )
         ) then
            c.bosch_table = ctable
	    c.bosch_table.object = "client"
            return ctable
         end
      end
   end
   c.bosch_table = same_class
   c.bosch_table.object = "client"
   return same_class
end

-- Give focus to client c, select its tag if not selected, and place
-- the mouse pointer on its center
function core.pimp_client(c)
   if awful.client.focus.filter(c) then
      local t = c.first_tag or mouse.screen.selected_tag
      if t and not t.selected then
          t:view_only()
      end

      client.focus = c
      c:raise()
      gears.timer.weak_start_new
      (
         0.05,
         function()

            if not ( c.bosch_table and c.bosch_table.unpimpable ) then
               local point =
               {
                  x = c.x + ( c.width / 2 ),
                  y = c.y + ( c.height / 2 )
               }
               mouse.coords( point )
            end
         end
      )
   end
end

-- Give focus to the client under mouse pointer in
-- tag t. If the mouse pointer isn't over any client
-- give focus to first client in clients order
function core.weak_focus(t)
   gears.timer.weak_start_new
   (
      0.08,
      function()
         if t and t.selected then
            --naughty.notify({ text =  "no."})
            local s = t.screen or mouse.screen
            local clients = t:clients()
            local c =
               (
                  mouse.object_under_pointer()
                  or
                     (
                        clients
                        and clients[1]
                     )
               )
               or s.clients[1]
            client.focus = c
         end
      end
   )
end


return core
