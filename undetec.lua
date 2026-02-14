local V1 = Instance.new('Frame', main)
local S = Instance.new("ScreenGui")
local main = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Open = Instance.new("TextButton")
local Close = Instance.new("TextButton")
local Title = Instance.new("TextLabel")
local SilentAim = Instance.new("TextButton")
local InfAmmo = Instance.new("TextButton")
local SpeedAmmo = Instance.new("TextButton")
local Esp = Instance.new("TextButton")
local RGBWeapon = Instance.new("TextButton")
local Speed = Instance.new("TextBox")
local UICorner = Instance.new("UICorner")
local UICorner2 = Instance.new("UICorner")
local UICorner3 = Instance.new("UICorner")
local UICorner4 = Instance.new("UICorner")
local UICorner5 = Instance.new("UICorner")
local UICorner6 = Instance.new("UICorner")
local UICorner7 = Instance.new("UICorner")
local UICorner8 = Instance.new("UICorner")
local UICorner9 = Instance.new("UICorner")
local UICorner10 = Instance.new("UICorner")

--Gui--
local gui = Instance.new('ScreenGui')
if crashy == false then
    gui.Parent = game.CoreGui
else
gui.Parent = game.Players.LocalPlayer.PlayerGui
end
gui.Name = "gui"
gui.ResetOnSpawn = false

S.Name = "S"
S.Parent = game.CoreGui
S.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

--Menu:
main.Parent = gui
main.AnchorPoint = Vector2.new(1, 0)
main.Active = true
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Position = UDim2.new(0.65, 0, 0.13, 0)
main.Size = UDim2.new(0, 170, 0, 130)
main.Draggable = true

V1.Parent = S
V1.AnchorPoint = Vector2.new(0.9, 0)
V1.Active = true
V1.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
V1.BackgroundTransparency = 1.000
V1.Position = UDim2.new(0.997, 0, 0.13, 0)
V1.Size = UDim2.new(0, 18, 0, 18)

UICorner.Parent = main
UICorner2.Parent = Open
UICorner3.Parent = V1
UICorner4.Parent = Close
UICorner5.Parent = SilentAim
UICorner6.Parent = InfAmmo
UICorner7.Parent = SpeedAmmo
UICorner8.Parent = Esp
UICorner9.Parent = RGBWeapon
UICorner10.Parent = Speed

Open.Name = "Open"
Open.Parent = V1
Open.AnchorPoint = Vector2.new(0.9, 0)
Open.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Open.Position = UDim2.new(0.898, 0, 0.0325, 0)
Open.Size = UDim2.new(0, 20, 0, 20)
Open.Font = Enum.Font.SourceSans
Open.Text = "+"
Open.TextColor3 = Color3.fromRGB(0, 153, 0)
Open.TextSize = 39.000
Open.Visible = false
Open.MouseButton1Down:Connect(function()
main.Visible = true
Open.Visible = false
Close.Visible = true
end)

Close.Name = "Close"
Close.Parent = V1
Close.AnchorPoint = Vector2.new(0.9, 0)
Close.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Close.Position = UDim2.new(0.898, 0, 0.0325, 0)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Font = Enum.Font.SourceSans
Close.Text = "-"
Close.TextColor3 = Color3.fromRGB(255, 0, 0)
Close.TextSize = 39.000
Close.MouseButton1Down:Connect(function()
main.Visible = false
Close.Visible = false
Open.Visible = true
end)

Title.Name = "Title"
Title.Parent = main
Title.BackgroundTransparency = 1.000
Title.Position = UDim2.new(0.41, 0, 0.005, 0)
Title.Size = UDim2.new(0.2, 0, 0.2, 0)
Title.Font = Enum.Font.Cartoon
Title.Text = "Arsenal "
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24.000


SilentAim.Name = "SilentAim"
SilentAim.Parent = main
SilentAim.AnchorPoint = Vector2.new(0.9, 0)
SilentAim.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SilentAim.Position = UDim2.new(0.30, 0, 0.2, 0)
SilentAim.Size = UDim2.new(0, 40, 0, 25)
SilentAim.Font = Enum.Font.SourceSans
SilentAim.Text = "SilentAim"
SilentAim.TextColor3 = Color3.fromRGB(255, 255, 255)
SilentAim.TextSize = 11.000
SilentAim.MouseButton1Down:Connect(function()
local CurrentCamera = workspace.CurrentCamera
local Players = game.Players
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
function ClosestPlayer()
    local MaxDist, Closest = math.huge
    for I,V in pairs(Players.GetPlayers(Players)) do
        if V == LocalPlayer then continue end
        if V.Team == LocalPlayer then continue end
        if not V.Character then continue end
        local Head = V.Character.FindFirstChild(V.Character, "Head")
        if not Head then continue end
        local Pos, Vis = CurrentCamera.WorldToScreenPoint(CurrentCamera, Head.Position)
        if not Vis then continue end
        local MousePos, TheirPos = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2), Vector2.new(Pos.X, Pos.Y)
        local Dist = (TheirPos - MousePos).Magnitude
        if Dist < MaxDist then
            MaxDist = Dist
            Closest = V
        end
    end
    return Closest
end
local MT = getrawmetatable(game)
local OldNC = MT.__namecall
local OldIDX = MT.__index
setreadonly(MT, false)
MT.__namecall = newcclosure(function(self, ...)
    local Args, Method = {...}, getnamecallmethod()
    if Method == "FindPartOnRayWithIgnoreList" and not checkcaller() then
        local CP = ClosestPlayer()
        if CP and CP.Character and CP.Character.FindFirstChild(CP.Character, "Head") then
            Args[1] = Ray.new(CurrentCamera.CFrame.Position, (CP.Character.Head.Position - CurrentCamera.CFrame.Position).Unit * 1000)
            return OldNC(self, unpack(Args))
        end
    end
    return OldNC(self, ...)
end)
MT.__index = newcclosure(function(self, K)
    if K == "Clips" then
        return workspace.Map
    end
    return OldIDX(self, K)
end)
setreadonly(MT, true)
function getplrsname() for i,v in pairs(game:GetChildren()) do if v.ClassName == "Players" then return v.Name end end end local players = getplrsname() local plr = game[players].LocalPlayer coroutine.resume(coroutine.create(function() while wait(1) do coroutine.resume(coroutine.create(function() for _,v in pairs(game[players]:GetPlayers()) do if v.Name ~= plr.Name and v.Character then v.Character.RightUpperLeg.CanCollide = false v.Character.RightUpperLeg.Transparency = 75 v.Character.RightUpperLeg.Size = Vector3.new(21,21,21) v.Character.LeftUpperLeg.CanCollide = false v.Character.LeftUpperLeg.Transparency = 75 v.Character.LeftUpperLeg.Size = Vector3.new(21,21,21) v.Character.HeadHB.CanCollide = false v.Character.HeadHB.Transparency = 75 v.Character.HeadHB.Size = Vector3.new(21,21,21) v.Character.HumanoidRootPart.CanCollide = false v.Character.HumanoidRootPart.Transparency = 75 v.Character.HumanoidRootPart.Size = Vector3.new(21,21,21) end end end)) end end))
end)

RGBWeapon.Name = "RGBWeapon"
RGBWeapon.Parent = main
RGBWeapon.AnchorPoint = Vector2.new(0.9, 0)
RGBWeapon.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
RGBWeapon.Position = UDim2.new(0.60, 0, 0.45, 0)
RGBWeapon.Size = UDim2.new(0, 40, 0, 25)
RGBWeapon.Font = Enum.Font.SourceSans
RGBWeapon.Text = " RGB Weapon "
RGBWeapon.TextColor3 = Color3.fromRGB(255, 255, 255)
RGBWeapon.TextSize = 9.000
RGBWeapon.MouseButton1Down:Connect(function()
local c = 1 function zigzag(X)  return math.acos(math.cos(X * math.pi)) / math.pi end game:GetService("RunService").RenderStepped:Connect(function()  if game.Workspace.Camera:FindFirstChild('Arms') then   for i,v in pairs(game.Workspace.Camera.Arms:GetDescendants()) do    if v.ClassName == 'MeshPart' then      v.Color = Color3.fromHSV(zigzag(c),1,1)     c = c + .0001    end   end  end end)
end)

Speed.Name = "Speed"
Speed.Parent = main
Speed.AnchorPoint = Vector2.new(0.9, 0)
Speed.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Speed.Position = UDim2.new(0.90, 0, 0.45, 0)
Speed.Size = UDim2.new(0, 40, 0, 25)
Speed.Font = Enum.Font.SourceSans
Speed.Text = "16"
Speed.TextColor3 = Color3.fromRGB(255, 255, 255)
Speed.TextSize = 9.000

spawn(function()
while wait() do
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Speed.Text
end
end)

Esp.Name = "Esp"
Esp.Parent = main
Esp.AnchorPoint = Vector2.new(0.9, 0)
Esp.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Esp.Position = UDim2.new(0.30, 0, 0.45, 0)
Esp.Size = UDim2.new(0, 40, 0, 25)
Esp.Font = Enum.Font.SourceSans
Esp.Text = " Esp "
Esp.TextColor3 = Color3.fromRGB(255, 255, 255)
Esp.TextSize = 9.000
Esp.MouseButton1Click:Connect(function()
    local function createEsp(player)
    -- Создаем объекты для esp
    local Esp = Instance.new("BillboardGui")
    Esp.Name = ""
    Esp.Size = UDim2.new(1.75, 0, 1.75, 0)
    Esp.AlwaysOnTop = true
    Esp.LightInfluence = 0
    Esp.Adornee = player.Character.Head
    Esp.Parent = player.Character.Head

    local Frame = Instance.new("Frame", Esp)
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame.BorderSizePixel = 4
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    
    local DistanceLabel = Instance.new("TextLabel", Frame)
    DistanceLabel.Size = UDim2.new(1, 0, 1, 0)
    DistanceLabel.BackgroundTransparency = 1
    DistanceLabel.Font = Enum.Font.SourceSansBold
    DistanceLabel.FontSize = Enum.FontSize.Size10
    DistanceLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    
    local function updateEsp()
        local distance = (player.Character.Head.Position - game.Players.LocalPlayer.Character.Head.Position).Magnitude
        if player.Team ~= game.Players.LocalPlayer.Team then
            Esp.Enabled = true
            DistanceLabel.Text = string.format("%.0f m", distance)
        else
            Esp.Enabled = false
        end
    end

    game:GetService("RunService").
 RenderStepped:Connect(function()
        pcall(updateEsp)
    end)
end

for _, player in pairs(game:GetService("Players"):GetPlayers()) do
    if player.Character and player.Character.Head then
        if player.Team ~= game.Players.LocalPlayer.Team then
            createEsp(player)
        end
    end
end

game:GetService("Players").PlayerAdded:Connect(function(player)
    if player.Character and player.Character.Head then
        if player.Team ~= game.Players.LocalPlayer.Team then
            createEsp(player)
        end
    end
end)
end)

InfAmmo.Name = "InfAmmo"
InfAmmo.Parent = main
InfAmmo.AnchorPoint = Vector2.new(0.9, 0)
InfAmmo.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
InfAmmo.Position = UDim2.new(0.60, 0, 0.2, 0)
InfAmmo.Size = UDim2.new(0, 40, 0, 25)
InfAmmo.Font = Enum.Font.SourceSans
InfAmmo.Text = " InfAmmo "
InfAmmo.TextColor3 = Color3.fromRGB(255, 255, 255)
InfAmmo.TextSize = 11.000
InfAmmo.MouseButton1Down:Connect(function()
while wait() do
        game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount.Value = 999
        game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount2.Value = 999
    end
end)

SpeedAmmo.Name = "SpeedAmmo"
SpeedAmmo.Parent = main
SpeedAmmo.AnchorPoint = Vector2.new(0.9, 0)
SpeedAmmo.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpeedAmmo.Position = UDim2.new(0.90, 0, 0.2, 0)
SpeedAmmo.Size = UDim2.new(0, 40, 0, 25)
SpeedAmmo.Font = Enum.Font.SourceSans
SpeedAmmo.Text = " SpeedAmmo "
SpeedAmmo.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedAmmo.TextSize = 9.000
SpeedAmmo.MouseButton1Down:Connect(function()
local replicationstorage = game.ReplicatedStorage

for i, v in pairs(replicationstorage.Weapons:GetDescendants()) do
   if v.Name == "Auto" then
       v.Value = true
   end
   if v.Name == "RecoilControl" then
       v.Value = 0
   end
   if v.Name == "MaxSpread" then
       v.Value = 0
   end
   if v.Name == "ReloadTime" then
      v.Value = 0
   end
   if v.Name == "FireRate" then
       v.Value = 0.05
   end
   if v.Name == "Crit" then
       v.Value = 20
   end
   end
end)
