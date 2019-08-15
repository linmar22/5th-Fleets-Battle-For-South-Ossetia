--[[This file allows the player to create a CAS mission using the radio menu.
Player chooses a CAS mission in a selected area of the AO.  A random OPFOR group
is spawned in a random zone, with a friendly group spawning nearby.  An invisible
drone is also spawned to act as a reliable JTAC.  Player can then use Radio to get info on
Las and command JTAC to smoke, lase ect.]]--

--declare userflag to check if there is a CAS Mission already running.
flagStartblueCasMission = USERFLAG:New("startBlueCasMission")
flagStartblueCasMission:Set(0)
flagblueCasMissionRunning = USERFLAG:New("blueCasMissionRunning")
flagblueCasMissionRunning:Set(0)

SETTINGS:SetA2G_LL_DDM()

--Declare all CAS Zones
local zoneTableSize = 10

redCasZones = {}
blueCasZones = {}
for i=1, zoneTableSize do
  if i < 10 then
    redCasZones[i] = ZONE:New("red CAS Zone #00"..i)
    blueCasZones[i] = ZONE:New("blue CAS Zone #00"..i)
  elseif i < 100 then
    redCasZones[i] = ZONE:New("red CAS Zone #0"..i)
    blueCasZones[i] = ZONE:New("blue CAS Zone #0"..i)
  else
    redCasZones[i] = ZONE:New("red CAS Zone #"..i)
    blueCasZones[i] = ZONE:New("blue CAS Zone #"..i)
  end
end



--function to spawn CAS Mission in random area with random units
local function spawnCasMission(enemyTemplates,friendlyTemplates,enemySpawnZones,friendlySpawnZones)
  local rand1 = math.random(table.getn(enemyTemplates))
  local rand2 = math.random(table.getn(friendlyTemplates))
  local rand3 = math.random(table.getn(enemySpawnZones))
  local enemySpawn = SPAWN:New(enemyTemplates[rand1])
  local enemyGroup = enemySpawn:SpawnInZone(enemySpawnZones[rand3],true)  
  local friendlySpawn = SPAWN:New(friendlyTemplates[rand2])
  friendlySpawn:SpawnInZone(friendlySpawnZones[rand3],true)
  return enemyGroup
end

--spawn a blue JTAC Drone that will orbit the enemy group
local function spawnBlueJtac(enemyGroup)
  local JtacSpawn = SPAWN:NewWithAlias("blue JTAC Template","blue JTAC ")
  local JtacZone = ZONE_GROUP:New("Jtac Group",enemyGroup,100)
  local JtacGroup = JtacSpawn:SpawnInZone(JtacZone,false)
  local JtacTaskOrbit = JtacGroup:TaskOrbitCircle(10000,46,JtacZone:GetCoordinate())
  JtacGroup:SetTask(JtacTaskOrbit,1)
  return JtacGroup  
end

--Set flag to start a blue CAS Mission
function startBlueCasMission()
  flagStartblueCasMission:Set(1)
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

--scheduled function to check if a mission has been set to start
local function casTasksMain()  
  --Startup Mission if CLient has selected CAS Mission in radio command
  if flagStartblueCasMission:Get(1) == 1 then
    blueEnemyGroup = spawnCasMission(redCAS,blueCAS,redCasZones,blueCasZones)
    blueJtac = spawnBlueJtac(blueEnemyGroup)
    
    --Create menu items for displaying coordinates of target area
    blueCasMissionGetCoordinatesOption = MENU_COALITION:New(coalition.side.BLUE,"Get CAS Mission Coordinates",blueCasMissionOptions)
    blueCasMissionGetCoordinatesLLDMS = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"LL DMS",blueCasMissionGetCoordinatesOption,getMissionCoordinatesLLDMS,blueEnemyGroup)
    blueCasMissionGetCoordinatesLLDDM = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"LL DDM",blueCasMissionGetCoordinatesOption,getMissionCoordinatesLLDDM,blueEnemyGroup)
    blueCasMissionGetCoordinatesMGRS = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"MGRS",blueCasMissionGetCoordinatesOption,getMissionCoordinatesMGRS,blueEnemyGroup)
    
    --Create designation options
    blueHQ = GROUP:FindByName("blue HQ")
    blueCC = COMMANDCENTER:New(blueHQ,"Artsivi")
    blueAFAC = SET_GROUP:New():FilterPrefixes("blue JTAC"):FilterStart()
    blueDetection = DETECTION_AREAS:New(blueAFAC,2000)
    bluePcs = SET_GROUP:New():FilterCoalitions("blue"):FilterPrefixes("PC"):FilterStart()
    blueDesignate = DESIGNATE:New(blueCC,blueDetection,bluePcs)
      :SetThreatLevelPrioritization(true)
      :GenerateLaserCodes()
      :AddMenuLaserCode(1113,"Set laser code for Su-25T (%d)")
      :__Detect(-5)
    flagStartblueCasMission:Set(0)
    flagblueCasMissionRunning:Set(1)
    
  --Monitor for all enemy units to be dead in order to end mission and stop scheduled tasks and menu items
  end    
end


blueCasMissionOptions = MENU_COALITION:New(coalition.side.BLUE,"CAS Missions")
blueCasMissionStart = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Start CAS Mission",blueCasMissionOptions,startBlueCasMission,{})    


  
 

casTasksScheduler = SCHEDULER:New(nil,casTasksMain,{},1,1)
casTasksScheduler:Start()
