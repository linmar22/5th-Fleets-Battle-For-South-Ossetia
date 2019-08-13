--[[This file allows the player to create a CAS mission using the radio menu.
Player chooses a CAS mission in a selected area of the AO.  A random OPFOR group
is spawned in a random zone, with a friendly group spawning nearby.  An invisible
drone is also spawned to act as a reliable JTAC.  Player can then use Radio to get info on
Las and command JTAC to smoke, lase ect.]]--

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

--initial math random to prevent same number being initialized
math.random()


--function to spawn CAS Mission in random area with random units
function spawnCasMission(argumentTable)
  local rand1 = math.random(table.getn(argumentTable[1]))
  local rand2 = math.random(table.getn(argumentTable[2]))
  local rand3 = math.random(table.getn(argumentTable[3]))
  local enemySpawn = SPAWN:NewWithAlias(argumentTable[1][rand1],"enemy CAS")
  enemySpawn:SpawnInZone(argumentTable[3][rand3],true)
  local friendlySpawn = SPAWN:NewWithAlias(argumentTable[2][rand2],"friendly CAS")
  friendlySpawn:SpawnInZone(argumentTable[4][rand3],true)
end


--Add menu item for CAS Missions (Coalition dependant)
local blueCasMissionOption = MENU_COALITION:New(coalition.side.BLUE,"A-G Missions")
local blueCasMissionCommand = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Start CAS Mission",blueCasMissionOption,spawnCasMission,{redCAS,blueCAS,redCasZones,blueCasZones})


