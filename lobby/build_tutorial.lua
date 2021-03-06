#!/usr/bin/lua

local lobby_zone, lobby_x, lobby_y = ...

info("[WORLDGEN] Tutorial")

local zone = "tutorial"
local tileset = "violetcastle"
local w = 11
local h = 37
local x_mid = math.floor(w/2)

new_zone(zone, "Tutorial", w, h, tileset..":path")

local build_horizontal_wall = function(y)
	for x=0,w-1 do
		place_setaspect(zone, x, y-1, tileset..":roof_horizontal")
		place_setaspect(zone, x, y,   tileset..":wall_bot")
	end
	place_setaspect(zone, x_mid-1, y-1, tileset..":roof_endrgt")
	place_setaspect(zone, x_mid,   y-1, tileset..":path")
	place_setaspect(zone, x_mid+1, y-1, tileset..":roof_horizontal")
	place_setaspect(zone, x_mid-1, y,   tileset..":wall_botrgt")
	place_setaspect(zone, x_mid,   y,   tileset..":path")
	place_setaspect(zone, x_mid+1, y,   tileset..":wall_botlft")
end

local y = h-2

local entrance_x = x_mid
local entrance_y = y
place_setaspect(zone, entrance_x, entrance_y, tileset..":mosaic_a") -- spawn point

y = y-3

build_horizontal_wall(y)
place_setlandon(zone, x_mid, y, "\
character_message(Character, \"* * *\")\
character_message(Character, \"Pour interagir avec certains éléments, il suffit de marcher dessus.\")\
character_message(Character, \"Essaye de marcher sur ces dalles, puis va jusqu'à la salle suivante.\")\
")

y = y-3

place_setaspect  (zone, 2,   y, tileset..":mosaic_white")
place_setlandon(zone, 2,   y, "dofile(\"logic/puzzle_mosaic_walk.lua\")")
place_setaspect  (zone, w-3, y, tileset..":mosaic_black")
place_setlandon(zone, w-3, y, "dofile(\"logic/puzzle_mosaic_walk.lua\")")

y = y-3

place_setaspect  (zone, 2,   y, tileset..":mosaic_b")
place_setlandon(zone, 2,   y, "character_setxy(Character, "..w-3 ..", "..y..")")
place_setaspect  (zone, w-3, y, tileset..":mosaic_b")
place_setlandon(zone, w-3, y, "character_setxy(Character, 2, "..y..")")

y = y-2

build_horizontal_wall(y)
place_setlandon(zone, x_mid, y, "\
character_message(Character, \"* * *\")\
character_message(Character, \"Pour interagir avec un objet, mets-toi devant et entre une commande.\")\
character_message(Character, \"Les commandes commencent par \'/\'. Essaye de /lire ce livre.\")\
character_message(Character, \"Tiens-toi devant ce livre, entre '/lire' et valide avec la touche Entrée.\")\
")

y = y-4

place_setaspect(zone, x_mid, y, tileset..":book_a_open")
place_settag(zone, x_mid, y, "text", "Bien joué! Va dans la salle suivante.")

y = y-3

build_horizontal_wall(y)
place_setlandon(zone, x_mid, y, "\
character_message(Character, \"* * *\")\
character_message(Character, \"Les commandes peuvent être enregistrées dans les touches Fx et rapidement réutilisées.\")\
character_message(Character, \"Appuyer sur shift + F1 sauvegarde la commande courante dans F1.\")\
character_message(Character, \"F1 ajoute le texte sauvegardé dans la commande. (Échap nettoie la ligne de commande.)\")\
character_message(Character, \"Sauvegarde la commande '/lire' pour lire rapidement ces livres, de gauche à droite. \")\
")

y = y-4

place_setaspect(zone, 1, y, tileset..":book_a_open")
place_settag(zone, 1, y, "text", "Tu")

place_setaspect(zone, 3, y, tileset..":book_a_open")
place_settag(zone, 3, y, "text", "T'en")

place_setaspect(zone, x_mid, y, tileset..":book_a_open")
place_settag(zone, x_mid, y, "text", "Sors")

place_setaspect(zone, w-4, y, tileset..":book_a_open")
place_settag(zone, w-4, y, "text", "Très")

place_setaspect(zone, w-2, y, tileset..":book_a_open")
place_settag(zone, w-2, y, "text", "Bien !")

y = y-3

build_horizontal_wall(y)
place_setlandon(zone, x_mid, y, "\
character_message(Character, \"* * *\")\
character_message(Character, \"Il est possible d'interagir avec certains éléments de façon plus complexe.\")\
character_message(Character, \"Essaye d'/ouvrir et de /fermer ces objets.\")\
character_message(Character, \"Recherche des indices sur les commandes à travers le jeu.\")\
")

y = y-4

local selfclose_duration = 60 -- 1 minute

loadfile("build/tools/book.lua")(tileset, zone, 3, y, "close")
place_settag(zone, 3, y, "openclose_selfclose", selfclose_duration)
place_settag(zone, 3, y, "text", "Tu peux /fouiller les coffres.")

loadfile("build/tools/coffer.lua")(tileset, zone, w-4, y)
loadfile("build/tools/give_empty_inventory.lua")(zone, w-4, y, 1)
place_settag (zone, w-4, y, "openclose_selfclose", selfclose_duration)

place_setaspect(zone, 1, y-2, tileset..":roof_lone")
place_setaspect(zone, 1, y-1, tileset..":pillar")
place_setaspect(zone, 1, y,   tileset..":pillar_bot")

place_setaspect(zone, w-2, y-2, tileset..":roof_lone")
place_setaspect(zone, w-2, y-1, tileset..":pillar")
place_setaspect(zone, w-2, y,   tileset..":pillar_bot")

y = y-3

place_setaspect(zone, x_mid-2, y,   tileset..":wall_botlft")
place_setaspect(zone, x_mid-1, y,   tileset..":bigdoor_lft")
place_setaspect(zone, x_mid,   y,   tileset..":bigdoor_closed")
place_setaspect(zone, x_mid+1, y,   tileset..":bigdoor_rgt")
place_setaspect(zone, x_mid+2, y,   tileset..":wall_botrgt")

place_setaspect(zone, x_mid-2, y-1, tileset..":wall_lft")
place_setaspect(zone, x_mid-1, y-1, tileset..":bigdoor_toplft")
place_setaspect(zone, x_mid,   y-1, tileset..":bigdoor_top")
place_setaspect(zone, x_mid+1, y-1, tileset..":bigdoor_toprgt")
place_setaspect(zone, x_mid+2, y-1, tileset..":wall_rgt")

place_setaspect(zone, x_mid-2, y-2, tileset..":roof_endlft")
place_setaspect(zone, x_mid-1, y-2, tileset..":roof_horizontal")
place_setaspect(zone, x_mid,   y-2, tileset..":roof_horizontal")
place_setaspect(zone, x_mid+1, y-2, tileset..":roof_horizontal")
place_setaspect(zone, x_mid+2, y-2, tileset..":roof_endrgt")

loadfile("build/tools/openclose_build.lua")(zone, x_mid, y, "close", tileset..":bigdoor", tileset..":bigdoor_closed")
place_settag(zone, x_mid, y, "openclose_selfclose", selfclose_duration)

place_setlandon(zone, x_mid, y, "character_changezone(Character, \""..lobby_zone.."\", "..lobby_x..", "..lobby_y..")")

return zone, entrance_x, entrance_y
