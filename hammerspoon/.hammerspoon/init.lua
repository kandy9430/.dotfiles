hs.application.enableSpotlightForNameSearches(true)
hs.hotkey.alertDuration = 0 -- disable alerts when hotkeys are pressed
hs.alert.defaultStyle.atScreenEdge = 2 -- position alerts at bottom of screen
hs.alert.defaultStyle.atScreenOffset = 100 -- offset alerts from bottom of screen
hs.window.highlight.ui.overlay = true -- enable overlay mode
hs.window.highlight.ui.frameWidth = 10 -- change window framewidth in overlay mode
-- hs.window.highlight.ui.frameColor = {0.5,0.5,0,0.7}
hs.window.highlight.start()

-- set the keybind mods
mods = { "alt" } 	
mods2 = {"alt", "cmd"}

hs.window.animationDuration = 0

function axHotfix(win)
	local axApp = hs.axuielement.applicationElement(win:application())
	local wasEnhanced = axApp.AXEnhancedUserInterface
	if wasEnhanced then
		axApp.AXEnhancedUserInterface = false
	end

	return function()
		if wasEnhanced then
			axApp.AXEnhancedUserInterface = true
		end
	end
end

-- Move focused window to occupy left half of screen
hs.hotkey.bind(mods, "Left",
"Move focused window to occupy left half of screen",
function()
	local win = hs.window.focusedWindow();
	if not win then return end
	local revert = axHotfix(win)
	win:moveToUnit(hs.layout.left50)
	revert()
end)
		
-- Move focused window to occupy right half of screen
hs.hotkey.bind(mods, "Right",
"Move focused window to occupy right half of screen",
function() 
	local win = hs.window.focusedWindow();
	if not win then return end
	local revert = axHotfix(win)
	win:moveToUnit(hs.layout.right50)
	revert()
end)

-- Toggle fullscreen
hs.hotkey.bind(mods2, "Up", 
"Toggle fullscreen",
function()
  local win = hs.window.focusedWindow();
  if not win then return end
	local revert = axHotfix(win)
  win:setFullScreen(not win:isFullScreen())
	revert()
end)

-- center focused window on screen
hs.hotkey.bind(mods, "Down",
"Center focused window on screen",
function()
	local win = hs.window.focusedWindow();
	if not win then return end
	local revert = axHotfix(win)
	win:centerOnScreen(true)
	revert()
end)

-- make current focused window occupy entire screen (except for dock and menu bar)
hs.hotkey.bind(mods, "Up", 
"make current focused window occupy entire screen (except for dock and menu bar)",
function()
	local win = hs.window.focusedWindow()
	if not win then return end
	local revert = axHotfix(win)
	win:maximize()
	revert()
end)

-- Move focused window to screen to left, if present
hs.hotkey.bind(mods2, "Left", 
"Move focused window to screen to left, if present",
function()
	local win = hs.window.focusedWindow()
	local max = screen:frame()
	local screenToLeft = screen:toWest()

	if screenToLeft then
		win:moveOneScreenWest()
	end
end)

-- Move focused window to screen to right, if present
hs.hotkey.bind(mods2, "Right", 
"Move focused window to screen ot right, if present",
function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()
	local screenToRight = screen:toEast()

	if screenToRight then
		win:moveOneScreenEast()
	end
end)

-- focus window frontmost window immediately to left
hs.hotkey.bind(mods, "H", 
"Focus frontmose window immediately to left",
function()
	local win = hs.window.focusedWindow()
	win:focusWindowWest(nil, true)
end)

-- focus window frontmost window immediately to right
hs.hotkey.bind(mods, "L", 
"Focus frontmost window immediately to right",
function()
	local win = hs.window.focusedWindow()
	win:focusWindowEast(nil, true)
end)

-- Minimizing Windows
-- table to store recently minimized windows to easily unminimize later
recentlyMinimizedWindows = {}

-- Display list of recently minimized windows"
hs.hotkey.bind(mods, "S",
"Display list of recently minimized windows",
function()
	local windows = ""
	for i = 1, #recentlyMinimizedWindows do
		local window = recentlyMinimizedWindows[i]
		windows = windows .. i .. ": " .. window:application():title() .. "\n"
	end
	hs.alert.show(windows)
end)

-- minimize all windows on the focused screen
hs.hotkey.bind(mods, "D", 
"Minimize all windows on the focused screen",
function()
	local screen = hs.screen.mainScreen()
	local windows = hs.window.visibleWindows()
	for i = 1, #windows do
		local window = windows[i]
		if window:screen() == screen then
			addToRecentlyMinimized(window)
			window:minimize()
		end
	end
end)

-- minimize current focused window
hs.hotkey.bind(mods, "-", 
"Minimize current window",
function()
	local window = hs.window.focusedWindow()
	addToRecentlyMinimized(window)
	if lastFocused == nil then
		if not window:focusWindowWest(nil, true) then
			window:focusWindowEast(nil, true)
		end
	else lastFocused:focus()
	end
	window:minimize()
end)

-- function to create hotkeys to unminimize recently minimized windows
recentlyClosedHotkeys = function(recentlyMinimized)
	for i = 1, #recentlyMinimized do
		hs.hotkey.bind(mods, tostring(i),
		"open window " .. i .. " of recently closed table",
		function()
			recentlyMinimized[i]:unminimize():focus()
		end)
	end
end

-- Check if element is in array, and return true and the index in array 
inArray = function(element, array)
	local inArray = false
	local index = 0
	for i = 1, #array do
		if element == array[i] then
			inArray = true
			index = i
			break
		end
	end
	return inArray, index
end

addToRecentlyMinimized = function(window)
	-- check if focused window to be minimized is already in the array
	local inArray = inArray(window, recentlyMinimizedWindows)
	-- if not, then insert into array, and generate hotkeys
	if not inArray and window:title() ~= "" then
		table.insert(recentlyMinimizedWindows, window) 
		recentlyClosedHotkeys(recentlyMinimizedWindows)
	end
end

removeFromRecentlyMinimized = function(window)
	-- check if focused window to be minimized is already in the array
	local inArray, index = inArray(window, recentlyMinimizedWindows)
	if inArray then
		table.remove(recentlyMinimizedWindows, index)
	end
end

-- close window, kill app if it was only window open
hs.hotkey.bind(mods, "K",
"Close current window",
function()
	local win = hs.window.focusedWindow()
	local app = win:application()
	removeFromRecentlyMinimized(win)
	if not win:focusWindowWest(nil, true) then
		win:focusWindowEast(nil, true)
	end
	win:close()
	if #app:allWindows() == 0 then
		app:kill()
	end
end)

-- end minimizing windows
	
-- Window movement/resizing modal 
-- Variable for the window to be adjusted in modal mode. Set when enterring
modalWindow = nil

-- define the hotkey to enter the modal mode
w = hs.hotkey.modal.new(mods, "W",
"Enter window movement and resizing modal")

-- when modal is entered, show an alert, and set modalWindow variable as focused window
function w:entered() 
	modalWindow = hs.window.focusedWindow()
	-- only enter mode if a window was focused at the time
	if modalWindow == nil then
		hs.alert.show("No window focused, window modal not entered")
		w:exit()
	else
		hs.alert.show("Entered window modal for: " .. modalWindow:application():title())
	end
end

-- when exited, show an alert and clear modalWindow variable
function w:exited() 
	modalWindow = nil
	hs.alert.show("Exited window modal") 
end

-- Keybind to set "ESC" key to exit modal
w:bind("", "escape", "exit window modal", function() w:exit() end)

-- function for moving or resizing based on key pressed
moveOrResize = function(key, frame)
	if key == "H" then frame.x = frame.x - 40 end
	if key == "L" then frame.x = frame.x + 40 end
	if key == "K" then frame.y = frame.y - 40 end
	if key == "J" then frame.y = frame.y + 40 end
	if key == "LEFT" then frame.w = frame.w - 40 end
	if key == "RIGHT" then frame.w = frame.w + 40 end
	if key == "UP" then frame.h = frame.h - 40 end
	if key == "DOWN" then frame.h = frame.h + 40 end
	return frame
end

-- function to set keybinds
-- first callback is called when key is pressed
-- third callback is called when key is repeating
modalMoveOrResize = function(key, message)
	w:bind("", key, message, function()
		local frame = modalWindow:frame()
		modalWindow:setFrameInScreenBounds(moveOrResize(key, frame))
	end, nil, function()
		local frame = modalWindow:frame()
		modalWindow:setFrameInScreenBounds(moveOrResize(key, frame))
	end)
end

-- movement keybinds, similar to VIM cursor movement
modalMoveOrResize("H", "Move window left")
modalMoveOrResize("L", "Move window right")
modalMoveOrResize("K", "Move window up")
modalMoveOrResize("J", "Move window down")

-- Resize keybinds
modalMoveOrResize("LEFT", "Decrease window width")
modalMoveOrResize("RIGHT", "Increase window width")
modalMoveOrResize("UP", "Increase window height")
modalMoveOrResize("DOWN", "Decrease window height")
-- End Window Modal


-- screen layouts
-- laptop only layout with terminal on left half, chrome on right half
hs.hotkey.bind(mods, "f1", 
"Laptop only layout with terminal on left, chrome on right",
function()
	local laptopScreen = hs.screen.allScreens()[1]:name()
	-- "Built-in Retina Display"
	-- local chrome = "Google Chrome"
	-- local terminal = "Terminal"
	local chrome = hs.application.open("Google Chrome")
	local terminal = hs.application.open("Terminal")
	chrome:activate()
	terminal:activate()
	local laptopOnlyLayout = {
		{terminal, nil, laptopScreen, hs.layout.left50, nil, nil},
		{chrome, nil, laptopScreen, hs.layout.right50, nil, nil}
	}
	hs.layout.apply(laptopOnlyLayout)
end)
-- end screen layouts


-- battery watcher
-- alert to remove charger when battery is almost done charging
function removeCharger()
	if hs.battery.isFinishingCharge() then
		hs.alert.show("Battery is almost charged, unplug charger")
	end
end

batteryChargingWatcher = hs.battery.watcher.new(removeCharger)
batteryChargingWatcher:start()

-- alert to plugin charger when battery is less than 20%  
function pluginCharger()
	local pct =  hs.battery.percentage()
	if not hs.battery.isCharging() and pct < 20 then
		hs.alert.show(string.format(
		"Battery %d%%, Plugin charger", pct))
	end
end

batteryPctWatcher = hs.battery.watcher.new(pluginCharger)
batteryPctWatcher:start()
-- end battery watcher

-- Cheat sheets
-- function to create keybinds for opening cheat sheets
function openCheatSheet(key, message, file)
	local dir = "/Users/akeane/Desktop/dev_tools"
	hs.hotkey.bind(mods, key, message,
	function()
		hs.execute("open " .. dir .. "/" .. file)
	end)
end

-- open tmux cheat sheet
openCheatSheet("M", "open tmux cheat sheet", "tmux_cheat_sheet.txt")

-- open git cheat sheet
openCheatSheet("G", "open git cheat sheet", "git_cheat_sheet.txt")

-- open vim cheat sheet
openCheatSheet("V", "open vim cheat sheet", "vim_cheat_sheet.pdf")
-- end cheat sheets

-- show all currently active hotkeys
hs.hotkey.showHotkeys(mods, "/")

-- automatic config reload when init files change
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")
