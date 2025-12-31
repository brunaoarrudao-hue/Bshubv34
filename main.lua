--[[
    BUNDA SECA HUB v35 - NATIVE EDITION
    Status: SEM LINKS EXTERNOS (Anti-Erro)
    Interface: Nativa do Roblox
]]

-- 1. NOTIFICAÇÃO DE ARRANQUE (Para saber se o executor está vivo)
game.StarterGui:SetCore("SendNotification", {
    Title = "Bunda Seca Hub";
    Text = "A carregar... Aguarde!";
    Duration = 5;
})

-- 2. VARIÁVEIS E SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VIM = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer

-- CONTROLO
_G.AutoClick = false
_G.AutoFarm = false

-- 3. INTERFACE MANUAL (GUI)
-- Removemos GUIs antigas para não duplicar
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "BSH_Native" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BSH_Native"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true -- Pode arrastar a janela

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "BUNDA SECA v35 (NATIVE)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

-- BOTÃO 1: AUTO CLICK PODEROSO
local BtnClick = Instance.new("TextButton")
BtnClick.Parent = MainFrame
BtnClick.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BtnClick.Position = UDim2.new(0.1, 0, 0.2, 0)
BtnClick.Size = UDim2.new(0.8, 0, 0.2, 0)
BtnClick.Font = Enum.Font.SourceSans
BtnClick.Text = "AUTO CLICK: OFF"
BtnClick.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnClick.TextSize = 20

-- BOTÃO 2: AUTO FARM (NEAREST)
local BtnFarm = Instance.new("TextButton")
BtnFarm.Parent = MainFrame
BtnFarm.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BtnFarm.Position = UDim2.new(0.1, 0, 0.5, 0)
BtnFarm.Size = UDim2.new(0.8, 0, 0.2, 0)
BtnFarm.Font = Enum.Font.SourceSans
BtnFarm.Text = "AUTO FARM (PERTO): OFF"
BtnFarm.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnFarm.TextSize = 18

-- BOTÃO 3: FECHAR
local BtnClose = Instance.new("TextButton")
BtnClose.Parent = MainFrame
BtnClose.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
BtnClose.Position = UDim2.new(0.3, 0, 0.8, 0)
BtnClose.Size = UDim2.new(0.4, 0, 0.15, 0)
BtnClose.Font = Enum.Font.SourceSansBold
BtnClose.Text = "FECHAR"
BtnClose.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnClose.TextSize = 14

-- 4. FUNÇÕES LÓGICAS (O QUE O SCRIPT FAZ)

-- Lógica do Auto Click
BtnClick.MouseButton1Click:Connect(function()
    _G.AutoClick = not _G.AutoClick
    if _G.AutoClick then
        BtnClick.Text = "AUTO CLICK: ON"
        BtnClick.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        BtnClick.Text = "AUTO CLICK: OFF"
        BtnClick.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

-- Motor do Auto Click (Roda em background)
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        if _G.AutoClick then
            pcall(function()
                local Tool = LP.Character:FindFirstChildOfClass("Tool")
                if Tool then
                    Tool:Activate()
                    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            end)
        end
    end
end)

-- Lógica do Auto Farm
BtnFarm.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    if _G.AutoFarm then
        BtnFarm.Text = "AUTO FARM: ON"
        BtnFarm.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        _G.AutoClick = true -- Liga o click junto
    else
        BtnFarm.Text = "AUTO FARM (PERTO): OFF"
        BtnFarm.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        -- Para o personagem
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end
end)

