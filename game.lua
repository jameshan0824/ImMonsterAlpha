
local composer = require( "composer" )
local widget = require( "widget" )

local generateCharacter = require( "character" )
local generateMonster = require( "monster" )
local generateBackground = require( "background" )
local particleDesigner = require( "particleDesigner" )

local scene = composer.newScene()

local runFrameSpeed = 1.5
local runtime = 0
local player = {}
local monster = {}
local bg = {}
local numPlayers = 0
local pewPews = {}
local pewCounter = nil
local sndPewHandle, sndPew2Handle, sndDamageHandle, sndDeathHandle, sndBackgroundMusic, sndBackgroundMusicHandle, sndClickHandle
local playerAcc = 0.1
local playerAccMax = 10
local playerJerk = 0.001
local tapPower = 0.2
local score = 0
local scoreLabel = nil

local deathCondition = display.contentHeight - 50

local exitButtonBackground, exitButton
local exitOnStartUp = false

local function createPlayer(displayName)
	local sprite = generateCharacter( nil )
	sprite.group.x = display.contentWidth/2
	sprite.group.y = display.contentHeight/2

	player = {
		sprite = sprite,
		v = { x=0, y=0 },
		name = displayName,
		score = 0,
		hp = 100,
		exitProgress = -1
	}

	scene.view:insert( sprite.group )
end

local function createBackground()
	bg = generateBackground()
  bg.group.x = display.contentCenterX
  bg.group.y = display.contentCenterY
	bg.group.height = display.contentHeight
	bg.group.width = display.contentWidth
  print(bg.group)
  for k,v in pairs(bg.group) do print(k,v) end
	scene.view:insert( bg.group )
  bg.anim:play()
end

local function createMonster()
  monster = generateMonster()
  --monster.group.anchorX = 0.0
  --monster.group.anchorY = 0.0
  monster.group.x = display.contentWidth/2--display.contentHeight + 600
  monster.group.y = display.contentHeight - 50
  monster.group.height = display.contentHeight
  monster.group.width = display.contentWidth
  scene.view:insert( monster.group )
  --monster.anim:play()
end

local function tapped( event )
  score = score + 1
	player.sprite.anim:play()
    --code executed when the button is tapped
    print( "object tapped = "..tostring(event.target) )  --'event.target' is the tapped object
    player.v.y = player.v.y - tapPower
    return true
end


local function getDeltaTime()
   local temp = system.getTimer()  -- Get current game time in ms
   local dt = (temp-runtime) / (1000/60)  -- 60fps or 30fps as base
   runtime = temp  -- Store game time
   return dt, temp
end


local function clampToScreen( x, min, max )
	if x < min then
		return min
	elseif x > max then
		return max
	else
		return x
	end
end


local function onFrameEnter()

	if exitOnStartUp then 
		return
	end
	monster.anim:play()
	local dt, time = getDeltaTime()
	local frameVelocity = dt*runFrameSpeed*1 -- instead of 1 should be frame time.
	local maxExitProgress = -1
  scoreLabel.text = tostring(score)

	if player.sprite.group.y > deathCondition then
		print "you dead son"
    print (score)
		composer.gotoScene("game-over", { effect="slideUp", time=600, params = {score=score} })
		composer.removeScene("game", false)
	end

	--tickPlayers
	-- for device, player in pairs(players) do
  print(player)
  player.sprite.group.x = clampToScreen(player.sprite.group.x + player.v.x*frameVelocity, 15, display.contentWidth-15)
  print "THING 1 "
  if player.sprite.group.y < 0 then
    print "I WAS CALLEd"
    player.v.y = 0
  end
  player.sprite.group.y = clampToScreen(player.sprite.group.y + player.v.y*frameVelocity, 25, display.contentHeight-25)

  local anim = "idle"
  player.v.y = player.v.y + playerAcc
  playerAcc = math.min(playerAcc + playerJerk, playerAccMax)

end


function scene:create( event )
	local sceneGroup = self.view

	display.setDefault( "textureWrapX", "repeat" )
	display.setDefault( "textureWrapY", "repeat" )

	-- Create a background image
	-- local background = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
	-- background.fill = { type="image", filename="grass.png" }
	-- background.fill.scaleX = 0.5
	-- background.fill.scaleY = 0.5

	-- Restore defaults
	local textureWrapDefault = "clampToEdge"
	display.setDefault( "textureWrapX", textureWrapDefault )
	display.setDefault( "textureWrapY", textureWrapDefault )

	-- Add back button
	-- exitButton = widget.newButton{
	-- 	label = "exit",
	-- 	onPress = function()
	-- 		audio.play( sndClickHandle )
	-- 		composer.gotoScene( "x", { effect="slideUp", time=600 } )
	-- 	end,
	-- 	fontSize = 13,
	-- 	shape = "rectangle",
	-- 	width = 70,
	-- 	height = 20,
	-- 	fillColor = {
	-- 		default={ 0, 0, 0, 0.6 },
	-- 		over={ 0, 0, 0, 0.6 }
	-- 	},
	-- 	labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } }
	-- }
	-- sceneGroup:insert( exitButton )
	-- exitButton.x = exitButton.width*0.5 - composer.getVariable( "letterboxWidth" )
	-- exitButton.y = display.contentHeight - exitButton.height*0.5 + composer.getVariable( "letterboxHeight" )
	
	-- exitButtonBackground = display.newRect( sceneGroup, exitButton.x, exitButton.y, exitButton.width, exitButton.height )
	-- exitButtonBackground.alpha = 0

	-- Load sounds
	sndClickHandle = audio.loadSound( "click.ogg" )
	sndBackgroundMusicHandle = audio.loadStream( "background_fight.ogg" )
	sndDamageHandle = audio.loadSound( "damage.ogg" )
	sndDeathHandle = audio.loadSound( "death.ogg" )
	sndPewHandle = audio.loadSound( "pew.ogg" )
	sndPew2Handle = audio.loadSound( "pew2.ogg" )

  print("creating scene!")
  createBackground()
  createPlayer("player")
  createMonster()
  scoreLabel = display.newText( sceneGroup, tostring(score), display.contentCenterX + 60, 50, composer.getVariable("appFont"), 14 )
  scoreLabel:setFillColor(0,0,0)
  sceneGroup:insert(scoreLabel)
end


function scene:show( event )
  score = 0
	if event.phase == "will" then
		-- Re-show and start spinner
		-- startText.alpha = 1
		-- spinner.alpha = 1
		-- spinner:start()
		--exitButtonBackground.alpha = 0
		--exitOnStartUp = false

	elseif event.phase == "did" then
		-- Add listeners
		-- Runtime:addEventListener( "axis", onAxisEvent )
		-- Runtime:addEventListener( "key", onKeyEvent )
		-- Runtime:addEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )
		Runtime:addEventListener( "enterFrame", onFrameEnter )
    Runtime:addEventListener( "touch", tapped)

		audio.rewind( sndBackgroundMusicHandle )
		sndBackgroundMusic = audio.play( sndBackgroundMusicHandle, { loops=-1 } )
	end
end


function scene:hide( event )

	if event.phase == "will" then

		-- Remove listeners
		Runtime:removeEventListener( "enterFrame", onFrameEnter )
    Runtime:removeEventListener( "touch", tapped)

		-- Stop all audio
		audio.stop()

	elseif event.phase == "did" then

    if player.sprite.group then
      player.sprite.group:removeSelf()
      player.sprite.group = nil
    end
		player = nil

		-- Stop spinner
		-- spinner:stop()
	end
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene
