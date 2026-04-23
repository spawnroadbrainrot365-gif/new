local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local OnBtn = Instance.new("TextButton")
local OffBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

local function StyleBtn(btn, text, pos, color)
    btn.Parent = MainFrame
    btn.Size = UDim2.new(0.8, 0, 0, 45)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    Instance.new("UICorner", btn)
end

StyleBtn(OnBtn, "Start", UDim2.new(0.1, 0, 0.15, 0), Color3.fromRGB(0, 150, 0))
StyleBtn(OffBtn, "Stop", UDim2.new(0.1, 0, 0.55, 0), Color3.fromRGB(150, 0, 0))

local SuperSpeed = 1200 
local Targets = {
    "Shahed-136 white", "Shahed-136 Black", "geran5", 
    "gerbera", "Model", "Su-27", "kalibr", "flamingo"
}
local IsActive = false 

local function ApplyHack(model)
    local seat = model:FindFirstChild("VehicleSeat")
    local main = model:FindFirstChild("Mainpart")
    
    if seat then
        if seat:FindFirstChild("giveNet") then
            seat.giveNet:FireServer(game.Players.LocalPlayer)
        elseif seat:FindFirstChild("getdostup") then
            seat.getdostup:FireServer(game.Players.LocalPlayer)
        end
    end

    if main and not model:FindFirstChild("HackRunning") then
        local tag = Instance.new("BoolValue", model)
        tag.Name = "HackRunning"

        task.spawn(function()
            local connection
            connection = game:GetService("RunService").Heartbeat:Connect(function()
                if not IsActive or not model.Parent or not model:FindFirstChild("HackRunning") then 
                    if model:FindFirstChild("HackRunning") then model.HackRunning:Destroy() end
                    if connection then connection:Disconnect() end
                    return 
                end

                main.AssemblyLinearVelocity = main.CFrame.LookVector * SuperSpeed
                main.AssemblyAngularVelocity = Vector3.new(0, 50, 0)
                
                if seat and seat:FindFirstChild("set rotate") then
                    seat["set rotate"]:FireServer()
                end
            end)
        end)
    end
end

local function ScanAndAttackAll()
    if not IsActive then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        for _, name in pairs(Targets) do
            if obj.Name == name then
                ApplyHack(obj)
            end
        end
    end
end

OnBtn.MouseButton1Click:Connect(function()
    IsActive = true
    OnBtn.Text = "active Now 🟢"
    ScanAndAttackAll()
end)

OffBtn.MouseButton1Click:Connect(function()
    IsActive = false
    OnBtn.Text = "Start"
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:FindFirstChild("HackRunning") then
            obj.HackRunning:Destroy()
        end
    end
end)

workspace.DescendantAdded:Connect(function(obj)
    if IsActive then
        for _, name in pairs(Targets) do
            if obj.Name == name then
                task.wait(0.5)
                ApplyHack(obj)
                break
            end
        end
    end
end)
