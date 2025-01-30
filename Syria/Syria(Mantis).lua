---
-- Name: AID-A2A-100 - Demonstration
-- Author: FlightControl
-- Date Created: 30 May 2017
--######MANTIS LINK#####

myredmantis = MANTIS:New("myredmantis","Red SAM","DF CCCP EWR","Red HQ","red",false,"DF CCCP AWACS")
--myredmantis:SetAutoRelocate(true, true) -- make HQ and EWR relocatable, if they are actually mobile in DCS!
myredmantis:Debug(false)
--myredmantis.verbose = false
myredmantis:Start()

--mybluemantis = MANTIS:New("bluemantis","Blue SAM","DF NATO EWR",nil,"blue",false,"DF NATO AWACS")
--mybluemantis:Start()


-- Define a SET_GROUP object that builds a collection of groups that define the EWR network.
-- Here we build the network with all the groups that have a name starting with DF CCCP AWACS and DF CCCP EWR.
--##Remove down to dispatcher New##
--DetectionSetGroup = SET_GROUP:New()
--DetectionSetGroup:FilterPrefixes( { "DF CCCP AWACS", "DF CCCP EWR" } )
--DetectionSetGroup:FilterStart()

--Detection = DETECTION_AREAS:New( DetectionSetGroup, 30000 )

-- Setup the A2A dispatcher, and initialize it.
A2ADispatcher = AI_A2A_DISPATCHER:New( myredmantis.Detection )

-- Enable the tactical display panel.
--A2ADispatcher:SetTacticalDisplay( true )

-- Initialize the dispatcher, setting up a border zone. This is a polygon, 
-- which takes the waypoints of a late activated group with the name CCCP Border as the boundaries of the border area.
-- Any enemy crossing this border will be engaged.
CCCPBorderZone = ZONE_POLYGON:New( "CCCP Border", GROUP:FindByName( "CCCP Border" ) )
A2ADispatcher:SetBorderZone( CCCPBorderZone )

-- Initialize the dispatcher, setting up a radius of 100km where any airborne friendly 
-- without an assignment within 100km radius from a detected target, will engage that target.
A2ADispatcher:SetEngageRadius( 100000 )
--Added this below
A2ADispatcher:SetGciRadius( 140000 )

-- Setup the squadrons.
A2ADispatcher:SetSquadron( "Kuznetzov", "BlackFlt TF1", { "SQ CCCP SU-33" }, 4 )
A2ADispatcher:SetSquadron( "Aleppo", AIRBASE.Syria.Aleppo, { "SQ CCCP  SU-30" }, 4 )
A2ADispatcher:SetSquadron( "Tiyas", AIRBASE.Syria.Tiyas, { "SQ CCCP  MIG-23","SQ CCCP  MIG31" }, 6 )
A2ADispatcher:SetSquadron( "Sayqal", AIRBASE.Syria.Sayqal, { "SQ CCCP  MIG-23" }, 6 )
--GCI Squadrons
A2ADispatcher:SetSquadron( "Hatay", AIRBASE.Syria.Hatay, { "SQ CCCP MIG-29" }, 4 )
A2ADispatcher:SetSquadron( "Hama", AIRBASE.Syria.Hama, { "SQ CCCP MIG-21 #2" }, 6 )
A2ADispatcher:SetSquadron( "Bassel", AIRBASE.Syria.Bassel_Al_Assad, { "SQ CCCP MIG-21 #1" }, 6 )  

-- Setup the overhead
A2ADispatcher:SetSquadronOverhead( "Kuznetzov", 1 )
A2ADispatcher:SetSquadronOverhead( "Aleppo", 1 )
A2ADispatcher:SetSquadronOverhead( "Tiyas", 1 )
A2ADispatcher:SetSquadronOverhead( "Sayqal", 1 )
A2ADispatcher:SetSquadronOverhead( "Hatay", 1 )
A2ADispatcher:SetSquadronOverhead( "Hama", 1.5 )
A2ADispatcher:SetSquadronOverhead( "Bassel", 1.5 )

-- Setup the Grouping
A2ADispatcher:SetSquadronGrouping( "Kuznetzov", 2 )
A2ADispatcher:SetSquadronGrouping( "Aleppo", 2 )
A2ADispatcher:SetSquadronGrouping( "Tiyas", 2 )
A2ADispatcher:SetSquadronGrouping( "Sayqal", 2 )
A2ADispatcher:SetSquadronGrouping( "Hatay", 2 )
A2ADispatcher:SetSquadronGrouping( "Hama", 2 )
A2ADispatcher:SetSquadronGrouping( "Bassel", 2 )
-- Setup the Takeoff methods
A2ADispatcher:SetSquadronTakeoffInAir( "Kuznetzov" )
A2ADispatcher:SetSquadronTakeoffFromParkingHot( "Sayqal" )
A2ADispatcher:SetSquadronTakeoffFromRunway( "Tiyas" )
A2ADispatcher:SetSquadronTakeoffFromRunway( "Aleppo" )
A2ADispatcher:SetSquadronTakeoffFromRunway( "Hatay" )
A2ADispatcher:SetSquadronTakeoffFromRunway( "Hama" )
A2ADispatcher:SetSquadronTakeoffFromRunway( "Bassel" )

-- Setup the Landing methods
A2ADispatcher:SetSquadronLandingNearAirbase( "Kuznetzov" )
A2ADispatcher:SetSquadronLandingNearAirbase( "Sayqal" )
A2ADispatcher:SetSquadronLandingAtEngineShutdown( "Tiyas" )
A2ADispatcher:SetSquadronLandingNearAirbase( "Aleppo" )
A2ADispatcher:SetSquadronLandingNearAirbase( "Hatay" )
A2ADispatcher:SetSquadronLandingNearAirbase( "Hama" )
A2ADispatcher:SetSquadronLandingNearAirbase( "Bassel" )



-- CAP Squadron execution.
--CAPZoneEast = ZONE_POLYGON:New( "CAP Zone East", GROUP:FindByName( "CAP Zone East" ) )
--A2ADispatcher:SetSquadronCap( "PLAAN", CAPZoneEast, 4000, 10000, 500, 600, 800, 900 )
--A2ADispatcher:SetSquadronCapInterval( "PLAAN", 1, 30, 900, 1 )

CAPZoneNorth = ZONE:New( "CAP Zone North", GROUP:FindByName( "CAP Zone North" ) )
A2ADispatcher:SetSquadronCap( "Aleppo", CAPZoneNorth, 4000, 8000, 600, 800, 800, 1200, "BARO" )
A2ADispatcher:SetSquadronCapInterval( "Aleppo", 1, 30, 300, 1 )

CAPZoneCenter = ZONE:New( "CAP Zone Center")
A2ADispatcher:SetSquadronCap( "Tiyas", CAPZoneCenter, 4000, 8000, 600, 800, 800, 1200, "RADIO" )
A2ADispatcher:SetSquadronCapInterval( "Tiyas", 1, 30, 300, 1 )

CAPZoneSouth = ZONE:New( "CAP Zone South")
A2ADispatcher:SetSquadronCap( "Sayqal", CAPZoneSouth, 4000, 8000, 600, 800, 800, 1200, "RADIO" )
A2ADispatcher:SetSquadronCapInterval( "Sayqal", 1, 30, 300, 1 )


CAPZoneNavy = ZONE:New( "CAP Zone Med")
A2ADispatcher:SetSquadronCap( "Kuznetzov", CAPZoneNavy, 4000, 8000, 600, 800, 800, 1200, "RADIO" )
A2ADispatcher:SetSquadronCapInterval( "Kuznetzov", 1, 30, 300, 1 )

-- GCI Squadron execution.
A2ADispatcher:SetSquadronGci( "Hatay", 900, 1200 )
A2ADispatcher:SetSquadronGci( "Hama", 900, 2100 )
A2ADispatcher:SetSquadronGci( "Bassel", 900, 1200 )

-- Set the squadrons visible before startup.
--A2ADispatcher:SetSquadronVisible( "Aleppo" )
--A2ADispatcher:SetSquadronVisible( "Palmyra" )
--A2ADispatcher:SetSquadronVisible( "Sayqal" )
--A2ADispatcher:SetSquadronVisible( "Maykop" )
--A2ADispatcher:SetSquadronVisible( "Novo" )


--CleanUp = CLEANUP_AIRBASE:New( { AIRBASE.Caucasus.Novorossiysk } )


