#!/usr/bin/env lua5.3

-- Ce module contient la partie "technique" du fatras, est n'est pas trop documentee pour le moment... desole :p 

async = {}
async.VERSION = 1 -- module version
async.context_check = false -- enforce context check rules

------------------------------------------------------
--                       LOCALS                     --
------------------------------------------------------
local function my_isverbose()
	if (isverbose == nil) then
		return false
	end
	return isverbose()
end

local async_ctx = { context = "async", __index = async }
setmetatable(async_ctx, async_ctx)

local function ducktype_event(f)
	return type(f) == "table" and type(f.handle) == "function"
end

local function expect_event(f)
	if not ducktype_event(f) then
		error("Expected event, got: " .. type(f))
	end
end

local function wrap(f)
	local result = {}
	local idx = 1
	local fn = load(string.dump(f))
	while true do
		local name, val = debug.getupvalue(f, idx)
		if not name then
			break
		end
		if name == "async" then
			local function fp()
				return async_ctx
			end
			debug.upvaluejoin(fn, idx, fp, 1)
		else
			debug.upvaluejoin(fn, idx, f, idx)
		end
		idx = idx + 1
	end
	return fn
end


local function resume_unless_error(f, ...)
	local tab = table.pack(coroutine.resume(f, ...))
	if not tab[1] then
		if my_isverbose() then
			print("[DEBUG] Coroutine " .. tostring(f) .. " was killed due to an error.")
		end
		error(tab[2])
	else
		return table.unpack(tab, 2)
	end
end

local function next_step(coro, finished, ...)
	local tab, event
	tab = table.pack(resume_unless_error(coro, ...))
	if coroutine.status(coro) == "suspended" then
		expect_event(tab[1])
		event = tab[1]
		if (my_isverbose()) then
			print("[DEBUG] Coroutine " .. tostring(coro) .. " suspended on event: " .. event.name)
		end
		event:hook(
			function(self, ...) 
				if (my_isverbose()) then
				print("[DEBUG] Coroutine " .. tostring(coro) .. " resumed because event " .. self.name .. " was triggered.")
				end
				next_step(coro, finished, ...) 
			end)
	elseif coroutine.status(coro) == "dead" then
		if my_isverbose() then
			print("[DEBUG] Coroutine " .. tostring(coro) .. " finished normally.")
		end
		assert(not ducktype_event(tab[1]), "Last value of async function should not be an Event")
		finished:handle(table.unpack(tab))
	else
		error("unknown coroutine status: " .. coroutine.status(coro))
	end
end


------------------------------------------------------
--                       EXPORTS                    --
------------------------------------------------------

async.context = "sync"

async.await = function()
	error("await cannot be used in functions that were not called by await")
end

async.WChan = { }
async.WChan.__index = async.WChan

function async.WChan.new(self, name)
	local newObj = {}
	newObj.name = name
	newObj.events = {}
	return setmetatable(newObj, self)
end

function async.WChan.fire(self, ...)
	local events = self.events
	local handled = false
	self.events = {}
	for key,value in pairs(events) do
		print("[DEBUG] Triggering event: " .. key.name)
		key:handle(...)
		handled = true
	end
	if not handled then
		if my_isverbose() then
			print("[DEBUG] WChan " .. self.name .. " fired, but nobody was listening...")
		end
	end
end

function async.WChan.register(self, event)
	self.events[event] = true
end

function async.WChan.unregister(self, event)
	self.events[event] = nil
end

async.Event = {}
async.Event.__index = async.Event
function async.Event.new(self)
	local newObj = {}
	return setmetatable(newObj, self)
end

function async.Event.handle(self, ...)
	self.result = table.pack(...)
end

function async.Event.hook(self, f)
	local g = function (ev, ...) 
		if not ev.fired then
			ev.fired = true
			f(ev, ...) 
		end
	end
	self.handle = g
	if not (self.result == nil) then
		g(self, table.unpack(self.result))
	end
end

async.never = async.Event:new()
async.now = async.Event:new()
async.now.result = {}

async.WEvent = async.Event:new()
async.WEvent.__index = async.WEvent
function async.WEvent.new(self, name, wchan, ...)
	local newObj = {}
	newObj.name = name
	newObj.wchan = wchan
	newObj.wchan_args = table.pack(...)
	wchan.register(wchan, newObj)
	return setmetatable(newObj, self)
end

function async.WEvent.rearm(self) 
	self.result = nil
	self.fired = nil
	self.wchan.register(self.wchan, self)
end

function async.WEvent.hook_rearm(self, f)
	async.Event.hook(self, function(event, ...) event:rearm() f(event, ...) end)
end

function async.start(f, ...) 
	local finished = async.Event:new()
	local coro = coroutine.create(wrap(f))
	if my_isverbose() then
		print("[DEBUG] Coroutine start: " .. tostring(coro))
	end
	next_step(coro, finished, ...)
	return finished
end

function async.when_all_done(...)
	local eventtab = table.pack(...)
	local master = async.Event:new()
	local num_done = 0
	master.results = {}
	master.name = ""
	for k,v in ipairs(eventtab) do
		v:hook(function(self, ...)
			if master.results[v] == nil then
				num_done = num_done + 1
			end
			master.results[v] = table.pack(...)
			if (num_done == #eventtab) then
				local list_results = {}
				for k2,v2 in ipairs(eventtab) do
					list_results[#list_results + 1] = master.results[v2]
				end
				master:handle(table.unpack(list_results))
			end
		end)
		master.name = master.name .. v.name .. ","
	end
	master.name = "all(" .. master.name .. ")"
	return master
end

function async.when_any_done(...)
	local eventtab = table.pack(...)
	local master = async.Event:new()
	master.name = ""
	for k,v in ipairs(eventtab) do
		v:hook(function(self, ...)
			master:handle(k, ...)
		end)
		master.name = master.name .. v.name .. ","
	end
	master.name = "any(" .. master.name .. ")"
	return master
end

function async.await(callee, ...)
	assert(not async.context_check, "Cannot use await in functions not called by await")
	return callee(...)
end

function async_ctx.await(callee, ...)
	return wrap(callee)(...)
end


function async.Event.next(self, f)
	return async.start(function(...)
		local args = table.pack(coroutine.yield(self))
		local ev = f(table.unpack(args))
		args = table.pack(coroutine.yield(ev))
		return table.unpack(args)
	end)
end

function async.await_event(event)
	return coroutine.yield(event)
end

function async.await_any(...)
	return coroutine.yield(async.when_any_done(...))
end

function async.await_all(...)
	return coroutine.yield(async.when_all_done(...))
end

function async.wait_chan(channel, ...)
	return async.wait_event(async.WEvent:new("wait:" .. channel.name, channel, ...))
end

print("Asynchronous event handler version " .. async.VERSION .. " initialized.")
return async
