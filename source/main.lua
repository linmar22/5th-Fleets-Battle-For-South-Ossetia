--5th Fleet Battle For South Ossetia is a persistant server mission for the 5th Fleet.
--It contains smart spawned CAP, GCI, BAI and CAS Groups, and options to spawn random ground
--targets.
--
--Created by Shaky Jones (MrEman25)

--set global spawn min/max times
spawnTimeMin = 1200
spawnTimeMax = 3600

redDetectionSetGroup = SET_GROUP:New()
redDetectionSetGroup:FilterPrefixes({"red EWR","3rd Separate AA","481 Air Def Missile Rgt","Abkhazia S-300","Abkhazia SA-11"})
redDetectionSetGroup:FilterStart()

redDetection = DETECTION_AREAS:New(redDetectionSetGroup,30000)

redA2ADispatcher = AI_A2A_DISPATCHER:New(redDetection)
redA2ADispatcher:SetGciRadius(120)

CAPZoneAbkhazia = ZONE_POLYGON:New("redCAPZoneAbkhazia",GROUP:FindByName("red CAP Zone Abkhazia"))
CAPZoneKrymsk = ZONE_POLYGON:New("redCAPZoneKrymsk",GROUP:FindByName("red CAP Zone Krymsk"))
CAPZoneStavropol = ZONE_POLYGON:New("redZCAPZoneStavropol",GROUP:FindByName("red CAP Zone Stavropol"))


ThirdFighterRgtCap = {
  name = "3rdFighterRgtCap",
  airbase = AIRBASE.Caucasus.Gudauta,
  template = {"red Su27 CAP Template"},
  resources = 10,
  zone = CAPZoneAbkhazia,
  minAlt = 4500,
  maxAlt = 9100,
  minPatrolSpeed = 370,
  maxPatrolSpeed = 555,
  minEngageSpeed = 555,
  maxEngageSpeed = 1400
}

ThirdFighterRgtGci = {
  name = "3rdFighterRgtGci",
  airbase = AIRBASE.Caucasus.Gudauta,
  template = {"red Su27 CAP Template"},
  resources = 10,
  minEngageSpeed = 555,
  maxEngageSpeed = 1400
}

NineteenthFighterRgtCap = {
  name = "19thFighterRgtCap",
  airbase = AIRBASE.Caucasus.Mozdok,
  template = {"red MiG29S CAP Template"},
  resources = 10,
  zone = CAPZoneStavropol,
  minAlt = 4500,
  maxAlt = 9100,
  minPatrolSpeed = 370,
  maxPatrolSpeed = 555,
  minEngageSpeed = 555,
  maxEngageSpeed = 1400
}

NineteenthFighterRgtGci = {
  name = "19thFighterRgtGci",
  airbase = AIRBASE.Caucasus.Mozdok,
  template = {"red MiG29S GCI Template"},
  resources = 10,
  minEngageSpeed = 555,
  maxEngageSpeed = 1400
}

ThirtyfirstGuardFighterRgtCap = {
  name = "31stGuardFighterRgtCap",
  airbase = AIRBASE.Caucasus.Krymsk,
  template = {"red MiG29S CAP Template"},
  resources = 10,
  zone = CAPZoneKrymsk,
  minAlt = 4500,
  maxAlt = 9100,
  minPatrolSpeed = 370,
  maxPatrolSpeed = 555,
  minEngageSpeed = 555,
  maxEngageSpeed = 1400
}

ThirtyfirstGuardFighterRgtGci = {
  name = "31stGuardFighterRgtGci",
  airbase = AIRBASE.Caucasus.Krymsk,
  template = {"red MiG29S GCI Template"},
  resources = 10,
  minEngageSpeed = 555,
  maxEngageSpeed = 1400
}


function createCapSquadron(dispatcher,squadron)
  dispatcher:SetSquadron(squadron.name,squadron.airbase,squadron.template,squadron.resources)
  dispatcher:SetSquadronCap(squadron.name,squadron.zone,squadron.minAlt,squadron.maxAlt,squadron.minPatrolSpeed,squadron.maxPatrolSpeed,squadron.minEngageSpeed,squadron.maxEngageSpeed,"BARO")
  dispatcher:SetSquadronGrouping(squadron.name,2)
  dispatcher:SetSquadronCapInterval(squadron.name,1,spawnTimeMin,spawnTimeMax)
end

createCapSquadron(redA2ADispatcher,ThirdFighterRgtCap)
createCapSquadron(redA2ADispatcher,NineteenthFighterRgtCap)
createCapSquadron(redA2ADispatcher,ThirtyfirstGuardFighterRgtCap)

function createGciSquadron(dispatcher,squadron)
  dispatcher:SetSquadron(squadron.name,squadron.airbase,squadron.template,squadron.resources)
  dispatcher:SetSquadronGci(squadron.name,squadron.minEngageSpeed,squadron.maxEngageSpeed)
end

createGciSquadron(redA2ADispatcher,ThirdFighterRgtGci)
createGciSquadron(redA2ADispatcher, NineteenthFighterRgtGci)
createGciSquadron(redA2ADispatcher,ThirtyfirstGuardFighterRgtGci)