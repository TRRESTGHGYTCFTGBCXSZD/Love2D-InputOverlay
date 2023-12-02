local ffi = require "ffi"
ffi.cdef[[
short GetAsyncKeyState(int);
]]
function createobject(workspace,positionx,positiony,bodytype,shape,density)
	local body = love.physics.newBody(workspace,positionx,positiony,bodytype)
	local fixes = love.physics.newFixture(body,shape,density)
	return {body,fixes}
end
function love.load(wao)
	frames = 0
	frameticks = 0
	bit32 = require("bit")
	love.graphics.setBackgroundColor(0, 0, 0, 0)
	bigcircle = love.graphics.newImage("botan.png")
	middlecircle = love.graphics.newImage("joy_golfball.png")
	smallcircle = love.graphics.newImage("joy_base.png")
	taenoahhhh = love.graphics.newImage("action_screa.png")
	taenonorma = love.graphics.newImage("action_norma.png")
	actioncolors = {}
	actioncolors["geriomint"] = {162/255,219/255,212/255,1}
	actioncolors["geriopink"] = {255/255,96/255,192/255,1}
	actioncolors["white"] = {1,1,1,1}
	actioncolors["gray"] = {.5,.5,.5,1}
	keyargaction = string.sub(wao[1],3,-1)
	--print(keyargaction)
	--print(string.len(keyargaction))
	joy1 = {["x"]=32,["y"]=32,["moving"]=false,}
	joy2 = {["x"]=32,["y"]=32,["moving"]=false,}
	joy3 = {["x"]=32,["y"]=32,["moving"]=false,}
	joy4 = {["x"]=32,["y"]=32,["moving"]=false,}
	flago1 = {["reddown"]=false,["redup"]=false,["whitedown"]=false,["whiteup"]=false,["redstate"]=0,["whitestate"]=0,}
	flago2 = {["reddown"]=false,["redup"]=false,["whitedown"]=false,["whiteup"]=false,["redstate"]=0,["whitestate"]=0,}
	heyyoudontskipit()
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
function DrawButton(x,y,on,sizex,sizey,rotation,basecoloroff,basecoloron,botancoloroff,botancoloron,hasface)
	sizex = sizex or 1
	sizey = sizey or sizex
	rotation = rotation or 0
	if (not hasface ~= nil) then
		hasface = true
	end
	local tempcolorr,tempcolorg,tempcolorb,tempcolora = love.graphics.getColor()
	love.graphics.push()
	love.graphics.rotate(rotation)
	love.graphics.translate(x,y)
	local botancolor = {1,1,1,1}
	if on then
		botancolor = basecoloron or actioncolors.white
	else
		botancolor = basecoloroff or actioncolors.gray
	end
	love.graphics.setColor(botancolor)
	love.graphics.draw(bigcircle,0,0,0,sizex,sizey)
	if on then
		botancolor = botancoloron or botancoloroff or actioncolors.geriomint
	else
		botancolor = botancoloroff or actioncolors.geriomint
	end
	love.graphics.setColor(botancolor)
	love.graphics.draw(middlecircle,0,0,0,sizex,sizey)
	if hasface then
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(on and taenoahhhh or taenonorma,16,16,0,sizex,sizey)
	end
	love.graphics.pop()
	love.graphics.setColor(tempcolorr,tempcolorg,tempcolorb,tempcolora)
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
	love.graphics.rotate(rotation)
	love.graphics.translate(x,y)
	love.graphics.setColor(basecolor or actioncolors.gray)
	love.graphics.draw(smallcircle, 32, 32,0,sizex,sizey)
	love.graphics.setColor(gbcolor or actioncolors.geriopink)
	love.graphics.draw(middlecircle, animationstore.x, animationstore.y,0,sizex,sizey)
	if hasface then
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(animationstore.moving and taenoahhhh or taenonorma, animationstore.x+16, animationstore.y+16,0,sizex,sizey)
	end
	love.graphics.pop()
	love.graphics.setColor(tempcolorr,tempcolorg,tempcolorb,tempcolora)
end
local Flagger=require("captainflag")
UpdateFlagger,DrawFlagger=Flagger[1],Flagger[2]
function heyyoudontskipit()
if keyargaction == "0btn" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(bit32.band(ffi.C.GetAsyncKeyState(0x25),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x28),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x26),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x27),0x8000) ~= 0,joy1)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,0,bit32.band(ffi.C.GetAsyncKeyState(0x32),0x8000) ~= 0)
	DrawJoystick(0,0,joy1)
end
end
if keyargaction == "0btnspace" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(bit32.band(ffi.C.GetAsyncKeyState(0x25),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x28),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x26),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x27),0x8000) ~= 0,joy1)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,0,bit32.band(ffi.C.GetAsyncKeyState(0x20),0x8000) ~= 0)
	DrawJoystick(0,0,joy1)
end
end
if keyargaction == "1btn" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(bit32.band(ffi.C.GetAsyncKeyState(0x25),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x28),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x26),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x27),0x8000) ~= 0,joy1)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,64,bit32.band(ffi.C.GetAsyncKeyState(0x5a),0x8000) ~= 0)
	DrawButton(128,0,bit32.band(ffi.C.GetAsyncKeyState(0x32),0x8000) ~= 0)
	DrawJoystick(0,0,joy1)
end
end
if keyargaction == "1btnspace" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(bit32.band(ffi.C.GetAsyncKeyState(0x25),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x28),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x26),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x27),0x8000) ~= 0,joy1)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,64,bit32.band(ffi.C.GetAsyncKeyState(0x20),0x8000) ~= 0)
	DrawButton(128,0,bit32.band(ffi.C.GetAsyncKeyState(0x32),0x8000) ~= 0)
	DrawJoystick(0,0,joy1)
end
end
if keyargaction == "2btn" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(bit32.band(ffi.C.GetAsyncKeyState(0x25),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x28),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x26),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x27),0x8000) ~= 0,joy1)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,64,bit32.band(ffi.C.GetAsyncKeyState(0x5a),0x8000) ~= 0)
	DrawButton(192,64,bit32.band(ffi.C.GetAsyncKeyState(0x58),0x8000) ~= 0)
	DrawButton(128,0,bit32.band(ffi.C.GetAsyncKeyState(0x32),0x8000) ~= 0)
	DrawJoystick(0,0,joy1)
end
end
if keyargaction == "2btnspace" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(bit32.band(ffi.C.GetAsyncKeyState(0x25),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x28),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x26),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x27),0x8000) ~= 0,joy1)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,64,bit32.band(ffi.C.GetAsyncKeyState(0x20),0x8000) ~= 0)
	DrawButton(192,64,bit32.band(ffi.C.GetAsyncKeyState(0x5a),0x8000) ~= 0)
	DrawButton(128,0,bit32.band(ffi.C.GetAsyncKeyState(0x32),0x8000) ~= 0)
	DrawJoystick(0,0,joy1)
end
end
if keyargaction == "3btn" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(bit32.band(ffi.C.GetAsyncKeyState(0x25),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x28),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x26),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x27),0x8000) ~= 0,joy1)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,64,bit32.band(ffi.C.GetAsyncKeyState(0x5a),0x8000) ~= 0)
	DrawButton(192,64,bit32.band(ffi.C.GetAsyncKeyState(0x58),0x8000) ~= 0)
	DrawButton(256,64,bit32.band(ffi.C.GetAsyncKeyState(0x43),0x8000) ~= 0)
	DrawButton(128,0,bit32.band(ffi.C.GetAsyncKeyState(0x32),0x8000) ~= 0)
	DrawJoystick(0,0,joy1)
end
end
-- special kind of games
if keyargaction == "gchgchmp" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(bit32.band(ffi.C.GetAsyncKeyState(0x41),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x53),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x57),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x44),0x8000) ~= 0,joy1)
		UpdateJoystick(bit32.band(ffi.C.GetAsyncKeyState(0x4b),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x4c),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x4f),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0xba),0x8000) ~= 0,joy2)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,0,bit32.band(ffi.C.GetAsyncKeyState(0x20),0x8000) ~= 0,1,1,0,nil,nil,{1,1,0,1})
	DrawJoystick(0,0,joy1,1,1,0,nil,{248/255,0/255,0/255,1})
	DrawJoystick(192,0,joy2,1,1,0,nil,{96/255,32/255,248/255,1})
end
end

if keyargaction == "captflag" then
function love.update(dt)
	frames = frames + (dt*60)
	while frames > 1 do
		frameticks = frameticks + 1
		frames = frames - 1
		UpdateJoystick(false,bit32.band(ffi.C.GetAsyncKeyState(0x5a),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x41),0x8000) ~= 0,false,joy1)
		UpdateJoystick(false,bit32.band(ffi.C.GetAsyncKeyState(0x58),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x53),0x8000) ~= 0,false,joy2)
		UpdateFlagger(bit32.band(ffi.C.GetAsyncKeyState(0x5a),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x41),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x58),0x8000) ~= 0,bit32.band(ffi.C.GetAsyncKeyState(0x53),0x8000) ~= 0,flago1)
	end
end
function love.draw()
	love.graphics.clear()
	DrawButton(128,64,bit32.band(ffi.C.GetAsyncKeyState(0x51),0x8000) ~= 0,1,1,0,{.25,.25,.25,1},{.25,.25,.25,1},{0,.5,0,1},{0,1,0,1})
	DrawButton(192,64,bit32.band(ffi.C.GetAsyncKeyState(0x57),0x8000) ~= 0,1,1,0,{.25,.25,.25,1},{.25,.25,.25,1},{.5,0,0,1},{1,0,0,1})
	DrawJoystick(-32+256,0,joy1,1,1,0,nil,{1,0,0,1})
	DrawJoystick(32+256,0,joy2,1,1,0,nil,{1,1,1,1})
	DrawFlagger(0,0,flago1)
end
end

end