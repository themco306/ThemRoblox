game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Script Loaded";
    Text = "Khanh ne";
    Duration = 20;
})

local StarterGui = Instance.new("ScreenGui") 
local Frame = Instance.new("Frame") 
local UICorner = Instance.new("UICorner") 
local TextButton = Instance.new("TextButton") 
local UICorner_2 = Instance.new("UICorner") 
local TextButton_2 = Instance.new("TextButton") 
local UICorner_3 = Instance.new("UICorner") 
local TextLabel = Instance.new("TextLabel") 
local TextBox = Instance.new("TextBox") 
local UICorner_4 = Instance.new("UICorner") 
local TextLabel_2 = Instance.new("TextLabel") 
local TextButton_3 = Instance.new("TextButton") 
local UICorner_5 = Instance.new("UICorner")

-- Setup UI
StarterGui.Name = "StarterGui" 
StarterGui.Parent = game.CoreGui 
StarterGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = StarterGui 
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) 
Frame.BorderColor3 = Color3.fromRGB(255, 0, 0) 
Frame.Position = UDim2.new(0.219810039, 0, 0.233396575, 0) 
Frame.Size = UDim2.new(0.560379922, 0, 0.527514219, 0) 
Frame.Visible = false 
Frame.Active = true 
Frame.Draggable = true

UICorner.Parent = Frame

TextButton.Parent = Frame 
TextButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) 
TextButton.Position = UDim2.new(0.0895883814, 0, 0.712230206, 0) 
TextButton.Size = UDim2.new(0.343825668, 0, 0.172661871, 0) 
TextButton.Font = Enum.Font.Cartoon 
TextButton.Text = "Cancel" 
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255) 
TextButton.TextScaled = true 
TextButton.TextSize = 14.000 
TextButton.TextWrapped = true

UICorner_2.Parent = TextButton

TextButton_2.Parent = Frame 
TextButton_2.BackgroundColor3 = Color3.fromRGB(25, 255, 0) 
TextButton_2.Position = UDim2.new(0.544794202, 0, 0.712230206, 0) 
TextButton_2.Size = UDim2.new(0.343825668, 0, 0.172661871, 0) 
TextButton_2.Font = Enum.Font.Cartoon 
TextButton_2.Text = "Set" 
TextButton_2.TextColor3 = Color3.fromRGB(255, 255, 255) 
TextButton_2.TextScaled = true 
TextButton_2.TextSize = 14.000 
TextButton_2.TextWrapped = true

UICorner_3.Parent = TextButton_2

TextLabel.Parent = Frame 
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
TextLabel.BackgroundTransparency = 1.000 
TextLabel.Size = UDim2.new(1, 0, 0.179856122, 0) 
TextLabel.Font = Enum.Font.Cartoon 
TextLabel.Text = "Set Walk Speed" 
TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0) 
TextLabel.TextScaled = true 
TextLabel.TextSize = 14.000 
TextLabel.TextWrapped = true

TextBox.Parent = Frame 
TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
TextBox.Position = UDim2.new(0.256658584, 0, 0.323741019, 0) 
TextBox.Size = UDim2.new(0.484261513, 0, 0.179856122, 0) 
TextBox.Font = Enum.Font.Cartoon 
TextBox.PlaceholderText = "Enter Walk Speed" 
TextBox.Text = "16" 
TextBox.TextColor3 = Color3.fromRGB(97, 97, 97) 
TextBox.TextScaled = true 
TextBox.TextSize = 14.000 
TextBox.TextWrapped = true

UICorner_4.Parent = TextBox

TextLabel_2.Parent = TextBox 
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
TextLabel_2.BackgroundTransparency = 1.000 
TextLabel_2.Position = UDim2.new(0.0765053779, 0, 1, 0) 
TextLabel_2.Size = UDim2.new(0, 106, 0, 27) 
TextLabel_2.Font = Enum.Font.Cartoon 
TextLabel_2.Text = "Numbers only" 
TextLabel_2.TextColor3 = Color3.fromRGB(255, 0, 0) 
TextLabel_2.TextScaled = true 
TextLabel_2.TextSize = 14.000 
TextLabel_2.TextWrapped = true

TextButton_3.Parent = StarterGui 
TextButton_3.BackgroundColor3 = Color3.fromRGB(0, 0, 0) 
TextButton_3.BorderColor3 = Color3.fromRGB(255, 0, 0) 
TextButton_3.Position = UDim2.new(-0.000928521913, 0, 0.488205522, 0) 
TextButton_3.Size = UDim2.new(0, 85, 0, 37) 
TextButton_3.Font = Enum.Font.Cartoon 
TextButton_3.Text = "Set Speed" 
TextButton_3.TextColor3 = Color3.fromRGB(255, 0, 0) 
TextButton_3.TextScaled = true 
TextButton_3.TextSize = 14.000 
TextButton_3.TextWrapped = true

UICorner_5.Parent = TextButton_3

-- Scripts:

local function CHCRPGN_fake_script() -- TextButton.LocalScript 
    local script = Instance.new('LocalScript', TextButton)
    script.Parent.MouseButton1Click:Connect(function()
        script.Parent.Parent.Visible = false
    end)
end
coroutine.wrap(CHCRPGN_fake_script)()

local function YDDLQYT_fake_script() -- TextButton_2.LocalScript 
    local script = Instance.new('LocalScript', TextButton_2)
    local player = game.Players.LocalPlayer

    script.Parent.MouseButton1Click:Connect(function()
        wait(0.6)
        local walkSpeed = tonumber(script.Parent.Parent.TextBox.Text)
        
        if walkSpeed and walkSpeed > 0 then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
            script.Parent.Parent.Visible = false
        else
            -- Thông báo lỗi nếu giá trị không hợp lệ
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "Invalid Input";
                Text = "Please enter a valid number for Walk Speed!";
                Duration = 3;
            })
        end
    end)
end
coroutine.wrap(YDDLQYT_fake_script)()

local function RZIFDD_fake_script() -- Frame.LocalScript 
    local script = Instance.new('LocalScript', Frame)
    local Frame = script.Parent
    Frame.Active = true
    Frame.Draggable = true
end
coroutine.wrap(RZIFDD_fake_script)()

local function RZJF_fake_script() -- TextButton_3.LocalScript 
    local script = Instance.new('LocalScript', TextButton_3)
    script.Parent.MouseButton1Click:Connect(function()
        script.Parent.Parent.Frame.Visible = true
    end)
end
coroutine.wrap(RZJF_fake_script)()
