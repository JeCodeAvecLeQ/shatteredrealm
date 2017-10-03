#!/usr/bin/lua

add_action("nom", "dofile(\"actions/name.lua\")");

add_action("lire",    "dofile(\"actions/read.lua\")");
add_action("écrire",  "dofile(\"actions/write.lua\")");
add_action("effacer", "dofile(\"actions/clear.lua\")");

add_action("ouvrir",      "dofile(\"actions/open.lua\")");
add_action("fermer",      "dofile(\"actions/close.lua\")");
add_action("verrouiller", "dofile(\"actions/lock.lua\")");

add_action("fouiller",   "dofile(\"actions/search.lua\")");
add_action("examiner",   "dofile(\"actions/search.lua\")");
add_action("inspecter",   "dofile(\"actions/search.lua\")");
add_action("inventaire", "dofile(\"actions/inventory.lua\")");
add_action("contenu",    "dofile(\"actions/inventory.lua\")");
add_action("prendre",    "dofile(\"actions/take.lua\")");
add_action("saisir",     "dofile(\"actions/take.lua\")");
add_action("dégainer",   "dofile(\"actions/take.lua\")");
add_action("sortir",     "dofile(\"actions/take.lua\")");
add_action("poser",      "dofile(\"actions/drop.lua\")");
add_action("déposer",    "dofile(\"actions/drop.lua\")");
add_action("rengainer",  "dofile(\"actions/drop.lua\")");
add_action("ranger",     "dofile(\"actions/drop.lua\")");
add_action("équiper",    "dofile(\"actions/equip.lua\")");
add_action("mettre",     "dofile(\"actions/equip.lua\")");
add_action("déséquiper", "dofile(\"actions/unequip.lua\")");
add_action("enlever",    "dofile(\"actions/unequip.lua\")");
add_action("jeter",      "dofile(\"actions/discard.lua\")");
add_action("vider",      "dofile(\"actions/empty.lua\")");

add_action("incanter", "dofile(\"actions/cast.lua\")");
add_action("détecter", "dofile(\"actions/detect.lua\")");

add_action("tresser", "dofile(\"actions/braid.lua\")");
add_action("miner",   "dofile(\"actions/mine.lua\")");

-- Plant commands.
add_action("récolter", "dofile(\"actions/plant/harvest.lua\")");
add_action("écraser",  "dofile(\"actions/plant/squash.lua\")");
add_action("semer",    "dofile(\"actions/plant/sow.lua\")");
add_action("planter",  "dofile(\"actions/plant/sow.lua\")");

-- Demon commands.
add_action("drainer", "dofile(\"actions/demon/crystal_drain.lua\")");
add_action("dévorer", "dofile(\"actions/demon/devour_soul.lua\")");

-- Debug commands.
add_action("save",      "dofile(\"actions/debug/save.lua\")");
add_action("load",      "dofile(\"actions/debug/load.lua\")");
add_action("set",       "dofile(\"actions/debug/settile.lua\")");
add_action("tp",        "dofile(\"actions/debug/tp.lua\")");
add_action("polymorph", "dofile(\"actions/debug/polymorph.lua\")");
add_action("whereami",  "dofile(\"actions/debug/whereami.lua\")");
add_action("whoami",    "dofile(\"actions/debug/whoami.lua\")");
add_action("hop",       "dofile(\"actions/debug/hop.lua\")");


new_add_action("prier", "dofile(\"actions/pray.lua\")"); --syntaxe equivalente a add_action()
declare_action("oui") -- sert a declarer l'existence d'une action sans associer de handler
declare_action("non")

info("Character actions loaded.");
