--hi skid
local Cubits = game.Workspace["Client Cubits"]:GetChildren()
local a = Instance.new("Folder", workspace)
a.Name = "Cube"

for _, v in ipairs(Cubits) do
    if v:IsA("BasePart") and v.Name == "Cubit" then
        local d = v:Clone()
        d.Parent = a
        d.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        local Prox = d:FindFirstChildOfClass("ProximityPrompt")
        if Prox then
            fireproximityprompt(Prox)
        end
    end
end
