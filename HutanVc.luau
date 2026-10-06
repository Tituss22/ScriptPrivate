local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local whitelistURL = "https://raw.githubusercontent.com/Tituss22/ScriptPrivate/main/whitelist.json"
local success, result = pcall(function()
    return game:HttpGet(whitelistURL)
end)

if success then
    local whitelistData = HttpService:JSONDecode(result)
    if not whitelistData[player.Name] then
        if setclipboard then setclipboard('bintanganggara22._') end
        player:Kick("Script Berbayar! Beli di Discord: bintanganggara22._ (Username otomatis di-copy)")
        return
    end
else
    player:Kick("Gagal mengecek whitelist. Coba lagi nanti atau cek koneksi internet.")
    return
end

print("Akses Diterima. Selamat datang, " .. player.Name .. "!")

-- ====================================================================
-- 🌲 HUTAN VOICE CHAT - MINI PREMIUM HUB (V28 - GREEN THEME & CART FIX)
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local guiName = "HutanVC_MiniHub"
local camera = Workspace.CurrentCamera
local networkPaused

-- 📱 Deteksi Perangkat (PC atau HP) & Skala UI Dinamis
local isMobile = UserInputService.TouchEnabled

local MAIN_W = isMobile and 175 or 210
local MAIN_H = isMobile and 350 or 430
local SUB_W = isMobile and 220 or 270
local TITLE_SIZE = isMobile and 13 or 16
local TEXT_SIZE = isMobile and 10 or 12
local BTN_H = isMobile and 30 or 34

-- ==========================================
-- 🔄 SISTEM AUTO REJOIN CHAT (!rejoin) & QUEUE ON TELEPORT
-- ==========================================
local queue_on_teleport = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)
local AutoExecuteURL = "https://raw.githubusercontent.com/Tituss22/ScriptPrivate/refs/heads/main/HutanVc.luau" 

LocalPlayer.Chatted:Connect(function(msg)
    if string.lower(msg) == "!rejoin" then
        if queue_on_teleport and AutoExecuteURL ~= "https://raw.githubusercontent.com/Tituss22/ScriptPrivate/refs/heads/main/HutanVc.luau" then
            queue_on_teleport('loadstring(game:HttpGet("' .. AutoExecuteURL .. '"))()')
        end
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
    end
end)

-- 🧹 Bersihkan GUI Lama
pcall(function()
    if CoreGui:FindFirstChild(guiName) then CoreGui[guiName]:Destroy() end
    if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(guiName) then LocalPlayer.PlayerGui[guiName]:Destroy() end
end)

-- ==========================================
-- 💾 SISTEM CACHE GUI & DRAGGING SUPPORT HP/PC
-- ==========================================
local CacheFileName = "HutanVC_Cache.json"
local guiCache = { Visible = true, PosX = 0.5, OffsetX = -120, PosY = 0.2, OffsetY = 0 }

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

local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition = false, nil, nil, nil
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
        end
    end)
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then DragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local delta = input.Position - DragStart
            object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + delta.Y)
        end
    end)
end

-- ==========================================
-- 🛸 SMART TELEPORT (TERBAWA GEROBAK/KENDARAAN)
-- ==========================================
local function SmartTeleport(targetCFrame)
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")

        if hum and hum.Sit and hum.SeatPart then
            local seat = hum.SeatPart
            local vehModel = seat:FindFirstChildAncestorOfClass("Model") or seat.Parent
            
            if vehModel and vehModel:IsA("Model") then
                vehModel:PivotTo(targetCFrame)
            elseif seat.AssemblyRootPart then
                seat.AssemblyRootPart.CFrame = targetCFrame
            else
                seat.CFrame = targetCFrame
            end

            if seat.AssemblyRootPart then
                seat.AssemblyRootPart.AssemblyLinearVelocity = Vector3.zero
                seat.AssemblyRootPart.AssemblyAngularVelocity = Vector3.zero
            end
        else
            if hum then hum.Sit = false end
            if hrp then 
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
            task.wait(0.02)
            char:PivotTo(targetCFrame)
        end
    end)
end

-- ==========================================
-- 🎨 SETUP TAMPILAN UTAMA (PROPORSI DINAMIS)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, MAIN_W, 0, MAIN_H) 
MainFrame.Position = UDim2.new(guiCache.PosX, guiCache.OffsetX, guiCache.PosY, guiCache.OffsetY)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 16, 14)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = guiCache.Visible
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
MakeDraggable(MainFrame, MainFrame)

if isMobile then
    local ToggleBtn = Instance.new("TextButton", ScreenGui)
    ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
    ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(12, 16, 14)
    ToggleBtn.BackgroundTransparency = 0.15
    ToggleBtn.Text = "🌲"
    ToggleBtn.TextSize = 24
    ToggleBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
    ToggleStroke.Color = Color3.fromRGB(0, 255, 128)
    ToggleStroke.Thickness = 2
    MakeDraggable(ToggleBtn, ToggleBtn)

    ToggleBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)
end

local function SaveCache()
    pcall(function()
        if writefile then
            local data = { Visible = MainFrame.Visible, PosX = MainFrame.Position.X.Scale, OffsetX = MainFrame.Position.X.Offset, PosY = MainFrame.Position.Y.Scale, OffsetY = MainFrame.Position.Y.Offset }
            writefile(CacheFileName, HttpService:JSONEncode(data))
        end
    end)
end
task.spawn(function() while task.wait(5) do SaveCache() end end)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 255, 128)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 28)
Title.Position = UDim2.new(0, 0, 0, 6)
Title.BackgroundTransparency = 1
Title.Text = "🌲 HUTAN VC"
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = TITLE_SIZE

local F2Hint = Instance.new("TextLabel", MainFrame)
F2Hint.Size = UDim2.new(1, 0, 0, 14)
F2Hint.Position = UDim2.new(0, 0, 0, 28)
F2Hint.BackgroundTransparency = 1
F2Hint.Text = isMobile and "[ Tap Logo 🌲 untuk Hide ]" or "[ Tekan F2 untuk Hide/Show ]"
F2Hint.TextColor3 = Color3.fromRGB(160, 160, 160)
F2Hint.Font = Enum.Font.GothamSemibold
F2Hint.TextSize = isMobile and 9 or 10

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -16, 1, -50)
Container.Position = UDim2.new(0, 8, 0, 44)
Container.BackgroundTransparency = 1

local ContainerScroll = Instance.new("ScrollingFrame", Container)
ContainerScroll.Size = UDim2.new(1, 0, 1, 0)
ContainerScroll.BackgroundTransparency = 1
ContainerScroll.ScrollBarThickness = isMobile and 4 or 3
ContainerScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 128)
ContainerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContainerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local UIListLayout = Instance.new("UIListLayout", ContainerScroll)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6) 

local ContainerPadding = Instance.new("UIPadding", ContainerScroll)
ContainerPadding.PaddingTop = UDim.new(0, 2)
ContainerPadding.PaddingBottom = UDim.new(0, 10)
ContainerPadding.PaddingRight = UDim.new(0, 4)

local function CreateSubFrame(titleText, iconText)
    local Frame = Instance.new("Frame", MainFrame)
    Frame.Size = UDim2.new(0, SUB_W, 1, 0) 
    Frame.Position = UDim2.new(1, 10, 0, 0) 
    Frame.BackgroundColor3 = Color3.fromRGB(12, 16, 14)
    Frame.BackgroundTransparency = 0.1 
    Frame.BorderSizePixel = 0
    Frame.Visible = false
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = Color3.fromRGB(0, 255, 128)
    Stroke.Thickness = 1.5
    Stroke.Transparency = 0.2

    local TitleLbl = Instance.new("TextLabel", Frame)
    TitleLbl.Size = UDim2.new(1, 0, 0, 36)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = iconText .. " " .. titleText
    TitleLbl.TextColor3 = Color3.fromRGB(0, 255, 128)
    TitleLbl.Font = Enum.Font.GothamBlack
    TitleLbl.TextSize = TITLE_SIZE - 1

    local Scroll = Instance.new("ScrollingFrame", Frame)
    Scroll.Size = UDim2.new(1, -16, 1, -44)
    Scroll.Position = UDim2.new(0, 8, 0, 38)
    Scroll.BackgroundTransparency = 1
    Scroll.ScrollBarThickness = isMobile and 5 or 4
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 128)
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    Scroll.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable

    local List = Instance.new("UIListLayout", Scroll)
    List.Padding = UDim.new(0, 6)
    List.SortOrder = Enum.SortOrder.LayoutOrder

    local Padding = Instance.new("UIPadding", Scroll)
    Padding.PaddingTop = UDim.new(0, 2)
    Padding.PaddingBottom = UDim.new(0, 15)
    Padding.PaddingLeft = UDim.new(0, 2)
    Padding.PaddingRight = UDim.new(0, 6)

    return Frame, Scroll
end

local DecalFrame, ScrollFrame = CreateSubFrame("DECAL LIST", "🖼️")
local TpPlayerFrame, TpPlayerScroll = CreateSubFrame("TELEPORT PLAYER", "👤")
local ViewPlayerFrame, ViewPlayerScroll = CreateSubFrame("VIEW PLAYER", "👁️")
local TpMapFrame, TpMapScroll = CreateSubFrame("TELEPORT TEMPAT", "🗺️")
local RusuhFrame, RusuhScroll = CreateSubFrame("SCRIPT RUSUH", "💥")

-- Tambah Search Box Khusus
local function AddSearchBox(ParentFrame, ScrollUI)
    local SearchBox = Instance.new("TextBox", ParentFrame)
    SearchBox.Size = UDim2.new(1, -16, 0, 28)
    SearchBox.Position = UDim2.new(0, 8, 0, 34)
    SearchBox.BackgroundColor3 = Color3.fromRGB(20, 28, 22)
    SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.PlaceholderText = "🔍 Cari..."
    SearchBox.Font = Enum.Font.GothamSemibold
    SearchBox.TextSize = TEXT_SIZE
    SearchBox.ClearTextOnFocus = false
    Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 6)
    local SearchStroke = Instance.new("UIStroke", SearchBox)
    SearchStroke.Color = Color3.fromRGB(0, 255, 128)
    SearchStroke.Transparency = 0.4
    
    ScrollUI.Size = UDim2.new(1, -16, 1, -70)
    ScrollUI.Position = UDim2.new(0, 8, 0, 66)

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local search = string.lower(SearchBox.Text)
        for _, item in ipairs(ScrollUI:GetChildren()) do
            if item:IsA("Frame") and item:FindFirstChild("NameLabel") then
                local pName = string.lower(item.NameLabel.Text)
                item.Visible = string.find(pName, search) ~= nil
            end
        end
    end)
    return SearchBox
end

local TpSearchBox = AddSearchBox(TpPlayerFrame, TpPlayerScroll)
local ViewSearchBox = AddSearchBox(ViewPlayerFrame, ViewPlayerScroll)

-- ==========================================
-- ⌨️ SISTEM HOTKEY F2 (PC SAJA)
-- ==========================================
if not isMobile then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.F2 then
            MainFrame.Visible = not MainFrame.Visible
            SaveCache()
        end
    end)
end

-- ==========================================
-- 🛠️ FUNGSI BANTUAN DASAR & IY UTILS
-- ==========================================
local function getRoot(char, vfly)
    if vfly then
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.SeatPart then
            local veh = hum.SeatPart.Parent
            if veh:IsA("Model") then return veh.PrimaryPart or hum.SeatPart or veh:FindFirstChildWhichIsA("BasePart") else return hum.SeatPart end
        end
    end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function CloseAllSubMenus()
    DecalFrame.Visible = false; TpPlayerFrame.Visible = false; ViewPlayerFrame.Visible = false; TpMapFrame.Visible = false; RusuhFrame.Visible = false
end

local function CreateActionBtn(name, callback)
    local Btn = Instance.new("TextButton", ContainerScroll)
    Btn.Size = UDim2.new(1, 0, 0, BTN_H)
    Btn.BackgroundColor3 = Color3.fromRGB(24, 30, 28) 
    Btn.BackgroundTransparency = 0.1
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = TEXT_SIZE
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
    local Btn = Instance.new("TextButton", ContainerScroll)
    Btn.Size = UDim2.new(1, 0, 0, BTN_H)
    Btn.BackgroundColor3 = Color3.fromRGB(24, 30, 28) 
    Btn.BackgroundTransparency = 0.1
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = TEXT_SIZE
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
local isAutoRiding, isProcessingRide = false, false
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
                                        if not isMobile then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game) end
                                        task.wait(0.05)
                                        if not isMobile then VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game) end
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
local isSpammingPiano, spamConnection, spamTimer = false, nil, nil
local orderedKeys = { Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four, Enum.KeyCode.Five, Enum.KeyCode.Six, Enum.KeyCode.Seven, Enum.KeyCode.Eight, Enum.KeyCode.Nine, Enum.KeyCode.Zero, Enum.KeyCode.Q, Enum.KeyCode.W, Enum.KeyCode.E, Enum.KeyCode.R, Enum.KeyCode.T, Enum.KeyCode.Y, Enum.KeyCode.U, Enum.KeyCode.I, Enum.KeyCode.O, Enum.KeyCode.P, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.F, Enum.KeyCode.G, Enum.KeyCode.H, Enum.KeyCode.J, Enum.KeyCode.K, Enum.KeyCode.L, Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V, Enum.KeyCode.B, Enum.KeyCode.N, Enum.KeyCode.M }

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
                VirtualInputManager:SendKeyEvent(true, orderedKeys[i], false, game)
                VirtualInputManager:SendKeyEvent(false, orderedKeys[i], false, game)
            end
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
            for i = 1, #orderedKeys do
                VirtualInputManager:SendKeyEvent(true, orderedKeys[i], false, game)
                VirtualInputManager:SendKeyEvent(false, orderedKeys[i], false, game)
            end
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
        end)
        spamTimer = task.delay(30, function() if isSpammingPiano then stopSpamming() end end)
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

local decalIDs = { "97621188548063",  "73203534417430",  "134834185288415", "85200908630517", "103696008317336", "98665051722682",  "89005004083873", "124107644275720", "119362477766882", "135051539601314", "75286848578025", "93619525646230", "96469468149871", "95798757543814", "132520586948409", "76241030161216", "81900715746842", "123351582929503", "103862562885646", "125472981338673", "101577115252273", "92654835490452", "75581390378147", "18721138013", "119911430798876", "135868263388393", "124295306744173", "77031658616427", "122584664996512", "100820160309981", "118358344042339", "98241598594893", "124197521447164", "95998018122646", "83101670376944", "106900665401467", "93769479126128", "72356519867383", "130188260773892", "75715745507820", "90636433912832", "122417880275747", "116199329143461", "131918155427883", "107747751559949", "77235297674681", "125785962142006", "88925185923237", "121031801714770", "123863821313412", "75258599751318", "130821336565497", "100777130375279", "94562243135321", "122896214893586", "80948784549280", "93571970236375", "104793836558416", "77701784444891", "129407866418547", "129574778629018", "78301832119498", "80377728136837", "93685920524232", "98294813785358", "111993790294475", "114999584257625", "131785713219876", "120747655874184", "117851244155531", "113290406249263", "110657214265135", "94818765680364", "116447576635301", "122620216163757", "119017518926012", "139885028444737", "118155454007068", "72088247031696", "124437704839119", "138763434489459", "120483906657333", "135686248548999", "138312991524010", "89430489368537", "94578691852491", "117064019114437", "131197681382977", "73094648154127", "83998131998365", "79696264372605", "128730637019281", "102692069490375", "80301455005198", "78814293639570", "140258791380569", "115218437944820", "106613884674871", "108559261107558", "134941546524030", "81632053602904", "82598654137492", "82111470861232", "101355803904839", "103369820318730", "129249729676333", "87652966439602", "98128697330192", "94569400123709", "108542009792132", "131829119848102", "98794228258962", "84848623393188", "105376163872239", "130802932647826", "139492031192073", "120644962590316", "118737923041902", "96627428050713", "96244369908125", "83862224708780", "80293177331008", "79649109378991", "74972175454475" }

local function applyDecalToServer(decalId)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local decalSign = character:FindFirstChild("DecalSign") or LocalPlayer.Backpack:FindFirstChild("DecalSign")
    if decalSign and decalSign:FindFirstChild("UpdateSignImage") then
        decalSign.UpdateSignImage:FireServer(2, "rbxthumb://type=Asset&id=" .. decalId .. "&w=420&h=420")
    end
end

for _, decalId in ipairs(decalIDs) do
    local itemFrame = Instance.new("Frame", ScrollFrame)
    itemFrame.Size = UDim2.new(1, 0, 0, 48)
    itemFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 22)
    itemFrame.BackgroundTransparency = 0.4; itemFrame.BorderSizePixel = 0
    Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 6)
    
    local imgPreview = Instance.new("ImageLabel", itemFrame)
    imgPreview.Size = UDim2.new(0, 38, 0, 38); imgPreview.Position = UDim2.new(0, 5, 0, 5)
    imgPreview.Image = "rbxthumb://type=Asset&id=" .. decalId .. "&w=150&h=150"
    imgPreview.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", imgPreview).CornerRadius = UDim.new(0, 4)
    
    local idText = Instance.new("TextLabel", itemFrame)
    idText.Size = UDim2.new(1, -115, 1, 0); idText.Position = UDim2.new(0, 50, 0, 0)
    idText.BackgroundTransparency = 1; idText.Text = decalId
    idText.TextColor3 = Color3.fromRGB(220, 220, 220)
    idText.Font = Enum.Font.GothamSemibold; idText.TextSize = TEXT_SIZE; idText.TextXAlignment = Enum.TextXAlignment.Left
    
    local applyBtn = Instance.new("TextButton", itemFrame)
    applyBtn.Size = UDim2.new(0, 55, 0, 26); applyBtn.Position = UDim2.new(1, -60, 0, 11)
    applyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 128); applyBtn.Text = "APPLY"
    applyBtn.TextColor3 = Color3.fromRGB(25, 25, 25); applyBtn.Font = Enum.Font.GothamBold; applyBtn.TextSize = 10
    Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 4)
    applyBtn.MouseButton1Click:Connect(function() applyDecalToServer(decalId) end)
end

-- ==========================================
-- 5️⃣ MENU: TELEPORT & VIEW PLAYER
-- ==========================================
CreateActionBtn("👤 Teleport Player", function()
    local newState = not TpPlayerFrame.Visible; CloseAllSubMenus(); TpPlayerFrame.Visible = newState
    if TpPlayerFrame.Visible then
        TpSearchBox.Text = "" 
        for _, child in ipairs(TpPlayerScroll:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
        local allPlayers = Players:GetPlayers()
        for _, p in ipairs(allPlayers) do
            if p ~= LocalPlayer then
                local itemFrame = Instance.new("Frame", TpPlayerScroll)
                itemFrame.Size = UDim2.new(1, 0, 0, 48); itemFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 22)
                itemFrame.BackgroundTransparency = 0.4; itemFrame.BorderSizePixel = 0
                Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 6)
                
                local avatarImg = Instance.new("ImageLabel", itemFrame)
                avatarImg.Size = UDim2.new(0, 38, 0, 38); avatarImg.Position = UDim2.new(0, 5, 0, 5)
                avatarImg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                avatarImg.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
                Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(0, 4)
                
                local nameText = Instance.new("TextLabel", itemFrame)
                nameText.Name = "NameLabel"; nameText.Size = UDim2.new(1, -105, 1, 0); nameText.Position = UDim2.new(0, 48, 0, 0)
                nameText.BackgroundTransparency = 1; nameText.Text = p.DisplayName .. "\n(@" .. p.Name .. ")"
                nameText.TextColor3 = Color3.fromRGB(220, 220, 220); nameText.Font = Enum.Font.GothamSemibold
                nameText.TextSize = TEXT_SIZE - 1; nameText.TextXAlignment = Enum.TextXAlignment.Left; nameText.TextTruncate = Enum.TextTruncate.AtEnd
                
                local tpBtn = Instance.new("TextButton", itemFrame)
                tpBtn.Size = UDim2.new(0, 48, 0, 26); tpBtn.Position = UDim2.new(1, -53, 0, 11)
                tpBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 128); tpBtn.Text = "GO"
                tpBtn.TextColor3 = Color3.fromRGB(25, 25, 25); tpBtn.Font = Enum.Font.GothamBold; tpBtn.TextSize = 10
                Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 4)
                
                tpBtn.MouseButton1Click:Connect(function()
                    pcall(function()
                        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            SmartTeleport(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0))
                        end
                    end)
                end)
            end
        end
    end
end)

local viewing, viewDied = nil, nil
local function stopViewing()
    if viewDied then viewDied:Disconnect(); viewDied = nil end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end
    viewing = nil
end

CreateActionBtn("👁️ View Player", function()
    local newState = not ViewPlayerFrame.Visible; CloseAllSubMenus(); ViewPlayerFrame.Visible = newState
    if ViewPlayerFrame.Visible then
        ViewSearchBox.Text = "" 
        for _, child in ipairs(ViewPlayerScroll:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
        local allPlayers = Players:GetPlayers()
        
        local unviewFrame = Instance.new("Frame", ViewPlayerScroll)
        unviewFrame.Size = UDim2.new(1, 0, 0, 48); unviewFrame.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
        unviewFrame.BackgroundTransparency = 0.3; unviewFrame.BorderSizePixel = 0
        Instance.new("UICorner", unviewFrame).CornerRadius = UDim.new(0, 6)
        
        local unviewText = Instance.new("TextLabel", unviewFrame)
        unviewText.Size = UDim2.new(1, -65, 1, 0); unviewText.Position = UDim2.new(0, 10, 0, 0)
        unviewText.BackgroundTransparency = 1; unviewText.Text = "🛑 STOP VIEWING"
        unviewText.TextColor3 = Color3.fromRGB(255, 100, 100); unviewText.Font = Enum.Font.GothamBold; unviewText.TextSize = TEXT_SIZE; unviewText.TextXAlignment = Enum.TextXAlignment.Left
        
        local unviewBtn = Instance.new("TextButton", unviewFrame)
        unviewBtn.Size = UDim2.new(0, 50, 0, 26); unviewBtn.Position = UDim2.new(1, -55, 0, 11)
        unviewBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50); unviewBtn.Text = "RESET"
        unviewBtn.TextColor3 = Color3.fromRGB(255, 255, 255); unviewBtn.Font = Enum.Font.GothamBold; unviewBtn.TextSize = 9
        Instance.new("UICorner", unviewBtn).CornerRadius = UDim.new(0, 4)
        unviewBtn.MouseButton1Click:Connect(function() stopViewing() end)

        for _, p in ipairs(allPlayers) do
            if p ~= LocalPlayer then
                local itemFrame = Instance.new("Frame", ViewPlayerScroll)
                itemFrame.Size = UDim2.new(1, 0, 0, 48); itemFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 22); itemFrame.BackgroundTransparency = 0.4; itemFrame.BorderSizePixel = 0
                Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 6)
                
                local avatarImg = Instance.new("ImageLabel", itemFrame)
                avatarImg.Size = UDim2.new(0, 38, 0, 38); avatarImg.Position = UDim2.new(0, 5, 0, 5); avatarImg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                avatarImg.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
                Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(0, 4)
                
                local nameText = Instance.new("TextLabel", itemFrame)
                nameText.Name = "NameLabel"; nameText.Size = UDim2.new(1, -105, 1, 0); nameText.Position = UDim2.new(0, 48, 0, 0)
                nameText.BackgroundTransparency = 1; nameText.Text = p.DisplayName .. "\n(@" .. p.Name .. ")"
                nameText.TextColor3 = Color3.fromRGB(220, 220, 220); nameText.Font = Enum.Font.GothamSemibold; nameText.TextSize = TEXT_SIZE - 1; nameText.TextXAlignment = Enum.TextXAlignment.Left; nameText.TextTruncate = Enum.TextTruncate.AtEnd
                
                local viewBtn = Instance.new("TextButton", itemFrame)
                viewBtn.Size = UDim2.new(0, 48, 0, 26); viewBtn.Position = UDim2.new(1, -53, 0, 11)
                viewBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 128); viewBtn.Text = "VIEW"
                viewBtn.TextColor3 = Color3.fromRGB(25, 25, 25); viewBtn.Font = Enum.Font.GothamBold; viewBtn.TextSize = 9
                Instance.new("UICorner", viewBtn).CornerRadius = UDim.new(0, 4)
                
                viewBtn.MouseButton1Click:Connect(function()
                    pcall(function()
                        if p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
                            stopViewing(); viewing = p
                            camera.CameraSubject = viewing.Character:FindFirstChildOfClass("Humanoid")
                            viewDied = viewing.CharacterAdded:Connect(function(char) camera.CameraSubject = char:WaitForChild("Humanoid") end)
                        end
                    end)
                end)
            end
        end
    end
end)

-- ==========================================
-- 7️⃣ MENU: TELEPORT TEMPAT (MAP SCAN)
-- ==========================================
local customLocations = {
    {Name = "Piano Konser", Pos = Vector3.new(368.72, 81.69, -1215.09)}, {Name = "Tempat Nonton", Pos = Vector3.new(105.78, 51.79, -1336.48)}, {Name = "Rumah Ayam", Pos = Vector3.new(232.71, 89.03, -1425.92)}, {Name = "Rumah Pohon", Pos = Vector3.new(177.79, 202.66, -1233.27)}, {Name = "Tempat Santai", Pos = Vector3.new(-410.56, 71.72, -920.36)}, {Name = "Perosotan", Pos = Vector3.new(-292.41, 69.27, -1014.37)}, {Name = "Picnic", Pos = Vector3.new(-73.18, 69.52, -794.39)}, {Name = "Api Unggun", Pos = Vector3.new(-411.05, 67.31, -1354.28)}, {Name = "Papan Iklan", Pos = Vector3.new(-289.79, 95.66, -1496.83)}, {Name = "Jembatan", Pos = Vector3.new(-85.71, 33.66, -1133.45)}, {Name = "Hutan Premium", Pos = Vector3.new(510.88, 29.00, 2150.21)}, {Name = "Green House", Pos = Vector3.new(91.29, 69.35, -782.57)}, {Name = "Kereta Gantung", Pos = Vector3.new(-298.97, 122.74, -882.37)}, {Name = "Hutan Studio", Pos = Vector3.new(747.95, -28.22, -818.74)}, {Name = "Taman Bermain", Pos = Vector3.new(1662.64, 36.29, -4520.78)}, {Name = "Labirin", Pos = Vector3.new(-1340.41, 37.01, -3302.17)}, {Name = "Spawn 1", Pos = Vector3.new(-405.23, 54.18, -1201.44)}, {Name = "Spawn 2", Pos = Vector3.new(156.04, 41.64, -1062.81)}, {Name = "Isolasi Diri 1", Pos = Vector3.new(-771.97, 14.37, -417.99)}, {Name = "Isolasi Diri 2", Pos = Vector3.new(-418.76, 40.75, -920.55)}, {Name = "Carriage", Pos = Vector3.new(546.86, 7.48, 2101.28)}, {Name = "Leaderboard", Pos = Vector3.new(273.11, 63.31, -893.29)}, {Name = "Market Stall", Pos = Vector3.new(130.29, 73.11, -1569.60)}, {Name = "Booth System", Pos = Vector3.new(610.46, 45.01, -465.23)}
}

CreateActionBtn("🗺️ Teleport Tempat", function()
    local newState = not TpMapFrame.Visible; CloseAllSubMenus(); TpMapFrame.Visible = newState
    if TpMapFrame.Visible then
        for _, child in ipairs(TpMapScroll:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
        for i, loc in ipairs(customLocations) do
            local itemFrame = Instance.new("Frame", TpMapScroll)
            itemFrame.Size = UDim2.new(1, 0, 0, 42); itemFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 22); itemFrame.BackgroundTransparency = 0.4; itemFrame.BorderSizePixel = 0
            Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 6)
            
            local nameText = Instance.new("TextLabel", itemFrame)
            nameText.Size = UDim2.new(1, -60, 1, 0); nameText.Position = UDim2.new(0, 10, 0, 0)
            nameText.BackgroundTransparency = 1; nameText.Text = i .. ". " .. loc.Name
            nameText.TextColor3 = Color3.fromRGB(220, 220, 220); nameText.Font = Enum.Font.GothamSemibold; nameText.TextSize = TEXT_SIZE; nameText.TextXAlignment = Enum.TextXAlignment.Left
            
            local tpBtn = Instance.new("TextButton", itemFrame)
            tpBtn.Size = UDim2.new(0, 48, 0, 26); tpBtn.Position = UDim2.new(1, -53, 0, 8)
            tpBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 128); tpBtn.Text = "GO"
            tpBtn.TextColor3 = Color3.fromRGB(25, 25, 25); tpBtn.Font = Enum.Font.GothamBold; tpBtn.TextSize = 10
            Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 4)
            
            tpBtn.MouseButton1Click:Connect(function()
                SmartTeleport(CFrame.new(loc.Pos))
            end)
        end
    end
end)

-- ==========================================
-- 8️⃣ MENU: SCRIPT RUSUH PANEL (Warna Hijau & Fix Scroll)
-- ==========================================
CreateActionBtn("💥 Script Rusuh", function()
    local newState = not RusuhFrame.Visible; CloseAllSubMenus(); RusuhFrame.Visible = newState
end)

local function CreateRusuhToggle(name, onEnable, onDisable)
    local isActive = false
    local Btn = Instance.new("TextButton", RusuhScroll)
    Btn.Size = UDim2.new(1, 0, 0, BTN_H + 2)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 32, 28); Btn.Text = name .. " [OFF]"
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200); Btn.Font = Enum.Font.GothamBold; Btn.TextSize = TEXT_SIZE
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    local BtnStroke = Instance.new("UIStroke", Btn)
    BtnStroke.Color = Color3.fromRGB(0, 255, 128); BtnStroke.Thickness = 1.5; BtnStroke.Transparency = 0.3
    Btn.MouseButton1Click:Connect(function()
        isActive = not isActive
        if isActive then
            Btn.Text = name .. " [ON]"; Btn.TextColor3 = Color3.fromRGB(0, 255, 128)
            BtnStroke.Color = Color3.fromRGB(0, 255, 128); BtnStroke.Transparency = 0
            onEnable()
        else
            Btn.Text = name .. " [OFF]"; Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            BtnStroke.Color = Color3.fromRGB(0, 255, 128); BtnStroke.Transparency = 0.3
            onDisable()
        end
    end)
end

local function CreateRusuhButton(name, callback)
    local Btn = Instance.new("TextButton", RusuhScroll)
    Btn.Size = UDim2.new(1, 0, 0, BTN_H + 2)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 32, 28) 
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(0, 255, 128) 
    Btn.Font = Enum.Font.GothamBold; Btn.TextSize = TEXT_SIZE
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    local BtnStroke = Instance.new("UIStroke", Btn)
    BtnStroke.Color = Color3.fromRGB(0, 255, 128); BtnStroke.Thickness = 1.5; BtnStroke.Transparency = 0.3
    Btn.MouseButton1Click:Connect(function()
        task.spawn(function()
            BtnStroke.Color = Color3.fromRGB(255, 255, 255); Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            task.wait(0.2)
            BtnStroke.Color = Color3.fromRGB(0, 255, 128); Btn.TextColor3 = Color3.fromRGB(0, 255, 128)
        end)
        callback()
    end)
end

-- [1] 🕊️ FLY & [2] 🛸 VEHICLE FLY
local iyflyspeed, vehicleflyspeed = 10, 10
local FLYING, flyKeyDown, flyKeyUp = false, nil, nil

local function sFLY(vfly)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then repeat task.wait() until char:FindFirstChildOfClass("Humanoid"); humanoid = char:FindFirstChildOfClass("Humanoid") end

    if flyKeyDown then flyKeyDown:Disconnect() flyKeyDown = nil end
    if flyKeyUp then flyKeyUp:Disconnect() flyKeyUp = nil end

    local T = getRoot(char, vfly)
    if not T then return end

    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local SPEED = 0
    local curSpeed = vfly and vehicleflyspeed or iyflyspeed

    local function FLY()
        FLYING = true
        local BG = Instance.new('BodyGyro')
        local BV = Instance.new('BodyVelocity')
        BG.P = 9e4; BG.Parent = T; BV.Parent = T
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9); BG.CFrame = T.CFrame
        BV.Velocity = Vector3.new(0, 0, 0); BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)

        task.spawn(function()
            repeat task.wait()
                if not vfly and humanoid then humanoid.PlatformStand = true end

                if isMobile and humanoid then
                    local moveDir = humanoid.MoveDirection
                    if moveDir.Magnitude > 0 then
                        local camLookFlat = Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z).Unit
                        local camRightFlat = Vector3.new(camera.CFrame.RightVector.X, 0, camera.CFrame.RightVector.Z).Unit
                        local forwardAmt = moveDir:Dot(camLookFlat)
                        local rightAmt = moveDir:Dot(camRightFlat)
                        local finalVec = (camera.CFrame.LookVector * forwardAmt) + (camera.CFrame.RightVector * rightAmt)
                        
                        SPEED = curSpeed
                        BV.Velocity = finalVec.Unit * SPEED
                        BG.CFrame = camera.CFrame
                        continue
                    end
                end

                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then SPEED = curSpeed
                elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then SPEED = 0 end

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
            CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}; lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}; SPEED = 0
            BG:Destroy(); BV:Destroy()
            if humanoid then humanoid.PlatformStand = false end
        end)
    end

    flyKeyDown = UserInputService.InputBegan:Connect(function(input, proc)
        if proc then return end
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = curSpeed elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = -curSpeed elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = -curSpeed elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = curSpeed elseif input.KeyCode == Enum.KeyCode.E then CONTROL.Q = curSpeed * 2 elseif input.KeyCode == Enum.KeyCode.Q then CONTROL.E = -curSpeed * 2 end
    end)
    flyKeyUp = UserInputService.InputEnded:Connect(function(input, proc)
        if proc then return end
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0 elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0 elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0 elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0 elseif input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 0 elseif input.KeyCode == Enum.KeyCode.Q then CONTROL.E = 0 end
    end)
    FLY()
end

local function NOFLY()
    FLYING = false
    if flyKeyDown then flyKeyDown:Disconnect() flyKeyDown = nil end
    if flyKeyUp then flyKeyUp:Disconnect() flyKeyUp = nil end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false end
end

CreateRusuhToggle("🕊️ Fly", function() sFLY(false) end, function() NOFLY() end)
CreateRusuhToggle("🛸 Vehicle Fly", function() sFLY(true) end, function() NOFLY() end)

-- [3] 🛒 CART DRIVE (UNIVERSAL HOVER DENGAN FIX KAKI TENGGELAM)
local speed, cartTarget, cartBV, cartBG, cartConn = 50, nil, nil, nil, nil
local currentVel, isHoveringPlayer = Vector3.zero, false

local function getCart()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if hum and hum.SeatPart then
        local seat = hum.SeatPart
        return seat.AssemblyRootPart or (seat.Parent:IsA("Model") and seat.Parent.PrimaryPart) or seat
    end
    if hrp then return hrp end
    return nil
end

local function stopCartDrive()
    if cartConn then cartConn:Disconnect() cartConn = nil end
    if cartBV then cartBV:Destroy() cartBV = nil end
    if cartBG then cartBG:Destroy() cartBG = nil end
    if isHoveringPlayer then 
        pcall(function() 
            LocalPlayer.Character.Humanoid.PlatformStand = false 
            LocalPlayer.Character:PivotTo(LocalPlayer.Character:GetPivot() * CFrame.new(0, 2, 0))
        end)
        isHoveringPlayer = false 
    end
    cartTarget = nil; currentVel = Vector3.zero
end

local function startCartDrive()
    stopCartDrive()
    cartTarget = getCart()
    if not cartTarget then return end

    pcall(function() cartTarget.Anchored = false end)
    isHoveringPlayer = (cartTarget.Name == "HumanoidRootPart")
    
    if isHoveringPlayer then 
        pcall(function() 
            LocalPlayer.Character.Humanoid.PlatformStand = true 
            LocalPlayer.Character:PivotTo(LocalPlayer.Character:GetPivot() * CFrame.new(0, 3, 0))
        end) 
    end

    cartBV = Instance.new("BodyVelocity"); cartBV.MaxForce = Vector3.new(math.huge, 0, math.huge); cartBV.Velocity = Vector3.zero; cartBV.Parent = cartTarget
    cartBG = Instance.new("BodyGyro"); cartBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); cartBG.P = 8000; cartBG.D = 1000; cartBG.CFrame = cartTarget.CFrame; cartBG.Parent = cartTarget

    cartConn = RunService.PreSimulation:Connect(function(dt)
        if not cartTarget or not cartTarget.Parent then stopCartDrive() return end
        local cam = Workspace.CurrentCamera
        if not cam then return end

        local camLook = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
        if camLook.Magnitude > 0 then camLook = camLook.Unit end
        local camRight = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)
        if camRight.Magnitude > 0 then camRight = camRight.Unit end

        local moveDir = Vector3.zero
        
        if isMobile and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humDir = LocalPlayer.Character.Humanoid.MoveDirection
            if humDir.Magnitude > 0 then
                local forwardAmt = humDir:Dot(camLook)
                local rightAmt = humDir:Dot(camRight)
                moveDir = (camLook * forwardAmt) + (camRight * rightAmt)
            end
        else
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camLook end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camLook end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camRight end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camRight end
        end

        local targetVel = (moveDir.Magnitude > 0) and (moveDir.Unit * speed) or Vector3.zero
        currentVel = currentVel:Lerp(targetVel, math.min(dt * 4, 1))
        cartBV.Velocity = currentVel

        local isShiftLock = (UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
        local facing = isShiftLock and camLook or (moveDir.Magnitude > 0 and moveDir.Unit or nil)
        if facing then cartBG.CFrame = cartBG.CFrame:Lerp(CFrame.lookAt(cartTarget.Position, cartTarget.Position + facing), math.min(dt * 7, 1)) end
    end)
end

CreateRusuhToggle("🛒 Cart Drive", function() startCartDrive() end, function() stopCartDrive() end)

-- [4] 🌪️ WALKFLING
local walkflinging, walkflingDied, walkflingNoclip = false, nil, nil
CreateRusuhToggle("🌪️ WalkFling", function()
    walkflinging = true
    walkflingNoclip = RunService.Stepped:Connect(function()
        if LocalPlayer.Character then for _, part in next, LocalPlayer.Character:GetDescendants() do if part:IsA("BasePart") then part.CanCollide = false end end end
    end)
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then walkflingDied = char.Humanoid.Died:Connect(function() walkflinging = false end) end

    task.spawn(function()
        repeat
            RunService.Heartbeat:Wait()
            local character, root, vel = LocalPlayer.Character, getRoot(LocalPlayer.Character, false), nil
            local movel = 0.1
            while not (character and character.Parent and root and root.Parent) and walkflinging do
                RunService.Heartbeat:Wait(); character = LocalPlayer.Character; root = getRoot(character, false)
            end
            if not walkflinging then break end
            vel = root.Velocity; root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            if character and character.Parent and root and root.Parent then root.Velocity = vel end
            RunService.Stepped:Wait()
            if character and character.Parent and root and root.Parent then root.Velocity = vel + Vector3.new(0, movel, 0); movel = movel * -1 end
        until walkflinging == false
    end)
end, function()
    walkflinging = false
    if walkflingDied then walkflingDied:Disconnect() walkflingDied = nil end
    if walkflingNoclip then walkflingNoclip:Disconnect() walkflingNoclip = nil end
end)

-- [5] 💥 FLING
local flinging, flingDied, flingNoclip = false, nil, nil
CreateRusuhToggle("💥 Fling", function()
    flinging = true
    pcall(function()
        local char = LocalPlayer.Character
        local root = getRoot(char, false)
        if not root then return end
        for _, child in next, char:GetDescendants() do
            if child:IsA("BasePart") then child.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5); child.Massless = true; child.Velocity = Vector3.zero end
        end
        task.wait(0.1)
        local bambam = Instance.new("BodyAngularVelocity"); bambam.Name = "IYFlingVel"; bambam.Parent = root; bambam.AngularVelocity = Vector3.new(0, 99999, 0); bambam.MaxTorque = Vector3.new(0, math.huge, 0); bambam.P = math.huge
        flingNoclip = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then for _, part in next, LocalPlayer.Character:GetDescendants() do if part:IsA("BasePart") then part.CanCollide = false end end end
        end)
        if char:FindFirstChildOfClass("Humanoid") then flingDied = char:FindFirstChildOfClass("Humanoid").Died:Connect(function() flinging = false end) end
        task.spawn(function()
            repeat bambam.AngularVelocity = Vector3.new(0, 99999, 0); task.wait(0.2); bambam.AngularVelocity = Vector3.new(0, 0, 0); task.wait(0.1) until flinging == false
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
                if v:IsA("BasePart") then v.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5); v.Massless = false; v.Velocity = Vector3.zero
                elseif v:IsA("BodyAngularVelocity") and v.Name == "IYFlingVel" then v:Destroy() end
            end
        end
    end)
end)

-- [6] 🛡️ ANTI-FLING (SISTEM PROTEKSI GANDA KEBAL TOTAL)
local antiFlingConn1, antiFlingConn2
CreateRusuhToggle("🛡️ Anti-Fling", function()
    if antiFlingConn1 then antiFlingConn1:Disconnect() end
    if antiFlingConn2 then antiFlingConn2:Disconnect() end

    antiFlingConn1 = RunService.Stepped:Connect(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                for _, v in ipairs(p.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                        v.AssemblyLinearVelocity = Vector3.zero
                        v.AssemblyAngularVelocity = Vector3.zero
                    end
                end
            end
        end
    end)

    antiFlingConn2 = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if hrp.AssemblyLinearVelocity.Magnitude > 100 then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                end
                if hrp.AssemblyAngularVelocity.Magnitude > 100 then
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end
    end)
end, function()
    if antiFlingConn1 then antiFlingConn1:Disconnect(); antiFlingConn1 = nil end
    if antiFlingConn2 then antiFlingConn2:Disconnect(); antiFlingConn2 = nil end
end)

-- [7] 👻 INVISIBLE (STABIL, -25 STUDS, ANTI HILANG GUI)
local invisibleActive, realCharacter, fakeCharacter, invisConnection, fakeCharDied = false, nil, nil, nil, nil
local originalTransparencies = {}

local function stopInvisible()
    if not invisibleActive then return end
    invisibleActive = false
    if invisConnection then invisConnection:Disconnect() invisConnection = nil end
    if fakeCharDied then fakeCharDied:Disconnect() fakeCharDied = nil end
    
    if realCharacter and realCharacter.Parent and fakeCharacter and fakeCharacter.Parent then
        local realHRP = realCharacter:FindFirstChild("HumanoidRootPart")
        local fakeHRP = fakeCharacter:FindFirstChild("HumanoidRootPart")
        if realHRP and fakeHRP then realHRP.CFrame = fakeHRP.CFrame end
        for v, orig in pairs(originalTransparencies) do if v and v.Parent then v.Transparency = orig end end
        if realCharacter:FindFirstChildOfClass("Humanoid") then realCharacter:FindFirstChildOfClass("Humanoid").PlatformStand = false end
    end
    if fakeCharacter then fakeCharacter:Destroy() fakeCharacter = nil end
    LocalPlayer.Character = realCharacter
    if realCharacter then workspace.CurrentCamera.CameraSubject = realCharacter:FindFirstChildOfClass("Humanoid") end
    originalTransparencies = {}
end

CreateRusuhToggle("👻 Invisible (Ghost)", function()
    if invisibleActive then return end
    invisibleActive = true
    realCharacter = LocalPlayer.Character
    if not realCharacter or not realCharacter:FindFirstChild("HumanoidRootPart") then invisibleActive = false return end
    
    for _, gui in pairs(LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do
        if gui:IsA("ScreenGui") then gui.ResetOnSpawn = false end
    end
    
    realCharacter.Archivable = true
    fakeCharacter = realCharacter:Clone()
    fakeCharacter.Name = LocalPlayer.Name .. "_Fake"; fakeCharacter.Parent = workspace
    
    for _, v in pairs(fakeCharacter:GetDescendants()) do if (v:IsA("BasePart") or v:IsA("Decal")) and v.Name ~= "HumanoidRootPart" then v.Transparency = 0.5 end end
    
    originalTransparencies = {}
    for _, v in pairs(realCharacter:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then
            originalTransparencies[v] = v.Transparency
            if v.Name ~= "HumanoidRootPart" then v.Transparency = 1 end
        end
    end
    
    LocalPlayer.Character = fakeCharacter
    workspace.CurrentCamera.CameraSubject = fakeCharacter:FindFirstChildOfClass("Humanoid")
    
    local fakeHum = fakeCharacter:FindFirstChildOfClass("Humanoid")
    if fakeHum then fakeCharDied = fakeHum.Died:Connect(function() if invisibleActive then stopInvisible() end end) end
    
    invisConnection = RunService.Stepped:Connect(function()
        if invisibleActive and realCharacter and realCharacter.Parent and fakeCharacter and fakeCharacter.Parent then
            local realHRP, fakeHRP = realCharacter:FindFirstChild("HumanoidRootPart"), fakeCharacter:FindFirstChild("HumanoidRootPart")
            if realHRP and fakeHRP then
                for _, v in pairs(realCharacter:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
                if realCharacter:FindFirstChildOfClass("Humanoid") then realCharacter:FindFirstChildOfClass("Humanoid").PlatformStand = true end
                
                realHRP.CFrame = fakeHRP.CFrame * CFrame.new(0, -25, 0)
                realHRP.Velocity = Vector3.zero
            end
        else
            if invisibleActive then stopInvisible() end
        end
    end)
end, function() stopInvisible() end)

-- [8] 🖱️ CTRL + CLICK TP (INSTANT SNAP) / HP TAP TP
local clickTpConn, tpTool, mouse = nil, nil, LocalPlayer:GetMouse()
CreateRusuhToggle("🖱️ Click / Tap TP", function()
    if isMobile then
        tpTool = Instance.new("Tool"); tpTool.Name = "🖱️ Mobile TP"; tpTool.RequiresHandle = false; tpTool.Parent = LocalPlayer.Backpack
        clickTpConn = tpTool.Activated:Connect(function()
            if mouse.Hit then SmartTeleport(mouse.Hit * CFrame.new(0, 3, 0)) end
        end)
    else
        clickTpConn = mouse.Button1Down:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and mouse.Hit then
                SmartTeleport(mouse.Hit * CFrame.new(0, 3, 0))
            end
        end)
    end
end, function()
    if clickTpConn then clickTpConn:Disconnect() end
    if tpTool then tpTool:Destroy() tpTool = nil end
end)

-- [9] 🔍 INFINITE ZOOM
CreateRusuhToggle("🔍 Infinite Zoom", function() pcall(function() LocalPlayer.CameraMaxZoomDistance = 999999 end) end, function() pcall(function() LocalPlayer.CameraMaxZoomDistance = 400 end) end)

-- [10] 🗑️ DELETE PREMIUM (TEMA HIJAU)
CreateRusuhButton("🗑️ Delete Premium", function()
    local toDelete = {
        workspace:FindFirstChild("Border") and workspace.Border:FindFirstChild("Garden") and workspace.Border.Garden:FindFirstChild("PremiumDetection"),
        workspace:FindFirstChild("GP Door"),
        workspace:FindFirstChild("GP Door2"),
        workspace:FindFirstChild("GP Door Garden"),
        workspace:FindFirstChild("GreenHouse") and workspace.GreenHouse:FindFirstChild("Gamepass"),
        workspace:FindFirstChild("GreenHouse") and workspace.GreenHouse:FindFirstChild("PremiumDetection"),
        workspace:FindFirstChild("Canopy Ride") and workspace["Canopy Ride"]:FindFirstChild("Canopy Platform")
    }
    
    for _, obj in pairs(toDelete) do
        if obj then pcall(function() obj:Destroy() end) end
    end
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "PremiumDetection" or obj.Name == "GP Canopy" or obj.Name == "Gamepass" then
            pcall(function() obj:Destroy() end)
        end
    end
end)

-- [11] 💤 ANTI AFK
local antiAfk
CreateRusuhToggle("💤 Anti AFK", function()
    local vu = game:GetService("VirtualUser")
    antiAfk = LocalPlayer.Idled:Connect(function() vu:Button2Down(Vector2.new(0,0), camera.CFrame); task.wait(1); vu:Button2Up(Vector2.new(0,0), camera.CFrame) end)
end, function() if antiAfk then antiAfk:Disconnect() antiAfk = nil end end)

-- [12] 👻 NOCLIP
local noclipConnection
CreateRusuhToggle("👻 Noclip", function()
    noclipConnection = RunService.Stepped:Connect(function()
        if LocalPlayer.Character then for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end end end
    end)
end, function() if noclipConnection then noclipConnection:Disconnect() end end)

-- [13] 🌀 SPIN KARAKTER
local spinVel
CreateRusuhToggle("🌀 Spin Karakter", function()
    local char = LocalPlayer.Character
    if char and getRoot(char, false) then
        spinVel = Instance.new("BodyAngularVelocity"); spinVel.Name = "SpinVelocity"; spinVel.Parent = getRoot(char, false)
        spinVel.MaxTorque = Vector3.new(0, math.huge, 0); spinVel.AngularVelocity = Vector3.new(0, 50, 0)
    end
end, function()
    if spinVel then spinVel:Destroy() end
    pcall(function() if LocalPlayer.Character and getRoot(LocalPlayer.Character, false) then for _, v in pairs(getRoot(LocalPlayer.Character, false):GetChildren()) do if v.Name == "SpinVelocity" then v:Destroy() end end end end)
end)

-- [14] 🚫 CLIENT ANTI-KICK
local antiKickEnabled, antiKickHooked = false, false
local function initAntiKickHook()
    if antiKickHooked or not hookmetamethod then return end; antiKickHooked = true
    local oldNamecall; oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
        local method = getnamecallmethod and getnamecallmethod() or ""
        if antiKickEnabled and select(1, ...) == LocalPlayer and (method == "Kick" or method == "kick") then return nil end
        return oldNamecall(...)
    end))
    if hookfunction then
        local oldKick; oldKick = hookfunction(LocalPlayer.Kick, newcclosure(function(self, ...)
            if antiKickEnabled and self == LocalPlayer then return nil end
            return oldKick(self, ...)
        end))
    end
end
CreateRusuhToggle("🚫 Client Anti-Kick", function() antiKickEnabled = true; initAntiKickHook() end, function() antiKickEnabled = false end)

-- [15] ⏸️ ANTI PAUSE UI
CreateRusuhToggle("⏸️ Anti Pause UI", function()
    pcall(function()
        if networkPaused then networkPaused:Disconnect() end
        local robloxGui = CoreGui:FindFirstChild("RobloxGui")
        if robloxGui then
            networkPaused = robloxGui.ChildAdded:Connect(function(obj) if obj.Name == "CoreScripts/NetworkPause" then obj:Destroy() end end)
            if robloxGui:FindFirstChild("CoreScripts/NetworkPause") then robloxGui["CoreScripts/NetworkPause"]:Destroy() end
        end
    end)
end, function() pcall(function() if networkPaused then networkPaused:Disconnect() networkPaused = nil end end) end)

-- [16] 🦘 INFINITE JUMP
local infJumpConn
CreateRusuhToggle("🦘 Infinite Jump", function() infJumpConn = UserInputService.JumpRequest:Connect(function() pcall(function() LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end) end, function() if infJumpConn then infJumpConn:Disconnect() end end)

-- [17] ⚡ SPEED 300
local speedActive = false
CreateRusuhToggle("⚡ Speed 300", function()
    speedActive = true
    task.spawn(function() while speedActive do pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 300 end); task.wait(0.5) end end)
end, function() speedActive = false; pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end) end)

-- [18] 👁️ ESP PLAYERS
local espActive, espElements = false, {}
CreateRusuhToggle("👁️ ESP Players", function()
    espActive = true
    task.spawn(function()
        while espActive do
            pcall(function()
                local myChar = LocalPlayer.Character; local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
                        local char, hrp = p.Character, p.Character.HumanoidRootPart
                        local head, humanoid = char:FindFirstChild("Head") or hrp, char.Humanoid
                        local highlight = char:FindFirstChild("ESPHighlight")
                        if not highlight then
                            highlight = Instance.new("Highlight"); highlight.Name = "ESPHighlight"
                            highlight.FillColor = Color3.fromRGB(255, 255, 255); highlight.FillTransparency = 0.4; highlight.OutlineColor = Color3.fromRGB(255, 255, 255); highlight.OutlineTransparency = 0
                            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; highlight.Adornee = char; highlight.Parent = char
                            table.insert(espElements, highlight)
                        end
                        local billboard = head:FindFirstChild("ESPText")
                        if not billboard then
                            billboard = Instance.new("BillboardGui"); billboard.Name = "ESPText"; billboard.Size = UDim2.new(0, 250, 0, 30); billboard.StudsOffset = Vector3.new(0, 3, 0); billboard.AlwaysOnTop = true
                            local label = Instance.new("TextLabel"); label.Name = "InfoLabel"; label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1
                            label.TextColor3 = Color3.fromRGB(255, 255, 255); label.TextStrokeTransparency = 0; label.TextSize = 14; label.Font = Enum.Font.SourceSansBold; label.Parent = billboard
                            billboard.Adornee = head; billboard.Parent = head
                            table.insert(espElements, billboard)
                        end
                        if billboard and billboard:FindFirstChild("InfoLabel") then
                            local distance = 0
                            if myHrp then distance = math.floor((hrp.Position - myHrp.Position).Magnitude) end
                            billboard.InfoLabel.Text = string.format("Name: %s | Health: %d | Studs: %d", p.Name, math.floor(humanoid.Health), distance)
                        end
                    end
                end
            end)
            task.wait(0.1) 
        end
    end)
end, function()
    espActive = false
    for _, elem in ipairs(espElements) do if elem then elem:Destroy() end end
    table.clear(espElements)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            if p.Character:FindFirstChild("ESPHighlight") then p.Character.ESPHighlight:Destroy() end
            if p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("ESPText") then p.Character.Head.ESPText:Destroy() end
        end
    end
end)

-- [19, 20, 21] ⚙️ LOAD SCRIPTS EXTERNAL
CreateRusuhToggle("📜 Load MoonDex", function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end) end, function() end)
CreateRusuhToggle("🚦 Load RemoteSpy", function() pcall(function() loadstring(game:HttpGet("https://gitlab.com/upio/cobalt/-/releases/permalink/latest/downloads/Cobalt.luau"))() end) end, function() end)
CreateRusuhToggle("🕵️ Load SimpleSpy", function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))() end) end, function() end)

-- ==========================================
-- 9️⃣ TOMBOL: LIKE & DISLIKE ALL (DUAL SPLIT BUTTON)
-- ==========================================
local DualVoteFrame = Instance.new("Frame", ContainerScroll)
DualVoteFrame.Size = UDim2.new(1, 0, 0, BTN_H); DualVoteFrame.BackgroundTransparency = 1

local LikeBtn = Instance.new("TextButton", DualVoteFrame)
LikeBtn.Size = UDim2.new(0.48, 0, 1, 0); LikeBtn.Position = UDim2.new(0, 0, 0, 0)
LikeBtn.BackgroundColor3 = Color3.fromRGB(25, 40, 28); LikeBtn.Text = "👍 Like All"
LikeBtn.TextColor3 = Color3.fromRGB(255, 255, 255); LikeBtn.Font = Enum.Font.GothamBold; LikeBtn.TextSize = TEXT_SIZE
Instance.new("UICorner", LikeBtn).CornerRadius = UDim.new(0, 6)
local LikeStroke = Instance.new("UIStroke", LikeBtn); LikeStroke.Color = Color3.fromRGB(46, 204, 113); LikeStroke.Thickness = 1.5

LikeBtn.MouseButton1Click:Connect(function()
    task.spawn(function() LikeStroke.Color = Color3.fromRGB(255, 255, 255); task.wait(0.2); LikeStroke.Color = Color3.fromRGB(46, 204, 113) end)
    local SubmitVote = ReplicatedStorage:FindFirstChild("ReputationRemotes") and ReplicatedStorage.ReputationRemotes:FindFirstChild("SubmitVote")
    if SubmitVote then
        for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then task.spawn(function() pcall(function() SubmitVote:InvokeServer(p.UserId, "Like") end) end); task.wait(0.1) end end
    end
end)

local DislikeBtn = Instance.new("TextButton", DualVoteFrame)
DislikeBtn.Size = UDim2.new(0.48, 0, 1, 0); DislikeBtn.Position = UDim2.new(0.52, 0, 0, 0)
DislikeBtn.BackgroundColor3 = Color3.fromRGB(40, 25, 28); DislikeBtn.Text = "👎 Dislike All"
DislikeBtn.TextColor3 = Color3.fromRGB(255, 255, 255); DislikeBtn.Font = Enum.Font.GothamBold; DislikeBtn.TextSize = TEXT_SIZE
Instance.new("UICorner", DislikeBtn).CornerRadius = UDim.new(0, 6)
local DislikeStroke = Instance.new("UIStroke", DislikeBtn); DislikeStroke.Color = Color3.fromRGB(231, 76, 60); DislikeStroke.Thickness = 1.5

DislikeBtn.MouseButton1Click:Connect(function()
    task.spawn(function() DislikeStroke.Color = Color3.fromRGB(255, 255, 255); task.wait(0.2); DislikeStroke.Color = Color3.fromRGB(231, 76, 60) end)
    local SubmitVote = ReplicatedStorage:FindFirstChild("ReputationRemotes") and ReplicatedStorage.ReputationRemotes:FindFirstChild("SubmitVote")
    if SubmitVote then
        for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then task.spawn(function() pcall(function() SubmitVote:InvokeServer(p.UserId, "Dislike") end) end); task.wait(0.1) end end
    end
end)
