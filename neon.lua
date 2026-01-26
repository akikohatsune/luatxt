-- Script đã được sửa chữa và gộp tính năng
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Cấu hình
local CONFIG = {
    BoxColor = Color3.fromRGB(255, 255, 255), -- Màu trắng (White)
    TextColor = Color3.fromRGB(255, 255, 255), -- Chữ màu trắng
    TextSize = 14
}

-------------------------------------------------------------------
-- PHẦN 1: ESP (BOX VIỀN + TÊN + KHOẢNG CÁCH)
-------------------------------------------------------------------
local function createESP(player)
    if player == LocalPlayer then return end

    local function applyVisuals(character)
        -- Đợi 1 chút để nhân vật load hết
        if not character:FindFirstChild("Head") then character:WaitForChild("Head", 5) end
        if not character:FindFirstChild("HumanoidRootPart") then character:WaitForChild("HumanoidRootPart", 5) end

        -- 1. Tạo Khung Viền Trắng (Thay thế BoxHandleAdornment cũ)
        if not character:FindFirstChild("ESP_Box") then
            local box = Instance.new("SelectionBox")
            box.Name = "ESP_Box"
            box.Adornee = character
            box.Color3 = CONFIG.BoxColor
            box.LineThickness = 0.04
            box.SurfaceTransparency = 1 -- Chỉ hiện viền, không hiện mặt
            box.AlwaysOnTop = true
            box.Parent = character
        end

        -- 2. Tạo Nametag + Khoảng cách (Tham khảo logic từ file esp.lua)
        local head = character:FindFirstChild("Head")
        if head and not head:FindFirstChild("ESP_Tag") then
            local bgui = Instance.new("BillboardGui")
            bgui.Name = "ESP_Tag"
            bgui.Adornee = head
            bgui.Size = UDim2.new(0, 200, 0, 50)
            bgui.StudsOffset = Vector3.new(0, 3, 0) -- Treo cao trên đầu
            bgui.AlwaysOnTop = true

            local label = Instance.new("TextLabel")
            label.Parent = bgui
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 1, 0)
            label.TextColor3 = CONFIG.TextColor
            label.TextStrokeTransparency = 0 -- Viền chữ đen cho dễ đọc
            label.TextSize = CONFIG.TextSize
            label.Font = Enum.Font.SourceSansBold
            
            bgui.Parent = head

            -- Cập nhật khoảng cách liên tục
            RunService.RenderStepped:Connect(function()
                if not character or not character.Parent or not bgui.Parent then return end
                
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                    -- Hiển thị: Tên [Số mét]
                    label.Text = string.format("%s\n[%dm]", player.DisplayName, math.floor(dist))
                else
                    label.Text = player.DisplayName
                end
            end)
        end
    end

    if player.Character then
        applyVisuals(player.Character)
    end

    player.CharacterAdded:Connect(function(char)
        applyVisuals(char)
    end)
end

-- Chạy cho tất cả người chơi
for _, p in pairs(Players:GetPlayers()) do
    createESP(p)
end
Players.PlayerAdded:Connect(createESP)

-------------------------------------------------------------------
-- PHẦN 2: HACK THỂ LỰC (STAMINA) - ĐÃ SỬA LỖI
-------------------------------------------------------------------
-- Phần này hay gây lỗi nếu game không có đúng đường dẫn, tôi đã thêm pcall để nó không làm hỏng script ESP
task.spawn(function()
    pcall(function()
        -- Code gốc của bạn 
        local Sprinting = game:GetService("ReplicatedStorage"):WaitForChild("Systems", 2):WaitForChild("Character", 2):WaitForChild("Game", 2):WaitForChild("Sprinting", 2)
        
        if Sprinting then
            local stamina = require(Sprinting)
            stamina.MaxStamina = 100 
            stamina.MinStamina = -20 
            stamina.StaminaGain = 100
            stamina.StaminaLoss = 0 -- Chỉnh về 0 để chạy không mất sức
            stamina.SprintSpeed = 35 
            stamina.StaminaLossDisabled = true
            print(">>> Hack Thể Lực: Thành công!")
        else
            warn(">>> Hack Thể Lực: Không tìm thấy file game, bỏ qua.")
        end
    end)
end)

print(">>> Script đã chạy xong!")
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
