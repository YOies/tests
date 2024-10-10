

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
    




end -- end for UI


