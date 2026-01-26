-- LocalScript: Safe Mode (ESP + Stamina tách biệt)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

print(">>> SCRIPT ĐANG KHỞI ĐỘNG...") -- Kiểm tra xem script có chạy dòng đầu không

-- Cấu hình
local CONFIG = {
    BoxColor = Color3.fromRGB(255, 255, 255), -- Màu trắng
    TextColor = Color3.fromRGB(255, 255, 255),
    ShowDistance = true,
    FontSize = 14
}

-------------------------------------------------------------------
-- PHẦN 1: ESP (NHÌN XUYÊN TƯỜNG & NAMETAG)
-------------------------------------------------------------------
task.spawn(function() -- Chạy luồng riêng để không bị ảnh hưởng bởi lỗi khác
    local function createVisuals(target)
        if target:FindFirstChild("MyESPBox") then return end

        -- 1. Tạo Khung Viền (Outline)
        local box = Instance.new("SelectionBox")
        box.Name = "MyESPBox"
        box.Adornee = target
        box.Color3 = CONFIG.BoxColor
        box.LineThickness = 0.05
        box.SurfaceTransparency = 1
        box.AlwaysOnTop = true
        box.Parent = target
    end

    local function createNametag(character, player)
        local head = character:FindFirstChild("Head")
        if not head or head:FindFirstChild("MyESPTag") then return end

        -- 2. Tạo Bảng Tên
        local bgui = Instance.new("BillboardGui")
        bgui.Name = "MyESPTag"
        bgui.Adornee = head
        bgui.Size = UDim2.new(0, 200, 0, 50)
        bgui.StudsOffset = Vector3.new(0, 3.5, 0)
        bgui.AlwaysOnTop = true

        local label = Instance.new("TextLabel")
        label.Parent = bgui
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.TextColor3 = CONFIG.TextColor
        label.TextStrokeTransparency = 0
        label.TextSize = CONFIG.FontSize
        label.Font = Enum.Font.SourceSansBold
        label.Text = player.Name
        
        bgui.Parent = head

        -- Cập nhật khoảng cách liên tục
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not character or not character.Parent or not bgui.Parent then
                connection:Disconnect()
                return
            end

            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("HumanoidRootPart") then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                label.Text = string.format("%s\n[%dm]", player.Name, math.floor(dist))
            end
        end)
    end

    local function setupPlayer(player)
        if player == LocalPlayer then return end

        local function charAdded(char)
            wait(1) -- Đợi load model
            
            -- Tạo viền cho các bộ phận
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then createVisuals(part) end
            end
            
            -- Tạo tên
            createNametag(char, player)

            -- Xử lý khi có bộ phận mới (ví dụ cầm súng)
            char.ChildAdded:Connect(function(child)
                if child:IsA("BasePart") then createVisuals(child) end
            end)
        end

        if player.Character then charAdded(player.Character) end
        player.CharacterAdded:Connect(charAdded)
    end

    -- Kích hoạt cho toàn bộ server
    for _, p in pairs(Players:GetPlayers()) do setupPlayer(p) end
    Players.PlayerAdded:Connect(setupPlayer)
    
    print(">>> ESP (NHÌN XUYÊN TƯỜNG) ĐÃ BẬT THÀNH CÔNG!")
end)

-------------------------------------------------------------------
-- PHẦN 2: HACK THỂ LỰC (Được bọc trong pcall để không làm hỏng script)
-------------------------------------------------------------------
task.spawn(function()
    -- pcall giúp script không bị dừng nếu game không có stamina
    local success, err = pcall(function()
        -- Đường dẫn này RẤT DỄ LỖI nếu không đúng game
        local path = ReplicatedStorage:WaitForChild("Systems", 2):WaitForChild("Character", 2):WaitForChild("Game", 2):WaitForChild("Sprinting", 2)
        
        if path then
            local stamina = require(path)
            if stamina then
                stamina.MaxStamina = 100 
                stamina.MinStamina = -20 
                stamina.StaminaGain = 100
                stamina.StaminaLoss = 0 -- Chỉnh về 0 để không mất thể lực
                stamina.SprintSpeed = 35 
                stamina.StaminaLossDisabled = true
                print(">>> HACK THỂ LỰC: THÀNH CÔNG!")
            end
        else
            warn(">>> HACK THỂ LỰC: Không tìm thấy file game. Có thể game này không hỗ trợ.")
        end
    end)

    if not success then
        warn(">>> HACK THỂ LỰC THẤT BẠI (Lỗi đường dẫn game):", err)
        print(">>> Đừng lo, ESP vẫn hoạt động bình thường.")
    end
end)
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
