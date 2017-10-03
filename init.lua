#!/usr/bin/lua

setverbose()
info("Lua Init...")
async = require("eventhandler/async") -- module asynchrone
dofile("common.lua") -- petit layer d'adaptation/glue

row = 0
dofile("tileset/base.lua")
loadfile("tileset/standard.lua")("redruins"); loadfile("tileset/extra_redruins.lua")("redruins");
loadfile("tileset/standard.lua")("violetcastle")
loadfile("tileset/standard.lua")("volcano"); loadfile("tileset/extra_volcano.lua")("volcano");
loadfile("tileset/forest.lua")("forest")
loadfile("tileset/forest.lua")("forest_corrupted")
loadfile("tileset/forest.lua")("forest_underground")

dofile("register_character_actions.lua")
dofile("lobby/build_lobby.lua")
dofile("build/demon/build.lua")
dofile("build/forest/build.lua")

open(31337, "lobby", 16, 16)
info("Lua Init OK.")

