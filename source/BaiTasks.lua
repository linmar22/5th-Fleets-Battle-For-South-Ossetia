--[[This file allows the player to create a BAI Mission using the radio
This will spawn a random group of enemy units in a random zone.
Radio items are available for the player to get the coordinates of the enemy unit]]--

--flags to indicate when a mission needs to be started or ended
flagBlueBaiMissionStart = USERFLAG:New("blueBaiMissionStart")
flagBlueBaiMissionStart:Set(0)
flagBlueBaiMissionEnd = USERFLAG:New("blueBaiMissionEnd")
flagBlueBaiMissionEnd:Set(0)
flagBlueBaiMissionRunning = USERFLAG:New("blueBaiMissionRunning")
flagBlueBaiMissionRunning:Set(0)

--Declare BAI Zones, sorted into area tables (South Ossetia, Abkhazia, and North Ossetia

local redZoneSizes = {6,0,0}
local redBaiZones = {}
local zoneIndex = 1
for i=1,#redZoneSizes do
  redBaiZones[i] = {}
  for j=1,redZoneSizes[i]  do    
    if j < 10 then
      redBaiZones[i][j] = ZONE:New("red BAI Zone #00"..zoneIndex)
    else if j < 100 then
      redBaiZones[i][j] = ZONE:New("red BAI Zone #0"..zoneIndex)
    else
      redBaiZones[i][j] = ZONE:New("red BAI Zone #"..zoneIndex)
      end
    end
    zoneIndex = zoneIndex + 1
  end
end

--activate flag to start a blue BAI mission
local function startBlueBaiMission()
  flagBlueBaiMissionStart:Set(1)
end

---Routes the given group to a random zone in a list, mainly via road
--@param #GROUP group is the group that is assigned the route
--@param #ZONE zoneTable is the table of possible destination ZONEs
--@return #ZONE destZone route's destination zone 
local function routeToRandomZoneOnRoad(group,zoneTable)
  local rand
  local destZone
  repeat
    rand = math.random(#zoneTable)
    destZone = zoneTable[rand]
  until(not group:IsAnyInZone(destZone))
  group:RouteGroundOnRoad(destZone:GetCoordinate(),60,2)
  return destZone
end

--spawn the target group for BAI that will route to a random zone
local function spawnBaiMission(enemyTemplates,spawnZones,destinationZones)
  local rand = math.random(#enemyTemplates)
  local rand2 = math.random(#spawnZones)
  local enemySpawn = SPAWN:NewWithAlias(enemyTemplates[rand],"enemy BAI Group")
  local enemyGroup = enemySpawn:SpawnInZone(spawnZones[rand2],true)
  local destinationZone = routeToRandomZoneOnRoad(enemyGroup,destinationZones)
  return enemyGroup,destinationZone
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
    local rand = math.random(#redBaiZones)
    blueBaiEnemyGroup, blueBaiEnemyDestination = spawnBaiMission(redBai,redBaiZones[rand],redBaiZones[rand])    
    blueBaiMissionGetCoordinatesOption = MENU_COALITION:New(coalition.side.BLUE,"Get BAI Mission Coordinates",blueBaiMissionOptions)
    blueBaiMissionGetCoordinatesLLDMS = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"LL DMS",blueBaiMissionGetCoordinatesOption,getMissionCoordinatesLLDMS,blueBaiEnemyGroup)
    blueBaiMissionGetCoordinatesLLDDM = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"LL DDM",blueBaiMissionGetCoordinatesOption,getMissionCoordinatesLLDDM,blueBaiEnemyGroup)
    blueBaiMissionGetCoordinatesMGRS = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"MGRS",blueBaiMissionGetCoordinatesOption,getMissionCoordinatesMGRS,blueBaiEnemyGroup)
    
     --Create Menu for cancelling the mission
    blueBaiMissionCancel = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Cancel Mission",blueBaiMissionOptions,blueCancelBaiMission)
    
    blueBaiMissionStart:Remove()
    flagBlueBaiMissionStart:Set(0)
    flagBlueBaiMissionRunning:Set(1)
  end
  
  if flagBlueBaiMissionRunning:Is(1) then
    --If enemy Group has reached its destination, then route to a new zone
    if blueBaiEnemyGroup:IsAnyInZone(blueBaiEnemyDestination) then
      blueBaiEnemyDestination = routeToRandomZoneOnRoad(blueBaiEnemyGroup,redBaiZones)
    end
  end
  
  --Once mission is flagged to end, remove uneeded menus, add start menu commmand and remove enemy groups
  if flagBlueBaiMissionEnd:Is(1) then
    removeBaiUnits(blueBaiEnemyGroup)
    blueBaiMissionStart = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Start BAI Mission",blueBaiMissionOptions,startBlueBaiMission,{})
    blueBaiMissionGetCoordinatesOption:Remove()
    blueBaiMissionCancel:Remove()
    flagBlueBaiMissionRunning:Set(0)
    flagBlueBaiMissionEnd:Set(0)
  end
end


blueBaiMissionOptions = MENU_COALITION:New(coalition.side.BLUE,"BAI Mission")
blueBaiMissionStart = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Start BAI Mission",blueBaiMissionOptions,startBlueBaiMission)

baiTasksScheduler = SCHEDULER:New(nil,baiTasksMain,{},1,1)
baiTasksScheduler:Start()