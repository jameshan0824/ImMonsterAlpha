local function generateBackground()

	local group = display.newGroup()
  local framesCount = 2
  local w = 1390
  local h = 1250

  print(display.contentWidth)
	local sheetOptions = {
		width = 400,
		height = 720,
		numFrames = 2,
		sheetContentWidth = 800,
		sheetContentHeight = 720
	}

	local sheet_background = graphics.newImageSheet( "background.png", sheetOptions )
  print(sheet_background)

	local sequencesData = {
		{
			name = "scroll",
			frames = {1, 2},
			time = 250,
			loopCount = 0,
			loopDirection = "forward"
		}
	}

	-- And, create the player that it belongs to
	local background = display.newSprite( sheet_background, sequencesData)
  print(background)
	background:setSequence("scroll")
	background:setFrame( 1 )

	group:insert( background, true )
  background.dispGroup = group
	-- character.dispGroup = group

	return { group=group, anim=background }
end

return generateBackground
