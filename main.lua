local ffi = require "ffi"
ffi.cdef[[
short GetAsyncKeyState(int);
]]
function createobject(workspace,positionx,positiony,bodytype,shape,density)
	local body = love.physics.newBody(workspace,positionx,positiony,bodytype)
	local fixes = love.physics.newFixture(body,shape,density)
	return {body,fixes}
end
function globaldown(key) return ffi.C.GetAsyncKeyState(key) end
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
local function lerp(a,b,t) return a * (1-t) + b * t end
local function inverselerp(a,b,t) return (t-a)/(b-a) end
local function clamp(x, a, b)
    return x > b and b or x < a and a or x;
end
local function colorlerp(color1,color2,t) return{lerp(color1[1],color2[1],t),lerp(color1[2],color2[2],t),lerp(color1[3],color2[3],t),lerp(color1[4] or 1,color2[4] or 1,t)} end
function love.load(wao)
	frames = 0
	frameticks = 0
	bit32 = require("bit")
	love.graphics.setBackgroundColor(0, 0, 0, 0)
	love.graphics.setDefaultFilter("linear","nearest",1)
	bigcircle = love.graphics.newImage("botan.png")
	middlecircle = love.graphics.newImage("joy_golfball.png")
	smallcircle = love.graphics.newImage("joy_base.png")
	bigsquare = love.graphics.newImage("analogbotan.png")
	middlesquare = love.graphics.newImage("analogbotan_component.png")
	taenoahhhh = love.graphics.newImage("action_screa.png")
	taenonorma = love.graphics.newImage("action_norma.png")
	actioncolors = {}
	actioncolors["geriomint"] = {162/255,219/255,212/255,1}
	actioncolors["geriopink"] = {255/255,96/255,192/255,1}
	actioncolors["white"] = {1,1,1,1}
	actioncolors["gray"] = {.5,.5,.5,1}
	-- for inputs, check https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
	-- as this uses virtual key code (and not love2d's key input system), it's advanced and hard one
	actionkeys = {}
	actionkeys.buttona = 0x5a
	actionkeys.buttonb = 0x58
	actionkeys.buttonc = 0x43
	actionkeys.buttond = 0x56
	actionkeys.buttone = 0x42
	actionkeys.buttonf = 0x4e
	actionkeys.buttong = 0x4d
	actionkeys.buttonh = 0xbc
	actionkeys.buttonspace = 0x20
	actionkeys.start = 0x32
	
	actionkeys.joyleft = 0x25
	actionkeys.joydown = 0x28
	actionkeys.joyup = 0x26
	actionkeys.joyright = 0x27
	keyargaction = string.sub(wao[1],3,-1)
	--print(keyargaction)
	--print(string.len(keyargaction))
	animationstores = {}
	animationstores.joybase = {["x"]=32,["y"]=32,["moving"]=false,}
	local Flagger=require("captainflag")
	UpdateFlagger,DrawFlagger,animationstores.flagobase=Flagger[1],Flagger[2],Flagger[3]
	animationstores.analogbotanbase = {["percentage"]=0,}
	------------
	animationstores.joy1 = deepcopy(animationstores.joybase)
	animationstores.joy2 = deepcopy(animationstores.joybase)
	animationstores.joy3 = deepcopy(animationstores.joybase)
	animationstores.joy4 = deepcopy(animationstores.joybase)
	animationstores.flago1 = deepcopy(animationstores.flagobase)
	animationstores.flago2 = deepcopy(animationstores.flagobase)
	animationstores.analogbotan1 = deepcopy(animationstores.analogbotanbase)
	animationstores.analogbotan2 = deepcopy(animationstores.analogbotanbase)
	animationstores.analogbotan3 = deepcopy(animationstores.analogbotanbase)
	animationstores.analogbotan4 = deepcopy(animationstores.analogbotanbase)
	animationstores.analogbotan5 = deepcopy(animationstores.analogbotanbase)
	animationstores.analogbotan6 = deepcopy(animationstores.analogbotanbase)
	animationstores.analogbotan7 = deepcopy(animationstores.analogbotanbase)
	animationstores.analogbotan8 = deepcopy(animationstores.analogbotanbase)
	heyyoudontskipit()
end

function DrawButton(x,y,on,sizex,sizey,rotation,basecoloroff,basecoloron,botancoloroff,botancoloron,hasface)
	sizex = sizex or 1
	sizey = sizey or sizex
	rotation = rotation or 0
	if (not hasface ~= nil) then
		hasface = true
	end
	local tempcolorr,tempcolorg,tempcolorb,tempcolora = love.graphics.getColor()
	love.graphics.push()
	love.graphics.scale(sizex,sizey)
	love.graphics.rotate(rotation)
	love.graphics.translate(x/sizex,y/sizey)
	local botancolor = {1,1,1,1}
	if on then
		botancolor = basecoloron or actioncolors.white
	else
		botancolor = basecoloroff or actioncolors.gray
	end
	love.graphics.setColor(botancolor)
	love.graphics.draw(bigcircle,0,0)
	if on then
		botancolor = botancoloron or botancoloroff or actioncolors.geriomint
	else
		botancolor = botancoloroff or actioncolors.geriomint
	end
	love.graphics.setColor(botancolor)
	love.graphics.draw(middlecircle,0,0)
	if hasface then
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(on and taenoahhhh or taenonorma,16,16)
	end
	love.graphics.pop()
	love.graphics.setColor(tempcolorr,tempcolorg,tempcolorb,tempcolora)
end

function UpdateJoystick(left,down,up,right,animationstore)
	animationstore.moving = (left or down or up or right)
	local targetx = 32
	local targety = 32
	if left and down then
		targetx = 32-18
		targety = 32+18
	elseif right and down then
		targetx = 32+18
		targety = 32+18
	elseif left and up then
		targetx = 32-18
		targety = 32-18
	elseif right and up then
		targetx = 32+18
		targety = 32-18
	elseif left then
		targetx = 32-24
	elseif down then
		targety = 32+24
	elseif up then
		targety = 32-24
	elseif right then
		targetx = 32+24
	end
	animationstore.x = animationstore.x + ((targetx - animationstore.x) * .65)
	animationstore.y = animationstore.y + ((targety - animationstore.y) * .65)
end
function UpdateAnalogJoystick(positionx,positiony,animationstore)
	animationstore.moving = ((positionx-128)^2)+((positiony-128)^2)>=16^2
	animationstore.x = lerp(8,56,inverselerp(1,255,clamp(positionx,0,255)))
	animationstore.y = lerp(8,56,inverselerp(1,255,clamp(positiony,0,255)))
end
function DrawJoystick(x,y,animationstore,sizex,sizey,rotation,basecolor,gbcolor,hasface)
	sizex = sizex or 1
	sizey = sizey or sizex
	rotation = rotation or 0
	if (not hasface ~= nil) then
		hasface = true
	end
	local tempcolorr,tempcolorg,tempcolorb,tempcolora = love.graphics.getColor()
	love.graphics.push()
	love.graphics.scale(sizex,sizey)
	love.graphics.rotate(rotation)
	love.graphics.translate(x/sizex,y/sizey)
	love.graphics.setColor(basecolor or actioncolors.gray)
	love.graphics.draw(smallcircle, 32, 32)
	love.graphics.setColor(gbcolor or actioncolors.geriopink)
	love.graphics.draw(middlecircle, animationstore.x, animationstore.y)
	if hasface then
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(animationstore.moving and taenoahhhh or taenonorma, animationstore.x+16, animationstore.y+16)
	end
	love.graphics.pop()
	love.graphics.setColor(tempcolorr,tempcolorg,tempcolorb,tempcolora)
end

function UpdateAnalogButton(presspercent,animationstore)
	animationstore.percentage = clamp(presspercent,0,255)
end
function UpdatePneumaticButton(presspercent,dropspeed,animationstore)
	animationstore.percentage = clamp(math.max(animationstore.percentage-dropspeed,presspercent),0,255)
end
function DrawAnalogButton(x,y,animationstore,sizex,sizey,rotation,basecoloroff,basecoloron,botancoloroff,botancoloron,hasface)
	sizex = sizex or 1
	sizey = sizey or sizex
	rotation = rotation or 0
	if (not hasface ~= nil) then
		hasface = true
	end
	local tempcolorr,tempcolorg,tempcolorb,tempcolora = love.graphics.getColor()
	love.graphics.push()
	love.graphics.scale(sizex,sizey)
	love.graphics.rotate(rotation)
	love.graphics.translate(x/sizex,y/sizey)
	local botancolor = {1,1,1,1}
	if animationstore.percentage < 128 then
		botancolor = basecoloroff or actioncolors.gray
	love.graphics.setColor(botancolor)
	love.graphics.draw(bigsquare,0,0)
		botancolor = basecoloron or actioncolors.white
	love.graphics.setColor(botancolor)
	love.graphics.rectangle("fill", 5,lerp(32,9,inverselerp(0,127,animationstore.percentage)), 54,lerp(0,46,inverselerp(0,127,animationstore.percentage)))
	else
		botancolor = basecoloron or actioncolors.white
	love.graphics.setColor(botancolor)
	love.graphics.draw(bigsquare,0,0)
		botancolor = basecoloroff or actioncolors.gray
	love.graphics.setColor(botancolor)
	love.graphics.rectangle("fill", lerp(32,9,inverselerp(255,128,animationstore.percentage)),5, lerp(0,46,inverselerp(255,128,animationstore.percentage)),54)
	end
		botancolor = colorlerp(botancoloroff or actioncolors.geriomint,botancoloron or botancoloroff or actioncolors.geriomint,inverselerp(0,255,animationstore.percentage))
	love.graphics.setColor(botancolor)
	love.graphics.draw(middlesquare,0,0)
	if hasface then
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(animationstore.percentage >= 8 and taenoahhhh or taenonorma,16,16)
	end
	love.graphics.pop()
	love.graphics.setColor(tempcolorr,tempcolorg,tempcolorb,tempcolora)
end
function heyyoudontskipit()
if keyargaction == "test" then --for testing purposes
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(bit32.band(globaldown(actionkeys.joyleft),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joydown),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joyup),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joyright),0x8000) ~= 0,animationstores.joy1)
		UpdateAnalogJoystick(love.mouse.getX(),love.mouse.getY(),animationstores.joy2)
		UpdateAnalogButton(love.mouse.getY(),animationstores.analogbotan1)
		UpdatePneumaticButton(math.random(0,math.random(0,math.random(0,math.random(0,255)))),16,animationstores.analogbotan2)
		UpdateFlagger(bit32.band(globaldown(0x5a),0x8000) ~= 0,bit32.band(globaldown(0x41),0x8000) ~= 0,bit32.band(globaldown(0x58),0x8000) ~= 0,bit32.band(globaldown(0x53),0x8000) ~= 0,animationstores.flago1)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(256,64,bit32.band(globaldown(actionkeys.start),0x8000) ~= 0)
	DrawJoystick(0,0,animationstores.joy1,.5,.5)
	DrawJoystick(64,0,animationstores.joy2,.5,.5)
	DrawFlagger(128,0,animationstores.flago1)
	DrawAnalogButton(256,0,animationstores.analogbotan1,1,1,0,{.25,.25,.25,1},{1,1,1,1},{.125,.125,.25,1},{.25,.25,1,1})
	--DrawAnalogButton(0,128,animationstores.analogbotan1,4,4,0,{.25,.25,.25,1},{1,1,1,1},{.125,.125,.25,1},{.25,.25,1,1})
	--DrawJoystick(0,128,animationstores.joy2,2,2)
	DrawFlagger(0,128,animationstores.flago1,2,2)
	DrawAnalogButton(320,0,animationstores.analogbotan2)
end
end

if keyargaction == "0btn" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(bit32.band(globaldown(actionkeys.joyleft),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joydown),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joyup),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joyright),0x8000) ~= 0,animationstores.joy1)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,0,bit32.band(globaldown(actionkeys.start),0x8000) ~= 0)
	DrawJoystick(0,0,animationstores.joy1)
end
end
if keyargaction == "0btnspace" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(bit32.band(globaldown(actionkeys.joyleft),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joydown),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joyup),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joyright),0x8000) ~= 0,animationstores.joy1)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,0,bit32.band(globaldown(actionkeys.buttonspace),0x8000) ~= 0)
	DrawJoystick(0,0,animationstores.joy1)
end
end
if keyargaction == "1btn" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(bit32.band(globaldown(actionkeys.joyleft),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joydown),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joyup),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joyright),0x8000) ~= 0,animationstores.joy1)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,64,bit32.band(globaldown(actionkeys.buttona),0x8000) ~= 0)
	DrawButton(128,0,bit32.band(globaldown(actionkeys.start),0x8000) ~= 0)
	DrawJoystick(0,0,animationstores.joy1)
end
end
if keyargaction == "1btnspace" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(bit32.band(globaldown(actionkeys.joyleft),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joydown),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joyup),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joyright),0x8000) ~= 0,animationstores.joy1)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,64,bit32.band(globaldown(actionkeys.buttonspace),0x8000) ~= 0)
	DrawButton(128,0,bit32.band(globaldown(actionkeys.start),0x8000) ~= 0)
	DrawJoystick(0,0,animationstores.joy1)
end
end
if keyargaction == "2btn" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(bit32.band(globaldown(actionkeys.joyleft),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joydown),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joyup),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joyright),0x8000) ~= 0,animationstores.joy1)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,64,bit32.band(globaldown(actionkeys.buttona),0x8000) ~= 0)
	DrawButton(192,64,bit32.band(globaldown(actionkeys.buttonb),0x8000) ~= 0)
	DrawButton(128,0,bit32.band(globaldown(actionkeys.start),0x8000) ~= 0)
	DrawJoystick(0,0,animationstores.joy1)
end
end
if keyargaction == "2btnspace" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(bit32.band(globaldown(actionkeys.joyleft),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joydown),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joyup),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joyright),0x8000) ~= 0,animationstores.joy1)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,64,bit32.band(globaldown(actionkeys.buttonspace),0x8000) ~= 0)
	DrawButton(192,64,bit32.band(globaldown(actionkeys.buttona),0x8000) ~= 0)
	DrawButton(128,0,bit32.band(globaldown(actionkeys.start),0x8000) ~= 0)
	DrawJoystick(0,0,animationstores.joy1)
end
end
if keyargaction == "3btn" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(bit32.band(globaldown(actionkeys.joyleft),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joydown),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joyup),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joyright),0x8000) ~= 0,animationstores.joy1)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,64,bit32.band(globaldown(actionkeys.buttona),0x8000) ~= 0)
	DrawButton(192,64,bit32.band(globaldown(actionkeys.buttonb),0x8000) ~= 0)
	DrawButton(256,64,bit32.band(globaldown(actionkeys.buttonc),0x8000) ~= 0)
	DrawButton(128,0,bit32.band(globaldown(actionkeys.start),0x8000) ~= 0)
	DrawJoystick(0,0,animationstores.joy1)
end
end
if keyargaction == "4btn" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(bit32.band(globaldown(actionkeys.joyleft),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joydown),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joyup),0x8000) ~= 0,bit32.band(globaldown(actionkeys.joyright),0x8000) ~= 0,animationstores.joy1)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,64,bit32.band(globaldown(actionkeys.buttona),0x8000) ~= 0)
	DrawButton(192,64,bit32.band(globaldown(actionkeys.buttonb),0x8000) ~= 0)
	DrawButton(256,64,bit32.band(globaldown(actionkeys.buttonc),0x8000) ~= 0)
	DrawButton(320,64,bit32.band(globaldown(actionkeys.buttond),0x8000) ~= 0)
	DrawButton(128,0,bit32.band(globaldown(actionkeys.start),0x8000) ~= 0)
	DrawJoystick(0,0,animationstores.joy1)
end
end
-- special kind of games
if keyargaction == "gchgchmp" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(bit32.band(globaldown(0x41),0x8000) ~= 0,bit32.band(globaldown(0x53),0x8000) ~= 0,bit32.band(globaldown(0x57),0x8000) ~= 0,bit32.band(globaldown(0x44),0x8000) ~= 0,animationstores.joy1)
		UpdateJoystick(bit32.band(globaldown(0x4b),0x8000) ~= 0,bit32.band(globaldown(0x4c),0x8000) ~= 0,bit32.band(globaldown(0x4f),0x8000) ~= 0,bit32.band(globaldown(0xba),0x8000) ~= 0,animationstores.joy2)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,0,bit32.band(globaldown(actionkeys.buttonspace),0x8000) ~= 0,1,1,0,nil,nil,{1,1,0,1})
	DrawJoystick(0,0,animationstores.joy1,1,1,0,nil,{248/255,0/255,0/255,1})
	DrawJoystick(192,0,animationstores.joy2,1,1,0,nil,{96/255,32/255,248/255,1})
end
end

if keyargaction == "captflag" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(false,bit32.band(globaldown(actionkeys.buttona),0x8000) ~= 0,bit32.band(globaldown(0x41),0x8000) ~= 0,false,animationstores.joy1)
		UpdateJoystick(false,bit32.band(globaldown(actionkeys.buttonb),0x8000) ~= 0,bit32.band(globaldown(0x53),0x8000) ~= 0,false,animationstores.joy2)
		UpdateFlagger(bit32.band(globaldown(0x5a),0x8000) ~= 0,bit32.band(globaldown(0x41),0x8000) ~= 0,bit32.band(globaldown(0x58),0x8000) ~= 0,bit32.band(globaldown(0x53),0x8000) ~= 0,animationstores.flago1)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,64,bit32.band(globaldown(0x51),0x8000) ~= 0,1,1,0,{.25,.25,.25,1},{.25,.25,.25,1},{0,.5,0,1},{0,1,0,1})
	DrawButton(192,64,bit32.band(globaldown(0x57),0x8000) ~= 0,1,1,0,{.25,.25,.25,1},{.25,.25,.25,1},{.5,0,0,1},{1,0,0,1})
	DrawJoystick(-32+256,0,animationstores.joy1,1,1,0,nil,{1,0,0,1})
	DrawJoystick(32+256,0,animationstores.joy2,1,1,0,nil,{1,1,1,1})
	DrawFlagger(0,0,animationstores.flago1)
end
end

end