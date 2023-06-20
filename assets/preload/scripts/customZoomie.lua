local realCamZoomie = true
local camBopIntensity = 1
local camBopInterval = 4
-- uses onStepHit, meaning it can hit smaller than beats. 0.25 is one step

local camTwistIntensity = 0
local camTwistIntensity2 = 3
local camTwist = false
local twistAmount = 1
local twistCrap = 1
local extraZoom = 0
-- gotta stay pg somehow

local noPreZoom = {
    defeat = true,
    ['sauces moogus'] = true
}

function onCreate()
    realCamZoomie = getPropertyFromClass('ClientPrefs', 'camZooms')
    -- debugPrint(realCamZoomie)
    setPropertyFromClass('ClientPrefs', 'camZooms', false)
    -- camBopInterval = 1
end

function onCreatePost()
    if noPreZoom[string.lower(songName)] ~= true then
        onEvent('Add Camera Zoom', 0.22, 0)
    end
end

function onDestroy()
    setPropertyFromClass('ClientPrefs', 'camZooms', realCamZoomie)
end

function onStepHit()
    -- debugPrint('step: ', curStep)
    -- debugPrint('beat check: ', curStep % (camBopInterval * 4))
    beatStep()
    if camTwist then
        if curStep % 4 == 0 then
            doTweenY('beatTwistHUD', 'camHUD', -6 * camTwistIntensity2, getPropertyFromClass('Conductor', 'stepCrochet') * 0.002, 'circout')
            doTweenY('beatTwistGame', 'camGame.scroll', 12, getPropertyFromClass('Conductor', 'stepCrochet') * 0.002, 'sinein')
        elseif curStep % 4 == 2 then
            doTweenY('beatTwistHUD', 'camHUD', 0, getPropertyFromClass('Conductor', 'stepCrochet') * 0.002, 'sinein')
            doTweenY('beatTwistGame', 'camGame.scroll', 0, getPropertyFromClass('Conductor', 'stepCrochet') * 0.002, 'sinein')
        end
    end
end

function beatStep()
    if curStep % (camBopInterval * 4) == 0 and getProperty('camZooming') then
        onEvent('Add Camera Zoom', 0.015 * getProperty('camZoomingMult') * camBopIntensity, 0.03 * getProperty('camZoomingMult') * camBopIntensity)
        -- debugPrint('beat intensity: ', 0.015 * getProperty('camZoomingMult') * camBopIntensity)
        -- debugPrint('beat hit! ', camBopInterval)
    end
end

function onBeatHit()
    if camTwist then
        if curBeat % 2 == 0 then
            twistShit = twistAmount
        else
            twistShit = 0-twistAmount
        end
        setProperty('camHUD.angle', twistCrap * camTwistIntensity2)
        setProperty('camGame.angle', twistCrap * camTwistIntensity2)
        doTweenAngle('beatTwistHUD3', 'camHUD', twistCrap * camTwistIntensity, getPropertyFromClass('Conductor', 'stepCrochet') * 0.001, 'circout')
        doTweenX('beatTwistHUD4', 'camHUD', 0-twistCrap * camTwistIntensity, getPropertyFromClass('Conductor', 'stepCrochet') * 0.001, 'linear')
        doTweenAngle('beatTwistGame3', 'camGame', twistCrap * camTwistIntensity, getPropertyFromClass('Conductor', 'stepCrochet') * 0.001, 'circout')
        doTweenX('beatTwistGame4', 'camGame', 0-twistCrap * camTwistIntensity, getPropertyFromClass('Conductor', 'stepCrochet') * 0.001, 'linear')
    end
end

function onEvent(eventName, value1, value2)
    if eventName == 'Camera Twist' then
        camTwist = true
        camTwistIntensity = tonumber(value1)
        camTwistIntensity2 = tonumber(value2)
        if value1 == nil or value1 == '' then camTwistIntensity = 0 end
        if value2 == nil or value2 == '' then camTwistIntensity2 = 0 end
        if camTwistIntensity2 == 0 then
            camTwist = false
            cancelTween('beatTwistGame4')
            cancelTween('beatTwistHUD4')
            doTweenX('beatTwistHUD3', 'camHUD', 0, getPropertyFromClass('Conductor', 'stepCrochet') * 0.002, 'sinein')
            doTweenX('beatTwistGame3', 'camGame.scroll', 0, getPropertyFromClass('Conductor', 'stepCrochet') * 0.002, 'sinein')
            doTweenAngle('beatTwistHUD2', 'camHUD', 0, 1, 'sineinout')
            doTweenAngle('beatTwistGame2', 'camGame', 0, 1, 'sineinout')
            doTweenY('beatTwistHUD', 'camHUD', 0, getPropertyFromClass('Conductor', 'stepCrochet') * 0.002, 'sinein')
            doTweenY('beatTwistGame', 'camGame.scroll', 0, getPropertyFromClass('Conductor', 'stepCrochet') * 0.002, 'sinein')
        end
    end
    if eventName == 'Alter Camera Bop' then
        camBopIntensity = tonumber(value1)
        camBopInterval = tonumber(value2)
        if value1 == nil or value1 == '' then camBopIntensity = 1 end
        if value2 == nil or value2 == '' then camBopInterval = 4 end
        beatStep()
        -- debugPrint(value1, ' hi ', value2)
        -- debugPrint(camBopIntensity, ' hi2 ', camBopInterval)
    end
    if eventName == 'Add Camera Zoom' then
        if realCamZoomie and getPropertyFromClass('flixel.FlxG', 'camera.zoom') < 1.35 then
            local camZoom = tonumber(value1)
            local hudZoom = tonumber(value2)
            if value1 == nil or value1 == '' then camZoom = 0.015 end
            if value2 == nil or value2 == '' then hudZoom = 0.03 end
            -- debugPrint('triggered! ', camZoom)

            -- debugPrint(camZoom, ' ', hudZoom)
            -- debugPrint(value1, ' ', value2)

            setPropertyFromClass('flixel.FlxG', 'camera.zoom', getPropertyFromClass('flixel.FlxG', 'camera.zoom') + camZoom)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + hudZoom)
        end
    end
    if eventName == 'Camera Follow Pos' then
        if value1 == 'mid' or value1 == 'middle' then
            cameraSetTarget('boyfriend')
            local boyCamPos = {getProperty('camFollow.x'), getProperty('camFollow.y')}
            cameraSetTarget('dad')
            local dadCamPos = {getProperty('camFollow.x'), getProperty('camFollow.y')}
            local midCamPos = {(boyCamPos[1] + dadCamPos[1]) / 2, (boyCamPos[2] + dadCamPos[2]) / 2}
            setProperty('camFollow.x', midCamPos[1])
            setProperty('camFollow.y', midCamPos[2])
            setProperty('isCameraOnForcedPos', true)
        end
    end
    if eventName == 'Extra Cam Zoom' then
        -- debugPrint('uhm1 ', value1, ' ', value2)
        setProperty('defaultCamZoom', getProperty('defaultCamZoom') - extraZoom + tonumber(value1))
        -- debugPrint('uhm2 ', value1, ' ', value2)
        extraZoom = tonumber(value1)
    end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    setProperty('camZooming', true)
end