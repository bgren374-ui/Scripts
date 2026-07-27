local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- 1. DATA CONFIG
local States = {["Enabled"] = false, ["TargetFPS"] = 60, ["ClickDelay"] = 0}
local function SetFPS(cap) if setfpscap then setfpscap(cap) end end

local function GetDynamicBoost()
    if States.TargetFPS >= 15 and States.TargetFPS <= 19 then return 54 end
    return 48 + ((60 - States.TargetFPS) * 0.45)
end

-- 2. KEYTECHZ LOGIN (BLACK THEME)
local KeyTechz = Instance.new("ScreenGui", player.PlayerGui)
KeyTechz.Name = "KeyTechz"

local KeyFrame = Instance.new("Frame", KeyTechz)
KeyFrame.Size = UDim2.new(0, 280, 0, 200); KeyFrame.Position = UDim2.new(0.5, -140, 0.5, -100); KeyFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Instance.new("UICorner", KeyFrame)

local KeyInput = Instance.new("TextBox", KeyFrame); KeyInput.PlaceholderText = "Enter Key..."; KeyInput.Size = UDim2.new(0.8, 0, 0, 40); KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0); KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25); KeyInput.TextColor3 = Color3.new(1, 1, 1); KeyInput.Text = ""; Instance.new("UICorner", KeyInput)

local Submit = Instance.new("TextButton", KeyFrame); Submit.Text = "Login"; Submit.Size = UDim2.new(0.8, 0, 0, 40); Submit.Position = UDim2.new(0.1, 0, 0.6, 0); Submit.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Submit.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", Submit)

local Msg = Instance.new("TextLabel", KeyFrame); Msg.Text = "KeyTechz V4.0"; Msg.Size = UDim2.new(1, 0, 0, 20); Msg.Position = UDim2.new(0, 0, 0.85, 0); Msg.TextColor3 = Color3.fromRGB(255, 255, 255); Msg.BackgroundTransparency = 1

-- 3. UNIVERSAL DRAG FUNCTION
local function makeDraggable(obj)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

-- 4. THE ENGINE LOADER
local function LoadEngine()
    KeyTechz:Destroy()
    local Gui = Instance.new("ScreenGui", player.PlayerGui); Gui.ResetOnSpawn = false
    
    -- MAIN MENU
    local Main = Instance.new("Frame", Gui); Main.Size = UDim2.new(0, 320, 0, 420); Main.Position = UDim2.new(0.5, -160, 0.5, -210); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Visible = true; Instance.new("UICorner", Main); makeDraggable(Main)

    -- SLIDER CREATOR FUNCTION (For Mobile Consistency)
    local function CreateSlider(name, min, max, pos, callback)
        local Frame = Instance.new("Frame", Main); Frame.Size = UDim2.new(0.9, 0, 0, 80); Frame.Position = pos; Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", Frame)
        local Label = Instance.new("TextLabel", Frame); Label.Text = name .. ": " .. min; Label.Size = UDim2.new(1, 0, 0.4, 0); Label.TextColor3 = Color3.new(1,1,1); Label.BackgroundTransparency = 1; Label.Font = "GothamBold"
        local Bar = Instance.new("Frame", Frame); Bar.Size = UDim2.new(0.8, 0, 0, 8); Bar.Position = UDim2.new(0.1, 0, 0.7, 0); Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45); Instance.new("UICorner", Bar)
        local Btn = Instance.new("TextButton", Bar); Btn.Size = UDim2.new(0, 35, 0, 35); Btn.Position = UDim2.new(0, -17, 0.5, -17); Btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0); Btn.Text = ""; Instance.new("UICorner", Btn)

        local moving = false
        Btn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then moving = true end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then moving = false end end)

        UserInputService.InputChanged:Connect(function(input)
            if moving and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local rel = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                Btn.Position = UDim2.new(rel, -17, 0.5, -17)
                local val = math.floor(min + (rel * (max - min)))
                Label.Text = name .. ": " .. val
                callback(val)
            end
        end)
    end

    -- FPS SLIDER
    CreateSlider("FPS CAP", 15, 240, UDim2.new(0.05, 0, 0.05, 0), function(v)
        States.TargetFPS = v
        if States.Enabled then SetFPS(v) end
    end)

    -- CLICK DELAY SLIDER
    CreateSlider("CLICK DELAY (ms)", 0, 500, UDim2.new(0.05, 0, 0.28, 0), function(v)
        States.ClickDelay = v/1000 -- Convert to seconds
    end)

    -- TOGGLE ENGINE BUTTON
    local Tgl = Instance.new("TextButton", Main); Tgl.Text = "ENABLE SHIFTZ ENGINE"; Tgl.Size = UDim2.new(0.8, 0, 0, 50); Tgl.Position = UDim2.new(0.1, 0, 0.55, 0); Tgl.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Tgl.TextColor3 = Color3.new(1,1,1); Tgl.Font = "GothamBold"; Instance.new("UICorner", Tgl)
    Tgl.MouseButton1Click:Connect(function()
        States.Enabled = not States.Enabled
        Tgl.BackgroundColor3 = States.Enabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(30, 30, 30)
        Tgl.Text = States.Enabled and "ENGINE ACTIVE" or "ENABLE SHIFTZ ENGINE"
        SetFPS(States.Enabled and States.TargetFPS or 60)
    end)

    -- S BUTTON (OPEN/CLOSE)
    local OpenBtn = Instance.new("TextButton", Gui); OpenBtn.Size = UDim2.new(0, 50, 0, 50); OpenBtn.Position = UDim2.new(0, 10, 0.5, -25); OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0); OpenBtn.Text = "S"; OpenBtn.TextColor3 = Color3.new(1,1,1); OpenBtn.Font = "LuckiestGuy"; OpenBtn.TextSize = 25; Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1,0); makeDraggable(OpenBtn)
    OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    -- CLICK DELAY LOGIC
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed or not States.Enabled or States.ClickDelay == 0 then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            task.wait(States.ClickDelay) -- The specific delay you chose on the slider
        end
    end)

    -- PHYSICS ENGINE
    local function applyBoost(char)
        local hum = char:WaitForChild("Humanoid"); local root = char:WaitForChild("HumanoidRootPart")
        hum.Jumping:Connect(function(active)
            if active and States.Enabled then
                task.wait(0.02)
                local b = GetDynamicBoost()
                if b > 0 then root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X * 0.85, b, root.AssemblyLinearVelocity.Z * 0.85) end
            end
        end)
    end
    player.CharacterAdded:Connect(applyBoost); if player.Character then applyBoost(player.Character) end
end

-- 5. PASSWORD CHECK
Submit.MouseButton1Click:Connect(function()
    if KeyInput.Text == "batmangoated" then LoadEngine() else Msg.Text = "ask owner for the key"; task.wait(2); Msg.Text = "KeyTechz V4.0" end
end)
