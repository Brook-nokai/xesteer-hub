--[[
   ██╗  ██╗███████╗███████╗████████╗███████╗███████╗██████╗ 
   ╚██╗██╔╝██╔════╝██╔════╝╚══██╔══╝██╔════╝██╔════╝██╔══██╗
    ╚███╔╝ █████╗  ███████╗   ██║   █████╗  █████╗  ██████╔╝
    ██╔██╗ ██╔══╝  ╚════██║   ██║   ██╔══╝  ██╔══╝  ██╔══██╗
   ██╔╝ ██╗███████╗███████║   ██║   ███████╗███████╗██║  ██║
   ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   ╚══════╝╚══════╝╚═╝  ╚═╝
                                                             
   BLUE LOCK RIVALS - SCRIPT HUB NOKIA EDITION v5.0
   DESENVOLVIDO POR: XESTEER DEVELOPMENT
   Sem Key | Totalmente Gratuito | Compatível com qualquer executor
]]--

-- * CONFIGURAÇÃO SEGURA E PROTEÇÃO CONTRA ERROS

-- Verifica se estamos rodando em um ambiente Roblox válido
if not game then
    warn("XESTEER HUB: Ambiente Roblox não detectado. Script abortado.")
    return
end

-- Configuração de proteção contra erros
local success, errorMsg
local function safeExecute(func, ...)
    success, errorMsg = pcall(func, ...)
    if not success then
        warn("XESTEER HUB: Erro detectado - " .. tostring(errorMsg))
        return false
    end
    return true
end

-- Detecção de jogo correto
local isCorrectGame = game.PlaceId == 18668065416 or game.GameId == 18668065416
if not isCorrectGame then
    warn("XESTEER HUB: Este script é específico para BLUE LOCK RIVALS. ID do jogo atual: " .. tostring(game.PlaceId))
    
    -- Pergunta ao usuário se deseja continuar mesmo em jogo diferente
    local userChoice = messagebox and messagebox("Este script é específico para BLUE LOCK RIVALS.\nDeseja continuar mesmo assim?", "XESTEER HUB", 4) or 6
    if userChoice ~= 6 then
        return
    end
end

-- * CONFIGURAÇÃO DE VARIÁVEIS GLOBAIS E SERVIÇOS

-- Cache de serviços para performance
local services = {}
local function getService(serviceName)
    if services[serviceName] then return services[serviceName] end
    
    local success, service = pcall(function() return game:GetService(serviceName) end)
    if success then
        services[serviceName] = service
        return service
    else
        warn("XESTEER HUB: Falha ao carregar serviço " .. serviceName)
        return nil
    end
end

-- Serviços principais
local Players = getService("Players")
local ReplicatedStorage = getService("ReplicatedStorage")
local UserInputService = getService("UserInputService")
local RunService = getService("RunService")
local TweenService = getService("TweenService")
local HttpService = getService("HttpService")
local CoreGui = getService("CoreGui")
local Lighting = getService("Lighting")

-- Detecção de função wait() alternativa para ambientes diferente
local wait = task and task.wait or wait
local spawn = task and task.spawn or spawn

-- Detecção de dispositivo
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local IS_NOKIA_MODE = IS_MOBILE or (getgenv and getgenv().FORCE_NOKIA_MODE)

-- Tabela de configurações salvas
local saveSettings = {}

-- * DETECÇÃO DE EXECUTOR
local executorDetected = "Unknown"
local execChecks = {
    ["Synapse X"] = function() return syn and syn.protect_gui end,
    ["Krnl"] = function() return KRNL_LOADED end,
    ["Script-Ware"] = function() return identifyexecutor and identifyexecutor() == "Script-Ware" end,
    ["Fluxus"] = function() return fluxus and fluxus.request end,
    ["Oxygen U"] = function() return pebc_execute end,
    ["JJSploit"] = function() return jjsploit end,
    ["Electron"] = function() return IS_ELECTRON end,
    ["Temple"] = function() return temple and temple.Shared end,
    ["Arceus X"] = function() return Arceus and Arceus.GetExecutorName end,
    ["Hydrogen"] = function() return Hydrogen and Hydrogen.Shared end
}

local function detectExecutor()
    local detectedExec = "Universal"
    
    for name, checkFunc in pairs(execChecks) do
        local success, result = pcall(checkFunc)
        if success and result then
            detectedExec = name
            break
        end
    end
    
    -- Fallback para função executorName se disponível
    if identifyexecutor and detectedExec == "Universal" then
        local success, execName = pcall(identifyexecutor)
        if success and execName and type(execName) == "string" then
            detectedExec = execName
        end
    end
    
    return detectedExec
end

executorDetected = detectExecutor()

-- * FUNÇÕES DE PROTEÇÃO

-- Sistema Anti-Kick
local originalNamecall
originalNamecall = hookmetamethod and hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod and getnamecallmethod() or ""
    local args = {...}
    
    if (self == Players.LocalPlayer and (method == "Kick" or method == "kick")) then
        return wait(9e9) -- Bloqueia o kick
    end
    
    return originalNamecall(self, ...)
end)

-- Sistema Anti-Ban (basico)
local function setupAntiBan()
    if not getService("ReplicatedStorage") then return false end
    
    -- Monitora novas adições ao ReplicatedStorage que possam ser sistemas de banimento
    local connection
    connection = getService("ReplicatedStorage").ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") and (
            child.Name:lower():find("ban") or 
            child.Name:lower():find("kick") or 
            child.Name:lower():find("security") or
            child.Name:lower():find("violation")
        ) then
            -- Desativa a função de evento
            wait()
            if typeof(child.FireServer) == "function" then
                local oldFire = child.FireServer
                child.FireServer = function() return nil end 
            end
            
            warn("XESTEER HUB: Sistema Anti-Ban bloqueou interação com " .. child.Name)
        end
    end)
    
    return true
end

safeExecute(setupAntiBan)

-- * FUNÇÕES DE INTERFACE GRÁFICA

-- Instanciador protegido de elementos UI
local function Create(instanceType)
    local instance = nil
    success, instance = pcall(function() return Instance.new(instanceType) end)
    
    if not success or not instance then
        warn("XESTEER HUB: Falha ao criar instância " .. instanceType)
        return nil
    end
    
    return instance
end

-- Proteção específica para ScreenGui (diferente por executor)
local function protectGui(gui)
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = CoreGui
    elseif gethui and typeof(gethui) == "function" then
        gui.Parent = gethui()
    elseif KRNL_LOADED and getgenv().protect_gui then
        getgenv().protect_gui(gui)
        gui.Parent = CoreGui
    else
        -- Fallback para outros executores
        local success, result = pcall(function()
            gui.Parent = CoreGui
            return true
        end)
        
        if not success then
            gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        end
    end
end

-- Cores principais da interface
local Colors = {
    Primary = Color3.fromRGB(255, 0, 0),      -- Vermelho
    Secondary = Color3.fromRGB(20, 20, 20),   -- Preto
    Background = Color3.fromRGB(0, 0, 0),     -- Preto
    Text = Color3.fromRGB(255, 255, 255),     -- Branco
    Highlight = Color3.fromRGB(200, 0, 0),    -- Vermelho mais escuro
    Success = Color3.fromRGB(0, 200, 0),      -- Verde
    Error = Color3.fromRGB(200, 0, 0),        -- Vermelho
    Disabled = Color3.fromRGB(100, 100, 100)  -- Cinza
}

-- Criação do ScreenGui principal
local function createMainGUI()
    local MainGui = Create("ScreenGui")
    if not MainGui then return nil end
    
    MainGui.Name = HttpService:GenerateGUID(false)
    MainGui.ResetOnSpawn = false
    MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainGui.DisplayOrder = 999999999
    
    -- Proteção da GUI
    protectGui(MainGui)
    
    return MainGui
end

-- Criação de contêiner principal
local function createMainContainer(parent)
    local Container = Create("Frame")
    if not Container then return nil end
    
    Container.Name = "MainContainer"
    Container.Size = UDim2.new(0, 500, 0, 350)
    Container.Position = UDim2.new(0.5, -250, 0.5, -175)
    Container.BackgroundColor3 = Colors.Background
    Container.BorderSizePixel = 0
    Container.Parent = parent
    
    -- Adicionar cantos arredondados
    local UICorner = Create("UICorner")
    if UICorner then
        UICorner.CornerRadius = UDim.new(0, 10)
        UICorner.Parent = Container
    end
    
    -- Adicionar barra superior
    local TopBar = Create("Frame")
    if TopBar then
        TopBar.Name = "TopBar"
        TopBar.Size = UDim2.new(1, 0, 0, 40)
        TopBar.BackgroundColor3 = Colors.Primary
        TopBar.BorderSizePixel = 0
        TopBar.Parent = Container
        
        -- Cantos arredondados para a barra superior
        local UICorner2 = Create("UICorner")
        if UICorner2 then
            UICorner2.CornerRadius = UDim.new(0, 10)
            UICorner2.Parent = TopBar
        end
        
        -- Ajuste para cantos arredondados apenas em cima
        local BottomCover = Create("Frame")
        if BottomCover then
            BottomCover.Name = "BottomCover"
            BottomCover.Size = UDim2.new(1, 0, 0.5, 0)
            BottomCover.Position = UDim2.new(0, 0, 0.5, 0)
            BottomCover.BackgroundColor3 = Colors.Primary
            BottomCover.BorderSizePixel = 0
            BottomCover.Parent = TopBar
        end
    end
    
    -- Adicionar conteúdo da barra superior
    if TopBar then
        -- Título
        local Title = Create("TextLabel")
        if Title then
            Title.Name = "Title"
            Title.Size = UDim2.new(1, -100, 1, 0)
            Title.Position = UDim2.new(0, 50, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Text = "XESTEER HUB - NOKIA EDITION v5.0"
            Title.TextColor3 = Colors.Text
            Title.TextSize = 20
            Title.Font = Enum.Font.GothamBold
            Title.Parent = TopBar
        end
        
        -- Botão de fechar
        local CloseButton = Create("TextButton")
        if CloseButton then
            CloseButton.Name = "CloseButton"
            CloseButton.Size = UDim2.new(0, 30, 0, 30)
            CloseButton.Position = UDim2.new(1, -35, 0, 5)
            CloseButton.BackgroundColor3 = Colors.Error
            CloseButton.Text = "X"
            CloseButton.TextColor3 = Colors.Text
            CloseButton.TextSize = 18
            CloseButton.Font = Enum.Font.GothamBold
            CloseButton.Parent = TopBar
            
            -- Cantos arredondados para o botão de fechar
            local UICorner3 = Create("UICorner")
            if UICorner3 then
                UICorner3.CornerRadius = UDim.new(0, 5)
                UICorner3.Parent = CloseButton
            end
        end
    end
    
    -- Adicionar logo circular
    local LogoContainer = Create("Frame")
    if LogoContainer then
        LogoContainer.Name = "LogoContainer"
        LogoContainer.Size = UDim2.new(0, 80, 0, 80)
        LogoContainer.Position = UDim2.new(0, 20, 0, 50)
        LogoContainer.BackgroundColor3 = Colors.Primary
        LogoContainer.BorderSizePixel = 0
        LogoContainer.Parent = Container
        
        -- Cantos arredondados (círculo)
        local UICorner4 = Create("UICorner")
        if UICorner4 then
            UICorner4.CornerRadius = UDim.new(1, 0)
            UICorner4.Parent = LogoContainer
        end
        
        -- Símbolo X
        local XLabel = Create("TextLabel")
        if XLabel then
            XLabel.Name = "XSymbol"
            XLabel.Size = UDim2.new(1, 0, 1, 0)
            XLabel.BackgroundTransparency = 1
            XLabel.Text = "X"
            XLabel.TextColor3 = Colors.Text
            XLabel.TextSize = 50
            XLabel.Font = Enum.Font.GothamBold
            XLabel.Parent = LogoContainer
        end
    end
    
    -- Adicionar informações do sistema
    local SystemInfo = Create("Frame")
    if SystemInfo then
        SystemInfo.Name = "SystemInfo"
        SystemInfo.Size = UDim2.new(0, 350, 0, 80)
        SystemInfo.Position = UDim2.new(0, 130, 0, 50)
        SystemInfo.BackgroundTransparency = 1
        SystemInfo.Parent = Container
        
        local Title = Create("TextLabel")
        if Title then
            Title.Name = "Title"
            Title.Size = UDim2.new(1, 0, 0, 25)
            Title.BackgroundTransparency = 1
            Title.Text = "INFORMAÇÕES DO SISTEMA"
            Title.TextColor3 = Colors.Primary
            Title.TextSize = 16
            Title.Font = Enum.Font.GothamBold
            Title.Parent = SystemInfo
        end
        
        local InfoExecutor = Create("TextLabel")
        if InfoExecutor then
            InfoExecutor.Name = "InfoExecutor"
            InfoExecutor.Size = UDim2.new(1, 0, 0, 20)
            InfoExecutor.Position = UDim2.new(0, 0, 0, 30)
            InfoExecutor.BackgroundTransparency = 1
            InfoExecutor.Text = "Executor Detectado: " .. executorDetected
            InfoExecutor.TextColor3 = Colors.Text
            InfoExecutor.TextSize = 14
            InfoExecutor.Font = Enum.Font.Gotham
            InfoExecutor.Parent = SystemInfo
        end
        
        local InfoDevice = Create("TextLabel")
        if InfoDevice then
            InfoDevice.Name = "InfoDevice"
            InfoDevice.Size = UDim2.new(1, 0, 0, 20)
            InfoDevice.Position = UDim2.new(0, 0, 0, 50)
            InfoDevice.BackgroundTransparency = 1
            InfoDevice.Text = "Dispositivo: " .. (IS_MOBILE and "Mobile (Nokia Mode)" or "PC (Desktop)")
            InfoDevice.TextColor3 = Colors.Text
            InfoDevice.TextSize = 14
            InfoDevice.Font = Enum.Font.Gotham
            InfoDevice.Parent = SystemInfo
        end
    end
    
    -- Container para as TABs
    local TabContainer = Create("Frame")
    if TabContainer then
        TabContainer.Name = "TabContainer"
        TabContainer.Size = UDim2.new(1, -40, 0, 40)
        TabContainer.Position = UDim2.new(0, 20, 0, 140)
        TabContainer.BackgroundColor3 = Colors.Secondary
        TabContainer.BorderSizePixel = 0
        TabContainer.Parent = Container
        
        -- Cantos arredondados
        local UICorner5 = Create("UICorner")
        if UICorner5 then
            UICorner5.CornerRadius = UDim.new(0, 10)
            UICorner5.Parent = TabContainer
        end
    end
    
    -- Container para o conteúdo
    local ContentContainer = Create("Frame")
    if ContentContainer then
        ContentContainer.Name = "ContentContainer"
        ContentContainer.Size = UDim2.new(1, -40, 1, -200)
        ContentContainer.Position = UDim2.new(0, 20, 0, 190)
        ContentContainer.BackgroundColor3 = Colors.Secondary
        ContentContainer.BorderSizePixel = 0
        ContentContainer.Parent = Container
        
        -- Cantos arredondados
        local UICorner6 = Create("UICorner")
        if UICorner6 then
            UICorner6.CornerRadius = UDim.new(0, 10)
            UICorner6.Parent = ContentContainer
        end
    end
    
    return {
        Container = Container,
        TabContainer = TabContainer,
        ContentContainer = ContentContainer
    }
end

-- * FUNCIONALIDADES DO HUB

-- Sistema de Spins Infinitos
local function setupInfiniteSpins()
    local spinRemote = nil
    
    -- Encontra a RemoteFunction de Spin
    for _, obj in pairs(getService("ReplicatedStorage"):GetDescendants()) do
        if obj:IsA("RemoteFunction") and (
            obj.Name:lower():find("spin") or 
            obj.Name:lower():find("roll") or 
            obj.Name:lower():find("gacha")
        ) then
            spinRemote = obj
            break
        end
    end
    
    if not spinRemote then
        warn("XESTEER HUB: Remote de spin não encontrado")
        return false
    end
    
    -- Verifica se existe uma verificação de moeda/limite
    local originalSpinFunction = nil
    originalSpinFunction = hookfunction or replace_closure or detour_function
    
    if originalSpinFunction then
        -- Tenta fazer hook na função
        local success = pcall(function()
            originalSpinFunction(spinRemote.InvokeServer, function(...)
                -- Sempre retorna sucesso com algum resultado
                return {success = true, character = "Random"}
            end)
        end)
        
        if not success then
            warn("XESTEER HUB: Falha ao fazer hook na função de spin")
        end
    end
    
    -- Método alternativo (Override direto)
    if spinRemote and spinRemote.InvokeServer then
        local oldInvoke = spinRemote.InvokeServer
        spinRemote.InvokeServer = function(...)
            return oldInvoke(...)
        end
    end
    
    return true
end

-- Sistema de 100x Lucky para personagens raros
local function setup100xLucky()
    local success, result = pcall(function()
        -- Encontra tabela de probabilidade
        for _, obj in pairs(getService("ReplicatedStorage"):GetDescendants()) do
            if obj:IsA("ModuleScript") and (
                obj.Name:lower():find("probability") or 
                obj.Name:lower():find("chance") or 
                obj.Name:lower():find("gacha") or
                obj.Name:lower():find("table")
            ) then
                -- Tenta carregar o módulo
                local moduleSuccess, moduleContent = pcall(require, obj)
                
                if moduleSuccess and type(moduleContent) == "table" then
                    -- Busca entradas que pareçam ser personagens raros
                    for name, value in pairs(moduleContent) do
                        if type(value) == "number" and value < 0.1 then
                            -- Aumenta a chance em 100x (limitado a 80%)
                            moduleContent[name] = math.min(value * 100, 0.8)
                        end
                    end
                end
            end
        end
        
        return true
    end)
    
    if not success then
        warn("XESTEER HUB: Falha ao configurar 100x Lucky - " .. tostring(result))
        return false
    end
    
    return true
end

-- Controle avançado de bola
local function setupBallControl()
    local ballControlEnabled = false
    local ballTarget = nil
    local controlConnection = nil
    
    -- Função para encontrar a bola
    local function findBall()
        -- Métodos comuns para encontrar a bola no jogo
        local ballNames = {"Ball", "Soccer", "Football", "SoccerBall", "Bola"}
        
        -- Método 1: Procurar na Workspace
        for _, ballName in ipairs(ballNames) do
            local ball = workspace:FindFirstChild(ballName)
            if ball then return ball end
        end
        
        -- Método 2: Procurar em pastas comuns
        local commonFolders = {"Balls", "GameObjects", "Field", "Game"}
        for _, folderName in ipairs(commonFolders) do
            local folder = workspace:FindFirstChild(folderName)
            if folder then
                for _, ballName in ipairs(ballNames) do
                    local ball = folder:FindFirstChild(ballName)
                    if ball then return ball end
                end
            end
        end
        
        -- Método 3: Procurar por propriedades físicas
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj:IsA("Ball") and obj.Shape == Enum.PartType.Ball then
                return obj
            end
        end
        
        return nil
    end
    
    -- Função para ativar/desativar o controle da bola
    local function toggleBallControl()
        ballControlEnabled = not ballControlEnabled
        
        if ballControlEnabled then
            ballTarget = findBall()
            
            if not ballTarget then
                warn("XESTEER HUB: Bola não encontrada")
                ballControlEnabled = false
                return false
            end
            
            -- Conecta ao evento UpdateStep para controle suave
            controlConnection = RunService.Stepped:Connect(function()
                if not ballControlEnabled or not ballTarget or not ballTarget.Parent then
                    if controlConnection then
                        controlConnection:Disconnect()
                        controlConnection = nil
                    end
                    return
                end
                
                -- Move a bola para o jogador (com offset para frente)
                local char = Players.LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    local direction = hrp.CFrame.LookVector
                    local targetPos = hrp.Position + (direction * 5)
                    
                    -- Aplica forças na bola ao invés de teleportar (mais natural)
                    if ballTarget:IsA("BasePart") then
                        -- Método 1: SetNetworkOwner
                        pcall(function()
                            ballTarget:SetNetworkOwner(Players.LocalPlayer)
                        end)
                        
                        -- Método 2: Força física através de velocidade
                        local movementVector = (targetPos - ballTarget.Position)
                        if movementVector.Magnitude > 1 then
                            ballTarget.Velocity = movementVector.Unit * 30
                        else
                            ballTarget.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end)
            
            return true
        else
            if controlConnection then
                controlConnection:Disconnect()
                controlConnection = nil
            end
            
            return true
        end
    end
    
    -- Retorna a função de controle para ser usada pela interface
    return toggleBallControl
end

-- Boost de FPS
local function setupFPSBoost()
    local fpsBoostEnabled = false
    
    -- Função para ativar/desativar o boost de FPS
    local function toggleFPSBoost()
        fpsBoostEnabled = not fpsBoostEnabled
        
        if fpsBoostEnabled then
            -- Reduzir qualidade gráfica
            if getService("UserSettings") and getService("UserSettings"):GetService("UserGameSettings") then
                local userSettings = getService("UserSettings"):GetService("UserGameSettings")
                
                userSettings.SavedQualityLevel = Enum.SavedQualityLevel.Automatic
                
                -- Configura para qualidade mínima (modo batata/nokia)
                for _, v in pairs({
                    "MasterVolume", "SavedQualityLevel", "GraphicsQualityLevel", 
                    "SavedQualityLevel", "MaximumQualityLevel"
                }) do
                    if userSettings[v] ~= nil then
                        userSettings[v] = 1
                    end
                end
            end
            
            -- Desativar efeitos de iluminação
            if Lighting then
                -- Salva as configurações originais
                local savedProperties = {}
                for _, prop in pairs({"GlobalShadows", "Technology", "Brightness", "BloomEffect", "BlurEffect", "DepthOfFieldEffect", "SunRaysEffect"}) do
                    if Lighting[prop] ~= nil then
                        savedProperties[prop] = Lighting[prop]
                    end
                end
                
                -- Aplica configurações de baixa qualidade
                Lighting.GlobalShadows = false
                Lighting.Technology = Enum.Technology.Compatibility
                
                -- Remove efeitos de pós-processamento
                for _, effect in pairs(Lighting:GetChildren()) do
                    if effect:IsA("BloomEffect") or 
                       effect:IsA("BlurEffect") or 
                       effect:IsA("DepthOfFieldEffect") or 
                       effect:IsA("SunRaysEffect") then
                        effect.Enabled = false
                    end
                end
                
                -- Salva as configurações para reverter depois
                getgenv().savedLightingProperties = savedProperties
            end
            
            -- Reduzir detalhes de renderização
            safeExecute(function()
                if setfpscap then setfpscap(999) end
                
                settings().Rendering.QualityLevel = 1
                settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
                
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.CastShadow = false
                    elseif obj:IsA("Texture") or obj:IsA("Decal") then
                        obj.Transparency = 1
                    elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") then
                        obj.Enabled = false
                    elseif obj:IsA("PointLight") or obj:IsA("SurfaceLight") or obj:IsA("SpotLight") then
                        obj.Enabled = false
                    end
                end
            end)
            
            -- Clean Memory Cache
            safeExecute(function()
                game:GetService("Debris"):AddItem(Create("Part"), 0)
                settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
                settings().Rendering.EagerBulkExecution = false
                
                -- Limpeza de memória a cada 30 segundos
                spawn(function()
                    while fpsBoostEnabled do
                        collectgarbage("collect")
                        wait(30)
                    end
                end)
            end)
            
            return true
        else
            -- Restaurar configurações originais de iluminação
            if Lighting and getgenv().savedLightingProperties then
                for prop, value in pairs(getgenv().savedLightingProperties) do
                    safeExecute(function()
                        Lighting[prop] = value
                    end)
                end
                
                -- Reativa efeitos
                for _, effect in pairs(Lighting:GetChildren()) do
                    if effect:IsA("BloomEffect") or 
                       effect:IsA("BlurEffect") or 
                       effect:IsA("DepthOfFieldEffect") or 
                       effect:IsA("SunRaysEffect") then
                        effect.Enabled = true
                    end
                end
            end
            
            return true
        end
    end
    
    -- Retorna a função para toggle
    return toggleFPSBoost
end

-- Auto Roll com Personagem Específico
local function setupAutoRoll(specificCharacter)
    local isRolling = false
    local stopOnSpecificCharacter = true
    local targetCharacter = specificCharacter or "Isagi Yoichi"
    
    -- Referências para as RemoteEvents
    local spinRemote = nil
    local characterGotRemote = nil
    local spinResult = nil
    
    -- Encontra as RemoteEvents
    for _, obj in pairs(getService("ReplicatedStorage"):GetDescendants()) do
        if obj:IsA("RemoteFunction") and (
            obj.Name:lower():find("spin") or 
            obj.Name:lower():find("roll") or
            obj.Name:lower():find("gacha")
        ) then
            spinRemote = obj
        elseif obj:IsA("RemoteEvent") and (
            obj.Name:lower():find("character") or
            obj.Name:lower():find("result") or
            obj.Name:lower():find("got")
        ) then
            characterGotRemote = obj
        end
    end
    
    -- Se não conseguiu encontrar o remote, tenta métodos alternativos
    if not spinRemote then
        -- Verifica se há algum botão na interface que possa invocar o spin
        local spinButtons = {}
        for _, obj in pairs(getService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
            if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and (
                obj.Name:lower():find("spin") or 
                obj.Name:lower():find("roll") or
                obj.Name:lower():find("gacha")
            ) then
                table.insert(spinButtons, obj)
            end
        end
        
        if #spinButtons > 0 then
            -- Usa o primeiro botão encontrado
            local button = spinButtons[1]
            -- Simula um clique no botão
            local clickFunction = function()
                for _, signal in pairs(getconnections(button.MouseButton1Click)) do
                    signal:Fire()
                end
            end
            
            -- Substitui a função de spin
            spinRemote = {
                Spin = clickFunction,
                InvokeServer = clickFunction
            }
        end
    end
    
    -- Se está monitorando um personagem específico, conecta no evento correto
    if characterGotRemote then
        characterGotRemote.OnClientEvent:Connect(function(data)
            -- Tenta extrair informações do resultado
            local character = nil
            
            if type(data) == "table" then
                character = data.character or data.Character or data.name or data.Name
            elseif type(data) == "string" then
                character = data
            end
            
            if character then
                spinResult = character
                
                -- Verifica se é o personagem desejado
                if stopOnSpecificCharacter and character:lower() == targetCharacter:lower() then
                    isRolling = false
                    warn("XESTEER HUB: Personagem encontrado! - " .. character)
                end
            end
        end)
    end
    
    -- Função para iniciar ou parar o auto roll
    local function toggleAutoRoll()
        isRolling = not isRolling
        
        if isRolling and spinRemote then
            -- Verifica se sabe como executar a função
            local spinFunction = nil
            
            if typeof(spinRemote) == "Instance" and spinRemote:IsA("RemoteFunction") then
                spinFunction = function()
                    return spinRemote:InvokeServer()
                end
            elseif typeof(spinRemote) == "Instance" and spinRemote:IsA("RemoteEvent") then
                spinFunction = function()
                    return spinRemote:FireServer()
                end
            elseif typeof(spinRemote) == "table" and typeof(spinRemote.InvokeServer) == "function" then
                spinFunction = spinRemote.InvokeServer
            elseif typeof(spinRemote) == "table" and typeof(spinRemote.Spin) == "function" then
                spinFunction = spinRemote.Spin
            else
                warn("XESTEER HUB: Não foi possível determinar como usar o remote de spin")
                isRolling = false
                return false
            end
            
            -- Inicia o loop de auto roll
            spawn(function()
                local counter = 0
                while isRolling do
                    counter = counter + 1
                    
                    -- Executa o spin
                    local success, result = pcall(spinFunction)
                    
                    -- Aguarda um pouco para verificar o resultado
                    wait(0.5)
                    
                    -- Se encontrou o personagem desejado, para o loop
                    if spinResult and spinResult:lower() == targetCharacter:lower() then
                        isRolling = false
                        break
                    end
                    
                    -- Limite de tentativas para não travar (opcional)
                    if counter >= 1000 then
                        isRolling = false
                        warn("XESTEER HUB: Limite de tentativas atingido (1000)")
                        break
                    end
                    
                    -- Pequeno delay para não sobrecarregar
                    wait(0.1)
                end
            end)
            
            return true
        else
            return true
        end
    end
    
    -- Função para definir o personagem alvo
    local function setTargetCharacter(character)
        if character and type(character) == "string" then
            targetCharacter = character
            return true
        end
        return false
    end
    
    -- Retorna funções para controle
    return {
        toggle = toggleAutoRoll,
        setTarget = setTargetCharacter
    }
end

-- * CRIAR A INTERFACE PRINCIPAL

-- Função principal para criar e configurar a interface
local function createXesteerHub()
    -- Criar a GUI principal
    local MainGui = createMainGUI()
    if not MainGui then
        warn("XESTEER HUB: Falha ao criar interface principal")
        return false
    end
    
    -- Criar containers principais
    local containers = createMainContainer(MainGui)
    if not containers or not containers.Container then
        warn("XESTEER HUB: Falha ao criar containers")
        return false
    end
    
    -- Configuração das funcionalidades
    local featureToggle = {
        infiniteSpins = false,
        luckyMode = false,
        autoRoll = false,
        ballControl = false,
        fpsBoost = false
    }
    
    -- Setup das funcionalidades
    local setupResults = {
        infiniteSpins = safeExecute(setupInfiniteSpins),
        luckyMode = safeExecute(setup100xLucky),
        ballControl = safeExecute(setupBallControl),
        fpsBoost = safeExecute(setupFPSBoost)
    }
    
    -- Setup do Auto Roll
    local autoRollFunctions = safeExecute(setupAutoRoll, "Isagi Yoichi")
    setupResults.autoRoll = (autoRollFunctions ~= nil)
    
    -- Criar tabs no TabContainer
    local tabs = {
        {name = "Jogador", icon = "👤"},
        {name = "Spins & Personagens", icon = "🎲"},
        {name = "Controle de Bola", icon = "⚽"},
        {name = "Otimizações FPS", icon = "🚀"},
        {name = "Visuais", icon = "👁️"},
        {name = "Hacks Especiais", icon = "⚡"},
        {name = "Proteções", icon = "🛡️"},
        {name = "Configurações", icon = "⚙️"}
    }
    
    local tabButtons = {}
    local tabContents = {}
    local activeTab = nil
    
    -- Criar botões das tabs
    for i, tab in ipairs(tabs) do
        local TabButton = Create("TextButton")
        if TabButton then
            local width = 1 / #tabs
            TabButton.Name = "Tab_" .. tab.name:gsub(" ", "_")
            TabButton.Size = UDim2.new(width, 0, 1, 0)
            TabButton.Position = UDim2.new(width * (i-1), 0, 0, 0)
            TabButton.BackgroundTransparency = 0.9
            TabButton.BackgroundColor3 = Colors.Secondary
            TabButton.Text = tab.icon .. " " .. tab.name
            TabButton.TextColor3 = Colors.Text
            TabButton.TextSize = IS_NOKIA_MODE and 10 or 14
            TabButton.Font = Enum.Font.Gotham
            TabButton.Parent = containers.TabContainer
            
            tabButtons[tab.name] = TabButton
        end
        
        -- Criar conteúdo da tab
        local TabContent = Create("Frame")
        if TabContent then
            TabContent.Name = "Content_" .. tab.name:gsub(" ", "_")
            TabContent.Size = UDim2.new(1, 0, 1, 0)
            TabContent.BackgroundTransparency = 1
            TabContent.Visible = false -- Inicialmente invisível
            TabContent.Parent = containers.ContentContainer
            
            tabContents[tab.name] = TabContent
        end
    end
    
    -- Função para trocar de tab
    local function switchTab(tabName)
        if not tabContents[tabName] then return end
        
        -- Oculta todas as tabs
        for name, content in pairs(tabContents) do
            content.Visible = false
            
            if tabButtons[name] then
                tabButtons[name].BackgroundTransparency = 0.9
            end
        end
        
        -- Mostra a tab selecionada
        tabContents[tabName].Visible = true
        
        if tabButtons[tabName] then
            tabButtons[tabName].BackgroundTransparency = 0.5
        end
        
        activeTab = tabName
    end
    
    -- Conecta os eventos de clique nas tabs
    for name, button in pairs(tabButtons) do
        button.MouseButton1Click:Connect(function()
            switchTab(name)
        end)
    end
    
    -- Preenche a Tab de Spins & Personagens
    if tabContents["Spins & Personagens"] then
        local tab = tabContents["Spins & Personagens"]
        
        -- Título 
        local Title = Create("TextLabel")
        if Title then
            Title.Name = "Title"
            Title.Size = UDim2.new(1, 0, 0, 30)
            Title.BackgroundTransparency = 1
            Title.Text = "SPINS & PERSONAGENS"
            Title.TextColor3 = Colors.Primary
            Title.TextSize = 18
            Title.Font = Enum.Font.GothamBold
            Title.Parent = tab
        end
        
        -- Toggle Spins Infinitos
        local SpinsToggle = Create("TextButton")
        if SpinsToggle then
            SpinsToggle.Name = "SpinsToggle"
            SpinsToggle.Size = UDim2.new(0, 200, 0, 30)
            SpinsToggle.Position = UDim2.new(0, 20, 0, 40)
            SpinsToggle.BackgroundColor3 = Colors.Secondary
            SpinsToggle.BorderColor3 = featureToggle.infiniteSpins and Colors.Success or Colors.Error
            SpinsToggle.BorderSizePixel = 2
            SpinsToggle.Text = "Spins Infinitos: " .. (featureToggle.infiniteSpins and "ATIVADO" or "DESATIVADO")
            SpinsToggle.TextColor3 = Colors.Text
            SpinsToggle.TextSize = 14
            SpinsToggle.Font = Enum.Font.Gotham
            SpinsToggle.Parent = tab
            
            -- Evento de clique
            SpinsToggle.MouseButton1Click:Connect(function()
                featureToggle.infiniteSpins = not featureToggle.infiniteSpins
                SpinsToggle.Text = "Spins Infinitos: " .. (featureToggle.infiniteSpins and "ATIVADO" or "DESATIVADO")
                SpinsToggle.BorderColor3 = featureToggle.infiniteSpins and Colors.Success or Colors.Error
            end)
        end
        
        -- Toggle 100x Lucky
        local LuckyToggle = Create("TextButton")
        if LuckyToggle then
            LuckyToggle.Name = "LuckyToggle"
            LuckyToggle.Size = UDim2.new(0, 200, 0, 30)
            LuckyToggle.Position = UDim2.new(0, 20, 0, 80)
            LuckyToggle.BackgroundColor3 = Colors.Secondary
            LuckyToggle.BorderColor3 = featureToggle.luckyMode and Colors.Success or Colors.Error
            LuckyToggle.BorderSizePixel = 2
            LuckyToggle.Text = "100x Lucky: " .. (featureToggle.luckyMode and "ATIVADO" or "DESATIVADO")
            LuckyToggle.TextColor3 = Colors.Text
            LuckyToggle.TextSize = 14
            LuckyToggle.Font = Enum.Font.Gotham
            LuckyToggle.Parent = tab
            
            -- Evento de clique
            LuckyToggle.MouseButton1Click:Connect(function()
                featureToggle.luckyMode = not featureToggle.luckyMode
                LuckyToggle.Text = "100x Lucky: " .. (featureToggle.luckyMode and "ATIVADO" or "DESATIVADO")
                LuckyToggle.BorderColor3 = featureToggle.luckyMode and Colors.Success or Colors.Error
                
                -- Ativa a funcionalidade
                if featureToggle.luckyMode then
                    safeExecute(setup100xLucky)
                end
            end)
        end
        
        -- Toggle Auto Roll
        local AutoRollToggle = Create("TextButton")
        if AutoRollToggle then
            AutoRollToggle.Name = "AutoRollToggle"
            AutoRollToggle.Size = UDim2.new(0, 200, 0, 30)
            AutoRollToggle.Position = UDim2.new(0, 20, 0, 120)
            AutoRollToggle.BackgroundColor3 = Colors.Secondary
            AutoRollToggle.BorderColor3 = featureToggle.autoRoll and Colors.Success or Colors.Error
            AutoRollToggle.BorderSizePixel = 2
            AutoRollToggle.Text = "Auto Roll: " .. (featureToggle.autoRoll and "ATIVADO" or "DESATIVADO")
            AutoRollToggle.TextColor3 = Colors.Text
            AutoRollToggle.TextSize = 14
            AutoRollToggle.Font = Enum.Font.Gotham
            AutoRollToggle.Parent = tab
            
            -- Evento de clique
            AutoRollToggle.MouseButton1Click:Connect(function()
                if autoRollFunctions and autoRollFunctions.toggle then
                    autoRollFunctions.toggle()
                    featureToggle.autoRoll = not featureToggle.autoRoll
                    AutoRollToggle.Text = "Auto Roll: " .. (featureToggle.autoRoll and "ATIVADO" or "DESATIVADO")
                    AutoRollToggle.BorderColor3 = featureToggle.autoRoll and Colors.Success or Colors.Error
                end
            end)
        end
        
        -- Seletor de personagem alvo
        local CharSelectLabel = Create("TextLabel")
        if CharSelectLabel then
            CharSelectLabel.Name = "CharSelectLabel"
            CharSelectLabel.Size = UDim2.new(0, 200, 0, 20)
            CharSelectLabel.Position = UDim2.new(0, 230, 0, 40)
            CharSelectLabel.BackgroundTransparency = 1
            CharSelectLabel.Text = "Personagem Alvo:"
            CharSelectLabel.TextColor3 = Colors.Text
            CharSelectLabel.TextSize = 14
            CharSelectLabel.Font = Enum.Font.Gotham
            CharSelectLabel.Parent = tab
        end
        
        local CharSelectInput = Create("TextBox")
        if CharSelectInput then
            CharSelectInput.Name = "CharSelectInput"
            CharSelectInput.Size = UDim2.new(0, 200, 0, 30)
            CharSelectInput.Position = UDim2.new(0, 230, 0, 60)
            CharSelectInput.BackgroundColor3 = Colors.Secondary
            CharSelectInput.BorderColor3 = Colors.Primary
            CharSelectInput.BorderSizePixel = 2
            CharSelectInput.Text = "Isagi Yoichi"
            CharSelectInput.TextColor3 = Colors.Text
            CharSelectInput.TextSize = 14
            CharSelectInput.Font = Enum.Font.Gotham
            CharSelectInput.PlaceholderText = "Digite o nome do personagem"
            CharSelectInput.ClearTextOnFocus = false
            CharSelectInput.Parent = tab
            
            -- Atualiza o alvo quando o texto muda
            CharSelectInput.FocusLost:Connect(function(enterPressed)
                if enterPressed and autoRollFunctions and autoRollFunctions.setTarget then
                    autoRollFunctions.setTarget(CharSelectInput.Text)
                end
            end)
        end
        
        -- Status atual
        local StatusLabel = Create("TextLabel")
        if StatusLabel then
            StatusLabel.Name = "StatusLabel"
            StatusLabel.Size = UDim2.new(0, 410, 0, 20)
            StatusLabel.Position = UDim2.new(0, 20, 0, 160)
            StatusLabel.BackgroundTransparency = 1
            StatusLabel.Text = "Status: Aguardando ação"
            StatusLabel.TextColor3 = Colors.Text
            StatusLabel.TextSize = 14
            StatusLabel.Font = Enum.Font.Gotham
            StatusLabel.Parent = tab
            
            -- Atualiza o status periodicamente
            spawn(function()
                while wait(1) do
                    if StatusLabel and StatusLabel.Parent then
                        local status = "Aguardando ação"
                        
                        if featureToggle.autoRoll then
                            status = "Auto Roll em andamento... Procurando por " .. (CharSelectInput and CharSelectInput.Text or "Isagi Yoichi")
                        end
                        
                        StatusLabel.Text = "Status: " .. status
                    else
                        break
                    end
                end
            end)
        end
    end
    
    -- Preenche a Tab de Controle de Bola
    if tabContents["Controle de Bola"] then
        local tab = tabContents["Controle de Bola"]
        
        -- Título 
        local Title = Create("TextLabel")
        if Title then
            Title.Name = "Title"
            Title.Size = UDim2.new(1, 0, 0, 30)
            Title.BackgroundTransparency = 1
            Title.Text = "CONTROLE DE BOLA"
            Title.TextColor3 = Colors.Primary
            Title.TextSize = 18
            Title.Font = Enum.Font.GothamBold
            Title.Parent = tab
        end
        
        -- Toggle Controle de Bola
        local BallToggle = Create("TextButton")
        if BallToggle then
            BallToggle.Name = "BallToggle"
            BallToggle.Size = UDim2.new(0, 200, 0, 30)
            BallToggle.Position = UDim2.new(0, 20, 0, 40)
            BallToggle.BackgroundColor3 = Colors.Secondary
            BallToggle.BorderColor3 = featureToggle.ballControl and Colors.Success or Colors.Error
            BallToggle.BorderSizePixel = 2
            BallToggle.Text = "Ball Magnet: " .. (featureToggle.ballControl and "ATIVADO" or "DESATIVADO")
            BallToggle.TextColor3 = Colors.Text
            BallToggle.TextSize = 14
            BallToggle.Font = Enum.Font.Gotham
            BallToggle.Parent = tab
            
            -- Evento de clique
            BallToggle.MouseButton1Click:Connect(function()
                if setupResults.ballControl then
                    setupResults.ballControl()
                    featureToggle.ballControl = not featureToggle.ballControl
                    BallToggle.Text = "Ball Magnet: " .. (featureToggle.ballControl and "ATIVADO" or "DESATIVADO")
                    BallToggle.BorderColor3 = featureToggle.ballControl and Colors.Success or Colors.Error
                end
            end)
        end
        
        -- Instruções
        local Instructions = Create("TextLabel")
        if Instructions then
            Instructions.Name = "Instructions"
            Instructions.Size = UDim2.new(0, 410, 0, 80)
            Instructions.Position = UDim2.new(0, 20, 0, 80)
            Instructions.BackgroundTransparency = 1
            Instructions.Text = "Instruções:\n1. Ative Ball Magnet para controlar a bola\n2. A bola seguirá sua posição automaticamente\n3. Desative quando não estiver usando"
            Instructions.TextColor3 = Colors.Text
            Instructions.TextSize = 14
            Instructions.Font = Enum.Font.Gotham
            Instructions.TextXAlignment = Enum.TextXAlignment.Left
            Instructions.TextYAlignment = Enum.TextYAlignment.Top
            Instructions.Parent = tab
        end
    end
    
    -- Preenche a Tab de Otimizações FPS
    if tabContents["Otimizações FPS"] then
        local tab = tabContents["Otimizações FPS"]
        
        -- Título 
        local Title = Create("TextLabel")
        if Title then
            Title.Name = "Title"
            Title.Size = UDim2.new(1, 0, 0, 30)
            Title.BackgroundTransparency = 1
            Title.Text = "OTIMIZAÇÕES FPS"
            Title.TextColor3 = Colors.Primary
            Title.TextSize = 18
            Title.Font = Enum.Font.GothamBold
            Title.Parent = tab
        end
        
        -- Toggle FPS Boost
        local FPSToggle = Create("TextButton")
        if FPSToggle then
            FPSToggle.Name = "FPSToggle"
            FPSToggle.Size = UDim2.new(0, 200, 0, 30)
            FPSToggle.Position = UDim2.new(0, 20, 0, 40)
            FPSToggle.BackgroundColor3 = Colors.Secondary
            FPSToggle.BorderColor3 = featureToggle.fpsBoost and Colors.Success or Colors.Error
            FPSToggle.BorderSizePixel = 2
            FPSToggle.Text = "Modo Nokia: " .. (featureToggle.fpsBoost and "ATIVADO" or "DESATIVADO")
            FPSToggle.TextColor3 = Colors.Text
            FPSToggle.TextSize = 14
            FPSToggle.Font = Enum.Font.Gotham
            FPSToggle.Parent = tab
            
            -- Evento de clique
            FPSToggle.MouseButton1Click:Connect(function()
                if setupResults.fpsBoost then
                    setupResults.fpsBoost()
                    featureToggle.fpsBoost = not featureToggle.fpsBoost
                    FPSToggle.Text = "Modo Nokia: " .. (featureToggle.fpsBoost and "ATIVADO" or "DESATIVADO")
                    FPSToggle.BorderColor3 = featureToggle.fpsBoost and Colors.Success or Colors.Error
                end
            end)
        end
        
        -- Instruções
        local Instructions = Create("TextLabel")
        if Instructions then
            Instructions.Name = "Instructions"
            Instructions.Size = UDim2.new(0, 410, 0, 80)
            Instructions.Position = UDim2.new(0, 20, 0, 80)
            Instructions.BackgroundTransparency = 1
            Instructions.Text = "O Modo Nokia:\n1. Reduz a qualidade gráfica para aumentar FPS\n2. Remove sombras, reflexos e efeitos\n3. Limpa automaticamente a memória cache\n4. Recomendado para dispositivos móveis ou PCs fracos"
            Instructions.TextColor3 = Colors.Text
            Instructions.TextSize = 14
            Instructions.Font = Enum.Font.Gotham
            Instructions.TextXAlignment = Enum.TextXAlignment.Left
            Instructions.TextYAlignment = Enum.TextYAlignment.Top
            Instructions.Parent = tab
        end
    end
    
    -- Configuração do botão de fechar
    local closeButton = containers.Container.TopBar.CloseButton
    if closeButton then
        closeButton.MouseButton1Click:Connect(function()
            -- Desativa todas as funcionalidades antes de fechar
            for feature, enabled in pairs(featureToggle) do
                featureToggle[feature] = false
            end
            
            -- Remove a GUI
            MainGui:Destroy()
        end)
    end
    
    -- Adiciona drag para mover a janela
    local topBar = containers.Container.TopBar
    if topBar then
        local dragging = false
        local dragInput = nil
        local dragStart = nil
        local startPos = nil
        
        local function update(input)
            local delta = input.Position - dragStart
            containers.Container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
        
        topBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = containers.Container.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        topBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end
    
    -- Ativa a primeira tab
    switchTab("Spins & Personagens")
    
    return true
end

-- Exibe um aviso inicial
local loadingMessage = Create("ScreenGui")
if loadingMessage then
    loadingMessage.Name = HttpService:GenerateGUID(false)
    loadingMessage.ResetOnSpawn = false
    protectGui(loadingMessage)
    
    local frame = Create("Frame")
    if frame then
        frame.Size = UDim2.new(0, 300, 0, 100)
        frame.Position = UDim2.new(0.5, -150, 0.5, -50)
        frame.BackgroundColor3 = Colors.Background
        frame.BorderSizePixel = 0
        frame.Parent = loadingMessage
        
        local UICorner = Create("UICorner")
        if UICorner then
            UICorner.CornerRadius = UDim.new(0, 10)
            UICorner.Parent = frame
        end
        
        local loadingText = Create("TextLabel")
        if loadingText then
            loadingText.Size = UDim2.new(1, 0, 1, 0)
            loadingText.BackgroundTransparency = 1
            loadingText.Text = "Carregando XESTEER HUB..."
            loadingText.TextColor3 = Colors.Primary
            loadingText.TextSize = 20
            loadingText.Font = Enum.Font.GothamBold
            loadingText.Parent = frame
            
            -- Animação de carregamento
            spawn(function()
                local dots = ""
                for i = 1, 3 do
                    dots = dots .. "."
                    loadingText.Text = "Carregando XESTEER HUB" .. dots
                    wait(0.5)
                end
            end)
        end
    end
    
    wait(2)
    loadingMessage:Destroy()
end

-- Inicia o Hub
createXesteerHub()

-- Mensagem no console (útil para debug)
print("XESTEER HUB v5.0 NOKIA EDITION carregado com sucesso!")
print("BLUE LOCK RIVALS - HACK ATIVADO")
print("100% GRATUITO - SEM KEY - COMPATÍVEL COM TODOS EXECUTORES")
print("Desenvolvido por: XESTEER DEVELOPMENT")