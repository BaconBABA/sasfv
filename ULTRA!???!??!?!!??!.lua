local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local math_cos = math.cos
local math_sin = math.sin
local math_atan2 = math.atan2
local math_rad = math.rad
local math_abs = math.abs
local math_clamp = math.clamp
local math_max = math.max
local math_min = math.min

local DEFAULT_RADIUS = 50
local MIN_RADIUS = 1
local MAX_RADIUS = 1000
local HEIGHT = 100
local ROTATION_SPEED = 1
local ATTRACTION_STRENGTH = 1000
local MAX_DISTANCE = 500

local function createUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 240)
    frame.Position = UDim2.new(0.5, -140, 0.5, -120)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    local frameCorner = Instance.new("UICorner", frame)
    frameCorner.CornerRadius = UDim.new(0, 16)
    frame.Parent = screenGui

    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(80, 80, 80)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.Text = "Ultra Ring Parts"
    title.TextColor3 = Color3.fromRGB(240, 240, 240)
    title.Font = Enum.Font.BuilderSans
    title.TextSize = 26
    local titleCorner = Instance.new("UICorner", title)
    titleCorner.CornerRadius = UDim.new(0, 16)
    local titleGradient = Instance.new("UIGradient", title)
    titleGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(60,60,60)),ColorSequenceKeypoint.new(1, Color3.fromRGB(90,90,90))})

    local minimize = Instance.new("TextButton", frame)
    minimize.Size = UDim2.new(0, 32, 0, 32)
    minimize.Position = UDim2.new(1, -44, 0, 10)
    minimize.Text = "-"
    minimize.BackgroundColor3 = Color3.fromRGB(70,70,70)
    minimize.TextColor3 = Color3.fromRGB(240,240,240)
    minimize.Font = Enum.Font.Gotham
    minimize.TextSize = 22
    local minCorner = Instance.new("UICorner", minimize)
    minCorner.CornerRadius = UDim.new(0, 8)

    local toggle = Instance.new("TextButton", frame)
    toggle.Size = UDim2.new(0.9, 0, 0, 48)
    toggle.Position = UDim2.new(0.05, 0, 0.3, 0)
    toggle.Text = "Ring Parts Off"
    toggle.BackgroundColor3 = Color3.fromRGB(75,135,185)
    toggle.TextColor3 = Color3.fromRGB(255,255,255)
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 22
    local toggleCorner = Instance.new("UICorner", toggle)
    toggleCorner.CornerRadius = UDim.new(0, 8)

    local decRadius = Instance.new("TextButton", frame)
    decRadius.Size = UDim2.new(0.2, 0, 0, 48)
    decRadius.Position = UDim2.new(0.1, 0, 0.55, 0)
    decRadius.Text = "<"
    decRadius.BackgroundColor3 = Color3.fromRGB(85,85,85)
    decRadius.TextColor3 = Color3.fromRGB(245,245,245)
    decRadius.Font = Enum.Font.Gotham
    decRadius.TextSize = 22
    local decCorner = Instance.new("UICorner", decRadius)
    decCorner.CornerRadius = UDim.new(0, 8)

    local incRadius = Instance.new("TextButton", frame)
    incRadius.Size = UDim2.new(0.2, 0, 0, 48)
    incRadius.Position = UDim2.new(0.7, 0, 0.55, 0)
    incRadius.Text = ">"
    incRadius.BackgroundColor3 = Color3.fromRGB(85,85,85)
    incRadius.TextColor3 = Color3.fromRGB(245,245,245)
    incRadius.Font = Enum.Font.Gotham
    incRadius.TextSize = 22
    local incCorner = Instance.new("UICorner", incRadius)
    incCorner.CornerRadius = UDim.new(0, 8)

    local radiusDisplay = Instance.new("TextBox", frame)
    radiusDisplay.Size = UDim2.new(0.3, 0, 0, 48)
    radiusDisplay.Position = UDim2.new(0.35, 0, 0.55, 0)
    radiusDisplay.Text = tostring(DEFAULT_RADIUS)
    radiusDisplay.BackgroundColor3 = Color3.fromRGB(55,55,55)
    radiusDisplay.TextColor3 = Color3.fromRGB(245,245,245)
    radiusDisplay.Font = Enum.Font.Gotham
    radiusDisplay.TextSize = 22
    local radiusCorner = Instance.new("UICorner", radiusDisplay)
    radiusCorner.CornerRadius = UDim.new(0, 8)

    local watermark = Instance.new("TextLabel", frame)
    watermark.Size = UDim2.new(1, 0, 0, 22)
    watermark.Position = UDim2.new(0, 0, 1, -22)
    watermark.Text = "Ultra Ring [V1] by SolyNot\nhttps://discord.gg/8pJCFW8cpG"
    watermark.TextColor3 = Color3.fromRGB(140,140,140)
    watermark.BackgroundTransparency = 1
    watermark.Font = Enum.Font.Gotham
    watermark.TextSize = 14

    return {ScreenGui = screenGui,Frame = frame,Title = title,Minimize = minimize,Toggle = toggle,DecRadius = decRadius,IncRadius = incRadius,RadiusDisplay = radiusDisplay,Watermark = watermark}
end

local UI = createUI()

local function enableDrag(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            frame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset + input.Position.X - dragStart.X,startPos.Y.Scale,startPos.Y.Offset + input.Position.Y - dragStart.Y)
        end
    end)
end

enableDrag(UI.Frame)

local minimized = false
UI.Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and UDim2.new(0, UI.Frame.Size.X.Offset, 0, 60) or UDim2.new(0, UI.Frame.Size.X.Offset, 0, 240)
    UI.Frame:TweenSize(targetSize, "Out", "Quad", 0.3, true)
    UI.Minimize.Text = minimized and "+" or "-"
    for _, element in ipairs({UI.Toggle, UI.DecRadius, UI.IncRadius, UI.RadiusDisplay, UI.Watermark}) do
        element.Visible = not minimized
    end
end)

if not getgenv().Network then
    getgenv().Network = { BaseParts = {}, Velocity = Vector3.new(14.5, 14.5, 14.5) }
    getgenv().Network.RetainPart = function(part)
        if part:IsA("BasePart") and part:IsDescendantOf(Workspace) then
            table.insert(getgenv().Network.BaseParts, part)
            part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            part.CanCollide = false
        end
    end
    LocalPlayer.ReplicationFocus = Workspace
    RunService.Heartbeat:Connect(function()
        sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
        for _, part in pairs(getgenv().Network.BaseParts) do
            if part:IsDescendantOf(Workspace) then
                part.Velocity = getgenv().Network.Velocity
            end
        end
    end)
end

local radius = DEFAULT_RADIUS
local ringEnabled = false
local ringParts = {}

local function retainPart(part)
    if part:IsA("BasePart") and not part.Anchored and part:IsDescendantOf(Workspace)
       and part.Parent ~= LocalPlayer.Character and not part:IsDescendantOf(LocalPlayer.Character) then
        part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
        part.CanCollide = false
        return true
    end
    return false
end

local function updateParts(part, add)
    if add then
        if retainPart(part) and not ringParts[part] then
            ringParts[part] = true
        end
    else
        ringParts[part] = nil
    end
end

local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if hrp then
    local partsInRadius = Workspace:GetPartBoundsInRadius(hrp.Position, MAX_DISTANCE)
    for _, part in ipairs(partsInRadius) do
        updateParts(part, true)
    end
end

Workspace.DescendantAdded:Connect(function(part)
    updateParts(part, true)
end)
Workspace.DescendantRemoving:Connect(function(part)
    updateParts(part, false)
end)

RunService.Heartbeat:Connect(function()
    if not ringEnabled or not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local center = hrp.Position
    for part, _ in pairs(ringParts) do
        if not part.Parent then
            ringParts[part] = nil
        elseif (Vector3.new(part.Position.X, center.Y, part.Position.Z) - center).Magnitude < MAX_DISTANCE then
            local angle = math_atan2(part.Position.Z - center.Z, part.Position.X - center.X) + math_rad(ROTATION_SPEED)
            local targetOffset = Vector3.new(math_cos(angle), HEIGHT * math_abs(math_sin((part.Position.Y - center.Y) / HEIGHT)) / radius, math_sin(angle)) * radius
            local target = center + targetOffset
            local direction = target - part.Position
            if direction.Magnitude > 0 then
                part.Velocity = direction.Unit * ATTRACTION_STRENGTH
            end
        end
    end
end)

UI.Toggle.MouseButton1Click:Connect(function()
    ringEnabled = not ringEnabled
    UI.Toggle.Text = ringEnabled and "Ring Parts On" or "Ring Parts Off"
    UI.Toggle.BackgroundColor3 = ringEnabled and Color3.fromRGB(50,205,50) or Color3.fromRGB(75,135,185)
end)

UI.DecRadius.MouseButton1Click:Connect(function()
    radius = math_max(MIN_RADIUS, radius - 2)
    UI.RadiusDisplay.Text = tostring(radius)
end)

UI.IncRadius.MouseButton1Click:Connect(function()
    radius = math_min(MAX_RADIUS, radius + 2)
    UI.RadiusDisplay.Text = tostring(radius)
end)

UI.RadiusDisplay:GetPropertyChangedSignal("Text"):Connect(function()
    UI.RadiusDisplay.Text = UI.RadiusDisplay.Text:gsub("%D", "")
end)

UI.RadiusDisplay.FocusLost:Connect(function(enter)
    if enter then
        radius = math_clamp(tonumber(UI.RadiusDisplay.Text) or radius, MIN_RADIUS, MAX_RADIUS)
        UI.RadiusDisplay.Text = tostring(radius)
    end
end)
