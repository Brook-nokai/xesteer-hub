# XESTEER-HUB V4

Um script avançado para Blox Fruits baseado no HoHo Hub V4, sem sistema de key.

## Compatibilidade

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
- etc..

## Links

**Discord:** https://discord.gg/7QjAc6y4ch

## Opções de Carregamento

### Opção 1: Versão Direta (Recomendada)
```lua
--[[
    XESTEER-HUB V4
    Blox Fruits Script - Versão Super Avançada (Sem Key)
    100% Baseado no HoHo Hub V4 - Todos os recursos e designs originais
    
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

-- Versão 1: Direto com tela de carregamento personalizada
loadstring(game:HttpGet("https://raw.githubusercontent.com/xesteer-hub/scripts/main/xesteer-hub-full.lua"))()

-- Versão 2: Carregamento direto do HoHo Hub V4 (Sem Key)
--[[
_G.HohoV2 = true -- Define a variável global para pular o sistema de key
loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))()
]]
```

### Opção 2: Versão Completa com Interface Personalizada
```lua
--[[
    XESTEER-HUB V4
    Blox Fruits Script - Versão Super Avançada (Sem Key)
    100% Baseado no HoHo Hub V4 - Todos os recursos e designs originais
    
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

local GameId = game.GameId
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local ContentProvider = game:GetService("ContentProvider")

repeat task.wait() until game:IsLoaded() and Players.LocalPlayer

plr = Players.LocalPlayer

-- Definir variável para carregar script completo sem key
_G.HohoV2 = true

local isSupport = nil
local GameList = {
    [994732206] = "e4aedc7ccd2bacd83555baa884f3d4b1", -- Blox Fruit
    [7018190066] = "bf149e75708e91ad902bd72e408fae02", -- Dead Rails
    [383310974] = "b83e9255dc81e9392da975a89d26e363", -- Adopt Me
    [4777817887] = "35ad587b07c00b82c218fcf0e55eeea6", -- Blade Ball
    [5477548919] = "0a9bfef9eb03d0cb17dd85451e4be696", -- Honkai Star Rail Simulator
    [5750914919] = "b94343ca266a778e5da8d72e92d4aab5", -- Fisch
    [3359505957] = "095fbd843016a7af1d3a9ee88714c64a", -- Collect All Pets
    [6167925365] = "9d21987314f78380b8a21faec2f6e328", -- Cong Dong Viet Nam
    [5361032378] = "ff4e04500b94246eaa3f5c5be92a8b4a", -- Sol's RNG
}

for id, scriptid in pairs(GameList) do
    if id == GameId then
        isSupport = scriptid
    end
end

if _G.loadCustomId then
    isSupport = _G.loadCustomId
end

if not isSupport then
    loadstring(game:HttpGet('https://raw.githubusercontent.com/acsu123/HohoV2/refs/heads/main/ScriptLoadButOlder.lua'))()
    wait(9e9)
end

INFO_DOT25_QUAD = TweenInfo.new(.25,Enum.EasingStyle.Quad)

function CoreGuiAdd(gui)
    repeat wait() until pcall(function()
        gui.Parent = CoreGui
    end)
end

PreloadID = {
    "rbxassetid://4560909609",
    "rbxassetid://12187376174",
}
UI_LOCK = true

function isNotLocked(v)
    if not v:GetAttribute("Locked") and UI_LOCK == false then
        return true
    end
end

do      
    HOHO_Passcheck = Instance.new("ScreenGui")
    INTRO = Instance.new("CanvasGroup")
    Wallpaper = Instance.new("ImageLabel")
    TextHolder = Instance.new("Frame")
    Status = Instance.new("TextLabel")
    UITextSizeConstraint = Instance.new("UITextSizeConstraint")
    Gradient = Instance.new("Frame")
    UIGradient = Instance.new("UIGradient")
    Pattern = Instance.new("ImageLabel")
    Logo = Instance.new("ImageLabel")
    Main = Instance.new("ImageLabel")
    UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    Loader = Instance.new("Frame")
    Content = Instance.new("Frame")
    UIStroke = Instance.new("UIStroke")
    ImageLabel = Instance.new("ImageLabel")
    UIAspectRatioConstraint_1 = Instance.new("UIAspectRatioConstraint")
    UICorner = Instance.new("UICorner")
    GET_KEY = Instance.new("CanvasGroup")
    UICorner_1 = Instance.new("UICorner")
    Logo_1 = Instance.new("ImageLabel")
    UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")
    Get = Instance.new("TextButton")
    UICorner_2 = Instance.new("UICorner")
    UIStroke_1 = Instance.new("UIStroke")
    Title = Instance.new("TextLabel")
    Submit = Instance.new("TextButton")
    UICorner_3 = Instance.new("UICorner")
    UIStroke_2 = Instance.new("UIStroke")
    Title_1 = Instance.new("TextLabel")
    Pfp = Instance.new("ImageLabel")
    UICorner_4 = Instance.new("UICorner")
    Support = Instance.new("TextButton")
    UICorner_5 = Instance.new("UICorner")
    UIStroke_3 = Instance.new("UIStroke")
    Title_2 = Instance.new("TextLabel")
    Credit = Instance.new("TextLabel")
    Close = Instance.new("TextButton")
    Title_3 = Instance.new("TextLabel")
    UIStroke_4 = Instance.new("UIStroke")
    UICorner_6 = Instance.new("UICorner")
    Frame = Instance.new("Frame")
    UIStroke_5 = Instance.new("UIStroke")
    UIGradient_2 = Instance.new("UIGradient")
    UIGradient_3 = Instance.new("UIGradient")
    UICorner_7 = Instance.new("UICorner")
    Frame_1 = Instance.new("TextLabel")
    Frame_2 = Instance.new("TextBox")
    UIStroke_6 = Instance.new("UIStroke")
    UICorner_8 = Instance.new("UICorner")
    UICorner_9 = Instance.new("UICorner")
    Gradient_1 = Instance.new("Frame")
    UIGradient_1 = Instance.new("UIGradient")
    Pattern_1 = Instance.new("ImageLabel")
    Hover = Instance.new("ImageLabel")
    local Hover_2
    Gradient_Frame = Instance.new("Frame")
    UIGradient_4 = Instance.new("UIGradient")

    HOHO_Passcheck.IgnoreGuiInset = true
    HOHO_Passcheck.ResetOnSpawn = false
    HOHO_Passcheck.Name = "Xesteer_Hub"
    HOHO_Passcheck.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
    HOHO_Passcheck.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    CoreGuiAdd(HOHO_Passcheck)
    HOHO_Passcheck.Enabled = true

    INTRO.BorderSizePixel = 0
    INTRO.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    INTRO.AnchorPoint = Vector2.new(0.5, 0.5)
    INTRO.Size = UDim2.new(0.455271, 0, 0.46186, 0)
    INTRO.ZIndex = 990
    INTRO.Name = "INTRO"
    INTRO.Position = UDim2.new(0.5, 0, 0.5, 0)
    INTRO.BorderColor3 = Color3.fromRGB(0, 0, 0)
    INTRO.Parent = HOHO_Passcheck

    Hover.ImageColor3 = Color3.fromRGB(255, 51, 51)
    Hover.BorderSizePixel = 0
    Hover.SliceCenter = Rect.new(205, 197, 828, 828)
    Hover.ScaleType = Enum.ScaleType.Slice
    Hover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Hover.ImageTransparency = 1
    Hover.Position = UDim2.new(0.5, 0, 0.5, 0)
    Hover.Name = "Hover"
    Hover.AnchorPoint = Vector2.new(0.5, 0.5)
    Hover.Image = "rbxassetid://16261022724"
    Hover.Size = UDim2.new(1.055, 0, 1.45, 0)
    Hover.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Hover.BackgroundTransparency = 1
    Hover.Parent = Get

    Hover_2 = Hover:Clone()
    Hover_2.Parent = Submit

    Wallpaper.BorderSizePixel = 0
    Wallpaper.ScaleType = Enum.ScaleType.Fit
    Wallpaper.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Wallpaper.Position = UDim2.new(-0.0361702, 0, -0.158876, 0)
    Wallpaper.Name = "Wallpaper"
    Wallpaper.Image = "rbxassetid://16073585738"
    Wallpaper.Size = UDim2.new(1.11064, 0, 1.59989, 0)
    Wallpaper.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Wallpaper.Parent = INTRO

    TextHolder.BorderSizePixel = 0
    TextHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TextHolder.Size = UDim2.new(1, 0, 0.284847, 0)
    TextHolder.BorderColor3 = Color3.fromRGB(30, 30, 30)
    TextHolder.Name = "TextHolder"
    TextHolder.Position = UDim2.new(0, 0, 0.753631, 0)
    TextHolder.Parent = INTRO

    Status.TextWrapped = true
    Status.BorderSizePixel = 0
    Status.TextScaled = true
    Status.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Status.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Italic)
    Status.Position = UDim2.new(0.120042, 0, 0.254529, 0)
    Status.Name = "Status"
    Status.TextSize = 20
    Status.Size = UDim2.new(0.79993, 0, 0.464041, 0)
    Status.ZIndex = 2
    Status.TextColor3 = Color3.fromRGB(255, 255, 255)
    Status.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Status.Text = "Carregando XESTEER HUB para uma experiência incrível..."
    Status.BackgroundTransparency = 1
    Status.Parent = TextHolder
    Status:SetAttribute("EngText", Status.Text)

    UITextSizeConstraint.MaxTextSize = 20
    UITextSizeConstraint.Parent = Status

    Gradient.BorderSizePixel = 0
    Gradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Gradient.Size = UDim2.new(1, 0, 1, 0)
    Gradient.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Gradient.Name = "Gradient"
    Gradient.Position = UDim2.new(0, 0, 2.11993e-08, 0)
    Gradient.Parent = TextHolder

    UIGradient.Transparency = NumberSequence.new{ NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(1, 0.9) }
    UIGradient.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, Color3.fromRGB(157, 2, 31)), ColorSequenceKeypoint.new(0.466321, Color3.fromRGB(139.758, 6.07549, 31.0759)), ColorSequenceKeypoint.new(0.797927, Color3.fromRGB(46.7098, 28.0691, 31.4853)), ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30)) }
    UIGradient.Rotation = -90
    UIGradient.Parent = Gradient

    Pattern.SliceCenter = Rect.new(0, 256, 0, 256)
    Pattern.ScaleType = Enum.ScaleType.Tile
    Pattern.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Pattern.ImageTransparency = 0.6
    Pattern.Position = UDim2.new(6.64996e-05, 0, 0.00124399, 0)
    Pattern.Name = "Pattern"
    Pattern.Image = "rbxassetid://2151741365"
    Pattern.TileSize = UDim2.new(0, 250, 0, 250)
    Pattern.Size = UDim2.new(1, 0, 1, 0)
    Pattern.ZIndex = 0
    Pattern.BackgroundTransparency = 1
    Pattern.Parent = Gradient

    Logo.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Logo.BorderSizePixel = 0
    Logo.ScaleType = Enum.ScaleType.Fit
    Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Logo.ImageTransparency = 0.5
    Logo.Position = UDim2.new(0.271609, 0, 0.122057, 0)
    Logo.Name = "Logo"
    Logo.Image = "rbxassetid://14232580420" -- Xesteer Logo
    Logo.Size = UDim2.new(0.453191, 0, 0.550704, 0)
    Logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Logo.ZIndex = 2
    Logo.BackgroundTransparency = 1
    Logo.Parent = INTRO

    Main.BorderSizePixel = 0
    Main.ScaleType = Enum.ScaleType.Fit
    Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Name = "Main"
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Image = "rbxassetid://14232580420" -- Xesteer Logo
    Main.Size = UDim2.new(0.95, 0, 0.95, 0)
    Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Main.BackgroundTransparency = 1
    Main.Parent = Logo

    UIAspectRatioConstraint.AspectRatio = 2.08357
    UIAspectRatioConstraint.Parent = INTRO

    Loader.BorderSizePixel = 0
    Loader.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    Loader.Size = UDim2.new(0.999948, 0, 0.0285966, 0)
    Loader.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Loader.Name = "Loader"
    Loader.Position = UDim2.new(0, 0, 0.751682, 0)
    Loader.ZIndex = 2
    Loader.Parent = INTRO

    Content.BorderSizePixel = 0
    Content.BackgroundColor3 = Color3.fromRGB(255, 51, 51)
    Content.Size = UDim2.new(0.462745, 0, 1, 0)
    Content.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Content.Name = "Content"
    Content.Parent = Loader

    UIStroke.Transparency = 0.5
    UIStroke.Parent = Content

    ImageLabel.ImageColor3 = Color3.fromRGB(255, 46, 46)
    ImageLabel.BorderSizePixel = 0
    ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel.Position = UDim2.new(1, 0, .5, 0)
    ImageLabel.AnchorPoint = Vector2.new(.5,.5)
    ImageLabel.Image = "rbxassetid://16073652319"
    ImageLabel.Size = UDim2.new(0.671884, 0, 15.1201, 0)
    ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Parent = Content

    UIAspectRatioConstraint_1.AspectRatio = 1.49814
    UIAspectRatioConstraint_1.Parent = ImageLabel

    UICorner.CornerRadius = UDim.new(0, 30)
    UICorner.Parent = INTRO

    GET_KEY.BorderSizePixel = 0
    GET_KEY.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    GET_KEY.AnchorPoint = Vector2.new(0.5, 0.5)
    GET_KEY.Size = UDim2.new(0.359117, 0, 0.665296, 0)
    GET_KEY.ZIndex = 990
    GET_KEY.Name = "GET_KEY"
    GET_KEY.Position = UDim2.new(0.5, 0, 0.5, 0)
    GET_KEY.BorderColor3 = Color3.fromRGB(0, 0, 0)
    GET_KEY.Parent = HOHO_Passcheck
    GET_KEY.Visible = false -- Desabilitar tela de key

    UICorner_1.CornerRadius = UDim.new(0.075, 0)
    UICorner_1.Parent = GET_KEY

    Logo_1.BorderSizePixel = 0
    Logo_1.ScaleType = Enum.ScaleType.Fit
    Logo_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Logo_1.Position = UDim2.new(0.256362, 0, 0.0700547, 0)
    Logo_1.Name = "Logo"
    Logo_1.Image = "rbxassetid://14232580420" -- Xesteer Logo
    Logo_1.Size = UDim2.new(0.481145, 0, 0.133585, 0)
    Logo_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Logo_1.ZIndex = 2
    Logo_1.BackgroundTransparency = 1
    Logo_1.Parent = GET_KEY

    UIAspectRatioConstraint_2.AspectRatio = 1.14096
    UIAspectRatioConstraint_2.Parent = GET_KEY

    -- Pular tela de key e carregar script diretamente
    task.spawn(function()
        task.wait(3) -- Aguardar 3 segundos para animação de carregamento
        
        -- Mensagem de status
        Status.Text = "XESTEER HUB carregado com sucesso! Versão sem Key."
        
        -- Carregar o script completo
        local success, result = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/acsu123/HOHO_H/main/GameScripts/Game'..isSupport..'.lua'))()
        end)
        
        if not success then
            warn("Erro ao carregar script:", result)
            Status.Text = "Erro ao carregar XESTEER HUB. Tente novamente."
        end
    end)

    -- Animação de carregamento
    task.spawn(function()
        for i = 1, 100 do
            Content:TweenSize(UDim2.new(i/100, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.03, true)
            task.wait(0.03)
        end
    end)
    
    -- Notificação
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "XESTEER-HUB V4",
        Text = "Versão sem Key - Carregando...",
        Duration = 5
    })
end
```

### Opção 3: Versão Simplificada
```lua
--[[
    XESTEER-HUB LOADER
    Versão Simplificada para Compartilhamento (Sem Key)
]]

loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))()

-- Modificando objeto global para carregar o script completo do HoHo Hub
_G.HohoV2 = true
```

## Recursos

- Auto Farm
- Kill Aura
- Farm de Boss
- Hitbox Expander
- Auto Raid
- Teleporte para ilhas
- Dungeon Helper
- Fast Attack
- Devil Fruit Finder
- Auto Buy Haki/Sword
- Chest Farm
- NoClip
- E muito mais!

## Como usar

1. Copie um dos scripts acima
2. Cole no seu executor (Delta, Codex, Fluxus, etc.)
3. Execute o script
4. Aproveite todas as funcionalidades sem precisar de key!

## Nota importante

Este script é baseado no HoHo Hub V4, mantendo todas as suas funcionalidades mas removendo as restrições de key system. O Xesteer Hub foi projetado para ser compatível com QUALQUER executor de Roblox.
