#!/usr/bin/lua

-- - - - - - - - - --
-- Build big door. --
-- - - - - - - - - --

-- Get arguments.
local tileset, screen, x, y = ...

-- Build door around X and Y.
screen_settile(screen, x-1, y-1, tileset..":bigdoor_toplft")
screen_settile(screen, x,   y-1, tileset..":bigdoor_top")
screen_settile(screen, x+1, y-1, tileset..":bigdoor_toprgt")
screen_settile(screen, x-1, y,   tileset..":bigdoor_lft")
screen_settile(screen, x,   y,   tileset..":bigdoor")
screen_settile(screen, x+1, y,   tileset..":bigdoor_rgt")

-- Give open/close tags.
screen_settag(screen, x, y, "openclose_state", "open")
screen_settag(screen, x, y, "openclose_opentile", tileset..":bigdoor")
screen_settag(screen, x, y, "openclose_closetile", tileset..":bigdoor_closed")
