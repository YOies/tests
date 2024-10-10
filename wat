--gg


local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   wait(3)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)


local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Alucard Private | " .. gameName,
    SubTitle = "by Alucard",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})


local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
}

local Options = Fluent.Options

do


    local Fish = Tabs.Main:AddToggle("FishToggle", {Title = "Auto Fish", Default = false })
    local SwordInRock = Tabs.Main:AddToggle("SwordInRockToggle", {Title = "Auto Sword In Rock", Default = false })
    local AutoPVP = Tabs.Main:AddToggle("AutoPVPToggle", {Title = "Auto PVP", Default = false })
    local AutoRefreshPVP = Tabs.Main:AddToggle("AutoRefreshPVPToggle", {Title = "Auto Refresh PVP If You Fought All Opponents", Default = false })
    local AutoFightHighestDungeon = Tabs.Main:AddToggle("AutoFightHighestDungeonToggle", {Title = "Auto Fight The Dungeon Closest To Your DPS", Default = false })
    local AutoUseAllPotions = Tabs.Main:AddToggle("AutoUseAllPotionToggle", {Title = "Auto Use All Potions", Default = false })


    
    Fish:OnChanged(function()
        while Options.FishToggle.Value == true do  
            task.wait(.1)
                   pcall(function()
                    if workspace.Environment.Fishing.Rod.Rill.Attachment.ProximityPrompt.ObjectText == "NOW!" then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Environment.Fishing.Rod.Rill.CFrame
                    local proximityPrompt = workspace.Environment.Fishing.Rod.Rill.Attachment.ProximityPrompt
                    proximityPrompt:InputHoldBegin()
                    proximityPrompt:InputHoldEnd()
                    end    
                   end)
                   if  Options.FishToggle.Value == false then 
                       break 
                     end 
                   end 
           
    end)



    SwordInRock:OnChanged(function()
        while Options.SwordInRockToggle.Value == true do  
            task.wait(.1)
                   pcall(function()
                    if workspace.Environment.SwordInRock.Rock.Attachment.ProximityPrompt.ObjectText == "NOW!" then 
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(31.2233238, 2.52888727, 44.5766983, 0.984812498, 0, 0.173621148, 0, 1, 0, -0.173621148, 0, 0.984812498)
                        local proximityPrompt = workspace.Environment.SwordInRock.Rock.Attachment.ProximityPrompt
                        proximityPrompt:InputHoldBegin()
                        proximityPrompt:InputHoldEnd()
                    end                     
                   end)
                   if  Options.SwordInRockToggle.Value == false then 
                       break 
                     end 
                   end 
           
    end)


   

    
    AutoUseAllPotions:OnChanged(function()
        while Options.AutoUseAllPotionToggle.Value == true do  
            task.wait(.1)
            local potions = {}

            -- Iterate through the potion inventory items
            for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.PotionInventory.Items:GetChildren()) do
                if v:IsA("Frame") then
                    local text = v.Name
                    local value = string.match(text, "([^:]+):") -- Extract value before the colon
                    if value then
                        print("Value before colon: ", value)
                        table.insert(potions, value) -- Store the value in the potions table
                    end
                end
            end
            
            -- Consume each potion collected
            for _, potionName in pairs(potions) do
                local args = {
                    [1] = potionName, -- Use potionName directly
                    [2] = 1 -- Quantity to consume
                }
            
                -- Ensure ReplicatedStorage is correctly referenced
                local replicatedStorage = game:GetService("ReplicatedStorage")
                local potionInventoryService = replicatedStorage:WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PotionInventoryService")
                
                -- Invoke the remote function to consume the potion
                local success, errorMessage = pcall(function()
                    potionInventoryService:WaitForChild("RF"):WaitForChild("ConsumePotion"):InvokeServer(unpack(args))
                end)
            
                -- Handle errors
                if not success then
                    print("Error consuming potion: ", errorMessage)
                else
                    print("Successfully consumed potion: ", potionName)
                end
            end
            
                   if  Options.AutoUseAllPotionToggle.Value == false then 
                       break 
                     end 
                   end 
           
    end)


    AutoPVP:OnChanged(function()
        local OpponentsList = game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.PVP.Attack.OpponentsList
        local connection -- To hold the event connection for ChildAdded
        local autoPVPActive = false -- Track AutoPVP status
    
        -- Function to process each opponent frame
        local function processFrame(v)
            if v:IsA('Frame') and v.Fight.Button.Title.Text == "⚔️Fight" then
                local args = {
                    [1] = v.Name
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PVPDungeonService"):WaitForChild("RF"):WaitForChild("FightPlayerDungeon"):InvokeServer(unpack(args))
            end
        end
    
        -- Function to start processing
        local function startAutoPVP()
            autoPVPActive = true
            -- Process new children dynamically
            connection = OpponentsList.ChildAdded:Connect(function(child)
                if Options.AutoPVPToggle.Value == true then
                    processFrame(child)
                end
            end)
    
            -- Process existing children in a loop
            while Options.AutoPVPToggle.Value == true and autoPVPActive do
                task.wait(0.1)
                pcall(function()
                    for _, v in pairs(OpponentsList:GetChildren()) do
                        processFrame(v)
                    end
                end)
            end
    
            -- Disconnect event listener if toggle is turned off
            if connection then
                connection:Disconnect()
            end
            autoPVPActive = false
        end
    
        -- Function to stop AutoPVP
        local function stopAutoPVP()    
            autoPVPActive = false
            if connection then
                connection:Disconnect()
            end
        end
    
        -- React to the toggle change
        if Options.AutoPVPToggle.Value == true then
            startAutoPVP()
        else
            stopAutoPVP()
        end
    end)
    
    AutoRefreshPVP:OnChanged(function()
        while Options.AutoRefreshPVPToggle.Value == true do  
            task.wait(.1)
        local opponentsList = game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.PVP.Attack.OpponentsList:GetChildren()

local allDifferent = true

for _, child in pairs(opponentsList) do
    if child:IsA("Frame") and child:FindFirstChild("Fight") and child.Fight:FindFirstChild("Button") and child.Fight.Button:FindFirstChild("Title") then
        local labelText = child.Fight.Button.Title.Text 
        if labelText == "⚔️Fight" then
            print(child.Name .. " has the fight text")
            allDifferent = false
        end
    end
end

if allDifferent then
    print("Passed check!, Refresh PVP List")
    game:GetService("ReplicatedStorage"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PVPService"):WaitForChild("RF"):WaitForChild("RefreshOpponents"):InvokeServer()

end

if  Options.AutoRefreshPVPToggle.Value == false then 
    break 
  end 
end 
    end)

    AutoFightHighestDungeon:OnChanged(function()
        while Options.AutoFightHighestDungeonToggle.Value == true do  
            task.wait(.1)
            if game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.DungeonProgress.Visible == false then 
-- Function to convert DPS text to a number, if necessary
function convertToNumber(valueString)
    local number, suffix = valueString:match("(%d+)(%a+)")
    
    if not number then
        print("No number found in: " .. valueString) 
        return tonumber(valueString) 
    end

    number = tonumber(number) 
    if suffix == "K" then
        return number * 1_000        
    elseif suffix == "M" then
        return number * 1_000_000    
    elseif suffix == "B" then
        return number * 1_000_000_000 
    elseif suffix == "T" then
        return number * 1_000_000_000_000 
    elseif suffix == "QD" then
        return number * 1_000_000_000_000_000 
    else
        print("Unknown suffix in: " .. valueString) 
        return number -- If no known suffix, return the original number
    end
end

-- Get the player's DPS
local dpsText = game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.PlayerState.DPS.Text
local playerDPS = convertToNumber(dpsText)

-- Initialize a variable to track the highest dungeon DPS the player can beat
local highestDungeonDPS = nil
local highestDungeon = nil

-- Iterate through dungeons and compare their DPS
for dungeonName, dungeon in pairs(workspace.Dungeons:GetChildren()) do
    local powerText = dungeon.Entrance and dungeon.Entrance.DoorScreen.SurfaceGui.Power and dungeon.Entrance.DoorScreen.SurfaceGui.Power.Text

    if powerText then
        -- Remove non-numeric characters (except for the digits)
        local cleanedText = powerText:gsub("[^%d]", "") -- Remove all characters except digits

        local dungeonDPS = tonumber(cleanedText) -- Convert the cleaned text to a number

        if dungeonDPS then
        --    print(dungeonName .. ": " .. dungeonDPS) -- Print the dungeon name and its DPS
            
            -- Check if playerDPS is higher than the dungeonDPS
            if playerDPS > dungeonDPS then
           --     print("Player DPS: " .. playerDPS .. " is higher than " .. dungeonName .. " DPS: " .. dungeonDPS)
                
                -- Find the highest dungeon DPS the player can beat
                if not highestDungeonDPS or dungeonDPS > highestDungeonDPS then
                    highestDungeonDPS = dungeonDPS
                    highestDungeon = dungeon -- Store the reference to the highest dungeon
                end
            end
        else
            print(dungeonName .. ": The text is not a valid number.")
        end
    else
        print(dungeonName .. ": Power text not found.")
    end
end

-- Check if we found the highest dungeon the player can beat
if highestDungeon and highestDungeon.Entrance and highestDungeon.Entrance.DoorScreen then
    -- Teleport the player to the highest dungeon's DoorScreen
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    character:SetPrimaryPartCFrame(highestDungeon.Entrance.DoorScreen.CFrame * CFrame.new(0,0,-7)) -- Teleport the player
    print("Teleported to: " .. highestDungeon.Name .. ".")
else
    print("No valid dungeon found to teleport to.")
end
            if  Options.AutoFightHighestDungeonToggle.Value == false then 
                break 
              end 
            end 
        end 
        end 
    end)
end -- end for UI


