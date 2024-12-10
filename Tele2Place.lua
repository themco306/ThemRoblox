-- Lấy các dịch vụ cần thiết
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")  -- Dịch vụ tween
local StarterGui = game:GetService("StarterGui")

local SecondSea = {
    {name = "Cafe", position = Vector3.new(-365, 74, 290)},
    {name = "Dark_Arena", position = Vector3.new(3814, 15, -3548)},
    {name = "Dock_1", position = Vector3.new(-1335, 15, 189)},    
    {name = "Dock_2", position = Vector3.new(-10, 30, 2760)},
    {name = "Dock_3", position = Vector3.new(-2026, 16, -2623)},
    {name = "Lava", position = Vector3.new(-5059, 144, -5308)},
    {name = "Raid", position = Vector3.new(-6520, 251, -4500)},
    {name = "Zomebie", position = Vector3.new(-5869, 421, -405)},
    {name = "Colosseum", position = Vector3.new(-1962, 242, 1748)}
}

-- Tạo GUI cho việc chia màn hình
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Tạo Frame chính để chia giao diện
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.6, 0, 0.6, 0)  -- Thu nhỏ kích thước của frame
mainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)  -- Đặt vị trí của frame
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.Parent = screenGui

-- Tạo Frame bên trái (chứa nút "Ngừng" và "Tốc độ")
local leftFrame = Instance.new("Frame")
leftFrame.Size = UDim2.new(0.4, 0, 1, 0)  -- Thu nhỏ bên trái
leftFrame.Position = UDim2.new(0, 0, 0, 0)
leftFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
leftFrame.Parent = mainFrame

-- Tạo Frame bên phải (chứa các nút bay đến đảo)
local rightFrame = Instance.new("Frame")
rightFrame.Size = UDim2.new(0.6, 0, 1, 0)  -- Thu nhỏ bên phải
rightFrame.Position = UDim2.new(0.4, 0, 0, 0)
rightFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
rightFrame.Parent = mainFrame

-- Tạo nút Ngừng
local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(0, 150, 0, 40)  -- Thu nhỏ nút "Ngừng"
stopButton.Position = UDim2.new(0.5, -75, 0.4, 0)  -- Đặt vị trí nút
stopButton.Text = "Ngừng"
stopButton.Parent = leftFrame

-- Tạo nút Chỉnh Tốc Độ
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 150, 0, 40)  -- Thu nhỏ nút "Tốc độ"
speedButton.Position = UDim2.new(0.5, -75, 0.5, 0)  -- Đặt vị trí nút
speedButton.Text = "Tốc độ: 200"
speedButton.Parent = leftFrame

-- Biến tốc độ bay và tốc độ mặc định
local flightSpeed = 200  -- 50 studs/giây (bạn có thể điều chỉnh giá trị này)

-- Biến để kiểm soát trạng thái bay
local isFlying = false
local currentTween

-- Hàm bay đến vị trí nhập vào
local function flyToTargetPosition(targetPosition)
    isFlying = true
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Tính toán khoảng cách giữa vị trí hiện tại và vị trí đích
    local distance = (humanoidRootPart.Position - targetPosition).Magnitude

    -- Tính toán thời gian di chuyển dựa trên vận tốc
    local travelTime = distance / flightSpeed  -- Thời gian để di chuyển với tốc độ cố định

    -- Tạo Tween thông qua TweenInfo với thời gian di chuyển tính toán
    local tweenInfo = TweenInfo.new(
        travelTime,  -- Thời gian di chuyển tính toán từ khoảng cách và tốc độ
        Enum.EasingStyle.Linear,  -- Phong cách easing (di chuyển mượt mà)
        Enum.EasingDirection.Out,  -- Hướng easing
        0,  -- Không lặp lại
        false,  -- Không quay lại
        0  -- Không trì hoãn
    )

    -- Tạo Tween cho CFrame (vị trí)
    local tweenGoal = {CFrame = CFrame.new(targetPosition)}

    -- Hủy tween hiện tại (nếu có) trước khi tạo tween mới
    if currentTween then
        currentTween:Cancel()
    end

    -- Tạo Tween mới
    currentTween = TweenService:Create(humanoidRootPart, tweenInfo, tweenGoal)

    -- Thực hiện Tween
    currentTween:Play()

    -- In ra vị trí đã di chuyển
    print("Đang bay đến vị trí: " .. tostring(targetPosition))

    -- Kiểm tra khi đến gần vị trí đích (khoảng cách nhỏ hơn 1 stud)
    local checkDistance = 1  -- Khoảng cách ngưỡng để dừng bay
    while isFlying do
        local currentDistance = (humanoidRootPart.Position - targetPosition).Magnitude
        if currentDistance <= checkDistance then
            -- Khi gần đến đích, dừng lại
            stopFlying()
            break
        end
        wait(0.1)  -- Kiểm tra lại mỗi 0.1 giây
    end
end

-- Hàm dừng bay
local function stopFlying()
    if isFlying and currentTween then
        currentTween:Cancel()  -- Dừng tween
        isFlying = false  -- Đánh dấu là không còn bay
        print("Dừng bay")
    end
end

-- Hàm thay đổi tốc độ bay
local function changeSpeed()
    if flightSpeed == 200 then
        flightSpeed = 300
        speedButton.Text = "Tốc độ: 300"
    elseif flightSpeed == 300 then
        flightSpeed = 400
        speedButton.Text = "Tốc độ: 400"
    else
        flightSpeed = 200
        speedButton.Text = "Tốc độ: 200"
    end

    -- Khi thay đổi tốc độ, hủy tween hiện tại và tạo lại một tween mới với tốc độ mới
    if isFlying then
        stopFlying()
        flyToTargetPosition(targetPosition)  -- Bắt đầu lại quá trình bay với tốc độ mới
    end
end

-- Lắng nghe sự kiện nhấn nút Ngừng
stopButton.MouseButton1Click:Connect(stopFlying)

-- Lắng nghe sự kiện nhấn nút Chỉnh Tốc Độ
speedButton.MouseButton1Click:Connect(changeSpeed)

-- Tạo nút Ẩn/Hiện màn hình (nút này nằm ngoài mainFrame)
local toggleVisibilityButton = Instance.new("TextButton")
toggleVisibilityButton.Size = UDim2.new(0, 150, 0, 40)
toggleVisibilityButton.Position = UDim2.new(0.6, -75, 0.8, 0)  -- Đặt vị trí nút bên ngoài mainFrame
toggleVisibilityButton.Text = "Tele2Place"
toggleVisibilityButton.Parent = screenGui  -- Thêm nút vào screenGui chứ không phải vào mainFrame

-- Lắng nghe sự kiện nhấn nút Ẩn/Hiện
toggleVisibilityButton.MouseButton1Click:Connect(function()
    if mainFrame.Visible then
        mainFrame.Visible = false  -- Ẩn màn hình
    else
        mainFrame.Visible = true  -- Hiện màn hình
    end
end)

-- Tạo các nút để bay đến các đảo từ mảng SecondSea
local function createIslandButtons()
    local buttonHeight = 40  -- Thu nhỏ chiều cao của mỗi nút
    local startPositionY = 0  -- Vị trí Y bắt đầu của nút đầu tiên

    for i, island in ipairs(SecondSea) do
        local teleportButton = Instance.new("TextButton")
        teleportButton.Size = UDim2.new(0, 150, 0, buttonHeight)  -- Thu nhỏ kích thước nút
        teleportButton.Position = UDim2.new(0.5, -75, 0, startPositionY + (i - 1) * (buttonHeight + 10))  -- Đặt vị trí các nút
        teleportButton.Text = "Bay đến " .. island.name
        teleportButton.Parent = rightFrame
        teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        teleportButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)

        -- Lắng nghe sự kiện nhấn nút Bay đến đảo
        teleportButton.MouseButton1Click:Connect(function()
            local targetPosition = island.position
            flyToTargetPosition(targetPosition)  -- Lấy tọa độ của đảo và bay đến đó
        end)
    end
end

createIslandButtons()
