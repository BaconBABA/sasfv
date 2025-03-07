-- Services
local PhysicsService = game:GetService("PhysicsService")
local PathfindingService = game:GetService("PathfindingService")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

-- Constants
local NPC_TAG = "NPC"  -- Tag for NPC models
local WALL_TAG = "Wall"  -- Tag for wall parts
local WAY_FOLDER = workspace:WaitForChild("Way")
local NPC_COLLISION_GROUP = "NPC"

-- Create the NPC collision group if it doesn't exist and set it so that NPC parts don't collide with each other
pcall(function()
    PhysicsService:CreateCollisionGroup(NPC_COLLISION_GROUP)
end)
PhysicsService:CollisionGroupSetCollidable(NPC_COLLISION_GROUP, NPC_COLLISION_GROUP, false)

-- Function to assign a collision group to every BasePart in a model
local function assignCollisionGroup(model, groupName)
    for _, part in pairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            PhysicsService:SetPartCollisionGroup(part, groupName)
        end
    end
end

-- Wall check function using raycasting.
-- This function casts a ray from startPos to endPos. If the ray hits any part tagged as "Wall", it returns false.
local function isPathClear(startPos, endPos)
    local direction = (endPos - startPos)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    -- Blacklist will ignore the NPC itself (caller can add its parts later if needed)
    local result = workspace:Raycast(startPos, direction, raycastParams)
    if result then
        if CollectionService:HasTag(result.Instance, WALL_TAG) then
            return false
        end
    end
    return true
end

-- Main NPC control function – runs a movement loop for one NPC
local function controlNPC(npc)
    -- Make sure the model has a Humanoid and a PrimaryPart
    if not npc:FindFirstChild("Humanoid") or not npc.PrimaryPart then
        return
    end
    local humanoid = npc.Humanoid
    assignCollisionGroup(npc, NPC_COLLISION_GROUP)
    
    while npc.Parent do
        local waypoints = WAY_FOLDER:GetChildren()
        if #waypoints == 0 then
            warn("No waypoints found in the 'Way' folder!")
            break
        end

        -- Choose a random waypoint
        local randomWaypoint = waypoints[math.random(1, #waypoints)]
        local startPos = npc.PrimaryPart.Position
        local targetPos = randomWaypoint.Position

        -- Check direct line-of-sight to the target (avoid walls)
        if not isPathClear(startPos, targetPos) then
            -- If blocked, wait and try again
            wait(1)
        else
            -- Compute a path using PathfindingService
            local path = PathfindingService:CreatePath({
                AgentRadius = 2,
                AgentHeight = 5,
                AgentCanJump = true,
                AgentWalkableTypes = {Enum.Material.Grass, Enum.Material.Concrete, Enum.Material.SmoothPlastic},
            })
            path:ComputeAsync(startPos, targetPos)
            
            if path.Status == Enum.PathStatus.Success then
                local pathWaypoints = path:GetWaypoints()
                for _, wp in ipairs(pathWaypoints) do
                    local wpPos = wp.Position
                    -- Check the segment to the waypoint is clear of walls
                    if not isPathClear(npc.PrimaryPart.Position, wpPos) then
                        warn("Path segment blocked by wall; recalculating path.")
                        break
                    end
                    humanoid:MoveTo(wpPos)
                    local reached = humanoid.MoveToFinished:Wait()
                    if not reached then
                        warn("Failed to reach waypoint; recalculating path.")
                        break
                    end
                end
            else
                warn("Pathfinding failed with status: " .. tostring(path.Status))
            end
            wait(1)
        end
    end
end

-- Function to initialize and control all NPCs tagged with "NPC"
local function setupNPCs()
    for _, npc in pairs(CollectionService:GetTagged(NPC_TAG)) do
        spawn(function()
            controlNPC(npc)
        end)
    end
end

-- Initialize existing NPCs
setupNPCs()

-- Listen for any new NPCs added at runtime
CollectionService:GetInstanceAddedSignal(NPC_TAG):Connect(function(npc)
    spawn(function()
        controlNPC(npc)
    end)
end)
