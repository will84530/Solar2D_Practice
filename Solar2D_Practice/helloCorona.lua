local widget = require("widget")
local composer = require("composer")

local progress = 0
local isRunning = true
local timerStop = false

local rgb = {245/255, 245/255, 220/255}
local factor = 1

local radioLocX = 0.15
local radioLocY = 0.75
local radioOffset = 0.08
local itemLocX = 0.72
local itemLocY = 0.83
local textWidth = 150
local textLocX = 0.45


local function setBackground(rgb, f)
	display.setDefault("background", rgb[1] * f, rgb[2] * f, rgb[3] * factor)
end
setBackground(rgb, factor)

local item = display.newCircle(display.contentWidth * itemLocX, display.contentHeight * itemLocY, 35)
item:setFillColor(1, 0, 0)



-----radioButton------------------------------------
local function onSwitchPress(event)
	item:removeSelf()
	if event.target.id == "RadioButton1" then
		item = display.newCircle(display.contentWidth * itemLocX, display.contentHeight * itemLocY, 35)
	elseif event.target.id == "RadioButton2" then
		item = display.newRoundedRect(display.contentWidth * itemLocX, display.contentHeight * itemLocY, 75, 50, 10)
	elseif event.target.id == "RadioButton3" then
		item = display.newPolygon(display.contentWidth * itemLocX, display.contentHeight * itemLocY, {-30, -35, -30, 35, 40, 0})
	end
	item:setFillColor(1, 0, 0)
end

local radioBtn1 = widget.newSwitch(
	{
		x = display.contentWidth * radioLocX,
		y = display.contentHeight * (radioLocY + radioOffset * 0),
		id = "RadioButton1",
		style = "radio",
		initialSwitchState = true,
		onPress = onSwitchPress
	}
)
local radioBtn2 = widget.newSwitch(
	{
		x = display.contentWidth * radioLocX,
		y = display.contentHeight * (radioLocY + radioOffset * 1),
		id = "RadioButton2",
		style = "radio",
		--initialSwitchState = true,
		onPress = onSwitchPress
	}
)
local radioBtn3 = widget.newSwitch(
	{
		x = display.contentWidth * radioLocX,
		y = display.contentHeight * (radioLocY + radioOffset * 2),
		id = "RadioButton3",
		style = "radio",
		--initialSwitchState = true,
		onPress = onSwitchPress
	}
)

local btnText1 = display.newText(
	{
		text = "Circle",
		x = display.contentWidth * textLocX,
		y = display.contentHeight * (radioLocY + radioOffset * 0),
		fontSize = 20,
		width = textWidth
	}
)
local btnText2 = display.newText(
	{
		text = "Rectangle",
		x = display.contentWidth * textLocX,
		y = display.contentHeight * (radioLocY + radioOffset * 1),
		fontSize = 20,
		width = textWidth
	}
)
local btnText3 = display.newText(
	{
		text = "Triangle",
		x = display.contentWidth * textLocX,
		y = display.contentHeight * (radioLocY + radioOffset * 2),
		fontSize = 20,
		width = textWidth
	}
)
btnText1:setFillColor({ 0, 0, 0 })
btnText2:setFillColor({ 0, 0, 0 })
btnText3:setFillColor({ 0, 0, 0 })

local radioGroup = display.newGroup()
radioGroup:insert(radioBtn1)
radioGroup:insert(radioBtn2)
radioGroup:insert(radioBtn3)


-----checkBtn------------------------------


local function onCheckboxPress(event)
	if event.target.isOn then 
		native.showAlert("Checkbox Event", "Checkmate", { "OK" },
			function (ev)
				if ev.action == "clicked" then checkBtn:setState({isOn = false}) end
			end)
		
	end
end



checkBtn = widget.newSwitch( --If you want to use 'showAlert' function, You Can't declare 'local'.
	{
		x = display.contentWidth * radioLocX,
		y = display.contentHeight * (radioLocY + radioOffset * 3 + 0.03),
		style = "checkbox",
		onPress = onCheckboxPress
	}
)

local checkboxText = display.newText(
	{
		text = "Check Me",
		x = display.contentWidth * textLocX,
		y = display.contentHeight * (radioLocY + radioOffset * 3 + 0.03),
		fontSize = 20,
		width = textWidth
	}
)
checkboxText:setFillColor(0, 0, 0)


-----segmentControl------------------------
local function onSegmentPress(event)
	if event.target.segmentNumber == 1 then rgb = { 245/255, 245/255, 220/255 }
	elseif event.target.segmentNumber == 2 then rgb = { 135/255, 206/255, 235/255 }
	elseif event.target.segmentNumber == 3 then rgb = { 144/255, 238/255, 144/255 }
	end
	setBackground(rgb, factor)
end

local segmentedControl = widget.newSegmentedControl(
	{
		x = display.contentCenterX,
		y = display.contentHeight * 0.18,
		segmentWidth = 80,
		segments = { 'Beige', 'Sky Blue', 'Light Green'},
		defaultSegment = 1,
		onPress = onSegmentPress
	}
)


-----slider-----------------------------------------
local function sliderListener(event)
	if event.phase == "moved" then
		factor = ((100 - event.value) * 0.2 + 80) / 100
		setBackground(rgb, factor)
	end
end

local slider = widget.newSlider(
	{
		x = display.contentCenterX,
		y = display.contentHeight * 0.27,
		width = display.contentWidth * 0.75,
		value = 0,
		listener = sliderListener
	}
)



-----progressView-------------------------------------------

local progressView = widget.newProgressView(
	{
		x = display.contentWidth * 0.47,
		y = display. contentHeight * 0.36,
		width = display.contentWidth * 0.7,
		isAnimated = false
	}
)
progressView:setProgress(progress)


-----button[Run]-------------------------------------------

local function btnProgressListener(event)
	if isRunning and event.phase == "ended" then
		timerStop = false
		timer.performWithDelay(
			50,
			function() 
				if progress < 100 and not timerStop then progress = progress + 1 end
				print(progress)
				progressView:setProgress(progress / 100)
			end,
			0
		)
	end
end

local btnProgress = widget.newButton(
	{
		left = display.contentWidth * 0.12,
		top = display.contentHeight * 0.44,
		label = "Run",
		isEnabled = true,
		onEvent = btnProgressListener,
		shape = "roundedRect",
		width = 100,
		labelColor = {
			default = { 0/255, 0/255, 0/255 },
			over = { 0/255, 0/255, 0/255 }
		},
		fillColor = {
			default = { 180/255, 255/255, 255/255 },
			over = { 110/255, 255/255, 255/255 }
		}
	}
)

-----button[Stop]-------------------------------------------

local function btnProgressListener2(event)
	if isRunning and event.phase == "ended" then
		if not timerStop then
			timerStop = true
			--btnProgress2.text = 'Start'
		else
			timerStop = false
			--btnProgress2.text = 'Stop'
		end
	end		
end

local btnProgress2 = widget.newButton(
	{
		left = display.contentWidth * 0.50,
		top = display.contentHeight * 0.44,
		label = "Stop/Start",
		isEnabled = true,
		onEvent = btnProgressListener2,
		shape = "roundedRect",
		width = 100,
		labelColor = {
			default = { 0/255, 0/255, 0/255 },
			over = { 0/255, 0/255, 0/255 }
		},
		fillColor = {
			default = { 180/255, 255/255, 255/255 },
			over = { 110/255, 255/255, 255/255 }
		}
	}
)



-----onStepperPress--------------------
local function onStepperPress(event)
	if isRunning then
		if event.phase == "increment" then
			progress = progress + 10
		elseif event.phase == "decrement" then
			progress = progress - 10
		end
		progressView:setProgress(progress / 100)
		print(progress)
	end
end

local stepper = widget.newStepper(
	{
		x = display.contentWidth * 0.35,
		y = display.contentHeight * 0.64,
		initialValue = 999,
		--minimumValue = 0,
		--maximumValue = 10,
		onPress = onStepperPress
	}
)


------onOff-----------------------
local function onOffPress(event)
	if event.target.isOn then
		isRunning = false
	else
		isRunning = true
	end
end

local onOff = widget.newSwitch(
	{
		x = display.contentWidth * 0.65,
		y = display.contentHeight * 0.64,
		initialSwitchState = true,
		onPress = onOffPress
	}
)


-----nextBtn---------------------------
local nextBtn = widget.newButton(
	{
		x = display.contentWidth * 0.9,
		y = display.contentHeight * 0,
		label = "Next",
		fontSize = 20,
		emboss = false,
		shape = "roundedRect",
		width = 100,
		labelColr = {
			default = {0, 0, 0},
			over = {0,0,0}
		},
		fillColor = {
			default = {180/255, 1, 1},
			over = {110/255, 1, 1}
		},
		onEvent = function(ev)
			composer.gotoScene("tabBar")
		end
	}
)



-----SecneConfig------------------------

local scene = composer.newScene()

function scene:create(event)
	self.view:insert(radioGroup)
	self.view:insert(btnText1)
	self.view:insert(btnText2)
	self.view:insert(btnText3)
	self.view:insert(checkBtn)
	self.view:insert(checkboxText)
	self.view:insert(segmentedControl)
	self.view:insert(slider)
	self.view:insert(progressView)
	self.view:insert(btnProgress)
	self.view:insert(btnProgress2)
	self.view:insert(stepper)
	self.view:insert(onOff)
	self.view:insert(nextBtn)
	self.view:insert(item)
end

function scene:show(event)
	if(event.phase == "will") then
		self.view.isVisible = true	
		setBackground(rgb, factor)
	end
end

function scene:hide(event)
	if(event.phase == "did") then
		self.view.isVisible = false	
		self.view:insert(item)
	end
end

function scene:destroy(event)
	self.view:removeSelf()	
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene

