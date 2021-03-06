#!/usr/bin/lua

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --
-- Builds a 7x7 ziggurat at designated point.  Return coordinates of entrance. --
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --

local tileset, zone, x_shift, y_shift = ...

--
--
place_setaspect(zone, x_shift+2, y_shift+0, tileset..":roof_toplft")
place_setaspect(zone, x_shift+3, y_shift+0, tileset..":roof_top")
place_setaspect(zone, x_shift+4, y_shift+0, tileset..":roof_toprgt")
--
--

--
place_setaspect(zone, x_shift+1, y_shift+1, tileset..":roof_toplft")
place_setaspect(zone, x_shift+2, y_shift+1, tileset..":roof_botlft")
place_setaspect(zone, x_shift+3, y_shift+1, tileset..":roof_bot")
place_setaspect(zone, x_shift+4, y_shift+1, tileset..":roof_botrgt")
place_setaspect(zone, x_shift+5, y_shift+1, tileset..":roof_toprgt")
--

place_setaspect(zone, x_shift+0, y_shift+2, tileset..":roof_toplft")
place_setaspect(zone, x_shift+1, y_shift+2, tileset..":roof_lft")
place_setaspect(zone, x_shift+2, y_shift+2, tileset..":wall_botlft")
place_setaspect(zone, x_shift+3, y_shift+2, tileset..":wall_bot")
place_setaspect(zone, x_shift+4, y_shift+2, tileset..":wall_botrgt")
place_setaspect(zone, x_shift+5, y_shift+2, tileset..":roof_rgt")
place_setaspect(zone, x_shift+6, y_shift+2, tileset..":roof_toprgt")

place_setaspect(zone, x_shift+0, y_shift+3, tileset..":roof_lft")
place_setaspect(zone, x_shift+1, y_shift+3, tileset..":roof_botlft")
place_setaspect(zone, x_shift+2, y_shift+3, tileset..":roof_bot")
place_setaspect(zone, x_shift+3, y_shift+3, tileset..":roof_bot")
place_setaspect(zone, x_shift+4, y_shift+3, tileset..":roof_bot")
place_setaspect(zone, x_shift+5, y_shift+3, tileset..":roof_botrgt")
place_setaspect(zone, x_shift+6, y_shift+3, tileset..":roof_rgt")

place_setaspect(zone, x_shift+0, y_shift+4, tileset..":roof_lft")
place_setaspect(zone, x_shift+1, y_shift+4, tileset..":wall_lft")
place_setaspect(zone, x_shift+2, y_shift+4, tileset..":bigdoor_toplft")
place_setaspect(zone, x_shift+3, y_shift+4, tileset..":bigdoor_top")
place_setaspect(zone, x_shift+4, y_shift+4, tileset..":bigdoor_toprgt")
place_setaspect(zone, x_shift+5, y_shift+4, tileset..":wall_rgt")
place_setaspect(zone, x_shift+6, y_shift+4, tileset..":roof_rgt")

place_setaspect(zone, x_shift+0, y_shift+5, tileset..":roof_botlft")
place_setaspect(zone, x_shift+1, y_shift+5, tileset..":roof_botrgt")
place_setaspect(zone, x_shift+2, y_shift+5, tileset..":bigdoor_lft")
place_setaspect(zone, x_shift+3, y_shift+5, tileset..":bigdoor")
place_setaspect(zone, x_shift+4, y_shift+5, tileset..":bigdoor_rgt")
place_setaspect(zone, x_shift+5, y_shift+5, tileset..":roof_botlft")
place_setaspect(zone, x_shift+6, y_shift+5, tileset..":roof_botrgt")

place_setaspect(zone, x_shift+0, y_shift+6, tileset..":wall_botlft")
place_setaspect(zone, x_shift+1, y_shift+6, tileset..":wall_botrgt")
--
--
--
place_setaspect(zone, x_shift+5, y_shift+6, tileset..":wall_botlft")
place_setaspect(zone, x_shift+6, y_shift+6, tileset..":wall_botrgt")

return x_shift+3, y_shift+5
