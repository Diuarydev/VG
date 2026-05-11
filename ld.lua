-- Verificação do jogo
local gameId = game.PlaceId
local allowedGameId = 89405258333641

if gameId ~= allowedGameId then
    print("=========================================")
    print("⚠️ SCRIPT BLOQUEADO! ⚠️")
    print("Este script só funciona no jogo:")
    print("Cook a Recipe")
    print("=========================================")
    wait(2)
    game:Shutdown()
    error("Script bloqueado! Jogo não autorizado.")
end

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local function crashGame()
    game:Shutdown()
    error("💔 VOCÊ DISSE NÃO! Coração quebrado... Game Over 💔")
end

-- ANTI AFK
local function startAntiAFK()
    spawn(function()
        while true do
            wait(30)
            pcall(function()
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end)
end
startAntiAFK()

-- Tela de casamento
local marriageGui = Instance.new("ScreenGui")
marriageGui.Name = "MarriageProposal"
marriageGui.Parent = player:WaitForChild("PlayerGui")

local darkBg = Instance.new("Frame")
darkBg.Size = UDim2.new(1, 0, 1, 0)
darkBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
darkBg.BackgroundTransparency = 0.7
darkBg.Parent = marriageGui

local proposalFrame = Instance.new("Frame")
proposalFrame.Size = UDim2.new(0, 400, 0, 300)
proposalFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
proposalFrame.BackgroundColor3 = Color3.fromRGB(255, 200, 220)
proposalFrame.BackgroundTransparency = 0.1
proposalFrame.BorderSizePixel = 0
proposalFrame.Parent = marriageGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 20)
frameCorner.Parent = proposalFrame

local heartBg = Instance.new("Frame")
heartBg.Size = UDim2.new(0, 400, 0, 300)
heartBg.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
heartBg.BackgroundTransparency = 0.3
heartBg.Parent = proposalFrame

local heartCorner = Instance.new("UICorner")
heartCorner.CornerRadius = UDim.new(0, 20)
heartCorner.Parent = heartBg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.Position = UDim2.new(0, 0, 0, 20)
title.BackgroundTransparency = 1
title.Text = "💍 PEDIDO ESPECIAL 💍"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.Parent = proposalFrame

local question = Instance.new("TextLabel")
question.Size = UDim2.new(1, 0, 0, 80)
question.Position = UDim2.new(0, 0, 0, 80)
question.BackgroundTransparency = 1
question.Text = "Vivian, você aceita casar comigo?"
question.TextColor3 = Color3.fromRGB(255, 255, 255)
question.TextSize = 20
question.Font = Enum.Font.GothamBold
question.Parent = proposalFrame

local heartEmoji = Instance.new("TextLabel")
heartEmoji.Size = UDim2.new(1, 0, 0, 50)
heartEmoji.Position = UDim2.new(0, 0, 0, 140)
heartEmoji.BackgroundTransparency = 1
heartEmoji.Text = "❤️ 💍 ❤️"
heartEmoji.TextColor3 = Color3.fromRGB(255, 255, 255)
heartEmoji.TextSize = 35
heartEmoji.Font = Enum.Font.GothamBold
heartEmoji.Parent = proposalFrame

local simBtn = Instance.new("TextButton")
simBtn.Size = UDim2.new(0, 120, 0, 50)
simBtn.Position = UDim2.new(0.5, -130, 0, 200)
simBtn.Text = "✅ SIM"
simBtn.TextSize = 18
simBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
simBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
simBtn.BorderSizePixel = 0
simBtn.Font = Enum.Font.GothamBold
simBtn.Parent = proposalFrame

local simCorner = Instance.new("UICorner")
simCorner.CornerRadius = UDim.new(0, 10)
simCorner.Parent = simBtn

local naoBtn = Instance.new("TextButton")
naoBtn.Size = UDim2.new(0, 120, 0, 50)
naoBtn.Position = UDim2.new(0.5, 10, 0, 200)
naoBtn.Text = "❌ NÃO"
naoBtn.TextSize = 18
naoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
naoBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
naoBtn.BorderSizePixel = 0
naoBtn.Font = Enum.Font.GothamBold
naoBtn.Parent = proposalFrame

local naoCorner = Instance.new("UICorner")
naoCorner.CornerRadius = UDim.new(0, 10)
naoCorner.Parent = naoBtn

simBtn.MouseButton1Click:Connect(function()
    marriageGui:Destroy()
    loadHub()
end)

naoBtn.MouseButton1Click:Connect(function()
    crashGame()
end)

function loadHub()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Variaveis de estado
    local autoPet = false
    local autoPlant = false
    local autoMoney = false
    local autoSilver = false
    local autoGolden = false
    local infiniteJump = false
    local speedEnabled = false
    local running = true
    
    local antiAFK = true
    local collectedCache = {}
    local cacheTimeout = 10
    
    local config = {
        moneyDelay = 30,
        walkSpeed = 45
    }
    
    -- ==================== FUNÇÕES AUXILIARES ====================
    local function safeGetChildren(obj)
        if not obj or typeof(obj) ~= "Instance" then
            return {}
        end
        local success, children = pcall(function()
            return obj:GetChildren()
        end)
        if success then
            return children
        end
        return {}
    end
    
    -- Busca recursiva por nome parcial (para Silver)
    local function findRecursive(parent, partialName, results)
        results = results or {}
        local ok, children = pcall(function() return parent:GetChildren() end)
        if not ok then return results end
        for _, obj in ipairs(children) do
            if obj.Name:lower():find(partialName:lower()) then
                if obj:IsA("Model") or obj:IsA("BasePart") then
                    table.insert(results, obj)
                end
            end
            findRecursive(obj, partialName, results)
        end
        return results
    end
    
    -- Pega baús dentro dos TreasureSpawns (Golden)
    local function getGoldenChests()
        local chests = {}
        local hinterlands = workspace:FindFirstChild("Hinterlands")
        if not hinterlands then return chests end
        
        local spawnPoints = hinterlands:FindFirstChild("SpawnPoints")
        if not spawnPoints then return chests end
        
        local treasureChest = spawnPoints:FindFirstChild("TreasureChest")
        if not treasureChest then return chests end
        
        for _, spawn in ipairs(safeGetChildren(treasureChest)) do
            for _, obj in ipairs(safeGetChildren(spawn)) do
                if obj:IsA("Model") or obj:IsA("BasePart") then
                    if not collectedCache[obj] then
                        table.insert(chests, obj)
                    end
                end
            end
        end
        return chests
    end
    
    -- Pega posição do objeto (inteligente)
    local function getPosition(obj)
        local pos = nil
        pcall(function()
            local parent = obj.Parent
            if parent and parent:IsA("BasePart") then
                pos = parent.Position
                return
            end
        end)
        if pos then return pos end
        
        pcall(function()
            if obj:IsA("BasePart") then
                pos = obj.Position
                return
            end
        end)
        if pos then return pos end
        
        pcall(function()
            for _, v in ipairs(obj:GetDescendants()) do
                if v:IsA("BasePart") then
                    pos = v.Position
                    return
                end
            end
        end)
        return pos
    end
    
    -- ==================== BUSCAS ESPECÍFICAS ====================
    local function getAllPets()
        local pets = {}
        local hinterlands = workspace:FindFirstChild("Hinterlands")
        if not hinterlands then return pets end
        
        local spawnPoints = hinterlands:FindFirstChild("SpawnPoints")
        if not spawnPoints then return pets end
        
        local animals = spawnPoints:FindFirstChild("Animals")
        if not animals then return pets end
        
        for _, child in ipairs(safeGetChildren(animals)) do
            if child:IsA("Model") or child:IsA("Part") or child:IsA("MeshPart") then
                if not child.Name:find("Box") and not child.Name:find("Movement") then
                    if not collectedCache[child] then
                        table.insert(pets, child)
                    end
                end
            end
            
            local animalFolder = child:FindFirstChild("Animals")
            if animalFolder then
                for _, pet in ipairs(safeGetChildren(animalFolder)) do
                    if pet:IsA("Model") or pet:IsA("Part") then
                        if not collectedCache[pet] then
                            table.insert(pets, pet)
                        end
                    end
                end
            end
        end
        
        return pets
    end
    
    local function getAllPlants()
        local plants = {}
        local hinterlands = workspace:FindFirstChild("Hinterlands")
        if not hinterlands then return plants end
        
        local spawnPoints = hinterlands:FindFirstChild("SpawnPoints")
        if not spawnPoints then return plants end
        
        local generalSpawn = spawnPoints:FindFirstChild("GeneralSpawnPoints")
        if not generalSpawn then return plants end
        
        for _, child in ipairs(safeGetChildren(generalSpawn)) do
            if child:IsA("Model") or child:IsA("Part") or child:IsA("MeshPart") then
                if child.Name:lower():find("plant") or child.Name:lower():find("mushroom") or 
                   child.Name:lower():find("shroom") or child.Name:lower():find("tomato") or 
                   child.Name:lower():find("carrot") or child.Name:lower():find("leek") or 
                   child.Name:lower():find("cabbage") or child.Name:lower():find("paprika") or 
                   child.Name:lower():find("sunmelon") or child.Name:lower():find("alien") or 
                   child.Name:lower():find("golden") or child.Name:lower():find("mythic") then
                    if not collectedCache[child] then
                        table.insert(plants, child)
                    end
                end
            end
            
            for _, subChild in ipairs(safeGetChildren(child)) do
                if subChild:IsA("Model") or subChild:IsA("Part") or subChild:IsA("MeshPart") then
                    if subChild.Name:lower():find("plant") or subChild.Name:lower():find("mushroom") or 
                       subChild.Name:lower():find("shroom") or subChild.Name:lower():find("tomato") or 
                       subChild.Name:lower():find("carrot") or subChild.Name:lower():find("leek") or 
                       subChild.Name:lower():find("cabbage") or subChild.Name:lower():find("paprika") or 
                       subChild.Name:lower():find("sunmelon") or subChild.Name:lower():find("alien") or 
                       subChild.Name:lower():find("golden") or subChild.Name:lower():find("mythic") then
                        if not collectedCache[subChild] then
                            table.insert(plants, subChild)
                        end
                    end
                end
            end
        end
        
        return plants
    end
    
    local function cleanCache()
        local now = tick()
        for obj, time in pairs(collectedCache) do
            if now - time > cacheTimeout then
                collectedCache[obj] = nil
            end
        end
    end
    
    local function setSpeed()
        if speedEnabled and humanoid then
            humanoid.WalkSpeed = config.walkSpeed
        elseif humanoid then
            humanoid.WalkSpeed = 16
        end
    end
    
    local function onCharacterAdded(newChar)
        character = newChar
        humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        humanoid = character:WaitForChild("Humanoid")
        wait(0.5)
        setSpeed()
    end
    
    local function collectMoney()
        pcall(function()
            local remote = game:GetService("ReplicatedStorage").Remotes.ClaimPassiveIncome
            if remote then
                remote:InvokeServer()
            end
        end)
    end
    
    -- Função de coleta generica
    local function collectObject(obj, holdTime)
        if not obj or not obj.Parent then 
            if obj then collectedCache[obj] = tick() end
            return false 
        end
        
        local objPosition = getPosition(obj)
        
        if not objPosition then 
            collectedCache[obj] = tick()
            return false 
        end
        
        pcall(function()
            humanoidRootPart.CFrame = CFrame.new(objPosition.X, objPosition.Y + 3, objPosition.Z)
        end)
        
        wait(0.5)
        
        pcall(function()
            local VIM = game:GetService("VirtualInputManager")
            VIM:SendKeyEvent(true, "E", false, game)
            wait(holdTime)
            VIM:SendKeyEvent(false, "E", false, game)
        end)
        
        collectedCache[obj] = tick()
        return true
    end
    
    -- Loop principal
    spawn(function()
        local lastMoneyTime = 0
        local petIndex = 1
        local plantIndex = 1
        local pets = {}
        local plants = {}
        
        while running do
            cleanCache()
            
            if autoPet then
                pcall(function()
                    pets = getAllPets()
                    if #pets > 0 then
                        if petIndex > #pets then petIndex = 1 end
                        collectObject(pets[petIndex], 0.05)
                        petIndex = petIndex + 1
                        wait(0.1)
                    end
                end)
            end
            
            if autoPlant then
                pcall(function()
                    plants = getAllPlants()
                    if #plants > 0 then
                        if plantIndex > #plants then plantIndex = 1 end
                        collectObject(plants[plantIndex], 0.05)
                        plantIndex = plantIndex + 1
                        wait(0.1)
                    end
                end)
            end
            
            if autoMoney and tick() - lastMoneyTime > config.moneyDelay then
                pcall(function()
                    collectMoney()
                    lastMoneyTime = tick()
                end)
            end
            
            -- AUTO SILVER (busca recursiva por "silver")
            if autoSilver then
                pcall(function()
                    local silverChests = findRecursive(workspace, "silver")
                    for _, chest in ipairs(silverChests) do
                        if not autoSilver then break end
                        collectObject(chest, 8)
                        wait(1)
                    end
                end)
            end
            
            -- AUTO GOLDEN (baús do TreasureChest)
            if autoGolden then
                pcall(function()
                    local goldenChests = getGoldenChests()
                    for _, chest in ipairs(goldenChests) do
                        if not autoGolden then break end
                        collectObject(chest, 8)
                        wait(1)
                    end
                end)
            end
            
            wait(0.05)
        end
    end)
    
    -- Pulo infinito
    UserInputService.JumpRequest:Connect(function()
        if infiniteJump then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            wait(0.05)
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
    
    -- ==================== GUI ====================
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AutoCollectHub"
    screenGui.ResetOnSpawn = false
    
    local success, guiParent = pcall(function()
        return player:WaitForChild("PlayerGui")
    end)
    
    if not success then
        guiParent = game:GetService("CoreGui")
    end
    
    screenGui.Parent = guiParent
    
    -- Frame principal (altura aumentada para 320)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 320)
    frame.Position = UDim2.new(0, 10, 0, 100)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    frame.ClipsDescendants = true
    
    local frameCorner2 = Instance.new("UICorner")
    frameCorner2.CornerRadius = UDim.new(0, 8)
    frameCorner2.Parent = frame
    
    -- Barra de titulo
    local titleBar2 = Instance.new("Frame")
    titleBar2.Size = UDim2.new(1, 0, 0, 36)
    titleBar2.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    titleBar2.BackgroundTransparency = 0.2
    titleBar2.BorderSizePixel = 0
    titleBar2.Parent = frame
    
    local titleCorner2 = Instance.new("UICorner")
    titleCorner2.CornerRadius = UDim.new(0, 8)
    titleCorner2.Parent = titleBar2
    
    local titleText2 = Instance.new("TextLabel")
    titleText2.Size = UDim2.new(1, -44, 1, 0)
    titleText2.Position = UDim2.new(0, 8, 0, 0)
    titleText2.BackgroundTransparency = 1
    titleText2.Text = "Feito para a Vivian 💍"
    titleText2.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText2.TextSize = 12
    titleText2.Font = Enum.Font.GothamBold
    titleText2.TextXAlignment = Enum.TextXAlignment.Left
    titleText2.Parent = titleBar2
    
    -- Botao minimizar
    local minimized = false
    local expandedHeight = 320
    local collapsedHeight = 36
    
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 30, 0, 28)
    minBtn.Position = UDim2.new(1, -34, 0, 4)
    minBtn.BackgroundTransparency = 1
    minBtn.Text = "❤️"
    minBtn.TextSize = 18
    minBtn.Font = Enum.Font.GothamBold
    minBtn.BorderSizePixel = 0
    minBtn.Parent = titleBar2
    
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            frame.Size = UDim2.new(0, 200, 0, collapsedHeight)
            minBtn.Text = "🤍"
        else
            frame.Size = UDim2.new(0, 200, 0, expandedHeight)
            minBtn.Text = "❤️"
        end
    end)
    
    -- Drag
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local function onDragStart(pos)
        dragging = true
        dragStart = pos
        startPos = frame.Position
    end
    
    local function onDragMove(pos)
        if dragging then
            local delta = pos - dragStart
            local newX = startPos.X.Offset + delta.X
            local newY = startPos.Y.Offset + delta.Y
            frame.Position = UDim2.new(0, newX, 0, newY)
        end
    end
    
    local function onDragEnd()
        dragging = false
    end
    
    titleBar2.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            onDragStart(Vector2.new(input.Position.X, input.Position.Y))
        end
    end)
    
    titleBar2.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            onDragEnd()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            onDragMove(Vector2.new(input.Position.X, input.Position.Y))
        end
    end)
    
    -- Touch mobile
    titleBar2.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            onDragStart(Vector2.new(input.Position.X, input.Position.Y))
        end
    end)
    
    titleBar2.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            onDragEnd()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            onDragMove(Vector2.new(input.Position.X, input.Position.Y))
        end
    end)
    
    -- Linha separadora
    local line2 = Instance.new("Frame")
    line2.Size = UDim2.new(0.9, 0, 0, 1)
    line2.Position = UDim2.new(0.05, 0, 0, 39)
    line2.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    line2.BackgroundTransparency = 0.6
    line2.Parent = frame
    
    -- Checkboxes
    local function createCheckbox(parent, y, text)
        local frameBox = Instance.new("Frame")
        frameBox.Size = UDim2.new(1, -20, 0, 28)
        frameBox.Position = UDim2.new(0, 10, 0, y)
        frameBox.BackgroundTransparency = 1
        frameBox.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 140, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.Parent = frameBox
        
        local check = Instance.new("ImageButton")
        check.Size = UDim2.new(0, 22, 0, 22)
        check.Position = UDim2.new(1, -25, 0.5, -11)
        check.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        check.BackgroundTransparency = 0.3
        check.BorderSizePixel = 0
        check.Parent = frameBox
        
        local checkCorner = Instance.new("UICorner")
        checkCorner.CornerRadius = UDim.new(0, 4)
        checkCorner.Parent = check
        
        local checkImage = Instance.new("ImageLabel")
        checkImage.Size = UDim2.new(1, -4, 1, -4)
        checkImage.Position = UDim2.new(0, 2, 0, 2)
        checkImage.BackgroundTransparency = 1
        checkImage.Image = "rbxassetid://0"
        checkImage.Parent = check
        
        return frameBox, check, checkImage
    end
    
    -- Criando os checkboxes (7 opcoes)
    local _, petCheck, petImage     = createCheckbox(frame, 48,  "Auto Pet")
    local _, plantCheck, plantImage = createCheckbox(frame, 76,  "Auto Plant")
    local _, moneyCheck, moneyImage = createCheckbox(frame, 104, "Auto Money")
    local _, silverCheck, silverImage = createCheckbox(frame, 132, "Auto Silver")
    local _, goldenCheck, goldenImage = createCheckbox(frame, 160, "Auto Golden")
    local _, speedCheck, speedImage = createCheckbox(frame, 188, "Speed")
    local _, jumpCheck, jumpImage   = createCheckbox(frame, 216, "Infinite Jump")
    
    -- Funcoes de atualizacao
    local function updatePet() 
        if autoPet then
            petImage.Image = "rbxassetid://1389151159"
            petCheck.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            petImage.Image = "rbxassetid://0"
            petCheck.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        end
    end
    
    local function updatePlant() 
        if autoPlant then
            plantImage.Image = "rbxassetid://1389151159"
            plantCheck.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            plantImage.Image = "rbxassetid://0"
            plantCheck.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        end
    end
    
    local function updateMoney() 
        if autoMoney then
            moneyImage.Image = "rbxassetid://1389151159"
            moneyCheck.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            moneyImage.Image = "rbxassetid://0"
            moneyCheck.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        end
    end
    
    local function updateSilver() 
        if autoSilver then
            silverImage.Image = "rbxassetid://1389151159"
            silverCheck.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            silverImage.Image = "rbxassetid://0"
            silverCheck.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        end
    end
    
    local function updateGolden() 
        if autoGolden then
            goldenImage.Image = "rbxassetid://1389151159"
            goldenCheck.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            goldenImage.Image = "rbxassetid://0"
            goldenCheck.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        end
    end
    
    local function updateSpeed() 
        if speedEnabled then
            speedImage.Image = "rbxassetid://1389151159"
            speedCheck.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            setSpeed()
        else
            speedImage.Image = "rbxassetid://0"
            speedCheck.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            setSpeed()
        end
    end
    
    local function updateJump() 
        if infiniteJump then
            jumpImage.Image = "rbxassetid://1389151159"
            jumpCheck.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            jumpImage.Image = "rbxassetid://0"
            jumpCheck.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        end
    end
    
    -- Eventos
    petCheck.MouseButton1Click:Connect(function() autoPet = not autoPet updatePet() end)
    plantCheck.MouseButton1Click:Connect(function() autoPlant = not autoPlant updatePlant() end)
    moneyCheck.MouseButton1Click:Connect(function() autoMoney = not autoMoney updateMoney() end)
    silverCheck.MouseButton1Click:Connect(function() autoSilver = not autoSilver updateSilver() end)
    goldenCheck.MouseButton1Click:Connect(function() autoGolden = not autoGolden updateGolden() end)
    speedCheck.MouseButton1Click:Connect(function() speedEnabled = not speedEnabled updateSpeed() end)
    jumpCheck.MouseButton1Click:Connect(function() infiniteJump = not infiniteJump updateJump() end)
    
    player.CharacterAdded:Connect(onCharacterAdded)
    
    print("=========================================")
    print("💍 Hub Carregado - Feito para a Vivian 💍")
    print("🥈 Auto Silver: 8s (busca recursiva)")
    print("💰 Auto Golden: 8s (TreasureChest)")
    print("=========================================")
end

print("=========================================")
print("✅ Jogo verificado: Cook a Recipe")
print("💍 FAÇA O PEDIDO - Aperte SIM")
print("=========================================")
