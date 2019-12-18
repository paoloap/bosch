local screen =
{
   _NAME = "bosch.modules.container.screen"
}

screen.key = "index"

screen.defined = { }
for cname, _ in pairs(tricks.lua_in_dir(conf.dir.bosch .. "modules/container/screen/")) do
   screen.defined[cname] = require(screen._NAME .. ".".. cname)
end

return screen
