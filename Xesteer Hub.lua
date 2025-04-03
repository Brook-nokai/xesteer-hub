--[[
   ██╗  ██╗███████╗███████╗████████╗███████╗███████╗██████╗ 
   ╚██╗██╔╝██╔════╝██╔════╝╚══██╔══╝██╔════╝██╔════╝██╔══██╗
    ╚███╔╝ █████╗  ███████╗   ██║   █████╗  █████╗  ██████╔╝
    ██╔██╗ ██╔══╝  ╚════██║   ██║   ██╔══╝  ██╔══╝  ██╔══██╗
   ██╔╝ ██╗███████╗███████║   ██║   ███████╗███████╗██║  ██║
   ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   ╚══════╝╚══════╝╚═╝  ╚═╝
                                                             
   XESTEER HUB - BLUE LOCK RIVALS MASTER X EDITION v5.0
   DESENVOLVIDO POR: XESTEER DEVELOPMENT TEAM
   Sem Key | Totalmente Gratuito | Compatível com qualquer executor
]]--

-- CONFIGURAÇÃO INICIAL E SISTEMAS DE PROTEÇÃO

-- Inicialização segura
local XesteerHub = {}
local SuccessInit, ErrorMessage = pcall(function()

-- Verificação de ambiente Roblox
if not game then
    warn("XESTEER HUB: Ambiente Roblox não detectado")
    return
end

-- Cache de serviços para melhor performance
local Services = setmetatable({}, {
    __index = function(self, service)
        local success, result = pcall(function()
            return game:GetService(service)
        end)
        
        if success then
            self[service] = result
            return result
        else
            warn("XESTEER HUB: Falha ao carregar serviço " .. service)
            return nil
        end
    end
})

-- Obtenção de serviços principais
local Players = Services.Players
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = Services.ReplicatedStorage
local UserInputService = Services.UserInputService
local RunService = Services.RunService
local TweenService = Services.TweenService
local HttpService = Services.HttpService
local CoreGui = Services.CoreGuiService or Services.CoreGui
local Lighting = Services.Lighting

-- Funções seguras para diferentes executores
local function SafeInstance(className)
    local success, instance = pcall(function()
        return Instance.new(className)
    end)
    
    if success and instance then
        return instance
    else
        warn("XESTEER HUB: Falha ao criar instância de " .. className)
        return nil
    end
end

-- Funções seguras para encapsular funções do Roblox que podem variar entre executores
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

-- Detecção de dispositivo
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local IS_HIGHEND = not IS_MOBILE and not (hookfunction == nil)

-- Verificação do jogo
local TargetGameId = 18668065416 -- BLUE LOCK RIVALS
local IsTargetGame = game.PlaceId == TargetGameId or game.GameId == TargetGameId

if not IsTargetGame then
    warn("XESTEER HUB: Este script é específico para BLUE LOCK RIVALS")
    warn("ID do jogo atual: " .. tostring(game.PlaceId))
    
    local messagebox = messagebox or function() return 6 end
    local userChoice = messagebox("Este script é específico para BLUE LOCK RIVALS.\nDeseja continuar mesmo assim?", "XESTEER HUB", 4)
    
    if userChoice ~= 6 then
        return
    end
end

-- DETECÇÃO DE EXECUTOR

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

-- Detecta executor em uso
for name, data in pairs(executorChecks) do
    local success, result = pcall(data.check)
    if success and result then
        ExecutorName = name
        ExecutorTier = data.tier
        break
    end
end

-- Verifica se algum executor genérico está sendo usado
if ExecutorName == "Universal" and identifyexecutor then
    local success, result = pcall(identifyexecutor)
    if success and type(result) == "string" then
        ExecutorName = result
    end
end

-- SISTEMAS DE PROTEÇÃO ANTI-BAN E ANTI-KICK

-- Sistema Anti-Kick avançado
local AntiKickEnabled = true
local OriginalNamecall

if AntiKickEnabled and SafeFuncs.hookmetamethod then
    OriginalNamecall = SafeFuncs.hookmetamethod(game, "__namecall", function(self, ...)
        local method = SafeFuncs.getnamecallmethod()
        local args = {...}
        
        -- Bloqueia tentativas de kick
        if method == "Kick" and self == LocalPlayer then
            warn("XESTEER HUB: Tentativa de kick bloqueada")
            return SafeFuncs.wait(9e9)
        end
        
        -- Bloqueia eventos de report
        if (method == "FireServer" or method == "InvokeServer") and 
           (self.Name:lower():find("report") or self.Name:lower():find("anticheat") or self.Name:lower():find("anti exploit")) then
            warn("XESTEER HUB: Evento de report/anticheat bloqueado - " .. self.Name)
            return
        end
        
        return OriginalNamecall(self, ...)
    end)
end

-- Sistema Anti-Ban
local function SetupAntiBan()
    if not ReplicatedStorage then return false end
    
    -- Monitora novos RemoteEvents que possam ser sistemas de banimento
    local connection = ReplicatedStorage.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            if child.Name:lower():find("ban") or 
               child.Name:lower():find("kick") or 
               child.Name:lower():find("report") or
               child.Name:lower():find("security") or
               child.Name:lower():find("anticheat") or
               child.Name:lower():find("detect") then
                
                SafeFuncs.wait()
                
                -- Desativa a função remotamente
                if typeof(child.FireServer) == "function" then
                    local oldFireServer = child.FireServer
                    child.FireServer = function() return nil end
                end
                
                if typeof(child.InvokeServer) == "function" then
                    local oldInvokeServer = child.InvokeServer
                    child.InvokeServer = function() return nil end
                end
                
                warn("XESTEER HUB: Remoto de segurança/ban bloqueado - " .. child.Name)
            end
        end
    end)
    
    -- Percorre os RemoteEvents existentes
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) and 
           (remote.Name:lower():find("ban") or 
            remote.Name:lower():find("kick") or 
            remote.Name:lower():find("security") or
            remote.Name:lower():find("anticheat") or
            remote.Name:lower():find("detect")) then
            
            -- Tenta desativar
            pcall(function()
                if typeof(remote.FireServer) == "function" then
                    local oldFireServer = remote.FireServer
                    remote.FireServer = function() return nil end
                end
                
                if typeof(remote.InvokeServer) == "function" then
                    local oldInvokeServer = remote.InvokeServer
                    remote.InvokeServer = function() return nil end
                end
                
                warn("XESTEER HUB: Remoto de segurança/ban existente bloqueado - " .. remote.Name)
            end)
        end
    end
    
    return true
end

-- Inicializa Anti-Ban
local AntiBanSuccess = pcall(SetupAntiBan)

-- INTERFACE GRÁFICA DO XESTEER HUB

-- Proteção de GUI para diferentes executores
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
        -- Fallback para outros executores
        local success = pcall(function()
            gui.Parent = CoreGui
        end)
        
        if not success then
            gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
    end
    
    -- Garante que a GUI não é destruída
    local destroyCon
    destroyCon = gui.AncestryChanged:Connect(function(_, newParent)
        if newParent == nil and gui and destroyCon then
            ProtectGui(gui)
        end
    end)
end

-- Esquema de cores futurista
local Colors = {
    Primary = Color3.fromRGB(255, 0, 0),     -- Vermelho
    Secondary = Color3.fromRGB(15, 15, 15),  -- Preto mais claro
    Background = Color3.fromRGB(10, 10, 10), -- Preto
    Text = Color3.fromRGB(255, 255, 255),    -- Branco
    SubText = Color3.fromRGB(200, 200, 200), -- Cinza claro
    Accent = Color3.fromRGB(200, 0, 0),      -- Vermelho escuro
    Success = Color3.fromRGB(0, 255, 100),   -- Verde neon
    Error = Color3.fromRGB(255, 0, 80),      -- Vermelho com rosa
    Warning = Color3.fromRGB(255, 120, 0),   -- Laranja
    Highlight = Color3.fromRGB(255, 0, 0)    -- Vermelho
}

-- Cria elementos de interface
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

-- Cria Tweens para animações
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

-- Personagens do Blue Lock Rivals para seleção
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

-- Cria o ScreenGui principal
local function CreateMainGUI()
    -- Cria o ScreenGui principal
    local XesteerScreenGui = Create("ScreenGui")({
        Name = HttpService:GenerateGUID(false),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        DisplayOrder = 999999
    })
    
    -- Protege a GUI de ser destruída
    ProtectGui(XesteerScreenGui)
    
    -- Frame principal
    local MainFrame = Create("Frame")({
        Name = "MainFrame",
        Size = UDim2.new(0, 500, 0, 320),
        Position = UDim2.new(0.5, -250, 0.5, -160),
        BackgroundColor3 = Colors.Background,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = XesteerScreenGui
    })
    
    -- Arredonda os cantos
    local MainCorner = Create("UICorner")({
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame
    })
    
    -- Adiciona stroke (contorno)
    local MainStroke = Create("UIStroke")({
        Color = Colors.Primary,
        Thickness = 1.5,
        Transparency = 0.4,
        Parent = MainFrame
    })
    
    -- Efeito de gradiente
    local MainGradient = Create("UIGradient")({
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
        }),
        Rotation = 45,
        Parent = MainFrame
    })
    
    -- Container de navegação esquerda
    local NavContainer = Create("Frame")({
        Name = "NavContainer",
        Size = UDim2.new(0, 120, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    -- Arredonda cantos da navegação
    local NavCorner = Create("UICorner")({
        CornerRadius = UDim.new(0, 8),
        Parent = NavContainer
    })
    
    -- Cria máscara para evitar overlap dos cantos
    local NavFixFrame = Create("Frame")({
        Name = "NavFixFrame",
        Size = UDim2.new(0, 10, 1, 0),
        Position = UDim2.new(1, -10, 0, 0),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = NavContainer
    })
    
    -- Logo no topo da navegação
    local LogoContainer = Create("Frame")({
        Name = "LogoContainer",
        Size = UDim2.new(0, 60, 0, 60),
        Position = UDim2.new(0.5, 0, 0, 15),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Colors.Primary,
        BorderSizePixel = 0,
        Parent = NavContainer
    })
    
    -- Torna o logo circular
    local LogoCorner = Create("UICorner")({
        CornerRadius = UDim.new(1, 0),
        Parent = LogoContainer
    })
    
    -- Adiciona X no centro do logo
    local LogoX = Create("TextLabel")({
        Name = "LogoX",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = Colors.Text,
        TextSize = 32,
        Font = Enum.Font.GothamBold,
        Parent = LogoContainer
    })
    
    -- Nome do Hub abaixo do logo
    local HubTitle = Create("TextLabel")({
        Name = "HubTitle",
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 0, 85),
        BackgroundTransparency = 1,
        Text = "XESTEER",
        TextColor3 = Colors.Primary,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = NavContainer
    })
    
    -- Subtítulo do Hub
    local HubSubtitle = Create("TextLabel")({
        Name = "HubSubtitle",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 110),
        BackgroundTransparency = 1,
        Text = "MASTER X",
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        Parent = NavContainer
    })
    
    -- Separador 
    local NavSeparator = Create("Frame")({
        Name = "NavSeparator",
        Size = UDim2.new(0.7, 0, 0, 1),
        Position = UDim2.new(0.15, 0, 0, 140),
        BackgroundColor3 = Colors.Primary,
        BorderSizePixel = 0,
        Transparency = 0.7,
        Parent = NavContainer
    })
    
    -- Container para os botões de navegação
    local NavButtons = Create("Frame")({
        Name = "NavButtons",
        Size = UDim2.new(1, 0, 0, 170),
        Position = UDim2.new(0, 0, 0, 150),
        BackgroundTransparency = 1,
        Parent = NavContainer
    })
    
    -- Contêiner de conteúdo
    local ContentContainer = Create("Frame")({
        Name = "ContentContainer",
        Size = UDim2.new(0, 370, 0, 310),
        Position = UDim2.new(0, 124, 0, 5),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = MainFrame
    })
    
    -- Lista de páginas
    local pages = {
        {name = "Main", icon = "rbxassetid://11432850248"},
        {name = "Team", icon = "rbxassetid://11448850105"},
        {name = "SuperPowers", icon = "rbxassetid://11433481329"},
        {name = "ESP", icon = "rbxassetid://11402142822"},
        {name = "Styles", icon = "rbxassetid://11433481329"},
        {name = "Visual", icon = "rbxassetid://11482998987"},
        {name = "Settings", icon = "rbxassetid://11483345203"}
    }
    
    -- Criar botões de navegação
    local navButtons = {}
    local pagePanels = {}
    local selectedPage = "Main"
    
    for i, page in ipairs(pages) do
        -- Cria o botão
        local NavButton = Create("TextButton")({
            Name = page.name .. "Button",
            Size = UDim2.new(0.85, 0, 0, 30),
            Position = UDim2.new(0.08, 0, 0, (i-1) * 35),
            BackgroundColor3 = page.name == selectedPage and Colors.Primary or Colors.Secondary,
            BackgroundTransparency = page.name == selectedPage and 0.7 or 1,
            Text = "",
            AutoButtonColor = false,
            Parent = NavButtons
        })
        
        -- Arredonda os cantos
        local ButtonCorner = Create("UICorner")({
            CornerRadius = UDim.new(0, 6),
            Parent = NavButton
        })
        
        -- Ícone do botão
        local ButtonIcon = Create("ImageLabel")({
            Name = "Icon",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 8, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Image = page.icon,
            ImageColor3 = page.name == selectedPage and Colors.Primary or Colors.Text,
            Parent = NavButton
        })
        
        -- Texto do botão
        local ButtonText = Create("TextLabel")({
            Name = "Text",
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 35, 0, 0),
            BackgroundTransparency = 1,
            Text = page.name,
            TextColor3 = page.name == selectedPage and Colors.Primary or Colors.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = NavButton
        })
        
        -- Efeito de hover
        NavButton.MouseEnter:Connect(function()
            if selectedPage ~= page.name then
                local tweenNav = CreateTween(NavButton, {BackgroundTransparency = 0.9}, 0.3)
                tweenNav:Play()
            end
        end)
        
        NavButton.MouseLeave:Connect(function()
            if selectedPage ~= page.name then
                local tweenNav = CreateTween(NavButton, {BackgroundTransparency = 1}, 0.3)
                tweenNav:Play()
            end
        end)
        
        -- Armazena o botão para referência
        navButtons[page.name] = {
            button = NavButton,
            icon = ButtonIcon,
            text = ButtonText
        }
        
        -- Cria painel de conteúdo para esta página
        local PagePanel = Create("Frame")({
            Name = page.name .. "Page",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = page.name == selectedPage,
            Parent = ContentContainer
        })
        
        -- Título da página
        local PageTitle = Create("TextLabel")({
            Name = "Title",
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            Text = page.name,
            TextColor3 = Colors.Text,
            TextSize = 24,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = PagePanel
        })
        
        -- Conteúdo da página
        local PageContent = Create("ScrollingFrame")({
            Name = "Content",
            Size = UDim2.new(1, 0, 1, -50),
            Position = UDim2.new(0, 0, 0, 50),
            BackgroundTransparency = 1,
            CanvasSize = UDim2.new(0, 0, 0, 0), -- Será atualizado depois
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Colors.Primary,
            Parent = PagePanel
        })
        
        -- Armazena a página para referência
        pagePanels[page.name] = {
            panel = PagePanel,
            title = PageTitle,
            content = PageContent
        }
        
        -- Evento de clique para mudar de página
        NavButton.MouseButton1Click:Connect(function()
            if selectedPage == page.name then return end
            
            -- Atualiza o botão anterior
            local prevButton = navButtons[selectedPage]
            CreateTween(prevButton.button, {BackgroundTransparency = 1}, 0.3):Play()
            CreateTween(prevButton.icon, {ImageColor3 = Colors.Text}, 0.3):Play()
            CreateTween(prevButton.text, {TextColor3 = Colors.Text}, 0.3):Play()
            
            -- Oculta o painel anterior
            pagePanels[selectedPage].panel.Visible = false
            
            -- Atualiza o novo botão selecionado
            CreateTween(NavButton, {BackgroundTransparency = 0.7, BackgroundColor3 = Colors.Primary}, 0.3):Play()
            CreateTween(ButtonIcon, {ImageColor3 = Colors.Primary}, 0.3):Play()
            CreateTween(ButtonText, {TextColor3 = Colors.Primary}, 0.3):Play()
            
            -- Mostra o novo painel
            PagePanel.Visible = true
            
            -- Atualiza a página selecionada
            selectedPage = page.name
        end)
    end
    
    -- UTILITÁRIOS DE INTERFACE
    
    -- Cria toggle
    local function CreateToggle(parent, position, text, initialState, callback)
        local ToggleFrame = Create("Frame")({
            Name = text .. "Toggle",
            Size = UDim2.new(1, -20, 0, 40),
            Position = position,
            BackgroundColor3 = Colors.Secondary,
            BorderSizePixel = 0,
            Parent = parent
        })
        
        local ToggleCorner = Create("UICorner")({
            CornerRadius = UDim.new(0, 6),
            Parent = ToggleFrame
        })
        
        local ToggleText = Create("TextLabel")({
            Name = "Text",
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Colors.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = ToggleFrame
        })
        
        local ToggleButton = Create("Frame")({
            Name = "Button",
            Size = UDim2.new(0, 40, 0, 22),
            Position = UDim2.new(1, -50, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = initialState and Colors.Primary or Colors.Secondary,
            BorderSizePixel = 0,
            Parent = ToggleFrame
        })
        
        local ToggleButtonCorner = Create("UICorner")({
            CornerRadius = UDim.new(1, 0),
            Parent = ToggleButton
        })
        
        local ToggleCircle = Create("Frame")({
            Name = "Circle",
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(initialState and 1 or 0, initialState and -20 or 2, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Colors.Text,
            BorderSizePixel = 0,
            Parent = ToggleButton
        })
        
        local ToggleCircleCorner = Create("UICorner")({
            CornerRadius = UDim.new(1, 0),
            Parent = ToggleCircle
        })
        
        -- Interatividade do toggle
        local toggleState = initialState
        local clickArea = Create("TextButton")({
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            Parent = ToggleFrame
        })
        
        clickArea.MouseButton1Click:Connect(function()
            toggleState = not toggleState
            
            -- Animação do botão
            CreateTween(ToggleButton, {BackgroundColor3 = toggleState and Colors.Primary or Colors.Secondary}, 0.3):Play()
            CreateTween(ToggleCircle, {Position = UDim2.new(toggleState and 1 or 0, toggleState and -20 or 2, 0.5, 0)}, 0.3):Play()
            
            -- Executa o callback
            if callback then
                callback(toggleState)
            end
        end)
        
        return {
            frame = ToggleFrame,
            setText = function(newText)
                ToggleText.Text = newText
            end,
            getValue = function()
                return toggleState
            end,
            setValue = function(value)
                toggleState = value
                CreateTween(ToggleButton, {BackgroundColor3 = toggleState and Colors.Primary or Colors.Secondary}, 0.3):Play()
                CreateTween(ToggleCircle, {Position = UDim2.new(toggleState and 1 or 0, toggleState and -20 or 2, 0.5, 0)}, 0.3):Play()
                
                if callback then
                    callback(toggleState)
                end
            end
        }
    end
    
    -- Cria botão com seta para direita
    local function CreateButtonWithArrow(parent, position, text, callback)
        local ButtonFrame = Create("Frame")({
            Name = text .. "Button",
            Size = UDim2.new(1, -20, 0, 40),
            Position = position,
            BackgroundColor3 = Colors.Secondary,
            BorderSizePixel = 0,
            Parent = parent
        })
        
        local ButtonCorner = Create("UICorner")({
            CornerRadius = UDim.new(0, 6),
            Parent = ButtonFrame
        })
        
        local ButtonText = Create("TextLabel")({
            Name = "Text",
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Colors.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = ButtonFrame
        })
        
        local ButtonArrow = Create("TextLabel")({
            Name = "Arrow",
            Size = UDim2.new(0, 40, 1, 0),
            Position = UDim2.new(1, -40, 0, 0),
            BackgroundTransparency = 1,
            Text = ">",
            TextColor3 = Colors.Text,
            TextSize = 18,
            Font = Enum.Font.GothamBold,
            Parent = ButtonFrame
        })
        
        -- Interatividade do botão
        local clickArea = Create("TextButton")({
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            Parent = ButtonFrame
        })
        
        -- Efeito de hover
        clickArea.MouseEnter:Connect(function()
            CreateTween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.3):Play()
        end)
        
        clickArea.MouseLeave:Connect(function()
            CreateTween(ButtonFrame, {BackgroundColor3 = Colors.Secondary}, 0.3):Play()
        end)
        
        clickArea.MouseButton1Click:Connect(function()
            CreateTween(ButtonFrame, {BackgroundColor3 = Colors.Primary}, 0.15):Play()
            SafeFuncs.delay(0.15, function()
                CreateTween(ButtonFrame, {BackgroundColor3 = Colors.Secondary}, 0.15):Play()
            end)
            
            if callback then
                callback()
            end
        end)
        
        return {
            frame = ButtonFrame,
            setText = function(newText)
                ButtonText.Text = newText
            end
        }
    end
    
    -- Cria dropdown
    local function CreateDropdown(parent, position, text, options, callback)
        local DropdownFrame = Create("Frame")({
            Name = text .. "Dropdown",
            Size = UDim2.new(1, -20, 0, 40),
            Position = position,
            BackgroundColor3 = Colors.Secondary,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Parent = parent
        })
        
        local DropdownCorner = Create("UICorner")({
            CornerRadius = UDim.new(0, 6),
            Parent = DropdownFrame
        })
        
        local DropdownText = Create("TextLabel")({
            Name = "Text",
            Size = UDim2.new(1, -50, 0, 40),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Colors.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = DropdownFrame
        })
        
        local SelectedOption = Create("TextLabel")({
            Name = "Selected",
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 0, 40),
            BackgroundTransparency = 1,
            Text = options[1] or "Select...",
            TextColor3 = Colors.Primary,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = DropdownFrame
        })
        
        local DropdownArrow = Create("TextLabel")({
            Name = "Arrow",
            Size = UDim2.new(0, 40, 0, 40),
            Position = UDim2.new(1, -40, 0, 0),
            BackgroundTransparency = 1,
            Text = "▼",
            TextColor3 = Colors.Text,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            Parent = DropdownFrame
        })
        
        -- Lista de opções
        local OptionsList = Create("Frame")({
            Name = "OptionsList",
            Size = UDim2.new(1, 0, 0, #options * 30),
            Position = UDim2.new(0, 0, 0, 80),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = DropdownFrame
        })
        
        -- Cria as opções
        local optionButtons = {}
        for i, option in ipairs(options) do
            local OptionButton = Create("TextButton")({
                Name = "Option_" .. i,
                Size = UDim2.new(1, 0, 0, 30),
                Position = UDim2.new(0, 0, 0, (i-1) * 30),
                BackgroundColor3 = Colors.Secondary,
                BackgroundTransparency = 0.5,
                Text = "",
                Parent = OptionsList
            })
            
            local OptionText = Create("TextLabel")({
                Name = "Text",
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = option,
                TextColor3 = Colors.Text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = OptionButton
            })
            
            -- Efeito de hover
            OptionButton.MouseEnter:Connect(function()
                CreateTween(OptionButton, {BackgroundColor3 = Colors.Primary, BackgroundTransparency = 0.7}, 0.3):Play()
            end)
            
            OptionButton.MouseLeave:Connect(function()
                CreateTween(OptionButton, {BackgroundColor3 = Colors.Secondary, BackgroundTransparency = 0.5}, 0.3):Play()
            end)
            
            -- Seleciona opção
            OptionButton.MouseButton1Click:Connect(function()
                SelectedOption.Text = option
                OptionsList.Visible = false
                CreateTween(DropdownFrame, {Size = UDim2.new(1, -20, 0, 80)}, 0.3):Play()
                
                if callback then
                    callback(option)
                end
            end)
            
            table.insert(optionButtons, OptionButton)
        end
        
        -- Interatividade do dropdown
        local isOpen = false
        local clickArea = Create("TextButton")({
            Size = UDim2.new(1, 0, 0, 80),
            BackgroundTransparency = 1,
            Text = "",
            Parent = DropdownFrame
        })
        
        clickArea.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            
            if isOpen then
                OptionsList.Visible = true
                CreateTween(DropdownFrame, {Size = UDim2.new(1, -20, 0, 80 + #options * 30)}, 0.3):Play()
                CreateTween(DropdownArrow, {Rotation = 180}, 0.3):Play()
            else
                CreateTween(DropdownFrame, {Size = UDim2.new(1, -20, 0, 80)}, 0.3):Play()
                CreateTween(DropdownArrow, {Rotation = 0}, 0.3):Play()
                
                SafeFuncs.delay(0.3, function()
                    OptionsList.Visible = false
                end)
            end
        end)
        
        return {
            frame = DropdownFrame,
            getValue = function()
                return SelectedOption.Text
            end,
            setValue = function(value)
                if table.find(options, value) then
                    SelectedOption.Text = value
                    
                    if callback then
                        callback(value)
                    end
                end
            end,
            updateOptions = function(newOptions)
                -- Limpa as opções antigas
                for _, button in ipairs(optionButtons) do
                    button:Destroy()
                end
                
                optionButtons = {}
                
                -- Tamanho da lista
                OptionsList.Size = UDim2.new(1, 0, 0, #newOptions * 30)
                
                -- Cria as novas opções
                for i, option in ipairs(newOptions) do
                    local OptionButton = Create("TextButton")({
                        Name = "Option_" .. i,
                        Size = UDim2.new(1, 0, 0, 30),
                        Position = UDim2.new(0, 0, 0, (i-1) * 30),
                        BackgroundColor3 = Colors.Secondary,
                        BackgroundTransparency = 0.5,
                        Text = "",
                        Parent = OptionsList
                    })
                    
                    local OptionText = Create("TextLabel")({
                        Name = "Text",
                        Size = UDim2.new(1, -20, 1, 0),
                        Position = UDim2.new(0, 10, 0, 0),
                        BackgroundTransparency = 1,
                        Text = option,
                        TextColor3 = Colors.Text,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = OptionButton
                    })
                    
                    -- Efeito de hover
                    OptionButton.MouseEnter:Connect(function()
                        CreateTween(OptionButton, {BackgroundColor3 = Colors.Primary, BackgroundTransparency = 0.7}, 0.3):Play()
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        CreateTween(OptionButton, {BackgroundColor3 = Colors.Secondary, BackgroundTransparency = 0.5}, 0.3):Play()
                    end)
                    
                    -- Seleciona opção
                    OptionButton.MouseButton1Click:Connect(function()
                        SelectedOption.Text = option
                        OptionsList.Visible = false
                        CreateTween(DropdownFrame, {Size = UDim2.new(1, -20, 0, 80)}, 0.3):Play()
                        
                        if callback then
                            callback(option)
                        end
                    end)
                    
                    table.insert(optionButtons, OptionButton)
                end
                
                -- Define um valor padrão
                if #newOptions > 0 then
                    SelectedOption.Text = newOptions[1]
                else
                    SelectedOption.Text = "Select..."
                end
            end
        }
    end
    
    -- Cria slider
    local function CreateSlider(parent, position, text, min, max, default, callback)
        local SliderFrame = Create("Frame")({
            Name = text .. "Slider",
            Size = UDim2.new(1, -20, 0, 60),
            Position = position,
            BackgroundColor3 = Colors.Secondary,
            BorderSizePixel = 0,
            Parent = parent
        })
        
        local SliderCorner = Create("UICorner")({
            CornerRadius = UDim.new(0, 6),
            Parent = SliderFrame
        })
        
        local SliderText = Create("TextLabel")({
            Name = "Text",
            Size = UDim2.new(0.7, 0, 0, 30),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Colors.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = SliderFrame
        })
        
        local SliderValue = Create("TextLabel")({
            Name = "Value",
            Size = UDim2.new(0.3, -20, 0, 30),
            Position = UDim2.new(0.7, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = tostring(default),
            TextColor3 = Colors.Primary,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = SliderFrame
        })
        
        local SliderBG = Create("Frame")({
            Name = "SliderBG",
            Size = UDim2.new(1, -20, 0, 6),
            Position = UDim2.new(0, 10, 0, 40),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            BorderSizePixel = 0,
            Parent = SliderFrame
        })
        
        local SliderBGCorner = Create("UICorner")({
            CornerRadius = UDim.new(1, 0),
            Parent = SliderBG
        })
        
        local SliderFill = Create("Frame")({
            Name = "SliderFill",
            Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = Colors.Primary,
            BorderSizePixel = 0,
            Parent = SliderBG
        })
        
        local SliderFillCorner = Create("UICorner")({
            CornerRadius = UDim.new(1, 0),
            Parent = SliderFill
        })
        
        local SliderButton = Create("TextButton")({
            Name = "SliderButton",
            Size = UDim2.new(1, 0, 1, 20),
            Position = UDim2.new(0, 0, 0, -10),
            BackgroundTransparency = 1,
            Text = "",
            Parent = SliderBG
        })
        
        -- Interatividade do slider
        local value = default
        local dragging = false
        
        SliderButton.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        RunService.RenderStepped:Connect(function()
            if dragging then
                local mousePos = UserInputService:GetMouseLocation()
                local framePos = SliderBG.AbsolutePosition
                local frameSize = SliderBG.AbsoluteSize
                
                local relativeX = math.clamp((mousePos.X - framePos.X) / frameSize.X, 0, 1)
                value = min + (max - min) * relativeX
                value = math.floor(value + 0.5) -- Arredonda para o valor mais próximo
                
                SliderValue.Text = tostring(value)
                SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                
                if callback then
                    callback(value)
                end
            end
        end)
        
        return {
            frame = SliderFrame,
            getValue = function()
                return value
            end,
            setValue = function(newValue)
                value = math.clamp(newValue, min, max)
                local relativeX = (value - min) / (max - min)
                
                SliderValue.Text = tostring(value)
                SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                
                if callback then
                    callback(value)
                end
            end
        }
    end
    
    -- Botão de fechar
    local CloseButton = Create("TextButton")({
        Name = "CloseButton",
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -14, 0, 10),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Colors.Error,
        Text = "X",
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Parent = MainFrame
    })
    
    local CloseButtonCorner = Create("UICorner")({
        CornerRadius = UDim.new(1, 0),
        Parent = CloseButton
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        -- Animação de saída
        CreateTween(MainFrame, {Size = UDim2.new(0, 500, 0, 0), Position = UDim2.new(0.5, -250, 0.5, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
        
        SafeFuncs.delay(0.3, function()
            XesteerScreenGui:Destroy()
        end)
    end)
    
    -- Tela de inicialização/splash
    local SplashGui = Create("ScreenGui")({
        Name = HttpService:GenerateGUID(false),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        DisplayOrder = 1000000
    })
    
    ProtectGui(SplashGui)
    
    local SplashFrame = Create("Frame")({
        Name = "SplashFrame",
        Size = UDim2.new(0, 250, 0, 250),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Colors.Background,
        BorderSizePixel = 0,
        Parent = SplashGui
    })
    
    local SplashCorner = Create("UICorner")({
        CornerRadius = UDim.new(0, 12),
        Parent = SplashFrame
    })
    
    local SplashStroke = Create("UIStroke")({
        Color = Colors.Primary,
        Thickness = 2,
        Transparency = 0.4,
        Parent = SplashFrame
    })
    
    -- Logo circular
    local SplashLogo = Create("Frame")({
        Name = "Logo",
        Size = UDim2.new(0, 120, 0, 120),
        Position = UDim2.new(0.5, 0, 0.3, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Colors.Primary,
        BorderSizePixel = 0,
        Parent = SplashFrame
    })
    
    local SplashLogoCorner = Create("UICorner")({
        CornerRadius = UDim.new(1, 0),
        Parent = SplashLogo
    })
    
    local SplashX = Create("TextLabel")({
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = Colors.Text,
        TextSize = 70,
        Font = Enum.Font.GothamBold,
        Parent = SplashLogo
    })
    
    -- Título do hub
    local SplashTitle = Create("TextLabel")({
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0.55, 0),
        BackgroundTransparency = 1,
        Text = "XESTEER HUB",
        TextColor3 = Colors.Primary,
        TextSize = 26,
        Font = Enum.Font.GothamBold,
        Parent = SplashFrame
    })
    
    -- Subtítulo do hub
    local SplashSubtitle = Create("TextLabel")({
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0.55, 35),
        BackgroundTransparency = 1,
        Text = "BLUE LOCK RIVALS",
        TextColor3 = Colors.Text,
        TextSize = 16,
        Font = Enum.Font.Gotham,
        Parent = SplashFrame
    })
    
    -- Barra de carregamento
    local LoadBarBG = Create("Frame")({
        Size = UDim2.new(0.8, 0, 0, 6),
        Position = UDim2.new(0.1, 0, 0.8, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Parent = SplashFrame
    })
    
    local LoadBarBGCorner = Create("UICorner")({
        CornerRadius = UDim.new(1, 0),
        Parent = LoadBarBG
    })
    
    local LoadBarFill = Create("Frame")({
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Colors.Primary,
        BorderSizePixel = 0,
        Parent = LoadBarBG
    })
    
    local LoadBarFillCorner = Create("UICorner")({
        CornerRadius = UDim.new(1, 0),
        Parent = LoadBarFill
    })
    
    -- Texto de carregamento
    local LoadText = Create("TextLabel")({
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0.9, 0),
        BackgroundTransparency = 1,
        Text = "Iniciando...",
        TextColor3 = Colors.SubText,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        Parent = SplashFrame
    })
    
    -- Animação de carregamento
    SafeFuncs.spawn(function()
        local loadTexts = {
            "Iniciando...",
            "Verificando executores...",
            "Carregando módulos...",
            "Ativando proteções...",
            "Escaneando o jogo...",
            "Preparando hackz...",
            "Quase pronto..."
        }
        
        for i, text in ipairs(loadTexts) do
            LoadText.Text = text
            local startPercent = (i-1) / #loadTexts
            local endPercent = i / #loadTexts
            
            for j = 0, 10 do
                local percent = startPercent + (endPercent - startPercent) * (j / 10)
                CreateTween(LoadBarFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.03):Play()
                SafeFuncs.wait(0.03)
            end
            
            SafeFuncs.wait(0.2)
        }
        
        SafeFuncs.wait(0.5)
        CreateTween(SplashFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
        SafeFuncs.wait(0.5)
        SplashGui:Destroy()
    end)
    
    -- CONFIGURAÇÃO DAS PÁGINAS E FUNCIONALIDADES
    
    -- Variáveis para armazenar funções das features
    local Features = {
        spinRemotes = {},
        characterRemotes = {},
        targetCharacter = BlueLockCharacters[1],
        isAutoRolling = false,
        isAutoGoalEnabled = false,
        isAutoStealEnabled = false,
        isTpBallEnabled = false,
        ballMagnitude = 5,
        wallsDisabled = false,
        -- Novos sistemas avançados
        isSuperKickEnabled = false,
        superKickPower = 100,
        isGhostModeEnabled = false,
        isSpeedBurstEnabled = false,
        speedMultiplier = 3,
        isFootballGodEnabled = false,
        selectedGodPower = "Nenhum",
        isAreaControlEnabled = false,
        isSuperJumpEnabled = false,
        jumpHeight = 5,
        isInfiniteStaminaEnabled = false,
        isAutoDefendEnabled = false
    }
    
    -- Página Main
    local MainPage = pagePanels.Main
    
    -- Auto Goal
    local AutoGoalToggle = CreateToggle(MainPage.content, UDim2.new(0, 10, 0, 10), "Auto Goal", false, function(value)
        Features.isAutoGoalEnabled = value
        if value then
            -- Implementação do Auto Goal
            SafeFuncs.spawn(function()
                while Features.isAutoGoalEnabled do
                    local success, error = pcall(function()
                        -- Encontra o gol e a bola
                        local goalPart = workspace:FindFirstChild("Goal") or workspace:FindFirstChild("GoalPart")
                        local ballPart = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("SoccerBall")
                        
                        if goalPart and ballPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = LocalPlayer.Character.HumanoidRootPart
                            
                            -- Teleporta para perto da bola
                            hrp.CFrame = ballPart.CFrame + Vector3.new(0, 0, 2)
                            
                            -- Chuta a bola para o gol
                            local goalDirection = (goalPart.Position - ballPart.Position).Unit
                            ballPart.Velocity = goalDirection * 100
                        end
                    end)
                    
                    SafeFuncs.wait(0.5)
                end
            end)
        end
    end)
    
    -- Auto Steal
    local AutoStealToggle = CreateToggle(MainPage.content, UDim2.new(0, 10, 0, 60), "Auto Steal", false, function(value)
        Features.isAutoStealEnabled = value
        if value then
            -- Implementação do Auto Steal
            SafeFuncs.spawn(function()
                while Features.isAutoStealEnabled do
                    local success, error = pcall(function()
                        local ballPart = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("SoccerBall")
                        
                        if ballPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = LocalPlayer.Character.HumanoidRootPart
                            
                            -- Encontra o jogador mais próximo com a bola
                            local closestPlayer = nil
                            local closestDistance = math.huge
                            
                            for _, player in pairs(Players:GetPlayers()) do
                                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                    local playerHrp = player.Character.HumanoidRootPart
                                    local distance = (playerHrp.Position - ballPart.Position).Magnitude
                                    
                                    if distance < 10 and distance < closestDistance then
                                        closestPlayer = player
                                        closestDistance = distance
                                    end
                                end
                            end
                            
                            -- Se encontrou alguém com a bola, teleporta e rouba
                            if closestPlayer then
                                hrp.CFrame = ballPart.CFrame + Vector3.new(0, 0, 2)
                                ballPart.Velocity = Vector3.new(0, 10, 0) -- Interrompe movimento
                            end
                        end
                    end)
                    
                    SafeFuncs.wait(0.5)
                end
            end)
        end
    end)
    
    -- Auto TP Ball
    local AutoTPBallToggle = CreateToggle(MainPage.content, UDim2.new(0, 10, 0, 110), "Auto TP Ball", false, function(value)
        Features.isTpBallEnabled = value
        if value then
            -- Implementação do Auto TP Ball
            SafeFuncs.spawn(function()
                while Features.isTpBallEnabled do
                    local success, error = pcall(function()
                        local ballPart = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("SoccerBall")
                        
                        if ballPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = LocalPlayer.Character.HumanoidRootPart
                            
                            -- Teleporta a bola para o jogador
                            ballPart.CFrame = hrp.CFrame + hrp.CFrame.LookVector * Features.ballMagnitude
                            
                            -- Tenta definir o NetworkOwner
                            pcall(function()
                                ballPart:SetNetworkOwner(LocalPlayer)
                            end)
                        end
                    end)
                    
                    SafeFuncs.wait(0.1)
                end
            end)
        end
    end)
    
    -- Teleport To Ball (botão)
    local TeleportToBallButton = CreateButtonWithArrow(MainPage.content, UDim2.new(0, 10, 0, 160), "Teleport To Ball", function()
        local success, error = pcall(function()
            local ballPart = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("SoccerBall")
            
            if ballPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                hrp.CFrame = ballPart.CFrame + Vector3.new(0, 3, 0)
            else
                warn("XESTEER HUB: Bola não encontrada")
            end
        end)
    end)
    
    -- Página Team
    local TeamPage = pagePanels.Team
    
    -- Função para encontrar os remotes de spin/roll
    local function FindSpinRemotes()
        local remotes = {}
        
        -- Procura nos locais comuns
        local remotePaths = {
            ReplicatedStorage,
            game:GetService("ReplicatedFirst"),
            game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"),
            game:GetService("ReplicatedStorage"):FindFirstChild("Events"),
            game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
        }
        
        local remoteKeywords = {
            "spin", "roll", "gacha", "summon", "draw", "pull", "character", "unlock"
        }
        
        -- Função recursiva para procurar
        local function searchIn(parent)
            for _, obj in pairs(parent:GetChildren()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                    local objNameLower = obj.Name:lower()
                    for _, keyword in pairs(remoteKeywords) do
                        if objNameLower:find(keyword) then
                            table.insert(remotes, obj)
                            break
                        end
                    end
                end
                
                if #obj:GetChildren() > 0 then
                    searchIn(obj)
                end
            end
        end
        
        -- Procura em cada caminho
        for _, path in pairs(remotePaths) do
            if path then
                pcall(function() searchIn(path) end)
            end
        end
        
        -- Detectar eventos de personagens obtidos
        local characterEvents = {}
        for _, obj in pairs(game:GetDescendants()) do
            if (obj:IsA("RemoteEvent") or obj:IsA("BindableEvent")) and 
               (obj.Name:lower():find("character") or
                obj.Name:lower():find("unlock") or
                obj.Name:lower():find("obtain") or
                obj.Name:lower():find("get")) then
                table.insert(characterEvents, obj)
            end
        end
        
        return remotes, characterEvents
    end
    
    -- Carrega remotes
    SafeFuncs.spawn(function()
        local spinRemotes, characterRemotes = FindSpinRemotes()
        Features.spinRemotes = spinRemotes
        Features.characterRemotes = characterRemotes
        
        -- Exibe informações de debug
        if #spinRemotes > 0 then
            print("XESTEER HUB: Encontrados " .. #spinRemotes .. " remotes de spin")
        else
            warn("XESTEER HUB: Nenhum remote de spin encontrado. Tentando método alternativo...")
        end
    end)
    
    -- Função do Auto Roll
    local function SetupAutoRoll()
        if Features.isAutoRolling then return end
        
        Features.isAutoRolling = true
        
        -- Implementação do Auto Roll
        SafeFuncs.spawn(function()
            local successCount = 0
            local attempts = 0
            
            while Features.isAutoRolling do
                local success, result = pcall(function()
                    if #Features.spinRemotes == 0 then
                        -- Tenta o método alternativo
                        for _, obj in pairs(game:GetDescendants()) do
                            if obj:IsA("TextButton") and (obj.Text:lower():find("spin") or obj.Text:lower():find("roll")) then
                                -- Simula clique no botão
                                for _, conn in pairs(getconnections(obj.MouseButton1Click)) do
                                    conn:Fire()
                                end
                                return true
                            end
                        end
                        return false
                    else
                        -- Usa o primeiro remote encontrado
                        local remote = Features.spinRemotes[1]
                        
                        if remote:IsA("RemoteFunction") then
                            return remote:InvokeServer()
                        else
                            remote:FireServer()
                            return true
                        end
                    end
                end)
                
                attempts = attempts + 1
                
                if success and result then
                    successCount = successCount + 1
                end
                
                -- Verifica se encontrou o personagem desejado
                local foundTarget = false
                
                -- Verifica nos eventos de personagem
                for _, event in pairs(Features.characterRemotes) do
                    pcall(function()
                        local oldFunc
                        
                        if event:IsA("RemoteEvent") then
                            oldFunc = event.OnClientEvent:Connect(function(data)
                                if typeof(data) == "string" and data:lower():find(Features.targetCharacter:lower()) then
                                    foundTarget = true
                                elseif typeof(data) == "table" and data.character and data.character:lower():find(Features.targetCharacter:lower()) then
                                    foundTarget = true
                                end
                            end)
                            
                            SafeFuncs.wait(0.5)
                            oldFunc:Disconnect()
                        end
                    end)
                end
                
                -- Método alternativo: verifica texto na tela
                pcall(function()
                    for _, obj in pairs(game:GetDescendants()) do
                        if obj:IsA("TextLabel") and obj.Visible and obj.Text:lower():find(Features.targetCharacter:lower()) then
                            local textTime = os.time()
                            
                            -- Verifica se o texto apareceu recentemente
                            if textTime - os.time() < 5 then
                                foundTarget = true
                                break
                            end
                        end
                    end
                end)
                
                if foundTarget then
                    print("XESTEER HUB: Personagem alvo encontrado! - " .. Features.targetCharacter)
                    Features.isAutoRolling = false
                    break
                end
                
                -- Aguarda um tempo entre spins
                SafeFuncs.wait(0.5)
                
                -- Limite de segurança
                if attempts >= 500 then
                    warn("XESTEER HUB: Limite de tentativas atingido (500)")
                    Features.isAutoRolling = false
                    break
                end
            end
        end)
    end
    
    -- Função para parar o Auto Roll
    local function StopAutoRoll()
        Features.isAutoRolling = false
    end
    
    -- Infinite Spins (método bypass)
    local InfiniteSpinsToggle = CreateToggle(TeamPage.content, UDim2.new(0, 10, 0, 10), "Infinite Spins", false, function(value)
        if value then
            -- Implementação do Infinite Spins
            SafeFuncs.spawn(function()
                -- Procura por limitadores de spin
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("ModuleScript") and (obj.Name:lower():find("spin") or obj.Name:lower():find("currency")) then
                        local success, module = pcall(require, obj)
                        
                        if success and typeof(module) == "table" then
                            -- Tenta modificar valores relacionados a spin
                            for k, v in pairs(module) do
                                if typeof(k) == "string" then
                                    if k:lower():find("max") or k:lower():find("limit") or k:lower():find("cost") then
                                        if typeof(v) == "number" then
                                            module[k] = 0 -- Custo zero
                                        end
                                    elseif k:lower():find("cooldown") or k:lower():find("delay") then
                                        if typeof(v) == "number" then
                                            module[k] = 0 -- Sem cooldown
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                
                -- Implementa hooks para bypass em remotes
                for _, remote in pairs(Features.spinRemotes) do
                    pcall(function()
                        if remote:IsA("RemoteFunction") then
                            local oldInvoke = remote.InvokeServer
                            
                            remote.InvokeServer = function(self, ...)
                                local args = {...}
                                
                                -- Modifica argumentos para garantir sucesso
                                if #args > 0 and typeof(args[1]) == "table" and args[1].cost then
                                    args[1].cost = 0
                                end
                                
                                return oldInvoke(self, unpack(args))
                            end
                        elseif remote:IsA("RemoteEvent") then
                            local oldFire = remote.FireServer
                            
                            remote.FireServer = function(self, ...)
                                local args = {...}
                                
                                -- Modifica argumentos para garantir sucesso
                                if #args > 0 and typeof(args[1]) == "table" and args[1].cost then
                                    args[1].cost = 0
                                end
                                
                                return oldFire(self, unpack(args))
                            end
                        end
                    end)
                end
            end)
        end
    end)
    
    -- 100x Lucky (aumenta chances para personagens raros)
    local LuckyToggle = CreateToggle(TeamPage.content, UDim2.new(0, 10, 0, 60), "100x Lucky", false, function(value)
        if value then
            -- Implementação do 100x Lucky
            SafeFuncs.spawn(function()
                -- Procura por tabelas de probabilidade
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("ModuleScript") and (
                        obj.Name:lower():find("probability") or 
                        obj.Name:lower():find("chance") or 
                        obj.Name:lower():find("rate") or
                        obj.Name:lower():find("gacha") or
                        obj.Name:lower():find("drop")) then
                        
                        local success, module = pcall(require, obj)
                        
                        if success and typeof(module) == "table" then
                            -- Tenta modificar valores de probabilidade
                            for k, v in pairs(module) do
                                if typeof(v) == "number" and v > 0 and v < 0.3 then
                                    -- Aumenta a chance em 100x, mas no máximo até 80%
                                    module[k] = math.min(v * 100, 0.8)
                                    print("XESTEER HUB: Aumentada probabilidade para " .. tostring(k) .. " de " .. tostring(v) .. " para " .. tostring(module[k]))
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
    
    -- Auto Roll com dropdown de personagens
    local AutoRollToggle = CreateToggle(TeamPage.content, UDim2.new(0, 10, 0, 110), "Auto Roll", false, function(value)
        if value then
            SetupAutoRoll()
        else
            StopAutoRoll()
        end
    end)
    
    -- Página de SuperPowers
    local SuperPowersPage = pagePanels.SuperPowers
    
    -- Super Chute Explosivo
    local SuperKickToggle = CreateToggle(SuperPowersPage.content, UDim2.new(0, 10, 0, 10), "Super Chute Explosivo", false, function(value)
        Features.isSuperKickEnabled = value
        if value then
            -- Implementação do Super Chute
            SafeFuncs.spawn(function()
                while Features.isSuperKickEnabled do
                    local success, error = pcall(function()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = LocalPlayer.Character.HumanoidRootPart
                            local ballPart = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("SoccerBall")
                            
                            if ballPart and (ballPart.Position - hrp.Position).Magnitude < 10 then
                                -- Adiciona efeito visual de explosão
                                local explosion = Instance.new("Explosion")
                                explosion.BlastRadius = 0 -- Não causa dano
                                explosion.BlastPressure = 0
                                explosion.Position = ballPart.Position
                                explosion.ExplosionType = Enum.ExplosionType.NoCraters
                                explosion.DestroyJointRadiusPercent = 0
                                explosion.Parent = workspace
                                
                                -- Aplica força na bola
                                local lookDirection = hrp.CFrame.LookVector
                                ballPart.Velocity = lookDirection * Features.superKickPower
                                
                                -- Efeito de trilha
                                pcall(function()
                                    local trail = Instance.new("Trail")
                                    trail.Lifetime = 1
                                    trail.Color = ColorSequence.new(Colors.Primary)
                                    trail.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 0),
                                        NumberSequenceKeypoint.new(1, 1)
                                    })
                                    trail.Parent = ballPart
                                    
                                    -- Remove a trilha após 2 segundos
                                    SafeFuncs.delay(2, function()
                                        trail:Destroy()
                                    end)
                                end)
                            end
                        end
                    end)
                    
                    SafeFuncs.wait(0.1)
                end
            end)
        end
    end)
    
    -- Controle de potência do chute
    local SuperKickPowerSlider = CreateSlider(SuperPowersPage.content, UDim2.new(0, 10, 0, 60), "Potência do Chute", 5, 500, Features.superKickPower, function(value)
        Features.superKickPower = value
    end)
    
    -- Modo Fantasma (atravessar paredes)
    local GhostModeToggle = CreateToggle(SuperPowersPage.content, UDim2.new(0, 10, 0, 120), "Modo Fantasma", false, function(value)
        Features.isGhostModeEnabled = value
        if value then
            -- Implementação do Modo Fantasma
            SafeFuncs.spawn(function()
                while Features.isGhostModeEnabled do
                    pcall(function()
                        if LocalPlayer.Character then
                            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                    -- Efeito visual de transparência
                                    part.Transparency = 0.5
                                end
                            end
                        end
                    end)
                    
                    SafeFuncs.wait(0.1)
                end
                
                -- Restaura a colisão quando desativado
                pcall(function()
                    if LocalPlayer.Character then
                        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                part.CanCollide = true
                                part.Transparency = 0
                            end
                        end
                    end
                end)
            end)
        end
    end)
    
    -- Speed Burst (corrida em supervelocidade)
    local SpeedBurstToggle = CreateToggle(SuperPowersPage.content, UDim2.new(0, 10, 0, 170), "Speed Burst", false, function(value)
        Features.isSpeedBurstEnabled = value
        if value then
            -- Implementação do Speed Burst
            SafeFuncs.spawn(function()
                local originalSpeed = 16
                
                -- Obtém a velocidade original
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        originalSpeed = LocalPlayer.Character.Humanoid.WalkSpeed
                    end
                end)
                
                while Features.isSpeedBurstEnabled do
                    pcall(function()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            -- Aumenta a velocidade
                            LocalPlayer.Character.Humanoid.WalkSpeed = originalSpeed * Features.speedMultiplier
                            
                            -- Efeito visual de velocidade
                            if not LocalPlayer.Character:FindFirstChild("SpeedEffect") then
                                pcall(function()
                                    local speedEffect = Instance.new("ParticleEmitter")
                                    speedEffect.Name = "SpeedEffect"
                                    speedEffect.Speed = NumberRange.new(5, 10)
                                    speedEffect.Lifetime = NumberRange.new(0.5, 1)
                                    speedEffect.Color = ColorSequence.new(Colors.Primary)
                                    speedEffect.Rate = 20
                                    speedEffect.Parent = LocalPlayer.Character.HumanoidRootPart
                                end)
                            end
                        end
                    end)
                    
                    SafeFuncs.wait(0.1)
                end
                
                -- Restaura a velocidade quando desativado
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid.WalkSpeed = originalSpeed
                        
                        -- Remove o efeito visual
                        if LocalPlayer.Character:FindFirstChild("SpeedEffect") then
                            LocalPlayer.Character.SpeedEffect:Destroy()
                        end
                    end
                end)
            end)
        end
    end)
    
    -- Controle de multiplicador de velocidade
    local SpeedMultiplierSlider = CreateSlider(SuperPowersPage.content, UDim2.new(0, 10, 0, 220), "Multiplicador de Velocidade", 1, 10, Features.speedMultiplier, function(value)
        Features.speedMultiplier = value
    end)
    
    -- Modo Deuses do Futebol
    local FootballGodToggle = CreateToggle(SuperPowersPage.content, UDim2.new(0, 10, 0, 270), "Modo Deuses do Futebol", false, function(value)
        Features.isFootballGodEnabled = value
        if value then
            -- Implementação do Modo Deuses do Futebol
            SafeFuncs.spawn(function()
                -- Definição de poderes especiais para cada personagem
                local godPowers = {
                    ["Isagi Yoichi"] = function(character, ball)
                        -- Poder: Spatial Awareness (previsão de trajetória)
                        if ball then
                            -- Cria linha de previsão
                            local prediction = Instance.new("Part")
                            prediction.Name = "PredictionLine"
                            prediction.Anchored = true
                            prediction.CanCollide = false
                            prediction.Size = Vector3.new(0.2, 0.2, 30)
                            prediction.Material = Enum.Material.Neon
                            prediction.Color = Color3.fromRGB(0, 255, 255)
                            prediction.CFrame = CFrame.new(ball.Position, ball.Position + ball.Velocity.Unit * 30)
                            prediction.Transparency = 0.7
                            prediction.Parent = workspace
                            
                            -- Remove após 2 segundos
                            SafeFuncs.delay(2, function()
                                prediction:Destroy()
                            end)
                        end
                    end,
                    
                    ["Bachira Meguru"] = function(character, ball)
                        -- Poder: Dribble Monstro (movimento errático)
                        if character and character:FindFirstChild("Humanoid") then
                            -- Aumenta agilidade
                            local originalSpeed = character.Humanoid.WalkSpeed
                            character.Humanoid.WalkSpeed = originalSpeed * 1.5
                            
                            -- Efeito visual
                            pcall(function()
                                local effect = Instance.new("ParticleEmitter")
                                effect.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
                                effect.Lifetime = NumberRange.new(0.5, 1)
                                effect.Parent = character.HumanoidRootPart
                                
                                SafeFuncs.delay(2, function()
                                    effect:Destroy()
                                    character.Humanoid.WalkSpeed = originalSpeed
                                end)
                            end)
                        end
                    end,
                    
                    ["Rin Itoshi"] = function(character, ball)
                        -- Poder: Chute Perfeito (sempre acerta o gol)
                        if ball and character then
                            local goalPart = workspace:FindFirstChild("Goal") or workspace:FindFirstChild("GoalPart")
                            
                            if goalPart then
                                -- Calcula trajetória para o gol
                                local goalDirection = (goalPart.Position - ball.Position).Unit
                                ball.Velocity = goalDirection * 150
                                
                                -- Efeito visual
                                local trail = Instance.new("Trail")
                                trail.Lifetime = 1
                                trail.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
                                trail.Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 0),
                                    NumberSequenceKeypoint.new(1, 1)
                                })
                                trail.Parent = ball
                                
                                SafeFuncs.delay(3, function()
                                    trail:Destroy()
                                end)
                            end
                        end
                    end
                }
                
                while Features.isFootballGodEnabled do
                    pcall(function()
                        local character = LocalPlayer.Character
                        local ball = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("SoccerBall")
                        
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            -- Detecta qual jogador está sendo usado pelo nome ou aparência
                            local currentCharacter = Features.selectedGodPower
                            
                            -- Executa o poder especial
                            if godPowers[currentCharacter] then
                                godPowers[currentCharacter](character, ball)
                            else
                                -- Poder padrão se não reconhecer o personagem
                                if ball and (ball.Position - character.HumanoidRootPart.Position).Magnitude < 10 then
                                    ball.Velocity = character.HumanoidRootPart.CFrame.LookVector * 100
                                end
                            end
                        end
                    end)
                    
                    SafeFuncs.wait(2) -- Intervalo entre usos do poder
                end
            end)
        end
    end)
    
    -- Seletor de Poder de Deus
    local godPowersList = {"Isagi Yoichi", "Bachira Meguru", "Rin Itoshi", "Nagi Seishiro", "Barou Shouei"}
    local GodPowerDropdown = CreateDropdown(SuperPowersPage.content, UDim2.new(0, 10, 0, 320), "Selecionar Poder de Deus", godPowersList, function(selected)
        Features.selectedGodPower = selected
    end)
    
    -- Super Pulo
    local SuperJumpToggle = CreateToggle(SuperPowersPage.content, UDim2.new(0, 10, 0, 380), "Super Pulo", false, function(value)
        Features.isSuperJumpEnabled = value
        if value then
            -- Implementação do Super Pulo
            SafeFuncs.spawn(function()
                local originalJump = 50
                
                -- Obtém a força de pulo original
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        originalJump = LocalPlayer.Character.Humanoid.JumpPower
                    end
                end)
                
                while Features.isSuperJumpEnabled do
                    pcall(function()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            -- Aumenta a força de pulo
                            LocalPlayer.Character.Humanoid.JumpPower = originalJump * Features.jumpHeight
                            
                            -- Efeito visual ao pular
                            LocalPlayer.Character.Humanoid.Jumping:Connect(function(active)
                                if active then
                                    pcall(function()
                                        local jumpEffect = Instance.new("Part")
                                        jumpEffect.Size = Vector3.new(3, 0.2, 3)
                                        jumpEffect.Transparency = 0.5
                                        jumpEffect.CanCollide = false
                                        jumpEffect.Anchored = true
                                        jumpEffect.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3, 0)
                                        jumpEffect.Material = Enum.Material.Neon
                                        jumpEffect.Color = Colors.Primary
                                        jumpEffect.Parent = workspace
                                        
                                        -- Animação e remoção
                                        for i = 1, 10 do
                                            jumpEffect.Transparency = 0.5 + (i * 0.05)
                                            jumpEffect.Size = jumpEffect.Size + Vector3.new(0.5, 0, 0.5)
                                            SafeFuncs.wait(0.05)
                                        end
                                        
                                        jumpEffect:Destroy()
                                    end)
                                end
                            end)
                        end
                    end)
                    
                    SafeFuncs.wait(0.1)
                end
                
                -- Restaura a força de pulo quando desativado
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid.JumpPower = originalJump
                    end
                end)
            end)
        end
    end)
    
    -- Controle de Área (sistema para dominar a área do gol)
    local AreaControlToggle = CreateToggle(SuperPowersPage.content, UDim2.new(0, 10, 0, 430), "Controle de Área", false, function(value)
        Features.isAreaControlEnabled = value
        if value then
            -- Implementação do Controle de Área
            SafeFuncs.spawn(function()
                while Features.isAreaControlEnabled do
                    pcall(function()
                        local goalPart = workspace:FindFirstChild("Goal") or workspace:FindFirstChild("GoalPart")
                        
                        if goalPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            -- Define área de controle (10 studs ao redor do gol)
                            local hrp = LocalPlayer.Character.HumanoidRootPart
                            local areaRadius = 15
                            
                            -- Visualização da área de controle
                            if not workspace:FindFirstChild("ControlArea") then
                                local areaVisual = Instance.new("Part")
                                areaVisual.Name = "ControlArea"
                                areaVisual.Anchored = true
                                areaVisual.CanCollide = false
                                areaVisual.Size = Vector3.new(areaRadius * 2, 0.2, areaRadius * 2)
                                areaVisual.CFrame = CFrame.new(goalPart.Position) * CFrame.new(0, -2, 0)
                                areaVisual.Shape = Enum.PartType.Cylinder
                                areaVisual.Material = Enum.Material.ForceField
                                areaVisual.Color = Colors.Primary
                                areaVisual.Transparency = 0.7
                                areaVisual.Parent = workspace
                            end
                            
                            -- Teleporta jogadores para fora da área
                            for _, player in pairs(Players:GetPlayers()) do
                                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                    local playerHrp = player.Character.HumanoidRootPart
                                    local distanceToGoal = (playerHrp.Position - goalPart.Position).Magnitude
                                    
                                    if distanceToGoal < areaRadius then
                                        -- Jogador está na área de controle, empurra para fora
                                        local direction = (playerHrp.Position - goalPart.Position).Unit
                                        local targetPosition = goalPart.Position + (direction * (areaRadius + 5))
                                        
                                        -- Aplica força ao jogador
                                        pcall(function()
                                            player.Character:PivotTo(CFrame.new(targetPosition))
                                            playerHrp.Velocity = direction * 50
                                            
                                            -- Efeito visual de repulsão
                                            local repelEffect = Instance.new("Part")
                                            repelEffect.Size = Vector3.new(1, 1, 1)
                                            repelEffect.Transparency = 0.5
                                            repelEffect.CanCollide = false
                                            repelEffect.Anchored = true
                                            repelEffect.Shape = Enum.PartType.Ball
                                            repelEffect.Material = Enum.Material.Neon
                                            repelEffect.Color = Color3.fromRGB(255, 0, 0)
                                            repelEffect.CFrame = playerHrp.CFrame
                                            repelEffect.Parent = workspace
                                            
                                            -- Animação e remoção
                                            SafeFuncs.spawn(function()
                                                for i = 1, 10 do
                                                    repelEffect.Transparency = 0.5 + (i * 0.05)
                                                    repelEffect.Size = repelEffect.Size + Vector3.new(0.3, 0.3, 0.3)
                                                    SafeFuncs.wait(0.03)
                                                end
                                                
                                                repelEffect:Destroy()
                                            end)
                                        end)
                                    end
                                end
                            end
                        end
                    end)
                    
                    SafeFuncs.wait(0.2)
                end
                
                -- Remove visualização da área quando desativado
                if workspace:FindFirstChild("ControlArea") then
                    workspace.ControlArea:Destroy()
                end
            end)
        else
            -- Remove visualização da área quando desativado
            if workspace:FindFirstChild("ControlArea") then
                workspace.ControlArea:Destroy()
            end
        end
    end)
    
    -- Dropdown de personagens
    local CharacterDropdown = CreateDropdown(TeamPage.content, UDim2.new(0, 10, 0, 160), "Target Character", BlueLockCharacters, function(selected)
        Features.targetCharacter = selected
        print("XESTEER HUB: Personagem alvo definido para " .. selected)
    end)
    
    -- Página ESP
    local ESPPage = pagePanels.ESP
    
    -- Player ESP
    local PlayerESPToggle = CreateToggle(ESPPage.content, UDim2.new(0, 10, 0, 10), "Player ESP", false, function(value)
        if value then
            -- Implementação do Player ESP
            SafeFuncs.spawn(function()
                local espObjects = {}
                
                local function createESP(player)
                    if player == LocalPlayer then return end
                    
                    local espFolder = player.Name .. "_ESP"
                    if workspace:FindFirstChild(espFolder) then return end
                    
                    local folder = Create("Folder")({
                        Name = espFolder,
                        Parent = workspace
                    })
                    
                    espObjects[player] = folder
                    
                    RunService.RenderStepped:Connect(function()
                        if not player or not player.Character or not folder or not folder.Parent then return end
                        
                        if not folder:FindFirstChild("Box") and player.Character:FindFirstChild("HumanoidRootPart") then
                            local box = Create("BoxHandleAdornment")({
                                Name = "Box",
                                Size = Vector3.new(4, 5, 1),
                                Color3 = Color3.fromRGB(255, 0, 0),
                                Transparency = 0.7,
                                AlwaysOnTop = true,
                                Adornee = player.Character.HumanoidRootPart,
                                ZIndex = 10,
                                Parent = folder
                            })
                            
                            local nameTag = Create("BillboardGui")({
                                Name = "NameTag",
                                Size = UDim2.new(0, 100, 0, 30),
                                AlwaysOnTop = true,
                                StudsOffset = Vector3.new(0, 2, 0),
                                Adornee = player.Character.Head,
                                Parent = folder
                            })
                            
                            local nameLabel = Create("TextLabel")({
                                Size = UDim2.new(1, 0, 1, 0),
                                BackgroundTransparency = 1,
                                TextColor3 = Color3.fromRGB(255, 0, 0),
                                TextStrokeTransparency = 0,
                                TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
                                Text = player.Name,
                                TextSize = 12,
                                Font = Enum.Font.Gotham,
                                Parent = nameTag
                            })
                        end
                    end)
                end
                
                -- Cria ESP para jogadores existentes
                for _, player in pairs(Players:GetPlayers()) do
                    createESP(player)
                end
                
                -- Cria ESP para novos jogadores
                Players.PlayerAdded:Connect(createESP)
                
                -- Remove ESP de jogadores que saíram
                Players.PlayerRemoving:Connect(function(player)
                    if espObjects[player] then
                        espObjects[player]:Destroy()
                        espObjects[player] = nil
                    end
                end)
            end)
        else
            -- Remove ESPs
            for _, player in pairs(Players:GetPlayers()) do
                local espFolder = workspace:FindFirstChild(player.Name .. "_ESP")
                if espFolder then
                    espFolder:Destroy()
                end
            end
        end
    end)
    
    -- Ball ESP
    local BallESPToggle = CreateToggle(ESPPage.content, UDim2.new(0, 10, 0, 60), "Ball ESP", false, function(value)
        if value then
            -- Implementação do Ball ESP
            SafeFuncs.spawn(function()
                if workspace:FindFirstChild("BallESP") then
                    workspace.BallESP:Destroy()
                end
                
                local ballEspFolder = Create("Folder")({
                    Name = "BallESP",
                    Parent = workspace
                })
                
                RunService.RenderStepped:Connect(function()
                    if not ballEspFolder or not ballEspFolder.Parent then return end
                    
                    -- Procura a bola
                    local ball = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("SoccerBall")
                    
                    if ball and not ballEspFolder:FindFirstChild("BallHighlight") then
                        local highlight = Create("Highlight")({
                            Name = "BallHighlight",
                            OutlineColor = Color3.fromRGB(255, 50, 50),
                            FillColor = Color3.fromRGB(255, 0, 0),
                            FillTransparency = 0.7,
                            OutlineTransparency = 0,
                            Adornee = ball,
                            Parent = ballEspFolder
                        })
                        
                        local tracePart = Create("Part")({
                            Name = "BallTrace",
                            Size = Vector3.new(0.5, 0.5, 0.5),
                            Anchored = true,
                            CanCollide = false,
                            Transparency = 0.3,
                            Material = Enum.Material.Neon,
                            Color = Color3.fromRGB(255, 0, 0),
                            Parent = ballEspFolder
                        })
                        
                        RunService.RenderStepped:Connect(function()
                            if tracePart and tracePart.Parent and ball and ball.Parent then
                                tracePart.CFrame = ball.CFrame
                            end
                        end)
                    end
                end)
            end)
        else
            -- Remove Ball ESP
            if workspace:FindFirstChild("BallESP") then
                workspace.BallESP:Destroy()
            end
        end
    end)
    
    -- Team ESP (diferencia times)
    local TeamESPToggle = CreateToggle(ESPPage.content, UDim2.new(0, 10, 0, 110), "Team ESP", false, function(value)
        if value then
            -- Implementação do Team ESP
            SafeFuncs.spawn(function()
                local teamEspObjects = {}
                
                local function createTeamESP(player)
                    if player == LocalPlayer then return end
                    
                    local teamEspFolder = player.Name .. "_TeamESP"
                    if workspace:FindFirstChild(teamEspFolder) then return end
                    
                    local folder = Create("Folder")({
                        Name = teamEspFolder,
                        Parent = workspace
                    })
                    
                    teamEspObjects[player] = folder
                    
                    -- Determina o time do jogador
                    local isTeammate = false
                    pcall(function()
                        isTeammate = player.Team == LocalPlayer.Team
                    end)
                    
                    local teamColor = isTeammate and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                    
                    RunService.RenderStepped:Connect(function()
                        if not player or not player.Character or not folder or not folder.Parent then return end
                        
                        if not folder:FindFirstChild("Highlight") and player.Character then
                            local highlight = Create("Highlight")({
                                Name = "Highlight",
                                OutlineColor = teamColor,
                                FillColor = teamColor,
                                FillTransparency = 0.7,
                                OutlineTransparency = 0.3,
                                Adornee = player.Character,
                                Parent = folder
                            })
                            
                            local nameTag = Create("BillboardGui")({
                                Name = "NameTag",
                                Size = UDim2.new(0, 100, 0, 30),
                                AlwaysOnTop = true,
                                StudsOffset = Vector3.new(0, 2, 0),
                                Adornee = player.Character:FindFirstChild("Head"),
                                Parent = folder
                            })
                            
                            local nameLabel = Create("TextLabel")({
                                Size = UDim2.new(1, 0, 1, 0),
                                BackgroundTransparency = 1,
                                TextColor3 = teamColor,
                                TextStrokeTransparency = 0,
                                TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
                                Text = player.Name .. " [" .. (isTeammate and "ALLY" or "ENEMY") .. "]",
                                TextSize = 12,
                                Font = Enum.Font.Gotham,
                                Parent = nameTag
                            })
                        end
                    end)
                end
                
                -- Cria Team ESP para jogadores existentes
                for _, player in pairs(Players:GetPlayers()) do
                    createTeamESP(player)
                end
                
                -- Cria Team ESP para novos jogadores
                Players.PlayerAdded:Connect(createTeamESP)
                
                -- Remove Team ESP de jogadores que saíram
                Players.PlayerRemoving:Connect(function(player)
                    if teamEspObjects[player] then
                        teamEspObjects[player]:Destroy()
                        teamEspObjects[player] = nil
                    end
                end)
            end)
        else
            -- Remove Team ESPs
            for _, player in pairs(Players:GetPlayers()) do
                local teamEspFolder = workspace:FindFirstChild(player.Name .. "_TeamESP")
                if teamEspFolder then
                    teamEspFolder:Destroy()
                end
            end
        end
    end)
    
    -- Página Styles
    local StylesPage = pagePanels.Styles
    
    -- Speed Multiplier
    local SpeedSlider = CreateSlider(StylesPage.content, UDim2.new(0, 10, 0, 10), "Speed Multiplier", 1, 10, 1, function(value)
        -- Implementação do Speed Multiplier
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16 * value -- 16 é a velocidade normal
        end
    end)
    
    -- Jump Power
    local JumpSlider = CreateSlider(StylesPage.content, UDim2.new(0, 10, 0, 80), "Jump Power", 50, 250, 50, function(value)
        -- Implementação do Jump Power
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end)
    
    -- No Clip
    local NoClipToggle = CreateToggle(StylesPage.content, UDim2.new(0, 10, 0, 150), "No Clip", false, function(value)
        Features.wallsDisabled = value
        
        if value then
            -- Implementação do No Clip
            SafeFuncs.spawn(function()
                local noclipConnection
                
                noclipConnection = RunService.Stepped:Connect(function()
                    if not Features.wallsDisabled then
                        if noclipConnection then
                            noclipConnection:Disconnect()
                            noclipConnection = nil
                        end
                        return
                    end
                    
                    if LocalPlayer.Character then
                        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") and part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            end)
        end
    end)
    
    -- Fly
    local FlyToggle = CreateToggle(StylesPage.content, UDim2.new(0, 10, 0, 200), "Fly", false, function(value)
        if value then
            -- Implementação do Fly
            SafeFuncs.spawn(function()
                local flySpeed = 1
                local flyAlready = false
                
                if flyAlready then return end
                flyAlready = true
                
                local flyPart = Create("Part")({
                    Name = "FlyPart",
                    Size = Vector3.new(1, 1, 1),
                    Transparency = 1,
                    Anchored = true,
                    CanCollide = false,
                    Parent = workspace
                })
                
                local weld = Create("Weld")({
                    Name = "FlyWeld",
                    Part0 = flyPart,
                    Part1 = LocalPlayer.Character:FindFirstChild("HumanoidRootPart"),
                    Parent = flyPart
                })
                
                local controlModule = {}
                controlModule.Forward = 0
                controlModule.Backward = 0
                controlModule.Left = 0
                controlModule.Right = 0
                controlModule.Up = 0
                controlModule.Down = 0
                
                local inputConnection
                inputConnection = UserInputService.InputBegan:Connect(function(input, processed)
                    if processed then return end
                    
                    if input.KeyCode == Enum.KeyCode.W then
                        controlModule.Forward = 1
                    elseif input.KeyCode == Enum.KeyCode.S then
                        controlModule.Backward = 1
                    elseif input.KeyCode == Enum.KeyCode.A then
                        controlModule.Left = 1
                    elseif input.KeyCode == Enum.KeyCode.D then
                        controlModule.Right = 1
                    elseif input.KeyCode == Enum.KeyCode.Space then
                        controlModule.Up = 1
                    elseif input.KeyCode == Enum.KeyCode.LeftControl then
                        controlModule.Down = 1
                    end
                end)
                
                local inputEndConnection
                inputEndConnection = UserInputService.InputEnded:Connect(function(input, processed)
                    if processed then return end
                    
                    if input.KeyCode == Enum.KeyCode.W then
                        controlModule.Forward = 0
                    elseif input.KeyCode == Enum.KeyCode.S then
                        controlModule.Backward = 0
                    elseif input.KeyCode == Enum.KeyCode.A then
                        controlModule.Left = 0
                    elseif input.KeyCode == Enum.KeyCode.D then
                        controlModule.Right = 0
                    elseif input.KeyCode == Enum.KeyCode.Space then
                        controlModule.Up = 0
                    elseif input.KeyCode == Enum.KeyCode.LeftControl then
                        controlModule.Down = 0
                    end
                end)
                
                local renderConnection
                renderConnection = RunService.RenderStepped:Connect(function()
                    if not value then
                        if flyPart then flyPart:Destroy() end
                        if inputConnection then inputConnection:Disconnect() end
                        if inputEndConnection then inputEndConnection:Disconnect() end
                        if renderConnection then renderConnection:Disconnect() end
                        flyAlready = false
                        return
                    end
                    
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = LocalPlayer.Character.HumanoidRootPart
                        local lookVec = workspace.CurrentCamera.CFrame.LookVector
                        local rightVec = workspace.CurrentCamera.CFrame.RightVector
                        
                        flyPart.CFrame = CFrame.new(
                            flyPart.Position,
                            flyPart.Position + lookVec
                        )
                        
                        local moveDirection = Vector3.new(
                            controlModule.Right - controlModule.Left,
                            controlModule.Up - controlModule.Down,
                            controlModule.Forward - controlModule.Backward
                        ).Unit * flySpeed
                        
                        if moveDirection.Magnitude > 0 then
                            flyPart.CFrame = flyPart.CFrame * CFrame.new(moveDirection)
                        end
                    end
                end)
            end)
        end
    end)
    
    -- Página Visual
    local VisualPage = pagePanels.Visual
    
    -- FPS Boost
    local FPSBoostToggle = CreateToggle(VisualPage.content, UDim2.new(0, 10, 0, 10), "FPS Boost", false, function(value)
        if value then
            -- Implementação do FPS Boost
            SafeFuncs.spawn(function()
                -- Salva configurações originais
                local originalSettings = {}
                originalSettings.GlobalShadows = Lighting.GlobalShadows
                originalSettings.Brightness = Lighting.Brightness
                originalSettings.Technology = Lighting.Technology
                
                -- Otimiza iluminação
                Lighting.GlobalShadows = false
                Lighting.Brightness = 1
                Lighting.Technology = Enum.Technology.Compatibility
                
                -- Remove efeitos de post-processing
                for _, effect in pairs(Lighting:GetChildren()) do
                    if effect:IsA("BloomEffect") or 
                       effect:IsA("BlurEffect") or 
                       effect:IsA("DepthOfFieldEffect") or 
                       effect:IsA("SunRaysEffect") then
                        effect.Enabled = false
                    end
                end
                
                -- Remove detalhes dos modelos 3D
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and not obj:IsA("Terrain") then
                        obj.CastShadow = false
                    elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                        obj.Enabled = false
                    elseif obj:IsA("Decal") and obj.Name ~= "face" then
                        obj.Transparency = 0.5
                    elseif obj:IsA("PointLight") or obj:IsA("SurfaceLight") or obj:IsA("SpotLight") then
                        obj.Range = obj.Range * 0.5
                        obj.Brightness = obj.Brightness * 0.5
                        obj.Shadows = false
                    end
                end
                
                -- Configura qualidade gráfica
                pcall(function()
                    UserSettings():GetService("UserGameSettings").MasterVolume = 0
                    UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualityLevel.Level01
                    
                    settings().Rendering.QualityLevel = 1
                    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
                end)
                
                -- Garbage Collection regularmente
                while value do
                    collectgarbage("collect")
                    SafeFuncs.wait(10)
                end
                
                -- Restaura configurações quando desligado
                if not value then
                    Lighting.GlobalShadows = originalSettings.GlobalShadows
                    Lighting.Brightness = originalSettings.Brightness
                    Lighting.Technology = originalSettings.Technology
                end
            end)
        end
    end)
    
    -- Full Bright
    local FullBrightToggle = CreateToggle(VisualPage.content, UDim2.new(0, 10, 0, 60), "Full Bright", false, function(value)
        if value then
            -- Implementação do Full Bright
            SafeFuncs.spawn(function()
                local originalAmbient = Lighting.Ambient
                local originalBrightness = Lighting.Brightness
                local originalClockTime = Lighting.ClockTime
                
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                
                while value do
                    Lighting.Brightness = 2
                    SafeFuncs.wait(1)
                end
                
                -- Restaura quando desligado
                if not value then
                    Lighting.Ambient = originalAmbient
                    Lighting.Brightness = originalBrightness
                    Lighting.ClockTime = originalClockTime
                end
            end)
        end
    end)
    
    -- Field Transparency
    local FieldTransparencyToggle = CreateToggle(VisualPage.content, UDim2.new(0, 10, 0, 110), "Field Transparency", false, function(value)
        if value then
            -- Implementação do Field Transparency
            SafeFuncs.spawn(function()
                -- Procura pelo campo
                local fieldParts = {}
                
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (
                        obj.Name:lower():find("field") or 
                        obj.Name:lower():find("grass") or 
                        obj.Name:lower():find("floor") or
                        obj.Name:lower():find("ground")
                    ) then
                        if obj.Size.Y < 1 and obj.Size.X > 10 and obj.Size.Z > 10 then
                            table.insert(fieldParts, obj)
                            obj.Transparency = 0.7
                        end
                    end
                end
                
                -- Restaura quando desligado
                if not value then
                    for _, part in pairs(fieldParts) do
                        if part and part.Parent then
                            part.Transparency = 0
                        end
                    end
                end
            end)
        end
    end)
    
    -- Rainbow Ball
    local RainbowBallToggle = CreateToggle(VisualPage.content, UDim2.new(0, 10, 0, 160), "Rainbow Ball", false, function(value)
        if value then
            -- Implementação do Rainbow Ball
            SafeFuncs.spawn(function()
                local originalColor = nil
                local ballPart = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("SoccerBall")
                
                if ballPart and ballPart:IsA("BasePart") then
                    originalColor = ballPart.Color
                    
                    while value do
                        local hue = (tick() % 5) / 5
                        local color = Color3.fromHSV(hue, 1, 1)
                        
                        if ballPart and ballPart.Parent then
                            ballPart.Color = color
                            
                            -- Adiciona também brilho
                            if not ballPart:FindFirstChild("RainbowEffect") then
                                local effect = Create("PointLight")({
                                    Name = "RainbowEffect",
                                    Color = color,
                                    Brightness = 5,
                                    Range = 10,
                                    Parent = ballPart
                                })
                            else
                                ballPart.RainbowEffect.Color = color
                            end
                        else
                            -- Procura a bola novamente se perdida
                            ballPart = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("SoccerBall")
                        end
                        
                        SafeFuncs.wait(0.1)
                    end
                    
                    -- Restaura quando desligado
                    if ballPart and ballPart.Parent and originalColor then
                        ballPart.Color = originalColor
                        
                        if ballPart:FindFirstChild("RainbowEffect") then
                            ballPart.RainbowEffect:Destroy()
                        end
                    end
                end
            end)
        end
    end)
    
    -- Página Settings
    local SettingsPage = pagePanels.Settings
    
    -- Restore Character
    local RestoreCharButton = CreateButtonWithArrow(SettingsPage.content, UDim2.new(0, 10, 0, 10), "Restore Character", function()
        if LocalPlayer.Character then
            LocalPlayer.Character:BreakJoints()
        end
    end)
    
    -- Reset All Hacks
    local ResetHacksButton = CreateButtonWithArrow(SettingsPage.content, UDim2.new(0, 10, 0, 60), "Reset All Hacks", function()
        -- Desativa todos os toggles
        AutoGoalToggle.setValue(false)
        AutoStealToggle.setValue(false)
        AutoTPBallToggle.setValue(false)
        PlayerESPToggle.setValue(false)
        BallESPToggle.setValue(false)
        TeamESPToggle.setValue(false)
        InfiniteSpinsToggle.setValue(false)
        LuckyToggle.setValue(false)
        AutoRollToggle.setValue(false)
        NoClipToggle.setValue(false)
        FlyToggle.setValue(false)
        FPSBoostToggle.setValue(false)
        FullBrightToggle.setValue(false)
        FieldTransparencyToggle.setValue(false)
        RainbowBallToggle.setValue(false)
        
        -- Reseta sliders
        SpeedSlider.setValue(1)
        JumpSlider.setValue(50)
    end)
    
    -- Theme Color
    local ThemeToggle = CreateToggle(SettingsPage.content, UDim2.new(0, 10, 0, 110), "Red/Blue Theme", false, function(value)
        if value then
            -- Muda para tema azul
            Colors.Primary = Color3.fromRGB(0, 120, 255)
            Colors.Accent = Color3.fromRGB(0, 80, 200)
            Colors.Highlight = Color3.fromRGB(0, 150, 255)
            Colors.Error = Color3.fromRGB(0, 100, 255)
            
            -- Atualiza cores da interface
            MainStroke.Color = Colors.Primary
            LogoContainer.BackgroundColor3 = Colors.Primary
            HubTitle.TextColor3 = Colors.Primary
            NavSeparator.BackgroundColor3 = Colors.Primary
            
            -- Atualiza botões selecionados
            for _, buttonData in pairs(navButtons) do
                if buttonData.button.BackgroundColor3 == Color3.fromRGB(255, 0, 0) then
                    buttonData.button.BackgroundColor3 = Colors.Primary
                    buttonData.icon.ImageColor3 = Colors.Primary
                    buttonData.text.TextColor3 = Colors.Primary
                end
            end
            
            -- Atualiza outros elementos
            for _, obj in pairs(MainFrame:GetDescendants()) do
                if obj:IsA("Frame") and obj.BackgroundColor3 == Color3.fromRGB(255, 0, 0) then
                    obj.BackgroundColor3 = Colors.Primary
                elseif obj:IsA("TextLabel") and obj.TextColor3 == Color3.fromRGB(255, 0, 0) then
                    obj.TextColor3 = Colors.Primary
                elseif obj:IsA("UIStroke") and obj.Color == Color3.fromRGB(255, 0, 0) then
                    obj.Color = Colors.Primary
                end
            end
        else
            -- Retorna para tema vermelho
            Colors.Primary = Color3.fromRGB(255, 0, 0)
            Colors.Accent = Color3.fromRGB(200, 0, 0)
            Colors.Highlight = Color3.fromRGB(255, 0, 0)
            Colors.Error = Color3.fromRGB(255, 0, 80)
            
            -- Atualiza cores da interface
            MainStroke.Color = Colors.Primary
            LogoContainer.BackgroundColor3 = Colors.Primary
            HubTitle.TextColor3 = Colors.Primary
            NavSeparator.BackgroundColor3 = Colors.Primary
            
            -- Atualiza botões selecionados
            for _, buttonData in pairs(navButtons) do
                if buttonData.button.BackgroundColor3 == Color3.fromRGB(0, 120, 255) then
                    buttonData.button.BackgroundColor3 = Colors.Primary
                    buttonData.icon.ImageColor3 = Colors.Primary
                    buttonData.text.TextColor3 = Colors.Primary
                end
            end
            
            -- Atualiza outros elementos
            for _, obj in pairs(MainFrame:GetDescendants()) do
                if obj:IsA("Frame") and obj.BackgroundColor3 == Color3.fromRGB(0, 120, 255) then
                    obj.BackgroundColor3 = Colors.Primary
                elseif obj:IsA("TextLabel") and obj.TextColor3 == Color3.fromRGB(0, 120, 255) then
                    obj.TextColor3 = Colors.Primary
                elseif obj:IsA("UIStroke") and obj.Color == Color3.fromRGB(0, 120, 255) then
                    obj.Color = Colors.Primary
                end
            end
        end
    end)
    
    -- Executor Info
    local ExecutorInfo = Create("TextLabel")({
        Name = "ExecutorInfo",
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 170),
        BackgroundTransparency = 1,
        Text = "Executor: " .. ExecutorName .. " (" .. ExecutorTier .. ")",
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Parent = SettingsPage.content
    })
    
    -- Credit
    local CreditText = Create("TextLabel")({
        Name = "CreditText",
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 220),
        BackgroundTransparency = 1,
        Text = "Xesteer Hub v5.0 - Sem Key - 100% Free",
        TextColor3 = Colors.Primary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Parent = SettingsPage.content
    })
    
    -- Exibe o GUI depois da splash screen
    SafeFuncs.wait(3.5) -- Tempo para a splash screen terminar
    
    return MainFrame
end

-- INICIALIZA O XESTEER HUB
XesteerHub.MainGUI = CreateMainGUI()

-- Mensagem inicial
print("XESTEER HUB: Inicializado com sucesso!")
print("XESTEER HUB: Sem Key - 100% FREE - BLUE LOCK RIVALS")

end)

-- Se ocorreu algum erro na inicialização, exibe mensagem de erro
if not SuccessInit then
    warn("XESTEER HUB: Erro durante a inicialização!")
    warn(ErrorMessage)
    
    -- Tenta exibir uma mensagem de erro mais amigável
    local errorGui = Instance.new("ScreenGui")
    errorGui.Name = "XesteerHubError"
    
    local errorFrame = Instance.new("Frame")
    errorFrame.Size = UDim2.new(0, 300, 0, 150)
    errorFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    errorFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    errorFrame.BorderSizePixel = 0
    errorFrame.Parent = errorGui
    
    local errorCorner = Instance.new("UICorner")
    errorCorner.CornerRadius = UDim.new(0, 10)
    errorCorner.Parent = errorFrame
    
    local errorTitle = Instance.new("TextLabel")
    errorTitle.Size = UDim2.new(1, 0, 0, 30)
    errorTitle.Position = UDim2.new(0, 0, 0, 10)
    errorTitle.BackgroundTransparency = 1
    errorTitle.Text = "XESTEER HUB - ERRO"
    errorTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
    errorTitle.TextSize = 20
    errorTitle.Font = Enum.Font.GothamBold
    errorTitle.Parent = errorFrame
    
    local errorMessage = Instance.new("TextLabel")
    errorMessage.Size = UDim2.new(1, -20, 0, 60)
    errorMessage.Position = UDim2.new(0, 10, 0, 50)
    errorMessage.BackgroundTransparency = 1
    errorMessage.Text = "Ocorreu um erro durante a inicialização.\nTente executar novamente ou use outro executor."
    errorMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
    errorMessage.TextSize = 14
    errorMessage.TextWrapped = true
    errorMessage.Font = Enum.Font.Gotham
    errorMessage.Parent = errorFrame
    
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 100, 0, 30)
    closeButton.Position = UDim2.new(0.5, -50, 1, -40)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.Text = "Fechar"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 14
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = errorFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        errorGui:Destroy()
    end)
    
    -- Tenta exibir o erro
    local success, result = pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(errorGui)
            errorGui.Parent = game:GetService("CoreGui")
        else
            errorGui.Parent = game:GetService("CoreGui")
        end
    end)
    
    if not success then
        errorGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
end

return XesteerHub