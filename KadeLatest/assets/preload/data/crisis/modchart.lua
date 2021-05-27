function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
end

function update (elapsed) -- example https://twitter.com/KadeDeveloper/status/1382178179184422918
	local currentBeat = (songPos / 1000)*(bpm/60)
	local shaking = false;
	local testlist = {0, 4, 1, 5, 2, 6, 3, 7}

	if ( (currentBeat >= 208 and currentBeat < 224) or (currentBeat >= 240 and currentBeat < 256) ) then
		shaking = true;
	end
	
	if not (shaking) then
		--for i,v in ipairs(testlist) do
			--setActorX(_G['defaultStrum'..(i-1)..'X'] + 32 * math.sin((currentBeat/1)-2), v)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat/1)-2), i)
		end
		setCamPosition(0, 0)
		setCameraZoom(1)
	else
		setWindowPos(winX, winY)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + (16 * math.sin((currentBeat/1)-2)) + ((math.random(10, 30) * 0.2) - 2), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 16 + ((math.random(10, 30) * 0.2) - 2), i)
		end
		setCamPosition(((math.random(10, 30) * 0.5) - 2), ((math.random(10, 30) * 0.5) - 2))
		setCameraZoom(0.9)
	end
end

function beatHit (beat)
   -- do nothing
end

function stepHit (step)
	-- do nothing
end

print("Mod Chart script loaded :)")