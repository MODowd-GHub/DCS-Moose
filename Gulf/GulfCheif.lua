local SamSet = SET_GROUP:New():FilterPrefixes("Red SAM"):FilterCoalitions("red"):FilterStart()
Redshorad = SHORAD:New("RedShorad", "Red SHORAD", SamSet, 22000, 600, "red")
--Redshorad:SwitchDebug(true)
--Set up both IADS
rediads = MANTIS:New("rediads","Red SAM","Red EWR","Red HQ","red",true,"Red AWACS")
rediads:SetAutoRelocate(true, true) -- make HQ and EWR relocatable, if they are actually mobile in DCS!
rediads:SetAdvancedMode(true, 100) -- switch on advanced mode - detection will slow down or die if HQ and EWR die
rediads:SetSAMRange(90)
--rediads:AddShorad(RedShorad,600)
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
local AgentsRed=SET_GROUP:New():FilterPrefixes({"Red EWR", "Red AWACS"}):FilterOnce()
--Set up Red Squadrons

--ADD THE SQUADRONs
--- MIG-29 Fighter Squadron.
local SquadBandar=SQUADRON:New("SQ IRI F4", 4, "24th") --Ops.Squadron#SQUADRON
SquadBandar:SetGrouping(2) -- Two aircraft per group X 6 = 12 airframes
SquadBandar:SetModex(130)  -- Tail number of the sqaud start with 130, 131,...
SquadBandar:SetTakeoffAir()
SquadBandar:AddMissionCapability({ AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 100) -- Squad can do intercept missions.
SquadBandar:SetMissionRange(50) -- Squad will be considered for targets within 100NM of its airwing location.

--F-5 Squadron.
local SquadQeshm=SQUADRON:New("SQ IRI F5", 2, "243rd") --Ops.Squadron#SQUADRON
SquadQeshm:SetGrouping(2) -- Two aircraft per group X 6 = 12 airframes
SquadQeshm:SetModex(004)  -- Tail number of the sqaud start with 130, 131,...
SquadQeshm:SetTakeoffAir()
SquadQeshm:AddMissionCapability({ AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 100)  -- Squad can do intercept missions.
SquadQeshm:SetMissionRange(50) -- Squad will be considered for targets within 50 NM of its airwing location.

local SquadQeshmSEAD=SQUADRON:New("SQ CCCP SU-24 SEAD", 6, "39th") --Ops.Squadron#SQUADRON
SquadQeshmSEAD:SetGrouping(2) -- Two aircraft per group X 6 = 12 airframes
SquadQeshmSEAD:SetModex(30)  -- Tail number of the sqaud start with 130, 131,...
SquadQeshmSEAD:SetTakeoffAir()
SquadQeshmSEAD:AddMissionCapability({AUFTRAG.Type.SEAD,AUFTRAG.Type.ALERT5}, 100) -- Squad can do SEAD missions.
--SquadBackfire:AddMissionCapability({AUFTRAG.Type.ALERT5})        -- Squad can be spawned at the airfield in uncontrolled state.
SquadQeshmSEAD:SetMissionRange(100) -- Squad will be considered for targets within 350 NM of its airwing location.

--Backfire Squadron
local SquadBackfire=SQUADRON:New("SQ CCCP TU-22M", 6, "23rd") --Ops.Squadron#SQUADRON
SquadBackfire:SetGrouping(4) -- Two aircraft per group X 6 = 12 airframes
SquadBackfire:SetModex(130)  -- Tail number of the sqaud start with 130, 131,...
SquadBackfire:SetTakeoffAir()
SquadBackfire:AddMissionCapability({AUFTRAG.Type.ANTISHIP,AUFTRAG.Type.ALERT5}, 100) -- Squad can do intercept missions.
--SquadBackfire:AddMissionCapability({AUFTRAG.Type.ALERT5})        -- Squad can be spawned at the airfield in uncontrolled state.
SquadBackfire:SetMissionRange(500) -- Squad will be considered for targets within 350 NM of its airwing location.

--F1 tactical CAP

local SquadJask=SQUADRON:New("SQ IRI F1", 2, "67th") --Ops.Squadron#SQUADRON
SquadJask:SetGrouping(2) -- Two aircraft per group X 6 = 12 airframes
SquadJask:SetModex(13)  -- Tail number of the sqaud start with 130, 131,...
SquadJask:SetTakeoffHot()
SquadJask:AddMissionCapability( {AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 95) -- Squad can do intercept missions.

local SquadBear=SQUADRON:New("SQ CCCP TU-95MSM CHM", 6, "56th") --Ops.Squadron#SQUADRON
SquadBear:SetGrouping(4) -- Two aircraft per group X 6 = 12 airframes
SquadBear:SetModex(130)  -- Tail number of the sqaud start with 130, 131,...
SquadBear:SetTakeoffAir()
SquadBear:AddMissionCapability({AUFTRAG.Type.ANTISHIP,AUFTRAG.Type.ALERT5}, 100) -- Squad can do intercept missions.
--SquadBackfire:AddMissionCapability({AUFTRAG.Type.ALERT5})        -- Squad can be spawned at the airfield in uncontrolled state.
SquadBear:SetMissionRange(350) -- Squad will be considered for targets within 350 NM of its airwing location.


--- Add the Airwings
local BandarWing=AIRWING:New("Bandar Airbase", "24th") --Ops.AirWing#AIRWING
local BackfireWing=AIRWING:New("Shiraz Airbase", "23rd") --Ops.AirWing#AIRWING
local QeshmWing=AIRWING:New("Qeshm Airbase", "243rd") --Ops.AirWing#AIRWING
local JaskWing=AIRWING:New("Jask Airbase","67th")
local JiroftWing=AIRWING:New("Jiroft Airbase","56th")
--Add squadrons to wings
BandarWing:AddSquadron(SquadBandar)
BackfireWing:AddSquadron(SquadBackfire)
QeshmWing:AddSquadron(SquadQeshm)
QeshmWing:AddSquadron(SquadQeshmSEAD)
JaskWing:AddSquadron(SquadJask)
-- Payload: This payload is used for GCICAP, INTERCEPT and CAP missions. 
--          Only two are available ==> Only two missions can be started simultaniously.
--          Payloads are returned when the assets returns to the airwing.
BandarWing:NewPayload(GROUP:FindByName("SQ IRI F4"), -1, {AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP,AUFTRAG.Type.ALERT5}, 100)
BackfireWing:NewPayload(GROUP:FindByName("SQ CCCP TU-22M"), -1, {AUFTRAG.Type.ANTISHIP,AUFTRAG.Type.ALERT5 }, 100)
JiroftWing:NewPayload(GROUP:FindByName("SQ CCCP TU-95MSM CHM"), -1, {AUFTRAG.Type.ANTISHIP,AUFTRAG.Type.ALERT5 }, 100)
QeshmWing:NewPayload(GROUP:FindByName("SQ IRI F5"), -1, {AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 95)
QeshmWing:NewPayload(GROUP:FindByName("SQ CCCP SU-24 SEAD"), -1, {AUFTRAG.Type.SEAD, AUFTRAG.Type.CASENHANCED, AUFTRAG.Type.ALERT5, }, 95)
JaskWing:NewPayload(GROUP:FindByName("SQ IRI F1"), -1, {AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 95)
-- RedChief OF STAFF
---

-- Zone defining the border of the red territory.
local ZoneredBorder=ZONE_POLYGON:New( "CCCP Border", GROUP:FindByName( "Red Border" ) )

-- red AgentsRed.
local AgentsRed=SET_GROUP:New():FilterPrefixes({"Red EWR", "Red AWACS"}):FilterOnce()

-- Define RedChief.  
local RedChief=CHIEF:New(coalition.side.RED, AgentsRed)

-- Add border zone.
RedChief:AddBorderZone(ZoneredBorder)


-- Launch at least one but at most four asset groups for INTERCEPT missions if the threat level of the target is great or equal to six.
RedChief:SetResponseOnTarget(2, 4, 6, nil, AUFTRAG.Type.INTERCEPT)
RedChief:SetResponseOnTarget(4, 20, 3, TARGET.Category.NAVAL, AUFTRAG.Type.ANTISHIP)


-- Add airwing(s) to the RedChief.
RedChief:AddAirwing(BandarWing)
RedChief:AddAirwing(BackfireWing)
RedChief:AddAirwing(QeshmWing)
RedChief:AddAirwing(JaskWing)
RedChief:AddAirwing(JiroftWing)
-- Set strategy to DEFENSIVE: Only targets within the border of the RedChief's territory are attacked.
RedChief:SetStrategy(RedChief.Strategy.AGGRESSIVE) --Changed this from defensive to try spawn more then one MIG flight
RedChief:SetTacticalOverviewOn()--Test Overview
local CarrierStrike=AUFTRAG:NewANTISHIP(GROUP:FindByName( "TF-1" ), 25000)
CarrierStrike:SetMissionSpeed(550)
CarrierStrike:SetWeaponExpend(32)

-- Assign mission to Cheif.

RedChief:AddMission(CarrierStrike)

-- Start RedChief after 5 seconds to make sure the ME groups spawn correctly.
RedChief:__Start(5)


