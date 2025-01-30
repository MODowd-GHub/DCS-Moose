local SamSet = SET_GROUP:New():FilterPrefixes("Red SAM"):FilterCoalitions("red"):FilterStart()
RedShorad = SHORAD:New("RedShorad", "Red SHORAD", SamSet, 25000, 600, "red")

redmantis = MANTIS:New("redmantis","Red SAM","Red EWR","Red HQ","red",true,"Red Awacs")
redmantis:SetAutoRelocate(true, true) -- make HQ and EWR relocatable, if they are actually mobile in DCS!
redmantis:SetAdvancedMode(true, 100) -- switch on advanced mode - detection will slow down or die if HQ and EWR die
redmantis:SetSAMRange(95)
redmantis:AddShorad(RedShorad,720)
--redmantis:Debug(true)
--redmantis.verbose = true -- watch DCS.log
redmantis:Start()

blueiads = MANTIS:New("blueiads","Blue SAM","Blue EWR","Blue HQ","blue",true,"Blue AWACS")
blueiads:SetAutoRelocate(true, true) -- make HQ and EWR relocatable, if they are actually mobile in DCS!
blueiads:SetAdvancedMode(true, 100)
blueiads:SetSAMRange(90)
--blueiads:Debug(true)
--blueiads.verbose = true -- watch DCS.log
blueiads:Start()

-- Setup the A2A dispatcher, and initialize it.
DetectionSetGroup = SET_GROUP:New()
DetectionSetGroup:FilterPrefixes( {"Red EWR", "Red Awacs" } )
DetectionSetGroup:FilterStart()

Detection = DETECTION_AREAS:New( DetectionSetGroup, 30000 )

-- Setup the A2A dispatcher, and initialize it.
A2ADispatcherRed = AI_A2A_DISPATCHER:New( Detection )
--A2ADispatcherRed:SetTacticalDisplay( true )

 -- Setup the A2A dispatcher, and initialize it.
DetectionSetGroup = SET_GROUP:New()
DetectionSetGroup:FilterPrefixes( {"Blue EWR", "Blue AWACS" } )
DetectionSetGroup:FilterStart()

DetectionBlue = DETECTION_AREAS:New( DetectionSetGroup, 30000 )

-- Setup the A2A dispatcher, and initialize it.
A2ADispatcherBlue = AI_A2A_DISPATCHER:New( DetectionBlue )
--A2ADispatcherBlue:SetTacticalDisplay( true )

-- Initialize the dispatcher, setting up a border zone. This is a polygon, 
-- which takes the waypoints of a late activated group with the name CCCP Border as the boundaries of the border area.
-- Any enemy crossing this border will be engaged.
CCCPBorderZone = ZONE_POLYGON:New( "Red Border", GROUP:FindByName( "Red Border" ) )
A2ADispatcherRed:SetBorderZone( CCCPBorderZone )
A2ADispatcherRed:SetEngageRadius( 150000 )

BlueBorder = ZONE_POLYGON:New( "UN Border", GROUP:FindByName( "UN Border" ) )
A2ADispatcherBlue:SetBorderZone( BlueBorder )
A2ADispatcherBlue:SetEngageRadius( 150000 )
--A2ADispatcherBlue:SetGciRadius( 100000 )

--Set up the Red Squadrons

A2ADispatcherRed:SetSquadron( "BandarGCI", AIRBASE.PersianGulf.Bandar_Abbas_Intl, { "SQ IRI F1", "SQ IRI F4" }, 2 )
A2ADispatcherRed:SetSquadronGci( "BandarGCI", 800, 1200 )
A2ADispatcherRed:SetSquadronOverhead("BandarGCI", 1 )
A2ADispatcherRed:SetSquadronGrouping( "BandarGCI", 2 )
A2ADispatcherRed:SetSquadronTakeoffFromRunway( "BandarGCI" )

A2ADispatcherRed:SetSquadron( "QeshmGCI", AIRBASE.PersianGulf.Qeshm_Island, { "SQ IRI F5" }, 4 )
A2ADispatcherRed:SetSquadronGci( "QeshmGCI", 800, 1200 )
A2ADispatcherRed:SetSquadronOverhead("QeshmGCI", 1 )
A2ADispatcherRed:SetSquadronGrouping( "QeshmGCI", 2 )
A2ADispatcherRed:SetSquadronTakeoffFromRunway( "QeshmGCI" )

A2ADispatcherRed:SetSquadron( "KishCAP", AIRBASE.PersianGulf.Kish_International_Airport, { "SQ IRI MIG29" }, 4 )
--A2ADispatcherRed:SetSquadronGci( "KishCAP", 800, 1200 )
A2ADispatcherRed:SetSquadronOverhead("KishCAP", 1 )
A2ADispatcherRed:SetSquadronGrouping( "KishCAP", 2 )
A2ADispatcherRed:SetSquadronTakeoffFromRunway( "KishCAP" )


A2ADispatcherRed:SetSquadron( "HavadaryaCAP", AIRBASE.PersianGulf.Havadarya, { "SQ IRI MIG29" }, 2 )
--A2ADispatcherRed:SetSquadronGci( "HavadaryaCAP", 800, 1200 )
A2ADispatcherRed:SetSquadronOverhead("HavadaryaCAP", 1 )
A2ADispatcherRed:SetSquadronGrouping( "HavadaryaCAP", 2 )
A2ADispatcherRed:SetSquadronTakeoffFromParkingHot( "HavadaryaCAP" )

A2ADispatcherRed:SetSquadron( "JaskCAP", AIRBASE.PersianGulf.Bandar_e_Jask_airfield, { "SQ IRI F14" }, 4 )
--A2ADispatcherRed:SetSquadronGci( "JaskCAP", 800, 1200 )
A2ADispatcherRed:SetSquadronOverhead("JaskCAP", 1 )
A2ADispatcherRed:SetSquadronGrouping( "JaskCAP", 2 )
A2ADispatcherRed:SetSquadronTakeoffFromParkingHot( "JaskCAP" )

RedCAPZone1 = ZONE:New( "RedCapZone1")
A2ADispatcherRed:SetSquadronCap( "HavadaryaCAP", RedCAPZone1, 4000, 8000, 600, 800, 800, 1200, "BARO" )
A2ADispatcherRed:SetSquadronCapInterval( "HavadaryaCAP", 1, 30, 300, 1 )

RedCAPZone2 = ZONE:New( "RedCapZone2")
A2ADispatcherRed:SetSquadronCap( "KishCAP", B1, 4000, 8000, 600, 800, 800, 1200, "RADIO" )
A2ADispatcherRed:SetSquadronCapInterval( "KishCAP", 1, 30, 300, 1 )

RedCAPZone3 = ZONE:New( "RedCapZone3")
A2ADispatcherRed:SetSquadronCap( "JaskCAP", RedCAPZone3, 4000, 8000, 600, 800, 800, 1200, "BARO" )
A2ADispatcherRed:SetSquadronCapInterval( "JaskCAP", 1, 30, 300, 1 )


--Set up the Blue Squadrons

A2ADispatcherBlue:SetSquadron( "ALAINCAP", AIRBASE.PersianGulf.Al_Ain_International_Airport, { "SQ NATO F15" }, 4 )
--A2ADispatcherBlue:SetSquadronGci( "ALAINCAP", 800, 1200 )
A2ADispatcherBlue:SetSquadronOverhead("ALAINCAP", 1 )
A2ADispatcherBlue:SetSquadronGrouping( "ALAINCAP", 2 )
A2ADispatcherBlue:SetSquadronTakeoffFromParkingHot( "ALAINCAP" )

A2ADispatcherBlue:SetSquadron( "FujairahCAP", AIRBASE.PersianGulf.Fujairah_Intl, { "SQ NATO F4" }, 4 )
--A2ADispatcherBlue:SetSquadronGci( "FujairahCAP", 800, 1200 )
A2ADispatcherBlue:SetSquadronOverhead("FujairahCAP", 1 )
A2ADispatcherBlue:SetSquadronGrouping( "FujairahCAP", 2 )
A2ADispatcherBlue:SetSquadronTakeoffFromParkingHot( "FujairahCAP" )

--Set up the Blue CapZones
BlueCAPZone1 = ZONE:New( "BlueCapZone1")
A2ADispatcherBlue:SetSquadronCap( "FujairahCAP", BlueCAPZone1, 4000, 8000, 600, 800, 800, 1200, "BARO" )
A2ADispatcherBlue:SetSquadronCapInterval( "FujairahCAP", 1, 30, 300, 1 )

BlueCAPZone2 = ZONE:New( "BlueCapZone2")
A2ADispatcherBlue:SetSquadronCap( "ALAINCAP", BlueCAPZone2, 4000, 8000, 600, 800, 800, 1200, "BARO" )
A2ADispatcherBlue:SetSquadronCapInterval( "ALAINCAP", 1, 30, 300, 1 )