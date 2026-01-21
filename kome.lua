-- // Variables \\ --

_G.triggerbot = false

local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local Clicked = false

-- // UI Creation (Tạo nút bấm) \\ --

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

-- Đưa UI vào PlayerGui
ScreenGui.Name = "TriggerBotGUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false -- Giữ UI khi chết

-- Thiết lập khung chứa (Frame)
Frame.Name = "MainFrame"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.1, 0, 0.1, 0) -- Vị trí mặc định
Frame.Size = UDim2.new(0, 150, 0, 50) -- Kích thước
Frame.Active = true
Frame.Draggable = true -- Cho phép kéo thả nút

-- Thiết lập nút bấm (Button)
TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80) -- Màu đỏ (Tắt)
TextButton.Size = UDim2.new(1, -10, 1, -10)
TextButton.Position = UDim2.new(0, 5, 0, 5)
TextButton.Font = Enum.Font.SourceSansBold
TextButton.Text = "Triggerbot: OFF"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 18

UICorner.Parent = TextButton
UICorner.CornerRadius = UDim.new(0, 8)

-- // UI Functionality (Chức năng nút) \\ --

TextButton.MouseButton1Click:Connect(function()
	_G.triggerbot = not _G.triggerbot
	
	if _G.triggerbot then
		TextButton.Text = "Triggerbot: ON"
		TextButton.BackgroundColor3 = Color3.fromRGB(80, 255, 80) -- Chuyển sang màu xanh khi Bật
	else
		TextButton.Text = "Triggerbot: OFF"
		TextButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80) -- Chuyển về màu đỏ khi Tắt
	end
end)

-- // Main Scripts (Logic cũ giữ nguyên) \\ --

game:GetService("RunService").RenderStepped:Connect(function()
	-- Kiểm tra mục tiêu có phải là Humanoid không
	local target = mouse.Target
	if target and target.Parent then
		local humanoid = target.Parent:FindFirstChildOfClass("Humanoid") or target.Parent.Parent:FindFirstChildOfClass("Humanoid")
		
		if humanoid and _G.triggerbot and target.Parent.Name ~= player.Name then
			if humanoid.Health > 0 then
				mouse1press()
				Clicked = false
			end
		elseif _G.triggerbot and not Clicked then
			mouse1release()
		elseif not _G.triggerbot and humanoid then
			-- Logic cũ: Nếu tắt bot nhưng vẫn nhắm vào mục tiêu thì reset click
			Clicked = true
		end
	end
end)
