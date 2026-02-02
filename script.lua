-- Delta Executor için Ragdoll Script (Eğitim Amaçlı)
-- GUI butonu ile kontrol edilir

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- GUI oluşturma
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RagdollGUI"
ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 100, 0, 40)
Frame.Position = UDim2.new(0, 10, 0, 50) -- Sol üstün biraz altında
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1, 0, 1, 0)
Button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Text = "Aktif Et"
Button.Font = Enum.Font.GothamBold
Button.TextSize = 14
Button.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 1, 5)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Text = "Kapalı"
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.Parent = Frame

-- Değişkenler
local isActive = false
local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local RAGDOLL_TIME = 8 -- 8 saniye
local ACTIVATION_DISTANCE = 50 -- 50 stud mesafe

-- Ragdoll fonksiyonu
local function applyRagdoll(targetPlayer)
    if not targetPlayer or targetPlayer == localPlayer then return end
    
    local targetChar = targetPlayer.Character
    if not targetChar then return end
    
    local targetHumanoid = targetChar:FindFirstChild("Humanoid")
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    
    if not targetHumanoid or not targetHRP then return end
    
    -- Önceki ragdoll'u temizle
    if activeRagdolls[targetPlayer] then
        activeRagdolls[targetPlayer]:Disconnect()
        activeRagdolls[targetPlayer] = nil
    end
    
    -- Ragdoll etkisi (eğitim amaçlı simülasyon)
    -- Not: Gerçek ragdoll için oyunun fizik motorunu manipüle etmek gerekir
    
    -- Simüle ragdoll efekti - karakteri yere düşür
    targetHumanoid.PlatformStand = true
    targetHumanoid.AutoRotate = false
    
    -- Rastgele güç uygula (düşme efekti)
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(
        math.random(-50, 50),
        -math.random(20, 50),
        math.random(-50, 50)
    )
    bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    bodyVelocity.Parent = targetHRP
    
    -- 8 saniye sonra kaldır
    local ragdollEndTime = tick() + RAGDOLL_TIME
    local connection
    
    connection = RunService.Heartbeat:Connect(function()
        if tick() >= ragdollEndTime then
            -- Ragdoll'u sonlandır
            targetHumanoid.PlatformStand = false
            targetHumanoid.AutoRotate = true
            
            if bodyVelocity and bodyVelocity.Parent then
                bodyVelocity:Destroy()
            end
            
            -- Karakteri ayağa kaldır
            targetChar:SetPrimaryPartCFrame(CFrame.new(targetHRP.Position + Vector3.new(0, 3, 0)))
            
            if connection then
                connection:Disconnect()
            end
            
            if activeRagdolls[targetPlayer] then
                activeRagdolls[targetPlayer] = nil
            end
        end
    end)
    
    activeRagdolls[targetPlayer] = connection
    
    -- BodyVelocity'yi 0.5 saniye sonra kaldır
    delay(0.5, function()
        if bodyVelocity and bodyVelocity.Parent then
            bodyVelocity:Destroy()
        end
    end)
end

-- Oyuncu takip fonksiyonu
local function checkNearbyPlayers()
    while isActive do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                local targetChar = player.Character
                if targetChar then
                    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                    if targetHRP and humanoidRootPart then
                        local distance = (targetHRP.Position - humanoidRootPart.Position).Magnitude
                        
                        if distance <= ACTIVATION_DISTANCE then
                            -- Eğer henüz ragdoll değilse, ragdoll uygula
                            if not activeRagdolls[player] then
                                applyRagdoll(player)
                                
                                -- Bildirim (eğitim amaçlı)
                                warn("[Ragdoll] " .. player.Name .. " ragdoll edildi! (" .. math.floor(distance) .. " stud)")
                            end
                        end
                    end
                end
            end
        end
        
        wait(0.5) -- 0.5 saniyede bir kontrol et
    end
end

-- Buton tıklama olayı
local checkThread = nil
Button.MouseButton1Click:Connect(function()
    isActive = not isActive
    
    if isActive then
        Button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        Button.Text = "Kapat"
        StatusLabel.Text = "AÇIK - " .. ACTIVATION_DISTANCE .. " stud"
        StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        
        -- Karakter referansını güncelle
        character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        -- Aktif ragdoll listesini temizle
        activeRagdolls = {}
        
        -- Oyuncu kontrolünü başlat
        checkThread = task.spawn(checkNearbyPlayers)
        
        -- Başlatma mesajı
        print("[Ragdoll Script] Aktif edildi! Yaklaşan oyuncular ragdoll olacak.")
    else
        Button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        Button.Text = "Aktif Et"
        StatusLabel.Text = "KAPALI"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        
        -- Tüm ragdoll'ları temizle
        for player, connection in pairs(activeRagdolls) do
            if connection then
                connection:Disconnect()
            end
            
            -- Oyuncuları ayağa kaldır
            local targetChar = player.Character
            if targetChar then
                local targetHumanoid = targetChar:FindFirstChild("Humanoid")
                if targetHumanoid then
                    targetHumanoid.PlatformStand = false
                    targetHumanoid.AutoRotate = true
                end
            end
        end
        
        activeRagdolls = {}
        
        -- Kontrol thread'ini durdur
        if checkThread then
            task.cancel(checkThread)
            checkThread = nil
        end
        
        print("[Ragdoll Script] Kapatıldı.")
    end
end)

-- Karakter değiştiğinde güncelle
localPlayer.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
end)

-- GUI'yi sürükleme özelliği
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

-- Başlangıç mesajı
print("[Ragdoll Script] Yüklendi! Sol üstteki butona tıklayarak aktif edin.")
print("[EĞİTİM AMAÇLIDIR] Bu script sadece eğitim amaçlıdır.")
