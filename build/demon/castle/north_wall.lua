#!/usr/bin/lua

local tileset, zone = ...

info("[WORLDGEN] [Demon Castle] North Wall")

local build_wall = function(x, y, h)
	for i=0,5 do
		place_setaspect(zone, x+i, y,   tileset..":roof_top")
		place_setaspect(zone, x+i, y+1, tileset..":roof")
		place_setaspect(zone, x+i, y+2, tileset..":roof_bot")
		for j=3,h-2 do
			place_setaspect(zone, x+i, y+j, tileset..":wall")
		end
		place_setaspect(zone, x+i, y+h-1, tileset..":wall_bot")
	end
end

build_wall(6, 6, 5)
build_wall(17, 4, 7)
build_wall(28, 4, 7)
build_wall(39, 6, 5)
loadfile("build/tools/tower.lua")(tileset, zone, 1,  3, "northwest", "south,east")
loadfile("build/tools/tower.lua")(tileset, zone, 12, 3, "left", "west,ground")
loadfile("build/demon/castle/tower_tall.lua")(tileset, zone, 23, 1)
loadfile("build/tools/tower.lua")(tileset, zone, 34, 3, "right", "east,ground")
loadfile("build/tools/tower.lua")(tileset, zone, 45,  3, "northeast", "south,west")

-- Passage from roof to high walls.
place_setaspect(zone, 16, 5, tileset..":roof")
place_setaspect(zone, 34, 5, tileset..":roof")

place_setaspect("tall_tower_2", 0, 3, tileset..":pillar_bot")
place_setaspect("tall_tower_2", 0, 4, tileset..":mosaic_a")
place_setaspect(zone, 22, 5, tileset..":mosaic_a")
loadfile("build/tools/link.lua")("tall_tower_2", 0, 4, zone, 22, 5)

place_setaspect("tall_tower_2", 8, 3, tileset..":pillar_bot")
place_setaspect("tall_tower_2", 8, 4, tileset..":mosaic_a")
place_setaspect(zone, 28, 5, tileset..":mosaic_a")
loadfile("build/tools/link.lua")("tall_tower_2", 8, 4, zone, 28, 5)

-- Add puzzle to light up the crystal.
local master_zone = "tall_tower_2"
local master_x = 4
local master_y = 2
place_setaspect(master_zone, master_x, master_y, tileset..":crystal_2")
local script = "place_setaspect(\""..master_zone.."\", "..master_x..", "..master_y..", \""..tileset..":crystal_6\")"
place_settag(master_zone, master_x, master_y, "puzzle_script", script)
local master = master_zone.."/"..master_x.."-"..master_y

local place_piece = function(n, zone, x, y)
	place_setaspect(zone, x, y, tileset..":mosaic_black")
	place_settag(zone, x, y, "puzzle_init", "black")
	place_settag(zone, x, y, "puzzle_model", "white")
	place_settag(zone, x, y, "puzzle_master", master)
	place_setlandon(zone, x, y, "dofile(\"logic/puzzle_mosaic_walk.lua\")")
	place_settag(master_zone, master_x, master_y, "puzzle_piece_"..n, zone.."/"..x.."-"..y)
end

place_piece(1, "tall_tower_0", 4, 4)
place_piece(2, "northwest_floor_1", 2, 6)
place_piece(3, "northeast_floor_1", 6, 6)

-- Add hint around the crystal.
place_setaspect(master_zone, master_x-2, master_y+1, tileset..":mosaic_white")
place_setaspect(master_zone, master_x,   master_y+2, tileset..":mosaic_white")
place_setaspect(master_zone, master_x+2, master_y+1, tileset..":mosaic_white")
place_setaspect(master_zone, master_x-1, master_y+2, tileset..":mosaic_c")

-- Seal off left tower's door.
place_setaspect(zone, 14, 11, tileset..":block_1")
place_setaspect("left_floor_0", 4, 9, tileset..":block_1")
place_setaspect("left_floor_0", 4, 9-1, tileset..":bigdoor_top")

-- Add mark in left tower.
place_setaspect("left_floor_0", 4, 4, tileset..":mosaic_c")
