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

-- Event for Ctrl+Shift+Eject to sleep display (Karabiner Elements breaks this shortcut)
hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(eventCS) -- Ctrl+Shift
	local flagsCS = eventCS:getFlags()
	if flagsCS.ctrl and flagsCS.shift then
		hs.eventtap.new({ hs.eventtap.event.types.NSSystemDefined }, function(eventE) -- Eject
			local flagsE = eventE:systemKey()
			if flagsE.key == 'EJECT' and flagsE.down then
				-- TODO: This runs incrementally
				os.execute("pmset displaysleepnow")
				--
			end
		end):start()
	end
end):start()
