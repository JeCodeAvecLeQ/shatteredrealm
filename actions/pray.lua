#!/usr/bin/lua
if praying == nil then
	praying = {}
end

local function fun() 
	if praying[Character] then
		character_message(Character, "Tu es déjà entrain d'essayer de prier!")
		return
	end
	praying[Character] = true
	character_message(Character, "Est-tu sûr de vouloir prier? ")
	result = async.await_any(event_action("oui"), event_action("non"))
	praying[Character] = nil
	if (result == 1) then
		character_message(Character, "OK!")
	else
		character_message(Character, "Tant pis...")
		erreurdemerde.blah = 5
	end
end
async.start(fun)


