--[[
    XESTEER-HUB V4
    Blox Fruits Script - Versão Super Avançada (Sem Key)
    Código aprimorado e otimizado do HoHo Hub V4
    
    Compatível com TODOS os executores:
    - Arceus X
    - Delta
    - Codex
    - Fluxus
    - Hydrogen
    - Krnl
    - Synapse X
    - Electron
    - Script-Ware
    - Oxygen U
    - JJSploit
    - etc.
    
    Desenvolvido por: Xesteer Team
    Discord: https://discord.gg/7QjAc6y4ch
]]

-- Versão compacta para compartilhamento (isso é o que você compartilha com amigos)
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/xesteer-hub/scripts/main/xesteer-hub.lua"))()

-- Verificação Inicial
if not game:IsLoaded() then 
    game.Loaded:Wait()
end

-- Verificação de Jogo
local GameSupported = false
if game.PlaceId == 2753915549 or game.PlaceId == 4442272183 or game.PlaceId == 7449423635 then
    GameSupported = true
else
    -- Notificação de jogo não suportado
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "XESTEER-HUB",
        Text = "Este script é exclusivo para Blox Fruits!",
        Duration = 5
    })
    return
end

-- Anti Lag
settings().Rendering.QualityLevel = 1
UserSettings():GetService("UserGameSettings").MasterVolume = 0
pcall(function()
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").FogEnd = 9e9
    game:GetService("Lighting").Brightness = 0
end)

-- Remoção de efeitos para melhorar performance
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
        pcall(function()
            v.Lifetime = NumberRange.new(0)
            v.Enabled = false
        end)
    end
end

-- Anti AFK
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- Variáveis Globais
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
end)

local Data = {}
local Config = {
    AutoFarm = false,
    AutoFarmBoss = false,
    AutoFarmNearest = false,
    KillAura = false,
    AutoRaid = false,
    TeleportIsland = "",
    FastAttack = true,
    MobAura = false,
    AutoBuyHaki = false,
    AutoBuySword = false,
    AutoUpgradeRace = false,
    ChestFarm = false,
    FullySuperhuman = false,
    SeaBeastsHop = false,
    AutoBuyLegendarySword = false,
    AutoLowServerHop = false,
    AutoBuyEnchancementColor = false,
    AutoBuyLegendaryHaki = false,
    NoClip = false,
    HitboxExpander = false
}

-- Utilitários
local Utilities = {}

-- Tweening Functions
function Utilities:Tween(obj, info, properties)
    local tween = TweenService:Create(obj, TweenInfo.new(unpack(info)), properties)
    tween:Play()
    return tween
end

-- Get Nearest Mob
function Utilities:GetNearestMob(maxDistance)
    local nearestMob = nil
    local shortestDistance = maxDistance or math.huge
    
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            local magnitude = (v.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
            if magnitude < shortestDistance then
                shortestDistance = magnitude
                nearestMob = v
            end
        end
    end
    
    return nearestMob
end

-- Get Mob by Name
function Utilities:GetMobByName(name, maxDistance)
    local nearestMob = nil
    local shortestDistance = maxDistance or math.huge
    
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name:lower():find(name:lower()) and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            local magnitude = (v.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
            if magnitude < shortestDistance then
                shortestDistance = magnitude
                nearestMob = v
            end
        end
    end
    
    return nearestMob
end

-- Get Boss
function Utilities:GetBoss(name)
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name:lower():find(name:lower()) and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and v:FindFirstChild("Boss") then
            return v
        end
    end
    return nil
end

-- Teleport Function
function Utilities:Teleport(position)
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = Character.HumanoidRootPart
        
        local tweenInfo = TweenInfo.new(
            (position - humanoidRootPart.Position).Magnitude / 200, -- Speed
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
end

-- Click Functions for Fast Attack
function Utilities:Attack()
    local args = {
        [1] = "LeftClick"
    }
    
    local Combat = Character:FindFirstChild("Combat") or LocalPlayer.Backpack:FindFirstChild("Combat")
    if Combat then
        Combat.Parent = Character
        if Combat.Activator then
            Combat.Activator:FireServer(unpack(args))
        end
    else
        -- Use melee, sword or gun
        for _, v in pairs(Character:GetChildren()) do
            if v:IsA("Tool") then
                v:Activate()
                if v:FindFirstChild("Activator") then
                    v.Activator:FireServer(unpack(args))
                end
                break
            end
        end
    end
end

-- Hitbox Expander
function Utilities:ExpandHitbox(mob, size)
    if mob and mob:FindFirstChild("HumanoidRootPart") then
        mob.HumanoidRootPart.Transparency = 0.75
        mob.HumanoidRootPart.Size = Vector3.new(size, size, size)
        mob.HumanoidRootPart.CanCollide = false
    end
end

-- Inicialização UI
local UI = {}

-- Load UI
function UI:Create()
    -- Destruir GUI anterior se existir
    if game:GetService("CoreGui"):FindFirstChild("XESTEER-HUB") then
        game:GetService("CoreGui"):FindFirstChild("XESTEER-HUB"):Destroy()
    end

    -- Main GUI
    local XesteerHub = Instance.new("ScreenGui")
    XesteerHub.Name = "XESTEER-HUB"
    XesteerHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    XesteerHub.ResetOnSpawn = false

    -- Compatibilidade universal com qualquer executor
    local success, result = pcall(function()
        -- Método 1: Synapse X, Script-Ware, etc.
        if syn and syn.protect_gui then
            syn.protect_gui(XesteerHub)
            XesteerHub.Parent = game.CoreGui
            return true
        -- Método 2: KRNL, Fluxus, etc.
        elseif KRNL_LOADED and SetIdentity then
            SetIdentity(1)
            XesteerHub.Parent = game.CoreGui
            return true
        -- Método 3: Sentinel
        elseif secure_load then
            XesteerHub.Parent = game.CoreGui
            return true
        -- Método 4: Arceus X, etc.
        elseif gethui then
            XesteerHub.Parent = gethui()
            return true
        -- Método 5: getgenv
        elseif getgenv then
            XesteerHub.Parent = game.CoreGui
            return true
        -- Método 6: Fallback para qualquer outro executor
        else
            XesteerHub.Parent = game:GetService("CoreGui")
            return true
        end
    end)
    
    -- Fallback universal se nenhum método acima funcionar
    if not success then
        pcall(function()
            XesteerHub.Parent = game:GetService("Players").LocalPlayer.PlayerGui
        end)
    end

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 650, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = XesteerHub
    
    -- Sistema Sem Key Ativado (Sem Notificação)
    -- Todas as funções disponíveis sem restrição

    -- Cantos arredondados
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame

    -- Efeito sombra
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 35, 1, 35)
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = -1
    Shadow.Parent = MainFrame

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    -- HeaderCorner
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header

    -- HeaderFiller para evitar cantos arredondados na parte de baixo
    local HeaderFiller = Instance.new("Frame")
    HeaderFiller.Name = "HeaderFiller"
    HeaderFiller.Size = UDim2.new(1, 0, 0, 10)
    HeaderFiller.Position = UDim2.new(0, 0, 1, -10)
    HeaderFiller.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    HeaderFiller.BorderSizePixel = 0
    HeaderFiller.ZIndex = 0
    HeaderFiller.Parent = Header

    -- Logo
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(0, 30, 0, 30)
    Logo.Position = UDim2.new(0, 10, 0, 5)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://14232580420" -- Xesteer Logo
    Logo.Parent = Header

    -- Título
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 50, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "XESTEER HUB V4"
    Title.TextColor3 = Color3.fromRGB(255, 0, 0)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    -- Status Label
    local Status = Instance.new("TextLabel")
    Status.Name = "Status"
    Status.Size = UDim2.new(0, 150, 0, 20)
    Status.Position = UDim2.new(0, 50, 0, 25)
    Status.BackgroundTransparency = 1
    Status.Text = "Versão Completa (Sem Key)"
    Status.TextColor3 = Color3.fromRGB(255, 255, 255)
    Status.TextSize = 12
    Status.Font = Enum.Font.Gotham
    Status.TextXAlignment = Enum.TextXAlignment.Left
    Status.Parent = Header

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -40, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Header

    -- Arredondar Close Button
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -80, 0, 5)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 16
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = Header

    -- Arredondar Minimize Button
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = MinimizeButton

    -- Make Header Draggable
    local isDragging = false
    local dragStart = nil
    local startPos = nil

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- NavBar
    local NavBar = Instance.new("Frame")
    NavBar.Name = "NavBar"
    NavBar.Size = UDim2.new(0, 150, 1, -40)
    NavBar.Position = UDim2.new(0, 0, 0, 40)
    NavBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    NavBar.BorderSizePixel = 0
    NavBar.Parent = MainFrame

    -- Content
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -150, 1, -40)
    Content.Position = UDim2.new(0, 150, 0, 40)
    Content.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Content.BorderSizePixel = 0
    Content.Parent = MainFrame

    -- Botões de navegação
    local navButtons = {
        {Name = "Home", Icon = "rbxassetid://6026568198"},
        {Name = "Farm", Icon = "rbxassetid://6031075931"},
        {Name = "Stats", Icon = "rbxassetid://6034509993"},
        {Name = "Teleport", Icon = "rbxassetid://6031265959"},
        {Name = "Dungeon", Icon = "rbxassetid://6034754410"},
        {Name = "DevilFruit", Icon = "rbxassetid://6031086173"},
        {Name = "Shop", Icon = "rbxassetid://6031289449"},
        {Name = "Misc", Icon = "rbxassetid://6034509776"}
    }

    -- Páginas Container
    local Pages = Instance.new("Folder")
    Pages.Name = "Pages"
    Pages.Parent = Content

    -- Criando botões e páginas
    for i, data in ipairs(navButtons) do
        -- NavButton
        local NavButton = Instance.new("TextButton")
        NavButton.Name = data.Name .. "Button"
        NavButton.Size = UDim2.new(1, -20, 0, 36)
        NavButton.Position = UDim2.new(0, 10, 0, 10 + (i-1) * 46)
        NavButton.BackgroundColor3 = i == 1 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(40, 40, 40)
        NavButton.BorderSizePixel = 0
        NavButton.Text = data.Name
        NavButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        NavButton.TextSize = 14
        NavButton.Font = Enum.Font.GothamSemibold
        NavButton.Parent = NavBar

        -- NavButtonCorner
        local NavButtonCorner = Instance.new("UICorner")
        NavButtonCorner.CornerRadius = UDim.new(0, 6)
        NavButtonCorner.Parent = NavButton

        -- Icon
        local Icon = Instance.new("ImageLabel")
        Icon.Name = "Icon"
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.Position = UDim2.new(0, 10, 0.5, -10)
        Icon.BackgroundTransparency = 1
        Icon.Image = data.Icon
        Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        Icon.Parent = NavButton

        -- Page
        local Page = Instance.new("ScrollingFrame")
        Page.Name = data.Name .. "Page"
        Page.Size = UDim2.new(1, -10, 1, -10)
        Page.Position = UDim2.new(0, 5, 0, 5)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 2
        Page.ScrollingDirection = Enum.ScrollingDirection.Y
        Page.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be updated later
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = i == 1 -- Only first page visible
        Page.Parent = Pages

        -- Page Padding
        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingLeft = UDim.new(0, 10)
        PagePadding.PaddingRight = UDim.new(0, 10)
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingBottom = UDim.new(0, 10)
        PagePadding.Parent = Page

        -- Page List Layout
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = Page

        -- Click behavior
        NavButton.MouseButton1Click:Connect(function()
            -- Reset all buttons color
            for _, button in pairs(NavBar:GetChildren()) do
                if button:IsA("TextButton") then
                    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                end
            end
            
            -- Set current button color
            NavButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            
            -- Hide all pages
            for _, page in pairs(Pages:GetChildren()) do
                page.Visible = false
            end
            
            -- Show current page
            Pages[data.Name .. "Page"].Visible = true
        end)
    end

    -- Discord Button
    local DiscordButton = Instance.new("TextButton")
    DiscordButton.Name = "DiscordButton"
    DiscordButton.Size = UDim2.new(1, -20, 0, 36)
    DiscordButton.Position = UDim2.new(0, 10, 1, -46)
    DiscordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242) -- Discord color
    DiscordButton.BorderSizePixel = 0
    DiscordButton.Text = "Discord"
    DiscordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DiscordButton.TextSize = 14
    DiscordButton.Font = Enum.Font.GothamSemibold
    DiscordButton.Parent = NavBar

    -- DiscordButtonCorner
    local DiscordButtonCorner = Instance.new("UICorner")
    DiscordButtonCorner.CornerRadius = UDim.new(0, 6)
    DiscordButtonCorner.Parent = DiscordButton

    -- Discord Icon
    local DiscordIcon = Instance.new("ImageLabel")
    DiscordIcon.Name = "Icon"
    DiscordIcon.Size = UDim2.new(0, 20, 0, 20)
    DiscordIcon.Position = UDim2.new(0, 10, 0.5, -10)
    DiscordIcon.BackgroundTransparency = 1
    DiscordIcon.Image = "rbxassetid://12058969086" -- Discord icon
    DiscordIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    DiscordIcon.Parent = DiscordButton

    -- Discord Button Click
    DiscordButton.MouseButton1Click:Connect(function()
        -- Visual feedback
        DiscordButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        DiscordButton.Text = "Copiado!"
        
        -- Copy to clipboard - compatível com todos os executores
        local clipboard_functions = {
            ["setclipboard"] = setclipboard,
            ["toclipboard"] = toclipboard,
            ["set_clipboard"] = set_clipboard,
            ["Synapse"] = (syn and syn.write_clipboard),
            ["Copy"] = Copy,
            ["clipboard.set"] = (clipboard and clipboard.set)
        }
        
        for name, func in pairs(clipboard_functions) do
            if func then
                pcall(function()
                    if name == "Synapse" then
                        syn.write_clipboard("https://discord.gg/7QjAc6y4ch")
                    elseif name == "clipboard.set" then
                        clipboard.set("https://discord.gg/7QjAc6y4ch")
                    else
                        func("https://discord.gg/7QjAc6y4ch")
                    end
                end)
                break
            end
        end
        
        -- Show notification
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "XESTEER-HUB",
            Text = "Discord link copiado para área de transferência!",
            Duration = 3
        })
        
        -- Reset after 2 seconds
        task.delay(2, function()
            DiscordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
            DiscordButton.Text = "Discord"
        end)
    end)

    -- Close Button Click
    CloseButton.MouseButton1Click:Connect(function()
        XesteerHub:Destroy()
    end)

    -- Minimize Button Click
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        
        if minimized then
            MainFrame:TweenSize(
                UDim2.new(0, 650, 0, 40),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quart,
                0.5,
                true
            )
        else
            MainFrame:TweenSize(
                UDim2.new(0, 650, 0, 400),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quart,
                0.5,
                true
            )
        end
    end)

    -- Criar Home Page
    local HomePage = Pages.HomePage

    -- Welcome Message
    local WelcomeSection = Instance.new("Frame")
    WelcomeSection.Name = "WelcomeSection"
    WelcomeSection.Size = UDim2.new(1, 0, 0, 120)
    WelcomeSection.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    WelcomeSection.BorderSizePixel = 0
    WelcomeSection.Parent = HomePage

    -- Rounded corners
    local WelcomeCorner = Instance.new("UICorner")
    WelcomeCorner.CornerRadius = UDim.new(0, 6)
    WelcomeCorner.Parent = WelcomeSection

    -- Logo grande
    local BigLogo = Instance.new("ImageLabel")
    BigLogo.Name = "BigLogo"
    BigLogo.Size = UDim2.new(0, 90, 0, 90)
    BigLogo.Position = UDim2.new(0, 10, 0, 15)
    BigLogo.BackgroundTransparency = 1
    BigLogo.Image = "rbxassetid://14232580420" -- Xesteer logo
    BigLogo.Parent = WelcomeSection

    -- Welcome Title
    local WelcomeTitle = Instance.new("TextLabel")
    WelcomeTitle.Name = "WelcomeTitle"
    WelcomeTitle.Size = UDim2.new(1, -120, 0, 40)
    WelcomeTitle.Position = UDim2.new(0, 110, 0, 15)
    WelcomeTitle.BackgroundTransparency = 1
    WelcomeTitle.Text = "BEM-VINDO AO XESTEER HUB"
    WelcomeTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
    WelcomeTitle.TextSize = 20
    WelcomeTitle.Font = Enum.Font.GothamBold
    WelcomeTitle.TextXAlignment = Enum.TextXAlignment.Left
    WelcomeTitle.Parent = WelcomeSection

    -- Welcome Description
    local WelcomeDesc = Instance.new("TextLabel")
    WelcomeDesc.Name = "WelcomeDesc"
    WelcomeDesc.Size = UDim2.new(1, -120, 0, 60)
    WelcomeDesc.Position = UDim2.new(0, 110, 0, 50)
    WelcomeDesc.BackgroundTransparency = 1
    WelcomeDesc.Text = "Obrigado por usar nossos serviços. Estamos comprometidos em proporcionar a melhor experiência possível. Escolha as opções no menu à esquerda."
    WelcomeDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    WelcomeDesc.TextSize = 14
    WelcomeDesc.Font = Enum.Font.Gotham
    WelcomeDesc.TextXAlignment = Enum.TextXAlignment.Left
    WelcomeDesc.TextWrapped = true
    WelcomeDesc.Parent = WelcomeSection

    -- Player Info
    local PlayerSection = Instance.new("Frame")
    PlayerSection.Name = "PlayerSection"
    PlayerSection.Size = UDim2.new(1, 0, 0, 100)
    PlayerSection.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    PlayerSection.BorderSizePixel = 0
    PlayerSection.LayoutOrder = 1
    PlayerSection.Parent = HomePage

    -- Rounded corners
    local PlayerCorner = Instance.new("UICorner")
    PlayerCorner.CornerRadius = UDim.new(0, 6)
    PlayerCorner.Parent = PlayerSection

    -- Player Info Title
    local PlayerTitle = Instance.new("TextLabel")
    PlayerTitle.Name = "PlayerTitle"
    PlayerTitle.Size = UDim2.new(1, 0, 0, 30)
    PlayerTitle.BackgroundTransparency = 1
    PlayerTitle.Text = "INFORMAÇÕES DO JOGADOR"
    PlayerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerTitle.TextSize = 16
    PlayerTitle.Font = Enum.Font.GothamBold
    PlayerTitle.Parent = PlayerSection

    -- Player Name
    local PlayerName = Instance.new("TextLabel")
    PlayerName.Name = "PlayerName"
    PlayerName.Size = UDim2.new(0.5, -10, 0, 20)
    PlayerName.Position = UDim2.new(0, 10, 0, 35)
    PlayerName.BackgroundTransparency = 1
    PlayerName.Text = "Name: " .. LocalPlayer.Name
    PlayerName.TextColor3 = Color3.fromRGB(200, 200, 200)
    PlayerName.TextSize = 14
    PlayerName.Font = Enum.Font.Gotham
    PlayerName.TextXAlignment = Enum.TextXAlignment.Left
    PlayerName.Parent = PlayerSection

    -- Player Level
    local PlayerLevel = Instance.new("TextLabel")
    PlayerLevel.Name = "PlayerLevel"
    PlayerLevel.Size = UDim2.new(0.5, -10, 0, 20)
    PlayerLevel.Position = UDim2.new(0.5, 0, 0, 35)
    PlayerLevel.BackgroundTransparency = 1
    PlayerLevel.Text = "Level: Carregando..."
    PlayerLevel.TextColor3 = Color3.fromRGB(200, 200, 200)
    PlayerLevel.TextSize = 14
    PlayerLevel.Font = Enum.Font.Gotham
    PlayerLevel.TextXAlignment = Enum.TextXAlignment.Left
    PlayerLevel.Parent = PlayerSection

    -- Player Fruit
    local PlayerFruit = Instance.new("TextLabel")
    PlayerFruit.Name = "PlayerFruit"
    PlayerFruit.Size = UDim2.new(0.5, -10, 0, 20)
    PlayerFruit.Position = UDim2.new(0, 10, 0, 60)
    PlayerFruit.BackgroundTransparency = 1
    PlayerFruit.Text = "Fruit: Carregando..."
    PlayerFruit.TextColor3 = Color3.fromRGB(200, 200, 200)
    PlayerFruit.TextSize = 14
    PlayerFruit.Font = Enum.Font.Gotham
    PlayerFruit.TextXAlignment = Enum.TextXAlignment.Left
    PlayerFruit.Parent = PlayerSection

    -- Player Race
    local PlayerRace = Instance.new("TextLabel")
    PlayerRace.Name = "PlayerRace"
    PlayerRace.Size = UDim2.new(0.5, -10, 0, 20)
    PlayerRace.Position = UDim2.new(0.5, 0, 0, 60)
    PlayerRace.BackgroundTransparency = 1
    PlayerRace.Text = "Race: Carregando..."
    PlayerRace.TextColor3 = Color3.fromRGB(200, 200, 200)
    PlayerRace.TextSize = 14
    PlayerRace.Font = Enum.Font.Gotham
    PlayerRace.TextXAlignment = Enum.TextXAlignment.Left
    PlayerRace.Parent = PlayerSection

    -- Update player info
    local function UpdatePlayerInfo()
        task.spawn(function()
            while true do
                if LocalPlayer.PlayerGui.Main.Level then
                    local level = LocalPlayer.PlayerGui.Main.Level.Value
                    PlayerLevel.Text = "Level: " .. level
                end
                
                -- Get devil fruit
                local fruit = "None"
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:FindFirstChild("Fruit") then
                        fruit = tool.Name
                        break
                    end
                end
                
                for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Fruit") then
                        fruit = tool.Name
                        break
                    end
                end
                
                PlayerFruit.Text = "Fruit: " .. fruit
                
                -- Get race
                local race = LocalPlayer.Data.Race.Value
                PlayerRace.Text = "Race: " .. race
                
                wait(1)
            end
        end)
    end
    
    UpdatePlayerInfo()

    -- Criar Farm Page
    local FarmPage = Pages.FarmPage

    -- Auto Farm Section
    local AutoFarmSection = Instance.new("Frame")
    AutoFarmSection.Name = "AutoFarmSection"
    AutoFarmSection.Size = UDim2.new(1, 0, 0, 120)
    AutoFarmSection.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    AutoFarmSection.BorderSizePixel = 0
    AutoFarmSection.LayoutOrder = 0
    AutoFarmSection.Parent = FarmPage

    -- Rounded corners
    local AutoFarmCorner = Instance.new("UICorner")
    AutoFarmCorner.CornerRadius = UDim.new(0, 6)
    AutoFarmCorner.Parent = AutoFarmSection

    -- Section Title
    local AutoFarmTitle = Instance.new("TextLabel")
    AutoFarmTitle.Name = "AutoFarmTitle"
    AutoFarmTitle.Size = UDim2.new(1, 0, 0, 30)
    AutoFarmTitle.BackgroundTransparency = 1
    AutoFarmTitle.Text = "AUTO FARM"
    AutoFarmTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    AutoFarmTitle.TextSize = 16
    AutoFarmTitle.Font = Enum.Font.GothamBold
    AutoFarmTitle.Parent = AutoFarmSection

    -- Create Toggle Function
    local function CreateToggle(parent, text, position, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = text .. "Toggle"
        ToggleFrame.Size = UDim2.new(0, 180, 0, 30)
        ToggleFrame.Position = position
        ToggleFrame.BackgroundTransparency = 1
        ToggleFrame.Parent = parent
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Name = "Label"
        ToggleLabel.Size = UDim2.new(0, 130, 1, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = text
        ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        ToggleLabel.TextSize = 14
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame
        
        local ToggleButton = Instance.new("Frame")
        ToggleButton.Name = "Button"
        ToggleButton.Size = UDim2.new(0, 40, 0, 20)
        ToggleButton.Position = UDim2.new(1, -40, 0.5, -10)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Parent = ToggleFrame
        
        -- Rounded corners
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 10)
        ToggleCorner.Parent = ToggleButton
        
        local ToggleIndicator = Instance.new("Frame")
        ToggleIndicator.Name = "Indicator"
        ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
        ToggleIndicator.Position = UDim2.new(0, 2, 0.5, -8)
        ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleIndicator.BorderSizePixel = 0
        ToggleIndicator.Parent = ToggleButton
        
        -- Rounded corners
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(0, 8)
        IndicatorCorner.Parent = ToggleIndicator
        
        -- Click behavior
        local enabled = false
        
        local function UpdateToggle()
            if enabled then
                ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                ToggleIndicator:TweenPosition(
                    UDim2.new(1, -18, 0.5, -8),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quad,
                    0.2,
                    true
                )
            else
                ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                ToggleIndicator:TweenPosition(
                    UDim2.new(0, 2, 0.5, -8),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quad,
                    0.2,
                    true
                )
            end
        end
        
        ToggleButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                enabled = not enabled
                UpdateToggle()
                callback(enabled)
            end
        end)
        
        -- Make label clickable too
        ToggleLabel.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                enabled = not enabled
                UpdateToggle()
                callback(enabled)
            end
        end)
        
        return {
            SetValue = function(value)
                enabled = value
                UpdateToggle()
            end
        }
    end

    -- Auto Farm Toggles
    local AutoFarmToggle = CreateToggle(
        AutoFarmSection,
        "Auto Farm",
        UDim2.new(0, 10, 0, 35),
        function(value)
            Config.AutoFarm = value
        end
    )

    local NearestFarmToggle = CreateToggle(
        AutoFarmSection,
        "Auto Farm Nearest",
        UDim2.new(0.5, 0, 0, 35),
        function(value)
            Config.AutoFarmNearest = value
        end
    )

    local KillAuraToggle = CreateToggle(
        AutoFarmSection,
        "Kill Aura",
        UDim2.new(0, 10, 0, 75),
        function(value)
            Config.KillAura = value
        end
    )

    local AutoBossToggle = CreateToggle(
        AutoFarmSection,
        "Auto Farm Boss",
        UDim2.new(0.5, 0, 0, 75),
        function(value)
            Config.AutoFarmBoss = value
        end
    )

    -- Boss Section
    local BossSection = Instance.new("Frame")
    BossSection.Name = "BossSection"
    BossSection.Size = UDim2.new(1, 0, 0, 140)
    BossSection.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    BossSection.BorderSizePixel = 0
    BossSection.LayoutOrder = 1
    BossSection.Parent = FarmPage

    -- Rounded corners
    local BossCorner = Instance.new("UICorner")
    BossCorner.CornerRadius = UDim.new(0, 6)
    BossCorner.Parent = BossSection

    -- Section Title
    local BossTitle = Instance.new("TextLabel")
    BossTitle.Name = "BossTitle"
    BossTitle.Size = UDim2.new(1, 0, 0, 30)
    BossTitle.BackgroundTransparency = 1
    BossTitle.Text = "SELECT BOSS"
    BossTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    BossTitle.TextSize = 16
    BossTitle.Font = Enum.Font.GothamBold
    BossTitle.Parent = BossSection

    -- Dropdown Function
    local function CreateDropdown(parent, text, options, position, callback)
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Name = text .. "Dropdown"
        DropdownFrame.Size = UDim2.new(1, -20, 0, 30)
        DropdownFrame.Position = position
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        DropdownFrame.BorderSizePixel = 0
        DropdownFrame.ClipsDescendants = true
        DropdownFrame.Parent = parent
        
        -- Rounded corners
        local DropdownCorner = Instance.new("UICorner")
        DropdownCorner.CornerRadius = UDim.new(0, 6)
        DropdownCorner.Parent = DropdownFrame
        
        local DropdownLabel = Instance.new("TextLabel")
        DropdownLabel.Name = "Label"
        DropdownLabel.Size = UDim2.new(1, -30, 1, 0)
        DropdownLabel.BackgroundTransparency = 1
        DropdownLabel.Text = text
        DropdownLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        DropdownLabel.TextSize = 14
        DropdownLabel.Font = Enum.Font.Gotham
        DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        DropdownLabel.Parent = DropdownFrame
        
        local DropdownArrow = Instance.new("TextLabel")
        DropdownArrow.Name = "Arrow"
        DropdownArrow.Size = UDim2.new(0, 20, 1, 0)
        DropdownArrow.Position = UDim2.new(1, -25, 0, 0)
        DropdownArrow.BackgroundTransparency = 1
        DropdownArrow.Text = "▼"
        DropdownArrow.TextColor3 = Color3.fromRGB(200, 200, 200)
        DropdownArrow.TextSize = 14
        DropdownArrow.Font = Enum.Font.Gotham
        DropdownArrow.Parent = DropdownFrame
        
        local OptionsFrame = Instance.new("Frame")
        OptionsFrame.Name = "Options"
        OptionsFrame.Size = UDim2.new(1, 0, 0, 0) -- Start closed
        OptionsFrame.Position = UDim2.new(0, 0, 1, 0)
        OptionsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        OptionsFrame.BorderSizePixel = 0
        OptionsFrame.ClipsDescendants = true
        OptionsFrame.Visible = false
        OptionsFrame.Parent = DropdownFrame
        
        -- Rounded corners
        local OptionsCorner = Instance.new("UICorner")
        OptionsCorner.CornerRadius = UDim.new(0, 6)
        OptionsCorner.Parent = OptionsFrame
        
        local OptionsList = Instance.new("ScrollingFrame")
        OptionsList.Name = "List"
        OptionsList.Size = UDim2.new(1, 0, 1, 0)
        OptionsList.BackgroundTransparency = 1
        OptionsList.BorderSizePixel = 0
        OptionsList.ScrollBarThickness = 2
        OptionsList.ScrollingDirection = Enum.ScrollingDirection.Y
        OptionsList.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
        OptionsList.Parent = OptionsFrame
        
        -- List layout
        local ListLayout = Instance.new("UIListLayout")
        ListLayout.Padding = UDim.new(0, 5)
        ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ListLayout.Parent = OptionsList
        
        -- Padding
        local ListPadding = Instance.new("UIPadding")
        ListPadding.PaddingTop = UDim.new(0, 5)
        ListPadding.PaddingBottom = UDim.new(0, 5)
        ListPadding.Parent = OptionsList
        
        -- Create options
        for i, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Name = option .. "Option"
            OptionButton.Size = UDim2.new(1, -10, 0, 25)
            OptionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            OptionButton.BorderSizePixel = 0
            OptionButton.Text = option
            OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            OptionButton.TextSize = 14
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.Parent = OptionsList
            
            -- Rounded corners
            local OptionCorner = Instance.new("UICorner")
            OptionCorner.CornerRadius = UDim.new(0, 4)
            OptionCorner.Parent = OptionButton
            
            -- Click behavior
            OptionButton.MouseButton1Click:Connect(function()
                DropdownLabel.Text = text .. ": " .. option
                callback(option)
                
                -- Close dropdown
                OptionsFrame.Visible = false
                OptionsFrame:TweenSize(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
                DropdownArrow.Text = "▼"
                DropdownFrame:TweenSize(UDim2.new(1, -20, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
            end)
        end
        
        -- Toggle dropdown
        local dropdownOpen = false
        
        local function ToggleDropdown()
            dropdownOpen = not dropdownOpen
            
            if dropdownOpen then
                OptionsFrame.Visible = true
                OptionsFrame:TweenSize(UDim2.new(1, 0, 0, math.min(#options * 35, 150)), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
                DropdownFrame:TweenSize(UDim2.new(1, -20, 0, 30 + math.min(#options * 35, 150)), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
                DropdownArrow.Text = "▲"
            else
                OptionsFrame:TweenSize(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
                DropdownFrame:TweenSize(UDim2.new(1, -20, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
                DropdownArrow.Text = "▼"
                
                -- Hide when animation completes
                task.delay(0.3, function()
                    if not dropdownOpen then
                        OptionsFrame.Visible = false
                    end
                end)
            end
        end
        
        DropdownFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                ToggleDropdown()
            end
        end)
        
        return {
            SetValue = function(value)
                if table.find(options, value) then
                    DropdownLabel.Text = text .. ": " .. value
                    callback(value)
                end
            end
        }
    end

    -- Lista de Bosses
    local bosses = {
        "Select...",
        "Saber Expert",
        "The Gorilla King",
        "Bobby",
        "Yeti",
        "The Saw",
        "Warden",
        "Chief Warden",
        "Swan",
        "Magma Admiral",
        "Fishman Lord",
        "Wysper",
        "Thunder God",
        "Cyborg",
        "Greybeard",
        "Diamond",
        "Jeremy",
        "Fajita",
        "Don Swan",
        "Smoke Admiral",
        "Cursed Captain",
        "Darkbeard",
        "Order",
        "Tide Keeper",
        "Awakened Ice Admiral",
        "Tide Keeper",
        "Stone",
        "Island Empress",
        "Kilo Admiral",
        "Captain Elephant",
        "Beautiful Pirate",
        "Cake Queen"
    }

    -- Boss Dropdown
    local BossDropdown = CreateDropdown(
        BossSection,
        "Select Boss",
        bosses,
        UDim2.new(0, 10, 0, 40),
        function(value)
            if value ~= "Select..." then
                Config.SelectedBoss = value
            end
        end
    )

    -- Instância do button para Farm Boss selecionado
    local FarmSelectedBoss = Instance.new("TextButton")
    FarmSelectedBoss.Name = "FarmSelectedBoss"
    FarmSelectedBoss.Size = UDim2.new(0.5, -15, 0, 30)
    FarmSelectedBoss.Position = UDim2.new(0, 10, 0, 90)
    FarmSelectedBoss.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    FarmSelectedBoss.BorderSizePixel = 0
    FarmSelectedBoss.Text = "Farm Selected Boss"
    FarmSelectedBoss.TextColor3 = Color3.fromRGB(255, 255, 255)
    FarmSelectedBoss.Font = Enum.Font.GothamBold
    FarmSelectedBoss.TextSize = 14
    FarmSelectedBoss.Parent = BossSection

    -- Rounded corners
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = FarmSelectedBoss

    -- Button para teleportar para boss
    local TeleportToBoss = Instance.new("TextButton")
    TeleportToBoss.Name = "TeleportToBoss"
    TeleportToBoss.Size = UDim2.new(0.5, -15, 0, 30)
    TeleportToBoss.Position = UDim2.new(0.5, 5, 0, 90)
    TeleportToBoss.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TeleportToBoss.BorderSizePixel = 0
    TeleportToBoss.Text = "Teleport to Boss"
    TeleportToBoss.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportToBoss.Font = Enum.Font.GothamBold
    TeleportToBoss.TextSize = 14
    TeleportToBoss.Parent = BossSection

    -- Rounded corners
    local TeleportCorner = Instance.new("UICorner")
    TeleportCorner.CornerRadius = UDim.new(0, 6)
    TeleportCorner.Parent = TeleportToBoss

    -- Clique para Farm Boss
    FarmSelectedBoss.MouseButton1Click:Connect(function()
        if Config.SelectedBoss and Config.SelectedBoss ~= "Select..." then
            Config.AutoFarmBoss = not Config.AutoFarmBoss
            
            if Config.AutoFarmBoss then
                FarmSelectedBoss.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
                FarmSelectedBoss.Text = "Stop Farm Boss"
                
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "XESTEER-HUB",
                    Text = "Farm Boss iniciado: " .. Config.SelectedBoss,
                    Duration = 3
                })
            else
                FarmSelectedBoss.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                FarmSelectedBoss.Text = "Farm Selected Boss"
                
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "XESTEER-HUB",
                    Text = "Farm Boss interrompido",
                    Duration = 3
                })
            end
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "XESTEER-HUB",
                Text = "Selecione um Boss primeiro!",
                Duration = 3
            })
        end
    end)

    -- Clique para Teleport Boss
    TeleportToBoss.MouseButton1Click:Connect(function()
        if Config.SelectedBoss and Config.SelectedBoss ~= "Select..." then
            task.spawn(function()
                TeleportToBoss.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
                TeleportToBoss.Text = "Teleporting..."
                
                -- Buscar boss
                local boss = Utilities:GetBoss(Config.SelectedBoss)
                
                if boss then
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "XESTEER-HUB",
                        Text = "Teleportando para: " .. Config.SelectedBoss,
                        Duration = 3
                    })
                    
                    Utilities:Teleport(boss.HumanoidRootPart.Position)
                else
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "XESTEER-HUB",
                        Text = "Boss não encontrado no servidor!",
                        Duration = 3
                    })
                end
                
                wait(1)
                TeleportToBoss.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                TeleportToBoss.Text = "Teleport to Boss"
            end)
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "XESTEER-HUB",
                Text = "Selecione um Boss primeiro!",
                Duration = 3
            })
        end
    end)

    -- Implementar Auto Farm de Mobs
    local function StartAutoFarm()
        if Config.AutoFarmNearest then
            local mob = Utilities:GetNearestMob(1000)
            
            if mob then
                -- Expand hitbox
                Utilities:ExpandHitbox(mob, 15)
                
                -- Teleport behind mob
                local mobPosition = mob.HumanoidRootPart.Position
                local behindPosition = mobPosition - mob.HumanoidRootPart.CFrame.lookVector * 5
                
                behindPosition = behindPosition + Vector3.new(0, 3, 0) -- Slight offset upwards
                
                Utilities:Teleport(behindPosition)
                
                -- Attack
                Utilities:Attack()
                
                return true
            end
        end
        
        if Config.AutoFarm then
            -- Auto Farm lógica baseada no nível
            local playerLevel = LocalPlayer.Data.Level.Value
            
            -- Find appropriate mobs based on level
            local mobNames = {}
            
            -- Level ranges for mobs
            if playerLevel < 10 then
                mobNames = {"Bandit"}
            elseif playerLevel < 20 then
                mobNames = {"Monkey"}
            elseif playerLevel < 30 then
                mobNames = {"Gorilla"}
            elseif playerLevel < 40 then
                mobNames = {"Pirate"}
            elseif playerLevel < 60 then
                mobNames = {"Desert Bandit"}
            elseif playerLevel < 75 then
                mobNames = {"Desert Officer"}
            elseif playerLevel < 90 then
                mobNames = {"Snow Bandit"}
            elseif playerLevel < 100 then
                mobNames = {"Snowman"}
            elseif playerLevel < 120 then
                mobNames = {"Chief Petty Officer"}
            elseif playerLevel < 150 then
                mobNames = {"Sky Bandit"}
            elseif playerLevel < 175 then
                mobNames = {"Dark Master"}
            elseif playerLevel < 190 then
                mobNames = {"Prisoner"}
            elseif playerLevel < 250 then
                mobNames = {"Dangerous Prisoner"}
            elseif playerLevel < 300 then
                mobNames = {"Swan Pirate"}
            elseif playerLevel < 350 then
                mobNames = {"Marine Captain"}
            elseif playerLevel < 375 then
                mobNames = {"Fishman Warrior"}
            elseif playerLevel < 400 then
                mobNames = {"Fishman Commando"}
            elseif playerLevel < 450 then
                mobNames = {"God's Guard"}
            elseif playerLevel < 475 then
                mobNames = {"Shanda"}
            elseif playerLevel < 525 then
                mobNames = {"Royal Squad"}
            elseif playerLevel < 550 then
                mobNames = {"Royal Soldier"}
            elseif playerLevel < 625 then
                mobNames = {"Galley Pirate"}
            elseif playerLevel < 650 then
                mobNames = {"Galley Captain"}
            else
                mobNames = {"Factory Staff", "Marine Lieutenant", "Marine Captain", "Zombie", "Vampire", "Snow Trooper", "Winter Warrior"}
            end
            
            -- Find nearest mob from the list
            local nearestMob = nil
            local shortestDistance = 1000
            
            for _, mobName in pairs(mobNames) do
                local mob = Utilities:GetMobByName(mobName, 1000)
                
                if mob then
                    local distance = (mob.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                    
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearestMob = mob
                    end
                end
            end
            
            if nearestMob then
                -- Expand hitbox
                Utilities:ExpandHitbox(nearestMob, 15)
                
                -- Teleport behind mob
                local mobPosition = nearestMob.HumanoidRootPart.Position
                local behindPosition = mobPosition - nearestMob.HumanoidRootPart.CFrame.lookVector * 5
                
                behindPosition = behindPosition + Vector3.new(0, 3, 0) -- Slight offset upwards
                
                Utilities:Teleport(behindPosition)
                
                -- Attack
                Utilities:Attack()
                
                return true
            end
        end
        
        if Config.AutoFarmBoss and Config.SelectedBoss then
            local boss = Utilities:GetBoss(Config.SelectedBoss)
            
            if boss then
                -- Expand hitbox
                Utilities:ExpandHitbox(boss, 15)
                
                -- Teleport behind boss
                local bossPosition = boss.HumanoidRootPart.Position
                local behindPosition = bossPosition - boss.HumanoidRootPart.CFrame.lookVector * 7
                
                behindPosition = behindPosition + Vector3.new(0, 5, 0) -- Slight offset upwards
                
                Utilities:Teleport(behindPosition)
                
                -- Attack
                Utilities:Attack()
                
                return true
            end
        end
        
        return false
    end

    -- Kill Aura
    local function StartKillAura()
        if Config.KillAura then
            local mob = Utilities:GetNearestMob(50)
            
            if mob then
                -- Expand hitbox
                Utilities:ExpandHitbox(mob, 15)
                
                -- Attack
                Utilities:Attack()
                
                return true
            end
        end
        
        return false
    end

    -- Main Loop
    task.spawn(function()
        while true do
            -- Auto Farm
            if Config.AutoFarm or Config.AutoFarmNearest or Config.AutoFarmBoss then
                StartAutoFarm()
            end
            
            -- Kill Aura
            if Config.KillAura then
                StartKillAura()
            end
            
            wait(0.1)
        end
    end)

    -- Fast Attack
    task.spawn(function()
        while wait() do
            if Config.FastAttack then
                pcall(function()
                    local Combat = LocalPlayer.Character:FindFirstChild("Combat") or LocalPlayer.Backpack:FindFirstChild("Combat")
                    if Combat then
                        for i = 1, 2 do
                            Combat.Parent = LocalPlayer.Character
                            Combat:Activate()
                        end
                    end
                    
                    -- Use equipped weapon
                    for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                        if v:IsA("Tool") and v.ToolTip == "Melee" then
                            v:Activate()
                        end
                    end
                end)
            end
        end
    end)

    -- Log Script Loaded
    print("╔═════════════════════════════════════════════════╗")
    print("║                XESTEER-HUB V4                   ║")
    print("╠═════════════════════════════════════════════════╣")
    print("║ ✓ Status: Script carregado com sucesso!         ║")
    print("║ ✓ Autor: Xesteer Team                           ║")
    print("║ ✓ Versão: Completa (Sem Key)                    ║") 
    print("║ ✓ Discord: discord.gg/7QjAc6y4ch                ║")
    print("╚═════════════════════════════════════════════════╝")

    -- Notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "XESTEER-HUB V4",
        Text = "Script carregado com sucesso!",
        Duration = 5
    })

    return XesteerHub
end

-- Início do Script
if game:IsLoaded() and GameSupported then
    local Success, Error = pcall(function()
        UI:Create()
    end)
    
    if not Success then
        warn("Erro ao carregar XESTEER-HUB: " .. Error)
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "XESTEER-HUB ERROR",
            Text = "Ocorreu um erro ao carregar o script. Tente novamente.",
            Duration = 5
        })
    end
end