
-------------------------------------------------------------------------------------------------------
-- Artwork used within this project is licensed under Public Domain Dedication
-- See the following site for further information: https://creativecommons.org/publicdomain/zero/1.0/
-------------------------------------------------------------------------------------------------------

local function generateCharacter( offset )

	local group = display.newGroup()

	--local selOffset = (( (offset or math.random(4)) + 1 ) % 4) * 4

	-- Create our player sprite sheet
	local sheetOptions = {
		width = 200,
		height = 200,
		numFrames = 4,
		sheetContentWidth = 800,
		sheetContentHeight = 200
	}

	local sheet_character = graphics.newImageSheet( "player.png", sheetOptions )

	local sequencesData = {
		{
			name = "swim",
			frames = { 1, 2, 3, 4, 1 },
			time = 150,
			loopCount = 1,
			loopDirection = "forward"
		}
	}

	-- And, create the player that it belongs to
	local character = display.newSprite( sheet_character, sequencesData)
	character:setSequence("swim")
	character:setFrame( 2 )

	group:insert( character, true )
	character.dispGroup = group

	return { group=group, anim=character }
end

return generateCharacter
