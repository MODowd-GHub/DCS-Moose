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

local SquadKibrit=SQUADRON:New("SQ RED MIG-29", 4, "3rd") --Ops.Squadron#SQUADRON
SquadKibrit:SetGrouping(2) -- Two aircraft per group X 2 = 8 airframes
SquadKibrit:SetModex(130)  -- Tail number of the sqaud start with 130, 131,...
SquadKibrit:SetTakeoffAir()
SquadKibrit:AddMissionCapability({ AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 95) -- Squad can do intercept missions.
SquadKibrit:SetMissionRange(150) -- Squad will be considered for targets within 150 NM of its airwing location.

local SquadBaluza=SQUADRON:New("SQ RED MIG-21", 4, "14th") --Ops.Squadron#SQUADRON
SquadBaluza:SetGrouping(2) -- Two aircraft per group X 2 = 4 airframes
SquadBaluza:SetModex(170)  -- Tail number of the sqaud start with 130, 131,...
SquadBaluza:SetTakeoffAir()
SquadBaluza:AddMissionCapability({ AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 100) -- Squad can do intercept missions.
SquadBaluza:SetMissionRange(100) -- Squad will be considered for targets within 200 NM of its airwing location.

local SquadCairo=SQUADRON:New("SQ RED SU-27", 4, "6th") --Ops.Squadron#SQUADRON
SquadCairo:SetGrouping(2) -- Two aircraft per group X 3 = 6 airframes
SquadCairo:SetModex(17)  -- Tail number of the sqaud start with 130, 131,...
SquadCairo:SetTakeoffAir()
SquadCairo:AddMissionCapability({ AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 100) -- Squad can do intercept missions.
SquadCairo:SetMissionRange(200) -- Squad will be considered for targets within 200 NM of its airwing location.


---Backfire Squadron
local SquadBackfire=SQUADRON:New("SQ RED Backfire", 3, "2nd") --Ops.Squadron#SQUADRON
SquadBackfire:SetGrouping(4) -- 4 aircraft per group X 6 = 12 airframes
SquadBackfire:SetModex(130)  -- Tail number of the sqaud start with 130, 131,...
SquadBackfire:SetTakeoffAir()
SquadBackfire:AddMissionCapability({AUFTRAG.Type.ANTISHIP}, 100) -- Squad can do intercept missions.
--SquadKobuleti:AddMissionCapability({AUFTRAG.Type.ALERT5})        -- Squad can be spawned at the airfield in uncontrolled state.
SquadBackfire:SetMissionRange(300) -- Squad will be considered for targets within 300 NM of its airwing location.

--Add the airwings
local KibritWing=AIRWING:New("Kibrit Airbase", "3rd") --Ops.AirWing#AIRWING
KibritWing:AddSquadron(SquadKibrit)
KibritWing:NewPayload(GROUP:FindByName("SQ RED MIG-29"), -1, {AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP,AUFTRAG.Type.ALERT5}, 95)

local BaluzaWing=AIRWING:New("Baluza Airbase", "14th") --Ops.AirWing#AIRWING
BaluzaWing:AddSquadron(SquadBaluza)
BaluzaWing:NewPayload(GROUP:FindByName("SQ RED MIG-21"), -1, {AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP,AUFTRAG.Type.ALERT5}, 100)

local CairoWing=AIRWING:New("Cairo West Airbase", "6th") --Ops.AirWing#AIRWING
CairoWing:AddSquadron(SquadCairo)
CairoWing:NewPayload(GROUP:FindByName("SQ RED SU-27"), -1, {AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP,AUFTRAG.Type.ALERT5}, 100)


local BackfireWing=AIRWING:New("Cairo West Airbase", "2nd") --Ops.AirWing#AIRWING
BackfireWing:AddSquadron(SquadBackfire)
BackfireWing:NewPayload(GROUP:FindByName("SQ RED Backfire"), -1, {AUFTRAG.Type.ANTISHIP}, 100)


--Set PRC Border
local ZoneredBorder=ZONE_POLYGON:New( "Arab Border", GROUP:FindByName( "Red Border" ) )
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
RedChief:AddAirwing(KibritWing)
RedChief:AddAirwing(BaluzaWing)
RedChief:AddAirwing(CairoWing)
RedChief:AddAirwing(BackfireWing)
--RedChief:AddGciCapZone(CAPZone2, 25000, 275, 0, 15)
-- Set strategy to DEFENSIVE: Only targets within the border of the RedChief's territory are attacked.
RedChief:SetStrategy(RedChief.Strategy.AGGRESSIVE) --Changed this from defensive to try spawn more than one MIG flight
RedChief:SetLimitMission(5, AUFTRAG.Type.INTERCEPT)
--RedChief:AddGciCapZone(CAPZone2, 25000, 275, 0, 15)
-- Start RedChief after 5 seconds.
RedChief:__Start(5)
--RedConflict