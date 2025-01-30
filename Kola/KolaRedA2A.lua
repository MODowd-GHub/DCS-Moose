local SamSet = SET_GROUP:New():FilterPrefixes("Red SAM"):FilterCoalitions("red"):FilterStart()
Redshorad = SHORAD:New("RedShorad", "Red SHORAD", SamSet, 22000, 600, "red")
--Redshorad:SwitchDebug(true)
--Start the RedMANTIS
redmantis = MANTIS:New("redmantis","Red SAM","DF CCCP EWR","Red HQ","red",true,"DF CCCP AWACS")
redmantis:SetAutoRelocate(true, true) -- make HQ and EWR relocatable, if they are actually mobile in DCS!
redmantis:SetAdvancedMode(true, 100) -- switch on advanced mode - detection will slow down or die if HQ and EWR die
redmantis:SetSAMRange(95)
redmantis:Debug(true)
redmantis.verbose = true -- watch DCS.log
redmantis:Start()


DetectionSetGroup = SET_GROUP:New()
DetectionSetGroup:FilterPrefixes( {"DF CCCP EWR", "DF CCCP AWACS" } )
DetectionSetGroup:FilterStart()

Detection = DETECTION_AREAS:New( DetectionSetGroup, 30000 )

-- Setup the A2A dispatcher, and initialize it.
A2ADispatcherRed = AI_A2A_DISPATCHER:New( Detection )

CCCPBorderZone = ZONE_POLYGON:New( "CCCP Border", GROUP:FindByName( "CCCP Border" ) )
A2ADispatcherRed:SetBorderZone( CCCPBorderZone )
A2ADispatcherRed:SetEngageRadius( 150000 )

A2ADispatcherRed:SetSquadron( "Severomorsk3GCI", AIRBASE.Kola.Severomorsk3, { "SQ CCCP MIG-23" }, 2 )
A2ADispatcherRed:SetSquadronGci( "Severomorsk3GCI", 800, 1200 )
A2ADispatcherRed:SetSquadronOverhead("Severomorsk3GCI", 1 )
A2ADispatcherRed:SetSquadronGrouping( "Severomorsk3GCI", 2 )
A2ADispatcherRed:SetSquadronTakeoffFromRunway( "Severomorsk3GCI" )