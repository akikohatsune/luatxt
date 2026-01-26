-- Script ESP Optimized cho Delta (Mobile/PC)
-- Tính năng: Viền Trắng + Tên + Khoảng Cách + Hack Stamina

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Cấu hình
local SETTINGS = {
    BoxColor = Color3.fromRGB(255, 255, 255), -- Màu trắng
    TextColor = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    ShowDistance = true
}

-------------------------------------------------------------------
-- PHẦN 1: ESP AN TOÀN CHO DELTA
-------------------------------------------------------------------
local function createESP(player)
    if player == LocalPlayer then return end

    local function applyVisuals(character)
        if not character then return end
        
        -- Đợi nạp nhân vật
        task.wait(0.5)
        local head = character:FindFirstChild("Head")
        local root = character:FindFirstChild("HumanoidRootPart")
        
        if not head or not root then return end

        -- 1. TẠO VIỀN (Dùng Highlight thay vì SelectionBox để mượt hơn trên Mobile)
        -- Nếu muốn dùng SelectionBox như cũ thì báo mình, nhưng Highlight đẹp hơn
        if not character:FindFirstChild("DeltaESP_Highlight") then
            local hl = Instance.new("Highlight")
            hl.Name = "DeltaESP_Highlight"
            hl.Adornee = character
            hl.FillTransparency = 1 -- Trong suốt bên trong
            hl.OutlineColor = SETTINGS.BoxColor
            hl.OutlineTransparency = 0 -- Hiện viền rõ
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Nhìn xuyên tường
            hl.Parent = character
        end

        -- 2. TẠO TÊN + KHOẢNG CÁCH (BillboardGui)
        if not head:FindFirstChild("DeltaESP_Tag") then
            local bgui = Instance.new("BillboardGui")
            bgui.Name = "DeltaESP_Tag"
            bgui.Adornee = head
            bgui.Size = UDim2.new(0, 200, 0, 50)
            bgui.StudsOffset = Vector3.new(0, 3.5, 0) -- Cao hơn đầu chút
            bgui.AlwaysOnTop = true

            local label = Instance.new("TextLabel")
            label.Parent = bgui
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 1, 0)
            label.TextColor3 = SETTINGS.TextColor
            label.TextStrokeTransparency = 0 -- Viền chữ đen
            label.TextSize = SETTINGS.TextSize
            label.Font = Enum.Font.GothamBold
            label.TextYAlignment = Enum.TextYAlignment.Bottom
            
            bgui.Parent = head

            -- Cập nhật khoảng cách liên tục
            -- Dùng vòng lặp này nhẹ hơn RenderStepped cho điện thoại
            task.spawn(function()
                while character and character.Parent and bgui.Parent do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local myPos = LocalPlayer.Character.HumanoidRootPart.Position
                        local targetPos = root.Position
                        local dist = (myPos - targetPos).Magnitude
                        
                        label.Text = string.format("%s\n[%dm]", player.DisplayName, math.floor(dist))
                    else
                        label.Text = player.DisplayName
                    end
                    task.wait(0.1) -- Cập nhật 0.1s/lần để đỡ lag máy
                end
            end)
        end
    end

    -- Kích hoạt khi có nhân vật mới
    if player.Character then applyVisuals(player.Character) end
    player.CharacterAdded:Connect(applyVisuals)
end

-- Chạy cho người chơi hiện tại
for _, p in pairs(Players:GetPlayers()) do
    createESP(p)
end
Players.PlayerAdded:Connect(createESP)

-------------------------------------------------------------------
-- PHẦN 2: HACK THỂ LỰC (STAMINA) 
-------------------------------------------------------------------
-- Sử dụng pcall để tránh Delta bị crash nếu sai game
task.spawn(function()
    local success, err = pcall(function()
        local Sprinting = game:GetService("ReplicatedStorage"):WaitForChild("Systems", 5):WaitForChild("Character", 5):WaitForChild("Game", 5):WaitForChild("Sprinting", 5)
        
        if Sprinting then
            local stamina = require(Sprinting)
            -- Thiết lập thông số như yêu cầu 
            stamina.MaxStamina = 100 
            stamina.MinStamina = -20 
            stamina.StaminaGain = 100
            stamina.StaminaLoss = 0 -- Sửa thành 0 để chạy mãi không mệt
            stamina.SprintSpeed = 35 
            stamina.StaminaLossDisabled = true
            print("Delta: Hack Thể Lực đã bật!")
        end
    end)
    
    if not success then
        warn("Delta: Game này không có hệ thống Stamina đó, nhưng ESP vẫn chạy tốt!")
    end
end)

print("--- Delta Script Loaded ---")
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
