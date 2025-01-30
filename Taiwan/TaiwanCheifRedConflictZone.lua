local SamSet = SET_GROUP:New():FilterPrefixes("Red SAM"):FilterCoalitions("red"):FilterStart()
Redshorad = SHORAD:New("RedShorad", "Red SHORAD", SamSet, 22000, 600, "red")
--Redshorad:SwitchDebug(true)
--Set up both IADS
rediads = MANTIS:New("rediads","Red SAM","Red EWR","Red HQ","red",true,"Red Awacs")
rediads:SetAutoRelocate(true, true) -- make HQ and EWR relocatable, if they are actually mobile in DCS!
rediads:SetAdvancedMode(true, 100) -- switch on advanced mode - detection will slow down or die if HQ and EWR die
rediads:SetSAMRange(90)
--rediads:Debug(true)
--rediads.verbose = true -- watch DCS.log
rediads:Start()

blueiads = MANTIS:New("blueiads","Blue SAM","Blue EWR","Blue HQ","blue",true,"Blue AWACS")
blueiads:SetAutoRelocate(true, true) -- make HQ and EWR relocatable, if they are actually mobile in DCS!
blueiads:SetAdvancedMode(true, 100)
blueiads:SetSAMRange(90)
--blueiads:Debug(true)
--blueiads.verbose = true -- watch DCS.log
blueiads:Start()

-- red AgentsRed.
local AgentsRed=SET_GROUP:New():FilterPrefixes({"Red EWR", "Red Awacs"}):FilterOnce()
--Set up Red Squadrons

local SquadRene=SQUADRON:New("SQ PLAAF J-10", 2, "773rd") --Ops.Squadron#SQUADRON
SquadRene:SetGrouping(2) -- Two aircraft per group X 2 = 8 airframes
SquadRene:SetModex(130)  -- Tail number of the sqaud start with 130, 131,...
SquadRene:SetTakeoffAir()
SquadRene:AddMissionCapability({ AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 100) -- Squad can do intercept missions.
SquadRene:SetMissionRange(150) -- Squad will be considered for targets within 200 NM of its airwing location.

local SquadBassel=SQUADRON:New("SQ PLAAF J-11#2", 4, "24th") --Ops.Squadron#SQUADRON
SquadBassel:SetGrouping(2) -- Two aircraft per group X 2 = 4 airframes
SquadBassel:SetModex(17)  -- Tail number of the sqaud start with 130, 131,...
SquadBassel:SetTakeoffAir()
SquadBassel:AddMissionCapability({ AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 100) -- Squad can do intercept missions.
SquadBassel:SetMissionRange(150) -- Squad will be considered for targets within 200 NM of its airwing location.

local SquadHatay=SQUADRON:New("SQ PLAAF J-11", 4, "6th") --Ops.Squadron#SQUADRON
SquadHatay:SetGrouping(2) -- Two aircraft per group X 3 = 6 airframes
SquadHatay:SetModex(17)  -- Tail number of the sqaud start with 130, 131,...
SquadHatay:SetTakeoffAir()
SquadHatay:AddMissionCapability({ AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 100) -- Squad can do intercept missions.
SquadHatay:SetMissionRange(150) -- Squad will be considered for targets within 200 NM of its airwing location.

local SquadDamascus=SQUADRON:New("SQ PLAAF J-10", 4, "19th") --Ops.Squadron#SQUADRON
SquadDamascus:SetGrouping(2) -- 4 aircraft per group X 2 = 8 airframes
SquadDamascus:SetModex(17)  -- Tail number of the sqaud start with 130, 131,...
SquadDamascus:SetTakeoffAir()
SquadDamascus:AddMissionCapability({ AUFTRAG.Type.GCICAP,AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 100) -- Squad can do intercept missions.
SquadDamascus:SetMissionRange(150) -- Squad will be considered for targets within 200 NM of its airwing location.

---Backfire Squadron
local SquadBadger=SQUADRON:New("SQ PLAAF Badger", 2, "2nd") --Ops.Squadron#SQUADRON
SquadBadger:SetGrouping(4) -- 4 aircraft per group X 6 = 12 airframes
SquadBadger:SetModex(130)  -- Tail number of the sqaud start with 130, 131,...
SquadBadger:SetTakeoffAir()
SquadBadger:AddMissionCapability({AUFTRAG.Type.ANTISHIP}, 100) -- Squad can do intercept missions.
--SquadKobuleti:AddMissionCapability({AUFTRAG.Type.ALERT5})        -- Squad can be spawned at the airfield in uncontrolled state.
SquadBadger:SetMissionRange(300) -- Squad will be considered for targets within 200 NM of its airwing location.

--Add the airwings
local ReneWing=AIRWING:New("Warehouse Rene Mouawad", "773rd") --Ops.AirWing#AIRWING
ReneWing:AddSquadron(SquadRene)
ReneWing:NewPayload(GROUP:FindByName("SQ PLAAF J-10"), -1, {AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP,AUFTRAG.Type.ALERT5}, 100)

local BasselWing=AIRWING:New("Warehouse Bassel Al-Assad", "24th") --Ops.AirWing#AIRWING
BasselWing:AddSquadron(SquadBassel)
BasselWing:NewPayload(GROUP:FindByName("SQ PLAAF J-11#2"), -1, {AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP,AUFTRAG.Type.ALERT5}, 100)

local HatayWing=AIRWING:New("Warehouse Hatay", "6th") --Ops.AirWing#AIRWING
HatayWing:AddSquadron(SquadHatay)
HatayWing:NewPayload(GROUP:FindByName("SQ PLAAF J-11"), -1, {AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP,AUFTRAG.Type.ALERT5}, 100)

local DamascusWing=AIRWING:New("Warehouse Damascus", "19th") --Ops.AirWing#AIRWING
DamascusWing:AddSquadron(SquadHatay)
DamascusWing:NewPayload(GROUP:FindByName("SQ PLAAF J-10"), -1, {AUFTRAG.Type.GCICAP,AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP,AUFTRAG.Type.ALERT5}, 100)


local BadgerWing=AIRWING:New("Warehouse Damascus", "2nd") --Ops.AirWing#AIRWING
BadgerWing:AddSquadron(SquadBadger)
BadgerWing:NewPayload(GROUP:FindByName("SQ PLAAF Badger"), -1, {AUFTRAG.Type.ANTISHIP}, 100)



--Set PRC Border
local ZoneredBorder=ZONE_POLYGON:New( "PRC Border", GROUP:FindByName( "PRC Border" ) )
local CAPZone1= ZONE:New("RedCapZone1")   
local CAPZone2= ZONE:New("RedCapZone2")   
local ADZ= ZONE_POLYGON:New("RedConflict", GROUP:FindByName("RedConflict"))
-- red AgentsRed.
local AgentsRed=SET_GROUP:New():FilterPrefixes({"Red EWR", "Red Awacs"}):FilterOnce()

-- Define RedChief.  
local RedChief=CHIEF:New(coalition.side.RED, AgentsRed)

-- Add border zone.
RedChief:AddBorderZone(ZoneredBorder)
RedChief:AddConflictZone(ADZ)
RedChief:SetTacticalOverviewOn()--Test Overview

-- Launch at least one but at most four asset groups for INTERCEPT missions if the threat level of the target is great or equal to six.
RedChief:SetResponseOnTarget(2, 4, 6, nil, AUFTRAG.Type.INTERCEPT)
RedChief:SetResponseOnTarget(2, 6, 6, TARGET.Category.NAVAL, AUFTRAG.Type.ANTISHIP)
--Add the Airwings to teh Cheif
RedChief:AddAirwing(ReneWing)
RedChief:AddAirwing(BasselWing)
RedChief:AddAirwing(HatayWing)
RedChief:AddAirwing(DamascusWing)
RedChief:AddAirwing(BadgerWing)
RedChief:AddGciCapZone(CAPZone2, 25000, 275, 0, 15)
-- Set strategy to DEFENSIVE: Only targets within the border of the RedChief's territory are attacked.
RedChief:SetStrategy(RedChief.Strategy.AGGRESSIVE) --Changed this from defensive to try spawn more than one MIG flight
RedChief:SetLimitMission(5, AUFTRAG.Type.INTERCEPT)
RedChief:AddGciCapZone(CAPZone2, 25000, 275, 0, 15)
-- Start RedChief after 5 seconds.
RedChief:__Start(5)
--RedConflict





