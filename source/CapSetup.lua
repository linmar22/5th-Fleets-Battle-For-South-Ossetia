--[[ This file creates CAP and GCI Squads for blue and red coalition.  Detection gorups are created for an automated dispatcher,
then squadron tables are created.  The squad tables and dispatcher are sent to functions that set them up as CAP or GCI squads 
using MOOSE ]]--

--set globals for spawning flights
spawnTimeMin = 3700
spawnTimeMax = 9000

--create zones for CAP flights to patrol
CAPZoneAbkhazia = ZONE_POLYGON:New("CAPZoneAbkhazia",GROUP:FindByName("CAP Zone Abkhazia"))
CAPZoneBatumi = ZONE_POLYGON:New("capZoneBatumi",GROUP:FindByName("CAP Zone Batumi"))
CAPZoneKrymsk = ZONE_POLYGON:New("CAPZoneKrymsk",GROUP:FindByName("CAP Zone Krymsk"))
CAPZoneStavropol = ZONE_POLYGON:New("CAPZoneStavropol",GROUP:FindByName("CAP Zone Stavropol"))
CAPZoneTurkey = ZONE_POLYGON:New("capZoneTurkey",GROUP:FindByName("CAP Zone Turkey"))



--set up detection set groups and detection objects
redDetectionSetGroup = SET_GROUP:New()
redDetectionSetGroup:FilterPrefixes({"red EWR","3rd Separate AA","481 Air Def Missile Rgt","Abkhazia S-300","Abkhazia SA-11"})
redDetectionSetGroup:FilterStart()
redDetection = DETECTION_AREAS:New(redDetectionSetGroup,30000)

blueDetectionSetGroup = SET_GROUP:New()
blueDetectionSetGroup:FilterPrefixes({"blue SA11","blue EWR","5th Fleet"})
blueDetectionSetGroup:FilterStart()
blueDetection = DETECTION_AREAS:New(blueDetectionSetGroup,30000)

--create dispatchers
redA2ADispatcher = AI_A2A_DISPATCHER:New(redDetection)
redA2ADispatcher:SetGciRadius(120)

blueA2ADispatcher = AI_A2A_DISPATCHER:New(blueDetection)
blueA2ADispatcher:SetGciRadius(120)

--create squadron tables
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

AAFMiG21Gci = {
  name = "AAFMiG21Gci",
  airbase = AIRBASE.Caucasus.Sukhumi_Babushara,
  template = {"red AAF MiG21 Intercept Template"},
  resources = 4,
  minEngageSpeed = 450,
  maxEngageSpeed = 1300,
}

FighterSquadron213Cap = {
  name = "BlacklionsCAP",
  airbase = AIRBASE.Caucasus.Batumi,
  template = {"blue F14B CAP Template"},
  resources = 6,
  zone = CAPZoneTurkey,
  minAlt = 4500,
  maxAlt= 9100,
  minPatrolSpeed = 370,
  maxPatrolSpeed = 555,
  minEngageSpeed = 555,
  maxEngageSpeed = 1400
}

FighterSquadron323Cap = {
  name = "DeathRattlersCAP",
  airbase = AIRBASE.Caucasus.Batumi,
  template = {"blue FA18C CAP Template"},
  resources = 12,
  zone = CAPZoneBatumi,
  minAlt = 4500,
  maxAlt = 9100,
  minPatrolSpeed = 370,
  maxPatrolSpeed = 555,
  minEngageSpeed = 555,
  maxEngageSpeed = 1400,
}

GAFL39SquadGCI = {
  name = "GafL39Gci",
  airbase = AIRBASE.Caucasus.Tbilisi_Lochini,
  template = {"blue L39ZA GCI Template"},
  resources = 2,
  minEngageSpeed = 450,
  maxEngageSpeed = 1300,  
}

FighterSquadron213GCI ={
  name = "BlacklionsGCI",
  airbase = "CVN70",
  template = {"blue F14B CAP Template"},
  resources = 6,
  minEngageSpeed = 555,
  maxEngageSpeed = 1400
}

FighterSquadron323GCI = {
  name = "DeathRattlersGCI",
  airbase = "CVN74",
  template = {"blue FA18C GCI Template"},
  resources = 12,
  minEngageSpeed = 555,
  maxEngageSpeed = 1400,
}

--Function creates a squadron in given dispatcher using given squadron table
function createCapSquadron(dispatcher,squadron)
  dispatcher:SetSquadron(squadron.name,squadron.airbase,squadron.template,squadron.resources)
  dispatcher:SetSquadronCap(squadron.name,squadron.zone,squadron.minAlt,squadron.maxAlt,squadron.minPatrolSpeed,squadron.maxPatrolSpeed,squadron.minEngageSpeed,squadron.maxEngageSpeed,"BARO")
  dispatcher:SetSquadronGrouping(squadron.name,2)
  dispatcher:SetSquadronCapInterval(squadron.name,1,spawnTimeMin,spawnTimeMax)
end

--create CAP squadrons for coalitions
createCapSquadron(redA2ADispatcher,ThirdFighterRgtCap)
createCapSquadron(redA2ADispatcher,NineteenthFighterRgtCap)
createCapSquadron(redA2ADispatcher,ThirtyfirstGuardFighterRgtCap)

createCapSquadron(blueA2ADispatcher,FighterSquadron213Cap)
createCapSquadron(blueA2ADispatcher,FighterSquadron323Cap)

--create a GCI squadron in a given dispatcher using a given squadron table
function createGciSquadron(dispatcher,squadron)
  dispatcher:SetSquadron(squadron.name,squadron.airbase,squadron.template,squadron.resources)
  dispatcher:SetSquadronGci(squadron.name,squadron.minEngageSpeed,squadron.maxEngageSpeed)
end

--create the GCI squads
createGciSquadron(redA2ADispatcher,ThirdFighterRgtGci)
createGciSquadron(redA2ADispatcher, NineteenthFighterRgtGci)
createGciSquadron(redA2ADispatcher,ThirtyfirstGuardFighterRgtGci)
createGciSquadron(redA2ADispatcher,AAFMiG21Gci)

createGciSquadron(blueA2ADispatcher,GAFL39SquadGCI)
--createGciSquadron(blueA2ADispatcher,FighterSquadron213GCI)
--createGciSquadron(blueA2ADispatcher,FighterSquadron323GCI)

--blueA2ADispatcher:SetSquadron(FighterSquadron213GCI.name,FighterSquadron213GCI.airbase,FighterSquadron213GCI.template,FighterSquadron213GCI.resources)
--blueA2ADispatcher:SetSquadronGci(FighterSquadron213GCI.name,FighterSquadron213GCI.minEngageSpeed,FighterSquadron213GCI.maxEngageSpeed)