-- Includes
local application = require "hs.application"

-- Vars
local mash = {"cmd", "alt", "ctrl"}

-- Default alert style
--hs.alert.defaultStyle.strokeColor =  {white = 1, alpha = 0}
--hs.alert.defaultStyle.fillColor =  {white = 0.05, alpha = 0.75}
--hs.alert.defaultStyle.radius =  10
--hs.alert.defaultStyle.textSize = 18

-- Reload hs config
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
	hs.reload()
end)
--hs.alert("hsconfig reloaded")

-- System event watcher
function caffeinateWatcher(eventType)
	if (eventType == hs.caffeinate.watcher.systemDidWake) then
		-- wake:start()
		hs.execute("/Users/$USER/Scripts/hibernate.sh restore", true)
	end
end
sleepWatcher = hs.caffeinate.watcher.new(caffeinateWatcher)
sleepWatcher:start()

-- caffeine - Menu bar icon only displayed when caffeine is on
caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
	if state then
		if caffeine:isInMenuBar() == false then -- true when object first loads
			caffeine:returnToMenuBar()
			caffeine:setIcon("caffeine.pdf")
		else
			caffeine:setIcon("caffeine.pdf")
		end
	else
		if caffeine:isInMenuBar() == true then
			caffeine:removeFromMenuBar()
		end
	end
end
function caffeineClicked()
	setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end
if caffeine then
	caffeine:setClickCallback(caffeineClicked)
	setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end
hs.hotkey.bind(mash, "C", function() caffeineClicked()
end)

-- Open apps
function openSafari()
	application.launchOrFocus("Safari")
end

function openMessages()
	application.launchOrFocus("Messages")
end

function openSpotify()
	application.launchOrFocus("Spotify")
end

function openiTunes()
	application.launchOrFocus("iTunes")
end

function openiTerm()
	application.launchOrFocus("iTerm")
end

hs.hotkey.bind(mash, 'S', openSafari)
hs.hotkey.bind(mash, 'M', openMessages)
hs.hotkey.bind(mash, 'P', openSpotify)
hs.hotkey.bind(mash, 'I', openiTunes)
hs.hotkey.bind(mash, 'T', openiTerm)

-- Power events for eject key (broken in Karabiner-Elements)
powerEventTap = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged, hs.eventtap.event.types.NSSystemDefined }, function(event)
local flags = hs.eventtap.checkKeyboardModifiers()
local systemKey = event:systemKey()
	if flags.ctrl and flags.shift and systemKey.key == "EJECT" and systemKey.down and not systemKey["repeat"] then
		os.execute("pmset displaysleepnow") -- Sleep display
		return true
	end
	if flags.ctrl and flags.alt and flags.cmd and systemKey.key == "EJECT" and systemKey.down and not systemKey["repeat"] then
		hs.osascript.applescript([[ tell app "System Events" to shut down ]]) -- Shutdown
		return true
	end
	if flags.alt and flags.cmd and systemKey.key == "EJECT" and systemKey.down and not systemKey["repeat"] then
		os.execute("pmset sleepnow") -- Sleep
		return true
	end
	if flags.ctrl and flags.cmd and systemKey.key == "EJECT" and systemKey.down and not systemKey["repeat"] then
		hs.osascript.applescript([[ tell app "System Events" to restart ]]) -- Restart
		return true
	end
end):start()
