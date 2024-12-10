-- Lấy các dịch vụ cần thiết fly to player
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

-- Tạo GUI cho việc nhập tên người chơi
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Tạo TextBox để nhập tên người chơi
local playerNameInput = Instance.new("TextBox")
playerNameInput.Size = UDim2.new(0, 300, 0, 50)
playerNameInput.Position = UDim2.new(0.5, -150, 0.5, -25)
playerNameInput.Text = "Nhập tên người chơi"
playerNameInput.Visible = false  -- Ẩn TextBox ban đầu
playerNameInput.Parent = screenGui

-- Tạo nút Bay
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 200, 0, 50)
flyButton.Position = UDim2.new(0.5, -100, 0.5, 25)
flyButton.Text = "Bay đến"
flyButton.Visible = false  -- Ẩn nút Bay ban đầu
flyButton.Parent = screenGui

-- Tạo nút Ngừng
local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(0, 200, 0, 50)
stopButton.Position = UDim2.new(0.5, -100, 0.6, 25)
stopButton.Text = "Ngừng"
stopButton.Visible = false  -- Ẩn nút Ngừng ban đầu
stopButton.Parent = screenGui

-- Tạo nút chỉnh tốc độ
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 200, 0, 50)
speedButton.Position = UDim2.new(0.5, -100, 0.7, 25)
speedButton.Text = "Tốc độ: 200"
speedButton.Visible = false  -- Ẩn nút Chỉnh tốc độ ban đầu
speedButton.Parent = screenGui

-- Tạo nút Tele2Player
local teleButton = Instance.new("TextButton")
teleButton.Size = UDim2.new(0, 150, 0, 40)
teleButton.Position = UDim2.new(0.4, -75, 0.8, 0)
teleButton.Text = "Tele2Player"
teleButton.Parent = screenGui

-- Biến tốc độ bay và tốc độ mặc định
local flightSpeed = 200  -- 50 studs/giây (bạn có thể điều chỉnh giá trị này)

-- Biến để kiểm soát trạng thái bay
local isFlying = false
local currentTween

-- Biến để kiểm soát trạng thái hiển thị GUI
local isGuiVisible = false

-- Biến để kiểm soát trạng thái kéo nút
local dragging = false
local dragStart = nil
local startPos = nil

-- Hàm bay đến người chơi
local function flyToPlayerByName()
    isFlying = true

    local inputText = playerNameInput.Text:lower()  -- Lấy tên nhập vào và chuyển thành chữ thường

    -- Tìm người chơi có tên bắt đầu với inputText
    local targetPlayer = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #inputText) == inputText then
            targetPlayer = p
            break  -- Dừng vòng lặp khi tìm thấy người chơi đầu tiên
        end
    end

    -- Nếu tìm thấy người chơi
    if targetPlayer then
        local targetCharacter = targetPlayer.Character
        if targetCharacter then
            local targetPosition = targetCharacter:WaitForChild("HumanoidRootPart").Position
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

            -- In ra thông tin người chơi đã bay đến
            print("Đang bay đến người chơi: " .. targetPlayer.Name)

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
        else
            -- Nếu người chơi không có character
            StarterGui:SetCore("SendNotification", {
                Title = "Lỗi",
                Text = "Người chơi không có nhân vật hiện tại.",
                Duration = 3
            })
        end
    else
        -- Nếu không tìm thấy người chơi
        StarterGui:SetCore("SendNotification", {
            Title = "Lỗi",
            Text = "Không tìm thấy người chơi có tên bắt đầu bằng \"" .. inputText .. "\".",
            Duration = 3
        })
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
        flyToPlayerByName()  -- Bắt đầu lại quá trình bay với tốc độ mới
    end
end

-- Hàm ẩn hoặc hiện tất cả các đối tượng GUI
local function toggleAllGUI()
    if isGuiVisible then
        -- Ẩn tất cả các đối tượng
        playerNameInput.Visible = false
        flyButton.Visible = false
        stopButton.Visible = false
        speedButton.Visible = false
    else
        -- Hiện tất cả các đối tượng
        playerNameInput.Visible = true
        flyButton.Visible = true
        stopButton.Visible = true
        speedButton.Visible = true
    end

    -- Đảo ngược trạng thái hiển thị
    isGuiVisible = not isGuiVisible
end

-- Lắng nghe sự kiện nhấn nút Tele2Player
teleButton.MouseButton1Click:Connect(toggleAllGUI)

-- Lắng nghe sự kiện nhấn nút Bay
flyButton.MouseButton1Click:Connect(flyToPlayerByName)

-- Lắng nghe sự kiện nhấn nút Ngừng
stopButton.MouseButton1Click:Connect(stopFlying)

-- Lắng nghe sự kiện nhấn nút Chỉnh Tốc Độ
speedButton.MouseButton1Click:Connect(changeSpeed)

-- Xử lý sự kiện kéo chuột (di chuyển nút Tele2Player)
teleButton.MouseButton1Down:Connect(function(input)
    dragging = true
    dragStart = input.Position
    startPos = teleButton.Position
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        teleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
