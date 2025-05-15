--[[
    ██╗  ██╗███████╗███████╗████████╗███████╗███████╗██████╗     ██╗  ██╗██╗   ██╗██████╗ 
    ╚██╗██╔╝██╔════╝██╔════╝╚══██╔══╝██╔════╝██╔════╝██╔══██╗    ██║  ██║██║   ██║██╔══██╗
     ╚███╔╝ █████╗  ███████╗   ██║   █████╗  █████╗  ██████╔╝    ███████║██║   ██║██████╔╝
     ██╔██╗ ██╔══╝  ╚════██║   ██║   ██╔══╝  ██╔══╝  ██╔══██╗    ██╔══██║██║   ██║██╔══██╗
    ██╔╝ ██╗███████╗███████║   ██║   ███████╗███████╗██║  ██║    ██║  ██║╚██████╔╝██████╔╝
    ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   ╚══════╝╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 

    ███████╗██████╗ ███████╗███████╗    ███████╗██████╗ ██╗████████╗██╗ ██████╗ ███╗   ██╗
    ██╔════╝██╔══██╗██╔════╝██╔════╝    ██╔════╝██╔══██╗██║╚══██╔══╝██║██╔═══██╗████╗  ██║
    █████╗  ██████╔╝█████╗  █████╗      █████╗  ██║  ██║██║   ██║   ██║██║   ██║██╔██╗ ██║
    ██╔══╝  ██╔══██╗██╔══╝  ██╔══╝      ██╔══╝  ██║  ██║██║   ██║   ██║██║   ██║██║╚██╗██║
    ██║     ██║  ██║███████╗███████╗    ███████╗██████╔╝██║   ██║   ██║╚██████╔╝██║ ╚████║
    ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝    ╚══════╝╚═════╝ ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝

    xesteer Hub v3.0.0 - EDIÇÃO GRATUITA - SCRIPT UNIVERSAL MULTIJOGOS
    
    → RECURSOS GERAIS (TODOS OS JOGOS SUPORTADOS):
      • Auto Farm Inteligente
      • Sistema Anti-Detecção
      • Proteção contra Kicks e Bans
      • Farm de Recursos com IA
      • Interface com Temas Personalizados
      • Otimizador de Performance
      • ESP completo (Jogadores, NPCs, Itens)
      • Teleporte Inteligente
      • Multi-instância (Vários jogos simultâneos)
    
    → RECURSOS ESPECIAIS POR JOGO:
      • BLOX FRUITS: Farm Total, Raid Auto, Frutas Auto, Boss Auto, Dungeon Auto
      • KING LEGACY: Níveis Auto, Farm Frutas, Quests Auto, Batalhas PvP
      • BROOKHAVEN: Teleportes, Itens Grátis, Controle Total, Admin Local
      • PET SIMULATOR 99: Farm Automático, Pets Auto, Encubar, Crafting
      • FISCH: Captura Automática, Farm de Raridades, Coleção Completa
      • BLUE LOCK: Gols Automáticos, Farm Habilidades, Treino Intensivo
      • DEAD RAILS: Auto Aim, ESP Avançado, Farm Recursos, Buff Armas
      • BLADE BALL: Auto Parry, Auto Win, Reflexo Perfeito, Combos Pro
      • DEATH BALL: Anti-Morte, Auto Bloco, Aimbot Avançado, Táticas Pro
    
    → COMO USAR:
      1. Execute o script em qualquer jogo Roblox
      2. Selecione o jogo e módulos desejados
      3. Configure a seu gosto e divirta-se!
      4. 100% GRATUITO e SEM LIMITAÇÕES!
]]

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")

-- Variables
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- Usar pcall para evitar erros caso o personagem não tenha carregado completamente
local Humanoid, HumanoidRootPart
local success, errorMsg = pcall(function()
    Humanoid = Character:WaitForChild("Humanoid", 10)
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 10)
end)

if not success then
    -- Tentar novamente em caso de falha
    wait(1)
    Character = Player.Character or Player.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid", 10)
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 10)
end

local Camera = workspace.CurrentCamera or workspace:WaitForChild("Camera")

-- Sistema de Boas-Vindas
local function InicializarScript()
    -- Informações do usuário para estatísticas anônimas (sem coleta de dados pessoais)
    local Estatisticas = {
        Jogo = game.PlaceId,
        DataHora = os.date("%Y-%m-%d %H:%M:%S"),
        Versao = "v3.0.0 - FREE EDITION"
    }
    
    -- Mostrar mensagem de boas-vindas com animação
    local function MostrarBoasVindas()
        local GUI = Instance.new("ScreenGui")
        GUI.Name = "xesteerWelcome"
        GUI.Parent = game.CoreGui
        
        -- Fundo escurecido para destaque
        local Fundo = Instance.new("Frame")
        Fundo.Size = UDim2.new(1, 0, 1, 0)
        Fundo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Fundo.BackgroundTransparency = 0.7
        Fundo.BorderSizePixel = 0
        Fundo.Parent = GUI
        
        -- Frame principal com efeito de entrada
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0, 500, 0, 300)
        Frame.Position = UDim2.new(0.5, -250, 0.5, -150)
        Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        Frame.BorderSizePixel = 0
        Frame.Parent = GUI
        
        -- Cantos arredondados
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 12)
        UICorner.Parent = Frame
        
        -- Logo (versão texto)
        local Logo = Instance.new("TextLabel")
        Logo.Size = UDim2.new(1, 0, 0, 70)
        Logo.Position = UDim2.new(0, 0, 0, 20)
        Logo.BackgroundTransparency = 1
        Logo.TextColor3 = Color3.fromRGB(100, 170, 255)
        Logo.TextSize = 40
        Logo.Font = Enum.Font.GothamBold
        Logo.Text = "xesteer Hub"
        Logo.Parent = Frame
        
        -- Subtítulo
        local Subtitulo = Instance.new("TextLabel")
        Subtitulo.Size = UDim2.new(1, 0, 0, 30)
        Subtitulo.Position = UDim2.new(0, 0, 0, 80)
        Subtitulo.BackgroundTransparency = 1
        Subtitulo.TextColor3 = Color3.fromRGB(255, 215, 0)
        Subtitulo.TextSize = 20
        Subtitulo.Font = Enum.Font.GothamSemibold
        Subtitulo.Text = "EDIÇÃO GRATUITA - SEM LIMITES"
        Subtitulo.Parent = Frame
        
        -- Mensagem
        local Mensagem = Instance.new("TextLabel")
        Mensagem.Size = UDim2.new(1, -80, 0, 90)
        Mensagem.Position = UDim2.new(0, 40, 0, 120)
        Mensagem.BackgroundTransparency = 1
        Mensagem.TextColor3 = Color3.fromRGB(230, 230, 230)
        Mensagem.TextSize = 18
        Mensagem.Font = Enum.Font.Gotham
        Mensagem.Text = "Bem-vindo ao xesteer Hub!\n\nO script está sendo inicializado para " .. 
                         (pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId).Name end) and MarketplaceService:GetProductInfo(game.PlaceId).Name or "este jogo") .. 
                         ".\n\nAproveite todos os recursos sem limitações!"
        Mensagem.TextWrapped = true
        Mensagem.Parent = Frame
        
        -- Botão Continuar
        local BotaoContinuar = Instance.new("TextButton")
        BotaoContinuar.Size = UDim2.new(0, 200, 0, 50)
        BotaoContinuar.Position = UDim2.new(0.5, -100, 1, -70)
        BotaoContinuar.BackgroundColor3 = Color3.fromRGB(70, 130, 220)
        BotaoContinuar.TextColor3 = Color3.fromRGB(255, 255, 255)
        BotaoContinuar.TextSize = 20
        BotaoContinuar.Font = Enum.Font.GothamBold
        BotaoContinuar.Text = "INICIAR"
        BotaoContinuar.Parent = Frame
        
        -- Arredondar botão
        local UICornerBotao = Instance.new("UICorner")
        UICornerBotao.CornerRadius = UDim.new(0, 8)
        UICornerBotao.Parent = BotaoContinuar
        
        -- Efeito de brilho no botão
        local Brilho = Instance.new("UIGradient")
        Brilho.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 160, 235)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(70, 130, 220)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 190))
        })
        Brilho.Rotation = 30
        Brilho.Parent = BotaoContinuar
        
        -- Efeitos de hover no botão
        BotaoContinuar.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(
                BotaoContinuar,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = Color3.fromRGB(90, 150, 240), Size = UDim2.new(0, 210, 0, 55)}
            ):Play()
        end)
        
        BotaoContinuar.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(
                BotaoContinuar,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = Color3.fromRGB(70, 130, 220), Size = UDim2.new(0, 200, 0, 50)}
            ):Play()
        end)
        
        -- Animação da barra de progresso
        local BarraProgresso = Instance.new("Frame")
        BarraProgresso.Size = UDim2.new(0, 0, 0, 5)
        BarraProgresso.Position = UDim2.new(0, 0, 1, -10)
        BarraProgresso.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        BarraProgresso.BorderSizePixel = 0
        BarraProgresso.Parent = Frame
        
        -- Animar barra de progresso
        spawn(function()
            for i = 0, 100, 2 do
                BarraProgresso.Size = UDim2.new(i/100, 0, 0, 5)
                wait(0.02)
            end
        end)
        
        -- Animação de entrada
        Frame.Position = UDim2.new(0.5, -250, 1.5, 0)
        Fundo.BackgroundTransparency = 1
        
        game:GetService("TweenService"):Create(
            Frame,
            TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, -250, 0.5, -150)}
        ):Play()
        
        game:GetService("TweenService"):Create(
            Fundo,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0.7}
        ):Play()
        
        -- Fechar GUI ao clicar no botão
        BotaoContinuar.MouseButton1Click:Connect(function()
            -- Efeito de clique
            game:GetService("TweenService"):Create(
                BotaoContinuar,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = Color3.fromRGB(50, 100, 190), Size = UDim2.new(0, 195, 0, 45)}
            ):Play()
            
            wait(0.2)
            
            -- Animação de saída
            local saidaFrame = game:GetService("TweenService"):Create(
                Frame,
                TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {Position = UDim2.new(0.5, -250, -0.5, 0)}
            )
            
            local saidaFundo = game:GetService("TweenService"):Create(
                Fundo,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundTransparency = 1}
            )
            
            saidaFrame:Play()
            saidaFundo:Play()
            
            saidaFrame.Completed:Connect(function()
                GUI:Destroy()
            end)
        end)
        
        return true
    end
    
    -- Mostrar mensagem de boas-vindas e iniciar o script
    return MostrarBoasVindas()
end

-- Tabela com URLs das imagens de fundo para cada jogo
local game_background_images = {
    ["Blox Fruits"] = "rbxassetid://12254697162",  -- Imagem de fundo do Blox Fruits
    ["King Legacy"] = "rbxassetid://10103468748",  -- Imagem de fundo do King Legacy
    ["Brookhaven"] = "rbxassetid://8761041357",    -- Imagem de fundo do Brookhaven
    ["Pet Simulator 99"] = "rbxassetid://15602466702", -- Imagem de fundo do Pet Simulator 99
    ["Fisch"] = "rbxassetid://14913437338",        -- Imagem de fundo do Fisch
    ["BLUE Lock"] = "rbxassetid://14509977184",    -- Imagem de fundo do BLUE Lock
    ["Dead Rails"] = "rbxassetid://13993205190",   -- Imagem de fundo do Dead Rails
    ["Blade Ball"] = "rbxassetid://14397037957",   -- Imagem de fundo do Blade Ball
    ["Death Ball"] = "rbxassetid://15500234707"    -- Imagem de fundo do Death Ball
}

-- Tabela com cores primárias e secundárias para cada jogo
local game_theme_colors = {
    ["Blox Fruits"] = {
        primary = Color3.fromRGB(65, 105, 225),   -- Azul royal
        secondary = Color3.fromRGB(50, 50, 80),   -- Azul escuro
        accent = Color3.fromRGB(255, 215, 0)      -- Dourado
    },
    ["King Legacy"] = {
        primary = Color3.fromRGB(128, 0, 128),    -- Roxo
        secondary = Color3.fromRGB(50, 30, 70),   -- Roxo escuro
        accent = Color3.fromRGB(255, 215, 0)      -- Dourado
    },
    ["Brookhaven"] = {
        primary = Color3.fromRGB(46, 204, 113),   -- Verde
        secondary = Color3.fromRGB(30, 60, 40),   -- Verde escuro
        accent = Color3.fromRGB(240, 240, 240)    -- Branco
    },
    ["Pet Simulator 99"] = {
        primary = Color3.fromRGB(255, 165, 0),    -- Laranja
        secondary = Color3.fromRGB(70, 50, 20),   -- Marrom
        accent = Color3.fromRGB(255, 255, 100)    -- Amarelo
    },
    ["Fisch"] = {
        primary = Color3.fromRGB(0, 150, 255),    -- Azul água
        secondary = Color3.fromRGB(20, 40, 60),   -- Azul marinho
        accent = Color3.fromRGB(200, 255, 255)    -- Ciano claro
    },
    ["BLUE Lock"] = {
        primary = Color3.fromRGB(0, 102, 204),    -- Azul
        secondary = Color3.fromRGB(20, 30, 50),   -- Azul escuro
        accent = Color3.fromRGB(255, 255, 255)    -- Branco
    },
    ["Dead Rails"] = {
        primary = Color3.fromRGB(139, 0, 0),      -- Vermelho escuro
        secondary = Color3.fromRGB(40, 20, 20),   -- Vermelho muito escuro
        accent = Color3.fromRGB(169, 169, 169)    -- Cinza
    },
    ["Blade Ball"] = {
        primary = Color3.fromRGB(211, 84, 0),     -- Laranja escuro
        secondary = Color3.fromRGB(50, 30, 10),   -- Marrom
        accent = Color3.fromRGB(255, 255, 255)    -- Branco
    },
    ["Death Ball"] = {
        primary = Color3.fromRGB(120, 0, 0),      -- Vermelho sangue
        secondary = Color3.fromRGB(40, 10, 10),   -- Vermelho muito escuro
        accent = Color3.fromRGB(50, 50, 50)       -- Cinza escuro
    }
}

-- Função para mostrar notificação de carregamento
local function ShowLoadingNotification(gameName)
    local notification = Instance.new("ScreenGui")
    notification.Name = "xesteerHubNotification"
    notification.Parent = game.CoreGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0.5, -50)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.BorderSizePixel = 0
    frame.Parent = notification
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(45, 45, 75)
    title.BorderSizePixel = 0
    title.Text = "xesteer Hub"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.SourceSansBold
    title.Parent = frame
    
    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, 0, 1, -30)
    message.Position = UDim2.new(0, 0, 0, 30)
    message.BackgroundTransparency = 1
    message.Text = "Carregando script para " .. gameName .. "...\nPor favor, aguarde."
    message.TextColor3 = Color3.fromRGB(255, 255, 255)
    message.TextSize = 14
    message.Font = Enum.Font.SourceSans
    message.Parent = frame
    
    return notification
end

-- Função para criar uma notificação de erro
local function ShowErrorNotification(title, message, auto_close_time)
    auto_close_time = auto_close_time or 10 -- Padrão: 10 segundos
    
    local error_gui = Instance.new("ScreenGui")
    error_gui.Name = "xesteerHubErrorNotification"
    error_gui.Parent = game.CoreGui
    
    local error_frame = Instance.new("Frame")
    error_frame.Size = UDim2.new(0, 300, 0, 120)
    error_frame.Position = UDim2.new(0.5, -150, 0.8, -60)
    error_frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    error_frame.BorderSizePixel = 0
    error_frame.Parent = error_gui
    
    local error_title = Instance.new("TextLabel")
    error_title.Size = UDim2.new(1, 0, 0, 30)
    error_title.BackgroundColor3 = Color3.fromRGB(180, 70, 70)
    error_title.BorderSizePixel = 0
    error_title.Text = title
    error_title.TextColor3 = Color3.fromRGB(255, 255, 255)
    error_title.TextSize = 16
    error_title.Font = Enum.Font.SourceSansBold
    error_title.Parent = error_frame
    
    local error_message = Instance.new("TextLabel")
    error_message.Size = UDim2.new(1, -20, 1, -40)
    error_message.Position = UDim2.new(0, 10, 0, 35)
    error_message.BackgroundTransparency = 1
    error_message.Text = message
    error_message.TextColor3 = Color3.fromRGB(255, 255, 255)
    error_message.TextSize = 14
    error_message.TextWrapped = true
    error_message.TextXAlignment = Enum.TextXAlignment.Left
    error_message.TextYAlignment = Enum.TextYAlignment.Top
    error_message.Font = Enum.Font.SourceSans
    error_message.Parent = error_frame
    
    -- Efeito de aparecer
    error_frame.Position = UDim2.new(0.5, -150, 1.1, 0)
    local tween = game:GetService("TweenService"):Create(
        error_frame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -150, 0.8, -60)}
    )
    tween:Play()
    
    -- Auto-fechar
    spawn(function()
        wait(auto_close_time)
        if error_gui and error_gui.Parent then
            -- Efeito de desaparecer
            local close_tween = game:GetService("TweenService"):Create(
                error_frame,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {Position = UDim2.new(0.5, -150, 1.1, 0)}
            )
            close_tween:Play()
            close_tween.Completed:Wait()
            error_gui:Destroy()
        end
    end)
    
    return error_gui
end

-- Verificar conexão à internet
local function CheckInternetConnection()
    local success, result = pcall(function()
        return HttpService:GetAsync("https://google.com", true)
    end)
    
    return success
end

-- Função para criar uma interface estilizada para seleção de scripts
local function ShowScriptSelector(game_name, scripts_table)
    -- Obter cores do tema para o jogo atual (ou usar cores padrão se não encontradas)
    local theme = game_theme_colors[game_name] or {
        primary = Color3.fromRGB(45, 45, 75),
        secondary = Color3.fromRGB(25, 25, 35),
        accent = Color3.fromRGB(255, 255, 255)
    }
    
    local background_image = game_background_images[game_name]
    
    -- Criar GUI para seleção de script
    local selector_gui = Instance.new("ScreenGui")
    selector_gui.Name = "xesteerHubSelector"
    selector_gui.Parent = game.CoreGui
    
    -- Efeito de fundo escuro semi-transparente
    local darkener = Instance.new("Frame")
    darkener.Size = UDim2.new(1, 0, 1, 0)
    darkener.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    darkener.BackgroundTransparency = 0.5
    darkener.BorderSizePixel = 0
    darkener.Parent = selector_gui
    
    -- Frame principal com animação de entrada
    local main_frame = Instance.new("Frame")
    main_frame.Size = UDim2.new(0, 430, 0, 430)
    main_frame.Position = UDim2.new(0.5, -215, 0.5, -215)
    main_frame.BackgroundColor3 = theme.secondary
    main_frame.BorderSizePixel = 0
    main_frame.ClipsDescendants = true
    main_frame.Active = true
    main_frame.Draggable = true
    main_frame.Parent = selector_gui
    
    -- Cantos arredondados
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = main_frame
    
    -- Sombra
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTranspar