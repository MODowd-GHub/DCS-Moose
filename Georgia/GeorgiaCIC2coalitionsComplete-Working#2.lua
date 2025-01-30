local SamSet = SET_GROUP:New():FilterPrefixes("Red SAM"):FilterCoalitions("red"):FilterStart()
Redshorad = SHORAD:New("RedShorad", "Red SHORAD", SamSet, 22000, 600, "red")
--Redshorad:SwitchDebug(true)
--Start the RedMANTIS
redmantis = MANTIS:New("redmantis","Red SAM","DF CCCP EWR","Red HQ","red",true,"DF CCCP AWACS")
redmantis:SetAutoRelocate(true, true) -- make HQ and EWR relocatable, if they are actually mobile in DCS!
redmantis:SetAdvancedMode(true, 100) -- switch on advanced mode - detection will slow down or die if HQ and EWR die
redmantis:SetSAMRange(95)
--redmantis:Debug(true)
--redmantis.verbose = true -- watch DCS.log
redmantis:Start()

bluemantis = MANTIS:New("bluemantis","Blue SAM","DF NATO EWR","Blue HQ","blue",true,"DF NATO AWACS")
bluemantis:SetAutoRelocate(true, true) -- make HQ and EWR relocatable, if they are actually mobile in DCS!
bluemantis:SetAdvancedMode(true, 100) -- switch on advanced mode - detection will slow down or die if HQ and EWR die
bluemantis:SetSAMRange(95)
--bluemantis:Debug(true)
--bluemantis.verbose = true -- watch DCS.log
bluemantis:Start()

--ADD THE SQUADRON
--- MIG-29 Fighter Squadron.
local SquadGudauta=SQUADRON:New("SQ CCCP MIG-29", 4, "773rd") --Ops.Squadron#SQUADRON
SquadGudauta:SetGrouping(2) -- Two aircraft per group X 6 = 12 airframes
SquadGudauta:SetModex(130)  -- Tail number of the sqaud start with 130, 131,...
SquadGudauta:SetTakeoffAir()
SquadGudauta:AddMissionCapability({ AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 100) -- Squad can do intercept missions.
SquadGudauta:SetMissionRange(100) -- Squad will be considered for targets within 200 NM of its airwing location.

--Flanker Squadron.
local SquadSochi=SQUADRON:New("SQ CCCP SU-27", 4, "243rd") --Ops.Squadron#SQUADRON
SquadSochi:SetGrouping(2) -- Two aircraft per group X 6 = 12 airframes
SquadSochi:SetModex(004)  -- Tail number of the sqaud start with 130, 131,...
SquadSochi:SetTakeoffAir()
SquadSochi:AddMissionCapability({ AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 100)  -- Squad can do intercept missions.
SquadSochi:SetMissionRange(200) -- Squad will be considered for targets within 200 NM of its airwing location.

---Backfire Squadron
local BackfireSquad=SQUADRON:New("SQ CCCP TU-22M", 6, "23rd (Novorossiysk)") --Ops.Squadron#SQUADRON
BackfireSquad:SetGrouping(2) -- Two aircraft per group X 6 = 12 airframes
BackfireSquad:SetModex(130)  -- Tail number of the sqaud start with 130, 131,...
BackfireSquad:SetTakeoffAir()
BackfireSquad:AddMissionCapability({AUFTRAG.Type.ANTISHIP}, 100) -- Squad can do intercept missions.
--BackfireSquad:AddMissionCapability({AUFTRAG.Type.ALERT5})        -- Squad can be spawned at the airfield in uncontrolled state.
BackfireSquad:SetMissionRange(200) -- Squad will be considered for targets within 200 NM of its airwing location.

--- AIRWING Gudauta
local GudautaWing=AIRWING:New("Warehouse Gudauta", "773rd (Gudauta)") --Ops.AirWing#AIRWING
--- AIRWING Sochi
local NovorossiyskBackfire=AIRWING:New("Novorossiysk Airbase", "23rd (Novorossiysk)") --Ops.AirWing#AIRWING
local SochiFlanker=AIRWING:New("Sochi Airbase", "243rd (Sochi)") --Ops.AirWing#AIRWING
-- Add squadrons to airwing.
GudautaWing:AddSquadron(SquadGudauta)
NovorossiyskBackfire:AddSquadron(BackfireSquad)
SochiFlanker:AddSquadron(SquadSochi)
-- Payload: This payload is used for GCICAP, INTERCEPT and CAP missions. 
--          Only two are available ==> Only two missions can be started simultaniously.
--          Payloads are returned when the assets returns to the airwing.
GudautaWing:NewPayload(GROUP:FindByName("SQ CCCP MIG-29"), -1, {AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP,AUFTRAG.Type.ALERT5}, 95)
NovorossiyskBackfire:NewPayload(GROUP:FindByName("SQ CCCP TU-22M"), -1, {AUFTRAG.Type.ANTISHIP }, 100)
SochiFlanker:NewPayload(GROUP:FindByName("SQ CCCP SU27-1"), -1, {AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 90)
---
-- RedChief OF STAFF
---

-- Zone defining the border of the red territory.
local ZoneredBorder=ZONE_POLYGON:New( "CCCP Border", GROUP:FindByName( "CCCP Border" ) )
local CAPZone1= ZONE:New("CAP Zone 1")   
local CAPZone2= ZONE:New("CAP Zone 2")   
-- red AgentsRed.
local AgentsRed=SET_GROUP:New():FilterPrefixes({"DF CCCP EWR", "DF CCCP AWACS"}):FilterOnce()

-- Define RedChief.  
local RedChief=CHIEF:New(coalition.side.RED, AgentsRed)

-- Add border zone.
RedChief:AddBorderZone(ZoneredBorder)
--RedChief:SetTacticalOverviewOn()--Test Overview

-- Launch at least one but at most four asset groups for INTERCEPT missions if the threat level of the target is great or equal to six.
RedChief:SetResponseOnTarget(2, 4, 6, nil, AUFTRAG.Type.INTERCEPT)
RedChief:SetResponseOnTarget(2, 6, 6, TARGET.Category.NAVAL, AUFTRAG.Type.ANTISHIP)

-- Add airwing(s) to the RedChief.
RedChief:AddAirwing(GudautaWing)
RedChief:AddAirwing(NovorossiyskBackfire)
RedChief:AddAirwing(SochiFlanker)
-- Set strategy to DEFENSIVE: Only targets within the border of the RedChief's territory are attacked.
RedChief:SetStrategy(RedChief.Strategy.OFFENSIVE) --Changed this from defensive to try spawn more than one MIG flight
RedChief:AddGciCapZone(CAPZone1, 25000, 275, 0, 15)
-- Start RedChief after one second.
RedChief:__Start(1)

--BlueCheif

--ADD THE SQUADRON
--- MIG-29 Fighter Squadron.

--Flanker Squadron.
local SquadKutaisi=SQUADRON:New("SQ NATO SU-27", 6, "36th") --Ops.Squadron#SQUADRON
SquadKutaisi:SetGrouping(2) -- Two aircraft per group X 6 = 12 airframes
SquadKutaisi:SetModex(004)  -- Tail number of the sqaud start with 130, 131,...
SquadKutaisi:SetTakeoffHot()
SquadKutaisi:AddMissionCapability({ AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 100)  -- Squad can do intercept missions.
SquadKutaisi:SetMissionRange(200) -- Squad will be considered for targets within 200 NM of its airwing location.

---Raider Squadron
local SquadKobuleti=SQUADRON:New("SQ NATO B-21", 2, "2nd") --Ops.Squadron#SQUADRON
SquadKobuleti:SetGrouping(2) -- Two aircraft per group X 6 = 12 airframes
SquadKobuleti:SetModex(130)  -- Tail number of the sqaud start with 130, 131,...
SquadKobuleti:SetTakeoffHot()
SquadKobuleti:AddMissionCapability({AUFTRAG.Type.ANTISHIP}, 100) -- Squad can do asw missions.
--SquadKobuleti:AddMissionCapability({AUFTRAG.Type.ALERT5})        -- Squad can be spawned at the airfield in uncontrolled state.
SquadKobuleti:SetMissionRange(300) -- Squad will be considered for targets within 300 NM of its airwing location.

-- AIRWING Kutaisi
local KutaisiWing=AIRWING:New("Warehouse Kutasi", "36th") --Ops.AirWing#AIRWING
--- AIRWING Sochi
local KobuletiWing=AIRWING:New("Warehouse Kobuleti", "2nd") --Ops.AirWing#AIRWING

KutaisiWing:AddSquadron(SquadKutaisi)
KobuletiWing:AddSquadron(SquadKobuleti)

KutaisiWing:NewPayload(GROUP:FindByName("SQ NATO SU-27"), -1, {AUFTRAG.Type.INTERCEPT,AUFTRAG.Type.GCICAP,AUFTRAG.Type.CAP,AUFTRAG.Type.ALERT5}, 100)
KobuletiWing:NewPayload(GROUP:FindByName("SQ NATO B-21"), -1, {AUFTRAG.Type.ANTISHIP }, 100)

local ZoneBlueBorder=ZONE_POLYGON:New( "NATO Border", GROUP:FindByName( "NATO Border" ) )
local CAPZone3= ZONE:New("BlueCap1")   

-- blue agents.
local AgentsBlue=SET_GROUP:New():FilterPrefixes({"DF NATO EWR", "DF NATO AWACS"}):FilterOnce()

-- Define BlueCheif.  
local BlueCheif=CHIEF:New(coalition.side.BLUE, AgentsBlue)

BlueCheif:AddBorderZone(ZoneBlueBorder)

-- Enable tactical overview.
--BlueCheif:SetTacticalOverviewOn()

-- Launch at least one but at most four asset groups for INTERCEPT missions if the threat level of the target is great or equal to six.
BlueCheif:SetResponseOnTarget(2, 4, 6, nil, AUFTRAG.Type.INTERCEPT)
BlueCheif:SetResponseOnTarget(2, 4, 6, TARGET.Category.NAVAL, AUFTRAG.Type.ANTISHIP)

-- Add airwing(s) to the BlueCheif.
BlueCheif:AddAirwing(KutaisiWing)
BlueCheif:AddAirwing(KobuletiWing)

-- Set strategy to DEFENSIVE: Only targets within the border of the BlueCheif's territory are attacked.
BlueCheif:SetStrategy(BlueCheif.Strategy.DEFENSIVE)
--BlueCheif:AddGciCapZone(CAPZone3, 25000, 275, 0, 15)
local mCAP=AUFTRAG:NewCAP(CAPZone3, 12000, 350, nil, 090, 20, {"Air"})


-- Start BlueCheif after five seconds.
BlueCheif:__Start(5)

--Set out 2 Groups of Interceptors.  Note that whatever payload they spawn with, they're stuck with.
local KutaisiiInterceptAlert5=AUFTRAG:NewALERT5(AUFTRAG.Type.INTERCEPT)
KutaisiiInterceptAlert5:SetRequiredAssets(2)
KutaisiiInterceptAlert5:SetTime(30)
-- Add the mission to the airwing.
-- NOTE: We could also add the mission to the CHIEF. But then we would not know which airwing he choses if he has more than one. Here it does not matter.



local KutaisiGCICAPAlert5s=AUFTRAG:NewALERT5(AUFTRAG.Type.GCICAP)
KutaisiGCICAPAlert5s:SetRequiredAssets(2)
KutaisiGCICAPAlert5s:SetTime(300)

KutaisiWing:AddMission(KutaisiiInterceptAlert5)
KutaisiWing:AddMission(KutaisiGCICAPAlert5s)
      
-- Add mission to airwing.
BlueCheif:AddMission(KutaisiGCICAPAlert5s)
BlueCheif:AddMission(KutaisiiInterceptAlert5)