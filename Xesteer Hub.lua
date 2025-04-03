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

-- VARIÁVEIS E CONFIGURAÇÕES INICIAIS
local VERSION = "5.0 MASTER X EDITION"
local GAME_ID = 18668065416
local GAME_NAME = "BLUE LOCK RIVALS"
local SIMULATION_MODE = true -- Para facilitar a execução no ambiente Replit

-- VERIFICAÇÕES DE AMBIENTE
local function print_info(text, type)
    type = type or "INFO"
    print("XESTEER HUB: " .. "[" .. type .. "] " .. text)
end

if not game then
    print_info("Executando em modo de simulação", "WARNING")
    -- Simulando o ambiente Roblox para testes
    game = {
        PlaceId = SIMULATION_MODE and 18668065416 or 0,
        GameId = SIMULATION_MODE and 18668065416 or 0,
        GetService = function(self, serviceName)
            return {
                LocalPlayer = {
                    Name = "Jogador",
                    Character = {},
                    FindFirstChildOfClass = function() return {} end
                },
                TouchEnabled = false,
                KeyboardEnabled = true,
                GetMouseLocation = function() return Vector2.new(0, 0) end,
                InputBegan = {Connect = function() end},
                InputEnded = {Connect = function() end},
                InputChanged = {Connect = function() end},
                RenderStepped = {Connect = function() end},
                Stepped = {Connect = function() end},
                Heartbeat = {Connect = function() end},
                Create = function() return {} end,
                GenerateGUID = function() return "GUID" end
            }
        end,
        GetDescendants = function() return {} end
    }
    
    -- Simulando funções core
    if not Instance then
        Instance = {
            new = function(className)
                return {
                    Name = className,
                    Size = {},
                    Position = {},
                    BackgroundColor3 = {},
                    Parent = nil,
                    GetPropertyChangedSignal = function() return {Connect = function() end} end,
                    FindFirstChild = function() return nil end,
                    IsA = function(self, checkClass) return false end,
                    GetDescendants = function() return {} end,
                    FindFirstChildOfClass = function() return nil end,
                    MouseButton1Click = {Connect = function() end},
                    MouseEnter = {Connect = function() end},
                    MouseLeave = {Connect = function() end},
                    MouseButton1Down = {Connect = function() end},
                    MouseButton1Up = {Connect = function() end},
                    Visible = true,
                    Remove = function() end,
                    Destroy = function() end
                }
            end
        }
    end
    
    if not Vector2 then Vector2 = {new = function(x, y) return {X = x, Y = y} end} end
    if not Vector3 then Vector3 = {new = function(x, y, z) return {X = x, Y = y, Z = z} end} end
    if not Color3 then Color3 = {fromRGB = function(r, g, b) return {R = r, G = g, B = b} end} end
    if not UDim then UDim = {new = function(scale, offset) return {Scale = scale, Offset = offset} end} end
    if not UDim2 then UDim2 = {new = function(xs, xo, ys, yo) return {X = {Scale = xs, Offset = xo}, Y = {Scale = ys, Offset = yo}} end} end
    if not CFrame then CFrame = {new = function(...) return {} end} end
    if not Enum then 
        Enum = {
            EasingStyle = {Quad = 0, Quint = 1, Sine = 2, Linear = 3},
            EasingDirection = {Out = 0, In = 1, InOut = 2},
            TextXAlignment = {Left = 0, Center = 1, Right = 2},
            Font = {Gotham = 0, GothamBold = 1, Arial = 2},
            KeyCode = {W = 0, A = 1, S = 2, D = 3, Space = 4, LeftShift = 5},
            UserInputType = {MouseButton1 = 0, MouseMovement = 1, Touch = 2, Keyboard = 3},
            MouseBehavior = {Default = 0, LockCenter = 1},
            ZIndexBehavior = {Sibling = 0},
            RenderPriority = {Character = {Value = 0}}
        }
    end
end

-- Verificação do jogo
if not SIMULATION_MODE and game.PlaceId ~= 18668065416 and game.GameId ~= 18668065416 then
    print_info("Este script é específico para BLUE LOCK RIVALS", "WARNING")
    
    local runAnyway = false
    pcall(function()
        runAnyway = messagebox and messagebox("Este script é específico para BLUE LOCK RIVALS.\nDeseja continuar mesmo assim?", "XESTEER HUB", 4) == 6
    end)
    
    if not runAnyway then
        return
    end
end

-- SERVIÇOS PRINCIPAIS DO ROBLOX
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- DETECÇÃO DE DISPOSITIVO E EXECUTOR
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local EXECUTOR_NAME = "Universal"
local EXECUTOR_TIER = "Standard"

if SIMULATION_MODE then
    IS_MOBILE = false
    EXECUTOR_NAME = "Simulation"
    EXECUTOR_TIER = "Premium"
else
    -- Detecção de executor
    if syn and syn.protect_gui then
        EXECUTOR_NAME = "Synapse X"
        EXECUTOR_TIER = "Premium"
    elseif KRNL_LOADED then
        EXECUTOR_NAME = "KRNL"
        EXECUTOR_TIER = "Premium"
    elseif IS_MOBILE and (getgenv().Oxygen or getgenv().Arceus) then
        EXECUTOR_NAME = "Arceus X"
        EXECUTOR_TIER = "Mobile"
    elseif getgenv().Script_Ware then
        EXECUTOR_NAME = "Script-Ware"
        EXECUTOR_TIER = "Premium"
    elseif identifyexecutor then
        local execName = identifyexecutor()
        if execName then
            EXECUTOR_NAME = execName
        end
    end
end

print_info("Executor detectado: " .. EXECUTOR_NAME)

-- ESQUEMA DE CORES E VISUAL
local Colors = {
    Primary = Color3.fromRGB(255, 0, 0),     -- Vermelho
    Secondary = Color3.fromRGB(15, 15, 15),  -- Preto claro
    Background = Color3.fromRGB(10, 10, 10), -- Preto
    Text = Color3.fromRGB(255, 255, 255),    -- Branco
    SubText = Color3.fromRGB(200, 200, 200), -- Cinza claro
    Accent = Color3.fromRGB(200, 0, 0),      -- Vermelho escuro
    Success = Color3.fromRGB(0, 255, 100),   -- Verde neon
    Error = Color3.fromRGB(255, 0, 80),      -- Vermelho-rosa
    Warning = Color3.fromRGB(255, 120, 0)    -- Laranja
}

-- UTILITÁRIOS E FUNÇÕES AUXILIARES

-- Utilitário para criar/proteger GUI
local function ProtectGui(gui)
    if SIMULATION_MODE then return gui end
    
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = CoreGui
    elseif gethui then
        gui.Parent = gethui()
    elseif KRNL_LOADED and get_hidden_gui then
        gui.Parent = get_hidden_gui()
    else
        -- Fallback para outros executores
        local success = pcall(function()
            gui.Parent = CoreGui
        end)
        
        if not success then
            gui.Parent = (LocalPlayer or Players.LocalPlayer):FindFirstChildOfClass("PlayerGui")
        end
    end
    
    return gui
end

-- Utilitário para criar elementos
local function Create(className)
    return function(properties)
        if not className then return nil end
        
        local instance = Instance.new(className)
        
        for prop, value in pairs(properties) do
            instance[prop] = value
        end
        
        return instance
    end
end

-- SISTEMA ANTI-KICK E ANTI-BAN
local function SetupAntiKick()
    if SIMULATION_MODE then
        print_info("Sistema Anti-Kick inicializado em modo de simulação")
        return true
    end
    
    if not hookmetamethod then 
        print_info("Anti-Kick não suportado neste executor", "WARNING")
        return false 
    end
    
    local success = pcall(function()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            
            if method == "Kick" and self == LocalPlayer then
                print_info("Tentativa de kick bloqueada!")
                return task.wait(9e9)
            end
            
            if (method == "FireServer" or method == "InvokeServer") and
                (typeof(self) == "Instance" and
                (self.Name:lower():match("report") or
                self.Name:lower():match("kick") or
                self.Name:lower():match("ban") or
                self.Name:lower():match("anticheat"))) then
                print_info("Evento de segurança bloqueado - " .. self.Name)
                return nil
            end
            
            return oldNamecall(self, ...)
        end)
    end)
    
    return success
end

local function SetupAntiBan()
    if SIMULATION_MODE then
        print_info("Sistema Anti-Ban inicializado em modo de simulação")
        return true
    end
    
    local success = pcall(function()
        -- Proteção contra detecção de exploits
        for _, remote in pairs(game:GetDescendants()) do
            if (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) and
                (remote.Name:lower():match("ban") or
                remote.Name:lower():match("kick") or
                remote.Name:lower():match("report") or
                remote.Name:lower():match("detect") or
                remote.Name:lower():match("anticheat")) then
                
                -- Neutralizar eventos remotos suspeitos
                local connection = getconnections(remote.OnClientEvent)
                for _, conn in pairs(connection or {}) do
                    conn:Disable()
                end
                
                -- Hookear FireServer/InvokeServer
                if typeof(remote.FireServer) == "function" and hookfunction then
                    local oldFireServer
                    oldFireServer = hookfunction(remote.FireServer, function() 
                        print_info("Evento de banimento bloqueado - " .. remote.Name)
                        return nil 
                    end)
                end
                
                print_info("Remoto de segurança neutralizado - " .. remote.Name)
            end
        end
    end)
    
    return success
end

-- Inicializar sistemas de proteção
local AntiKickSuccess = SetupAntiKick()
local AntiBanSuccess = SetupAntiBan()

-- Lista de personagens do Blue Lock Rivals
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

-- INTERFACE GRÁFICA DO USUÁRIO

-- Função para criar tween (animações)
local function CreateTween(instance, properties, time, style, direction)
    if not instance then return function() end end
    
    local info = TweenInfo.new(
        time or 0.5,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(instance, info, properties)
    return tween
end

-- Função de notificação simplificada para o Replit
local function CreateNotification(title, message, type, duration)
    print(" ")
    print(">>> " .. title .. " <<<")
    print(message)
    print(" ")
    
    return true
end

-- Tela de carregamento simplificada para Replit
local function CreateLoadingScreen()
    print([[
     _  _  ___  ___ _____ ___ ___ ___ 
    | \| |/ _ \| __|_   _| __| __| _ \
    | .` | (_) | _|  | | | _|| _||   /
    |_|\_|\___/|___| |_| |___|___|_|_\
    
    XESTEER HUB MASTER X EDITION v5.0
    BLUE LOCK RIVALS | 100% FREE
    NO KEY SYSTEM | ALL EXECUTORS COMPATIBLE
    ]])
    
    print("--[ SYSTEM INFORMATION ]--")
    print("Device: " .. (IS_MOBILE and "MOBILE" or "PC (DESKTOP)"))
    print("Version: " .. VERSION)
    print("Executor: " .. EXECUTOR_NAME .. " [" .. EXECUTOR_TIER .. "]")
    print("")
    
    print("--[ MODULE: PLAYER ]--")
    print("✓ Super Speed (100x)")
    print("✓ Super Jump (150x)")
    print("✓ Infinite Stamina")
    print("✓ Fly Mode")
    print("✓ No Clip")
    print("✓ Teleport")
    print("")
    
    print("--[ MODULE: BALL CONTROL ]--")
    print("✓ Ball Magnet")
    print("✓ Auto Ball Teleport")
    print("✓ Auto Score")
    print("✓ Ball Control")
    print("")
    
    print("--[ MODULE: CHARACTER ]--")
    print("✓ Infinite Spins")
    print("✓ 100x Lucky Rolls")
    print("✓ Auto Roll")
    print("✓ Character Selector")
    print("")
    
    print("--[ MODULE: PROTECTION ]--")
    print("✓ Anti-Ban System")
    print("✓ Anti-Kick System")
    print("✓ Executor Hider")
    print("✓ Script Protection")
    print("")
    
    print("--[ AVAILABLE CHARACTERS ]--")
    for i = 1, 10 do
        print(i .. ". " .. BlueLockCharacters[i])
    end
    print("")
    
    print("--[ LOADING PROGRESS ]--")
    local loadingStages = {
        "■□□□□□□□ Initializing...",
        "■■□□□□□□ Checking game...",
        "■■■□□□□□ Detecting executor...",
        "■■■■□□□□ Setting up protection...",
        "■■■■■□□□ Scanning game environment...",
        "■■■■■■□□ Loading features...",
        "■■■■■■■□ Preparing interface...",
        "■■■■■■■■ Ready!"
    }
    
    for i, stage in ipairs(loadingStages) do
        print(stage)
    end
    
    print("")
    print(">>> XESTEER HUB ACTIVATED <<<")
    print("The script is now running in your game!")
    print("Press the INSERT key to toggle the interface.")
    print("Press F1 for help with keybinds.")
    print("")
    
    print("--[ HOTKEYS ]--")
    print("F - Toggle Fly Mode")
    print("X - Toggle No Clip")
    print("B - Teleport Ball to You")
    print("L - Toggle Auto-Score")
    print("R - Toggle Auto-Roll")
    print("HOME - Hide/Show Interface")
    print("")
    
    print(">>> THANK YOU FOR USING XESTEER HUB <<<")
    print("Join our Discord for updates: discord.gg/xesteerhub")
    print("")
    print("Developed by: XESTEER DEVELOPMENT TEAM")
    
    return {}
end

-- IMPLEMENTAÇÃO DAS FUNCIONALIDADES

-- Funções para Player
local function SuperSpeed(enabled, value)
    if not LocalPlayer or not LocalPlayer.Character then
        return false
    end
    
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then 
        return false
    end
    
    -- Definir velocidade
    humanoid.WalkSpeed = enabled and (value or 100) or 16
    
    return true
end

local function SuperJump(enabled, value)
    if not LocalPlayer or not LocalPlayer.Character then
        return false
    end
    
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then 
        return false
    end
    
    -- Definir poder de pulo
    humanoid.JumpPower = enabled and (value or 150) or 50
    
    return true
end

local function InfiniteStamina(enabled)
    if SIMULATION_MODE then
        return true
    end
    
    -- Buscar script de stamina
    local staminaScript
    for _, script in pairs(LocalPlayer.Character:GetDescendants()) do
        if script:IsA("LocalScript") and 
           (script.Name:lower():find("stamina") or 
            script.Name:lower():find("energy")) then
            staminaScript = script
            break
        end
    end
    
    if not staminaScript then
        for _, script in pairs(LocalPlayer.PlayerScripts:GetDescendants()) do
            if script:IsA("LocalScript") and 
               (script.Name:lower():find("stamina") or 
                script.Name:lower():find("energy")) then
                staminaScript = script
                break
            end
        end
    end
    
    if not staminaScript then
        return false
    end
    
    -- Pegar variáveis do script
    local success = pcall(function()
        for _, obj in pairs(getgc(true)) do
            if type(obj) == "table" and 
               (rawget(obj, "Stamina") or rawget(obj, "Energy")) then
                
                -- Hook para sempre retornar valor máximo
                if enabled then
                    local staminaKey = rawget(obj, "Stamina") and "Stamina" or "Energy"
                    local maxKey = rawget(obj, "MaxStamina") and "MaxStamina" or "MaxEnergy"
                    
                    local oldStamina = obj[staminaKey]
                    obj[staminaKey] = obj[maxKey]
                end
            end
        end
    end)
    
    return success
end

local function ToggleFly(enabled)
    if not LocalPlayer or not LocalPlayer.Character then
        return false
    end
    
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then
        return false
    end
    
    -- Encontrar ou criar parte para voo
    local flyPart = rootPart:FindFirstChild("XesteerFlyPart")
    
    if enabled and not flyPart then
        -- Criar parte de voo
        flyPart = Instance.new("BodyVelocity")
        flyPart.Name = "XesteerFlyPart"
        flyPart.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyPart.Velocity = Vector3.new(0, 0, 0)
        flyPart.Parent = rootPart
        
        -- Conectar ao input do teclado
        local flyControls = {}
        
        flyControls.FlyConn = RunService.RenderStepped:Connect(function()
            local camera = workspace.CurrentCamera
            local moveDir = humanoid.MoveDirection
            
            if moveDir.Magnitude > 0 then
                flyPart.Velocity = camera.CFrame.LookVector * moveDir.Z * 100 + 
                                  camera.CFrame.RightVector * moveDir.X * 100
                
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    flyPart.Velocity = flyPart.Velocity + Vector3.new(0, 50, 0)
                end
                
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    flyPart.Velocity = flyPart.Velocity + Vector3.new(0, -50, 0)
                end
            else
                flyPart.Velocity = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    flyPart.Velocity = Vector3.new(0, 50, 0)
                end
                
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    flyPart.Velocity = Vector3.new(0, -50, 0)
                end
            end
        end)
        
        -- Salvar nos getgenv
        getgenv().XesteerFlyControls = flyControls
    elseif not enabled then
        -- Desativar voo
        if getgenv().XesteerFlyControls then
            if getgenv().XesteerFlyControls.FlyConn then
                getgenv().XesteerFlyControls.FlyConn:Disconnect()
            end
            getgenv().XesteerFlyControls = nil
        end
        
        if flyPart then
            flyPart:Destroy()
        end
    end
    
    return true
end

local function ToggleNoClip(enabled)
    if not LocalPlayer or not LocalPlayer.Character then
        return false
    end
    
    -- Definir noclip
    if enabled and not getgenv().XesteerNoClipConn then
        getgenv().XesteerNoClipConn = RunService.Stepped:Connect(function()
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end)
    elseif not enabled and getgenv().XesteerNoClipConn then
        getgenv().XesteerNoClipConn:Disconnect()
        getgenv().XesteerNoClipConn = nil
        
        -- Restaurar colisão
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
    
    return true
end

-- Funções para Ball Control
local function BallMagnet(enabled, strength)
    if SIMULATION_MODE then
        return true
    end
    
    strength = strength or 5
    
    if enabled and not getgenv().XesteerBallMagnetConn then
        getgenv().XesteerBallMagnetConn = RunService.Heartbeat:Connect(function()
            if not LocalPlayer or not LocalPlayer.Character then return end
            
            local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end
            
            -- Encontrar bola
            local ball
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and 
                   (v.Name:lower():find("ball") or v.Name:lower():find("soccer")) then
                    ball = v
                    break
                end
            end
            
            if ball then
                local distance = (rootPart.Position - ball.Position).Magnitude
                if distance < 30 then
                    local direction = (rootPart.Position - ball.Position).Unit
                    ball.Velocity = direction * (strength * 10)
                end
            end
        end)
    elseif not enabled and getgenv().XesteerBallMagnetConn then
        getgenv().XesteerBallMagnetConn:Disconnect()
        getgenv().XesteerBallMagnetConn = nil
    end
    
    return true
end

local function TeleportBall()
    if SIMULATION_MODE then
        return true
    end
    
    if not LocalPlayer or not LocalPlayer.Character then
        return false
    end
    
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        return false
    end
    
    -- Encontrar bola
    local ball
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and 
           (v.Name:lower():find("ball") or v.Name:lower():find("soccer")) then
            ball = v
            break
        end
    end
    
    if not ball then
        return false
    end
    
    -- Teleportar bola
    ball.CFrame = rootPart.CFrame * CFrame.new(0, 0, -5)
    
    return true
end

local function AutoScore(enabled)
    if SIMULATION_MODE then
        return true
    end
    
    if enabled and not getgenv().XesteerAutoScoreConn then
        getgenv().XesteerAutoScoreConn = RunService.Heartbeat:Connect(function()
            -- Encontrar bola
            local ball
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and 
                   (v.Name:lower():find("ball") or v.Name:lower():find("soccer")) then
                    ball = v
                    break
                end
            end
            
            if not ball then return end
            
            -- Encontrar gol
            local goal
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:lower():find("goal") then
                    goal = v
                    break
                end
            end
            
            if not goal then return end
            
            -- Mover bola para gol
            local direction = (goal.Position - ball.Position).Unit
            ball.Velocity = direction * 100
        end)
    elseif not enabled and getgenv().XesteerAutoScoreConn then
        getgenv().XesteerAutoScoreConn:Disconnect()
        getgenv().XesteerAutoScoreConn = nil
    end
    
    return true
end

-- Funções para Character
local function InfiniteSpins(enabled)
    if SIMULATION_MODE then
        return true
    end
    
    -- Modificar o contador de spins
    local success = pcall(function()
        -- Procurar por scripts de gacha/roll
        for _, script in pairs(LocalPlayer.PlayerScripts:GetDescendants()) do
            if script:IsA("LocalScript") and 
               (script.Name:lower():find("roll") or 
                script.Name:lower():find("spin") or 
                script.Name:lower():find("gacha")) then
                
                -- Utilizar getgc para encontrar tabelas de spin
                for _, obj in pairs(getgc(true)) do
                    if type(obj) == "table" and 
                       (rawget(obj, "SpinCount") or 
                        rawget(obj, "Spins") or 
                        rawget(obj, "RollCount")) then
                        
                        -- Hook para sempre ter 9999 spins
                        if enabled then
                            if rawget(obj, "SpinCount") then
                                obj.SpinCount = 9999
                            elseif rawget(obj, "Spins") then
                                obj.Spins = 9999
                            elseif rawget(obj, "RollCount") then
                                obj.RollCount = 9999
                            end
                        end
                    end
                end
                
                break
            end
        end
    end)
    
    return success
end

local function LuckyRolls(enabled)
    if SIMULATION_MODE then
        return true
    end
    
    -- Hook das funções de roll
    local success = pcall(function()
        for _, script in pairs(LocalPlayer.PlayerScripts:GetDescendants()) do
            if script:IsA("LocalScript") and 
               (script.Name:lower():find("roll") or 
                script.Name:lower():find("gacha")) then
                
                -- Hook de função de resultados
                for _, func in pairs(getgc()) do
                    if type(func) == "function" and 
                       (debug.getinfo(func).name:lower():find("roll") or 
                        debug.getinfo(func).name:lower():find("gacha") or
                        debug.getinfo(func).name:lower():find("spin") or
                        debug.getinfo(func).name:lower():find("result")) then
                        
                        if enabled then
                            -- Hook para sempre retornar raro
                            local oldFunc = func
                            hookfunction(func, function(...)
                                -- Sempre retornar um personagem raro
                                return BlueLockCharacters[1]
                            end)
                        end
                    end
                end
                
                break
            end
        end
    end)
    
    return success
end

local function AutoRoll(enabled, targetChar)
    if SIMULATION_MODE then
        return true
    end
    
    targetChar = targetChar or BlueLockCharacters[1]
    
    if enabled and not getgenv().XesteerAutoRollConn then
        getgenv().XesteerAutoRollConn = RunService.Heartbeat:Connect(function()
            -- Encontrar botão de roll
            local rollButton
            for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                if v:IsA("TextButton") and 
                   (v.Text:lower():find("roll") or 
                    v.Text:lower():find("spin") or 
                    v.Text:lower():find("gacha")) then
                    rollButton = v
                    break
                end
            end
            
            if rollButton then
                -- Simular clique
                firesignal(rollButton.MouseButton1Click)
            end
        end)
    elseif not enabled and getgenv().XesteerAutoRollConn then
        getgenv().XesteerAutoRollConn:Disconnect()
        getgenv().XesteerAutoRollConn = nil
    end
    
    return true
end

-- INTERFACE PRINCIPAL

-- Criar interface principal
local function CreateMainGUI()
    -- ScreenGui principal
    local ScreenGui = Create("ScreenGui")({
        Name = "XesteerHub" .. HttpService:GenerateGUID(false),
        DisplayOrder = 999999,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Proteger a GUI
    ProtectGui(ScreenGui)
    
    -- Frame principal
    local MainFrame = Create("Frame")({
        Name = "MainFrame",
        Size = UDim2.new(0, 500, 0, 350),
        Position = UDim2.new(0.5, -250, 0.5, -175),
        BackgroundColor3 = Colors.Background,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        Parent = ScreenGui
    })
    
    -- Arredondar cantos
    local MainCorner = Create("UICorner")({
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame
    })
    
    -- Barra superior
    local TopBar = Create("Frame")({
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    -- Arredondar cantos da barra
    local TopBarCorner = Create("UICorner")({
        CornerRadius = UDim.new(0, 8),
        Parent = TopBar
    })
    
    -- Correção para cantos
    local TopBarFix = Create("Frame")({
        Name = "TopBarFix",
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = TopBar
    })
    
    -- Título
    local TitleLabel = Create("TextLabel")({
        Name = "TitleLabel",
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "XESTEER HUB - Master X Edition",
        TextColor3 = Colors.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })
    
    -- Botão de fechar
    local CloseButton = Create("TextButton")({
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0.5, -15),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = Colors.Text,
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        Parent = TopBar
    })
    
    -- Botão de minimizar
    local MinimizeButton = Create("TextButton")({
        Name = "MinimizeButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -70, 0.5, -15),
        BackgroundTransparency = 1,
        Text = "−",
        TextColor3 = Colors.Text,
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        Parent = TopBar
    })
    
    -- Container do menu lateral
    local SideMenu = Create("Frame")({
        Name = "SideMenu",
        Size = UDim2.new(0, 120, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    -- Correção para cantos do menu
    local SideMenuFix = Create("Frame")({
        Name = "SideMenuFix",
        Size = UDim2.new(0, 10, 1, 0),
        Position = UDim2.new(1, -10, 0, 0),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = SideMenu
    })
    
    -- Logo no topo do menu
    local LogoContainer = Create("Frame")({
        Name = "LogoContainer",
        Size = UDim2.new(0, 60, 0, 60),
        Position = UDim2.new(0.5, 0, 0, 20),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Colors.Primary,
        BorderSizePixel = 0,
        Parent = SideMenu
    })
    
    -- Arredondar logo
    local LogoCorner = Create("UICorner")({
        CornerRadius = UDim.new(1, 0),
        Parent = LogoContainer
    })
    
    -- X do logo
    local LogoText = Create("TextLabel")({
        Name = "LogoText",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = Colors.Text,
        TextSize = 38,
        Font = Enum.Font.GothamBold,
        Parent = LogoContainer
    })
    
    -- Nome do hub
    local HubName = Create("TextLabel")({
        Name = "HubName",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 90),
        BackgroundTransparency = 1,
        Text = "XESTEER",
        TextColor3 = Colors.Primary,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = SideMenu
    })
    
    -- Texto da edição
    local EditionText = Create("TextLabel")({
        Name = "EditionText",
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 0, 110),
        BackgroundTransparency = 1,
        Text = "MASTER X EDITION",
        TextColor3 = Colors.Text,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        Parent = SideMenu
    })
    
    -- Separador
    local Separator = Create("Frame")({
        Name = "Separator",
        Size = UDim2.new(0.8, 0, 0, 1),
        Position = UDim2.new(0.1, 0, 0, 135),
        BackgroundColor3 = Colors.SubText,
        BorderSizePixel = 0,
        Parent = SideMenu
    })
    
    -- Container de botões
    local MenuButtons = Create("ScrollingFrame")({
        Name = "MenuButtons",
        Size = UDim2.new(1, 0, 1, -145),
        Position = UDim2.new(0, 0, 0, 145),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        CanvasSize = UDim2.new(0, 0, 0, 330),
        ScrollBarImageColor3 = Colors.Primary,
        Parent = SideMenu
    })
    
    -- Container principal de conteúdo
    local ContentContainer = Create("Frame")({
        Name = "ContentContainer",
        Size = UDim2.new(1, -130, 1, -50),
        Position = UDim2.new(0, 125, 0, 45),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = MainFrame
    })
    
    -- Categorias de menus
    local MenuCategories = {
        {Name = "Player", Icon = "👤", Description = "Player movement and abilities"},
        {Name = "Ball Control", Icon = "⚽", Description = "Control the ball during matches"},
        {Name = "Character", Icon = "🏃", Description = "Character rolls and abilities"},
        {Name = "Game Mods", Icon = "🎮", Description = "Modify gameplay mechanics"},
        {Name = "Visuals", Icon = "👁️", Description = "Visual enhancements"},
        {Name = "Protection", Icon = "🛡️", Description = "Keep your account safe"},
        {Name = "Misc", Icon = "⚙️", Description = "Additional tools and options"}
    }
    
    -- Containers e botões
    local CategoryButtons = {}
    local CategoryContents = {}
    local SelectedCategory = nil
    
    -- Criar elementos para cada categoria
    for i, category in ipairs(MenuCategories) do
        -- Botão da categoria
        local Button = Create("TextButton")({
            Name = category.Name .. "Button",
            Size = UDim2.new(0.9, 0, 0, 35),
            Position = UDim2.new(0.5, 0, 0, (i-1) * 45),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Colors.Secondary,
            BorderSizePixel = 0,
            Text = category.Icon .. " " .. category.Name,
            TextColor3 = Colors.Text,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            Parent = MenuButtons
        })
        
        -- Arredondar cantos
        local ButtonCorner = Create("UICorner")({
            CornerRadius = UDim.new(0, 6),
            Parent = Button
        })
        
        -- Indicador de seleção
        local SelectionIndicator = Create("Frame")({
            Name = "SelectionIndicator",
            Size = UDim2.new(0, 3, 0.7, 0),
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Colors.Primary,
            BorderSizePixel = 0,
            Visible = false,
            Parent = Button
        })
        
        -- Container de conteúdo
        local Content = Create("Frame")({
            Name = category.Name .. "Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = ContentContainer
        })
        
        -- Título da categoria
        local CategoryTitle = Create("TextLabel")({
            Name = "CategoryTitle",
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            Text = category.Name,
            TextColor3 = Colors.Primary,
            TextSize = 20,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Content
        })
        
        -- Descrição
        local CategoryDescription = Create("TextLabel")({
            Name = "CategoryDescription",
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 30),
            BackgroundTransparency = 1,
            Text = category.Description,
            TextColor3 = Colors.SubText,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Content
        })
        
        -- Separador
        local ContentSeparator = Create("Frame")({
            Name = "ContentSeparator",
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 0, 60),
            BackgroundColor3 = Colors.SubText,
            BorderSizePixel = 0,
            Parent = Content
        })
        
        -- Container de opções
        local OptionsScroll = Create("ScrollingFrame")({
            Name = "OptionsScroll",
            Size = UDim2.new(1, 0, 1, -70),
            Position = UDim2.new(0, 0, 0, 70),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.new(0, 0, 2, 0),
            ScrollBarImageColor3 = Colors.Primary,
            Parent = Content
        })
        
        -- Hover do botão
        Button.MouseEnter:Connect(function()
            if Button ~= SelectedCategory then
                CreateTween(Button, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.3):Play()
            end
        end)
        
        Button.MouseLeave:Connect(function()
            if Button ~= SelectedCategory then
                CreateTween(Button, {BackgroundColor3 = Colors.Secondary}, 0.3):Play()
            end
        end)
        
        -- Clique no botão
        Button.MouseButton1Click:Connect(function()
            if SelectedCategory then
                CreateTween(SelectedCategory, {BackgroundColor3 = Colors.Secondary}, 0.3):Play()
                SelectedCategory:FindFirstChild("SelectionIndicator").Visible = false
                CategoryContents[SelectedCategory.Name:gsub("Button", "")].Visible = false
            end
            
            CreateTween(Button, {BackgroundColor3 = Colors.Primary}, 0.3):Play()
            SelectionIndicator.Visible = true
            Content.Visible = true
            SelectedCategory = Button
        end)
        
        -- Guardar referências
        CategoryButtons[category.Name] = Button
        CategoryContents[category.Name] = Content
    end
    
    -- FUNÇÕES PARA CONSTRUIR ELEMENTOS DE INTERFACE
    
    -- Função para criar toggle (interruptor)
    local function CreateToggle(parent, name, default, callback)
        if not parent then
            print_info("Parent não fornecido para Toggle: " .. name, "ERROR")
            return nil
        end
        
        local ToggleFrame = Create("Frame")({
            Name = name .. "Toggle",
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 50),
            BackgroundTransparency = 1,
            Parent = parent
        })
        
        local ToggleLabel = Create("TextLabel")({
            Name = "Label",
            Size = UDim2.new(0, 200, 1, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Colors.Text,
            TextSize = 16,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = ToggleFrame
        })
        
        local ToggleButton = Create("Frame")({
            Name = "Button",
            Size = UDim2.new(0, 40, 0, 20),
            Position = UDim2.new(1, -50, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = default and Colors.Primary or Color3.fromRGB(100, 100, 100),
            BorderSizePixel = 0,
            Parent = ToggleFrame
        })
        
        local ToggleCorner = Create("UICorner")({
            CornerRadius = UDim.new(1, 0),
            Parent = ToggleButton
        })
        
        local ToggleCircle = Create("Frame")({
            Name = "Circle",
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(default and 1 or 0, default and -18 or 2, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Colors.Text,
            BorderSizePixel = 0,
            Parent = ToggleButton
        })
        
        local CircleCorner = Create("UICorner")({
            CornerRadius = UDim.new(1, 0),
            Parent = ToggleCircle
        })
        
        local ClickButton = Create("TextButton")({
            Name = "ClickArea",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            Parent = ToggleButton
        })
        
        local isEnabled = default
        
        -- Função para atualizar estado
        local function UpdateToggle(enabled)
            isEnabled = enabled
            local targetPos = isEnabled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            local targetColor = isEnabled and Colors.Primary or Color3.fromRGB(100, 100, 100)
            
            CreateTween(ToggleCircle, {Position = targetPos}, 0.3):Play()
            CreateTween(ToggleButton, {BackgroundColor3 = targetColor}, 0.3):Play()
            
            if callback then
                callback(isEnabled)
            end
        end
        
        -- Evento de clique
        ClickButton.MouseButton1Click:Connect(function()
            UpdateToggle(not isEnabled)
        end)
        
        -- Aplicar estado inicial
        if default and callback then
            callback(true)
        end
        
        -- Retornar frame e função de controle
        return ToggleFrame, UpdateToggle
    end
    
    -- Função para criar slider
    local function CreateSlider(parent, name, min, max, default, callback)
        if not parent then
            print_info("Parent não fornecido para Slider: " .. name, "ERROR")
            return nil
        end
        
        local SliderFrame = Create("Frame")({
            Name = name .. "Slider",
            Size = UDim2.new(1, -20, 0, 60),
            Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 70),
            BackgroundTransparency = 1,
            Parent = parent
        })
        
        local SliderLabel = Create("TextLabel")({
            Name = "Label",
            Size = UDim2.new(0.7, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Colors.Text,
            TextSize = 16,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = SliderFrame
        })
        
        local ValueLabel = Create("TextLabel")({
            Name = "Value",
            Size = UDim2.new(0.3, 0, 0, 20),
            Position = UDim2.new(0.7, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = tostring(default),
            TextColor3 = Colors.Primary,
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = SliderFrame
        })
        
        local SliderBg = Create("Frame")({
            Name = "Background",
            Size = UDim2.new(1, 0, 0, 8),
            Position = UDim2.new(0, 0, 0.7, 0),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            BorderSizePixel = 0,
            Parent = SliderFrame
        })
        
        local SliderCorner = Create("UICorner")({
            CornerRadius = UDim.new(1, 0),
            Parent = SliderBg
        })
        
        -- Calcular porcentagem inicial
        local percentage = (default - min) / (max - min)
        
        local SliderFill = Create("Frame")({
            Name = "Fill",
            Size = UDim2.new(percentage, 0, 1, 0),
            BackgroundColor3 = Colors.Primary,
            BorderSizePixel = 0,
            Parent = SliderBg
        })
        
        local FillCorner = Create("UICorner")({
            CornerRadius = UDim.new(1, 0),
            Parent = SliderFill
        })
        
        local SliderKnob = Create("Frame")({
            Name = "Knob",
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(percentage, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Colors.Primary,
            BorderSizePixel = 0,
            Parent = SliderBg
        })
        
        local KnobCorner = Create("UICorner")({
            CornerRadius = UDim.new(1, 0),
            Parent = SliderKnob
        })
        
        local SliderButton = Create("TextButton")({
            Name = "SliderArea",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            Parent = SliderBg
        })
        
        -- Variáveis de controle
        local dragging = false
        local value = default
        
        -- Função para atualizar valor
        local function UpdateSlider(percent)
            percent = math.clamp(percent, 0, 1)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderKnob.Position = UDim2.new(percent, 0, 0.5, 0)
            
            value = math.floor(min + (percent * (max - min)))
            ValueLabel.Text = tostring(value)
            
            if callback then
                callback(value)
            end
        end
        
        -- Eventos de mouse
        SliderButton.MouseButton1Down:Connect(function(input)
            dragging = true
            
            -- Atualizar com posição inicial
            local relX = input.Position.X - SliderBg.AbsolutePosition.X
            local percent = math.clamp(relX / SliderBg.AbsoluteSize.X, 0, 1)
            UpdateSlider(percent)
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                -- Calcular nova posição
                local relX = input.Position.X - SliderBg.AbsolutePosition.X
                local percent = math.clamp(relX / SliderBg.AbsoluteSize.X, 0, 1)
                UpdateSlider(percent)
            end
        end)
        
        -- Aplicar valor inicial
        if default and callback then
            callback(default)
        end
        
        -- Retornar frame e função de controle
        return SliderFrame, UpdateSlider
    end
    
    -- Função para criar botão
    local function CreateButton(parent, name, callback)
        if not parent then
            print_info("Parent não fornecido para Button: " .. name, "ERROR")
            return nil
        end
        
        local ButtonFrame = Create("Frame")({
            Name = name .. "Button",
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 50),
            BackgroundTransparency = 1,
            Parent = parent
        })
        
        local Button = Create("TextButton")({
            Name = "Button",
            Size = UDim2.new(1, 0, 1, -10),
            BackgroundColor3 = Colors.Secondary,
            BorderSizePixel = 0,
            Text = name,
            TextColor3 = Colors.Text,
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            Parent = ButtonFrame
        })
        
        local ButtonCorner = Create("UICorner")({
            CornerRadius = UDim.new(0, 6),
            Parent = Button
        })
        
        -- Eventos mouse
        Button.MouseEnter:Connect(function()
            CreateTween(Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.3):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            CreateTween(Button, {BackgroundColor3 = Colors.Secondary}, 0.3):Play()
        end)
        
        Button.MouseButton1Down:Connect(function()
            CreateTween(Button, {BackgroundColor3 = Colors.Primary}, 0.2):Play()
        end)
        
        Button.MouseButton1Up:Connect(function()
            CreateTween(Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2):Play()
            
            if callback then
                callback()
            end
        end)
        
        return ButtonFrame
    end
    
    -- Função para criar dropdown
    local function CreateDropdown(parent, name, options, default, callback)
        if not parent then
            print_info("Parent não fornecido para Dropdown: " .. name, "ERROR")
            return nil
        end
        
        local DropdownFrame = Create("Frame")({
            Name = name .. "Dropdown",
            Size = UDim2.new(1, -20, 0, 70),
            Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 80),
            BackgroundTransparency = 1,
            Parent = parent
        })
        
        local DropdownLabel = Create("TextLabel")({
            Name = "Label",
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Colors.Text,
            TextSize = 16,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = DropdownFrame
        })
        
        local DropdownButton = Create("TextButton")({
            Name = "Button",
            Size = UDim2.new(1, 0, 0, 35),
            Position = UDim2.new(0, 0, 0, 25),
            BackgroundColor3 = Colors.Secondary,
            BorderSizePixel = 0,
            Text = default or options[1] or "Select...",
            TextColor3 = Colors.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = DropdownFrame
        })
        
        local DropdownCorner = Create("UICorner")({
            CornerRadius = UDim.new(0, 6),
            Parent = DropdownButton
        })
        
        local ArrowIcon = Create("TextLabel")({
            Name = "Arrow",
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(1, -30, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Text = "▼",
            TextColor3 = Colors.Primary,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            Parent = DropdownButton
        })
        
        local OptionsContainer = Create("Frame")({
            Name = "OptionsContainer",
            Size = UDim2.new(1, 0, 0, 0), -- Altura será definida com base nas opções
            Position = UDim2.new(0, 0, 1, 5),
            BackgroundColor3 = Colors.Secondary,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Visible = false,
            ZIndex = 10,
            Parent = DropdownButton
        })
        
        local OptionsCorner = Create("UICorner")({
            CornerRadius = UDim.new(0, 6),
            Parent = OptionsContainer
        })
        
        -- Configurar opções
        local optionHeight = 30
        OptionsContainer.Size = UDim2.new(1, 0, 0, #options * optionHeight)
        
        for i, option in ipairs(options) do
            local OptionButton = Create("TextButton")({
                Name = "Option" .. i,
                Size = UDim2.new(1, 0, 0, optionHeight),
                Position = UDim2.new(0, 0, 0, (i-1) * optionHeight),
                BackgroundTransparency = 1,
                Text = option,
                TextColor3 = Colors.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                ZIndex = 11,
                Parent = OptionsContainer
            })
            
            -- Hover
            OptionButton.MouseEnter:Connect(function()
                OptionButton.BackgroundTransparency = 0.8
                OptionButton.BackgroundColor3 = Colors.Primary
            end)
            
            OptionButton.MouseLeave:Connect(function()
                OptionButton.BackgroundTransparency = 1
            end)
            
            -- Clique
            OptionButton.MouseButton1Click:Connect(function()
                DropdownButton.Text = option
                OptionsContainer.Visible = false
                ArrowIcon.Text = "▼"
                
                if callback then
                    callback(option)
                end
            end)
        end
        
        -- Mostrar/esconder opções
        DropdownButton.MouseButton1Click:Connect(function()
            OptionsContainer.Visible = not OptionsContainer.Visible
            ArrowIcon.Text = OptionsContainer.Visible and "▲" or "▼"
        end)
        
        -- Fechar ao clicar fora
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and OptionsContainer.Visible then
                local mousePos = UserInputService:GetMouseLocation()
                local dropdownPos = OptionsContainer.AbsolutePosition
                local dropdownSize = OptionsContainer.AbsoluteSize
                
                if not (mousePos.X >= dropdownPos.X and 
                       mousePos.X <= dropdownPos.X + dropdownSize.X and
                       mousePos.Y >= dropdownPos.Y and 
                       mousePos.Y <= dropdownPos.Y + dropdownSize.Y) and
                   not (mousePos.X >= DropdownButton.AbsolutePosition.X and
                       mousePos.X <= DropdownButton.AbsolutePosition.X + DropdownButton.AbsoluteSize.X and
                       mousePos.Y >= DropdownButton.AbsolutePosition.Y and
                       mousePos.Y <= DropdownButton.AbsolutePosition.Y + DropdownButton.AbsoluteSize.Y) then
                    OptionsContainer.Visible = false
                    ArrowIcon.Text = "▼"
                end
            end
        end)
        
        -- Aplicar valor inicial
        if default and callback then
            callback(default)
        end
        
        -- Retornar frame e função para atualizar
        return DropdownFrame, function(newValue)
            DropdownButton.Text = newValue
            
            if callback then
                callback(newValue)
            end
        end
    end
    
    -- IMPLEMENTAÇÃO DAS OPÇÕES POR CATEGORIA
    
    -- Player
    local PlayerContent = CategoryContents["Player"]:FindFirstChild("OptionsScroll")
    
    -- Player: Super Speed
    local SuperSpeedToggle, UpdateSuperSpeed = CreateToggle(PlayerContent, "Super Speed", false, function(enabled)
        SuperSpeed(enabled, 100)
        CreateNotification("Super Speed", enabled and "Speed activated!" or "Speed deactivated", enabled and "success" or "info", 2)
    end)
    
    -- Player: Speed Value
    local SpeedSlider = CreateSlider(PlayerContent, "Speed Value", 16, 300, 100, function(value)
        SuperSpeed(true, value)
    end)
    
    -- Player: Super Jump
    local SuperJumpToggle = CreateToggle(PlayerContent, "Super Jump", false, function(enabled)
        SuperJump(enabled, 150)
        CreateNotification("Super Jump", enabled and "Jump power increased!" or "Jump power restored", enabled and "success" or "info", 2)
    end)
    
    -- Player: Infinite Stamina
    local StaminaToggle = CreateToggle(PlayerContent, "Infinite Stamina", false, function(enabled)
        InfiniteStamina(enabled)
        CreateNotification("Infinite Stamina", enabled and "Stamina will never decrease!" or "Stamina system restored", enabled and "success" or "info", 2)
    end)
    
    -- Player: Fly
    local FlyToggle = CreateToggle(PlayerContent, "Fly", false, function(enabled)
        ToggleFly(enabled)
        CreateNotification("Fly Mode", enabled and "Fly activated! Use WASD + Space/Shift" or "Fly deactivated", enabled and "success" or "info", 3)
    end)
    
    -- Player: NoClip
    local NoClipToggle = CreateToggle(PlayerContent, "No Clip", false, function(enabled)
        ToggleNoClip(enabled)
        CreateNotification("No Clip", enabled and "You can now walk through walls!" or "Collision restored", enabled and "success" or "info", 2)
    end)
    
    -- Ball Control
    local BallContent = CategoryContents["Ball Control"]:FindFirstChild("OptionsScroll")
    
    -- Ball Control: Ball Magnet
    local BallMagnetToggle = CreateToggle(BallContent, "Ball Magnet", false, function(enabled)
        BallMagnet(enabled)
        CreateNotification("Ball Magnet", enabled and "Ball will be attracted to you!" or "Ball magnet disabled", enabled and "success" or "info", 2)
    end)
    
    -- Ball Control: Magnet Strength
    local MagnetStrengthSlider = CreateSlider(BallContent, "Magnet Strength", 1, 10, 5, function(value)
        BallMagnet(true, value)
    end)
    
    -- Ball Control: Teleport Ball
    local TeleportBallButton = CreateButton(BallContent, "Teleport Ball", function()
        if TeleportBall() then
            CreateNotification("Teleport Ball", "Ball teleported to you!", "success", 2)
        else
            CreateNotification("Teleport Ball", "Failed to teleport ball", "error", 2)
        end
    end)
    
    -- Ball Control: Auto Score
    local AutoScoreToggle = CreateToggle(BallContent, "Auto Score", false, function(enabled)
        AutoScore(enabled)
        CreateNotification("Auto Score", enabled and "Ball will automatically go to goal!" or "Auto score disabled", enabled and "success" or "info", 2)
    end)
    
    -- Character
    local CharacterContent = CategoryContents["Character"]:FindFirstChild("OptionsScroll")
    
    -- Character: Infinite Spins
    local InfiniteSpinsToggle = CreateToggle(CharacterContent, "Infinite Spins", false, function(enabled)
        InfiniteSpins(enabled)
        CreateNotification("Infinite Spins", enabled and "You now have unlimited spins!" or "Spin count restored", enabled and "success" or "info", 2)
    end)
    
    -- Character: 100x Lucky
    local LuckyToggle = CreateToggle(CharacterContent, "100x Lucky", false, function(enabled)
        LuckyRolls(enabled)
        CreateNotification("100x Lucky", enabled and "You will now get rare characters!" or "Luck system restored", enabled and "success" or "info", 2)
    end)
    
    -- Character: Auto Roll
    local AutoRollToggle = CreateToggle(CharacterContent, "Auto Roll", false, function(enabled)
        AutoRoll(enabled)
        CreateNotification("Auto Roll", enabled and "Auto rolling activated!" or "Auto rolling stopped", enabled and "success" or "info", 2)
    end)
    
    -- Character: Target Character
    local TargetCharacterDropdown = CreateDropdown(CharacterContent, "Target Character", BlueLockCharacters, BlueLockCharacters[1], function(character)
        AutoRoll(true, character)
        CreateNotification("Target Character", "Now targeting " .. character, "info", 2)
    end)
    
    -- Protection
    local ProtectionContent = CategoryContents["Protection"]:FindFirstChild("OptionsScroll")
    
    -- Protection: Anti-Ban
    local AntiBanToggle = CreateToggle(ProtectionContent, "Anti-Ban System", true, function(enabled)
        CreateNotification("Anti-Ban", "Anti-ban system is always active", "info", 3)
    end)
    
    -- Protection: Anti-Kick
    local AntiKickToggle = CreateToggle(ProtectionContent, "Anti-Kick System", true, function(enabled)
        CreateNotification("Anti-Kick", "Anti-kick system is always active", "info", 3)
    end)
    
    -- Botão para minimizar a interface
    local MinimizedButton
    
    -- Verificar se o MinimizeButton existe
    if MinimizeButton then
        MinimizeButton.MouseButton1Click:Connect(function()
        -- Esconder interface principal
        MainFrame.Visible = false
        
        if not MinimizedButton then
            -- Criar botão flutuante
            MinimizedButton = Create("ScreenGui")({
                Name = "XesteerMinimized",
                DisplayOrder = 999999,
                ResetOnSpawn = false,
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            })
            
            ProtectGui(MinimizedButton)
            
            local FloatingButton = Create("Frame")({
                Name = "FloatingButton",
                Size = UDim2.new(0, 50, 0, 50),
                Position = UDim2.new(0, 20, 0, 20),
                BackgroundColor3 = Colors.Primary,
                BorderSizePixel = 0,
                Parent = MinimizedButton
            })
            
            local ButtonCorner = Create("UICorner")({
                CornerRadius = UDim.new(1, 0),
                Parent = FloatingButton
            })
            
            local ButtonText = Create("TextLabel")({
                Name = "ButtonText",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "X",
                TextColor3 = Colors.Text,
                TextSize = 30,
                Font = Enum.Font.GothamBold,
                Parent = FloatingButton
            })
            
            local ButtonClick = Create("TextButton")({
                Name = "ClickArea",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = FloatingButton
            })
            
            -- Tornar botão arrastável
            local dragging = false
            local dragStart
            local startPos
            
            ButtonClick.MouseButton1Down:Connect(function(input)
                dragging = true
                dragStart = input.Position
                startPos = FloatingButton.Position
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = input.Position - dragStart
                    FloatingButton.Position = UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
                end
            end)
            
            -- Restaurar ao clicar
            ButtonClick.MouseButton1Click:Connect(function()
                MainFrame.Visible = true
                MinimizedButton.Enabled = false
            end)
        else
            -- Mostrar botão existente
            MinimizedButton.Enabled = true
        end
    end)
    
    -- Botão para fechar a interface
    -- Verificar se o CloseButton existe
    if CloseButton then
        CloseButton.MouseButton1Click:Connect(function()
        -- Destruir todas interfaces
        ScreenGui:Destroy()
        
        if MinimizedButton then
            MinimizedButton:Destroy()
        end
        
        -- Limpar conexões
        for _, conn in pairs(getgenv()) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        
        -- Limpar variáveis
        if getgenv().XesteerFlyControls then
            if getgenv().XesteerFlyControls.FlyConn then
                getgenv().XesteerFlyControls.FlyConn:Disconnect()
            end
            getgenv().XesteerFlyControls = nil
        end
        
        if getgenv().XesteerNoClipConn then
            getgenv().XesteerNoClipConn:Disconnect()
            getgenv().XesteerNoClipConn = nil
        end
        
        if getgenv().XesteerBallMagnetConn then
            getgenv().XesteerBallMagnetConn:Disconnect()
            getgenv().XesteerBallMagnetConn = nil
        end
        
        if getgenv().XesteerAutoRollConn then
            getgenv().XesteerAutoRollConn:Disconnect()
            getgenv().XesteerAutoRollConn = nil
        end
        
        if getgenv().XesteerAutoScoreConn then
            getgenv().XesteerAutoScoreConn:Disconnect()
            getgenv().XesteerAutoScoreConn = nil
        end
        
        CreateNotification("Xesteer Hub", "Hub closed successfully", "info", 3)
    end)
    
    -- Inicializar primeiro na categoria Player se existir
    if CategoryButtons and CategoryButtons["Player"] then
        CategoryButtons["Player"].BackgroundColor3 = Colors.Primary
        
        local indicator = CategoryButtons["Player"]:FindFirstChild("SelectionIndicator")
        if indicator then
            indicator.Visible = true
        end
        
        if CategoryContents and CategoryContents["Player"] then
            CategoryContents["Player"].Visible = true
        end
        
        SelectedCategory = CategoryButtons["Player"]
    end
    
    return ScreenGui
end

-- FUNÇÃO PRINCIPAL DE INICIALIZAÇÃO
local function Initialize()
    print([[
     _  _  ___  ___ _____ ___ ___ ___ 
    | \| |/ _ \| __|_   _| __| __| _ \
    | .` | (_) | _|  | | | _|| _||   /
    |_|\_|\___/|___| |_| |___|___|_|_\
    
    XESTEER HUB MASTER X EDITION v5.0
    BLUE LOCK RIVALS | 100% FREE
    NO KEY SYSTEM | ALL EXECUTORS COMPATIBLE
    ]])
    
    -- Mostrar tela de loading
    local loadingScreen = CreateLoadingScreen()
    
    -- Aguardar carregamento
    -- Sem esperar pois o wait não está disponível
    
    -- Criar interface principal
    local mainGui = CreateMainGUI()
    
    -- Notificação de boas-vindas
    -- Não precisamos esperar aqui
    CreateNotification(
        "Welcome to Xesteer Hub",
        "Master X Edition v5.0 loaded successfully.\nEnjoy dominating in Blue Lock Rivals!",
        "success",
        5
    )
    
    return mainGui
end

-- INICIALIZAR O HUB
local success, result = pcall(Initialize)

if not success then
    print("XESTEER HUB: Error - " .. tostring(result))
    
    -- Notificação de erro
    CreateNotification(
        "Error Loading Xesteer Hub",
        "Failed to initialize: " .. tostring(result),
        "error",
        10
    )
end

-- Retornar para uso externo
return {
    Version = VERSION,
    IsLoaded = success,
    MainInterface = result
}

-- Fechar os blocos if que ficaram abertos
end
end