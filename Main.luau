-- Atlas Access UI (Clean Rewrite + Hover Buttons + PC Toggle)
-- Part 1/4
-- Core UI + Animation + Dragging + Toggle

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local GROUP_ID = 33500299


------------------------------------------------
-- SCREEN GUI
------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "AtlasAccess"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")



------------------------------------------------
-- HELPERS
------------------------------------------------

local function addCorner(parent, radius)

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,radius)
	corner.Parent = parent

	return corner

end



local function addStroke(parent,color,thickness)

	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness
	stroke.Parent = parent

	return stroke

end



------------------------------------------------
-- MAIN PANEL
------------------------------------------------

local panel = Instance.new("Frame")

panel.Name = "MainPanel"
panel.Size = UDim2.new(0,600,0,330)
panel.Position = UDim2.new(0.5,-300,0.5,-165)
panel.BackgroundColor3 = Color3.fromRGB(25,25,32)
panel.BorderSizePixel = 0
panel.Active = true
panel.ClipsDescendants = true
panel.Parent = gui


addCorner(panel,20)

addStroke(
	panel,
	Color3.fromRGB(75,150,255),
	2
)



------------------------------------------------
-- ANIMATED STAR BACKGROUND
------------------------------------------------

local starContainer = Instance.new("Frame")

starContainer.Size = UDim2.new(1,0,1,0)
starContainer.BackgroundTransparency = 1
starContainer.ClipsDescendants = true
starContainer.ZIndex = 1
starContainer.Parent = panel



local function createStar()

	local star = Instance.new("Frame")

	star.Size = UDim2.new(0,2,0,35)
	star.BackgroundColor3 = Color3.fromRGB(120,190,255)
	star.BorderSizePixel = 0
	star.Rotation = -45
	star.ZIndex = 1
	star.Parent = starContainer


	local x = math.random(-50,550)
	local y = math.random(-50,300)


	star.Position = UDim2.new(
		0,
		x,
		0,
		y
	)


	local gradient = Instance.new("UIGradient")

	gradient.Transparency = NumberSequence.new({

		NumberSequenceKeypoint.new(0,1),
		NumberSequenceKeypoint.new(.3,0),
		NumberSequenceKeypoint.new(1,1)

	})

	gradient.Parent = star



	local tween = TweenService:Create(

		star,

		TweenInfo.new(
			1.5,
			Enum.EasingStyle.Linear
		),

		{

			Position = UDim2.new(
				0,
				x + 150,
				0,
				y + 150
			),

			BackgroundTransparency = 1

		}

	)


	tween:Play()


	tween.Completed:Connect(function()

		star:Destroy()

	end)

end



task.spawn(function()

	while panel.Parent do

		if #starContainer:GetChildren() < 5 then

			createStar()

		end


		task.wait(.7)

	end

end)



------------------------------------------------
-- DRAGGING
------------------------------------------------

local dragging = false
local dragStart
local startPosition



panel.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then


		dragging = true

		dragStart = input.Position

		startPosition = panel.Position


	end

end)

------------------------------------------------
-- DRAGGING CONTINUED
------------------------------------------------

UserInputService.InputChanged:Connect(function(input)

	if dragging and
	(input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch) then


		local delta = input.Position - dragStart


		panel.Position = UDim2.new(

			startPosition.X.Scale,

			startPosition.X.Offset + delta.X,

			startPosition.Y.Scale,

			startPosition.Y.Offset + delta.Y

		)

	end

end)



UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging = false

	end

end)



------------------------------------------------
-- TOGGLE FUNCTION
------------------------------------------------

local opened = true


local function toggleUI()

	opened = not opened

	panel.Visible = opened

end



------------------------------------------------
-- PC RIGHT SHIFT TOGGLE
------------------------------------------------

if UserInputService.KeyboardEnabled then

	UserInputService.InputBegan:Connect(function(input, processed)

		if processed then
			return
		end


		if input.KeyCode == Enum.KeyCode.RightShift then

			toggleUI()

		end

	end)

end



------------------------------------------------
-- PC TOGGLE HINT
------------------------------------------------

if UserInputService.KeyboardEnabled then

	local hint = Instance.new("TextLabel")

	hint.Size = UDim2.new(0,300,0,25)
	hint.Position = UDim2.new(1,-330,1,-25)
	hint.BackgroundTransparency = 1
	hint.Text = "Press Right Shift to toggle UI"
	hint.TextColor3 = Color3.fromRGB(170,170,170)
	hint.Font = Enum.Font.Gotham
	hint.TextSize = 14
	hint.ZIndex = 10
	hint.Parent = gui

end



------------------------------------------------
-- MOBILE A BUTTON
------------------------------------------------

if UserInputService.TouchEnabled then


	local toggle = Instance.new("TextButton")

	toggle.Size = UDim2.new(0,55,0,55)
	toggle.Position = UDim2.new(0,20,.5,-27)
	toggle.BackgroundColor3 = Color3.fromRGB(31,31,34)
	toggle.Text = "A"
	toggle.TextColor3 = Color3.fromRGB(75,150,255)
	toggle.Font = Enum.Font.GothamBold
	toggle.TextSize = 25
	toggle.Active = true
	toggle.ZIndex = 20
	toggle.Parent = gui


	addCorner(toggle,100)

	addStroke(
		toggle,
		Color3.fromRGB(75,150,255),
		2
	)



	toggle.Activated:Connect(function()

		toggleUI()

	end)


end



------------------------------------------------
-- TITLE
------------------------------------------------

local title = Instance.new("TextLabel")

title.Size = UDim2.new(1,-50,0,45)
title.Position = UDim2.new(0,30,0,20)
title.BackgroundTransparency = 1
title.Text = "Atlas Access"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 34
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 5
title.Parent = panel



------------------------------------------------
-- SUBTITLE
------------------------------------------------

local subtitle = Instance.new("TextLabel")

subtitle.Size = UDim2.new(1,-50,0,25)
subtitle.Position = UDim2.new(0,30,0,65)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Official Atlas Scripting Group Verification"
subtitle.TextColor3 = Color3.fromRGB(160,160,160)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 16
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 5
subtitle.Parent = panel

------------------------------------------------
-- DEFAULT STATUS
------------------------------------------------

local defaultText =
	"Atlas Scripting Group membership not detected."


local function resetStatus()

	status.Text = defaultText

	status.TextColor3 =
		Color3.new(1,1,1)


	dot.BackgroundColor3 =
		Color3.fromRGB(
			255,
			170,
			25
		)

end



------------------------------------------------
-- VERIFY SYSTEM
------------------------------------------------

local errorTimer


verify.Activated:Connect(function()


	local success,result = pcall(function()

		return player:IsInGroup(GROUP_ID)

	end)



	if success and result then


		status.Text =
			"Atlas Scripting Group membership verified!"


		status.TextColor3 =
			Color3.fromRGB(
				80,
				255,
				120
			)


		dot.BackgroundColor3 =
			Color3.fromRGB(
				80,
				255,
				120
			)



	else


		status.Text =
			"Error: Not in Atlas Scripting Group."


		status.TextColor3 =
			Color3.fromRGB(
				255,
				90,
				90
			)


		dot.BackgroundColor3 =
			Color3.fromRGB(
				255,
				90,
				90
			)



		if errorTimer then

			task.cancel(errorTimer)

		end



		errorTimer = task.delay(
			4,
			function()

				resetStatus()

			end
		)



	end


end)



------------------------------------------------
-- JOIN GROUP BUTTON
------------------------------------------------

join.Activated:Connect(function()


	if errorTimer then

		task.cancel(errorTimer)

	end



	resetStatus()



	status.Text =
		"Opening Atlas Scripting Group..."


	status.TextColor3 =
		Color3.fromRGB(
			255,
			255,
			255
		)



	-- Opens Roblox group invite prompt

	pcall(function()

		game:GetService("SocialService"):PromptGroupInvitation(
			player,
			GROUP_ID
		)

	end)



	-- Notification

	pcall(function()

		game:GetService("StarterGui"):SetCore(
			"SendNotification",
			{

				Title = "Atlas Access",

				Text = "Join the Atlas Scripting Group, then press Verify Membership.",

				Duration = 5

			}

		)

	end)


end)

------------------------------------------------
-- FINAL UI SETTINGS
------------------------------------------------

-- Keeps panel above other UI elements

panel.ZIndex = 1


-- Makes sure buttons stay clickable

join.Active = true
verify.Active = true



------------------------------------------------
-- OPTIONAL CLEANUP
------------------------------------------------

-- Prevents duplicate UI if script is reloaded

gui.AncestryChanged:Connect(function()

	if not gui.Parent then

		gui:Destroy()

	end

end)



------------------------------------------------
-- SCRIPT LOADED
------------------------------------------------

print("Atlas Access UI Loaded Successfully")
print("Group ID:", GROUP_ID)
