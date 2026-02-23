local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()

    if not checkcaller() and method == "FireServer" and typeof(self) == "Instance" then
        if self.Name == "R\204\180\204\136\204\177B\204\180\205\140\204\177KH\204\183\204\138\204\173\204\174" then
            return
        end

        local args = {...}
        if type(args[2]) == "string" and string.find(args[2], "Lucky2") then
            return
        end
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function cleanGui(gui)
    gui.ChildAdded:Connect(function(child)
        if child:IsA("Message") and type(child.Text) == "string" and string.find(child.Text, "Banned") then
            task.defer(function()
                child:Destroy()
            end)
        end
    end)
end

if LocalPlayer:FindFirstChild("PlayerGui") then
    cleanGui(LocalPlayer.PlayerGui)
end

LocalPlayer.ChildAdded:Connect(function(child)
    if child.Name == "PlayerGui" then
        cleanGui(child)
    end
end)
