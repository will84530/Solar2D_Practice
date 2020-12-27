local widget = require("widget")
local composer = require("composer")


-----pickerWheel Page----------------------

local color = {}
color.red = {1, 0, 0}
color.orange = {1, 165/255, 0}
color.yellow = {1, 1, 0}
color.green = {0, 1, 0}
color.blue = {0, 0, 1}
color.purple = {128/255, 0, 128/255}

local sizeCircle = {}
sizeCircle.small = 30
sizeCircle.medium = 40
sizeCircle.large = 50

local sizeRect = {}
sizeRect.small = {60, 36}
sizeRect.medium = {80, 48}
sizeRect.large = {100, 60}

local sizeTriangle = {}
sizeTriangle.small = {-20, -25, -20, 25, 30, 0}
sizeTriangle.medium = {-30, -35, -30, 35, 40, 0}
sizeTriangle.large = {-40, -45, -40, 45, 50, 0}

local size = {}
size.circle = sizeCircle
size.rectangle = sizeRect
size.triangle = sizeTriangle

local itemLocX = 0.5
local itemLocY = 0.2

local sizes = { "small", "medium", "large" }
local colors = { "red", "orange", "yellow", "green", "blue", "purple" }
local shapes = { "circle", "rectangle", "triangle" }

local Group1 = display.newGroup()
--local item = display.newCircle(display.contentWidth * itemLocX, display.contentHeight * itemLocY, sizeCircle.medium)
--item:setFillColor(color.orange[1], color.orange[2], color.orange[3])

local function getShape(options)
	local item
	if options.shape == "circle" then item = display.newCircle(options.x , options.y, size[options.shape][options.size])
	elseif options.shape == "rectangle" then item = display.newRoundedRect(options.x , options.y, size[options.shape][options.size][1], size[options.shape][options.size][2], 10)
	elseif options.shape == "triangle" then item = display.newPolygon(options.x , options.y, 
		{ size[options.shape][options.size][1], size[options.shape][options.size][2], size[options.shape][options.size][3],
		  size[options.shape][options.size][4], size[options.shape][options.size][5], size[options.shape][options.size][6] }
	)end
	item:setFillColor(color[options.color][1], color[options.color][2], color[options.color][3])
	return item
end

local function getIndex(list, item) 
	for i = 1, #list do
		if item == list[i] then
			return i
		end
	end
end

local mySize = system.getPreference("app", "mySize") -- save system
if mySize == nil then
	mySize = "medium"
end
local myColor = system.getPreference("app", "myColor")
if myColor == nil then
	myColor = "orange"
end
local myShape = system.getPreference("app", "myShape")
if myShape == nil then
	myShape = "circle"
end

local item = getShape({
	x = display.contentWidth * itemLocX,
	y = display.contentHeight * itemLocY,
	size = mySize,
	color = myColor,
	shape = myShape
})

local columnData = {
	{
		align = "left",
		width = 100,
		startIndex = getIndex(sizes, mySize),
		labels = { "small", "medium", "large" }
	},
	{
		align = "left",
		width = 110,
		startIndex = getIndex(colors, myColor),
		labels = { "red", "orange", "yellow", "green", "blue", "purple" }
	},
	{
		align = "left",
		startIndex = getIndex(shapes, myShape),
		labels = { "circle", "rectangle", "triangle" }
	}
}



local pickerWheel = widget.newPickerWheel(
	{
		x = display.contentCenterX - 10,
		y = display.contentCenterY + 70,
		columns = columnData,
		fontSize = 18,
		columnColor = { 180/255, 1, 1, }
	}
)
Group1:insert(pickerWheel)

local onValueSelected = function()
	local _size = pickerWheel:getValues()[1].value
	local _color = pickerWheel:getValues()[2].value
	local _shape = pickerWheel:getValues()[3].value
	item:removeSelf()
	item = getShape({
		x = display.contentWidth * itemLocX,
		y = display.contentHeight * itemLocY,
		size = _size,
		color = _color,
		shape = _shape
	})
	system.setPreferences("app", {
		mySize = _size,
		myColor = _color,
		myShape = _shape
	})

	Group1:insert(item)
end

timer.performWithDelay(100, onValueSelected, -1)




-----tableView Page-------------------

local ranks = {}
local weight = 1

local function initLoop(e, name)
	for i = 1, e do
		ranks[weight] = name
		weight = weight + 1
	end
end
initLoop(15, "shabby")
initLoop(50, "common")
initLoop(10, "uncommon")
initLoop(5, "rare")
initLoop(2, "epic")
initLoop(1, "legendary")

local weapons = {
	"gloves",
	"dagger",
	"sword",
	"great sword",
	"mace",
	"great mace",
	"axe",
	"great axe",
	"polearms"
}

local Group2 = display.newGroup()

local weaponLists
math.randomseed(os.time())
local function reloadList()
	weaponLists = {}
	for i = 1, 20 do
		iRank = math.random(1, #ranks)
		iWeapon = math.random(1, #weapons)
		weaponLists[i] = ranks[iRank] .. " " .. weapons[iWeapon]
	end
end
reloadList()

local function onRowRender2(event)
	local rowHeight = event.row.contentHeight
	local rowWidth = event.row.contentWidth
	local rowTitle = display.newText(event.row, weaponLists[event.row.index], 0, 0, nil, 17)
	rowTitle:setFillColor(0)
	rowTitle.anchorx = 30
	rowTitle.x = rowWidth * 0.5 -- must use rowWidth. because if you use "event.row.contentWidth", it will change its value after "newText()".
	rowTitle.y = rowHeight * 0.5
end

local tableView = widget.newTableView(
	{
		x = display.contentWidth * 0.5,
		y = display.contentHeight * 0.5,
		width = display.contentWidth * 0.9,
		height = display.contentHeight * 0.5,
		onRowRender = onRowRender2
	}
)
Group2:insert(tableView)

for i = 1, 20 do
	tableView:insertRow({})
end




-----None Page----------------------------

local Group3 = display.newGroup()





-----tabBar-------------------------------

local text1 = display.newText(
	{
		text = "Picker Wheel",
		x = display.contentWidth * 0.5,
		y = display.contentHeight * 0,
		fontSize = 20
	}
)
text1:setFillColor(0)
Group1:insert(text1)
local text2 = display.newText(
	{
		text = "Table View",
		x = display.contentWidth * 0.5,
		y = display.contentHeight * 0,
		fontSize = 20
	}
)
text2:setFillColor(0)
Group2:insert(text2)
local text3 = display.newText(
	{
		text = "-None-",
		x = display.contentWidth * 0.5,
		y = display.contentHeight * 0.45,
		fontSize = 20
	}
)
text3:setFillColor(0)
Group3:insert(text3)


Group1.isVisible = true
Group2.isVisible = false
Group3.isVisible = false

local tabButtons = {
	{
		label = "Tab1",
		id = "tab1",
		size = 20,
		selected = true,
		onPress = function()
			Group1.isVisible = true
			Group2.isVisible = false
			Group3.isVisible = false
		end
	},
	{
		label = "Tab2",
		id = "tab2",
		size = 20,
		selected = false,
		onPress = function()
			Group1.isVisible = false
			Group2.isVisible = true
			Group3.isVisible = false
		end
	},
	{
		label = "Tab3",
		id = "tab3",
		size = 20,
		selected = false,
		onPress = function()
			Group1.isVisible = false
			Group2.isVisible = false
			Group3.isVisible = true
		end
	},
}
local tabBar = widget.newTabBar(
	{
		top = display.contentHeight * 0.95,
		width = display.contentWidth,
		buttons = tabButtons
	}
)


-----nextBtn---------------------------
local nextBtn = widget.newButton(
	{
		x = display.contentWidth * 0.9,
		y = display.contentHeight * 0,
		label = "Previous",
		fontSize = 16,
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
			composer.gotoScene("helloCorona")
		end
	}
)



-----SecneConfig------------------------

local scene = composer.newScene()

function scene:create(event)
	self.view:insert(Group1)
	self.view:insert(Group2)
	self.view:insert(Group3)
	self.view:insert(tabBar)
	self.view:insert(nextBtn)
end

function scene:show(event)
	if(event.phase == "will") then
		self.view.isVisible = true	
		display.setDefault("background", 1, 1, 1)
	end
end

function scene:hide(event)
	if(event.phase == "did") then
		self.view.isVisible = false	
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
