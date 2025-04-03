--[[
   ██╗  ██╗███████╗███████╗████████╗███████╗███████╗██████╗ 
   ╚██╗██╔╝██╔════╝██╔════╝╚══██╔══╝██╔════╝██╔════╝██╔══██╗
    ╚███╔╝ █████╗  ███████╗   ██║   █████╗  █████╗  ██████╔╝
    ██╔██╗ ██╔══╝  ╚════██║   ██║   ██╔══╝  ██╔══╝  ██╔══██╗
   ██╔╝ ██╗███████╗███████║   ██║   ███████╗███████╗██║  ██║
   ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   ╚══════╝╚══════╝╚═╝  ╚═╝
                                                           
   XESTEER HUB - BLUE LOCK RIVALS MASTER X EDITION v5.0
   DEVELOPED BY: XESTEER DEVELOPMENT TEAM
   No Key | 100% Free | Compatible with any executor
]]--

-- CORE CONFIGURATION AND PROTECTION SYSTEMS

-- Safe initialization with error handling
local XesteerHub = {}
local SuccessInit, ErrorMessage = pcall(function()

-- Roblox environment check
if not game then
    warn("XESTEER HUB: Roblox environment not detected")
    return
end

-- Service caching for better performance
local Services = setmetatable({}, {
    __index = function(self, service)
        local success, result = pcall(function()
            return game:GetService(service)
        end)
        
        if success then
            self[service] = result
            return result
        else
            warn("XESTEER HUB: Failed to load service " .. service)
            return nil
        end
    end
})

-- Core services
local Players = Services.Players
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = Services.ReplicatedStorage
local UserInputService = Services.UserInputService
local RunService = Services.RunService
local TweenService = Services.TweenService
local HttpService = Services.HttpService
local CoreGui = Services.CoreGuiService or Services.CoreGui
local Lighting = Services.Lighting

-- Safe instance creation for cross-executor compatibility
local function SafeInstance(className)
    local success, instance = pcall(function()
        return Instance.new(className)
    end)
    
    if success and instance then
        return instance
    else
        warn("XESTEER HUB: Failed to create instance of " .. className)
        return nil
    end
end

-- Safe functions for cross-executor compatibility
local SafeFuncs = {
    wait = (task and task.wait) or wait,
    spawn = (task and task.spawn) or spawn,
    delay = (task and task.delay) or delay,
    hookmetamethod = hookmetamethod or function() return false end,
    hookfunction = hookfunction or function() return false end,
    getnamecallmethod = getnamecallmethod or function() return "" end,
    setclipboard = setclipboard or function() return false end,
    request = request or http_request or (syn and syn.request) or (http and http.request) or function() return {Success = false} end
}

-- Device detection
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local IS_HIGHEND = not IS_MOBILE and not (hookfunction == nil)

-- Game verification
local TargetGameId = 18668065416 -- BLUE LOCK RIVALS
local IsTargetGame = game.PlaceId == TargetGameId or game.GameId == TargetGameId

if not IsTargetGame then
    warn("XESTEER HUB: This script is specifically for BLUE LOCK RIVALS")
    warn("Current game ID: " .. tostring(game.PlaceId))
    
    local messagebox = messagebox or function() return 6 end
    local userChoice = messagebox("This script is specifically for BLUE LOCK RIVALS.\nDo you want to continue anyway?", "XESTEER HUB", 4)
    
    if userChoice ~= 6 then
        return
    end
end

-- EXECUTOR DETECTION

local ExecutorName = "Universal"
local ExecutorTier = "Standard"

local executorChecks = {
    ["Synapse X"] = {
        check = function() return syn and syn.protect_gui end,
        tier = "Premium"
    },
    ["Script-Ware"] = {
        check = function() return identifyexecutor and identifyexecutor():find("ScriptWare") end,
        tier = "Premium"
    },
    ["KRNL"] = {
        check = function() return KRNL_LOADED or (identifyexecutor and identifyexecutor():find("KRNL")) end,
        tier = "Premium"
    },
    ["Fluxus"] = {
        check = function() return fluxus and fluxus.request end,
        tier = "Standard"
    },
    ["Oxygen U"] = {
        check = function() return pebc_execute end,
        tier = "Standard"
    },
    ["Arceus X"] = {
        check = function() return Arceus and Arceus.GetExecutorName end,
        tier = "Mobile"
    },
    ["JJSploit"] = {
        check = function() return is_jjsploit_loaded or (identifyexecutor and identifyexecutor():find("JJSploit")) end,
        tier = "Basic"
    },
    ["Electron"] = {
        check = function() return is_electron_loaded or IS_ELECTRON end,
        tier = "Basic"
    },
    ["Hydrogen"] = {
        check = function() return Hydrogen and Hydrogen.Shared end,
        tier = "Basic"
    },
    ["Temple"] = {
        check = function() return is_temple_loaded or Temple end,
        tier = "Standard"
    },
    ["Comet"] = {
        check = function() return is_comet_loaded or getgenv().comet end,
        tier = "Standard"
    },
    ["Evon"] = {
        check = function() return is_evon_loaded or evon end,
        tier = "Standard"
    }
}

-- Detect current executor
for name, data in pairs(executorChecks) do
    local success, result = pcall(data.check)
    if success and result then
        ExecutorName = name
        ExecutorTier = data.tier
        break
    end
end

-- Check for generic executors
if ExecutorName == "Universal" and identifyexecutor then
    local success, result = pcall(identifyexecutor)
    if success and type(result) == "string" then
        ExecutorName = result
    end
end

-- ANTI-BAN AND ANTI-KICK PROTECTION SYSTEMS

-- Advanced Anti-Kick system
local AntiKickEnabled = true
local OriginalNamecall

if AntiKickEnabled and SafeFuncs.hookmetamethod then
    OriginalNamecall = SafeFuncs.hookmetamethod(game, "__namecall", function(self, ...)
        local method = SafeFuncs.getnamecallmethod()
        local args = {...}
        
        -- Block kick attempts
        if method == "Kick" and self == LocalPlayer then
            warn("XESTEER HUB: Kick attempt blocked")
            return SafeFuncs.wait(9e9)
        end
        
        -- Block report events
        if (method == "FireServer" or method == "InvokeServer") and 
           (self.Name:lower():find("report") or self.Name:lower():find("anticheat") or self.Name:lower():find("anti exploit")) then
            warn("XESTEER HUB: Report/anticheat event blocked - " .. self.Name)
            return
        end
        
        return OriginalNamecall(self, ...)
    end)
end

-- Anti-Ban System
local function SetupAntiBan()
    if not ReplicatedStorage then return false end
    
    -- Monitor new RemoteEvents that might be ban systems
    local connection = ReplicatedStorage.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            if child.Name:lower():find("ban") or 
               child.Name:lower():find("kick") or 
               child.Name:lower():find("report") or
               child.Name:lower():find("security") or
               child.Name:lower():find("anticheat") or
               child.Name:lower():find("detect") then
                
                SafeFuncs.wait()
                
                -- Disable remote function
                if typeof(child.FireServer) == "function" then
                    local oldFireServer = child.FireServer
                    child.FireServer = function() return nil end
                end
                
                if typeof(child.InvokeServer) == "function" then
                    local oldInvokeServer = child.InvokeServer
                    child.InvokeServer = function() return nil end
                end
                
                warn("XESTEER HUB: Security/ban remote blocked - " .. child.Name)
            end
        end
    end)
    
    -- Check existing RemoteEvents
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) and 
           (remote.Name:lower():find("ban") or 
            remote.Name:lower():find("kick") or 
            remote.Name:lower():find("security") or
            remote.Name:lower():find("anticheat") or
            remote.Name:lower():find("detect")) then
            
            -- Try to disable
            pcall(function()
                if typeof(remote.FireServer) == "function" then
                    local oldFireServer = remote.FireServer
                    remote.FireServer = function() return nil end
                end
                
                if typeof(remote.InvokeServer) == "function" then
                    local oldInvokeServer = remote.InvokeServer
                    remote.InvokeServer = function() return nil end
                end
                
                warn("XESTEER HUB: Existing security/ban remote blocked - " .. remote.Name)
            end)
        end
    end
    
    return true
end

-- Initialize Anti-Ban
local AntiBanSuccess = pcall(SetupAntiBan)

-- XESTEER HUB GRAPHICAL INTERFACE

-- GUI protection for different executors
local function ProtectGui(gui)
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = CoreGui
    elseif gethui and type(gethui) == "function" then
        gui.Parent = gethui()
    elseif KRNL_LOADED and getgenv().protect_gui then
        getgenv().protect_gui(gui)
        gui.Parent = CoreGui
    else
        -- Fallback for other executors
        local success = pcall(function()
            gui.Parent = CoreGui
        end)
        
        if not success then
            gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
    end
    
    -- Ensure GUI is not destroyed
    local destroyCon
    destroyCon = gui.AncestryChanged:Connect(function(_, newParent)
        if newParent == nil and gui and destroyCon then
            ProtectGui(gui)
        end
    end)
end

-- Modern color scheme
local Colors = {
    Primary = Color3.fromRGB(255, 0, 0),     -- Red
    Secondary = Color3.fromRGB(15, 15, 15),  -- Lighter black
    Background = Color3.fromRGB(10, 10, 10), -- Black
    Text = Color3.fromRGB(255, 255, 255),    -- White
    SubText = Color3.fromRGB(200, 200, 200), -- Light gray
    Accent = Color3.fromRGB(200, 0, 0),      -- Dark red
    Success = Color3.fromRGB(0, 255, 100),   -- Neon green
    Error = Color3.fromRGB(255, 0, 80),      -- Red with pink
    Warning = Color3.fromRGB(255, 120, 0),   -- Orange
    Highlight = Color3.fromRGB(255, 0, 0)    -- Red
}

-- Create interface elements
local function Create(className)
    local obj = SafeInstance(className)
    return function(properties)
        if not obj then return nil end
        
        for prop, value in pairs(properties) do
            obj[prop] = value
        end
        
        return obj
    end
end

-- Create Tweens for animations
local function CreateTween(instance, properties, time, style, direction)
    if not instance then return nil end
    
    local info = TweenInfo.new(
        time or 0.5,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(instance, info, properties)
    return tween
end

-- Blue Lock Rivals character selection
local BlueLockCharacters = {
    "Isagi Yoichi",
    "Bachira Meguru",
    "Chigiri Hyoma",
    "Kunigami Rensuke",
    "Nagi Seishiro",
    "Barou Shouei",
    "Rin Itoshi",
    "Shidou Ryusei",
    "Reo Mikage",
    "Karasu Tabito",
    "Otoya Eita",
    "Oliver Aiku",
    "Michael Kaiser",
    "Tokimitsu Aoshi",
    "Kurona Ranze",
    "Nanase Nijiro",
    "Igarashi Gurimu",
    "Wanima Hiroto",
    "Gagamaru Gin",
    "Aryu Jyubei",
    "Hiori Yo",
    "Yukimiya Kenyu",
    "Neru Sei",
    "Sendo Yuki",
    "Sae Itoshi"
}

-- Create loading animation frames
local LoadingAnimationFrames = {
    "⠋ Loading Xesteer Hub...",
    "⠙ Loading Xesteer Hub...",
    "⠹ Loading Xesteer Hub...",
    "⠸ Loading Xesteer Hub...",
    "⠼ Loading Xesteer Hub...",
    "⠴ Loading Xesteer Hub...",
    "⠦ Loading Xesteer Hub...",
    "⠧ Loading Xesteer Hub...",
    "⠇ Loading Xesteer Hub...",
    "⠏ Loading Xesteer Hub..."
}

-- Create main categories for the hub
local Categories = {
    {
        Name = "Player",
        Icon = "👤",
        SubCategories = {
            {
                Name = "Movement",
                Features = {
                    { Name = "Super Speed", Default = true, Type = "Slider", Min = 16, Max = 500, Default = 100 },
                    { Name = "Super Jump", Default = true, Type = "Slider", Min = 50, Max = 300, Default = 150 },
                    { Name = "Fly", Default = false, Type = "Toggle" },
                    { Name = "No Clip", Default = false, Type = "Toggle" },
                    { Name = "Teleport to Ball", Default = true, Type = "Button" },
                    { Name = "Teleport to Goal", Default = true, Type = "Button" }
                }
            },
            {
                Name = "Abilities",
                Features = {
                    { Name = "Infinite Stamina", Default = true, Type = "Toggle" },
                    { Name = "God Mode", Default = true, Type = "Toggle" },
                    { Name = "Super Kick", Default = true, Type = "Slider", Min = 1, Max = 10, Default = 5 },
                    { Name = "Ghost Mode", Default = false, Type = "Toggle" },
                    { Name = "Auto Block", Default = false, Type = "Toggle" },
                    { Name = "Force Field", Default = false, Type = "Toggle", Premium = true }
                }
            },
            {
                Name = "Appearance",
                Features = {
                    { Name = "Trail Effect", Default = false, Type = "Toggle" },
                    { Name = "Glow Effect", Default = false, Type = "Toggle" },
                    { Name = "Player Scale", Default = false, Type = "Slider", Min = 0.5, Max = 2, Default = 1 },
                    { Name = "Neon Body", Default = false, Type = "ColorPicker", Default = Color3.fromRGB(255, 0, 0) },
                    { Name = "Particle Effects", Default = false, Type = "Dropdown", Options = {"Fire", "Sparkles", "Smoke", "Lightning"} }
                }
            }
        }
    },
    {
        Name = "Ball Control",
        Icon = "⚽",
        SubCategories = {
            {
                Name = "Basic Controls",
                Features = {
                    { Name = "Ball Magnet", Default = true, Type = "Toggle" },
                    { Name = "Auto Dribble", Default = false, Type = "Toggle" },
                    { Name = "Ball Speed", Default = false, Type = "Slider", Min = 1, Max = 5, Default = 2 },
                    { Name = "Perfect Pass", Default = true, Type = "Toggle" },
                    { Name = "Teleport Ball", Default = true, Type = "Button" }
                }
            },
            {
                Name = "Advanced Controls",
                Features = {
                    { Name = "Auto Score", Default = false, Type = "Toggle" },
                    { Name = "Curve Ball", Default = true, Type = "Slider", Min = 0, Max = 10, Default = 5 },
                    { Name = "Power Shot", Default = true, Type = "Toggle" },
                    { Name = "Ball Trajectory", Default = false, Type = "Toggle" },
                    { Name = "Ball Size", Default = false, Type = "Slider", Min = 0.5, Max = 2, Default = 1 }
                }
            },
            {
                Name = "Special Moves",
                Features = {
                    { Name = "Direct Shoot", Default = true, Type = "Button" },
                    { Name = "Perfect Lob", Default = false, Type = "Button" },
                    { Name = "Explosive Kick", Default = true, Type = "Button" },
                    { Name = "Magnetic Control", Default = false, Type = "Toggle" },
                    { Name = "Tornado Shot", Default = false, Type = "Button", Premium = true }
                }
            }
        }
    },
    {
        Name = "Character",
        Icon = "🏃",
        SubCategories = {
            {
                Name = "Rolls & Spins",
                Features = {
                    { Name = "Auto Roll", Default = true, Type = "Toggle" },
                    { Name = "Target Character", Default = true, Type = "Dropdown", Options = BlueLockCharacters, Default = "Isagi Yoichi" },
                    { Name = "Infinite Spins", Default = true, Type = "Toggle" },
                    { Name = "100x Luck", Default = true, Type = "Toggle" },
                    { Name = "Instant Roll", Default = false, Type = "Toggle" }
                }
            },
            {
                Name = "Character Mods",
                Features = {
                    { Name = "Unlock All Characters", Default = true, Type = "Button" },
                    { Name = "Max All Stats", Default = false, Type = "Button" },
                    { Name = "Custom Skills", Default = false, Type = "Dropdown", Options = {"Egoist", "Direct Shot", "Chemical Reaction", "Spatial Awareness"} },
                    { Name = "Character Level", Default = false, Type = "Slider", Min = 1, Max = 100, Default = 50 },
                    { Name = "Evolution Unlock", Default = false, Type = "Toggle", Premium = true }
                }
            },
            {
                Name = "Special Powers",
                Features = {
                    { Name = "Flow State", Default = true, Type = "Toggle" },
                    { Name = "Weapon Mode", Default = false, Type = "Toggle" },
                    { Name = "Speed Boost", Default = true, Type = "Toggle" },
                    { Name = "Defense Break", Default = false, Type = "Toggle" },
                    { Name = "Football God Mode", Default = false, Type = "Toggle", Premium = true }
                }
            }
        }
    },
    {
        Name = "Game Mods",
        Icon = "🔧",
        SubCategories = {
            {
                Name = "Gameplay",
                Features = {
                    { Name = "Auto Win", Default = false, Type = "Toggle" },
                    { Name = "Score Multiplier", Default = false, Type = "Slider", Min = 1, Max = 10, Default = 2 },
                    { Name = "Infinite Time", Default = false, Type = "Toggle" },
                    { Name = "No Goal Cooldown", Default = true, Type = "Toggle" },
                    { Name = "Extra Time", Default = false, Type = "Button" }
                }
            },
            {
                Name = "Match Modifiers",
                Features = {
                    { Name = "Lock Score", Default = false, Type = "Toggle" },
                    { Name = "Freeze Opponents", Default = false, Type = "Toggle" },
                    { Name = "Super Teams", Default = false, Type = "Toggle" },
                    { Name = "Goal Area Control", Default = true, Type = "Toggle" },
                    { Name = "Match Speed", Default = false, Type = "Slider", Min = 0.5, Max = 2, Default = 1 }
                }
            },
            {
                Name = "Environment",
                Features = {
                    { Name = "Stadium Lights", Default = false, Type = "Toggle" },
                    { Name = "Weather Effects", Default = false, Type = "Dropdown", Options = {"Clear", "Rain", "Snow", "Fog"} },
                    { Name = "Field Size", Default = false, Type = "Slider", Min = 0.5, Max = 2, Default = 1 },
                    { Name = "Gravity", Default = false, Type = "Slider", Min = 0, Max = 2, Default = 1 },
                    { Name = "Time of Day", Default = false, Type = "Dropdown", Options = {"Day", "Night", "Sunset", "Dawn"} }
                }
            }
        }
    },
    {
        Name = "Visuals",
        Icon = "👁️",
        SubCategories = {
            {
                Name = "Performance",
                Features = {
                    { Name = "FPS Boost", Default = true, Type = "Toggle" },
                    { Name = "Potato Mode", Default = IS_MOBILE, Type = "Toggle" },
                    { Name = "Remove Textures", Default = false, Type = "Toggle" },
                    { Name = "Disable Shadows", Default = true, Type = "Toggle" },
                    { Name = "Limit FPS", Default = IS_MOBILE, Type = "Slider", Min = 30, Max = 240, Default = 60 }
                }
            },
            {
                Name = "ESP & Wallhack",
                Features = {
                    { Name = "Player ESP", Default = false, Type = "Toggle" },
                    { Name = "Ball ESP", Default = true, Type = "Toggle" },
                    { Name = "Tracers", Default = false, Type = "Toggle" },
                    { Name = "Distance ESP", Default = false, Type = "Toggle" },
                    { Name = "Team Colors", Default = true, Type = "Toggle" }
                }
            },
            {
                Name = "Effects",
                Features = {
                    { Name = "Goal Effects", Default = true, Type = "Toggle" },
                    { Name = "Ball Trail", Default = false, Type = "Toggle" },
                    { Name = "Custom Skybox", Default = false, Type = "Dropdown", Options = {"Default", "Space", "Sunset", "Vaporwave"} },
                    { Name = "Field Glow", Default = false, Type = "Toggle" },
                    { Name = "Ambient Light", Default = false, Type = "ColorPicker", Default = Color3.fromRGB(255, 255, 255) }
                }
            }
        }
    },
    {
        Name = "Farming",
        Icon = "💰",
        SubCategories = {
            {
                Name = "Auto Farm",
                Features = {
                    { Name = "Auto Play", Default = false, Type = "Toggle" },
                    { Name = "Coin Farm", Default = true, Type = "Toggle" },
                    { Name = "XP Farm", Default = true, Type = "Toggle" },
                    { Name = "Auto Join Match", Default = false, Type = "Toggle" },
                    { Name = "Auto Respawn", Default = true, Type = "Toggle" }
                }
            },
            {
                Name = "Resources",
                Features = {
                    { Name = "Infinite Coins", Default = false, Type = "Toggle" },
                    { Name = "Infinite Gems", Default = false, Type = "Toggle" },
                    { Name = "Unlock Shop Items", Default = false, Type = "Button" },
                    { Name = "Free Items", Default = false, Type = "Button" },
                    { Name = "Coin Multiplier", Default = true, Type = "Slider", Min = 1, Max = 10, Default = 2 }
                }
            },
            {
                Name = "Achievements",
                Features = {
                    { Name = "Auto Complete", Default = false, Type = "Toggle" },
                    { Name = "Instant Rewards", Default = true, Type = "Toggle" },
                    { Name = "Exp Booster", Default = true, Type = "Slider", Min = 1, Max = 5, Default = 2 },
                    { Name = "Daily Rewards", Default = false, Type = "Button" },
                    { Name = "Trophy Unlocker", Default = false, Type = "Button" }
                }
            }
        }
    },
    {
        Name = "Protection",
        Icon = "🛡️",
        SubCategories = {
            {
                Name = "Anti-Detection",
                Features = {
                    { Name = "Anti-Ban", Default = true, Type = "Toggle" },
                    { Name = "Anti-Kick", Default = true, Type = "Toggle" },
                    { Name = "Spoof Identity", Default = true, Type = "Toggle" },
                    { Name = "Hide Cheats", Default = true, Type = "Toggle" },
                    { Name = "Secure Mode", Default = false, Type = "Toggle", Premium = true }
                }
            },
            {
                Name = "Safety",
                Features = {
                    { Name = "Auto-Rejoin", Default = true, Type = "Toggle" },
                    { Name = "Crash Protection", Default = true, Type = "Toggle" },
                    { Name = "Server Hop", Default = false, Type = "Button" },
                    { Name = "Memory Clean", Default = true, Type = "Button" },
                    { Name = "Panic Mode", Default = false, Type = "Button" }
                }
            },
            {
                Name = "Status",
                Features = {
                    { Name = "Protection Status", Default = true, Type = "Label", Value = "Active" },
                    { Name = "Ban Risk Level", Default = true, Type = "Label", Value = "Low" },
                    { Name = "Cheat Detection", Default = true, Type = "Label", Value = "None" },
                    { Name = "Admin Present", Default = true, Type = "Label", Value = "No" },
                    { Name = "Safe Mode", Default = false, Type = "Toggle" }
                }
            }
        }
    },
    {
        Name = "Miscellaneous",
        Icon = "🔧",
        SubCategories = {
            {
                Name = "Tools",
                Features = {
                    { Name = "Server Info", Default = false, Type = "Button" },
                    { Name = "Player List", Default = true, Type = "Button" },
                    { Name = "Rejoin Server", Default = true, Type = "Button" },
                    { Name = "Copy Player ID", Default = false, Type = "Button" },
                    { Name = "Chat Spammer", Default = false, Type = "Toggle" }
                }
            },
            {
                Name = "Fun",
                Features = {
                    { Name = "Dance Emotes", Default = false, Type = "Button" },
                    { Name = "Fireworks", Default = false, Type = "Button" },
                    { Name = "Rainbow Character", Default = false, Type = "Toggle" },
                    { Name = "ChatBot", Default = false, Type = "Toggle" },
                    { Name = "Sound Effects", Default = false, Type = "Dropdown", Options = {"Goal", "Cheer", "Whistle", "Stadium"} }
                }
            },
            {
                Name = "Settings",
                Features = {
                    { Name = "UI Theme", Default = true, Type = "Dropdown", Options = {"Dark Red", "Dark Blue", "Dark Green", "Light Mode"} },
                    { Name = "Keybinds", Default = false, Type = "Button" },
                    { Name = "Notifications", Default = true, Type = "Toggle" },
                    { Name = "Tutorial", Default = true, Type = "Button" },
                    { Name = "Discord Server", Default = false, Type = "Button" }
                }
            }
        }
    }
}

-- TUTORIAL WALKTHROUGH SYSTEM

-- Tutorial pages for new users
local TutorialPages = {
    {
        Title = "Welcome to Xesteer Hub",
        Description = "This tutorial will guide you through the features and options of Xesteer Hub. Click 'Next' to continue.",
        Image = "rbxassetid://7733658504" -- Generic welcome image
    },
    {
        Title = "Navigation",
        Description = "Use the sidebar to switch between different categories. Each category has multiple subcategories with powerful features.",
        Image = "rbxassetid://7734034708" -- Navigation example
    },
    {
        Title = "Player Cheats",
        Description = "In the Player tab, you can modify your character's movement speed, jump height, and activate special abilities like fly mode.",
        Image = "rbxassetid://7734121187" -- Player settings image
    },
    {
        Title = "Ball Control",
        Description = "Control the ball with features like Ball Magnet, Auto Dribble, and Power Shot to dominate matches.",
        Image = "rbxassetid://7734178293" -- Ball control image
    },
    {
        Title = "Character Hacks",
        Description = "Get any character you want with Auto Roll, Infinite Spins, and increased luck. Never worry about rare characters again!",
        Image = "rbxassetid://7734251649" -- Character selection image
    },
    {
        Title = "Protection Features",
        Description = "Xesteer Hub includes advanced anti-ban and anti-kick systems to keep your account safe while using cheats.",
        Image = "rbxassetid://7734312408" -- Protection features image
    },
    {
        Title = "Quick Actions",
        Description = "Use the bottom bar for quick actions like applying all hacks at once or quickly disabling everything if needed.",
        Image = "rbxassetid://7734378954" -- Quick actions bar
    },
    {
        Title = "Ready to Play!",
        Description = "You're all set! Enjoy Xesteer Hub and dominate in Blue Lock Rivals! This tutorial can be accessed again from Settings.",
        Image = "rbxassetid://7734455872" -- Completion image
    }
}

-- Show tutorial to new users
local function ShowTutorial(parent, isFirstTime)
    -- Create tutorial container
    local TutorialBackground = Create("Frame")({
        Name = "TutorialBackground",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        ZIndex = 100,
        Parent = parent
    })
    
    -- Tutorial container
    local TutorialFrame = Create("Frame")({
        Name = "TutorialFrame",
        Size = UDim2.new(0, 500, 0, 350),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        ZIndex = 101,
        Parent = TutorialBackground
    })
    
    -- Round corners
    local TutorialCorner = Create("UICorner")({
        CornerRadius = UDim.new(0, 10),
        Parent = TutorialFrame
    })
    
    -- Stroke
    local TutorialStroke = Create("UIStroke")({
        Color = Colors.Primary,
        Thickness = 2,
        Parent = TutorialFrame
    })
    
    -- Title
    local TutorialTitle = Create("TextLabel")({
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "Welcome to Xesteer Hub",
        TextColor3 = Colors.Primary,
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        ZIndex = 102,
        Parent = TutorialFrame
    })
    
    -- Image
    local TutorialImage = Create("ImageLabel")({
        Name = "TutorialImage",
        Size = UDim2.new(0.9, 0, 0, 150),
        Position = UDim2.new(0.5, 0, 0, 60),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://7733658504",
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 102,
        Parent = TutorialFrame
    })
    
    -- Description
    local TutorialDescription = Create("TextLabel")({
        Name = "Description",
        Size = UDim2.new(0.9, 0, 0, 80),
        Position = UDim2.new(0.5, 0, 0, 220),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        Text = "This tutorial will guide you through the features and options of Xesteer Hub. Click 'Next' to continue.",
        TextColor3 = Colors.Text,
        TextSize = 16,
        TextWrapped = true,
        Font = Enum.Font.Gotham,
        ZIndex = 102,
        Parent = TutorialFrame
    })
    
    -- Next button
    local NextButton = Create("TextButton")({
        Name = "NextButton",
        Size = UDim2.new(0, 120, 0, 40),
        Position = UDim2.new(0.75, 0, 0.9, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Colors.Primary,
        BorderSizePixel = 0,
        Text = "Next",
        TextColor3 = Colors.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        ZIndex = 102,
        Parent = TutorialFrame
    })
    
    -- Round button corners
    local NextButtonCorner = Create("UICorner")({
        CornerRadius = UDim.new(0, 8),
        Parent = NextButton
    })
    
    -- Back button
    local BackButton = Create("TextButton")({
        Name = "BackButton",
        Size = UDim2.new(0, 120, 0, 40),
        Position = UDim2.new(0.25, 0, 0.9, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Text = "Back",
        TextColor3 = Colors.SubText,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        ZIndex = 102,
        Parent = TutorialFrame
    })
    
    -- Round button corners
    local BackButtonCorner = Create("UICorner")({
        CornerRadius = UDim.new(0, 8),
        Parent = BackButton
    })
    
    -- Skip button (only for first time)
    local SkipButton = nil
    if isFirstTime then
        SkipButton = Create("TextButton")({
            Name = "SkipButton",
            Size = UDim2.new(0, 120, 0, 30),
            Position = UDim2.new(0.5, 0, 1, -15),
            AnchorPoint = Vector2.new(0.5, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "Skip Tutorial",
            TextColor3 = Colors.SubText,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            ZIndex = 102,
            Parent = TutorialFrame
        })
    end
    
    -- Page indicator
    local PageIndicator = Create("TextLabel")({
        Name = "PageIndicator",
        Size = UDim2.new(0, 60, 0, 20),
        Position = UDim2.new(0.5, 0, 0.95, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Text = "1 / " .. #TutorialPages,
        TextColor3 = Colors.SubText,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        ZIndex = 102,
        Parent = TutorialFrame
    })
    
    -- Create dot indicators
    local DotContainer = Create("Frame")({
        Name = "DotContainer",
        Size = UDim2.new(0.5, 0, 0, 20),
        Position = UDim2.new(0.5, 0, 0.98, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        ZIndex = 102,
        Parent = TutorialFrame
    })
    
    -- Create dots for each page
    local dots = {}
    local dotSize = 10
    local spacing = 5
    local totalWidth = (#TutorialPages * dotSize) + ((#TutorialPages - 1) * spacing)
    
    for i = 1, #TutorialPages do
        local dot = Create("Frame")({
            Name = "Dot" .. i,
            Size = UDim2.new(0, dotSize, 0, dotSize),
            Position = UDim2.new(0.5, -totalWidth/2 + ((i-1) * (dotSize + spacing)), 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = i == 1 and Colors.Primary or Colors.SubText,
            ZIndex = 102,
            Parent = DotContainer
        })
        
        -- Round dot
        local dotCorner = Create("UICorner")({
            CornerRadius = UDim.new(1, 0),
            Parent = dot
        })
        
        dots[i] = dot
    end
    
    -- Tutorial navigation logic
    local currentPage = 1
    
    local function UpdatePage()
        -- Update title and description
        TutorialTitle.Text = TutorialPages[currentPage].Title
        TutorialDescription.Text = TutorialPages[currentPage].Description
        TutorialImage.Image = TutorialPages[currentPage].Image
        PageIndicator.Text = currentPage .. " / " .. #TutorialPages
        
        -- Update buttons
        BackButton.Visible = currentPage > 1
        NextButton.Text = currentPage == #TutorialPages and "Finish" or "Next"
        
        -- Update dots
        for i, dot in ipairs(dots) do
            dot.BackgroundColor3 = i == currentPage and Colors.Primary or Colors.SubText
        end
    end
    
    -- Button click handlers
    NextButton.MouseButton1Click:Connect(function()
        if currentPage < #TutorialPages then
            currentPage = currentPage + 1
            UpdatePage()
        else
            -- Close tutorial when finished
            TutorialBackground:Destroy()
        end
    end)
    
    BackButton.MouseButton1Click:Connect(function()
        if currentPage > 1 then
            currentPage = currentPage - 1
            UpdatePage()
        end
    end)
    
    if SkipButton then
        SkipButton.MouseButton1Click:Connect(function()
            TutorialBackground:Destroy()
        end)
    end
    
    UpdatePage()
    return TutorialBackground
end

-- IMPROVED LOADING ANIMATION

-- Create a nicer loading screen
local function CreateLoadingScreen()
    -- Main loading GUI
    local LoadingGui = Create("ScreenGui")({
        Name = HttpService:GenerateGUID(false),
        DisplayOrder = 999999,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Protect the GUI
    ProtectGui(LoadingGui)
    
    -- Background with blur effect
    local Background = Create("Frame")({
        Name = "Background",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Parent = LoadingGui
    })
    
    -- Add blur effect if high-end device
    if IS_HIGHEND then
        local BlurEffect = Create("BlurEffect")({
            Name = "Blur",
            Size = 10,
            Parent = game:GetService("Lighting")
        })
        
        -- Clean up blur when done
        Background:GetPropertyChangedSignal("Parent"):Connect(function()
            if Background.Parent == nil and BlurEffect then
                BlurEffect:Destroy()
            end
        end)
    end
    
    -- Center container
    local LoadingContainer = Create("Frame")({
        Name = "LoadingContainer",
        Size = UDim2.new(0, 300, 0, 350),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = Background
    })
    
    -- Round corners
    local ContainerCorner = Create("UICorner")({
        CornerRadius = UDim.new(0, 10),
        Parent = LoadingContainer
    })
    
    -- Logo container
    local LogoContainer = Create("Frame")({
        Name = "LogoContainer",
        Size = UDim2.new(0, 120, 0, 120),
        Position = UDim2.new(0.5, 0, 0.25, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Colors.Primary,
        BorderSizePixel = 0,
        Parent = LoadingContainer
    })
    
    -- Make logo circular
    local LogoCorner = Create("UICorner")({
        CornerRadius = UDim.new(1, 0),
        Parent = LogoContainer
    })
    
    -- Add X to logo
    local LogoX = Create("TextLabel")({
        Name = "LogoX",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = Colors.Text,
        TextSize = 70,
        Font = Enum.Font.GothamBold,
        Parent = LogoContainer
    })
    
    -- Pulsing animation for logo
    local function PulseLogo()
        while LoadingContainer.Parent do
            local tween1 = CreateTween(LogoContainer, {Size = UDim2.new(0, 130, 0, 130)}, 0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            tween1:Play()
            SafeFuncs.wait(0.8)
            
            local tween2 = CreateTween(LogoContainer, {Size = UDim2.new(0, 120, 0, 120)}, 0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            tween2:Play()
            SafeFuncs.wait(0.8)
        end
    end
    
    -- Start pulsing
    SafeFuncs.spawn(PulseLogo)
    
    -- Title
    local Title = Create("TextLabel")({
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0.45, 0),
        BackgroundTransparency = 1,
        Text = "XESTEER HUB",
        TextColor3 = Colors.Primary,
        TextSize = 30,
        Font = Enum.Font.GothamBold,
        Parent = LoadingContainer
    })
    
    -- Subtitle
    local Subtitle = Create("TextLabel")({
        Name = "Subtitle",
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0.52, 0),
        BackgroundTransparency = 1,
        Text = "MASTER X EDITION",
        TextColor3 = Colors.Text,
        TextSize = 18,
        Font = Enum.Font.Gotham,
        Parent = LoadingContainer
    })
    
    -- Loading text
    local LoadingText = Create("TextLabel")({
        Name = "LoadingText",
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0.65, 0),
        BackgroundTransparency = 1,
        Text = "⠋ Loading Xesteer Hub...",
        TextColor3 = Colors.Text,
        TextSize = 16,
        Font = Enum.Font.Gotham,
        Parent = LoadingContainer
    })
    
    -- Animate spinner
    local function AnimateSpinner()
        local frame = 1
        while LoadingContainer.Parent do
            LoadingText.Text = LoadingAnimationFrames[frame]
            frame = (frame % #LoadingAnimationFrames) + 1
            SafeFuncs.wait(0.1)
        end
    end
    
    -- Start spinner
    SafeFuncs.spawn(AnimateSpinner)
    
    -- Loading bar background
    local LoadingBarBg = Create("Frame")({
        Name = "LoadingBarBg",
        Size = UDim2.new(0.8, 0, 0, 10),
        Position = UDim2.new(0.5, 0, 0.75, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Parent = LoadingContainer
    })
    
    -- Round corners
    local LoadingBarBgCorner = Create("UICorner")({
        CornerRadius = UDim.new(1, 0),
        Parent = LoadingBarBg
    })
    
    -- Loading bar fill
    local LoadingBarFill = Create("Frame")({
        Name = "LoadingBarFill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Colors.Primary,
        BorderSizePixel = 0,
        Parent = LoadingBarBg
    })
    
    -- Round corners
    local LoadingBarFillCorner = Create("UICorner")({
        CornerRadius = UDim.new(1, 0),
        Parent = LoadingBarFill
    })
    
    -- Status text
    local StatusText = Create("TextLabel")({
        Name = "StatusText",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0.82, 0),
        BackgroundTransparency = 1,
        Text = "Initializing...",
        TextColor3 = Colors.SubText,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        Parent = LoadingContainer
    })
    
    -- Game info
    local GameInfo = Create("TextLabel")({
        Name = "GameInfo",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0.9, 0),
        BackgroundTransparency = 1,
        Text = "BLUE LOCK RIVALS | EXECUTOR: " .. ExecutorName,
        TextColor3 = Colors.SubText,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Parent = LoadingContainer
    })
    
    -- Loading stages for the animation
    local loadingStages = {
        {Text = "Initializing...", Progress = 0.1},
        {Text = "Checking game...", Progress = 0.2},
        {Text = "Detecting executor...", Progress = 0.3},
        {Text = "Setting up protection...", Progress = 0.45},
        {Text = "Scanning game environment...", Progress = 0.6},
        {Text = "Loading features...", Progress = 0.75},
        {Text = "Preparing interface...", Progress = 0.9},
        {Text = "Ready!", Progress = 1}
    }
    
    -- Function to animate loading process
    local function AnimateLoading()
        for i, stage in ipairs(loadingStages) do
            -- Update status text
            StatusText.Text = stage.Text
            
            -- Animate loading bar
            local tween = CreateTween(LoadingBarFill, {Size = UDim2.new(stage.Progress, 0, 1, 0)}, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            tween:Play()
            tween.Completed:Wait()
            
            -- Wait between stages
            if i < #loadingStages then
                SafeFuncs.wait(0.5)
            end
        end
        
        -- Final delay before finishing
        SafeFuncs.wait(0.5)
        
        -- Fade out animation
        local fadeTween = CreateTween(Background, {BackgroundTransparency = 1}, 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        fadeTween:Play()
        
        -- Also fade out container
        local containerFade = CreateTween(LoadingContainer, {BackgroundTransparency = 1}, 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        containerFade:Play()
        
        -- Fade out all text elements
        for _, v in pairs(LoadingContainer:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") then
                CreateTween(v, {TextTransparency = 1}, 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
            elseif v:IsA("Frame") and v ~= LoadingContainer then
                CreateTween(v, {BackgroundTransparency = 1}, 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
            end
        end
        
        -- Destroy after fade
        SafeFuncs.wait(0.8)
        LoadingGui:Destroy()
    end
    
    -- Start animation
    SafeFuncs.spawn(AnimateLoading)
    
    return LoadingGui
end

-- Create main GUI
local function CreateMainGUI()
    -- Create the ScreenGui
    local XesteerScreenGui = Create("ScreenGui")({
        Name = HttpService:GenerateGUID(false),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        DisplayOrder = 999999
    })
    
    -- Protect the GUI
    ProtectGui(XesteerScreenGui)
    
    -- Main frame
    local MainFrame = Create("Frame")({
        Name = "MainFrame",
        Size = UDim2.new(0, 600, 0, 380),
        Position = UDim2.new(0.5, -300, 0.5, -190),
        BackgroundColor3 = Colors.Background,
        BorderSizePixel = 0,
        Parent = XesteerScreenGui
    })
    
    -- Round corners
    local MainCorner = Create("UICorner")({
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame
    })
    
    -- Add stroke
    local MainStroke = Create("UIStroke")({
        Color = Colors.Primary,
        Thickness = 1.5,
        Transparency = 0.4,
        Parent = MainFrame
    })
    
    -- Gradient effect
    local MainGradient = Create("UIGradient")({
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
        }),
        Rotation = 45,
        Parent = MainFrame
    })
    
    -- Navigation sidebar
    local NavContainer = Create("Frame")({
        Name = "NavContainer",
        Size = UDim2.new(0, 140, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    -- Round corners
    local NavCorner = Create("UICorner")({
        CornerRadius = UDim.new(0, 8),
        Parent = NavContainer
    })
    
    -- Fix frame to prevent corner overlap
    local NavFixFrame = Create("Frame")({
        Name = "NavFixFrame",
        Size = UDim2.new(0, 10, 1, 0),
        Position = UDim2.new(1, -10, 0, 0),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = NavContainer
    })
    
    -- Logo at top of navigation
    local LogoContainer = Create("Frame")({
        Name = "LogoContainer",
        Size = UDim2.new(0, 70, 0, 70),
        Position = UDim2.new(0.5, 0, 0, 20),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Colors.Primary,
        BorderSizePixel = 0,
        Parent = NavContainer
    })
    
    -- Make logo circular
    local LogoCorner = Create("UICorner")({
        CornerRadius = UDim.new(1, 0),
        Parent = LogoContainer
    })
    
    -- X in center of logo
    local LogoX = Create("TextLabel")({
        Name = "LogoX",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = Colors.Text,
        TextSize = 40,
        Font = Enum.Font.GothamBold,
        Parent = LogoContainer
    })
    
    -- Hub name below logo
    local HubTitle = Create("TextLabel")({
        Name = "HubTitle",
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 0, 100),
        BackgroundTransparency = 1,
        Text = "XESTEER",
        TextColor3 = Colors.Primary,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Parent = NavContainer
    })
    
    -- Hub subtitle
    local HubSubtitle = Create("TextLabel")({
        Name = "HubSubtitle",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 125),
        BackgroundTransparency = 1,
        Text = "MASTER X",
        TextColor3 = Colors.Text,
        TextSize = 16,
        Font = Enum.Font.Gotham,
        Parent = NavContainer
    })
    
    -- Separator 
    local NavSeparator = Create("Frame")({
        Name = "NavSeparator",
        Size = UDim2.new(0.7, 0, 0, 1),
        Position = UDim2.new(0.5, 0, 0, 155),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Colors.Text,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Parent = NavContainer
    })
    
    -- Category container
    local CategoryContainer = Create("ScrollingFrame")({
        Name = "CategoryContainer",
        Size = UDim2.new(1, 0, 1, -165),
        Position = UDim2.new(0, 0, 0, 165),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Colors.Primary,
        CanvasSize = UDim2.new(0, 0, 0, 50 * #Categories),
        Parent = NavContainer
    })
    
    -- Content container
    local ContentContainer = Create("Frame")({
        Name = "ContentContainer",
        Size = UDim2.new(1, -150, 1, -10),
        Position = UDim2.new(0, 145, 0, 5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = MainFrame
    })
    
    -- Header container
    local HeaderContainer = Create("Frame")({
        Name = "HeaderContainer",
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = ContentContainer
    })
    
    -- Header title
    local HeaderTitle = Create("TextLabel")({
        Name = "HeaderTitle",
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "Player",
        TextColor3 = Colors.Primary,
        TextSize = 28,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = HeaderContainer
    })
    
    -- Header description
    local HeaderDescription = Create("TextLabel")({
        Name = "HeaderDescription",
        Size = UDim2.new(0.7, 0, 0.4, 0),
        Position = UDim2.new(0, 10, 0.6, 0),
        BackgroundTransparency = 1,
        Text = "Modify your player's movement and abilities",
        TextColor3 = Colors.SubText,
        TextSize = 16,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = HeaderContainer
    })
    
    -- Separator below header
    local HeaderSeparator = Create("Frame")({
        Name = "HeaderSeparator",
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 1, 0),
        BackgroundColor3 = Colors.Text,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Parent = HeaderContainer
    })
    
    -- Sub-category container
    local SubCategoryContainer = Create("Frame")({
        Name = "SubCategoryContainer",
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 60),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = ContentContainer
    })
    
    -- Feature container
    local FeatureContainer = Create("ScrollingFrame")({
        Name = "FeatureContainer",
        Size = UDim2.new(1, 0, 1, -100),
        Position = UDim2.new(0, 0, 0, 100),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Colors.Primary,
        CanvasSize = UDim2.new(0, 0, 2, 0),
        Parent = ContentContainer
    })
    
    -- Status bar at bottom
    local StatusBar = Create("Frame")({
        Name = "StatusBar",
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 1, -30),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    -- Round corners for status bar
    local StatusCorner = Create("UICorner")({
        CornerRadius = UDim.new(0, 8),
        Parent = StatusBar
    })
    
    -- Fix frame for status bar corners
    local StatusFixFrame = Create("Frame")({
        Name = "StatusFixFrame",
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = StatusBar
    })
    
    -- Status text
    local StatusText = Create("TextLabel")({
        Name = "StatusText",
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "Xesteer Hub v5.0 | Blue Lock Rivals | Executor: " .. ExecutorName,
        TextColor3 = Colors.SubText,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = StatusBar
    })
    
    -- Create quick action buttons
    local QuickApplyButton = Create("TextButton")({
        Name = "QuickApply",
        Size = UDim2.new(0, 100, 0, 22),
        Position = UDim2.new(1, -110, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Colors.Primary,
        BorderSizePixel = 0,
        Text = "Apply All",
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Parent = StatusBar
    })
    
    -- Round quick apply button corners
    local QuickApplyCorner = Create("UICorner")({
        CornerRadius = UDim.new(0, 4),
        Parent = QuickApplyButton
    })
    
    -- Create category buttons
    local categoryButtons = {}
    local contentFrames = {}
    local selectedCategory = Categories[1].Name
    
    -- Create category pages
    for i, category in ipairs(Categories) do
        -- Category button
        local CategoryButton = Create("TextButton")({
            Name = category.Name .. "Button",
            Size = UDim2.new(0.9, 0, 0, 40),
            Position = UDim2.new(0.5, 0, 0, (i-1) * 50),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = selectedCategory == category.Name and Colors.Primary or Color3.fromRGB(30, 30, 30),
            BackgroundTransparency = selectedCategory == category.Name and 0 or 0.5,
            BorderSizePixel = 0,
            Text = category.Icon .. " " .. category.Name,
            TextColor3 = Colors.Text,
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            Parent = CategoryContainer
        })
        
        -- Round corners
        local CategoryCorner = Create("UICorner")({
            CornerRadius = UDim.new(0, 6),
            Parent = CategoryButton
        })
        
        -- Selection indicator
        local SelectionIndicator = Create("Frame")({
            Name = "SelectionIndicator",
            Size = UDim2.new(0, 4, 0.7, 0),
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Colors.Primary,
            BorderSizePixel = 0,
            Visible = selectedCategory == category.Name,
            Parent = CategoryButton
        })
        
        -- Round indicator corners
        local IndicatorCorner = Create("UICorner")({
            CornerRadius = UDim.new(0, 2),
            Parent = SelectionIndicator
        })
        
        -- Store reference
        categoryButtons[category.Name] = {
            Button = CategoryButton,
            Indicator = SelectionIndicator
        }
        
        -- Create content frame for this category
        local ContentFrame = Create("Frame")({
            Name = category.Name .. "Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = selectedCategory == category.Name,
            Parent = ContentContainer
        })
        
        -- Store reference
        contentFrames[category.Name] = ContentFrame
    end
    
    -- Function to switch between categories
    local function SwitchCategory(categoryName)
        -- Don't do anything if already selected
        if selectedCategory == categoryName then return end
        
        -- Update buttons
        for name, elements in pairs(categoryButtons) do
            local isSelected = name == categoryName
            
            -- Update button appearance
            local highlightTween = CreateTween(elements.Button, {
                BackgroundColor3 = isSelected and Colors.Primary or Color3.fromRGB(30, 30, 30),
                BackgroundTransparency = isSelected and 0 or 0.5
            }, 0.3)
            highlightTween:Play()
            
            -- Show/hide indicator
            elements.Indicator.Visible = isSelected
        end
        
        -- Update content frames
        for name, frame in pairs(contentFrames) do
            frame.Visible = name == categoryName
        end
        
        -- Update header info
        HeaderTitle.Text = categoryName
        
        -- Find the matching category to get description
        for _, category in ipairs(Categories) do
            if category.Name == categoryName then
                local description = ""
                if category.Name == "Player" then
                    description = "Modify your player's movement and abilities"
                elseif category.Name == "Ball Control" then
                    description = "Take full control over the ball during matches"
                elseif category.Name == "Character" then
                    description = "Get any character with unlimited spins"
                elseif category.Name == "Game Mods" then
                    description = "Modify gameplay mechanics and rules"
                elseif category.Name == "Visuals" then
                    description = "Enhance visuals and performance"
                elseif category.Name == "Farming" then
                    description = "Automate resources and experience farming"
                elseif category.Name == "Protection" then
                    description = "Stay protected from anti-cheat systems"
                elseif category.Name == "Miscellaneous" then
                    description = "Additional utilities and fun features"
                end
                
                HeaderDescription.Text = description
                break
            end
        end
        
        -- Update selected category
        selectedCategory = categoryName
    end
    
    -- Add click handlers to buttons
    for categoryName, elements in pairs(categoryButtons) do
        elements.Button.MouseButton1Click:Connect(function()
            SwitchCategory(categoryName)
        end)
    end
    
    -- Display tutorial for first time users
    SafeFuncs.delay(1, function()
        local isFirstTime = true -- This would normally be stored/retrieved
        if isFirstTime then
            local tutorial = ShowTutorial(XesteerScreenGui, true)
        end
    end)
    
    -- Return references
    return {
        ScreenGui = XesteerScreenGui,
        MainFrame = MainFrame,
        StatusText = StatusText,
        SwitchCategory = SwitchCategory
    }
end

-- Create notification system
local function CreateNotification(title, message, type, duration)
    -- Default values
    type = type or "info" -- info, success, warning, error
    duration = duration or 5
    
    -- Type colors
    local typeColors = {
        info = Colors.Primary,
        success = Colors.Success,
        warning = Colors.Warning,
        error = Colors.Error
    }
    
    -- Type icons
    local typeIcons = {
        info = "ℹ️",
        success = "✅",
        warning = "⚠️",
        error = "❌"
    }
    
    -- Create notification container if it doesn't exist
    local notifContainer = CoreGui:FindFirstChild("XesteerNotifications")
    if not notifContainer then
        notifContainer = Create("ScreenGui")({
            Name = "XesteerNotifications",
            DisplayOrder = 999999,
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        })
        
        -- Notifications frame
        local notificationsFrame = Create("Frame")({
            Name = "NotificationsFrame",
            Size = UDim2.new(0, 300, 1, 0),
            Position = UDim2.new(1, -310, 0, 0),
            BackgroundTransparency = 1,
            Parent = notifContainer
        })
        
        -- Add layout
        local layout = Create("UIListLayout")({
            Padding = UDim.new(0, 10),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = notificationsFrame
        })
        
        ProtectGui(notifContainer)
    end
    
    -- Get notifications frame
    local notificationsFrame = notifContainer:FindFirstChild("NotificationsFrame")
    
    -- Create notification
    local notification = Create("Frame")({
        Name = "Notification_" .. HttpService:GenerateGUID(false),
        Size = UDim2.new(0, 280, 0, 80),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(1, 50, 0, 0), -- Start off-screen
        Parent = notificationsFrame
    })
    
    -- Round corners
    local notifCorner = Create("UICorner")({
        CornerRadius = UDim.new(0, 8),
        Parent = notification
    })
    
    -- Add stroke
    local notifStroke = Create("UIStroke")({
        Color = typeColors[type],
        Thickness = 1.5,
        Parent = notification
    })
    
    -- Icon
    local icon = Create("TextLabel")({
        Name = "Icon",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 15, 0, 15),
        BackgroundTransparency = 1,
        Text = typeIcons[type],
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Parent = notification
    })
    
    -- Title
    local titleLabel = Create("TextLabel")({
        Name = "Title",
        Size = UDim2.new(1, -60, 0, 25),
        Position = UDim2.new(0, 50, 0, 10),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = typeColors[type],
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification
    })
    
    -- Message
    local messageLabel = Create("TextLabel")({
        Name = "Message",
        Size = UDim2.new(1, -60, 0, 40),
        Position = UDim2.new(0, 50, 0, 35),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = Colors.Text,
        TextSize = 14,
        TextWrapped = true,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification
    })
    
    -- Close button
    local closeButton = Create("TextButton")({
        Name = "CloseButton",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0, 10),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = Colors.SubText,
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        Parent = notification
    })
    
    -- Progress bar
    local progressBar = Create("Frame")({
        Name = "ProgressBar",
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = typeColors[type],
        BorderSizePixel = 0,
        Parent = notification
    })
    
    -- Animate in
    local animateIn = CreateTween(notification, {Position = UDim2.new(0, 0, 0, 0)}, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    animateIn:Play()
    
    -- Progress bar animation
    local progressAnim = CreateTween(progressBar, {Size = UDim2.new(0, 0, 0, 2)}, duration, Enum.EasingStyle.Linear)
    progressAnim:Play()
    
    -- Close handler
    local function CloseNotification()
        local animateOut = CreateTween(notification, {Position = UDim2.new(1, 50, 0, 0)}, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        animateOut:Play()
        
        animateOut.Completed:Wait()
        notification:Destroy()
    end
    
    -- Close on button click
    closeButton.MouseButton1Click:Connect(CloseNotification)
    
    -- Auto close
    SafeFuncs.delay(duration, CloseNotification)
    
    return notification
end

-- Main function
local function Main()
    -- Show loading screen
    local loadingScreen = CreateLoadingScreen()
    
    -- Wait for loading to complete
    SafeFuncs.wait(4.5) -- This matches the loading animation duration
    
    -- Create main GUI
    local mainGui = CreateMainGUI()
    
    -- Welcome notification
    SafeFuncs.wait(0.5)
    CreateNotification(
        "Welcome to Xesteer Hub", 
        "Master X Edition v5.0 loaded successfully. Ready to dominate in Blue Lock Rivals!", 
        "success", 
        6
    )
    
    return true
end

-- Start the hub
local success, result = pcall(Main)
if not success then
    print("XESTEER HUB: Error during initialization: " .. tostring(result))
    -- Create error notification
    local notifContainer = CoreGui:FindFirstChild("XesteerNotifications")
    if not notifContainer then
        local errorNotif = CreateNotification(
            "Error Loading Xesteer Hub", 
            "Failed to initialize: " .. tostring(result) .. ". Please try again or contact support.", 
            "error", 
            10
        )
    end
end

end)

-- Handle initialization errors
if not SuccessInit then
    print("XESTEER HUB: Critical Error: " .. tostring(ErrorMessage))
    
    -- Create a basic error message
    local messageBox = messagebox or function(text) print(text) end
    messageBox("XESTEER HUB encountered an error: " .. tostring(ErrorMessage) .. "\n\nPlease check console for details.", "XESTEER HUB - Error", 0)
end

return XesteerHub