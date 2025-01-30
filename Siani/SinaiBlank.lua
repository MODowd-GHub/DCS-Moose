--Setup the MANTIS

local SamSet = SET_GROUP:New():FilterPrefixes("Red SAM"):FilterCoalitions("red"):FilterStart()
Redshorad = SHORAD:New("RedShorad", "Red SHORAD", SamSet, 22000, 600, "red")
--Redshorad:SwitchDebug(true)
--Start the RedMANTIS
redmantis = MANTIS:New("redmantis","Red SAM","Red EWR","Red HQ","red",true,"Red Awacs")
redmantis:SetAutoRelocate(true, true) -- make HQ and EWR relocatable, if they are actually mobile in DCS!
redmantis:SetAdvancedMode(true, 100) -- switch on advanced mode - detection will slow down or die if HQ and EWR die
redmantis:SetSAMRange(95)
redmantis:Debug(true)
--redmantis.verbose = true -- watch DCS.log
redmantis:Start()

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
CCCPBorderZone = ZONE_POLYGON:New( "Red Border", GROUP:FindByName( "Red Border" ) )
A2ADispatcherRed:SetBorderZone( CCCPBorderZone )
A2ADispatcherNATO:SetBorderZone( CCCPBorderZone )

-- Initialize the dispatcher, setting up a radius of 100km where any airborne friendly 
-- without an assignment within 100km radius from a detected target, will engage that target.
A2ADispatcherRed:SetEngageRadius( 120000 )
A2ADispatcherNATO:SetEngageRadius( 120000 )

--Set up the squadrons

A2ADispatcherRed:SetSquadron( "Kibrit", AIRBASE.Sinai.Kibrit_Air_Base, { "SQ RED MIG-29" }, 8)
A2ADispatcherRed:SetSquadron( "Inshas", AIRBASE.Sinai.Inshas_Airbase, { "SQ RED SU-57" }, 2 )
A2ADispatcherRed:SetSquadron( "Baluza", AIRBASE.Sinai.Baluza, { "SQ RED M2000","SQ RED MIG-21" }, 8)
A2ADispatcherNATO:SetSquadron( "Kedem", AIRBASE.Sinai.Kedem, { "SQ NATO F-15" }, 4)

-- Setup the overhead

A2ADispatcherRed:SetSquadronOverhead( "Kibrit", 1 )
A2ADispatcherRed:SetSquadronOverhead( "Inshas", 0.5 )
A2ADispatcherRed:SetSquadronOverhead( "Baluza", 1 )
A2ADispatcherNATO:SetSquadronOverhead( "Kedem", 1 )
-- Setup the Grouping

A2ADispatcherRed:SetSquadronGrouping( "Inshas", 2 )
A2ADispatcherRed:SetSquadronGrouping( "Kibrit", 2 )
A2ADispatcherRed:SetSquadronGrouping( "Baluza", 2 )
A2ADispatcherNATO:SetSquadronGrouping( "Kedem", 2 )
-- Setup the Takeoff methods

A2ADispatcherRed:SetSquadronTakeoffFromParkingHot( "Inshas" )
A2ADispatcherRed:SetSquadronTakeoffFromParkingHot( "Kibrit" )
A2ADispatcherRed:SetSquadronTakeoffFromRunway( "Baluza" )
A2ADispatcherNATO:SetSquadronTakeoffFromRunway( "Kedem" )

-- Setup the Landing methods

A2ADispatcherRed:SetSquadronLandingNearAirbase( "Inshas" )
A2ADispatcherRed:SetSquadronLandingAtEngineShutdown( "Kibrit" )
A2ADispatcherRed:SetSquadronLandingAtEngineShutdown( "Baluza" )
A2ADispatcherNATO:SetSquadronLandingNearAirbase( "Kedem" )
-- CAP Squadron execution.
CAPZone1 = ZONE:New( "CAP Zone 1")
A2ADispatcherRed:SetSquadronCap( "Kibrit", CAPZone1, 4000, 8000, 600, 800, 800, 1200, "RADIO" )
A2ADispatcherRed:SetSquadronCapInterval( "Kibrit", 1, 30, 300, 1 )

CAPZone2 = ZONE:New( "CAP Zone 2" )
A2ADispatcherRed:SetSquadronCap( "Inshas", CAPZone2, 4000, 8000, 600, 800, 800, 1200, "BARO" )
A2ADispatcherRed:SetSquadronCapInterval( "Inshas", 1, 30, 300, 1 )



CAPZone3 = ZONE:New( "BlueCap1")
A2ADispatcherNATO:SetSquadronCap( "Kedem", CAPZone3, 4000, 8000, 600, 800, 800, 1200, "BARO" )
A2ADispatcherNATO:SetSquadronCapInterval( "Kedem", 1, 30, 300, 1 )


--Set up GCI
 A2ADispatcherRed:SetSquadronGci( "Baluza", 900, 1200 )