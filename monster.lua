
-------------------------------------------------------------------------------------------------------
-- Artwork used within this project is licensed under Public Domain Dedication
-- See the following site for further information: https://creativecommons.org/publicdomain/zero/1.0/
-------------------------------------------------------------------------------------------------------

local function generateMonster( offset )

  local group = display.newGroup()

  --local selOffset = (( (offset or math.random(4)) + 1 ) % 4) * 4

  -- Create our player sprite sheet
  local sheetOptions = {
    width = 200,
    height = 200,
    numFrames = 5,
    sheetContentWidth = 1000,
    sheetContentHeight = 200
  }

  local sheet_character = graphics.newImageSheet( "monster.png", sheetOptions )

  local sequencesData = {
    {
      name = "chase",
      frames = { 1, 2, 3, 4, 5 },
      time = 250,
      loopCount = 0,
      loopDirection = "forward"
    }
  }

  -- And, create the player that it belongs to
  local mob = display.newSprite( sheet_character, sequencesData)
  mob:setSequence("chase")
  mob:setFrame( 5 )

  group:insert( mob, true )
  mob.dispGroup = group

  --group:scale(0.5,0.5)

  return { group=group, anim=mob }
end

return generateMonster
