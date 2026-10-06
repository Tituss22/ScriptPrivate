-- ====================================================================
-- 🌲 HUTAN VOICE CHAT - MINI PREMIUM HUB (V24 - UNDERGROUND INVISIBLE)
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local guiName = "HutanVC_MiniHub"

-- Variabel Global Pendukung
local networkPaused
local camera = Workspace.CurrentCamera

-- ==========================================
-- 🔄 SISTEM AUTO REJOIN CHAT (!rejoin) & QUEUE ON TELEPORT
-- ==========================================
local queue_on_teleport = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)

local AutoExecuteURL = "" 

LocalPlayer.Chatted:Connect(function(msg)
    if string.lower(msg) == "!rejoin" then
        if queue_on_teleport and AutoExecuteURL ~= "https://raw.githubusercontent.com/Tituss22/ScriptPrivate/refs/heads/main/HutanVc.luau" then
            queue_on_teleport('loadstring(game:HttpGet("' .. AutoExecuteURL .. '"))()')
        end
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
    end
end)

-- 🧹 Bersihkan GUI Lama
pcall(function()
    if CoreGui:FindFirstChild(guiName) then CoreGui[guiName]:Destroy() end
    if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(guiName) then LocalPlayer.PlayerGui[guiName]:Destroy() end
end)

-- ==========================================
-- 💾 SISTEM CACHE GUI (MENGINGAT POSISI & STATUS VISIBILITY)
-- ==========================================
local CacheFileName = "HutanVC_Cache.json"
local guiCache = {
    Visible = true,
    PosX = 0.5,
    OffsetX = -120,
    PosY = 0.2,
    OffsetY = 0
}

pcall(function()
    if isfile and isfile(CacheFileName) then
        local data = readfile(CacheFileName)
        local parsed = HttpService:JSONDecode(data)
        if parsed then
            guiCache.Visible = parsed.Visible
            guiCache.PosX = parsed.PosX
            guiCache.OffsetX = parsed.OffsetX
            guiCache.PosY = parsed.PosY
            guiCache.OffsetY = parsed.OffsetY
        end
    end
end)

-- ==========================================
-- 🎨 SETUP TAMPILAN UTAMA (DARK GLASS)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

ScreenGui.Enabled = guiCache.Visible

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 420) 
MainFrame.Position = UDim2.new(guiCache.PosX, guiCache.OffsetX, guiCache.PosY, guiCache.OffsetY)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 12)
MainFrame.BackgroundTransparency = 0.15 
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local function SaveCache()
    pcall(function()
        if writefile then
            local data = {
                Visible = ScreenGui.Enabled,
                PosX = MainFrame.Position.X.Scale,
                OffsetX = MainFrame.Position.X.Offset,
                PosY = MainFrame.Position.Y.Scale,
                OffsetY = MainFrame.Position.Y.Offset
            }
            writefile(CacheFileName, HttpService:JSONEncode(data))
        end
    end)
end

task.spawn(function()
    while task.wait(5) do
        SaveCache()
    end
end)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 255, 128)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "🌲 HUTAN VC"
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16

local F2Hint = Instance.new("TextLabel", MainFrame)
F2Hint.Size = UDim2.new(1, 0, 0, 15)
F2Hint.Position = UDim2.new(0, 0, 0, 25)
F2Hint.BackgroundTransparency = 1
F2Hint.Text = "[ Tekan F2 untuk Hide/Show ]"
F2Hint.TextColor3 = Color3.fromRGB(150, 150, 150)
F2Hint.Font = Enum.Font.GothamSemibold
F2Hint.TextSize = 10

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", Container)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8) 

-- ==========================================
-- 🖼️ FRAME: DECAL CHANGER MENU
-- ==========================================
local DecalFrame = Instance.new("Frame", MainFrame) 
DecalFrame.Size = UDim2.new(0, 260, 1, 0) 
DecalFrame.Position = UDim2.new(1, 10, 0, 0) 
DecalFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 12)
DecalFrame.BackgroundTransparency = 0.15 
DecalFrame.BorderSizePixel = 0
DecalFrame.Visible = false
Instance.new("UICorner", DecalFrame).CornerRadius = UDim.new(0, 10)

local DecalStroke = Instance.new("UIStroke", DecalFrame)
DecalStroke.Color = Color3.fromRGB(0, 255, 128)
DecalStroke.Thickness = 1.5
DecalStroke.Transparency = 0.2

local DecalTitle = Instance.new("TextLabel", DecalFrame)
DecalTitle.Size = UDim2.new(1, 0, 0, 40)
DecalTitle.BackgroundTransparency = 1
DecalTitle.Text = "🖼️ DECAL LIST"
DecalTitle.TextColor3 = Color3.fromRGB(0, 255, 128)
DecalTitle.Font = Enum.Font.GothamBlack
DecalTitle.TextSize = 15

local ScrollFrame = Instance.new("ScrollingFrame", DecalFrame)
ScrollFrame.Size = UDim2.new(1, -20, 1, -50)
ScrollFrame.Position = UDim2.new(0, 10, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 30 * 55) 
local DecalListLayout = Instance.new("UIListLayout", ScrollFrame)
DecalListLayout.Padding = UDim.new(0, 5)

-- ==========================================
-- 👤 FRAME: TELEPORT PLAYER MENU (+ SEARCH)
-- ==========================================
local TpPlayerFrame = Instance.new("Frame", MainFrame) 
TpPlayerFrame.Size = UDim2.new(0, 260, 1, 0) 
TpPlayerFrame.Position = UDim2.new(1, 10, 0, 0) 
TpPlayerFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 12)
TpPlayerFrame.BackgroundTransparency = 0.15 
TpPlayerFrame.BorderSizePixel = 0
TpPlayerFrame.Visible = false
Instance.new("UICorner", TpPlayerFrame).CornerRadius = UDim.new(0, 10)

local TpPlayerStroke = Instance.new("UIStroke", TpPlayerFrame)
TpPlayerStroke.Color = Color3.fromRGB(0, 255, 128)
TpPlayerStroke.Thickness = 1.5
TpPlayerStroke.Transparency = 0.2

local TpPlayerTitle = Instance.new("TextLabel", TpPlayerFrame)
TpPlayerTitle.Size = UDim2.new(1, 0, 0, 35)
TpPlayerTitle.BackgroundTransparency = 1
TpPlayerTitle.Text = "👤 TELEPORT PLAYER"
TpPlayerTitle.TextColor3 = Color3.fromRGB(0, 255, 128)
TpPlayerTitle.Font = Enum.Font.GothamBlack
TpPlayerTitle.TextSize = 15

local TpSearchBox = Instance.new("TextBox", TpPlayerFrame)
TpSearchBox.Size = UDim2.new(1, -20, 0, 26)
TpSearchBox.Position = UDim2.new(0, 10, 0, 35)
TpSearchBox.BackgroundColor3 = Color3.fromRGB(20, 25, 20)
TpSearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TpSearchBox.PlaceholderText = "🔍 Cari Player..."
TpSearchBox.Font = Enum.Font.GothamSemibold
TpSearchBox.TextSize = 12
TpSearchBox.ClearTextOnFocus = false
Instance.new("UICorner", TpSearchBox).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", TpSearchBox).Color = Color3.fromRGB(0, 255, 128)

local TpPlayerScroll = Instance.new("ScrollingFrame", TpPlayerFrame)
TpPlayerScroll.Size = UDim2.new(1, -20, 1, -75)
TpPlayerScroll.Position = UDim2.new(0, 10, 0, 65)
TpPlayerScroll.BackgroundTransparency = 1
TpPlayerScroll.ScrollBarThickness = 4
TpPlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 0) 
local TpPlayerListLayout = Instance.new("UIListLayout", TpPlayerScroll)
TpPlayerListLayout.Padding = UDim.new(0, 5)

TpSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local search = string.lower(TpSearchBox.Text)
    for _, item in ipairs(TpPlayerScroll:GetChildren()) do
        if item:IsA("Frame") and item:FindFirstChild("NameLabel") then
            local pName = string.lower(item.NameLabel.Text)
            item.Visible = string.find(pName, search) ~= nil
        end
    end
end)

-- ==========================================
-- 👁️ FRAME: VIEW PLAYER MENU (+ SEARCH)
-- ==========================================
local ViewPlayerFrame = Instance.new("Frame", MainFrame) 
ViewPlayerFrame.Size = UDim2.new(0, 260, 1, 0) 
ViewPlayerFrame.Position = UDim2.new(1, 10, 0, 0) 
ViewPlayerFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 12)
ViewPlayerFrame.BackgroundTransparency = 0.15 
ViewPlayerFrame.BorderSizePixel = 0
ViewPlayerFrame.Visible = false
Instance.new("UICorner", ViewPlayerFrame).CornerRadius = UDim.new(0, 10)

local ViewPlayerStroke = Instance.new("UIStroke", ViewPlayerFrame)
ViewPlayerStroke.Color = Color3.fromRGB(0, 255, 128)
ViewPlayerStroke.Thickness = 1.5
ViewPlayerStroke.Transparency = 0.2

local ViewPlayerTitle = Instance.new("TextLabel", ViewPlayerFrame)
ViewPlayerTitle.Size = UDim2.new(1, 0, 0, 35)
ViewPlayerTitle.BackgroundTransparency = 1
ViewPlayerTitle.Text = "👁️ VIEW PLAYER (SPECTATE)"
ViewPlayerTitle.TextColor3 = Color3.fromRGB(0, 255, 128)
ViewPlayerTitle.Font = Enum.Font.GothamBlack
ViewPlayerTitle.TextSize = 14

local ViewSearchBox = Instance.new("TextBox", ViewPlayerFrame)
ViewSearchBox.Size = UDim2.new(1, -20, 0, 26)
ViewSearchBox.Position = UDim2.new(0, 10, 0, 35)
ViewSearchBox.BackgroundColor3 = Color3.fromRGB(20, 25, 20)
ViewSearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ViewSearchBox.PlaceholderText = "🔍 Cari Player..."
ViewSearchBox.Font = Enum.Font.GothamSemibold
ViewSearchBox.TextSize = 12
ViewSearchBox.ClearTextOnFocus = false
Instance.new("UICorner", ViewSearchBox).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", ViewSearchBox).Color = Color3.fromRGB(0, 255, 128)

local ViewPlayerScroll = Instance.new("ScrollingFrame", ViewPlayerFrame)
ViewPlayerScroll.Size = UDim2.new(1, -20, 1, -75)
ViewPlayerScroll.Position = UDim2.new(0, 10, 0, 65)
ViewPlayerScroll.BackgroundTransparency = 1
ViewPlayerScroll.ScrollBarThickness = 4
ViewPlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 0) 
local ViewPlayerListLayout = Instance.new("UIListLayout", ViewPlayerScroll)
ViewPlayerListLayout.Padding = UDim.new(0, 5)

ViewSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local search = string.lower(ViewSearchBox.Text)
    for _, item in ipairs(ViewPlayerScroll:GetChildren()) do
        if item:IsA("Frame") and item:FindFirstChild("NameLabel") then
            local pName = string.lower(item.NameLabel.Text)
            item.Visible = string.find(pName, search) ~= nil
        end
    end
end)

-- ==========================================
-- 🗺️ FRAME: TELEPORT TEMPAT (MAP SCAN)
-- ==========================================
local TpMapFrame = Instance.new("Frame", MainFrame) 
TpMapFrame.Size = UDim2.new(0, 260, 1, 0) 
TpMapFrame.Position = UDim2.new(1, 10, 0, 0) 
TpMapFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 12)
TpMapFrame.BackgroundTransparency = 0.15 
TpMapFrame.BorderSizePixel = 0
TpMapFrame.Visible = false
Instance.new("UICorner", TpMapFrame).CornerRadius = UDim.new(0, 10)

local TpMapStroke = Instance.new("UIStroke", TpMapFrame)
TpMapStroke.Color = Color3.fromRGB(0, 255, 128)
TpMapStroke.Thickness = 1.5
TpMapStroke.Transparency = 0.2

local TpMapTitle = Instance.new("TextLabel", TpMapFrame)
TpMapTitle.Size = UDim2.new(1, 0, 0, 40)
TpMapTitle.BackgroundTransparency = 1
TpMapTitle.Text = "🗺️️ TELEPORT TEMPAT (SCAN)"
TpMapTitle.TextColor3 = Color3.fromRGB(0, 255, 128)
TpMapTitle.Font = Enum.Font.GothamBlack
TpMapTitle.TextSize = 13

local TpMapScroll = Instance.new("ScrollingFrame", TpMapFrame)
TpMapScroll.Size = UDim2.new(1, -20, 1, -50)
TpMapScroll.Position = UDim2.new(0, 10, 0, 40)
TpMapScroll.BackgroundTransparency = 0.2
TpMapScroll.BackgroundColor3 = Color3.fromRGB(15, 20, 17)
TpMapScroll.ScrollBarThickness = 4
TpMapScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", TpMapScroll).CornerRadius = UDim.new(0, 6)

local TpMapListLayout = Instance.new("UIListLayout", TpMapScroll)
TpMapListLayout.Padding = UDim.new(0, 5)

-- ==========================================
-- 💥 FRAME: SCRIPT RUSUH MENU
-- ==========================================
local RusuhFrame = Instance.new("Frame", MainFrame) 
RusuhFrame.Size = UDim2.new(0, 260, 1, 0) 
RusuhFrame.Position = UDim2.new(1, 10, 0, 0) 
RusuhFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 12)
RusuhFrame.BackgroundTransparency = 0.15 
RusuhFrame.BorderSizePixel = 0
RusuhFrame.Visible = false
Instance.new("UICorner", RusuhFrame).CornerRadius = UDim.new(0, 10)

local RusuhStroke = Instance.new("UIStroke", RusuhFrame)
RusuhStroke.Color = Color3.fromRGB(0, 255, 128)
RusuhStroke.Thickness = 1.5
RusuhStroke.Transparency = 0.2

local RusuhTitle = Instance.new("TextLabel", RusuhFrame)
RusuhTitle.Size = UDim2.new(1, 0, 0, 40)
RusuhTitle.BackgroundTransparency = 1
RusuhTitle.Text = "💥 SCRIPT RUSUH"
RusuhTitle.TextColor3 = Color3.fromRGB(0, 255, 128)
RusuhTitle.Font = Enum.Font.GothamBlack
RusuhTitle.TextSize = 15

local RusuhScroll = Instance.new("ScrollingFrame", RusuhFrame)
RusuhScroll.Size = UDim2.new(1, -20, 1, -50)
RusuhScroll.Position = UDim2.new(0, 10, 0, 40)
RusuhScroll.BackgroundTransparency = 1
RusuhScroll.ScrollBarThickness = 4
RusuhScroll.CanvasSize = UDim2.new(0, 0, 0, 24 * 42) 
local RusuhListLayout = Instance.new("UIListLayout", RusuhScroll)
RusuhListLayout.Padding = UDim.new(0, 6)

-- ==========================================
-- ⌨️ SISTEM HOTKEY F2 
-- ==========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F2 then
        ScreenGui.Enabled = not ScreenGui.Enabled
        SaveCache()
    end
end)

-- ==========================================
-- 🛠️ FUNGSI BANTUAN DASAR & IY UTILS
-- ==========================================
local function getRoot(char, vfly)
    if vfly then
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.SeatPart then
            local veh = hum.SeatPart.Parent
            if veh:IsA("Model") then
                return veh.PrimaryPart or hum.SeatPart or veh:FindFirstChildWhichIsA("BasePart")
            else
                return hum.SeatPart
            end
        end
    end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function CreateActionBtn(name, callback)
    local Btn = Instance.new("TextButton", Container)
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35) 
    Btn.BackgroundTransparency = 0.2
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    local BtnStroke = Instance.new("UIStroke", Btn)
    BtnStroke.Color = Color3.fromRGB(231, 76, 60)
    BtnStroke.Thickness = 1.5

    Btn.MouseButton1Click:Connect(function()
        task.spawn(function()
            BtnStroke.Color = Color3.fromRGB(46, 204, 113)
            task.wait(0.2)
            BtnStroke.Color = Color3.fromRGB(231, 76, 60)
        end)
        callback()
    end)
end

local function CreateToggle(name, callback)
    local isActive = false
    local Btn = Instance.new("TextButton", Container)
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35) 
    Btn.BackgroundTransparency = 0.2
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    local BtnStroke = Instance.new("UIStroke", Btn)
    BtnStroke.Color = Color3.fromRGB(231, 76, 60) 
    BtnStroke.Thickness = 1.5

    Btn.MouseButton1Click:Connect(function()
        isActive = not isActive
        BtnStroke.Color = isActive and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
        callback(isActive)
    end)
end

local function CloseAllSubMenus()
    DecalFrame.Visible = false
    TpPlayerFrame.Visible = false
    ViewPlayerFrame.Visible = false
    TpMapFrame.Visible = false
    RusuhFrame.Visible = false
end

-- ==========================================
-- 1️⃣ FITUR: COINS NOT A NUMBER
-- ==========================================
local isFarmingFish = false
CreateToggle("💰 Coins NaN", function(state)
    isFarmingFish = state
    local Remotes = ReplicatedStorage:FindFirstChild("Fishing_System") and ReplicatedStorage.Fishing_System:FindFirstChild("Remotes")
    local FC = LocalPlayer:WaitForChild("PlayerScripts"):FindFirstChild("Fishing_Client")
    if FC then FC.Disabled = isFarmingFish end

    if isFarmingFish and Remotes then
        task.spawn(function()
            while isFarmingFish do
                pcall(function()
                    local char = LocalPlayer.Character
                    if not char then return end
                    local rod = char:FindFirstChild("Broken Rod") or char:FindFirstChild("Fishing Rod") or LocalPlayer.Backpack:FindFirstChild("Broken Rod") or LocalPlayer.Backpack:FindFirstChild("Fishing Rod")
                    if rod then
                        if rod.Name == "Broken Rod" then rod.Name = "Fishing Rod" end
                        if rod.Parent ~= char then char.Humanoid:EquipTool(rod) end
                        local fishData = {Sell_Price_KG = 0/0, Fish_Name = "SukaBintang01", FishImage = "rbxassetid://17409245912", Weight = 0/0}
                        Remotes.EquippedRod:FireServer()
                        Remotes.BeginFishing:FireServer()
                        task.wait(0.1)
                        Remotes.FishingTask:FireServer()
                        Remotes.FinalTask:FireServer(rod, fishData)
                        Remotes.FishCatched:FireServer(rod, fishData)
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end)

-- ==========================================
-- 2️⃣ FITUR: AUTO WHEELBARROW
-- ==========================================
local isAutoRiding = false
local isProcessingRide = false
CreateToggle("🛒 Auto Wheelbarrow", function(state)
    isAutoRiding = state
    isProcessingRide = false

    if isAutoRiding then
        task.spawn(function()
            while isAutoRiding do
                task.wait(0.1)
                if not isProcessingRide then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if string.find(string.lower(obj.Name), "wheelbarrow") then
                            local seat = obj:FindFirstChildWhichIsA("VehicleSeat", true) or obj:FindFirstChildWhichIsA("Seat", true)
                            if seat and seat.Occupant == nil then
                                isProcessingRide = true
                                pcall(function()
                                    local char = LocalPlayer.Character
                                    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
                                    local humanoid = char and char:FindFirstChild("Humanoid")
                                    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)

                                    if rootPart and humanoid and prompt and not humanoid.Sit then
                                        local savedCFrame = rootPart.CFrame
                                        rootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
                                        rootPart.CFrame = seat.CFrame + Vector3.new(0, 0.3, 0)
                                        if fireproximityprompt then fireproximityprompt(prompt)
                                        else prompt.MaxActivationDistance = 9999999; prompt.RequiresLineOfSight = false; fireproximityprompt(prompt) end
                                        humanoid:Sit(seat)
                                        task.wait(0.2)
                                        humanoid.Jump = true
                                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                                        task.wait(0.05)
                                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                                        task.wait(0.15)
                                        rootPart.CFrame = savedCFrame
                                        rootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
                                    end
                                end)
                                isProcessingRide = false
                                break
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- ==========================================
-- 3️⃣ FITUR: PIANO SPAMMER
-- ==========================================
local isSpammingPiano = false
local spamConnection = nil
local spamTimer = nil

local orderedKeys = {
    Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four, Enum.KeyCode.Five, 
    Enum.KeyCode.Six, Enum.KeyCode.Seven, Enum.KeyCode.Eight, Enum.KeyCode.Nine, Enum.KeyCode.Zero,
    Enum.KeyCode.Q, Enum.KeyCode.W, Enum.KeyCode.E, Enum.KeyCode.R, Enum.KeyCode.T, 
    Enum.KeyCode.Y, Enum.KeyCode.U, Enum.KeyCode.I, Enum.KeyCode.O, Enum.KeyCode.P,
    Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.F, Enum.KeyCode.G, 
    Enum.KeyCode.H, Enum.KeyCode.J, Enum.KeyCode.K, Enum.KeyCode.L,
    Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V, Enum.KeyCode.B, 
    Enum.KeyCode.N, Enum.KeyCode.M
}

local function stopSpamming()
    isSpammingPiano = false
    if spamConnection then spamConnection:Disconnect() spamConnection = nil end
    if spamTimer then task.cancel(spamTimer) spamTimer = nil end
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
end

CreateToggle("🎹 Piano Brutal", function(state)
    if state then
        stopSpamming()
        isSpammingPiano = true
        spamConnection = RunService.Heartbeat:Connect(function()
            if not isSpammingPiano then return end
            for i = 1, #orderedKeys do
                local key = orderedKeys[i]
                VirtualInputManager:SendKeyEvent(true, key, false, game)
                VirtualInputManager:SendKeyEvent(false, key, false, game)
            end
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
            for i = 1, #orderedKeys do
                local key = orderedKeys[i]
                VirtualInputManager:SendKeyEvent(true, key, false, game)
                VirtualInputManager:SendKeyEvent(false, key, false, game)
            end
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
        end)
        spamTimer = task.delay(30, function()
            if isSpammingPiano then stopSpamming() end
        end)
    else
        stopSpamming()
    end
end)

-- ==========================================
-- 4️⃣ MENU: DECAL CHANGER PANEL
-- ==========================================
CreateActionBtn("🖼️ Decal Changer", function()
    local newState = not DecalFrame.Visible
    CloseAllSubMenus()
    DecalFrame.Visible = newState
end)

local decalIDs = {
    "97621188548063",  "73203534417430",  "134834185288415", "85200908630517", 
    "103696008317336", "98665051722682",  "89005004083873",  "124107644275720", 
    "119362477766882", "135051539601314", "75286848578025",  "93619525646230", 
    "96469468149871",  "95798757543814",  "132520586948409", "76241030161216", 
    "81900715746842",  "123351582929503", "103862562885646", "125472981338673", 
    "101577115252273", "92654835490452",  "75581390378147",  "18721138013",
    "119911430798876", "135868263388393", "124295306744173", "77031658616427",
    "122584664996512", "100820160309981", "118358344042339", "98241598594893",
    "124197521447164", "95998018122646",  "83101670376944",  "106900665401467",
    "93769479126128",  "72356519867383",  "130188260773892", "75715745507820",
    "90636433912832",  "122417880275747", "116199329143461", "131918155427883",
    "107747751559949", "77235297674681", "125785962142006", "88925185923237",
    "121031801714770", "123863821313412", "75258599751318",  "130821336565497",
    "100777130375279", "94562243135321",  "122896214893586", "80948784549280",
    "93571970236375",  "104793836558416", "77701784444891",  "129407866418547",
    "129574778629018", "78301832119498",  "80377728136837",  "93685920524232",
    "98294813785358",  "111993790294475", "114999584257625", "131785713219876",
    "120747655874184", "117851244155531", "113290406249263", "110657214265135",
    "94818765680364",  "116447576635301", "122620216163757", "119017518926012",
    "139885028444737", "118155454007068", "72088247031696",  "124437704839119",
    "138763434489459", "120483906657333", "135686248548999", "138312991524010",
    "89430489368537",  "94578691852491",  "117064019114437", "131197681382977",
    "73094648154127",  "83998131998365",  "79696264372605",  "128730637019281",
    "102692069490375", "80301455005198",  "78814293639570",  "140258791380569",
    "115218437944820", "106613884674871", "108559261107558", "134941546524030",
    "81632053602904",  "82598654137492",  "82111470861232",  "101355803904839",
    "103369820318730", "129249729676333", "87652966439602",  "98128697330192",
    "94569400123709",  "108542009792132", "131829119848102", "98794228258962",
    "84848623393188",  "105376163872239", "130802932647826", "139492031192073",
    "120644962590316", "118737923041902", "96627428050713",  "96244369908125",
    "83862224708780",  "80293177331008",  "79649109378991",  "74972175454475"
}

local listLayout = ScrollFrame:FindFirstChildOfClass("UIListLayout")
if not listLayout then
    listLayout = Instance.new("UIListLayout")
    listLayout.Parent = ScrollFrame
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 5)
end

ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 6

local function applyDecalToServer(decalId)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local decalSign = character:FindFirstChild("DecalSign") or LocalPlayer.Backpack:FindFirstChild("DecalSign")
    if decalSign then
        local event = decalSign:FindFirstChild("UpdateSignImage")
        if event then
            event:FireServer(2, "rbxthumb://type=Asset&id=" .. decalId .. "&w=420&h=420")
        end
    end
end

for _, decalId in ipairs(decalIDs) do
    local itemFrame = Instance.new("Frame")
    itemFrame.Size = UDim2.new(1, -10, 0, 50)
    itemFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 20)
    itemFrame.BackgroundTransparency = 0.5
    itemFrame.BorderSizePixel = 0
    itemFrame.Parent = ScrollFrame
    Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 6)
    
    local imgPreview = Instance.new("ImageLabel", itemFrame)
    imgPreview.Size = UDim2.new(0, 40, 0, 40)
    imgPreview.Position = UDim2.new(0, 5, 0, 5)
    imgPreview.Image = "rbxthumb://type=Asset&id=" .. decalId .. "&w=150&h=150"
    imgPreview.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", imgPreview).CornerRadius = UDim.new(0, 4)
    
    local idText = Instance.new("TextLabel", itemFrame)
    idText.Size = UDim2.new(0, 110, 0, 50)
    idText.Position = UDim2.new(0, 52, 0, 0)
    idText.BackgroundTransparency = 1
    idText.Text = decalId
    idText.TextColor3 = Color3.fromRGB(220, 220, 220)
    idText.Font = Enum.Font.GothamSemibold
    idText.TextSize = 11
    idText.TextXAlignment = Enum.TextXAlignment.Left
    
    local applyBtn = Instance.new("TextButton", itemFrame)
    applyBtn.Size = UDim2.new(0, 60, 0, 30)
    applyBtn.Position = UDim2.new(1, -65, 0, 10)
    applyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
    applyBtn.Text = "APPLY"
    applyBtn.TextColor3 = Color3.fromRGB(25, 25, 25)
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.TextSize = 11
    Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 4)
    
    applyBtn.MouseButton1Click:Connect(function() applyDecalToServer(decalId) end)
end

-- ==========================================
-- 5️⃣ MENU: TELEPORT PLAYER PANEL (INSTANT SNAP)
-- ==========================================
CreateActionBtn("👤 Teleport Player", function()
    local newState = not TpPlayerFrame.Visible
    CloseAllSubMenus()
    TpPlayerFrame.Visible = newState
    
    if TpPlayerFrame.Visible then
        TpSearchBox.Text = "" 
        for _, child in ipairs(TpPlayerScroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        
        local allPlayers = Players:GetPlayers()
        TpPlayerScroll.CanvasSize = UDim2.new(0, 0, 0, #allPlayers * 55)
        
        for _, p in ipairs(allPlayers) do
            if p ~= LocalPlayer then
                local itemFrame = Instance.new("Frame", TpPlayerScroll)
                itemFrame.Size = UDim2.new(1, 0, 0, 50)
                itemFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 20)
                itemFrame.BackgroundTransparency = 0.5
                itemFrame.BorderSizePixel = 0
                Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 6)
                
                local avatarImg = Instance.new("ImageLabel", itemFrame)
                avatarImg.Size = UDim2.new(0, 40, 0, 40)
                avatarImg.Position = UDim2.new(0, 5, 0, 5)
                avatarImg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                avatarImg.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
                Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(0, 4)
                
                local nameText = Instance.new("TextLabel", itemFrame)
                nameText.Name = "NameLabel"
                nameText.Size = UDim2.new(0, 130, 0, 50)
                nameText.Position = UDim2.new(0, 50, 0, 0)
                nameText.BackgroundTransparency = 1
                nameText.Text = p.DisplayName .. "\n(@" .. p.Name .. ")"
                nameText.TextColor3 = Color3.fromRGB(220, 220, 220)
                nameText.Font = Enum.Font.GothamSemibold
                nameText.TextSize = 10
                nameText.TextXAlignment = Enum.TextXAlignment.Left
                nameText.TextTruncate = Enum.TextTruncate.AtEnd
                
                local tpBtn = Instance.new("TextButton", itemFrame)
                tpBtn.Size = UDim2.new(0, 50, 0, 30)
                tpBtn.Position = UDim2.new(1, -55, 0, 10)
                tpBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
                tpBtn.Text = "GO"
                tpBtn.TextColor3 = Color3.fromRGB(25, 25, 25)
                tpBtn.Font = Enum.Font.GothamBold
                tpBtn.TextSize = 11
                Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 4)
                
                tpBtn.MouseButton1Click:Connect(function()
                    pcall(function()
                        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local char = LocalPlayer.Character
                            if char then
                                local hum = char:FindFirstChildOfClass("Humanoid")
                                if hum then hum.Sit = false end
                                local root = char:FindFirstChild("HumanoidRootPart")
                                if root then
                                    root.AssemblyLinearVelocity = Vector3.new(0,0,0)
                                end
                                task.wait(0.05)
                                char:PivotTo(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0))
                            end
                        end
                    end)
                end)
            end
        end
    end
end)

-- ==========================================
-- 6️⃣ MENU: VIEW PLAYER PANEL (+ SEARCH)
-- ==========================================
local viewing = nil
local viewDied, viewChanged

local function stopViewing()
    if viewDied then viewDied:Disconnect(); viewDied = nil end
    if viewChanged then viewChanged:Disconnect(); viewChanged = nil end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end
    viewing = nil
end

CreateActionBtn("👁️ View Player", function()
    local newState = not ViewPlayerFrame.Visible
    CloseAllSubMenus()
    ViewPlayerFrame.Visible = newState
    
    if ViewPlayerFrame.Visible then
        ViewSearchBox.Text = "" 
        for _, child in ipairs(ViewPlayerScroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        
        local allPlayers = Players:GetPlayers()
        ViewPlayerScroll.CanvasSize = UDim2.new(0, 0, 0, (#allPlayers + 1) * 55)
        
        local unviewFrame = Instance.new("Frame", ViewPlayerScroll)
        unviewFrame.Size = UDim2.new(1, 0, 0, 50)
        unviewFrame.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
        unviewFrame.BackgroundTransparency = 0.3
        unviewFrame.BorderSizePixel = 0
        Instance.new("UICorner", unviewFrame).CornerRadius = UDim.new(0, 6)
        
        local unviewText = Instance.new("TextLabel", unviewFrame)
        unviewText.Size = UDim2.new(0, 160, 0, 50)
        unviewText.Position = UDim2.new(0, 10, 0, 0)
        unviewText.BackgroundTransparency = 1
        unviewText.Text = "🛑 STOP VIEWING (UNVIEW)"
        unviewText.TextColor3 = Color3.fromRGB(255, 100, 100)
        unviewText.Font = Enum.Font.GothamBold
        unviewText.TextSize = 10
        unviewText.TextXAlignment = Enum.TextXAlignment.Left
        
        local unviewBtn = Instance.new("TextButton", unviewFrame)
        unviewBtn.Size = UDim2.new(0, 60, 0, 30)
        unviewBtn.Position = UDim2.new(1, -65, 0, 10)
        unviewBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        unviewBtn.Text = "RESET"
        unviewBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        unviewBtn.Font = Enum.Font.GothamBold
        unviewBtn.TextSize = 10
        Instance.new("UICorner", unviewBtn).CornerRadius = UDim.new(0, 4)
        
        unviewBtn.MouseButton1Click:Connect(function() stopViewing() end)

        for _, p in ipairs(allPlayers) do
            if p ~= LocalPlayer then
                local itemFrame = Instance.new("Frame", ViewPlayerScroll)
                itemFrame.Size = UDim2.new(1, 0, 0, 50)
                itemFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 20)
                itemFrame.BackgroundTransparency = 0.5
                itemFrame.BorderSizePixel = 0
                Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 6)
                
                local avatarImg = Instance.new("ImageLabel", itemFrame)
                avatarImg.Size = UDim2.new(0, 40, 0, 40)
                avatarImg.Position = UDim2.new(0, 5, 0, 5)
                avatarImg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                avatarImg.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
                Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(0, 4)
                
                local nameText = Instance.new("TextLabel", itemFrame)
                nameText.Name = "NameLabel"
                nameText.Size = UDim2.new(0, 130, 0, 50)
                nameText.Position = UDim2.new(0, 50, 0, 0)
                nameText.BackgroundTransparency = 1
                nameText.Text = p.DisplayName .. "\n(@" .. p.Name .. ")"
                nameText.TextColor3 = Color3.fromRGB(220, 220, 220)
                nameText.Font = Enum.Font.GothamSemibold
                nameText.TextSize = 10
                nameText.TextXAlignment = Enum.TextXAlignment.Left
                nameText.TextTruncate = Enum.TextTruncate.AtEnd
                
                local viewBtn = Instance.new("TextButton", itemFrame)
                viewBtn.Size = UDim2.new(0, 50, 0, 30)
                viewBtn.Position = UDim2.new(1, -55, 0, 10)
                viewBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
                viewBtn.Text = "VIEW"
                viewBtn.TextColor3 = Color3.fromRGB(25, 25, 25)
                viewBtn.Font = Enum.Font.GothamBold
                viewBtn.TextSize = 10
                Instance.new("UICorner", viewBtn).CornerRadius = UDim.new(0, 4)
                
                viewBtn.MouseButton1Click:Connect(function()
                    pcall(function()
                        if p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
                            stopViewing()
                            viewing = p
                            camera.CameraSubject = viewing.Character:FindFirstChildOfClass("Humanoid")
                            viewDied = viewing.CharacterAdded:Connect(function(char)
                                local hum = char:WaitForChild("Humanoid")
                                camera.CameraSubject = hum
                            end)
                        end
                    end)
                end)
            end
        end
    end
end)

-- ==========================================
-- 7️⃣ MENU: TELEPORT TEMPAT (PRESET LOCATIONS - INSTANT SNAP)
-- ==========================================
local customLocations = {
    {Name = "Piano Konser", Pos = Vector3.new(368.72, 81.69, -1215.09)},
    {Name = "Tempat Nonton", Pos = Vector3.new(105.78, 51.79, -1336.48)},
    {Name = "Rumah Ayam", Pos = Vector3.new(232.71, 89.03, -1425.92)},
    {Name = "Rumah Pohon", Pos = Vector3.new(177.79, 202.66, -1233.27)},
    {Name = "Tempat Santai", Pos = Vector3.new(-410.56, 71.72, -920.36)},
    {Name = "Perosotan", Pos = Vector3.new(-292.41, 69.27, -1014.37)},
    {Name = "Picnic", Pos = Vector3.new(-73.18, 69.52, -794.39)},
    {Name = "Api Unggun", Pos = Vector3.new(-411.05, 67.31, -1354.28)},
    {Name = "Papan Iklan", Pos = Vector3.new(-289.79, 95.66, -1496.83)},
    {Name = "Jembatan", Pos = Vector3.new(-85.71, 33.66, -1133.45)},
    {Name = "Hutan Premium", Pos = Vector3.new(510.88, 29.00, 2150.21)},
    {Name = "Green House", Pos = Vector3.new(91.29, 69.35, -782.57)},
    {Name = "Kereta Gantung", Pos = Vector3.new(-298.97, 122.74, -882.37)},
    {Name = "Hutan Studio", Pos = Vector3.new(747.95, -28.22, -818.74)},
    {Name = "Taman Bermain", Pos = Vector3.new(1662.64, 36.29, -4520.78)},
    {Name = "Labirin", Pos = Vector3.new(-1340.41, 37.01, -3302.17)},
    {Name = "Spawn 1", Pos = Vector3.new(-405.23, 54.18, -1201.44)},
    {Name = "Spawn 2", Pos = Vector3.new(156.04, 41.64, -1062.81)},
    {Name = "Isolasi Diri 1", Pos = Vector3.new(-771.97, 14.37, -417.99)},
    {Name = "Isolasi Diri 2", Pos = Vector3.new(-418.76, 40.75, -920.55)},
    {Name = "Carriage", Pos = Vector3.new(546.86, 7.48, 2101.28)},
    {Name = "Leaderboard", Pos = Vector3.new(273.11, 63.31, -893.29)},
    {Name = "Market Stall", Pos = Vector3.new(130.29, 73.11, -1569.60)},
    {Name = "Booth System", Pos = Vector3.new(610.46, 45.01, -465.23)}
}

CreateActionBtn("🗺️ Teleport Tempat", function()
    local newState = not TpMapFrame.Visible
    CloseAllSubMenus()
    TpMapFrame.Visible = newState
    
    if TpMapFrame.Visible then
        for _, child in ipairs(TpMapScroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        
        TpMapScroll.CanvasSize = UDim2.new(0, 0, 0, #customLocations * 45)
        
        for i, loc in ipairs(customLocations) do
            local itemFrame = Instance.new("Frame", TpMapScroll)
            itemFrame.Size = UDim2.new(1, 0, 0, 40)
            itemFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 20)
            itemFrame.BackgroundTransparency = 0.5
            itemFrame.BorderSizePixel = 0
            Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 6)
            
            local nameText = Instance.new("TextLabel", itemFrame)
            nameText.Size = UDim2.new(0, 160, 0, 40)
            nameText.Position = UDim2.new(0, 10, 0, 0)
            nameText.BackgroundTransparency = 1
            nameText.Text = i .. ". " .. loc.Name
            nameText.TextColor3 = Color3.fromRGB(220, 220, 220)
            nameText.Font = Enum.Font.GothamSemibold
            nameText.TextSize = 10
            nameText.TextXAlignment = Enum.TextXAlignment.Left
            
            local tpBtn = Instance.new("TextButton", itemFrame)
            tpBtn.Size = UDim2.new(0, 50, 0, 26)
            tpBtn.Position = UDim2.new(1, -55, 0, 7)
            tpBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
            tpBtn.Text = "GO"
            tpBtn.TextColor3 = Color3.fromRGB(25, 25, 25)
            tpBtn.Font = Enum.Font.GothamBold
            tpBtn.TextSize = 11
            Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 4)
            
            tpBtn.MouseButton1Click:Connect(function()
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then hum.Sit = false end
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if root then
                            root.AssemblyLinearVelocity = Vector3.new(0,0,0)
                        end
                        task.wait(0.05)
                        char:PivotTo(CFrame.new(loc.Pos))
                    end
                end)
            end)
        end
    end
end)

--- ==========================================
-- 8️⃣ MENU: SCRIPT RUSUH PANEL
-- ==========================================
CreateActionBtn("💥 Script Rusuh", function()
    local newState = not RusuhFrame.Visible
    CloseAllSubMenus()
    RusuhFrame.Visible = newState
end)

local function CreateRusuhToggle(name, onEnable, onDisable)
    local isActive = false
    local Btn = Instance.new("TextButton", RusuhScroll)
    Btn.Size = UDim2.new(1, 0, 0, 36)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 35, 30)
    Btn.Text = name .. " [OFF]"
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 11
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    local BtnStroke = Instance.new("UIStroke", Btn)
    BtnStroke.Color = Color3.fromRGB(0, 255, 128)
    BtnStroke.Thickness = 1.5
    BtnStroke.Transparency = 0.3

    Btn.MouseButton1Click:Connect(function()
        isActive = not isActive
        if isActive then
            Btn.Text = name .. " [ON]"
            Btn.TextColor3 = Color3.fromRGB(0, 255, 128)
            BtnStroke.Color = Color3.fromRGB(0, 255, 128)
            BtnStroke.Transparency = 0
            onEnable()
        else
            Btn.Text = name .. " [OFF]"
            Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            BtnStroke.Color = Color3.fromRGB(0, 255, 128)
            BtnStroke.Transparency = 0.3
            onDisable()
        end
    end)
end

-- ==========================================
-- 🚀 FITUR RUSUH (DIURUTKAN SESUAI REQUEST)
-- ==========================================

-- [1] 🕊️ FLY
iyflyspeed = 10
vehicleflyspeed = 10
QEfly = true
FLYING = false
local flyKeyDown, flyKeyUp

local function sFLY(vfly)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        repeat task.wait() until char:FindFirstChildOfClass("Humanoid")
        humanoid = char:FindFirstChildOfClass("Humanoid")
    end

    if flyKeyDown then flyKeyDown:Disconnect() flyKeyDown = nil end
    if flyKeyUp then flyKeyUp:Disconnect() flyKeyUp = nil end

    local T = getRoot(char, vfly)
    if not T then return end

    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local SPEED = 0

    local function FLY()
        FLYING = true
        local BG = Instance.new('BodyGyro')
        local BV = Instance.new('BodyVelocity')
        BG.P = 9e4
        BG.Parent = T
        BV.Parent = T
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.CFrame = T.CFrame
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)

        task.spawn(function()
            repeat task.wait()
                local camera = workspace.CurrentCamera
                if not vfly and humanoid then
                    humanoid.PlatformStand = true
                end

                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                    SPEED = 50
                elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
                    SPEED = 0
                end

                if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                    BV.Velocity = ((camera.CFrame.LookVector * (CONTROL.F + CONTROL.B)) + ((camera.CFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * SPEED
                    lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                    BV.Velocity = ((camera.CFrame.LookVector * (lCONTROL.F + lCONTROL.B)) + ((camera.CFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + lCONTROL.Q + lCONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * SPEED
                else
                    BV.Velocity = Vector3.new(0, 0, 0)
                end
                BG.CFrame = camera.CFrame
            until not FLYING

            CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            SPEED = 0
            BG:Destroy()
            BV:Destroy()

            if humanoid then humanoid.PlatformStand = false end
        end)
    end

    local currentSpeed = vfly and vehicleflyspeed or iyflyspeed

    flyKeyDown = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = currentSpeed
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = -currentSpeed
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = -currentSpeed
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = currentSpeed
        elseif input.KeyCode == Enum.KeyCode.E and QEfly then CONTROL.Q = currentSpeed * 2
        elseif input.KeyCode == Enum.KeyCode.Q and QEfly then CONTROL.E = -currentSpeed * 2
        end
    end)

    flyKeyUp = UserInputService.InputEnded:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0
        elseif input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 0
        elseif input.KeyCode == Enum.KeyCode.Q then CONTROL.E = 0
        end
    end)

    FLY()
end

local function NOFLY()
    FLYING = false
    if flyKeyDown then flyKeyDown:Disconnect() flyKeyDown = nil end
    if flyKeyUp then flyKeyUp:Disconnect() flyKeyUp = nil end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
        LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
    end
end

CreateRusuhToggle("🕊️ Fly", function() sFLY(false) end, function() NOFLY() end)

-- [2] 🛸 VEHICLE FLY
CreateRusuhToggle("🛸 Vehicle Fly", function() sFLY(true) end, function() NOFLY() end)

-- [3] 🛒 CART DRIVE
local speed = 50 
local cartTarget, cartBV, cartBG, cartConn
local currentVel = Vector3.zero

local function getCart()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if hum and hum.SeatPart then
        local seat = hum.SeatPart
        return seat.AssemblyRootPart or (seat.Parent:IsA("Model") and seat.Parent.PrimaryPart) or seat
    end

    if hrp then
        local params = RaycastParams.new()
        params.FilterAncestorsInstances = {char}
        params.FilterType = Enum.RaycastFilterType.Exclude
        local res = Workspace:Raycast(hrp.Position, Vector3.new(0, -7, 0), params)
        if res and res.Instance then
            return res.Instance.AssemblyRootPart or res.Instance
        end
    end
    return nil
end

local function stopCartDrive()
    if cartConn then cartConn:Disconnect() cartConn = nil end
    if cartBV then cartBV:Destroy() cartBV = nil end
    if cartBG then cartBG:Destroy() cartBG = nil end
    cartTarget = nil
    currentVel = Vector3.zero
end

local function startCartDrive()
    stopCartDrive()
    cartTarget = getCart()
    if not cartTarget then return end

    pcall(function() cartTarget.Anchored = false end)

    cartBV = Instance.new("BodyVelocity")
    cartBV.MaxForce = Vector3.new(math.huge, 0, math.huge)
    cartBV.Velocity = Vector3.zero
    cartBV.Parent = cartTarget

    cartBG = Instance.new("BodyGyro")
    cartBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    cartBG.P = 8000
    cartBG.D = 1000
    cartBG.CFrame = cartTarget.CFrame
    cartBG.Parent = cartTarget

    cartConn = RunService.PreSimulation:Connect(function(dt)
        if not cartTarget or not cartTarget.Parent then
            stopCartDrive()
            return
        end

        local cam = Workspace.CurrentCamera
        if not cam then return end

        local camLook = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
        if camLook.Magnitude > 0 then camLook = camLook.Unit end

        local camRight = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)
        if camRight.Magnitude > 0 then camRight = camRight.Unit end

        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camLook end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camLook end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camRight end

        local targetVel = (moveDir.Magnitude > 0) and (moveDir.Unit * speed) or Vector3.zero
        currentVel = currentVel:Lerp(targetVel, math.min(dt * 4, 1))
        cartBV.Velocity = currentVel

        local isShiftLock = (UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter) 
            or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) 
            or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)

        local facing = isShiftLock and camLook or (moveDir.Magnitude > 0 and moveDir.Unit or nil)
        if facing then
            cartBG.CFrame = cartBG.CFrame:Lerp(CFrame.lookAt(cartTarget.Position, cartTarget.Position + facing), math.min(dt * 7, 1))
        end
    end)
end

CreateRusuhToggle("🛒 Cart Drive", function() startCartDrive() end, function() stopCartDrive() end)

-- [4] 🌪️ WALKFLING
local walkflinging = false
local walkflingDied, walkflingNoclip

CreateRusuhToggle("🌪️ WalkFling", function()
    walkflinging = true
    local speaker = LocalPlayer

    walkflingNoclip = RunService.Stepped:Connect(function()
        if speaker.Character then
            for _, part in next, speaker.Character:GetDescendants() do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)

    local char = speaker.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            walkflingDied = hum.Died:Connect(function() walkflinging = false end)
        end
    end

    task.spawn(function()
        repeat
            RunService.Heartbeat:Wait()
            local character = speaker.Character
            local root = getRoot(character, false)
            local vel, movel = nil, 0.1

            while not (character and character.Parent and root and root.Parent) and walkflinging do
                RunService.Heartbeat:Wait()
                character = speaker.Character
                root = getRoot(character, false)
            end

            if not walkflinging then break end

            vel = root.Velocity
            root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)

            RunService.RenderStepped:Wait()
            if character and character.Parent and root and root.Parent then
                root.Velocity = vel
            end

            RunService.Stepped:Wait()
            if character and character.Parent and root and root.Parent then
                root.Velocity = vel + Vector3.new(0, movel, 0)
                movel = movel * -1
            end
        until walkflinging == false
    end)
end, function()
    walkflinging = false
    if walkflingDied then walkflingDied:Disconnect() walkflingDied = nil end
    if walkflingNoclip then walkflingNoclip:Disconnect() walkflingNoclip = nil end
end)

-- [5] 💥 FLING
local flinging = false
local flingDied, flingNoclip

CreateRusuhToggle("💥 Fling", function()
    flinging = true
    local speaker = LocalPlayer

    pcall(function()
        local char = speaker.Character
        if not char then return end
        local root = getRoot(char, false)
        if not root then return end

        for _, child in next, char:GetDescendants() do
            if child:IsA("BasePart") then
                child.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
                child.Massless = true
                child.Velocity = Vector3.zero
            end
        end

        task.wait(0.1)

        local bambam = Instance.new("BodyAngularVelocity")
        bambam.Name = "IYFlingVel"
        bambam.Parent = root
        bambam.AngularVelocity = Vector3.new(0, 99999, 0)
        bambam.MaxTorque = Vector3.new(0, math.huge, 0)
        bambam.P = math.huge

        flingNoclip = RunService.Stepped:Connect(function()
            if speaker.Character then
                for _, part in next, speaker.Character:GetDescendants() do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            flingDied = hum.Died:Connect(function() flinging = false end)
        end

        task.spawn(function()
            repeat
                bambam.AngularVelocity = Vector3.new(0, 99999, 0)
                task.wait(0.2)
                bambam.AngularVelocity = Vector3.new(0, 0, 0)
                task.wait(0.1)
            until flinging == false

            if bambam then bambam:Destroy() end
        end)
    end)
end, function()
    flinging = false
    if flingDied then flingDied:Disconnect() flingDied = nil end
    if flingNoclip then flingNoclip:Disconnect() flingNoclip = nil end

    pcall(function()
        local char = LocalPlayer.Character
        if char and getRoot(char, false) then
            for _, v in next, char:GetDescendants() do
                if v:IsA("BasePart") then
                    v.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
                    v.Massless = false
                    v.Velocity = Vector3.zero
                elseif v:IsA("BodyAngularVelocity") and v.Name == "IYFlingVel" then
                    v:Destroy()
                end
            end
        end
    end)
end)

-- [6] 🛡️ ANTI-FLING
local antifling
CreateRusuhToggle("🛡️ Anti-Fling", function()
    if antifling then antifling:Disconnect() end
    antifling = RunService.Stepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end
    end)
end, function()
    if antifling then antifling:Disconnect() antifling = nil end
end)

-- [7] 👻 INVISIBLE (UNDERGROUND SYNC)
local invisibleActive = false
local realCharacter = nil
local fakeCharacter = nil
local invisConnection = nil
local fakeCharDied = nil
local originalTransparencies = {}

CreateRusuhToggle("👻 Invisible (Ghost)", function()
    if invisibleActive then return end
    invisibleActive = true
    realCharacter = LocalPlayer.Character
    if not realCharacter or not realCharacter:FindFirstChild("HumanoidRootPart") then
        invisibleActive = false
        return
    end
    
    -- Clone karakter untuk visual dummy di atas tanah
    realCharacter.Archivable = true
    fakeCharacter = realCharacter:Clone()
    fakeCharacter.Name = LocalPlayer.Name .. "_Fake"
    fakeCharacter.Parent = workspace
    
    -- Buat dummy memudar (50% transparansi)
    for _, v in pairs(fakeCharacter:GetDescendants()) do
        if (v:IsA("BasePart") or v:IsA("Decal")) and v.Name ~= "HumanoidRootPart" then
            v.Transparency = 0.5
        end
    end
    
    -- Sembunyikan sepenuhnya karakter asli & rekam nilai transparansi awalnya
    originalTransparencies = {}
    for _, v in pairs(realCharacter:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then
            originalTransparencies[v] = v.Transparency
            if v.Name ~= "HumanoidRootPart" then
                v.Transparency = 1 
            end
        end
    end
    
    -- Overwrite kontrol lokal ke fake character
    LocalPlayer.Character = fakeCharacter
    workspace.CurrentCamera.CameraSubject = fakeCharacter:FindFirstChildOfClass("Humanoid")
    
    local fakeHum = fakeCharacter:FindFirstChildOfClass("Humanoid")
    if fakeHum then
        fakeCharDied = fakeHum.Died:Connect(function()
            if invisibleActive then stopInvisible() end
        end)
    end
    
    -- Loop Stepped untuk membawa karakter asli ke bawah tanah persis di bawah dummy
    invisConnection = RunService.Stepped:Connect(function()
        if invisibleActive and realCharacter and realCharacter.Parent and fakeCharacter and fakeCharacter.Parent then
            local realHRP = realCharacter:FindFirstChild("HumanoidRootPart")
            local fakeHRP = fakeCharacter:FindFirstChild("HumanoidRootPart")
            if realHRP and fakeHRP then
                for _, v in pairs(realCharacter:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
                local realHum = realCharacter:FindFirstChildOfClass("Humanoid")
                if realHum then
                    realHum.PlatformStand = true -- Mencegah freefall
                end
                
                -- Offset Y = -15 (Aman di bawah lantai tapi suara VC tetap nyampe)
                realHRP.CFrame = fakeHRP.CFrame * CFrame.new(0, -15, 0)
                realHRP.Velocity = Vector3.zero
            end
        else
            -- Jika salah satu hilang (reset, dll) kembalikan sistem normal
            if invisibleActive then stopInvisible() end
        end
    end)
    
end, function()
    -- Fungsi stop dipanggil saat tombol di-OFF
    if not invisibleActive then return end
    invisibleActive = false
    
    if invisConnection then invisConnection:Disconnect() invisConnection = nil end
    if fakeCharDied then fakeCharDied:Disconnect() fakeCharDied = nil end
    
    if realCharacter and realCharacter.Parent and fakeCharacter and fakeCharacter.Parent then
        local realHRP = realCharacter:FindFirstChild("HumanoidRootPart")
        local fakeHRP = fakeCharacter:FindFirstChild("HumanoidRootPart")
        if realHRP and fakeHRP then
            -- MUNCUL OTOMATIS: Angkat karakter asli kembali ke atas (posisi terakhir dummy)
            realHRP.CFrame = fakeHRP.CFrame
        end
        
        -- Kembalikan transparansi karakter asli
        for v, orig in pairs(originalTransparencies) do
            if v and v.Parent then
                v.Transparency = orig
            end
        end
        
        local realHum = realCharacter:FindFirstChildOfClass("Humanoid")
        if realHum then
            realHum.PlatformStand = false
        end
    end
    
    if fakeCharacter then
        fakeCharacter:Destroy()
        fakeCharacter = nil
    end
    
    -- Kembalikan kontrol player ke karakter asli
    LocalPlayer.Character = realCharacter
    if realCharacter then
        workspace.CurrentCamera.CameraSubject = realCharacter:FindFirstChildOfClass("Humanoid")
    end
    originalTransparencies = {}
end)

-- [8] 🖱️ CTRL + CLICK TP (INSTANT SNAP)
local clickTpConn
local mouse = LocalPlayer:GetMouse()
CreateRusuhToggle("🖱️ Ctrl + Click TP", function()
    clickTpConn = mouse.Button1Down:Connect(function()
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and mouse.Hit then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.Sit = false end
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.AssemblyLinearVelocity = Vector3.zero
                end
                char:PivotTo(mouse.Hit * CFrame.new(0, 3, 0))
            end
        end
    end)
end, function()
    if clickTpConn then clickTpConn:Disconnect() end
end)

-- [9] 🔍 INFINITE ZOOM
CreateRusuhToggle("🔍 Infinite Zoom", function()
    pcall(function()
        LocalPlayer.CameraMaxZoomDistance = 999999
    end)
end, function()
    pcall(function()
        LocalPlayer.CameraMaxZoomDistance = 400
    end)
end)

-- [10] 💤 ANTI AFK
local antiAfk
CreateRusuhToggle("💤 Anti AFK", function()
    local vu = game:GetService("VirtualUser")
    antiAfk = LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end, function()
    if antiAfk then antiAfk:Disconnect() antiAfk = nil end
end)

-- [11] 👻 NOCLIP
local noclipConnection
CreateRusuhToggle("👻 Noclip", function()
    noclipConnection = RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then
                    p.CanCollide = false
                end
            end
        end
    end)
end, function()
    if noclipConnection then noclipConnection:Disconnect() end
end)

-- [12] 🌀 SPIN KARAKTER
local spinVel
CreateRusuhToggle("🌀 Spin Karakter", function()
    local char = LocalPlayer.Character
    if char and getRoot(char, false) then
        spinVel = Instance.new("BodyAngularVelocity")
        spinVel.Name = "SpinVelocity"
        spinVel.Parent = getRoot(char, false)
        spinVel.MaxTorque = Vector3.new(0, math.huge, 0)
        spinVel.AngularVelocity = Vector3.new(0, 50, 0)
    end
end, function()
    if spinVel then spinVel:Destroy() end
    pcall(function()
        local char = LocalPlayer.Character
        if char and getRoot(char, false) then
            for _, v in pairs(getRoot(char, false):GetChildren()) do
                if v.Name == "SpinVelocity" then v:Destroy() end
            end
        end
    end)
end)

-- [13] 🚫 CLIENT ANTI-KICK
local antiKickEnabled = false
local antiKickHooked = false

local function initAntiKickHook()
    if antiKickHooked or not hookmetamethod then return end
    antiKickHooked = true
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
        local method = getnamecallmethod and getnamecallmethod() or ""
        if antiKickEnabled and select(1, ...) == LocalPlayer and (method == "Kick" or method == "kick") then return nil end
        return oldNamecall(...)
    end))
    if hookfunction then
        local oldKick
        oldKick = hookfunction(LocalPlayer.Kick, newcclosure(function(self, ...)
            if antiKickEnabled and self == LocalPlayer then return nil end
            return oldKick(self, ...)
        end))
    end
end
CreateRusuhToggle("🚫 Client Anti-Kick", function()
    antiKickEnabled = true
    initAntiKickHook()
end, function() antiKickEnabled = false end)

-- [14] ⏸️ ANTI PAUSE UI
CreateRusuhToggle("⏸️ Anti Pause UI", function()
    pcall(function()
        if networkPaused then networkPaused:Disconnect() end
        local robloxGui = CoreGui:FindFirstChild("RobloxGui")
        if robloxGui then
            networkPaused = robloxGui.ChildAdded:Connect(function(obj)
                if obj.Name == "CoreScripts/NetworkPause" then obj:Destroy() end
            end)
            local pauseUI = robloxGui:FindFirstChild("CoreScripts/NetworkPause")
            if pauseUI then pauseUI:Destroy() end
        end
    end)
end, function()
    pcall(function()
        if networkPaused then networkPaused:Disconnect() networkPaused = nil end
    end)
end)

-- [15] 🦘 INFINITE JUMP
local infJumpConn
CreateRusuhToggle("🦘 Infinite Jump", function()
    infJumpConn = UserInputService.JumpRequest:Connect(function()
        pcall(function() LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
    end)
end, function()
    if infJumpConn then infJumpConn:Disconnect() end
end)

-- [16] ⚡ SPEED 300
local speedActive = false
CreateRusuhToggle("⚡ Speed 300", function()
    speedActive = true
    task.spawn(function()
        while speedActive do
            pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 300 end)
            task.wait(0.5)
        end
    end)
end, function()
    speedActive = false
    pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end)
end)

-- [17] 👁️ ESP PLAYERS
local espActive = false
local espElements = {}

CreateRusuhToggle("👁️ ESP Players", function()
    espActive = true
    ESPenabled = true

    task.spawn(function()
        while espActive do
            pcall(function()
                local myChar = LocalPlayer.Character
                local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
                        local char = p.Character
                        local hrp = char.HumanoidRootPart
                        local head = char:FindFirstChild("Head") or hrp
                        local humanoid = char.Humanoid

                        local highlight = char:FindFirstChild("ESPHighlight")
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.Name = "ESPHighlight"
                            highlight.FillColor = Color3.fromRGB(255, 255, 255) 
                            highlight.FillTransparency = 0.4
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.OutlineTransparency = 0
                            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            highlight.Adornee = char
                            highlight.Parent = char
                            table.insert(espElements, highlight)
                        end

                        local billboard = head:FindFirstChild("ESPText")
                        if not billboard then
                            billboard = Instance.new("BillboardGui")
                            billboard.Name = "ESPText"
                            billboard.Size = UDim2.new(0, 250, 0, 30)
                            billboard.StudsOffset = Vector3.new(0, 3, 0)
                            billboard.AlwaysOnTop = true

                            local label = Instance.new("TextLabel")
                            label.Name = "InfoLabel"
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextColor3 = Color3.fromRGB(255, 255, 255)
                            label.TextStrokeTransparency = 0 
                            label.TextSize = 14
                            label.Font = Enum.Font.SourceSansBold
                            label.Parent = billboard

                            billboard.Adornee = head
                            billboard.Parent = head
                            table.insert(espElements, billboard)
                        end

                        if billboard and billboard:FindFirstChild("InfoLabel") then
                            local distance = 0
                            if myHrp then
                                distance = math.floor((hrp.Position - myHrp.Position).Magnitude)
                            end
                            local health = math.floor(humanoid.Health)
                            billboard.InfoLabel.Text = string.format("Name: %s | Health: %d | Studs: %d", p.Name, health, distance)
                        end
                    end
                end
            end)
            task.wait(0.1) 
        end
    end)
end, function()
    espActive = false
    ESPenabled = false

    for _, elem in ipairs(espElements) do
        if elem then elem:Destroy() end
    end
    table.clear(espElements)

    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            local hl = p.Character:FindFirstChild("ESPHighlight")
            if hl then hl:Destroy() end
            local head = p.Character:FindFirstChild("Head")
            if head then
                local bb = head:FindFirstChild("ESPText")
                if bb then bb:Destroy() end
            end
        end
    end
end)

-- [18] 📜 LOAD MOONDEX
CreateRusuhToggle("📜 Load MoonDex", function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)
end, function() end)

-- [19] 🚦 LOAD REMOTESPY
CreateRusuhToggle("🚦 Load RemoteSpy", function()
    pcall(function() loadstring(game:HttpGet("https://gitlab.com/upio/cobalt/-/releases/permalink/latest/downloads/Cobalt.luau"))() end)
end, function() end)

-- [20] 🕵️ LOAD SIMPLESPY
CreateRusuhToggle("🕵️ Load SimpleSpy", function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))() end)
end, function() end)


-- ==========================================
-- 9️⃣ TOMBOL: LIKE & DISLIKE ALL (DUAL SPLIT BUTTON)
-- ==========================================
local DualVoteFrame = Instance.new("Frame", Container)
DualVoteFrame.Size = UDim2.new(1, 0, 0, 32)
DualVoteFrame.BackgroundTransparency = 1

local LikeBtn = Instance.new("TextButton", DualVoteFrame)
LikeBtn.Size = UDim2.new(0.48, 0, 1, 0)
LikeBtn.Position = UDim2.new(0, 0, 0, 0)
LikeBtn.BackgroundColor3 = Color3.fromRGB(30, 45, 30)
LikeBtn.Text = "👍 Like All"
LikeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LikeBtn.Font = Enum.Font.GothamBold
LikeBtn.TextSize = 12
Instance.new("UICorner", LikeBtn).CornerRadius = UDim.new(0, 6)

local LikeStroke = Instance.new("UIStroke", LikeBtn)
LikeStroke.Color = Color3.fromRGB(46, 204, 113)
LikeStroke.Thickness = 1.5

LikeBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        LikeStroke.Color = Color3.fromRGB(255, 255, 255)
        task.wait(0.2)
        LikeStroke.Color = Color3.fromRGB(46, 204, 113)
    end)
    local SubmitVote = ReplicatedStorage:FindFirstChild("ReputationRemotes") and ReplicatedStorage.ReputationRemotes:FindFirstChild("SubmitVote")
    if SubmitVote then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                task.spawn(function() pcall(function() SubmitVote:InvokeServer(player.UserId, "Like") end) end)
                task.wait(0.1)
            end
        end
    end
end)

local DislikeBtn = Instance.new("TextButton", DualVoteFrame)
DislikeBtn.Size = UDim2.new(0.48, 0, 1, 0)
DislikeBtn.Position = UDim2.new(0.52, 0, 0, 0)
DislikeBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 30)
DislikeBtn.Text = "👎 Dislike All"
DislikeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DislikeBtn.Font = Enum.Font.GothamBold
DislikeBtn.TextSize = 12
Instance.new("UICorner", DislikeBtn).CornerRadius = UDim.new(0, 6)

local DislikeStroke = Instance.new("UIStroke", DislikeBtn)
DislikeStroke.Color = Color3.fromRGB(231, 76, 60)
DislikeStroke.Thickness = 1.5

DislikeBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        DislikeStroke.Color = Color3.fromRGB(255, 255, 255)
        task.wait(0.2)
        DislikeStroke.Color = Color3.fromRGB(231, 76, 60)
    end)
    local SubmitVote = ReplicatedStorage:FindFirstChild("ReputationRemotes") and ReplicatedStorage.ReputationRemotes:FindFirstChild("SubmitVote")
    if SubmitVote then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                task.spawn(function() pcall(function() SubmitVote:InvokeServer(player.UserId, "Dislike") end) end)
                task.wait(0.1)
            end
        end
    end
end)
