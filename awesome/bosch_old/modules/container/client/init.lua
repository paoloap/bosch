local client =
{
   _NAME = "bosch.modules.container.client"
}

client.key = "window"

client.defined = { }
for cname, _ in pairs(tricks.lua_in_dir(conf.dir.bosch .. "modules/container/client/")) do
   client.defined[cname] = require(client._NAME .. ".".. cname)
end

return client
