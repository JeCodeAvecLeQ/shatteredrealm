local action2wchan = {}
local actionid2action = {}

local next_action_id = 0

function event_action(action) 
	return async.WEvent:new("ev:" .. action, action2wchan[action])
end

function action_fire_wchan(action_id)
	local action = actionid2action[action_id]
	if (isverbose())  then
		print("[DEBUG] WChan fired for action: " .. action)
	end
	local ret, err = pcall(action2wchan[action].fire, action2wchan[action])
	if not ret then
		print("[ERROR] during coroutine execution for action " .. action .. ": " .. err)
	end
end

function declare_action(action)
	if (action2wchan[action] == nil) then
		action2wchan[action] = async.WChan:new("wchan:" .. action)
		actionid2action[next_action_id] = action
		if (isverbose())  then
			print("[DEBUG] Created WChan for action: " .. action)
		end
		add_action(action, "action_fire_wchan(" .. next_action_id .. ")")
		next_action_id = next_action_id + 1
	else 
		print("warning: action " .. action .. " was already declared.")
	end
end

function new_add_action(action, handler)
	if (isverbose()) then
		print("[DEBUG] Using new handler system for: " .. action)
	end
	declare_action(action)
	local ev = async.WEvent:new("ev:" .. action, action2wchan[action])

	local f, err = load(handler)
	if f == nil then
		print("[ERROR] while parsing handler for action " .. action .. " : " .. err)
	else
		ev:hook_rearm(
			function(event, ...) 
				if (isverbose()) then
					print("[DEBUG] Event " .. event.name .. " triggered, launching handler")
				end
				local ret, err = pcall(f, ...)
				if not ret then
					print("[ERROR] while calling handler for action " .. action .. ": " .. err)
				end
			end
		)
	end
end
