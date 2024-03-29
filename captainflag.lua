local redflags = {}
redflags[-2]=love.graphics.newImage("flagger_aka_shita.png")
redflags[-1]=love.graphics.newImage("flagger_aka_sage.png")
redflags[0]=love.graphics.newImage("flagger_aka_neutral.png")
redflags[1]=love.graphics.newImage("flagger_aka_age.png")
redflags[2]=love.graphics.newImage("flagger_aka_ue.png")
redflags[3]=love.graphics.newImage("flagger_aka_what.png")
local whiteflags = {}
whiteflags[-2]=love.graphics.newImage("flagger_shiro_shita.png")
whiteflags[-1]=love.graphics.newImage("flagger_shiro_sage.png")
whiteflags[0]=love.graphics.newImage("flagger_shiro_neutral.png")
whiteflags[1]=love.graphics.newImage("flagger_shiro_age.png")
whiteflags[2]=love.graphics.newImage("flagger_shiro_ue.png")
whiteflags[3]=love.graphics.newImage("flagger_shiro_what.png")
for _,roar in pairs(redflags) do
	roar:setFilter("linear","linear",1)
end
for _,roar in pairs(whiteflags) do
	roar:setFilter("linear","linear",1)
end
local fakeo = {}
fakeo["normal"]=love.graphics.newImage("action_norma.png")
fakeo["ue"]=love.graphics.newImage("action_flaggerup.png")
fakeo["shita"]=love.graphics.newImage("action_flaggerdown.png")
fakeo["ogami"]=love.graphics.newImage("action_flaggerhigh.png")
fakeo["what"]=love.graphics.newImage("action_screa.png")
local drawo = love.graphics.newCanvas(128,128)
drawo:setFilter("linear","linear",1)
function UpdateMe(reddown,redup,whitedown,whiteup,animationstore)
	animationstore.reddown = reddown
	animationstore.redup = redup
	animationstore.whitedown = whitedown
	animationstore.whiteup = whiteup
	targetredstate = 0
	targetwhitestate = 0
	if animationstore.redstate == 3 then
		animationstore.redstate = 0
	end
	if animationstore.whitestate == 3 then
		animationstore.whitestate = 0
	end
	if reddown and redup then
		targetredstate = 0
	elseif reddown then
		targetredstate = -2
	elseif redup then
		targetredstate = 2
	end
	if whitedown and whiteup then
		targetwhitestate = 0
	elseif whitedown then
		targetwhitestate = -2
	elseif whiteup then
		targetwhitestate = 2
	end
	if reddown and redup and animationstore.redstate == 0 then
		animationstore.redstate = 3
	elseif animationstore.redstate > targetredstate then
		animationstore.redstate = animationstore.redstate - 1
	elseif animationstore.redstate < targetredstate then
		animationstore.redstate = animationstore.redstate + 1
	end
	if whitedown and whiteup and animationstore.whitestate == 0 then
		animationstore.whitestate = 3
	elseif animationstore.whitestate > targetwhitestate then
		animationstore.whitestate = animationstore.whitestate - 1
	elseif animationstore.whitestate < targetwhitestate then
		animationstore.whitestate = animationstore.whitestate + 1
	end
end

function DrawMe(x,y,animationstore,sizex,sizey,rotation)
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
	love.graphics.setColor(1,1,1,1)
	local notdrawo = love.graphics.getCanvas()
	love.graphics.setCanvas(drawo)
	love.graphics.push()
	love.graphics.origin()
	love.graphics.clear(0,0,0,0)
	love.graphics.draw(redflags[animationstore.redstate], 0, 0)
	love.graphics.draw(whiteflags[animationstore.whitestate], 128, 0,0,-1,1)
	love.graphics.pop()
	love.graphics.setCanvas(notdrawo)
	local mon,monn = love.graphics.getBlendMode()
	love.graphics.setBlendMode("alpha", "premultiplied")
	love.graphics.draw(drawo, 0, 0)
	love.graphics.setBlendMode(mon,monn)
	if (animationstore.reddown and animationstore.redup) or (animationstore.whitedown and animationstore.whiteup) then
		love.graphics.draw(fakeo["what"], 48, 31)
	elseif animationstore.redup and animationstore.whiteup then
		love.graphics.draw(fakeo["ogami"], 48, 31)
	elseif (animationstore.reddown and animationstore.whitedown) or (animationstore.redup and animationstore.whitedown) or (animationstore.reddown and animationstore.whiteup) then
		love.graphics.draw(fakeo["normal"], 48, 31)
	elseif animationstore.redup then
		love.graphics.draw(fakeo["ue"], 48, 31)
	elseif animationstore.reddown then
		love.graphics.draw(fakeo["shita"], 48, 31)
	elseif animationstore.whiteup then
		love.graphics.draw(fakeo["ue"], 80, 31,0,-1,1)
	elseif animationstore.whitedown then
		love.graphics.draw(fakeo["shita"], 80, 31,0,-1,1)
	else
		love.graphics.draw(fakeo["normal"], 48, 31)
	end
	love.graphics.pop()
	love.graphics.setColor(tempcolorr,tempcolorg,tempcolorb,tempcolora)
end
local AnimationStoreLMAO = {["reddown"]=false,["redup"]=false,["whitedown"]=false,["whiteup"]=false,["redstate"]=0,["whitestate"]=0,}
return {UpdateMe,DrawMe,AnimationStoreLMAO}