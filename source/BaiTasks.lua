--[[This file allows the player to create a BAI Mission using the radio
This will spawn a random group of enemy units in a random zone.
Radio items are available for the player to get the coordinates of the enemy unit]]--

--flags to indicate when a mission needs to be started or ended
flagBlueBaiMissionStart = USERFLAG:New("blueMissionStart")
flagBlueBaiMissionStart:Set(0)
flagBlueBaiMissionEnd = USERFLAG:New("blueMissionEnd")
flagBlueBaiMissionEnd:Set(0)

--Declare BAI Zones
redBaiZones = {}
redBaiZones[1] = ZONE:New("red BAI Zone #001")

--activate flag to start a blue BAI mission
local function startBlueBaiMission()
  flagBlueBaiMissionStart:Set(1)
end

--spawn the target group for BAI
local function spawnBaiMission(enemyTemplates,spawnZones)
  local rand = math.random(table.getn(enemyTemplates))
  local rand2 = math.random(table.getn(spawnZones))
  local enemySpawn = SPAWN:NewWithAlias(enemyTemplates[rand],"enemy BAI Group")
  local enemyGroup = enemySpawn:SpawnInZone(spawnZones[rand2],true)
  return enemyGroup
end

local function getMissionCoordinatesLLDMS(enemyGroup)
  local missionCoord = enemyGroup:GetCoordinate()
  local coordmessage = MESSAGE:New(missionCoord:ToStringLLDMS(),30)
  if enemyGroup:GetCoalition() == coalition.side.BLUE then
    coordmessage:ToRed()
  else
    coordmessage:ToBlue()
  end
end

local function getMissionCoordinatesLLDDM(enemyGroup)
  local missionCoord = enemyGroup:GetCoordinate()
  local coordmessage = MESSAGE:New(missionCoord:ToStringLLDDM(),30)
  if enemyGroup:GetCoalition() == coalition.side.BLUE then
    coordmessage:ToRed()
  else
    coordmessage:ToBlue()
  end
end

local function getMissionCoordinatesMGRS(enemyGroup)
  local missionCoord = enemyGroup:GetCoordinate()
  local coordmessage = MESSAGE:New(missionCoord:ToStringMGRS(),30)
  if enemyGroup:GetCoalition() == coalition.side.BLUE then
    coordmessage:ToRed()
  else
    coordmessage:ToBlue()
  end
end

--activates flag to end the mission
local function blueCancelBaiMission()
  flagBlueBaiMissionEnd:Set(1)
end

--remove all BAI Units remaining in the game
local function removeBaiUnits(enemyGroup)
  enemyGroup:Destroy()
end

--Scheduled function that monitors for flag changes
local function baiTasksMain()
  --If flag to start mission is activated, spawn targets and add radio items to give coordinates
  if flagBlueBaiMissionStart:Is(1) then
    blueEnemyGroup = spawnBaiMission(redBai,redBaiZones)    
    blueBaiMissionGetCoordinatesOption = MENU_COALITION:New(coalition.side.BLUE,"Get BAI Mission Coordinates",blueBaiMissionOptions)
    blueBaiMissionGetCoordinatesLLDMS = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"LL DMS",blueBaiMissionGetCoordinatesOption,getMissionCoordinatesLLDMS,blueEnemyGroup)
    blueBaiMissionGetCoordinatesLLDDM = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"LL DDM",blueBaiMissionGetCoordinatesOption,getMissionCoordinatesLLDDM,blueEnemyGroup)
    blueBaiMissionGetCoordinatesMGRS = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"MGRS",blueBaiMissionGetCoordinatesOption,getMissionCoordinatesMGRS,blueEnemyGroup)
    
     --Create Menu for cancelling the mission
    blueBaiMissionCancel = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Cancel Mission",blueBaiMissionOptions,blueCancelBaiMission)
    
    blueBaiMissionStart:Remove()
    flagBlueBaiMissionStart:Set(0)
  end
  
  if flagBlueBaiMissionEnd:Is(1) then
    removeBaiUnits(blueEnemyGroup)
    blueBaiMissionStart = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Start BAI Mission",blueBaiMissionOptions,startBlueBaiMission,{})
    blueBaiMissionGetCoordinatesOption:Remove()
    blueBaiMissionCancel:Remove()
    flagBlueBaiMissionEnd:Set(0)
  end
end


blueBaiMissionOptions = MENU_COALITION:New(coalition.side.BLUE,"BAI Mission")
blueBaiMissionStart = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Start BAI Mission",blueBaiMissionOptions,startBlueBaiMission)

baiTasksScheduler = SCHEDULER:New(nil,baiTasksMain,{},1,1)
baiTasksScheduler:Start()