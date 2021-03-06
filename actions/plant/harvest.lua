#!/usr/bin/lua

local zone = character_getzone(Character);
local x = character_getx(Character);
local y = character_gety(Character);

-- Get artifact in character's hands.
local artifact = character_gettag(Character, "hand");
if not artifact or artifact == "" then
	character_message(Character, "Tu ne peux pas /récolter.");
	return;
end

local name
local inventory

-- Get inventory from artifact.
if artifact ~= "EMPTY" then
	name = artifact_getname(artifact);
	inventory = artifact_gettag(artifact, "inventory");
	if inventory == "" then inventory = nil; end
end

local function fun(x, y)
	-- Check if target is a plant.
	if place_gettag(zone, x, y, "plant_state") == "mature" then
		-- Check if artifact held in hand.
		if artifact == "EMPTY" then
			character_message(Character, "Tu dois tenir un conteneur en main.");
			return true;
		end

		-- Check if container.
		if not inventory then
			character_message(Character, name.." n'est pas un conteneur.");
			return true;
		end

		-- Harvest plant.
		local plant = place_gettag(zone, x, y, "plant_name");
		local aspect = place_gettag(zone, x, y, "plant_aspect");
		local added = inventory_add(inventory, 1, plant);
		if added <= 0 then
			character_message(Character, "Tu n'as plus de place dans : "..name);
			return true;
		end

		character_message(Character, "Tu récoltes "..added.." "..plant.." dans : "..name);
		loadfile("logic/plant/destroy.lua")(zone, x, y);

		-- Give seed.
		if c_rand(4) ~= 4 then
			return true;
		end
		-- local seed = server_gettag("seedof:"..plant); -- TODO
		local seed = "Spore rouge"; -- XXX
		added = inventory_add(inventory, 1, seed)
		if added <= 0 then
			character_message(Character, "Oups. "..seed.." déborde de : "..name);
		else
			character_message(Character, "Tu récoltes également : "..seed);
			character_hint(Character, aspect, "/semer "..seed);
		end
		return true;
	end

	-- Check if target is a tree.
	local aspect = place_getaspect(zone, x, y);
	local tileset, tile = string.match(aspect, "(.*):(.*)");
	if tile ~= "trees_lft" and tile ~= "trees_rgt" and tile ~= "tree_toplft" and tile ~= "tree_toprgt" and tile ~= "tree_botlft" and tile ~= "tree_botrgt" then
		return false;
	end

	-- Get color of leaves.
	local color = "";
	if tileset == "forest_corrupted" then
		color = " bleues";
	elseif tileset == "forest_underground" then
		color = " violettes";
	end

	if artifact == "EMPTY" then
		-- Make leaves bag.
		local bag = create_artifact("Sac de feuilles"..color);
		artifact_settag(bag, "inventory", create_inventory(3));
		character_settag(Character, "hand", bag);
		character_message(Character, "Tu fabriques un sac avec des feuilles.");
		character_hint(Character, tileset.."_leavesbag", "/contenu");
		return true;
	end

	-- Check if container.
	if not inventory then
		character_message(Character, name.." n'est pas un conteneur.");
		return true;
	end
	
	-- Fill container with leaves.
	local item = "Feuilles"..color;
	local added = inventory_add(inventory, 1, item);
	if added > 0 then
		character_message(Character, "Tu récoltes "..added.." "..item.." dans : "..name);
	else
		character_message(Character, "Tu n'as plus de place dans : "..name);
	end
	return true;
end

if not fun(x, y)
and not fun(x, y-1)
and not fun(x, y+1)
and not fun(x-1, y)
and not fun(x+1, y)
then
	character_message(Character, "Il n'y a rien à /récolter.");
end
