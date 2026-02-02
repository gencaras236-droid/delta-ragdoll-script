-- Delta Executor için No Clip, Fly ve God Mode
-- Tuşlar: 
-- N = No Clip Aç/Kapat
-- F = Fly Aç/Kapat  
-- G = God Mode Aç/Kapat

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Oyuncu ve karakter
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Değişkenler
local noclip = false
local flying = false
local godmode = false
local flySpeed = 50
local flyBoost = 2

-- GUI oluştur
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CheatGUI"
ScreenGui.Parent = game:GetService("CoreGui") or player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 150, 0, 150)
Frame.Position = UDim2.new(0, 10, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BackgroundTransparency = 0.3
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Başlık
local Title = Instance.new("TextLabel")
Title.Text = "🏴‍☠️ CHEAT MENU"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Frame

-- No Clip Durumu
local NoclipLabel = Instance.new("TextLabel")
NoclipLabel.Name = "NoclipLabel"
NoclipLabel.Text = "🚫 No Clip: KAPALI"
NoclipLabel.Size = UDim2.new(1, 0, 0, 25)
NoclipLabel.Position = UDim2.new(0, 0, 0, 35)
NoclipLabel.BackgroundTransparency = 1
NoclipLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
NoclipLabel.Font = Enum.Font.Gotham
NoclipLabel.TextSize = 14
NoclipLabel.Parent = Frame

-- Fly Durumu
local FlyLabel = Instance.new("TextLabel")
FlyLabel.Name = "FlyLabel"
FlyLabel.Text = "✈️ Fly: KAPALI"
FlyLabel.Size = UDim2.new(1, 0, 0, 25)
FlyLabel.Position = UDim2.new(0, 0, 0, 60)
FlyLabel.BackgroundTransparency = 1
FlyLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
FlyLabel.Font = Enum.Font.Gotham
FlyLabel.TextSize = 14
FlyLabel.Parent = Frame

-- God Mode Durumu
local GodLabel = Instance.new("TextLabel")
GodLabel.Name = "GodLabel"
GodLabel.Text = "🛡️ God Mode: KAPALI"
GodLabel.Size = UDim2.new(1, 0, 0, 25)
GodLabel.Position = UDim2.new(0, 0, 0, 85)
GodLabel.BackgroundTransparency = 1
GodLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
GodLabel.Font = Enum.Font.Gotham
GodLabel.TextSize = 14
GodLabel.Parent = Frame

-- Bilgi
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Text = "N: NoClip  F: Fly  G: God"
InfoLabel.Size = UDim2.new(1, 0, 0, 25)
InfoLabel.Position = UDim2.new(0, 0, 0, 120)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextSize = 12
InfoLabel.Parent = Frame

-- NO CLIP SİSTEMİ
local function toggleNoclip()
    noclip = not noclip
    
    if noclip then
        NoclipLabel.Text = "✅ No Clip: AÇIK"
        NoclipLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Karakterin tüm parçalarını NoClip yap
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        NoclipLabel.Text = "🚫 No Clip: KAPALI"
        NoclipLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        -- Collision'ı geri aç
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    print("[NoClip] " .. (noclip and "AÇIK" or "KAPALI"))
end

-- FLY SİSTEMİ
local function toggleFly()
    flying = not flying
    
    if flying then
        FlyLabel.Text = "✅ Fly: AÇIK"
        FlyLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Fly mekaniği
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 10000
        bodyGyro.D = 1000
        bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
        bodyGyro.CFrame = humanoidRootPart.CFrame
        bodyGyro.Parent = humanoidRootPart
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
        bodyVelocity.Parent = humanoidRootPart
        
        humanoid.PlatformStand = true
        
        -- Fly kontrol
        local flyConnection
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flying then
                flyConnection:Disconnect()
                return
            end
            
            local velocity = Vector3.new(0, 0, 0)
            local camera = Workspace.CurrentCamera
            
            -- W A S D kontrolü
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + (camera.CFrame.LookVector * flySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - (camera.CFrame.LookVector * flySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + (camera.CFrame.RightVector * flySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - (camera.CFrame.RightVector * flySpeed)
            end
            
            -- Yükseklik kontrolü (Space ve Shift)
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, flySpeed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
                velocity = velocity - Vector3.new(0, flySpeed, 0)
            end
            
            -- Hız boost (E tuşu)
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                velocity = velocity * flyBoost
            end
            
            bodyVelocity.Velocity = velocity
            bodyGyro.CFrame = camera.CFrame
        end)
        
        -- Fly kapandığında temizlik
        spawn(function()
            while flying do
                wait()
            end
            bodyGyro:Destroy()
            bodyVelocity:Destroy()
            humanoid.PlatformStand = false
        end)
        
    else
        FlyLabel.Text = "✈️ Fly: KAPALI"
        FlyLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    
    print("[Fly] " .. (flying and "AÇIK" or "KAPALI"))
end

-- GOD MODE SİSTEMİ
local function toggleGodmode()
    godmode = not godmode
    
    if godmode then
        GodLabel.Text = "✅ God Mode: AÇIK"
        GodLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Ölümsüzlük
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        
        -- Hasar engelleme
        local oldTakeDamage = humanoid.TakeDamage
        humanoid.TakeDamage = function() end
        
        -- Ölüm engelleme
        humanoid.BreakJointsOnDeath = false
        humanoid.RequiresNeck = false
        
        -- Geri alma fonksiyonu
        humanoid.GodmodeRestore = oldTakeDamage
        
    else
        GodLabel.Text = "🛡️ God Mode: KAPALI"
        GodLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        -- Normal moda dön
        if humanoid.GodmodeRestore then
            humanoid.TakeDamage = humanoid.GodmodeRestore
            humanoid.GodmodeRestore = nil
        end
        
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    end
    
    print("[GodMode] " .. (godmode and "AÇIK" or "KAPALI"))
end

-- TUŞ KONTROLLERİ
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- N tuşu = No Clip
    if input.KeyCode == Enum.KeyCode.N then
        toggleNoclip()
    
    -- F tuşu = Fly
    elseif input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    
    -- G tuşu = God Mode
    elseif input.KeyCode == Enum.KeyCode.G then
        toggleGodmode()
    
    -- H tuşu = Hız artır
    elseif input.KeyCode == Enum.KeyCode.H then
        flySpeed = flySpeed + 10
        print("[Fly Speed] " .. flySpeed)
    
    -- J tuşu = Hız azalt
    elseif input.KeyCode == Enum.KeyCode.J then
        flySpeed = math.max(10, flySpeed - 10)
        print("[Fly Speed] " .. flySpeed)
    end
end)

-- NO CLIP LOOP (sürekli collision kontrol)
spawn(function()
    while true do
        if noclip and character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        wait(0.1)
    end
end)

-- KARAKTER DEĞİŞİNCE GÜNCELLE
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    
    -- God mode aktifse yeniden uygula
    if godmode then
        task.wait(1)
        toggleGodmode()
        toggleGodmode()
    end
end)

-- GUI SÜRÜKLEME
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- BAŞLANGIÇ MESAJI
print("====================================")
print("🚀 NO CLIP, FLY & GOD MODE SCRIPT")
print("====================================")
print("N tuşu = No Clip Aç/Kapat")
print("F tuşu = Fly Aç/Kapat")
print("G tuşu = God Mode Aç/Kapat")
print("H tuşu = Fly Hızını Artır")
print("J tuşu = Fly Hızını Azalt")
print("WASD = Fly Hareketi")
print("Space = Yukarı Çık")
print("Shift = Aşağı İn")
print("E = Hız Boost")
print("====================================")
