--Set up the artillery fire missions
--local RedArty=ARTY:New(GROUP:FindByName("RedArty"))
--RedArty:SetIlluminationShells(100,2.0)
--RedArty:SetIlluminationMinMaxAlt(500,750)
--local coord = ZONE:New("Artillery Illumination"):GetCoordinate()
--RedArty:AssignTargetCoord(coord,10,500,10,1,"08:31:0", ARTY.WeaponType.IlluminationShells,"Lightening")

--Set up the conditionals to daisy chain the missions using  event handling

--RedArty:HandleEvent( EVENTS.Shot )
--function RedArty:OnEventShot ( EventData )
--local data = EventData -- Core.Event#EVENTDATA
--local shooter = data.IniDCSGroupName
--if shooter == "RedArty" then
--local Rain=ARTY:New(GROUP:FindByName("Rain"))
--local coord = ZONE:New("Artillery Illumination"):GetCoordinate()
--Rain:AssignTargetCoord(coord, nil, 1000, 40, 1, nil, nil, "Thunder")
--Rain:Start()
--RedArty:UnHandleEvent( EVENTS.Shot )
--end
--end
--RedArty:Start()


--RAT
local evac=RAT:New("Evac")
evac:SetDeparture(AIRBASE.Caucasus.Kobuleti)
evac:Spawn()

local SamSet = SET_GROUP:New():FilterPrefixes("Red SAM"):FilterCoalitions("red"):FilterStart()
Redshorad = SHORAD:New("RedShorad", "Red SHORAD", SamSet, 22000, 600, "red")
--Redshorad:SwitchDebug(true)
--Start the RedMANTIS
redmantis = MANTIS:New("redmantis","Red SAM","Red EWR","Red HQ","red",true,"Red Awacs")
redmantis:SetAutoRelocate(true, true) -- make HQ and EWR relocatable, if they are actually mobile in DCS!
redmantis:SetAdvancedMode(true, 100) -- switch on advanced mode - detection will slow down or die if HQ and EWR die
redmantis:SetSAMRange(95)
--redmantis:Debug(true)
--redmantis.verbose = true -- watch DCS.log
redmantis:Start()
--Jamming
local function isGroupInZone()
    local group = GROUP:FindByName("Queer")
    --local zone = ZONE:FindByName ("Umbrella")

   if group:IsAlive()==true then--and group:IsCompletelyInZone( zone )	then
      redmantis:SetNewSAMRangeWhileRunning(25)
		else
		redmantis:SetNewSAMRangeWhileRunning(95)
    end

    end

Jamming=SCHEDULER:New(nil, isGroupInZone, {}, 1, 5) -- Adjust the interval and delay as per your needs

Jamming:Start()

-- Define a SET_GROUP object that builds a collection of groups that define the EWR network.
-- Here we build the network with all the groups that have a name starting with DF CCCP AWACS and DF CCCP EWR.
--##Remove down to dispatcher New##
DetectionSetGroup = SET_GROUP:New()
DetectionSetGroup:FilterPrefixes( { "DF NATO AWACS", "DF NATO EWR" } )
DetectionSetGroup:FilterStart()

NatoDetection = DETECTION_AREAS:New( DetectionSetGroup, 30000 )

-- Setup the A2A dispatcher, and initialize it.
A2ADispatcherRed = AI_A2A_DISPATCHER:New( redmantis.Detection )
A2ADispatcherNATO = AI_A2A_DISPATCHER:New( NatoDetection )
-- Enable the tactical display panel.
--A2ADispatcherRed:SetTacticalDisplay( true )

-- Initialize the dispatcher, setting up a border zone. This is a polygon, 
-- which takes the waypoints of a late activated group with the name CCCP Border as the boundaries of the border area.
-- Any enemy crossing this border will be engaged.
CCCPBorderZone = ZONE_POLYGON:New( "CCCP Border", GROUP:FindByName( "CCCP Border" ) )
A2ADispatcherRed:SetBorderZone( CCCPBorderZone )
A2ADispatcherNATO:SetBorderZone( CCCPBorderZone )

-- Initialize the dispatcher, setting up a radius of 100km where any airborne friendly 
-- without an assignment within 100km radius from a detected target, will engage that target.
A2ADispatcherRed:SetEngageRadius( 120000 )
A2ADispatcherNATO:SetEngageRadius( 120000 )


A2ADispatcherRed:SetSquadron( "Gudauta", AIRBASE.Caucasus.Gudauta, { "SQ CCCP SU-30", "SQ CCCP SU-27" }, 8 )
A2ADispatcherRed:SetSquadron( "Sochi", AIRBASE.Caucasus.Sochi_Adler, { "SQ CCCP SU-57" }, 2)
A2ADispatcherRed:SetSquadron( "Sukhumi", AIRBASE.Caucasus.Sukhumi_Babushara, { "SQ CCCP MIG-29" }, 6)
A2ADispatcherNATO:SetSquadron( "Kutaisi", AIRBASE.Caucasus.Kutaisi, { "SQ NATO MIG-29" }, 8)

-- Setup the overhead

A2ADispatcherRed:SetSquadronOverhead( "Gudauta", 1 )
A2ADispatcherRed:SetSquadronOverhead( "Sochi", 0.5 )
A2ADispatcherRed:SetSquadronOverhead( "Sukhumi", 1 )
A2ADispatcherNATO:SetSquadronOverhead( "Kutaisi", 1 )
-- Setup the Grouping

A2ADispatcherRed:SetSquadronGrouping( "Sochi", 2 )
A2ADispatcherRed:SetSquadronGrouping( "Gudauta", 2 )
A2ADispatcherRed:SetSquadronGrouping( "Sukhumi", 2 )
A2ADispatcherNATO:SetSquadronGrouping( "Kutaisi", 2 )
-- Setup the Takeoff methods

A2ADispatcherRed:SetSquadronTakeoffFromParkingHot( "Sochi" )
A2ADispatcherRed:SetSquadronTakeoffFromParkingHot( "Gudauta" )
A2ADispatcherRed:SetSquadronTakeoffFromRunway( "Sukhumi" )
A2ADispatcherNATO:SetSquadronTakeoffFromRunway( "Kutaisi" )

-- Setup the Landing methods

A2ADispatcherRed:SetSquadronLandingNearAirbase( "Sochi" )
A2ADispatcherRed:SetSquadronLandingAtEngineShutdown( "Gudauta" )
A2ADispatcherRed:SetSquadronLandingAtEngineShutdown( "Sukhumi" )
A2ADispatcherNATO:SetSquadronLandingNearAirbase( "Kutaisi" )
-- CAP Squadron execution.
CAPZone1 = ZONE:New( "CAP Zone 1")
A2ADispatcherRed:SetSquadronCap( "Gudauta", CAPZone1, 4000, 8000, 600, 800, 800, 1200, "RADIO" )
A2ADispatcherRed:SetSquadronCapInterval( "Gudauta", 1, 30, 300, 1 )

CAPZone2 = ZONE:New( "CAP Zone 2" )
A2ADispatcherRed:SetSquadronCap( "Sochi", CAPZone2, 4000, 8000, 600, 800, 800, 1200, "BARO" )
A2ADispatcherRed:SetSquadronCapInterval( "Sochi", 1, 30, 300, 1 )



CAPZone3 = ZONE:New( "BlueCap1")
A2ADispatcherNATO:SetSquadronCap( "Kutaisi", CAPZone3, 4000, 8000, 600, 800, 800, 1200, "BARO" )
A2ADispatcherNATO:SetSquadronCapInterval( "Kutaisi", 1, 30, 300, 1 )


--Set up GCI
 A2ADispatcherRed:SetSquadronGci( "Sukhumi", 900, 1200 )
 
-- Set up Blue CAS/BAI/SEAD

Recce_Blue = SET_GROUP:New():FilterPrefixes( "RECCE" ):FilterStart()

Detection_Blue = DETECTION_AREAS:New( Recce_Blue, 5000 )

A2G_Blue = AI_A2G_DISPATCHER:New(Detection_Blue)

--A2G_Blue:SetTacticalDisplay( true ) -- set on using true as a parameter

FEBA = GROUP:FindByName( "Team Alpha" ):GetCoordinate()

A2G_Blue:AddDefenseCoordinate( "Front Line", FEBA )
A2G_Blue:SetDefenseRadius( 50000 ) -- in meters
A2G_Blue:SetDefenseReactivityHigh() -- we engage almost immediately

--REAR = GROUP:FindByName( "Blue SAM-3" ):GetCoordinate()

--A2G_Blue:AddDefenseCoordinate( "REAR", REAR )
--A2G_Blue:SetDefenseRadius( 100000 ) -- in meters
--A2G_Blue:SetDefenseReactivityHigh() -- we engage almost immediately

A2G_Blue:SetSquadron( "BAI", AIRBASE.Caucasus.Senaki_Kolkhi, { "SQ NATO BAI" }, 6 )
A2G_Blue:SetSquadronBai( "BAI", 300, 400, 300, 5000 )
A2G_Blue:SetSquadronTakeoffInAir( "BAI", 1000) -- altitude in meters when spawning in the air.
A2G_Blue:SetSquadronLandingNearAirbase( "BAI" )
A2G_Blue:SetSquadronOverhead( "BAI", 0.25 )
A2G_Blue:SetSquadronTakeoffInterval( "BAI", 60 )

A2G_Blue:SetSquadron( "CAS", AIRBASE.Caucasus.Senaki_Kolkhi, { "SQ NATO CAS" }, 4 )
A2G_Blue:SetSquadronCas( "CAS", 300, 400, 300, 5000 )
A2G_Blue:SetSquadronTakeoffInAir( "CAS", 1000) -- altitude in meters when spawning in the air.
A2G_Blue:SetSquadronLandingNearAirbase( "CAS" )
A2G_Blue:SetSquadronOverhead( "CAS", 0.25 )
A2G_Blue:SetSquadronTakeoffInterval( "CAS", 60 )

A2G_Blue:SetSquadron( "SEAD", AIRBASE.Caucasus.Senaki_Kolkhi, { "SQ NATO SEAD" }, 4 )
A2G_Blue:SetSquadronSead( "SEAD", 300, 400, 300, 5000 )
A2G_Blue:SetSquadronTakeoffInAir( "SEAD") -- altitude in meters when spawning in the air.
A2G_Blue:SetSquadronLandingNearAirbase( "SEAD" )
A2G_Blue:SetSquadronOverhead( "SEAD", 0.25 )
A2G_Blue:SetSquadronTakeoffInterval( "SEAD", 60 )

--Set up the Jammer for the MANTIS
--MusicOn = ZONE:New("Umbrella")

