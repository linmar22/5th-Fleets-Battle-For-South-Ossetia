--[[This file allows the player to create a CAS mission using the radio menu.
Player chooses a CAS mission in a selected area of the AO.  A random OPFOR group
is spawned in a random zone, with a friendly group spawning nearby.  An invisible
drone is also spawned to act as a reliable JTAC.  Player can then use Radio to get info on
Las and command JTAC to smoke, lase ect.]]--

testZone1 = ZONE:New("test zone 1")
testZone2 = ZONE:New("test zone 2")
testZone3 = ZONE:New("test zone 3")
testZone4 = ZONE:New("test zone 4")


CasZones = {
  testZone1,
  testZone2  
}
blueZones = {
  testZone3,
  testZone4
}
rand = math.random(1,table.getn(redCAS))
rand2 = math.random(1,table.getn(CasZones))
rand3 = math.random(1,table.getn(blueCAS))

testCasSpawn = SPAWN:NewWithAlias(redCAS[rand],"CasSpawn")
testCasSpawn:SpawnInZone(CasZones[rand2],true)

testblueCAS = SPAWN:NewWithAlias(blueCAS[rand3],"blueSpawn")
testblueCAS:SpawnInZone(blueZones[rand2],true)

JTACgroup = GROUP:FindByName(blueJtac[rand2])
JTACgroup:Activate()

blueHQ = GROUP:FindByName("blue HQ")
blueCC = COMMANDCENTER:New(blueHQ, "blue HQ")

JtacSetGroup = SET_GROUP:FilterPrefixes(blueJtac[rand2])
JtacSetGroup:FilterStart()
blueDetection = DETECTION_UNITS:New(JtacSetGroup)

attackSet = SET_GROUP:New():FilterPrefixes(redCAS[rand])
attackSet:FilterStart()

jtacDesignation = DESIGNATE:New(blueCC,blueDetection,attackSet)
jtacDesignation:GenerateLaserCodes()
jtacDesignation:MenuStatus()