-- LocalScript: Highlight (White), Nametag, Distance, Stamina
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Cấu hình màu sắc
local BOX_COLOR = Color3.fromRGB(255, 255, 255) -- Màu trắng
local TEXT_COLOR = Color3.fromRGB(255, 255, 255) -- Màu chữ trắng

-------------------------------------------------------------------
-- 1. HÀM TẠO VIỀN (HIGHLIGHT)
-------------------------------------------------------------------
local function createBoxHighlight(target)
    if target:FindFirstChild("SelectionBox") then return end

    local box = Instance.new("SelectionBox")
    box.Adornee = target
    box.Color3 = BOX_COLOR
    box.LineThickness = 0.05
    box.SurfaceTransparency = 1 -- Chỉ hiện viền
    box.AlwaysOnTop = true
    box.Parent = target
end

-------------------------------------------------------------------
-- 2. HÀM TẠO NAMETAG & KHOẢNG CÁCH
-------------------------------------------------------------------
local function createNametag(character, player)
    -- Tìm phần đầu để gắn tên vào
    local head = character:FindFirstChild("Head")
    if not head or head:FindFirstChild("ESPTag") then return end

    -- Tạo bảng tên (BillboardGui)
    local bgui = Instance.new("BillboardGui")
    bgui.Name = "ESPTag"
    bgui.Adornee = head
    bgui.Size = UDim2.new(0, 200, 0, 50)
    bgui.StudsOffset = Vector3.new(0, 3, 0) -- Treo cao hơn đầu 3 đơn vị
    bgui.AlwaysOnTop = true -- Luôn nhìn thấy xuyên tường

    local label = Instance.new("TextLabel")
    label.Parent = bgui
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.TextColor3 = TEXT_COLOR
    label.TextStrokeTransparency = 0 -- Viền chữ đen cho dễ đọc
    label.TextSize = 14
    label.Font = Enum.Font.SourceSansBold
    
    bgui.Parent = head

    -- Vòng lặp cập nhật khoảng cách liên tục
    local connection
    connection = RunService.RenderStepped:Connect(function()
        -- Kiểm tra nếu nhân vật hoặc bảng tên không còn tồn tại thì dừng cập nhật
        if not character or not character.Parent or not bgui.Parent then
            connection:Disconnect()
            return
        end

        -- Tính khoảng cách
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("HumanoidRootPart") then
            local myPos = LocalPlayer.Character.HumanoidRootPart.Position
            local targetPos = character.HumanoidRootPart.Position
            local distance = (myPos - targetPos).Magnitude
            
            -- Cập nhật nội dung: Tên [Khoảng cách]
            label.Text = player.Name .. "\n[" .. math.floor(distance) .. "m]"
        end
    end)
end

-------------------------------------------------------------------
-- 3. HÀM XỬ LÝ CHÍNH
-------------------------------------------------------------------
local function processPlayer(player)
    if player == LocalPlayer then return end

    local function onCharacterAdded(character)
        wait(1) -- Đợi nhân vật load xong
        
        -- Tạo viền cho từng bộ phận
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                createBoxHighlight(part)
            end
        end
        
        -- Tạo Nametag trên đầu
        createNametag(character, player)

        -- Nếu nhân vật mọc thêm bộ phận mới (ví dụ cầm súng), thêm viền luôn
        character.ChildAdded:Connect(function(child)
            if child:IsA("BasePart") then
                createBoxHighlight(child)
            end
        end)
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end

-- Chạy cho tất cả người chơi hiện tại
for _, player in pairs(Players:GetPlayers()) do
    processPlayer(player)
end

-- Chạy cho người chơi mới vào sau
Players.PlayerAdded:Connect(processPlayer)

-------------------------------------------------------------------
-- 4. PHẦN HACK THỂ LỰC (STAMINA)
-------------------------------------------------------------------
--[[
	WARNING: Heads up!
    This script has not been verified by ScriptBlox. Use at your own risk!
]]
local Sprinting = game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting
local stamina = require(Sprinting)
stamina.MaxStamina = 100 
stamina.MinStamina = -20 
stamina.StaminaGain = 100
stamina.StaminaLoss = 5
stamina.SprintSpeed = 30 
stamina.StaminaLossDisabled = true
