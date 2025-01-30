local SamSet = SET_GROUP:New():FilterPrefixes("Red SAM"):FilterCoalitions("red"):FilterStart()
Redshorad = SHORAD:New("RedShorad", "Red SHORAD", SamSet, 22000, 600, "red")
--Redshorad:SwitchDebug(true)
--Start the RedMANTIS
redmantis = MANTIS:New("redmantis","Red SAM","Red EWR","Red HQ","red",true,"Red AWACS")
redmantis:SetAutoRelocate(true, true) -- make HQ and EWR relocatable, if they are actually mobile in DCS!
redmantis:SetAdvancedMode(true, 100) -- switch on advanced mode - detection will slow down or die if HQ and EWR die
redmantis:SetSAMRange(95)
--redmantis:Debug(true)
--redmantis.verbose = true -- watch DCS.log
redmantis:AddShorad(Redshorad,720)
redmantis:Start()

--ADD THE SQUADRON
--- MIG-21 Fighter Squadrons.
local SquadSeveromorskA=SQUADRON:New("SQ MIG-21#1", 2, "773rd") --Ops.Squadron#SQUADRON
SquadSeveromorskA:SetGrouping(2) -- Two aircraft per group X 4 = 8 airframes
SquadSeveromorskA:SetModex(130)  -- Tail number of the sqaud start with 130, 131,...
SquadSeveromorskA:SetTakeoffAir()
SquadSeveromorskA:AddMissionCapability({ AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ALERT5}, 95) -- Squad can do intercept missions. ##Removed CAP capability
SquadSeveromorskA:SetMissionRange(100) -- Squad will be considered for targets within 100 NM of its airwing location.

local SquadSeveromorskB=SQUADRON:New("SQ MIG-23-1", 2, "103rd") --Ops.Squadron#SQUADRON
SquadSeveromorskB:SetGrouping(2) -- Two aircraft per group X 4 = 8 airframes
SquadSeveromorskB:SetModex(130)  -- Tail number of the sqaud start with 130, 131,...
SquadSeveromorskB:SetTakeoffAir()
SquadSeveromorskB:AddMissionCapability({ AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ALERT5}, 100) -- Squad can do intercept missions. ##Removed CAP capability
SquadSeveromorskB:SetMissionRange(100) -- Squad will be considered for targets within 100 NM of its airwing location.


--- MIG-31 CAP Fighter Squadrons.
local SquadMonchegorsk=SQUADRON:New("SQ MIG-23-2", 4, "204th") --Ops.Squadron#SQUADRON
SquadMonchegorsk:SetGrouping(2) -- Two aircraft per group X 4 = 8 airframes
SquadMonchegorsk:SetModex(130)  -- Tail number of the sqaud start with 130, 131,...
SquadMonchegorsk:SetTakeoffAir()
SquadMonchegorsk:AddMissionCapability({ AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 100) -- Squad can do intercept missions.
SquadMonchegorsk:SetMissionRange(100) -- Squad will be considered for targets within 100 NM of its airwing location.

local SquadOlenya=SQUADRON:New("SQ Backfire#1", 12, "22nd") --Ops.Squadron#SQUADRON
SquadOlenya:SetGrouping(2) -- Two aircraft per group X 12 = 24 airframes
SquadOlenya:SetModex(100)  -- Tail number of the sqaud start with 130, 131,...
SquadOlenya:SetTakeoffHot()
SquadOlenya:AddMissionCapability({AUFTRAG.Type.ANTISHIP,AUFTRAG.Type.ALERT5}, 90)  -- Squad can do intercept missions.
SquadOlenya:SetMissionRange(500) -- Squad will be considered for targets within 500NM of its airwing location.

--- AIRWINGs
local SeveromorskWingB=AIRWING:New("Severomorsk-3 Airbase", "103rd (Severomorsk-3)") --Ops.AirWing#AIRWING
local SeveromorskWingA=AIRWING:New("Severomorsk-1 Airbase", "773rd (Severomorsk-1)") --Ops.AirWing#AIRWING
local MonchegorskWing=AIRWING:New("Monchegorsk Airbase", "204th (Monchegorsk)") --Ops.AirWing#AIRWING
local OlenyaWing=AIRWING:New("Olenya Airbase", "22nd (Olenya)") --Ops.AirWing#AIRWING
-- Add squadrons to airwings.
SeveromorskWingB:AddSquadron(SquadSeveromorskB)
SeveromorskWingA:AddSquadron(SquadSeveromorskA)
MonchegorskWing:AddSquadron(SquadMonchegorsk)
OlenyaWing:AddSquadron(SquadOlenya)
-- Add payload to the aircraft
SeveromorskWingA:NewPayload(GROUP:FindByName("SQ MIG-21#1"), -1, {AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.ALERT5}, 95)
SeveromorskWingB:NewPayload(GROUP:FindByName("SQ MIG-23-1"), -1, {AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.ALERT5}, 100)
MonchegorskWing:NewPayload(GROUP:FindByName("SQ MIG-23-2"), -1, {AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP,AUFTRAG.Type.ALERT5}, 100)
OlenyaWing:NewPayload(GROUP:FindByName("SQ Backfire#1"), -1, {AUFTRAG.Type.ANTISHIP}, 90)
-- RedChief OF STAFF
---

-- Zone defining the border of the red territory.
local ZoneredBorder=ZONE_POLYGON:New( "Red Border", GROUP:FindByName( "Red Border" ) )
local AgentsRed=SET_GROUP:New():FilterPrefixes({"Red EWR", "Red AWACS"}):FilterOnce()


-- Define RedChief.  
local RedChief=CHIEF:New(coalition.side.RED, AgentsRed)

-- Add border zone.
RedChief:AddBorderZone(ZoneredBorder)

-- Launch at least one but at most four asset groups for INTERCEPT missions if the threat level of the target is great or equal to six.
RedChief:SetResponseOnTarget(2, 4, 6, nil, AUFTRAG.Type.INTERCEPT)
RedChief:SetResponseOnTarget(2, 4, 6, TARGET.Category.NAVAL, AUFTRAG.Type.ANTISHIP)

-- Add airwing(s) to the RedChief.
RedChief:AddAirwing(SeveromorskWingA)
RedChief:AddAirwing(SeveromorskWingB)
RedChief:AddAirwing(MonchegorskWing)
RedChief:AddAirwing(OlenyaWing)
-- Set strategy to DEFENSIVE: Only targets within the border of the RedChief's territory are attacked.
RedChief:SetStrategy(RedChief.Strategy.OFFENSIVE)
RedChief:SetTacticalOverviewOn()
--Set up CAPZone
local RedCAPZone1=ZONE:FindByName("RedCAPZone1")
RedChief:AddGciCapZone(RedCAPZone1, 25000, 275, 0, 15)
-- Start RedChief after five seconds.
RedChief:__Start(5)
local mCAP=AUFTRAG:NewCAP(RedCAPZone1, 12000, 400, nil, 270, 20, {"Air"})
local NordicHammer=AUFTRAG:NewANTISHIP(GROUP:FindByName("Backstop"), 25000)
NordicHammer:SetMissionSpeed(600)


RedChief:AddMission(mCAP)
RedChief:AddMission(NordicHammer)


