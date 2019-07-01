--5th Fleet Battle For South Ossetia is a persistant server mission for the 5th Fleet.
--It contains smart spawned CAP, GCI, BAI and CAS Groups, and options to spawn random ground
--targets.
--
--Created by Shaky Jones (MrEman25)

--set global spawn min/max times
spawnTimeMin = 20
spawnTimeMax = 45

--set CAP Zones
 redCAPZoneAbkhazia = ZONE_POLYGON:New("redCAPZoneAbkhazia",GROUP:FindByName("red CAP Zone Abkhazia"))
 redCAPZoneCrimea = ZONE_POLYGON:New("redCAPZoneCrimea",GROUP:FindByName("red CAP Zone Crimea"))
 redCAPZoneStavropol = ZONE_POLYGON:New("redCAPZoneStavropol",GROUP:FindByName("red CAP Zone Stavropol"))

--create squadrons
local red3rdFighterRgt = 
{
  name = "3rdFighterRgt",
  airbase = AIRBASE.Caucasus.Gudauta,
  template = "red Su-27 CAP Template",
  resources = 20,
  grouping = 2,
  zone = redCAPZoneAbkhazia,
  floor = 6100,
  ceiling = 9100,
  patrolMin = 370,
  patrolMax = 555,
  engageMin = 555,
  engageMax = 1400,
  tanker = nil,
  showOnGround = true,
  TakeoffFromParkingCold = false
}

local red19thFighterRgt = 
{
  name = "19thFighterRgt",
  airbase = AIRBASE.Caucasus.Krymsk,
  template = "red MiG-29S CAP Template",
  resources = 20,
  grouping = 2,
  zone = redCAPZoneAbkhazia,
  floor = 6100,
  ceiling = 9000,
  patrolMin = 370,
  patrolMax = 555,
  engageMin = 555,
  engageMax = 1400,
  tanker = nil,
  showOnGround = true,
  TakeoffFromParkingCold = false
}

local red31stFighterRgt = 
{
  name = "31stFighterRgt",
  airbase = AIRBASE.Caucasus.Mozdok,
  template = "red MiG-29S CAP Template",
  resources = 20,
  grouping = 2,
  zone = redCAPZoneStavropol,
  floor = 6100,
  ceiling = 9000,
  patrolMin = 370,
  patrolMax = 555,
  engageMin = 555,
  engageMax = 1400,
  tanker = nil,
  showOnGround = true,
  TakeoffFromParkingCold = false
}

--red squad table
local redSquads = {
  red3rdFighterRgt,
  red31stFighterRgt,
  red19thFighterRgt,
}

--red CAP squad table
local redCAPSquads = {
  red3rdFighterRgt,
  red31stFighterRgt,
  red19thFighterRgt,
}

--red EWR Detection Group Table
local redEWRDetectionGroups = {
  "67 Air Def Missile Brig. Battery",
  "red EWR",
  "481 Air Def Missile Rgt Battery",
  "3rd Separate AA Missile Rgt."
  
}

--set up EWR networks
local redEWRDetectionSetGroup = SET_GROUP:New()
redEWRDetectionSetGroup:FilterPrefixes(redEWRDetectionGroups)
redEWRDetectionSetGroup:FilterStart()

local redEWRDetection = DETECTION_AREAS:New(redEWRDetectionSetGroup,30000)

redA2ADispatcher = AI_A2A_DISPATCHER:New(redEWRDetection)
redA2ADispatcher:SetEngageRadius(93000)
redA2ADispatcher:SetGciRadius(111000)

--create a squadron for a dispatcher from a squadron table
local function createSquadron(dispatcher,squadron)
  dispatcher:SetSquadron(squadron.name,squadron.airbase,squadron.template,squadron.resources)
end

--create squadrons from a table of squadron tables
local function createSquadrons(dispatcher,squadronTable)
  for i, squad in ipairs(squadronTable) do
    createSquadron(dispatcher,squad)
  end
  return dispatcher
end

--create red and blue squadrons
redA2ADispatcher:SetSquadron(red19thFighterRgt.name,red19thFighterRgt.airbase,red19thFighterRgt.template,red19thFighterRgt.resources)
redA2Adispatcher:SetSquadronCap(red19thFighterRgt.name,red19thFighterRgt.zone,red19thFighterRgt.floor,red19thFighterRgt.ceiling,red19thFighterRgt.patrolMin,red19thFighterRgt.patrolMax,red19thFighterRgt.engageMin,red19thFighterRgt.engageMax,"BARO")
  redA2ADispatcher:SetSquadronCapInterval(red19thFighterRgt.name,1,spawnTimeMin,spawnTimeMax)
  redA2ADispatcher:SetSquadronGrouping(red19thFighterRgt.name,red19thFighterRgt.grouping)
  redA2ADispatcher:SetSquadronLandingAtRunway(red19thFighterRgt.name)
--createSquadrons(redA2ADispatcher,redSquads)

--setup squadron for CAP
local function createCapSquad(dispatcher,squadron)
  dispatcher:SetSquadronCap(squadron.name,squadron.zone,squadron.floor,squadron.ceiling,squadron.patrolMin,squadron.patrolMax,squadron.engageMin,squadron.engageMax,"BARO")
  dispatcher:SetSquadronCapInterval(squadron.name,1,spawnTimeMin,spawnTimeMax)
  dispatcher:SetSquadronGrouping(squadron.name,squadron.grouping)
  dispatcher:SetSquadronLandingAtRunway(squadron.name)
  if squadron.tanker ~= nil then
    dispatcher:SetSquadronTanker(squadron.name,squadron.tanker)
  end
  if squadron.TakeoffFromParkingCold == true then
    dispatcher:SetSquadronTakeoffFromParkingCold(squadron.name)
  end
  if squadron.showOnGround == true then
    dispatcher:SetSquadronVisible(squadron.name)
  end  
  return dispatcher
end

--create CAP Squads based on a given table of squadrons
local function createCapSquads(dispatcher,squadTable)
  for i, squad in ipairs(squadTable) do
    createCapSquad(dispatcher,squad)
  end
  return dispatcher 
end

--setup CAP squads
--createCapSquads(redA2ADispatcher,redCAPSquads)