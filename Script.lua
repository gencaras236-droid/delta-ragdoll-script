-- Delta Premium Ultimate Hile Paketi
-- Yapımcı: Gencaras236 (Geliştirilmiş Sürüm)
-- Tüm hakları saklıdır - Sadece eğitim amaçlıdır

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

-- OYUNCU DEĞİŞKENLERİ
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local camera = Workspace.CurrentCamera

-- AYARLAR
local settings = {
    FlySpeed = 50,
    FlyBoost = 2,
    JumpPower = 100,
    InfiniteJump = false,
    Noclip = false,
    GodMode = false,
    FlyEnabled = false,
    SpeedHack = false,
    WalkSpeed = 16,
    RagdollRange = 34,
    RagdollStrength = 100,
    AutoRagdoll = true,
    ESPEnabled = false,
    XRay = false,
    NukeMode = false,
    AntiAFK = true,
    AutoFarm = false
}

-- MENÜ ARAYÜZÜ
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumCheatMenu"
ScreenGui.Parent = game:GetService("CoreGui") or player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- BAŞLIK
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "🔥 PREMIUM HİLE PAKETİ v2.0 🔥"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = TitleBar

-- SCROLL FRAME
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 900)
ScrollFrame.Parent = MainFrame

-- BUTON STİLİ
local function createButton(text, yPosition, toggleFunction, defaultValue)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, -20, 0, 40)
    buttonFrame.Position = UDim2.new(0, 10, 0, yPosition)
    buttonFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Parent = ScrollFrame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = buttonFrame
    
    local buttonText = Instance.new("TextLabel")
    buttonText.Text = text
    buttonText.Size = UDim2.new(0.8, 0, 1, 0)
    buttonText.Position = UDim2.new(0, 10, 0, 0)
    buttonText.BackgroundTransparency = 1
    buttonText.TextColor3 = Color3.fromRGB(220, 220, 220)
    buttonText.Font = Enum.Font.Gotham
    buttonText.TextSize = 14
    buttonText.TextXAlignment = Enum.TextXAlignment.Left
    buttonText.Parent = buttonFrame
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Text = defaultValue and "✅ AÇIK" or "❌ KAPALI"
    statusLabel.Size = UDim2.new(0.2, 0, 1, 0)
    statusLabel.Position = UDim2.new(0.8, 0, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = defaultValue and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 14
    statusLabel.Parent = buttonFrame
    
    button.MouseButton1Click:Connect(function()
        local newValue = not defaultValue
        defaultValue = newValue
        statusLabel.Text = newValue and "✅ AÇIK" or "❌ KAPALI"
        statusLabel.TextColor3 = newValue and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
        
        if toggleFunction then
            toggleFunction(newValue)
        end
    end)
    
    return buttonFrame, defaultValue
end

-- MENÜ ÖĞELERİ
local yPosition = 10

-- 1. NO CLIP
local noclipFrame, noclipValue = createButton("🚫 NO CLIP (Duvar Geçme)", yPosition, function(value)
    settings.Noclip = value
    if value then
        print("[NoClip] Aktif")
    else
        print("[NoClip] Devre Dışı")
    end
end, false)
yPosition = yPosition + 45

-- 2. FLY
local flyFrame, flyValue = createButton("✈️ FLY (Uçma)", yPosition, function(value)
    settings.FlyEnabled = value
    toggleFly(value)
end, false)
yPosition = yPosition + 45

-- 3. GOD MODE
local godFrame, godValue = createButton("🛡️ GOD MODE (Ölmeme)", yPosition, function(value)
    settings.GodMode = value
    toggleGodMode(value)
end, false)
yPosition = yPosition + 45

-- 4. SÜRESİZ ZIPLAMA
local jumpFrame, jumpValue = createButton("🔺 SÜRESİZ ZIPLAMA", yPosition, function(value)
    settings.InfiniteJump = value
    if value then
        print("[InfiniteJump] Aktif")
    else
        print("[InfiniteJump] Devre Dışı")
    end
end, false)
yPosition = yPosition + 45

-- 5. HIZ HACK
local speedFrame, speedValue = createButton("⚡ HIZ HACK", yPosition, function(value)
    settings.SpeedHack = value
    toggleSpeedHack(value)
end, false)
yPosition = yPosition + 45

-- 6. OTO RAGDOLL (34 STUD)
local ragdollFrame, ragdollValue = createButton("🤖 OTO RAGDOLL (34 stud)", yPosition, function(value)
    settings.AutoRagdoll = value
    if value then
        print("[AutoRagdoll] Aktif - 34 stud mesafe")
    else
        print("[AutoRagdoll] Devre Dışı")
    end
end, true)
yPosition = yPosition + 45

-- 7. ESP (GÖRÜNÜRLÜK)
local espFrame, espValue = createButton("👁️ ESP (Oyuncu Gör)", yPosition, function(value)
    settings.ESPEnabled = value
    toggleESP(value)
end, false)
yPosition = yPosition + 45

-- 8. X-RAY
local xrayFrame, xrayValue = createButton("📡 X-RAY (Duvar Gör)", yPosition, function(value)
    settings.XRay = value
    toggleXRay(value)
end, false)
yPosition = yPosition + 45

-- 9. NUKE MOD
local nukeFrame, nukeValue = createButton("💣 NUKE MOD (Hepsini Yok Et)", yPosition, function(value)
    settings.NukeMode = value
    toggleNukeMode(value)
end, false)
yPosition = yPosition + 45

-- 10. ANTI-AFK
local afkFrame, afkValue = createButton("🔄 ANTI-AFK", yPosition, function(value)
    settings.AntiAFK = value
    toggleAntiAFK(value)
end, true)
yPosition = yPosition + 45

-- 11. OTO FARM
local farmFrame, farmValue = createButton("💰 OTO FARM", yPosition, function(value)
    settings.AutoFarm = value
    toggleAutoFarm(value)
end, false)
yPosition = yPosition + 45

-- HIZ AYARLARI
yPosition = yPosition + 20
local speedLabel = Instance.new("TextLabel")
speedLabel.Text = "⚡ HIZ AYARLARI"
speedLabel.Size = UDim2.new(1, -20, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, yPosition)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 16
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = ScrollFrame
yPosition = yPosition + 35

-- FLY HIZI
local flySpeedFrame = Instance.new("Frame")
flySpeedFrame.Size = UDim2.new(1, -20, 0, 40)
flySpeedFrame.Position = UDim2.new(0, 10, 0, yPosition)
flySpeedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
flySpeedFrame.BorderSizePixel = 0
flySpeedFrame.Parent = ScrollFrame

local flySpeedText = Instance.new("TextLabel")
flySpeedText.Text = "Uçuş Hızı: " .. settings.FlySpeed
flySpeedText.Size = UDim2.new(0.7, 0, 1, 0)
flySpeedText.Position = UDim2.new(0, 10, 0, 0)
flySpeedText.BackgroundTransparency = 1
flySpeedText.TextColor3 = Color3.fromRGB(220, 220, 220)
flySpeedText.Font = Enum.Font.Gotham
flySpeedText.TextSize = 14
flySpeedText.TextXAlignment = Enum.TextXAlignment.Left
flySpeedText.Parent = flySpeedFrame

local flySpeedUp = Instance.new("TextButton")
flySpeedUp.Text = "+"
flySpeedUp.Size = UDim2.new(0.1, 0, 1, 0)
flySpeedUp.Position = UDim2.new(0.7, 0, 0, 0)
flySpeedUp.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
flySpeedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
flySpeedUp.Font = Enum.Font.GothamBold
flySpeedUp.TextSize = 18
flySpeedUp.Parent = flySpeedFrame

local flySpeedDown = Instance.new("TextButton")
flySpeedDown.Text = "-"
flySpeedDown.Size = UDim2.new(0.1, 0, 1, 0)
flySpeedDown.Position = UDim2.new(0.85, 0, 0, 0)
flySpeedDown.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
flySpeedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
flySpeedDown.Font = Enum.Font.GothamBold
flySpeedDown.TextSize = 18
flySpeedDown.Parent = flySpeedFrame

flySpeedUp.MouseButton1Click:Connect(function()
    settings.FlySpeed = settings.FlySpeed + 10
    flySpeedText.Text = "Uçuş Hızı: " .. settings.FlySpeed
    print("[FlySpeed] " .. settings.FlySpeed)
end)

flySpeedDown.MouseButton1Click:Connect(function()
    settings.FlySpeed = math.max(10, settings.FlySpeed - 10)
    flySpeedText.Text = "Uçuş Hızı: " .. settings.FlySpeed
    print("[FlySpeed] " .. settings.FlySpeed)
end)

yPosition = yPosition + 45

-- YARDIM METNİ
local helpLabel = Instance.new("TextLabel")
helpLabel.Text = "📌 KONTROLLER: N=NoClip, F=Fly, G=God, J=Zıpla, Space=InfJump, V=Nuke"
helpLabel.Size = UDim2.new(1, -20, 0, 50)
helpLabel.Position = UDim2.new(0, 10, 0, yPosition)
helpLabel.BackgroundTransparency = 1
helpLabel.TextColor3 = Color3.fromRGB(200, 200, 100)
helpLabel.Font = Enum.Font.Gotham
helpLabel.TextSize = 12
helpLabel.TextWrapped = true
helpLabel.Parent = ScrollFrame

-- FONKSİYONLAR
-- 1. FLY SİSTEMİ
local flyBodyGyro, flyBodyVelocity, flyConnection
function toggleFly(enabled)
    if enabled then
        -- Fly başlat
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.P = 10000
        flyBodyGyro.D = 1000
        flyBodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
        flyBodyGyro.CFrame = humanoidRootPart.CFrame
        flyBodyGyro.Parent = humanoidRootPart
        
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
        flyBodyVelocity.Parent = humanoidRootPart
        
        humanoid.PlatformStand = true
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not settings.FlyEnabled then return end
            
            local velocity = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + (camera.CFrame.LookVector * settings.FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - (camera.CFrame.LookVector * settings.FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + (camera.CFrame.RightVector * settings.FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - (camera.CFrame.RightVector * settings.FlySpeed)
            end
            
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, settings.FlySpeed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
                velocity = velocity - Vector3.new(0, settings.FlySpeed, 0)
            end
            
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                velocity = velocity * settings.FlyBoost
            end
            
            flyBodyVelocity.Velocity = velocity
            flyBodyGyro.CFrame = camera.CFrame
        end)
        
        print("[FLY] Aktif edildi")
    else
        -- Fly durdur
        if flyConnection then
            flyConnection:Disconnect()
        end
        if flyBodyGyro then
            flyBodyGyro:Destroy()
        end
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
        end
        humanoid.PlatformStand = false
        print("[FLY] Devre dışı")
    end
end

-- 2. GOD MODE
function toggleGodMode(enabled)
    if enabled then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        
        local oldTakeDamage = humanoid.TakeDamage
        humanoid.TakeDamage = function() end
        
        humanoid.BreakJointsOnDeath = false
        humanoid.RequiresNeck = false
        
        humanoid.GodmodeRestore = oldTakeDamage
        print("[GOD MODE] Aktif - Ölümsüzsün!")
    else
        if humanoid.GodmodeRestore then
            humanoid.TakeDamage = humanoid.GodmodeRestore
            humanoid.GodmodeRestore = nil
        end
        
        humanoid.MaxHealth = 100
        humanoid.Health = 100
        print("[GOD MODE] Devre dışı")
    end
end

-- 3. HIZ HACK
function toggleSpeedHack(enabled)
    if enabled then
        humanoid.WalkSpeed = 50
        print("[SPEED HACK] Aktif - Hız: 50")
    else
        humanoid.WalkSpeed = 16
        print("[SPEED HACK] Devre dışı")
    end
end

-- 4. ESP SİSTEMİ
local espBoxes = {}
function toggleESP(enabled)
    if enabled then
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                local char = otherPlayer.Character
                if char then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "ESP_" .. otherPlayer.Name
                    box.Adornee = char:FindFirstChild("HumanoidRootPart")
                    box.Size = Vector3.new(3, 5, 1)
                    box.Color3 = Color3.fromRGB(255, 50, 50)
                    box.Transparency = 0.3
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Parent = char
                    
                    espBoxes[otherPlayer] = box
                end
            end
        end
        print("[ESP] Aktif - Tüm oyuncular görünür")
    else
        for _, box in pairs(espBoxes) do
            box:Destroy()
        end
        espBoxes = {}
        print("[ESP] Devre dışı")
    end
end

-- 5. X-RAY
function toggleXRay(enabled)
    if enabled then
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency < 1 then
                part.LocalTransparencyModifier = 0.5
            end
        end
        print("[X-RAY] Aktif - Duvarlar görünür")
    else
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
        print("[X-RAY] Devre dışı")
    end
end

-- 6. NUKE MOD
function toggleNukeMode(enabled)
    if enabled then
        print("[NUKE] Hazır! V tuşuna basarak etkinleştir")
    else
        print("[NUKE] Devre dışı")
    end
end

-- 7. ANTI-AFK
local antiAFKConnection
function toggleAntiAFK(enabled)
    if enabled then
        antiAFKConnection = RunService.Heartbeat:Connect(function()
            localVirtualUser = game:GetService("VirtualUser")
            localVirtualUser:CaptureController()
            localVirtualUser:ClickButton2(Vector2.new())
        end)
        print("[ANTI-AFK] Aktif - AFK olmayacaksın")
    else
        if antiAFKConnection then
            antiAFKConnection:Disconnect()
        end
        print("[ANTI-AFK] Devre dışı")
    end
end

-- 8. OTO FARM
function toggleAutoFarm(enabled)
    if enabled then
        print("[AUTO FARM] Aktif - Yakındaki item'lar toplanıyor")
        spawn(function()
            while settings.AutoFarm do
                -- Bu kısmı oyununa göre özelleştirmen gerekebilir
                wait(1)
            end
        end)
    else
        print("[AUTO FARM] Devre dışı")
    end
end

-- 9. SÜRESİZ ZIPLAMA
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Space and settings.InfiniteJump then
        humanoidRootPart.Velocity = Vector3.new(
            humanoidRootPart.Velocity.X,
            settings.JumpPower,
            humanoidRootPart.Velocity.Z
        )
    end
    
    -- NO CLIP Tuşu (N)
    if input.KeyCode == Enum.KeyCode.N then
        settings.Noclip = not settings.Noclip
        noclipValue = settings.Noclip
        local status = settings.Noclip and "✅ AÇIK" or "❌ KAPALI"
        for _, child in ipairs(noclipFrame:GetChildren()) do
            if child:IsA("TextLabel") and child.Position == UDim2.new(0.8, 0, 0, 0) then
                child.Text = status
                child.TextColor3 = settings.Noclip and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
            end
        end
        print("[NoClip] " .. (settings.Noclip and "AÇIK" or "KAPALI"))
    end
    
    -- FLY Tuşu (F)
    if input.KeyCode == Enum.KeyCode.F then
        settings.FlyEnabled = not settings.FlyEnabled
        flyValue = settings.FlyEnabled
        toggleFly(settings.FlyEnabled)
        local status = settings.FlyEnabled and "✅ AÇIK" or "❌ KAPALI"
        for _, child in ipairs(flyFrame:GetChildren()) do
            if child:IsA("TextLabel") and child.Position == UDim2.new(0.8, 0, 0, 0) then
                child.Text = status
                child.TextColor3 = settings.FlyEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
            end
        end
    end
    
    -- GOD MODE Tuşu (G)
    if input.KeyCode == Enum.KeyCode.G then
        settings.GodMode = not settings.GodMode
        godValue = settings.GodMode
        toggleGodMode(settings.GodMode)
        local status = settings.GodMode and "✅ AÇIK" or "❌ KAPALI"
        for _, child in ipairs(godFrame:GetChildren()) do
            if child:IsA("TextLabel") and child.Position == UDim2.new(0.8, 0, 0, 0) then
                child.Text = status
                child.TextColor3 = settings.GodMode and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
            end
        end
    end
    
    -- NUKE Tuşu (V) - 34 stud içindeki her şeyi ragdoll
    if input.KeyCode == Enum.KeyCode.V and settings.NukeMode then
        print("[NUKE] Etkinleştirildi! 34 stud içindeki herkes ragdoll oluyor...")
        
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                local char = otherPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp and (hrp.Position - humanoidRootPart.Position).Magnitude <= 34 then
                        -- RAGDOLL ET
                        local humanoid = char:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid.PlatformStand = true
                            
                            -- Rastgele güç uygula
                            local bodyVelocity = Instance.new("BodyVelocity")
                            bodyVelocity.Velocity = Vector3.new(
                                math.random(-100, 100),
                                math.random(50, 100),
                                math.random(-100, 100)
                            )
                            bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                            bodyVelocity.Parent = hrp
                            game.Debris:AddItem(bodyVelocity, 1)
                        end
                    end
                end
            end
        end
    end
end)

-- 10. OTOMATİK RAGDOLL (34 STUD)
spawn(function()
    while true do
        if settings.AutoRagdoll then
            for _, otherPlayer in ipairs(Players:GetPlayers()) do
                if otherPlayer ~= player then
                    local char = otherPlayer.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp and humanoidRootPart then
                            local distance = (hrp.Position - humanoidRootPart.Position).Magnitude
                            
                            -- 34 stud içindeki herkesi ragdoll yap
                            if distance <= 34 then
                                local humanoid = char:FindFirstChild("Humanoid")
                                if humanoid and not humanoid.PlatformStand then
                                    humanoid.PlatformStand = true
                                    
                                    -- Karakteri sana doğru çek
                                    local direction = (humanoidRootPart.Position - hrp.Position).Unit
                                    local bodyVelocity = Instance.new("BodyVelocity")
                                    bodyVelocity.Velocity = direction * settings.RagdollStrength
                                    bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                                    bodyVelocity.Parent = hrp
                                    game.Debris:AddItem(bodyVelocity, 0.5)
                                    
                                    -- 3 saniye sonra normale dön
                                    spawn(function()
                                        wait(3)
                                        if char and char.Parent then
                                            humanoid.PlatformStand = false
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
        wait(0.5)
    end
end)

-- 11. NO CLIP LOOP
spawn(function()
    while true do
        if settings.Noclip and character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        wait(0.1)
    end
end)

-- 12. KARAKTER DEĞİŞİKLİĞİ
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    
    -- Ayar'ları yeni karaktere uygula
    task.wait(1)
    
    if settings.GodMode then
        toggleGodMode(true)
    end
    
    if settings.SpeedHack then
        toggleSpeedHack(true)
    end
    
    if settings.FlyEnabled then
        toggleFly(true)
    end
end)

-- BAŞLANGIÇ MESAJI
print("==============================================")
print("🔥 PREMIUM HİLE PAKETİ v2.0 YÜKLENDİ!")
print("==============================================")
print("📌 MENÜ: Ekranın ortasında görünecek")
print("📌 TUŞLAR: N=NoClip, F=Fly, G=God, V=Nuke")
print("📌 SÜRESİZ ZIPLAMA: Boşluk tuşu (aktifse)")
print("📌 OTO RAGDOLL: 34 stud içindekiler otomatik")
print("==============================================")
