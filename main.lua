--[[
    🍑 BUNDA SECA HUB v34 - FINAL EDITION 🍑
    Status: SEM KEY | TWEEN ATUALIZADO | FAST ATTACK V3
    Compatibilidade: Mobile & PC
]]

-- 1. OTIMIZAÇÃO INICIAL (EVITA CRASH)
if not game:IsLoaded() then game.Loaded:Wait() end
setfpscap(60) -- Estabiliza o FPS no Mobile

-- 2. CARREGANDO BIBLIOTECA MODERNA (ORION)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "Bunda Seca Hub 🍑 v34", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "BundaSecaV34",
    IntroEnabled = true,
    IntroText = "Bunda Seca Hub v34"
})

-- 3. SERVIÇOS E VARIÁVEIS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VIM = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer

-- FLAGS (CONTROLES)
_G.AutoFarmNearest = false
_G.AutoFarmChest = false
_G.FastAttack = false
_G.AutoBones = false
_G.AutoStats = false
_G.SelectedStat = "Melee" -- Padrão

-- =============================================
-- 🛠️ FUNÇÕES NUCLEARES (ENGINE)
-- =============================================

-- TWEEN (VOO SUAVE - ANTI KICK)
local function TweenTo(targetCFrame)
    local Character = LP.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    
    local Root = Character.HumanoidRootPart
    local Distance = (Root.Position - targetCFrame.Position).Magnitude
    local Speed = 300 -- Velocidade do voo
    local Time = Distance / Speed
    
    local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
    local Tween = TweenService:Create(Root, Info, {CFrame = targetCFrame})
    
    -- Desativa colisão para passar por paredes
    for _, v in pairs(Character:GetChildren()) do
        if v:IsA("BasePart") then v.CanCollide = false end
    end
    
    if Distance < 10 then
        Root.CFrame = targetCFrame -- Teleporte final preciso
    else
        Tween:Play()
    end
end

-- FAST ATTACK V3 (MÉTODO TRIPLO PARA MOBILE)
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait() -- Ultra Rápido
        if _G.FastAttack then
            pcall(function()
                local Tool = LP.Character:FindFirstChildOfClass("Tool")
                if Tool then
                    -- 1. Ativação Nativa
                    Tool:Activate()
                    -- 2. Virtual Input (Mobile)
                    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    -- 3. Reset de Animação (Visual)
                    LP.Character.Humanoid:ChangeState(11)
                end
            end)
        end
    end
end)

-- =============================================
-- 🖥️ INTERFACE (TABS)
-- =============================================

-- [ TAB: FARM ]
local TabFarm = Window:MakeTab({Name = "Auto Farm", Icon = "rbxassetid://4483345998"})

TabFarm:AddSection({Name = "Ataque & Farm Geral"})

TabFarm:AddToggle({
    Name = "Fast Attack (Super Rápido)",
    Default = false,
    Callback = function(Value)
        _G.FastAttack = Value
    end    
})

TabFarm:AddToggle({
    Name = "Auto Farm Nearest (Mata quem estiver perto)",
    Default = false,
    Callback = function(Value)
        _G.AutoFarmNearest = Value
        _G.FastAttack = Value -- Liga o ataque junto
        
        task.spawn(function()
            while _G.AutoFarmNearest do
                task.wait()
                pcall(function()
                    local ClosestEnemy = nil
                    local ShortestDist = 99999
                    
                    -- Busca inimigo mais próximo
                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                            local Dist = (LP.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                            if Dist < ShortestDist then
                                ShortestDist = Dist
                                ClosestEnemy = v
                            end
                        end
                    end
                    
                    -- Se achou, vai até ele
                    if ClosestEnemy then
                        -- Voa para 7 studs acima da cabeça do bicho
                        TweenTo(ClosestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0) * CFrame.Angles(math.rad(-90), 0, 0))
                        
                        -- Equipa arma automaticamente
                        if not LP.Character:FindFirstChildOfClass("Tool") then
                            local Weapon = LP.Backpack:FindFirstChildOfClass("Tool")
                            if Weapon then LP.Character.Humanoid:EquipTool(Weapon) end
                        end
                    end
                end)
            end
        end)
    end    
})

-- [ TAB: ITENS & MUNDO ]
local TabItems = Window:MakeTab({Name = "Items/World", Icon = "rbxassetid://4483345998"})

TabItems:AddToggle({
    Name = "Auto Chest (Farm de Baús)",
    Default = false,
    Callback = function(Value)
        _G.AutoFarmChest = Value
        task.spawn(function()
            while _G.AutoFarmChest do
                task.wait(0.5) -- Delay para não crashar
                pcall(function()
                    local ChestFound = false
                    -- Procura baús no mapa (vários nomes possíveis)
                    for _, v in pairs(game.Workspace:GetDescendants()) do
                        if v.Name:find("Chest") and v:IsA("Part") then
                            ChestFound = true
                            TweenTo(v.CFrame)
                            if (LP.Character.HumanoidRootPart.Position - v.Position).Magnitude < 5 then
                                wait(0.5) -- Espera coletar
                            end
                            break -- Vai um por um
                        end
                    end
                    if not ChestFound then
                        OrionLib:MakeNotification({Name = "Aviso", Content = "Sem baús por perto!", Time = 3})
                        wait(2)
                    end
                end)
            end
        end)
    end    
})

TabItems:AddToggle({
    Name = "Auto Bones (Haunted Castle)",
    Default = false,
    Callback = function(Value)
        _G.AutoBones = Value
        _G.FastAttack = Value
        -- Configuração Fixa para Haunted Castle
        task.spawn(function()
            while _G.AutoBones do
                task.wait()
                pcall(function()
                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name:find("Skeleton") or v.Name:find("Zombie") or v.Name:find("Possessed") then
                            if v.Humanoid.Health > 0 then
                                TweenTo(v.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0) * CFrame.Angles(math.rad(-90), 0, 0))
                            end
                        end
                    end
                end)
            end
        end)
    end    
})

-- [ TAB: STATS ]
local TabStats = Window:MakeTab({Name = "Auto Stats", Icon = "rbxassetid://4483345998"})

TabStats:AddDropdown({
    Name = "Escolha onde upar",
    Default = "Melee",
    Options = {"Melee", "Defense", "Sword", "Demon Fruit", "Gun"},
    Callback = function(Value)
        _G.SelectedStat = Value
    end    
})

TabStats:AddToggle({
    Name = "Auto Add Points",
    Default = false,
    Callback = function(Value)
        _G.AutoStats = Value
        task.spawn(function()
            while _G.AutoStats do
                task.wait(0.5)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", _G.SelectedStat, 1)
            end
        end)
    end    
})

-- [ TAB: MISC ]
local TabMisc = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483345998"})

TabMisc:AddButton({
    Name = "Remover Lag (Tela Branca)",
    Callback = function()
        game:GetService("RunService"):Set3dRenderingEnabled(false)
    end    
})

TabMisc:AddButton({
    Name = "Rejoin Server (Relogar)",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
    end    
})

OrionLib:Init()
