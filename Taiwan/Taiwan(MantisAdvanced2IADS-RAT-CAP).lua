--RAT
local Ryanair=RAT:New("RayanAir")
Ryanair:SetDeparture(AIRBASE.Syria.Gecitkale)
Ryanair:Spawn(1)
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


--Set up Red Dispatcher
RedA2ADispatcher = AI_A2A_DISPATCHER:New(rediads.Detection)  -- use existing detection object
--RedA2ADispatcher:SetTacticalDisplay( true )
--Set Border
PRCBorderZone = ZONE_POLYGON:New( "PRC Border", GROUP:FindByName( "CCCP Border" ) )
RedA2ADispatcher:SetBorderZone( PRCBorderZone )
RedA2ADispatcher:SetEngageRadius( 150000 )
--RedA2ADispatcher:SetGciRadius( 100000 )
--Set up Red Squadrons
RedA2ADispatcher:SetSquadron( "CAP1", AIRBASE.Syria.Hatay, { "SQ PLAAF J-11" }, 4 )
--RedA2ADispatcher:SetSquadronGci( "CAP1", 800, 1200 )
RedA2ADispatcher:SetSquadronOverhead("CAP1", 1 )
RedA2ADispatcher:SetSquadronGrouping( "CAP1", 2 )
RedA2ADispatcher:SetSquadronTakeoffFromParkingHot( "CAP1" )

RedA2ADispatcher:SetSquadron( "CAP2", AIRBASE.Syria.Shayrat, { "SQ PLAAF J-10" }, 4 )
--RedA2ADispatcher:SetSquadronGci( "CAP2", 800, 1200 )
RedA2ADispatcher:SetSquadronOverhead("CAP2", 1 )
RedA2ADispatcher:SetSquadronGrouping( "CAP2", 2 )
RedA2ADispatcher:SetSquadronTakeoffFromParkingHot( "CAP2" )

RedA2ADispatcher:SetSquadron( "GCI1", AIRBASE.Syria.Bassel_Al_Assad, { "SQ PLAAF J-7" }, 4 )
RedA2ADispatcher:SetSquadronGci( "GCI1", 800, 1200 )
RedA2ADispatcher:SetSquadronOverhead("GCI1", 1.5 )
RedA2ADispatcher:SetSquadronGrouping( "GCI1", 2 )
RedA2ADispatcher:SetSquadronTakeoffFromRunway( "GCI1" )

RedA2ADispatcher:SetSquadron( "GCI2", AIRBASE.Syria.Rene_Mouawad, { "SQ PLAAF J-7" }, 4 )
RedA2ADispatcher:SetSquadronGci( "GCI2", 800, 1200 )
RedA2ADispatcher:SetSquadronOverhead("GCI2", 1.5 )
RedA2ADispatcher:SetSquadronGrouping( "GCI2", 2 )
RedA2ADispatcher:SetSquadronTakeoffFromRunway( "GCI2" )
--Set up Red CAP Zones
RedCAPZone1 = ZONE:New( "RedCAPZone1", GROUP:FindByName( "RedCapZone1" ) )
RedA2ADispatcher:SetSquadronCap( "CAP1", RedCAPZone1, 4000, 8000, 600, 800, 800, 1200, "BARO" )
RedA2ADispatcher:SetSquadronCapInterval( "CAP1", 1, 30, 300, 1 )

RedCAPZone2 = ZONE:New( "RedCAPZone2", GROUP:FindByName( "RedCapZone2" ) )
RedA2ADispatcher:SetSquadronCap( "CAP2", RedCAPZone1, 4000, 8000, 600, 800, 800, 1200, "BARO" )
RedA2ADispatcher:SetSquadronCapInterval( "CAP2", 1, 30, 300, 1 )

--Set up Blue Dispatcher
BlueA2ADispatcher = AI_A2A_DISPATCHER:New(blueiads.Detection)  -- use existing detection object
--BlueA2ADispatcher:SetTacticalDisplay( true )
--Set Border
ROCBorderZone = ZONE_POLYGON:New( "ROCBorder", GROUP:FindByName( "ROCBorder" ) )
BlueA2ADispatcher:SetBorderZone( ROCBorderZone )
BlueA2ADispatcher:SetEngageRadius( 150000 )
--RedA2ADispatcher:SetGciRadius( 100000 )

--Set up Blue Squadrons
BlueA2ADispatcher:SetSquadron( "BGCI1", AIRBASE.Syria.Kingsfield, { "PointGCI" }, 2 )
BlueA2ADispatcher:SetSquadronGci( "BGCI1", 800, 1200 )
BlueA2ADispatcher:SetSquadronOverhead("BGCI1", 1.5 )
BlueA2ADispatcher:SetSquadronGrouping( "BGCI1", 2 )
BlueA2ADispatcher:SetSquadronTakeoffFromRunway( "BGCI1" )

BlueA2ADispatcher:SetSquadron( "BGCI2", AIRBASE.Syria.Paphos, { "PointGCI" }, 2 )
BlueA2ADispatcher:SetSquadronGci( "BGCI2", 800, 1200 )
BlueA2ADispatcher:SetSquadronOverhead("BGCI2", 1.5 )
BlueA2ADispatcher:SetSquadronGrouping( "BGCI2", 2 )
BlueA2ADispatcher:SetSquadronTakeoffFromRunway( "BGCI2" )

BlueA2ADispatcher:SetSquadron( "BCAP1", AIRBASE.Syria.Larnaca, { "BlueCap1" }, 4 )
--BlueA2ADispatcher:SetSquadronGci( "BCAP1", 800, 1200 )
BlueA2ADispatcher:SetSquadronOverhead("BCAP1", 1 )
BlueA2ADispatcher:SetSquadronGrouping( "BCAP1", 2 )
BlueA2ADispatcher:SetSquadronTakeoffFromParkingHot( "BCAP1" )

BlueA2ADispatcher:SetSquadron( "BCAP2", AIRBASE.Syria.Akrotiri, { "BlueCap2" }, 4 )
--BlueA2ADispatcher:SetSquadronGci( "BCAP2", 800, 1200 )
BlueA2ADispatcher:SetSquadronOverhead("BCAP2", 1 )
BlueA2ADispatcher:SetSquadronGrouping( "BCAP2", 2 )
BlueA2ADispatcher:SetSquadronTakeoffFromParkingHot( "BCAP2" )

--Set up Blue CAP Zones
BlueCAPZone1 = ZONE:New( "BlueCapZone1", GROUP:FindByName( "BlueCapZone1" ) )
BlueA2ADispatcher:SetSquadronCap( "BCAP1", BlueCAPZone1, 4000, 8000, 600, 800, 800, 1200, "BARO" )
BlueA2ADispatcher:SetSquadronCapInterval( "BCAP1", 1, 30, 300, 1 )

BlueCAPZone2 = ZONE:New( "BlueCapZone2", GROUP:FindByName( "BlueCapZone2" ) )
BlueA2ADispatcher:SetSquadronCap( "BCAP2", BlueCAPZone2, 4000, 8000, 600, 800, 800, 1200, "BARO" )
BlueA2ADispatcher:SetSquadronCapInterval( "BCAP2", 1, 30, 300, 1 )









