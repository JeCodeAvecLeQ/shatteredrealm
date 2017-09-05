#!/usr/bin/lua

local zone = player_getzone(Player)
local x = player_getx(Player)
local y = player_gety(Player)

-- Check mana.
local gauge = "mana"
local cost = 1
if gauge_getval(Player, gauge) < cost then
	player_message(Player, "Tu n'as pas assez de "..gauge..".")
	return
end

-- Check if soul-vessel in hand.
local hand = player_gettag(Player, "hand")
if not hand or hand == "" or hand == "EMPTY" then
	player_message(Player, "Tu dois tenir un réceptacle d'âme en main.")
	return
end

local state = artifact_gettag(hand, "soul_vessel")
if state ~= "full" and state ~= "empty" then
	player_message(Player, "L'objet tenu en main n'est pas un réceptacle d'âme.")
	return
end

-- Do the spell.
local function fun(x, y, vessel, vessel_content)
	local place_content = place_gettag(zone, x, y, "soul_vessel")
	if not place_content or (place_content ~= "full" and place_content ~= "empty") then
		return false;
	end

	if vessel_content == "empty" then
		if place_content == "full" then
			-- Capture soul.
			place_settag(zone, x, y, "soul_vessel", "empty")
			artifact_settag(vessel, "soul_vessel", "full")
			gauge_decrease(Player, gauge, cost)
			player_message(Player, "L'âme est prise à ce lieu.")
		else
			player_message(Player, "Il n'y a pas d'âme à capturer, ici.")
		end
	else -- vessel is full
		if place_content == "empty" then
			-- Bind soul.
			artifact_settag(vessel, "soul_vessel", "empty")
			place_settag(zone, x, y, "soul_vessel", "full")
			gauge_decrease(Player, gauge, cost)
			player_message(Player, "L'âme est liée à ce lieu.")
		else
			player_message(Player, "Il y a déjà une âme, ici.")
		end
	end
	
	return true
end

if not fun(x, y, hand, state)
and not fun(x, y-1, hand, state)
and not fun(x, y+1, hand, state)
and not fun(x-1, y, hand, state)
and not fun(x+1, y, hand, state)
then
	player_message(Player, "Il n'y a pas de réceptacle d'âme, ici.")
end