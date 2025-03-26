

-- Versão compacta para compartilhamento fácil (use este código para compartilhar)
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/xesteer-hub/blox-fruits/main/xesteer.lua"))()

-- Sistema de carregamento visual (inspirado no estilo HohoV2)
if not game:IsLoaded() then 
    repeat wait() until game:IsLoaded() 
end

-- Verificar se está no jogo Blox Fruits
if game.PlaceId == 2753915549 or game.PlaceId == 4442272183 or game.PlaceId == 7449423635 then
    -- Blox Fruits Detectado - Prossegue com o carregamento
else
    -- Não é Blox Fruits
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "xesteer-hub",
        Text = "Este script é exclusivo para Blox Fruits!",
        Duration = 5
    })
    return
end

-- Verificação de ambiente
if not game then
    print("ERRO: Este script deve ser executado dentro do Roblox com um executor compatível!")
    print("Copie este script e execute-o no jogo Blox Fruits usando Delta, Codex, Fluxus ou outro executor.")
    return
end

-- Criar efeito de carregamento visual estilo HohoV2
local LoadingScreen = Instance.new("ScreenGui")
local Background = Instance.new("Frame")
local StatusText = Instance.new("TextLabel")
local ProgressBar = Instance.new("Frame")
local ProgressFill = Instance.new("Frame")
local Logo = Instance.new("ImageLabel")
local Title = Instance.new("TextLabel")

-- Configurar GUI
LoadingScreen.Name = "XesteerLoadingScreen"
LoadingScreen.Parent = game.CoreGui
LoadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Background.Name = "Background"
Background.Parent = LoadingScreen
Background.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Background.BorderSizePixel = 0
Background.Position = UDim2.new(0, 0, 0, 0)
Background.Size = UDim2.new(1, 0, 1, 0)

StatusText.Name = "StatusText"
StatusText.Parent = Background
StatusText.BackgroundTransparency = 1
StatusText.Position = UDim2.new(0.5, -150, 0.6, 0)
StatusText.Size = UDim2.new(0, 300, 0, 30)
StatusText.Font = Enum.Font.GothamBold
StatusText.Text = "Carregando recursos..."
StatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusText.TextSize = 16
StatusText.TextStrokeTransparency = 0.8

ProgressBar.Name = "ProgressBar"
ProgressBar.Parent = Background
ProgressBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ProgressBar.BorderSizePixel = 0
ProgressBar.Position = UDim2.new(0.5, -150, 0.65, 0)
ProgressBar.Size = UDim2.new(0, 300, 0, 15)

ProgressFill.Name = "ProgressFill"
ProgressFill.Parent = ProgressBar
ProgressFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ProgressFill.BorderSizePixel = 0
ProgressFill.Size = UDim2.new(0, 0, 1, 0)

Logo.Name = "Logo"
Logo.Parent = Background
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.new(0.5, -100, 0.35, -100)
Logo.Size = UDim2.new(0, 200, 0, 200)
Logo.Image = "rbxassetid://14232580420" -- ID da imagem do logo xesteer-hub
Logo.ImageTransparency = 0

Title.Name = "Title"
Title.Parent = Background
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.5, -150, 0.55, -10)
Title.Size = UDim2.new(0, 300, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "XESTEER-HUB V2"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.TextSize = 28
Title.TextStrokeTransparency = 0.8

-- Função para atualizar a barra de progresso
local function UpdateProgress(percent, status)
    ProgressFill:TweenSize(
        UDim2.new(percent/100, 0, 1, 0), 
        Enum.EasingDirection.Out, 
        Enum.EasingStyle.Quad, 
        0.5, 
        true
    )
    StatusText.Text = status
end

-- Sequência de carregamento visual
spawn(function()
    UpdateProgress(10, "Verificando jogo...")
    wait(0.5)
    UpdateProgress(20, "Carregando configurações...")
    wait(0.5)
    UpdateProgress(35, "Preparando interface...")
    wait(0.7)
    UpdateProgress(50, "Inicializando funcionalidades...")
    wait(0.5)
    UpdateProgress(65, "Compilando módulos...")
    wait(0.5)
    UpdateProgress(80, "Carregando recursos visuais...")
    wait(0.6)
    UpdateProgress(95, "Finalizando...")
    wait(0.7)
    UpdateProgress(100, "Carregado com sucesso!")
    wait(1)
    
    -- Efeito de fade out
    for i = 0, 1, 0.1 do
        Background.BackgroundTransparency = i
        StatusText.TextTransparency = i
        ProgressBar.BackgroundTransparency = i
        ProgressFill.BackgroundTransparency = i
        Logo.ImageTransparency = i
        Title.TextTransparency = i
        wait(0.05)
    end
    
    -- Remover GUI
    LoadingScreen:Destroy()
end)

-- Local Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

-- Configuration
local Config = {
    MainFarmEnabled = false,
    StackAutoFarmEnabled = false,
    AutoKatakuriEnabled = false,
    AutoBoneEnabled = false,
    KillAuraEnabled = false,
    AutoDoughKingEnabled = false
}

-- Check if game is Blox Fruits
if game.PlaceId ~= 2753915549 and game.PlaceId ~= 4442272183 and game.PlaceId ~= 7449423635 then
    warn("This script is only for Blox Fruits!")
    return
end

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Utilities
local Utilities = {}

-- Get nearest mob
function Utilities:GetNearestMob(maxDistance)
    local nearestMob = nil
    local shortestDistance = maxDistance or math.huge
    
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            local magnitude = (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if magnitude < shortestDistance then
                shortestDistance = magnitude
                nearestMob = v
            end
        end
    end
    
    return nearestMob
end

-- Get nearest mob by level
function Utilities:GetNearestMobByLevel(playerLevel, maxDistance)
    local nearestMob = nil
    local shortestDistance = maxDistance or math.huge
    
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            -- Check if mob level is near player level (example logic - adjust as needed)
            local mobLevel = tonumber(v.Name:match("%d+")) or 1
            if math.abs(mobLevel - playerLevel) <= 10 then
                local magnitude = (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if magnitude < shortestDistance then
                    shortestDistance = magnitude
                    nearestMob = v
                end
            end
        end
    end
    
    return nearestMob
end

-- Teleport player to position
function Utilities:Teleport(position)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
    
    local tweenInfo = TweenInfo.new(
        (position - humanoidRootPart.Position).Magnitude / 250, -- time (speed based on distance)
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )
    
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(position)})
    tween:Play()
    
    return tween
end

-- Attack function
function Utilities:Attack()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Basic attack implementation
    local args = {
        [1] = "LeftClick",
        [2] = Vector3.new()
    }
    
    local Combat = LocalPlayer.Character:FindFirstChild("Combat") or LocalPlayer.Backpack:FindFirstChild("Combat")
    if Combat then
        Combat.Parent = LocalPlayer.Character
        Combat:Activate()
    else
        -- Attempt to use other weapons/skills
        for _, v in pairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("Tool") and v:FindFirstChild("Mastery") then
                v:Activate()
                break
            end
        end
    end
end

-- UI Library
local Library = {}

-- Create a screen GUI
function Library:CreateUI()
    local xesteerHubGui = Instance.new("ScreenGui")
    xesteerHubGui.Name = "xesteerHubGui"
    xesteerHubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    xesteerHubGui.ResetOnSpawn = false
    
    -- Make ScreenGui work in both normal and exploited environments
    pcall(function()
        if syn then
            syn.protect_gui(xesteerHubGui)
            xesteerHubGui.Parent = game.CoreGui
        elseif hookfunction then
            xesteerHubGui.Parent = game.CoreGui
        else
            xesteerHubGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
    end)
    
    -- Adicionar UI blur na tela toda (efeito visual premium)
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = 5
    blurEffect.Parent = game:GetService("Lighting")
    
    -- Efeito de abertura (animação)
    spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://6895079853" -- Som de UI
        sound.Volume = 0.5
        sound.Parent = xesteerHubGui
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 2)
    end)
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 0, 0, 0) -- Começa pequeno para animação
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45) -- Cor mais estilosa
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ClipsDescendants = true -- Para efeitos visuais
    mainFrame.Parent = xesteerHubGui
    
    -- Animação de abertura
    mainFrame:TweenSize(UDim2.new(0, 550, 0, 430), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.5, true)
    mainFrame:TweenPosition(UDim2.new(0.5, -275, 0.5, -215), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.5, true)
    
    -- Sombra (efeito visual)
    local shadowFrame = Instance.new("ImageLabel")
    shadowFrame.Name = "Shadow"
    shadowFrame.Size = UDim2.new(1, 40, 1, 40)
    shadowFrame.Position = UDim2.new(0, -20, 0, -20)
    shadowFrame.BackgroundTransparency = 1
    shadowFrame.Image = "rbxassetid://5554236805"
    shadowFrame.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadowFrame.ImageTransparency = 0.6
    shadowFrame.ScaleType = Enum.ScaleType.Slice
    shadowFrame.SliceCenter = Rect.new(23, 23, 277, 277)
    shadowFrame.ZIndex = -1
    shadowFrame.Parent = mainFrame
    
    -- Title Bar com gradiente
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    -- Gradiente no título
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 90)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 50))
    })
    titleGradient.Rotation = 90
    titleGradient.Parent = titleBar
    
    -- Título com ícone
    local titleIcon = Instance.new("ImageLabel")
    titleIcon.Name = "Icon"
    titleIcon.Size = UDim2.new(0, 20, 0, 20)
    titleIcon.Position = UDim2.new(0, 10, 0, 7)
    titleIcon.BackgroundTransparency = 1
    titleIcon.Image = "rbxassetid://7733658504" -- Ícone de coroa
    titleIcon.Parent = titleBar
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 40, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Text = "XESTEER-HUB V2 | PREMIUM"
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    -- Versão
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Name = "Version"
    versionLabel.Size = UDim2.new(0, 100, 0, 20)
    versionLabel.Position = UDim2.new(0, 40, 1, -15)
    versionLabel.BackgroundTransparency = 1
    versionLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
    versionLabel.TextSize = 12
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.Text = "v2.5.3 BETA"
    versionLabel.TextXAlignment = Enum.TextXAlignment.Left
    versionLabel.Parent = titleBar
    
    -- Minimize Button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -60, 0, 0)
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.TextSize = 18
    minimizeButton.Font = Enum.Font.SourceSansBold
    minimizeButton.Text = "-"
    minimizeButton.Parent = titleBar
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.BackgroundTransparency = 1
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Text = "X"
    closeButton.Parent = titleBar
    
    -- Sidebar com efeito de gradiente
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 150, 1, -35)
    sidebar.Position = UDim2.new(0, 0, 0, 35)
    sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    
    -- Adicionando gradiente à sidebar
    local sidebarGradient = Instance.new("UIGradient")
    sidebarGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 40))
    })
    sidebarGradient.Rotation = 90
    sidebarGradient.Parent = sidebar
    
    -- Logo na parte superior da sidebar
    local sidebarLogo = Instance.new("ImageLabel")
    sidebarLogo.Name = "SidebarLogo"
    sidebarLogo.Size = UDim2.new(0, 70, 0, 70)
    sidebarLogo.Position = UDim2.new(0.5, -35, 0, 10)
    sidebarLogo.BackgroundTransparency = 1
    sidebarLogo.Image = "rbxassetid://7733774602" -- Logo Blox Fruits
    sidebarLogo.Parent = sidebar
    
    -- Texto do logo
    local sidebarLogoText = Instance.new("TextLabel")
    sidebarLogoText.Name = "LogoText"
    sidebarLogoText.Size = UDim2.new(1, 0, 0, 20)
    sidebarLogoText.Position = UDim2.new(0, 0, 0, 85)
    sidebarLogoText.BackgroundTransparency = 1
    sidebarLogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    sidebarLogoText.TextSize = 12
    sidebarLogoText.Font = Enum.Font.GothamBold
    sidebarLogoText.Text = "XESTEER-HUB"
    sidebarLogoText.Parent = sidebar
    
    -- Linha separadora
    local separatorLine = Instance.new("Frame")
    separatorLine.Name = "Separator"
    separatorLine.Size = UDim2.new(0.8, 0, 0, 1)
    separatorLine.Position = UDim2.new(0.1, 0, 0, 115)
    separatorLine.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
    separatorLine.BorderSizePixel = 0
    separatorLine.Parent = sidebar
    
    -- Botão do Discord
    local discordButton = Instance.new("TextButton")
    discordButton.Name = "DiscordButton"
    discordButton.Size = UDim2.new(0.9, 0, 0, 30)
    discordButton.Position = UDim2.new(0.05, 0, 0.9, -40)
    discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242) -- Cor do Discord
    discordButton.BorderSizePixel = 0
    discordButton.Text = "Discord"
    discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordButton.TextSize = 14
    discordButton.Font = Enum.Font.GothamBold
    discordButton.Parent = sidebar
    
    -- Ícone do Discord
    local discordIcon = Instance.new("ImageLabel")
    discordIcon.Name = "DiscordIcon"
    discordIcon.Size = UDim2.new(0, 20, 0, 20)
    discordIcon.Position = UDim2.new(0, 10, 0.5, -10)
    discordIcon.BackgroundTransparency = 1
    discordIcon.Image = "rbxassetid://12058969086" -- Ícone do Discord
    discordIcon.Parent = discordButton
    
    -- Cantos arredondados para o botão
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 6)
    discordCorner.Parent = discordButton
    
    -- Função para copiar o link do Discord
    discordButton.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/7QjAc6y4ch")
        
        -- Feedback visual
        discordButton.Text = "Link Copiado!"
        discordButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        
        -- Efeito de pulsação
        discordButton:TweenSize(
            UDim2.new(0.95, 0, 0, 32), 
            Enum.EasingDirection.Out, 
            Enum.EasingStyle.Quad, 
            0.2, 
            true
        )
        
        wait(0.2)
        
        discordButton:TweenSize(
            UDim2.new(0.9, 0, 0, 30), 
            Enum.EasingDirection.In, 
            Enum.EasingStyle.Quad, 
            0.2, 
            true
        )
        
        -- Notificação
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Discord",
            Text = "Link copiado para a área de transferência!",
            Duration = 3
        })
        
        -- Restaurar após 2 segundos
        wait(2)
        discordButton.Text = "Discord"
        discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    end)
    
    -- Efeito hover
    discordButton.MouseEnter:Connect(function()
        discordButton:TweenSize(
            UDim2.new(0.95, 0, 0, 32), 
            Enum.EasingDirection.Out, 
            Enum.EasingStyle.Quad, 
            0.2, 
            true
        )
        discordButton.BackgroundColor3 = Color3.fromRGB(120, 130, 255)
    end)
    
    discordButton.MouseLeave:Connect(function()
        discordButton:TweenSize(
            UDim2.new(0.9, 0, 0, 30), 
            Enum.EasingDirection.In, 
            Enum.EasingStyle.Quad, 
            0.2, 
            true
        )
        discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    end)
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -150, 1, -30)
    contentFrame.Position = UDim2.new(0, 150, 0, 30)
    contentFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    -- Page Title
    local pageTitle = Instance.new("TextLabel")
    pageTitle.Name = "PageTitle"
    pageTitle.Size = UDim2.new(1, 0, 0, 40)
    pageTitle.BackgroundTransparency = 1
    pageTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    pageTitle.TextSize = 24
    pageTitle.Font = Enum.Font.SourceSansBold
    pageTitle.Text = "Main Farm"
    pageTitle.Parent = contentFrame
    
    -- Content Container
    local contentContainer = Instance.new("ScrollingFrame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -20, 1, -50)
    contentContainer.Position = UDim2.new(0, 10, 0, 50)
    contentContainer.BackgroundTransparency = 1
    contentContainer.ScrollBarThickness = 4
    contentContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    contentContainer.CanvasSize = UDim2.new(0, 0, 0, 500)
    contentContainer.Parent = contentFrame
    
    -- Add menu buttons
    local menuButtons = {
        "Main Farm",
        "Stack Auto farm",
        "Sub Farming",
        "Status",
        "Player-Status",
        "Fruit",
        "Local Player",
        "Travel"
    }
    
    local pages = {}
    
    -- Container para menu buttons
    local menuButtonsContainer = Instance.new("Frame")
    menuButtonsContainer.Name = "MenuButtonsContainer"
    menuButtonsContainer.Size = UDim2.new(1, 0, 1, -120) -- Espaço para o logo acima
    menuButtonsContainer.Position = UDim2.new(0, 0, 0, 120)
    menuButtonsContainer.BackgroundTransparency = 1
    menuButtonsContainer.Parent = sidebar
    
    for i, menuName in ipairs(menuButtons) do
        -- Create menu button
        local menuButton = Instance.new("TextButton")
        menuButton.Name = menuName .. "Button"
        menuButton.Size = UDim2.new(0.9, 0, 0, 32)
        menuButton.Position = UDim2.new(0.05, 0, 0, (i-1) * 40 + 5)
        menuButton.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
        menuButton.BorderSizePixel = 0
        menuButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        menuButton.TextSize = 14
        menuButton.Font = Enum.Font.GothamSemibold
        menuButton.Text = "  " .. menuName -- Espaço para ícone à esquerda
        menuButton.TextXAlignment = Enum.TextXAlignment.Left
        menuButton.Parent = menuButtonsContainer
        
        -- Arredondar as bordas
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = menuButton
        
        -- Efeitos de hover
        menuButton.MouseEnter:Connect(function()
            menuButton:TweenSize(UDim2.new(0.95, 0, 0, 32), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            menuButton:TweenPosition(UDim2.new(0.025, 0, 0, (i-1) * 40 + 5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            menuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            menuButton.BackgroundColor3 = Color3.fromRGB(65, 65, 120)
        end)
        
        menuButton.MouseLeave:Connect(function()
            menuButton:TweenSize(UDim2.new(0.9, 0, 0, 32), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            menuButton:TweenPosition(UDim2.new(0.05, 0, 0, (i-1) * 40 + 5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            menuButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            menuButton.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
        end)
        
        -- Ícone para o botão
        local buttonIcon = Instance.new("ImageLabel")
        buttonIcon.Name = "Icon"
        buttonIcon.Size = UDim2.new(0, 16, 0, 16)
        buttonIcon.Position = UDim2.new(0, 8, 0.5, -8)
        buttonIcon.BackgroundTransparency = 1
        
        -- Define ícone baseado no nome do menu
        if menuName:find("Farm") then
            buttonIcon.Image = "rbxassetid://7733885175" -- Ícone de farm
        elseif menuName:find("Status") then
            buttonIcon.Image = "rbxassetid://7743878358" -- Ícone de status
        elseif menuName:find("Player") then
            buttonIcon.Image = "rbxassetid://7743866303" -- Ícone de jogador
        elseif menuName:find("Fruit") then
            buttonIcon.Image = "rbxassetid://7733774602" -- Ícone de fruta
        elseif menuName:find("Travel") then
            buttonIcon.Image = "rbxassetid://7734053495" -- Ícone de viagem
        else
            buttonIcon.Image = "rbxassetid://7734039120" -- Ícone genérico
        end
        
        buttonIcon.Parent = menuButton
        
        -- Create page for menu
        local page = Instance.new("Frame")
        page.Name = menuName .. "Page"
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = i == 1 -- Only first page visible by default
        page.Parent = contentContainer
        
        pages[menuName] = page
        
        -- Add click behavior
        menuButton.MouseButton1Click:Connect(function()
            -- Update page title
            pageTitle.Text = menuName
            
            -- Hide all pages
            for _, p in pairs(pages) do
                p.Visible = false
            end
            
            -- Show selected page
            page.Visible = true
        end)
    end
    
    -- Create content for Main Farm page
    local mainFarmPage = pages["Main Farm"]
    
    -- Message about turning on only one farm
    local warningMessage = Instance.new("TextLabel")
    warningMessage.Name = "WarningMessage"
    warningMessage.Size = UDim2.new(1, 0, 0, 40)
    warningMessage.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    warningMessage.BorderSizePixel = 0
    warningMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
    warningMessage.TextSize = 14
    warningMessage.Font = Enum.Font.SourceSans
    warningMessage.Text = "Only Turn On 1 Farm At The Same Time"
    warningMessage.Parent = mainFarmPage
    
    -- Função modernizada para criar toggles
    local function CreateToggle(name, desc, yPosition, parent, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = name .. "Frame"
        toggleFrame.Size = UDim2.new(0.95, 0, 0, 70)
        toggleFrame.Position = UDim2.new(0.025, 0, 0, yPosition)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Parent = parent
        
        -- Arredondar cantos do toggle
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 8)
        frameCorner.Parent = toggleFrame
        
        -- Sombra para o toggle
        local frameShadow = Instance.new("ImageLabel")
        frameShadow.Name = "Shadow"
        frameShadow.Size = UDim2.new(1, 15, 1, 15)
        frameShadow.Position = UDim2.new(0, -7, 0, -7)
        frameShadow.BackgroundTransparency = 1
        frameShadow.Image = "rbxassetid://5554236805"
        frameShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        frameShadow.ImageTransparency = 0.7
        frameShadow.ScaleType = Enum.ScaleType.Slice
        frameShadow.SliceCenter = Rect.new(23, 23, 277, 277)
        frameShadow.ZIndex = -1
        frameShadow.Parent = toggleFrame
        
        -- Ícone do feature (baseado no nome)
        local featureIcon = Instance.new("ImageLabel")
        featureIcon.Name = "FeatureIcon"
        featureIcon.Size = UDim2.new(0, 24, 0, 24)
        featureIcon.Position = UDim2.new(0, 15, 0, 12)
        featureIcon.BackgroundTransparency = 1
        
        -- Seleciona ícone baseado no nome
        if name:find("Farm") then
            featureIcon.Image = "rbxassetid://7733885175" -- Ícone de farm
        elseif name:find("Bone") then
            featureIcon.Image = "rbxassetid://7743866303" -- Ícone de osso
        elseif name:find("Katakuri") or name:find("Cake") then
            featureIcon.Image = "rbxassetid://7733774602" -- Ícone de bolo
        elseif name:find("Dough") then 
            featureIcon.Image = "rbxassetid://7734039120" -- Ícone de rei
        elseif name:find("Kill") or name:find("Aura") then
            featureIcon.Image = "rbxassetid://7743878358" -- Ícone de ataque
        else
            featureIcon.Image = "rbxassetid://7733774602" -- Ícone padrão
        end
        
        featureIcon.Parent = toggleFrame
        
        -- Título do toggle
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Name = "Label"
        toggleLabel.Size = UDim2.new(1, -120, 0, 30)
        toggleLabel.Position = UDim2.new(0, 50, 0, 10)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleLabel.TextSize = 15
        toggleLabel.Font = Enum.Font.GothamBold
        toggleLabel.Text = name
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame
        
        -- Descrição (se houver)
        if desc then
            local toggleDesc = Instance.new("TextLabel")
            toggleDesc.Name = "Description"
            toggleDesc.Size = UDim2.new(1, -120, 0, 20)
            toggleDesc.Position = UDim2.new(0, 50, 0, 35)
            toggleDesc.BackgroundTransparency = 1
            toggleDesc.TextColor3 = Color3.fromRGB(180, 180, 230)
            toggleDesc.TextSize = 12
            toggleDesc.Font = Enum.Font.Gotham
            toggleDesc.Text = desc
            toggleDesc.TextXAlignment = Enum.TextXAlignment.Left
            toggleDesc.Parent = toggleFrame
        end
        
        -- Botão de toggle moderno
        local toggleButton = Instance.new("Frame")
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = UDim2.new(0, 56, 0, 28)
        toggleButton.Position = UDim2.new(1, -70, 0.5, -14)
        toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        toggleButton.BorderSizePixel = 0
        toggleButton.Parent = toggleFrame
        
        -- Arredondar cantos do botão
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 14)
        buttonCorner.Parent = toggleButton
        
        -- Indicador de toggle
        local toggleIndicator = Instance.new("Frame")
        toggleIndicator.Name = "Indicator"
        toggleIndicator.Size = UDim2.new(0, 24, 0, 24)
        toggleIndicator.Position = UDim2.new(0, 2, 0, 2)
        toggleIndicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        toggleIndicator.BorderSizePixel = 0
        toggleIndicator.Parent = toggleButton
        
        -- Arredondar indicador
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(0, 12)
        indicatorCorner.Parent = toggleIndicator
        
        -- Efeito de gradiente no indicador
        local indicatorGradient = Instance.new("UIGradient")
        indicatorGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
        })
        indicatorGradient.Rotation = 90
        indicatorGradient.Parent = toggleIndicator
        
        -- Efeito de hover no toggle
        toggleFrame.MouseEnter:Connect(function()
            toggleFrame:TweenSize(UDim2.new(0.97, 0, 0, 70), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            toggleFrame:TweenPosition(UDim2.new(0.015, 0, 0, yPosition), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
        end)
        
        toggleFrame.MouseLeave:Connect(function()
            toggleFrame:TweenSize(UDim2.new(0.95, 0, 0, 70), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            toggleFrame:TweenPosition(UDim2.new(0.025, 0, 0, yPosition), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        end)
        
        -- Make toggle clickable
        toggleFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                -- Toggle state
                local enabled = toggleIndicator.Position.X.Offset > 2
                enabled = not enabled
                
                -- Som de clique
                local clickSound = Instance.new("Sound")
                clickSound.SoundId = "rbxassetid://6895079853"
                clickSound.Volume = 0.2
                clickSound.Parent = toggleFrame
                clickSound:Play()
                game:GetService("Debris"):AddItem(clickSound, 1)
                
                -- Animate indicator with smoother animation
                if enabled then
                    toggleIndicator:TweenPosition(UDim2.new(0, 30, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, 0.3, true)
                    toggleIndicator:TweenSize(UDim2.new(0, 24, 0, 24), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, 0.3, true)
                    
                    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
                    
                    -- Atualizar gradiente para vermelho quando ativado (combinando com o logo)
                    indicatorGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 100))
                    })
                else
                    toggleIndicator:TweenPosition(UDim2.new(0, 2, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, 0.3, true)
                    toggleIndicator:TweenSize(UDim2.new(0, 24, 0, 24), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, 0.3, true)
                    
                    toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                    
                    -- Reverter gradiente para cinza quando desativado
                    indicatorGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
                    })
                end
                
                -- Call callback
                callback(enabled)
            end
        end)
        
        return toggleButton, toggleIndicator
    end
    
    -- Add feature toggles to Main Farm page
    CreateToggle("Auto Farm", nil, 50, mainFarmPage, function(enabled)
        Config.MainFarmEnabled = enabled
        -- Handle farming state change
    end)
    
    -- Create content for other pages
    -- Stack Auto farm page
    local stackAutoFarmPage = pages["Stack Auto farm"]
    CreateToggle("Stack Auto farm", nil, 10, stackAutoFarmPage, function(enabled)
        Config.StackAutoFarmEnabled = enabled
        -- Handle stack auto farm state change
    end)
    
    -- Sub Farming page
    local subFarmingPage = pages["Sub Farming"]
    CreateToggle("Auto Katakuri", "Turn On Auto Kill And Farm Cake Prince", 10, subFarmingPage, function(enabled)
        Config.AutoKatakuriEnabled = enabled
        -- Handle auto katakuri state change
    end)
    
    CreateToggle("Auto Bone", nil, 80, subFarmingPage, function(enabled)
        Config.AutoBoneEnabled = enabled
        -- Handle auto bone state change
    end)
    
    CreateToggle("Kill Aura", "Farm Near Lv Mob Or Near Position", 150, subFarmingPage, function(enabled)
        Config.KillAuraEnabled = enabled
        -- Handle kill aura state change
    end)
    
    CreateToggle("Fully Auto Dough King", nil, 220, subFarmingPage, function(enabled)
        Config.AutoDoughKingEnabled = enabled
        -- Handle auto dough king state change
    end)
    
    -- Add logo overlay (marca d'água)
    local logoOverlay = Instance.new("ImageLabel")
    logoOverlay.Name = "LogoOverlay"
    logoOverlay.Size = UDim2.new(0, 300, 0, 300)
    logoOverlay.Position = UDim2.new(0.5, -150, 0.5, -150)
    logoOverlay.BackgroundTransparency = 1
    logoOverlay.Image = "rbxassetid://14232580420" -- Logo oficial xesteer-hub
    logoOverlay.ImageTransparency = 0.85
    logoOverlay.ZIndex = 2
    logoOverlay.Parent = contentFrame
    
    -- Texto da marca d'água
    local logoText = Instance.new("TextLabel")
    logoText.Name = "LogoText"
    logoText.Size = UDim2.new(1, 0, 0, 50)
    logoText.Position = UDim2.new(0, 0, 0.8, 0)
    logoText.BackgroundTransparency = 1
    logoText.TextColor3 = Color3.fromRGB(255, 50, 50)
    logoText.TextSize = 40
    logoText.Font = Enum.Font.GothamBold
    logoText.Text = "XESTEER-HUB"
    logoText.TextTransparency = 0.7
    logoText.Rotation = 15
    logoText.ZIndex = 3
    logoText.Parent = contentFrame
    
    -- Add minimize/close button functionality
    minimizeButton.MouseButton1Click:Connect(function()
        if contentFrame.Visible then
            contentFrame.Visible = false
            sidebar.Visible = false
            mainFrame:TweenSize(UDim2.new(0, 500, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        else
            contentFrame.Visible = true
            sidebar.Visible = true
            mainFrame:TweenSize(UDim2.new(0, 500, 0, 400), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        xesteerHubGui:Destroy()
    end)
    
    return xesteerHubGui
end

-- Player Selection System (estilo HohoV2)
local PlayerSelectionSystem = {}
local SelectedPlayer = nil

function PlayerSelectionSystem:CreatePlayerList()
    -- Criar interface para seleção de jogadores
    local playerSelectionFrame = Instance.new("Frame")
    playerSelectionFrame.Name = "PlayerSelectionFrame"
    playerSelectionFrame.Size = UDim2.new(0, 200, 0, 300)
    playerSelectionFrame.Position = UDim2.new(1, 20, 0.5, -150)
    playerSelectionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    playerSelectionFrame.BorderSizePixel = 0
    playerSelectionFrame.Visible = false
    playerSelectionFrame.Parent = game.CoreGui:FindFirstChild("xesteerHubGui")
    
    -- Drop shadow para o frame
    local shadowFrame = Instance.new("ImageLabel")
    shadowFrame.Name = "Shadow"
    shadowFrame.Size = UDim2.new(1, 40, 1, 40)
    shadowFrame.Position = UDim2.new(0, -20, 0, -20)
    shadowFrame.BackgroundTransparency = 1
    shadowFrame.Image = "rbxassetid://5554236805"
    shadowFrame.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadowFrame.ImageTransparency = 0.6
    shadowFrame.ScaleType = Enum.ScaleType.Slice
    shadowFrame.SliceCenter = Rect.new(23, 23, 277, 277)
    shadowFrame.ZIndex = -1
    shadowFrame.Parent = playerSelectionFrame
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "Selecionar Jogador"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = playerSelectionFrame
    
    -- Container para a lista de jogadores
    local listContainer = Instance.new("ScrollingFrame")
    listContainer.Name = "PlayerList"
    listContainer.Size = UDim2.new(1, -10, 1, -40)
    listContainer.Position = UDim2.new(0, 5, 0, 35)
    listContainer.BackgroundTransparency = 1
    listContainer.BorderSizePixel = 0
    listContainer.ScrollBarThickness = 4
    listContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 70, 70)
    listContainer.CanvasSize = UDim2.new(0, 0, 0, 0) -- Será atualizado dinamicamente
    listContainer.Parent = playerSelectionFrame
    
    -- Função para atualizar a lista de jogadores
    local function UpdatePlayerList()
        -- Limpar lista atual
        for _, child in ipairs(listContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        -- Adicionar jogadores à lista
        local yOffset = 0
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local playerButton = Instance.new("TextButton")
                playerButton.Name = player.Name
                playerButton.Size = UDim2.new(1, -8, 0, 30)
                playerButton.Position = UDim2.new(0, 4, 0, yOffset)
                playerButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
                playerButton.BorderSizePixel = 0
                playerButton.Text = player.Name
                playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                playerButton.TextSize = 14
                playerButton.Font = Enum.Font.Gotham
                playerButton.Parent = listContainer
                
                -- Redondamento das bordas
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 4)
                corner.Parent = playerButton
                
                -- Gradient
                local gradient = Instance.new("UIGradient")
                gradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 70)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 60))
                })
                gradient.Rotation = 90
                gradient.Parent = playerButton
                
                -- Level do jogador (se disponível)
                local level = Instance.new("TextLabel")
                level.Name = "Level"
                level.Size = UDim2.new(0, 60, 1, 0)
                level.Position = UDim2.new(1, -60, 0, 0)
                level.BackgroundTransparency = 1
                level.TextColor3 = Color3.fromRGB(255, 200, 100)
                level.TextSize = 12
                level.Font = Enum.Font.Gotham
                level.Text = "Lv.???"
                level.Parent = playerButton
                
                -- Tentar obter nível do jogador
                pcall(function()
                    if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid:FindFirstChild("Value") then
                        level.Text = "Lv." .. tostring(player.Character.Humanoid.Value.Value)
                    end
                end)
                
                -- Evento de clique
                playerButton.MouseButton1Click:Connect(function()
                    SelectedPlayer = player
                    -- Destacar botão selecionado
                    for _, btn in ipairs(listContainer:GetChildren()) do
                        if btn:IsA("TextButton") then
                            if btn == playerButton then
                                btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                            else
                                btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
                            end
                        end
                    end
                    
                    -- Notificação
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Jogador Selecionado",
                        Text = "Alvo: " .. player.Name,
                        Duration = 3
                    })
                end)
                
                yOffset = yOffset + 35
            end
        end
        
        -- Atualizar tamanho do canvas
        listContainer.CanvasSize = UDim2.new(0, 0, 0, yOffset)
    end
    
    -- Atualizar lista inicialmente
    UpdatePlayerList()
    
    -- Atualizar lista quando jogadores entram/saem
    game.Players.PlayerAdded:Connect(UpdatePlayerList)
    game.Players.PlayerRemoving:Connect(UpdatePlayerList)
    
    -- Botão para abrir/fechar a lista de jogadores
    return playerSelectionFrame
end

function PlayerSelectionSystem:GetSelectedPlayer()
    return SelectedPlayer
end

function PlayerSelectionSystem:ToggleVisibility()
    local playerSelectionFrame = game.CoreGui:FindFirstChild("xesteerHubGui"):FindFirstChild("PlayerSelectionFrame")
    if playerSelectionFrame then
        playerSelectionFrame.Visible = not playerSelectionFrame.Visible
    end
end

-- Main Features Implementation
local Features = {}

-- Main Farm
function Features:MainFarm()
    if not Config.MainFarmEnabled then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Get nearest mob
    local mob = Utilities:GetNearestMob(1000)
    if not mob then return end
    
    -- Teleport to mob
    local targetPosition = mob.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
    Utilities:Teleport(targetPosition)
    
    -- Attack mob
    Utilities:Attack()
end

-- Stack Auto farm
function Features:StackAutoFarm()
    if not Config.StackAutoFarmEnabled then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Implementation similar to main farm but with stacking mechanics
    local mob = Utilities:GetNearestMob(1000)
    if not mob then return end
    
    -- Teleport to mob
    local targetPosition = mob.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
    Utilities:Teleport(targetPosition)
    
    -- Attack mob
    Utilities:Attack()
end

-- Auto Katakuri
function Features:AutoKatakuri()
    if not Config.AutoKatakuriEnabled then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Find Cake Prince or related mobs
    local mob = nil
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name:find("Cake Prince") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            mob = v
            break
        end
    end
    
    if not mob then return end
    
    -- Teleport to Cake Prince
    local targetPosition = mob.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
    Utilities:Teleport(targetPosition)
    
    -- Attack Cake Prince
    Utilities:Attack()
end

-- Auto Bone
function Features:AutoBone()
    if not Config.AutoBoneEnabled then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Find mobs that drop bones
    local mob = nil
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if (v.Name:find("Reborn") or v.Name:find("Demonic")) and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            mob = v
            break
        end
    end
    
    if not mob then return end
    
    -- Teleport to mob
    local targetPosition = mob.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
    Utilities:Teleport(targetPosition)
    
    -- Attack mob
    Utilities:Attack()
end

-- Kill Aura
function Features:KillAura()
    if not Config.KillAuraEnabled then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Find all mobs in radius
    local radius = 50
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            local distance = (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance <= radius then
                -- Attack mob
                local args = {
                    [1] = v.HumanoidRootPart.Position
                }
                
                -- Use skills if available
                for _, skill in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if skill:IsA("Tool") and (skill.Name:find("Combat") or skill.Name:find("Blox Fruit")) then
                        skill.Parent = LocalPlayer.Character
                        skill:Activate()
                    end
                end
            end
        end
    end
end

-- Auto Dough King
function Features:AutoDoughKing()
    if not Config.AutoDoughKingEnabled then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Find Dough King
    local mob = nil
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name:find("Dough King") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            mob = v
            break
        end
    end
    
    if not mob then return end
    
    -- Teleport to Dough King
    local targetPosition = mob.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
    Utilities:Teleport(targetPosition)
    
    -- Attack Dough King
    Utilities:Attack()
end

-- Main loop
local function MainLoop()
    -- Create UI
    local ui = Library:CreateUI()
    
    -- Criar lista de jogadores (estilo HohoV2)
    local playerList = PlayerSelectionSystem:CreatePlayerList()
    
    -- Adicionar botão para selecionar jogadores (no status page)
    local statusPage = ui:FindFirstChild("ContentFrame"):FindFirstChild("StatusPage") 
    if statusPage then
        local selectPlayerButton = Instance.new("TextButton")
        selectPlayerButton.Name = "SelectPlayerButton"
        selectPlayerButton.Size = UDim2.new(0, 180, 0, 40)
        selectPlayerButton.Position = UDim2.new(0.5, -90, 0, 150)
        selectPlayerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        selectPlayerButton.BorderSizePixel = 0
        selectPlayerButton.Text = "Selecionar Jogador"
        selectPlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        selectPlayerButton.TextSize = 16
        selectPlayerButton.Font = Enum.Font.GothamBold
        selectPlayerButton.Parent = statusPage
        
        -- Efeito hover
        selectPlayerButton.MouseEnter:Connect(function()
            selectPlayerButton:TweenSize(UDim2.new(0, 190, 0, 45), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            selectPlayerButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        end)
        
        selectPlayerButton.MouseLeave:Connect(function()
            selectPlayerButton:TweenSize(UDim2.new(0, 180, 0, 40), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            selectPlayerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        end)
        
        -- Cantos arredondados
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = selectPlayerButton
        
        -- Evento de clique
        selectPlayerButton.MouseButton1Click:Connect(function()
            PlayerSelectionSystem:ToggleVisibility()
            
            -- Efeito visual ao clicar
            local ripple = Instance.new("Frame")
            ripple.Name = "Ripple"
            ripple.Size = UDim2.new(0, 10, 0, 10)
            ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
            ripple.AnchorPoint = Vector2.new(0.5, 0.5)
            ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ripple.BackgroundTransparency = 0.8
            ripple.BorderSizePixel = 0
            ripple.ZIndex = 5
            ripple.Parent = selectPlayerButton
            
            -- Criar efeito circular
            local circle = Instance.new("UICorner")
            circle.CornerRadius = UDim.new(1, 0)
            circle.Parent = ripple
            
            -- Animação do efeito
            ripple:TweenSize(UDim2.new(1.5, 0, 1.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
            
            spawn(function()
                for i = 0.8, 1, 0.05 do
                    ripple.BackgroundTransparency = i
                    wait(0.05)
                end
                ripple:Destroy()
            end)
        end)
    end
    
    -- Main loop
    RunService.Heartbeat:Connect(function()
        pcall(function()
            if Config.MainFarmEnabled then
                Features:MainFarm()
            elseif Config.StackAutoFarmEnabled then
                Features:StackAutoFarm()
            elseif Config.AutoKatakuriEnabled then
                Features:AutoKatakuri()
            elseif Config.AutoBoneEnabled then
                Features:AutoBone()
            elseif Config.KillAuraEnabled then
                Features:KillAura()
            elseif Config.AutoDoughKingEnabled then
                Features:AutoDoughKing()
            end
        end)
    end)
end

-- Initialize script
do
    -- Efeitos de inicialização (para melhor experiência visual)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "xesteerInitEffect"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    
    -- Tentar colocar na CoreGui para maior segurança anti-detecção
    pcall(function()
        if syn then
            syn.protect_gui(screenGui)
            screenGui.Parent = game.CoreGui
        elseif hookfunction then
            screenGui.Parent = game.CoreGui
        else
            screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        end
    end)
    
    -- Fundo para o efeito
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 1
    background.Parent = screenGui
    
    -- Texto de carregamento
    local loadingText = Instance.new("TextLabel")
    loadingText.Name = "LoadingText"
    loadingText.Size = UDim2.new(1, 0, 0, 80)
    loadingText.Position = UDim2.new(0, 0, 0.5, -40)
    loadingText.BackgroundTransparency = 1
    loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingText.TextSize = 40
    loadingText.Font = Enum.Font.GothamBold
    loadingText.Text = "CARREGANDO XESTEER-HUB V2"
    loadingText.TextTransparency = 1
    loadingText.Parent = background
    
    -- Logo animado (usando o logo oficial do xesteer-hub)
    local logoImage = Instance.new("ImageLabel")
    logoImage.Name = "Logo"
    logoImage.Size = UDim2.new(0, 0, 0, 0)
    logoImage.Position = UDim2.new(0.5, 0, 0.4, 0)
    logoImage.BackgroundTransparency = 1
    logoImage.Image = "rbxassetid://14232580420" -- ID da imagem do logo xesteer-hub (você precisará fazer upload do logo para o Roblox)
    logoImage.ImageTransparency = 1
    logoImage.AnchorPoint = Vector2.new(0.5, 0.5)
    logoImage.Parent = background
    
    -- Sequência de animação
    spawn(function()
        -- Fade in
        background.BackgroundTransparency = 0
        wait(0.5)
        
        -- Aparecer logo
        logoImage:TweenSize(UDim2.new(0, 150, 0, 150), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.7, true)
        for i = 1, 10 do
            logoImage.ImageTransparency = 1 - (i * 0.1)
            wait(0.03)
        end
        wait(0.3)
        
        -- Rotacionar logo
        for i = 1, 3 do
            logoImage.Rotation = logoImage.Rotation + 120
            wait(0.2)
        end
        
        -- Aparecer texto
        for i = 1, 10 do
            loadingText.TextTransparency = 1 - (i * 0.1)
            wait(0.05)
        end
        
        -- Mensagem de verificação
        loadingText.Text = "VERIFICANDO AMBIENTE..."
        wait(0.7)
        loadingText.Text = "CARREGANDO FUNCIONALIDADES..."
        wait(0.8)
        loadingText.Text = "INICIALIZANDO UI..."
        wait(0.6)
        loadingText.Text = "XESTEER-HUB V2 INICIADO COM SUCESSO!"
        
        -- Som de sucesso 
        local successSound = Instance.new("Sound")
        successSound.SoundId = "rbxassetid://6895079853"
        successSound.Volume = 1
        successSound.Parent = screenGui
        successSound:Play()
        
        -- Pulsar logo
        logoImage:TweenSize(UDim2.new(0, 200, 0, 200), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        wait(0.3)
        logoImage:TweenSize(UDim2.new(0, 150, 0, 150), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        
        wait(1)
        
        -- Fade out
        for i = 1, 10 do
            background.BackgroundTransparency = i * 0.1
            logoImage.ImageTransparency = i * 0.1
            loadingText.TextTransparency = i * 0.1
            wait(0.05)
        end
        
        -- Destruir GUI
        screenGui:Destroy()
    end)
    
    -- Iniciar script principal
    spawn(function()
        wait(3) -- Aguardar a animação progredir
        
        while task.wait() do
            pcall(function()
                MainLoop()
            end)
        end
    end)
    
    -- Notifications estilizadas
    local StarterGui = game:GetService("StarterGui")
    
    -- Função para criar notificações customizadas
    local function CustomNotification(title, text, duration)
        -- Notificação do sistema
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5,
            Icon = "rbxassetid://14232580420" -- Logo oficial xesteer-hub
        })
        
        -- Notificação na tela (mais estilizada)
        spawn(function()
            wait(4) -- Esperar a animação de inicialização
            
            local notifGui = Instance.new("ScreenGui")
            notifGui.Name = "xesteerNotification"
            notifGui.ResetOnSpawn = false
            
            -- Proteger GUI
            pcall(function()
                if syn then
                    syn.protect_gui(notifGui)
                    notifGui.Parent = game.CoreGui
                elseif hookfunction then
                    notifGui.Parent = game.CoreGui
                else
                    notifGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                end
            end)
            
            -- Frame da notificação
            local notifFrame = Instance.new("Frame")
            notifFrame.Name = "NotifFrame"
            notifFrame.Size = UDim2.new(0, 300, 0, 80)
            notifFrame.Position = UDim2.new(1, 20, 0.8, 0)
            notifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
            notifFrame.BorderSizePixel = 0
            notifFrame.Parent = notifGui
            
            -- Cantos arredondados
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = notifFrame
            
            -- Barra de progresso
            local progressBar = Instance.new("Frame")
            progressBar.Name = "ProgressBar"
            progressBar.Size = UDim2.new(1, 0, 0, 4)
            progressBar.Position = UDim2.new(0, 0, 1, -4)
            progressBar.BackgroundColor3 = Color3.fromRGB(255, 70, 70) -- Vermelho para combinar com o logo
            progressBar.BorderSizePixel = 0
            progressBar.ZIndex = 10
            progressBar.Parent = notifFrame
            
            -- Cantos para a barra
            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(0, 2)
            barCorner.Parent = progressBar
            
            -- Título
            local titleLabel = Instance.new("TextLabel")
            titleLabel.Name = "Title"
            titleLabel.Size = UDim2.new(1, -20, 0, 30)
            titleLabel.Position = UDim2.new(0, 10, 0, 5)
            titleLabel.BackgroundTransparency = 1
            titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            titleLabel.TextSize = 18
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.Text = title
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.Parent = notifFrame
            
            -- Mensagem
            local textLabel = Instance.new("TextLabel")
            textLabel.Name = "Text"
            textLabel.Size = UDim2.new(1, -20, 0, 40)
            textLabel.Position = UDim2.new(0, 10, 0, 35)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            textLabel.TextSize = 15
            textLabel.Font = Enum.Font.Gotham
            textLabel.Text = text
            textLabel.TextXAlignment = Enum.TextXAlignment.Left
            textLabel.TextWrapped = true
            textLabel.Parent = notifFrame
            
            -- Animação de entrada
            notifFrame:TweenPosition(UDim2.new(1, -320, 0.8, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.5)
            
            -- Animação da barra de progresso
            progressBar:TweenSize(UDim2.new(0, 0, 0, 4), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, duration or 5, true, function()
                -- Animação de saída
                notifFrame:TweenPosition(UDim2.new(1, 20, 0.8, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quint, 0.5, false, function()
                    notifGui:Destroy()
                end)
            end)
        end)
    end
    
    -- Mensagens de sucesso
    wait(6) -- Esperar a animação completa
    CustomNotification("XESTEER-HUB V2", "Script carregado com sucesso! Desenvolvido por Xesteer Team", 5)
    wait(5.5)
    CustomNotification("INFORMAÇÃO", "Use o menu para ativar diferentes funcionalidades de farm", 5)
    
    -- Log de console
    print("╔═══════════════════════════════════════════╗")
    print("║           XESTEER-HUB V2 PREMIUM          ║")
    print("║───────────────────────────────────────────║")
    print("║  ✓ Status: Carregado com Sucesso!         ║")
    print("║  ✓ Versão: 2.5.3 BETA                     ║")
    print("║  ✓ Discord: discord.gg/7QjAc6y4ch         ║")
    print("╚═══════════════════════════════════════════╝")
end
