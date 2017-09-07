#!/usr/bin/lua

local origin, x, y = ...

zone_event(origin, "Une odeur de poussière et de rouille s'échappe du portail.")

local zone = "kalzakrax_"..c_rand(999999) -- TODO: request UUID.
local name = "Kalzakrax"
local tileset = "redruins"
local w = 40
local h = 40

new_zone(zone, name, w, h, tileset..":soil_1")

-- Randomize soil.
for x=0,w-1 do
	for y=0,h-1 do
		place_setaspect(zone, x, y, tileset..":soil_"..c_rand(4))
	end
end

place_setaspect(zone, 20, 39, tileset..":mosaic_a")
loadfile("build/tools/link.lua")(origin, x, y, zone, 20, 39)

loadfile("logic/generate/kalzakrax_graveyard.lua")(zone, 3, 5, 33, 30)

return zone
