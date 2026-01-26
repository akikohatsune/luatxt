-- LocalScript to highlight all players with a red box
local Players = game:GetService("Players")

-- Function to create a red box highlight effect
local function createBoxHighlight(target)
    local box = Instance.new("BoxHandleAdornment")
    box.Size = target.Size
    box.AlwaysOnTop = true
    box.ZIndex = 0
    box.Adornee = target
    box.Color3 = Color3.fromRGB(255, 0, 0) -- Red color
    box.Transparency = 0.5 -- Slightly transparent
    box.Parent = target
end

-- Function to highlight all players
local function highlightPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            local character = player.Character

            -- Highlight each part of the character with a red box
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    createBoxHighlight(part)
                end
            end
        end
    end
end

-- Highlight players when the script runs
highlightPlayers()

-- Also highlight any new players who join the game
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        -- Delay to ensure character parts are loaded
        wait(1)
        highlightPlayers()
    end)
end)
--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local Sprinting = game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting
local stamina = require(Sprinting)
stamina.MaxStamina = 100  -- Maximum stamina
stamina.MinStamina = -20  -- Minimum stamina
stamina.StaminaGain = 100 -- Stamina gain
stamina.StaminaLoss = 5 -- Stamina loss
stamina.SprintSpeed = 30 -- Sprint speed
stamina.StaminaLossDisabled = true -- Disable stamina drain (true/false)
