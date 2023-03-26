-- Vars
hpath = "~/.config/hammerspoon/"
mash = {"ctrl", "alt", "cmd"}

-- Default alert style
hs.alert.defaultStyle.strokeColor =  {white = 1, alpha = 0}
hs.alert.defaultStyle.fillColor =  {white = 0.05, alpha = 0.75}
hs.alert.defaultStyle.radius =  10
hs.alert.defaultStyle.textSize = 18

-- Reload hs config
hs.hotkey.bind(mash, "R", function()
	hs.reload()
end)

-- Load SpoonInstall
local spath = hpath .. 'Spoons/'
if hs.fs.displayName(spath .. 'SpoonInstall.spoon') then
	hs.loadSpoon('SpoonInstall') -- Load SpoonInstall
else
	if not hs.fs.displayName(spath) then -- Create Spoons directory if required
		hs.fs.mkdir(spath)
	end
	-- Download SpoonInstall spoon, unzip it, remove the zip and load SpoonInstall.
	hs.fs.chdir(spath)
	hs.execute('curl -L -o SpoonInstall.spoon.zip https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip')
	hs.execute('unzip SpoonInstall.spoon.zip')
	os.remove('SpoonInstall.spoon.zip')
	hs.loadSpoon('SpoonInstall')
end

-- Spoons
spoon.SpoonInstall:andUse('TimeMachineProgress', { start = true })
-- spoon.SpoonInstall:andUse('Pomodoro', { start = true }) -- TODO: Enable via hot key

-- Open apps
local application = require "hs.application"
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
		hs.caffeinate.shutdownSystem() -- Shutdown
		return true
	end
	if flags.alt and flags.cmd and systemKey.key == "EJECT" and systemKey.down and not systemKey["repeat"] then
		hs.caffeinate.systemSleep() -- Sleep
		return true
	end
	if flags.ctrl and flags.cmd and systemKey.key == "EJECT" and systemKey.down and not systemKey["repeat"] then
		hs.caffeinate.restartSystem() -- Restart
		return true
	end
end):start()

-- caffeine - Menu bar icon only displayed when caffeine is on
local caffeine = hs.menubar.new()
function setCaffeine(state)
	if state then
		if caffeine:isInMenuBar() == false then -- true when object first loads
			caffeine:returnToMenuBar()
			caffeine:setIcon("caffeinate/caffeine.pdf")
		else
			caffeine:setIcon("caffeinate/caffeine.pdf")
		end
	else
		if caffeine:isInMenuBar() == true then
			caffeine:removeFromMenuBar()
		end
	end
end
function caffeineClicked(set)
    local c = hs.caffeinate
    if c.get("systemIdle") or c.get("displayIdle") then
        c.set("systemIdle",nil,true)
        c.set("displayIdle",nil,true)
        setCaffeine(nil)
        return
    end
    if set == "display" then
        if not c.get("displayIdle") then
            c.set("displayIdle",true,true) -- Prevent display sleep
        end
    elseif set == "system" then
        if not c.get("systemIdle") then
            c.set("systemIdle",true,true) -- Prevent system sleep
        end
    end
    setCaffeine(true)
end
if caffeine then
	setCaffeine(nil)
	caffeine:setClickCallback(caffeineClicked)
end
hs.hotkey.bind({"ctrl", "alt"}, "C", function() caffeineClicked("display") end)
hs.hotkey.bind(mash, "C", function() caffeineClicked("system") end)
