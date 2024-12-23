local player = game.Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local mouse = player:GetMouse()

-- Tọa độ đảo
local SecondSea = {
    {name = "Cafe", position = Vector3.new(-365, 74, 290)},
    {name = "Dock_2", position = Vector3.new(-10, 30, 2760)}
}
-- Tạo GUI chính
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Tạo cửa sổ chính
local mainWindow = Instance.new("Frame")
mainWindow.Size = UDim2.new(0.4, 0, 0.5, 0)
mainWindow.Position = UDim2.new(0.3, 0, 0.25, 0)
mainWindow.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainWindow.Active = true
mainWindow.Draggable = true
mainWindow.Parent = screenGui

-- Tạo thanh tiêu đề
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0.1, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.Parent = mainWindow

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.9, 0, 1, 0)
titleLabel.Text = "Menu Chính"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = titleBar

-- Nút thu gọn/mở rộng
local toggleCollapseButton = Instance.new("TextButton")
toggleCollapseButton.Size = UDim2.new(0.1, 0, 1, 0)
toggleCollapseButton.Position = UDim2.new(0.9, 0, 0, 0)
toggleCollapseButton.Text = "+"
toggleCollapseButton.Font = Enum.Font.SourceSansBold
toggleCollapseButton.TextSize = 18
toggleCollapseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleCollapseButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleCollapseButton.Parent = titleBar

-- Sidebar cho các tab
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0.2, 0, 0.9, 0)
sidebar.Position = UDim2.new(0, 0, 0.1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sidebar.Parent = mainWindow

-- Nội dung chính
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0.8, 0, 0.9, 0)
contentFrame.Position = UDim2.new(0.2, 0, 0.1, 0)
contentFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
contentFrame.Parent = mainWindow

-- Tạo các tab
local tabs = {"Tăng Kích Thước", "Tele2Place", "Tele2Player"}
local buttons = {}
local currentTab = nil

for i, tabName in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, 0, 0.1, 0)
    tabButton.Position = UDim2.new(0, 0, (i - 1) * 0.1, 0)
    tabButton.Text = tabName
    tabButton.Font = Enum.Font.SourceSans
    tabButton.TextSize = 16
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    tabButton.Parent = sidebar
    buttons[tabName] = tabButton
end

-- Tạo nội dung cho các tab
local tabContents = {}

local function createTabContent(tabName, content)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = contentFrame

    -- Thêm nội dung vào tab
    for _, child in ipairs(content) do
        child.Parent = frame
    end

    tabContents[tabName] = frame
end

-- Hàm thay đổi kích thước nhân vật
local function changeSize(character, scale)
    if scale and scale > 0 then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Size = part.Size * scale
            end
        end
        print("Kích thước đã thay đổi:", scale)
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Lỗi",
            Text = "Giá trị không hợp lệ!",
            Duration = 3
        })
    end
end

-- Lưu kích thước ban đầu
local originalSize = {}
local function saveOriginalSize(character)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            originalSize[part.Name] = part.Size
        end
    end
end

local function resetSize(character)
    for partName, size in pairs(originalSize) do
        local part = character:FindFirstChild(partName)
        if part then
            part.Size = size
        end
    end
    print("Kích thước đã được reset về ban đầu.")
end

-- Hàm bật/tắt teleport
local teleportEnabled = false
local isAltHeld = false

local function toggleTeleport()
    teleportEnabled = not teleportEnabled
    if teleportEnabled then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Teleport Enabled",
            Text = "Alt + Click to Teleport.",
            Duration = 3
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Teleport Disabled",
            Text = "Teleport is now disabled.",
            Duration = 3
        })
    end
end

-- Teleport đến vị trí chuột
local function teleportToMouse()
    if teleportEnabled then
        local mousePosition = mouse.Hit.p
        local characterPosition = player.Character.HumanoidRootPart.Position
        local distance = (mousePosition - characterPosition).Magnitude

        if distance <= 200 then
            player.Character:SetPrimaryPartCFrame(CFrame.new(mousePosition))
        else
            local direction = (mousePosition - characterPosition).unit
            local limitedPosition = characterPosition + direction * 200
            player.Character:SetPrimaryPartCFrame(CFrame.new(limitedPosition))
        end
    end
end

-- Lắng nghe sự kiện khi giữ phím Alt và nhấn chuột
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.LeftAlt then
        isAltHeld = true
    end

    if isAltHeld and input.UserInputType == Enum.UserInputType.MouseButton1 then
        teleportToMouse()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.LeftAlt then
        isAltHeld = false
    end
end)

-- Nội dung Tab 1: Tăng Kích Thước
local sizeInput = Instance.new("TextBox")
sizeInput.Size = UDim2.new(0.5, 0, 0, 50)
sizeInput.Position = UDim2.new(0.25, 0, 0.1, 0)
sizeInput.Text = "2"
sizeInput.Font = Enum.Font.SourceSans
sizeInput.TextSize = 18
sizeInput.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
sizeInput.TextColor3 = Color3.fromRGB(255, 255, 255)

local saveButton = Instance.new("TextButton")
saveButton.Size = UDim2.new(0.3, 0, 0, 50)
saveButton.Position = UDim2.new(0.1, 0, 0.3, 0)
saveButton.Text = "Lưu"
saveButton.Font = Enum.Font.SourceSansBold
saveButton.TextSize = 18
saveButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
saveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveButton.MouseButton1Click:Connect(function()
    local scale = tonumber(sizeInput.Text)
    changeSize(player.Character, scale)
end)

local resetButton = Instance.new("TextButton")
resetButton.Size = UDim2.new(0.3, 0, 0, 50)
resetButton.Position = UDim2.new(0.6, 0, 0.3, 0)
resetButton.Text = "Reset"
resetButton.Font = Enum.Font.SourceSansBold
resetButton.TextSize = 18
resetButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resetButton.MouseButton1Click:Connect(function()
    resetSize(player.Character)
end)

-- Nội dung Tab 2: Teleport
local toggleTeleportButton = Instance.new("TextButton")
toggleTeleportButton.Size = UDim2.new(0.3, 0, 0, 50)
toggleTeleportButton.Position = UDim2.new(0.1, 0, 0.1, 0)
toggleTeleportButton.Text = "Toggle Teleport"
toggleTeleportButton.Font = Enum.Font.SourceSansBold
toggleTeleportButton.TextSize = 18
toggleTeleportButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleTeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleTeleportButton.MouseButton1Click:Connect(toggleTeleport)

toggleTeleportButton.MouseButton1Click:Connect(function()
    if toggleTeleportButton.BackgroundColor3 == Color3.fromRGB(255, 0, 0) then
        toggleTeleportButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60) -- Đổi thành xanh khi bấm
    else
        toggleTeleportButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Đổi lại thành đỏ nếu đã xanh
    end
end)
-- Nội dung Tab 3: Chưa có nội dung

createTabContent("Tăng Kích Thước", {sizeInput, saveButton, resetButton})
createTabContent("Tele2Place", {toggleTeleportButton})
createTabContent("Tele2Player", {})

-- Chuyển tab
local function switchTab(tabName)
    if currentTab then
        tabContents[currentTab].Visible = false
    end
    tabContents[tabName].Visible = true
    currentTab = tabName
end

for tabName, button in pairs(buttons) do
    button.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
end

switchTab("Tăng Kích Thước")

-- Thu gọn/mở rộng
local isCollapsed = false
toggleCollapseButton.MouseButton1Click:Connect(function()
    isCollapsed = not isCollapsed
    sidebar.Visible = not isCollapsed
    contentFrame.Visible = not isCollapsed
    toggleCollapseButton.Text = isCollapsed and "+" or "-"
    mainWindow.Size = isCollapsed and UDim2.new(0.4, 0, 0.1, 0) or UDim2.new(0.4, 0, 0.5, 0)
end)

-- Lắng nghe sự kiện CharacterAdded
player.CharacterAdded:Connect(function(character)
    -- Cập nhật lại các tham chiếu khi nhân vật tái sinh
    saveOriginalSize(character)
    changeSize(character, 2) -- Tăng kích thước mặc định sau khi tái sinh
end)

-- Cập nhật khi nhân vật đã tồn tại ban đầu
if player.Character then
    saveOriginalSize(player.Character)
end
