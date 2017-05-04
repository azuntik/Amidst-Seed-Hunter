; =============================================================================
; Amidst Seed Hunter - Globals (ASH_Globals.au3)
;
; Author: 	Azuntik
; Date:		2017.5.2
; License:	CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
;
; This file is part of the Amidst Seed Hunter project
; =============================================================================

Global $versionNumber = "0.2.3"
Global $debugBuffer, $searchResults, $newSearch

; GUI control globals
Global $form, $tabSet, $biomesTab, $structuresTab, $optionsTab, $resultsTab, $debugTab
Global $cancelQuitButton, $beginSearchButton, $currentTab, $previousTab
Global $searchContextMenu, $advancedSearchMenuItem

Global $availableBiomeList, $includedBiomeList, $excludedBiomeList
Global $availableBiomeLabel, $includedBiomeLabel, $excludedBiomeLabel
Global $includeBiomeButton, $removeIncludedBiomeButton, $removeAllIncludedBiomeButton
Global $excludeBiomeButton, $removeExcludedBiomeButton, $removeAllExcludedBiomeButton
Global $includedBiomeGroupButton, $excludedBiomeGroupButton, $biomeGroupMenu
Global $preset0Button, $preset0ContextMenu, $removePreset0
Global $preset1Button, $preset1ContextMenu, $removePreset1
Global $preset2Button, $preset2ContextMenu, $removePreset2
Global $preset3Button, $preset3ContextMenu, $removePreset3
Global $preset4Button, $preset4ContextMenu, $removePreset4

Global $availableStructList, $includedStructList, $excludedStructList
Global $availableStructLabel, $includedStructLabel, $excludedStructLabel
Global $includeStructButton, $removeIncludedStructButton, $removeAllIncludedStructButton
Global $excludeStructButton, $removeExcludedStructButton, $removeAllExcludedStructButton
Global $preset5Button, $preset5ContextMenu, $removePreset5
Global $preset6Button, $preset6ContextMenu, $removePreset6
Global $preset7Button, $preset7ContextMenu, $removePreset7
Global $preset8Button, $preset8ContextMenu, $removePreset8
Global $preset9Button, $preset9ContextMenu, $removePreset9

Global $seedOptionsGroup, $searchOptionsGroup, $otherOptionsGroup
Global $useRandomSeedsRadio, $useSeedListFileRadio, $seedListFileLabel, $seedListFileInput
Global $seedListFileBrowseButton, $seedOffsetLabel, $seedOffsetInput, $seedListInfoLabel
Global $searchForBiomeChkbx, $enableBiomeGroupsChkbx, $searchForStructChkbx, $saveResultsToFileChkbx
Global $includeRejectedSeedsChkbx, $resultsOutputFileLabel, $resultsOutputFileInput
Global $resultsOutputFileBrowseButton, $overwriteOutputFileChkbx
Global $maxSeedsLabel, $maxSeedsInput, $numSeedsToEvaluateLabel, $numSeedsToEvaluateInput
Global $guidedAmidstSetupChkbx, $saveScreenshotChkbx, $rememberAmidstWinSizeChkbx
Global $macLinuxCompatChkbx, $showProgressPopupChkbx, $showResultsTabChkbx, $enableDebugChkbx
Global $restoreHiddenDialogsButton, $reloadSettingsINIButton, $resetAllOptionsButton
Global $removePresetButton

Global $resultsEdit, $clearResultsButton, $copyResultsButton, $saveResultsButton

Global $debugEdit, $clearDebugButton, $copyDebugButton, $saveDebugButton

Global $biomeTabControlsArray = []
Global $structTabControlsArray = []
Global $optionsTabControlsArray = []
Global $resultsTabControlsArray = []
Global $debugTabControlsArray = []

Global $removePresetsForm = -1
Global $msg, $cancelButton, $okButton
Global $preset0Chkbx, $preset1Chkbx, $preset2Chkbx, $preset3Chkbx, $preset4Chkbx
Global $preset5Chkbx, $preset6Chkbx, $preset7Chkbx, $preset8Chkbx, $preset9Chkbx
Global $presetsSet = []

; Settings globals
Global $settingsINIFile, $useRandomSeeds, $seedListFile, $seedOffset, $seedFileInfo
Global $searchForBiomes, $enableBiomeGroups, $searchForStructures, $saveSearchResultsToFile
Global $maxSeedsToEvaluate, $seedsToFind, $resultsFile, $overwriteResults, $guidedAmidstSetup
Global $saveScreenshots, $rememberAmidstWindowSize, $showProgressPopupWindow, $macLinuxCompatibility
Global $showResultsTab, $enableDebugging, $includeRejectedSeeds
Global $amidstSetupComplete = False
Global $presetArray = []
Global $biomeArray = []
Global $biomeGroupArray = []
Global $structArray = []
Global $amidstWindowTitle = "Amidst v4.2"

Func UpdateGlobals()
	$settingsINIFile = @ScriptDir & "\Settings.ini"
	
	If FileExists($settingsINIFile) Then	
		$useRandomSeeds = IniRead($settingsINIFile, "Options", "UseRandomSeeds", 1)
		$seedListFile = IniRead($settingsINIFile, "Options", "SeedListFile", "")
		$seedOffset = IniRead($settingsINIFile, "Options", "SeedOffset", 0)
		$seedFileInfo = IniRead($settingsINIFile, "Options", "SeedFileInfo", "")
		$searchForBiomes = IniRead($settingsINIFile, "Options", "SearchForBiomes", 1)
		;$enableBiomeGroups = IniRead($settingsINIFile, "Options", "EnableBiomeGroups", 0)
		$enableBiomeGroups = 0
		$saveSearchResultsToFile = IniRead($settingsINIFile, "Options", "SaveSearchResultsToFile", 0)
		$searchForStructures = IniRead($settingsINIFile, "Options", "SearchForStructures", 0)
		$includeRejectedSeeds = IniRead($settingsINIFile, "Options", "IncludeRejectedSeeds", 0)
		$maxSeedsToEvaluate = IniRead($settingsINIFile, "Options", "MaxSeedsToEvaluate", 100)
		$seedsToFind = IniRead($settingsINIFile, "Options", "SeedsToFind", 1)
		$resultsFile = IniRead($settingsINIFile, "Options", "ResultsFile", "")
		$overwriteResults = IniRead($settingsINIFile, "Options", "OverwriteResults", 0)
		$guidedAmidstSetup = IniRead($settingsINIFile, "Options", "GuidedAmidstSetup", 1)
		$saveScreenshots = IniRead($settingsINIFile, "Options", "SaveScreenshots", 0)
		$rememberAmidstWindowSize = IniRead($settingsINIFile, "Options", "RememberAmidstWindowSize", 0)
		$showProgressPopupWindow = IniRead($settingsINIFile, "Options", "ShowProgressPopupWindow", 1)
		$macLinuxCompatibility = IniRead($settingsINIFile, "Options", "MacLinuxCompatibility", 0)
		$showResultsTab = IniRead($settingsINIFile, "Options", "ShowResultsTab", 0)
		$enableDebugging = IniRead($settingsINIFile, "Options", "EnableDebugging", 0)
		$presetArray = IniReadSection($settingsINIFile, "Presets")
		$biomeArray = IniReadSection($settingsINIFile, "BiomeList")
		;$biomeGroupArray = IniReadSection($settingsINIFile, "BiomeGroups")
		$structArray = IniReadSection($settingsINIFile, "StructureList")
	Else
		DoResetINIFileToDefaults(False) ; Create INI File
		IniWriteSection($settingsINIFile, "Presets", _
			"Preset0Name=" 		& @LF & _
			"Preset0Include=" 	& @LF & _
			"Preset0Exclude=" 	& @LF & _
			"Preset1Name=" 		& @LF & _
			"Preset1Include=" 	& @LF & _
			"Preset1Exclude=" 	& @LF & _
			"Preset2Name=" 		& @LF & _
			"Preset2Include=" 	& @LF & _
			"Preset2Exclude=" 	& @LF & _
			"Preset3Name=" 		& @LF & _
			"Preset3Include=" 	& @LF & _
			"Preset3Exclude=" 	& @LF & _
			"Preset4Name=" 		& @LF & _
			"Preset4Include=" 	& @LF & _
			"Preset4Exclude=" 	& @LF & _
			"Preset5Name=" 		& @LF & _
			"Preset5Include=" 	& @LF & _
			"Preset5Exclude=" 	& @LF & _
			"Preset6Name=" 		& @LF & _
			"Preset6Include=" 	& @LF & _
			"Preset6Exclude=" 	& @LF & _
			"Preset7Name=" 		& @LF & _
			"Preset7Include=" 	& @LF & _
			"Preset7Exclude=" 	& @LF & _
			"Preset8Name=" 		& @LF & _
			"Preset8Include=" 	& @LF & _
			"Preset8Exclude=" 	& @LF & _
			"Preset9Name=" 		& @LF & _
			"Preset9Include=" 	& @LF & _
			"Preset9Exclude="	)
		IniWriteSection($settingsINIFile, "BiomeList", _
			"Beach=0xFADE55" 						& @LF & _
			"Beach M=0xFFFF7D" 						& @LF & _
			"Birch Forest=0x307444" 				& @LF & _
			"Birch Forest Hills=0x1F5F32" 			& @LF & _
			"Birch Forest Hills M=0x47875A" 		& @LF & _
			"Birch Forest M=0x589C6C" 				& @LF & _
			"Cold Beach=0xFAF0C0" 					& @LF & _
			"Cold Beach M=0xFFFFE8" 				& @LF & _
			"Cold Taiga=0x31554A" 					& @LF & _
			"Cold Taiga Hills=0x243F36" 			& @LF & _
			"Cold Taiga Hills M=0x4C675E" 			& @LF & _
			"Cold Taiga M=0x597D72" 				& @LF & _
			"Deep Ocean=0x000030" 					& @LF & _
			"Deep Ocean M=0x282858" 				& @LF & _
			"Desert=0xFA9418" 						& @LF & _
			"Desert Hills=0xD25F12" 				& @LF & _
			"Desert Hills M=0xFA873A" 				& @LF & _
			"Desert M=0xFFBC40" 					& @LF & _
			"Extreme Hills+=0x507050" 				& @LF & _
			"Extreme Hills=0x606060" 				& @LF & _
			"Extreme Hills Edge=0x72789A" 			& @LF & _
			"Extreme Hills Edge M=0x9AA0C2" 		& @LF & _
			"Extreme Hills M=0x888888" 				& @LF & _
			"Extreme Hills+ M=0x789878" 			& @LF & _
			"Flower Forest=0x2D8E49" 				& @LF & _
			"Forest=0x056621" 						& @LF & _
			"Forest Hills=0x22551C" 				& @LF & _
			"Forest Hills M=0x4A7D44" 				& @LF & _
			"Frozen Ocean=0x9090A0" 				& @LF & _
			"Frozen Ocean M=0xB8B8C8" 				& @LF & _
			"Frozen River=0xA0A0FF" 				& @LF & _
			"Frozen River M=0xC8C8FF" 				& @LF & _
			"Ice Mountains=0xA0A0A0" 				& @LF & _
			"Ice Mountains M=0xC8C8C8" 				& @LF & _
			"Ice Plains=0xFFFFFF" 					& @LF & _
			"Ice Plains Spikes=0xB4DCDC" 			& @LF & _
			"Jungle=0x537B09" 						& @LF & _
			"Jungle Edge=0x628B17" 					& @LF & _
			"Jungle Edge M=0x8AB33F" 				& @LF & _
			"Jungle Hills=0x2C4205" 				& @LF & _
			"Jungle Hills M=0x546A2D" 				& @LF & _
			"Jungle M=0x7BA331" 					& @LF & _
			"Mega Spruce Taiga=0x818E79" 			& @LF & _
			"Mega Spruce Taiga (Hills)=0x6D7766" 	& @LF & _
			"Mega Taiga=0x596651" 					& @LF & _
			"Mega Taiga Hills=0x454F3E" 			& @LF & _
			"Mesa=0xD94515" 						& @LF & _
			"Mesa (Bryce)=0xFF6D3D" 				& @LF & _
			"Mesa Plateau=0xCA8C65" 				& @LF & _
			"Mesa Plateau F=0xB09765" 				& @LF & _
			"Mesa Plateau F M=0xD8BF8D" 			& @LF & _
			"Mesa Plateau M=0xF2B48D" 				& @LF & _
			"Mushroom Island=0xFF00FF" 				& @LF & _
			"Mushroom Island M=0xFF28FF" 			& @LF & _
			"Mushroom Island Shore=0xA000FF" 		& @LF & _
			"Mushroom Island Shore M=0xC828FF" 		& @LF & _
			"Ocean=0x000070" 						& @LF & _
			"Ocean M=0x282898" 						& @LF & _
			"Plains=0x8DB360" 						& @LF & _
			"River=0x0000FF" 						& @LF & _
			"River M=0x2828FF" 						& @LF & _
			"Roofed Forest=0x40511A" 				& @LF & _
			"Roofed Forest M=0x687942" 				& @LF & _
			"Savanna=0xBDB25F" 						& @LF & _
			"Savanna M=0xE5DA87" 					& @LF & _
			"Savanna Plateau=0xA79D64" 				& @LF & _
			"Savanna Plateau M=0xCFC58C" 			& @LF & _
			"Stone Beach=0xA2A284" 					& @LF & _
			"Stone Beach M=0xCACAAC" 				& @LF & _
			"Sunflower Plains=0xB5DB88" 			& @LF & _
			"Swampland=0x07F9B2" 					& @LF & _
			"Swampland M=0x2FFFDA" 					& @LF & _
			"Taiga=0x0B6659" 						& @LF & _
			"Taiga Hills=0x163933" 					& @LF & _
			"Taiga Hills M=0x3E615B" 				& @LF & _
			"Taiga M=0x338E81"						)
		IniWriteSection($settingsINIFile, "BiomeGroups", _
			"Any Beach=Beach|Beach M|Cold Beach|Cold Beach M|Stone Beach|Stone Beach M" & @LF & _
			"Any Birch Forest=Birch Forest|Birch Forest Hills|Birch Forest Hills M|Birch Forest M" & @LF & _
			"Any Desert=Desert|Desert Hills|Desert Hills M|Desert M" & @LF & _
			"Any Extreme Hills=Extreme Hills|Extreme Hills Edge|Extreme Hills Edge M|Extreme Hills M|Extreme Hills+|Extreme Hills +M" & @LF & _
			"Any Forest=Flower Forest|Forest|Forest Hills|Forest Hills M" & @LF & _
			"Any Ice Mountains=Ice Mountains|Ice Mountains M" & @LF & _
			"Any Ice Plains=Ice Plains|Ice Plains Spikes" & @LF & _
			"Any Jungle=Jungle|Jungle Edge|Jungle Edge M|Jungle Hills|Jungle Hills M|Jungle M" & @LF & _
			"Any Mesa=Mesa|Mesa (Bryce)|Mesa Plateau|Mesa Plateau F|Mesa Plateau F M|Mesa Plateau M" & @LF & _
			"Any Mushroom Island=Mushroom Island|Mushroom Island M|Mushroom Island Shore|Mushroom Island Shore M" & @LF & _
			"Any Ocean=Deep Ocean|Deep Ocean M|Frozen Ocean|Frozen Ocean M|Ocean|Ocean M" & @LF & _
			"Any Plains=Plains|Sunflower Plains" & @LF & _
			"Any River=Frozen River|Frozen River M|River|River M" & @LF & _
			"Any Roofed Forest=Roofed Forest|Roofed Forest M" & @LF & _
			"Any Savanna=Savanna|Savanna M|Savanna Plateau|Savanna Plateau M" & @LF & _
			"Any Swampland=Swampland|Swampland M" & @LF & _
			"Any Taiga=Cold Taiga|Cold Taiga Hills|Cold Taiga Hills M|Cold Taiga M|Mega Spruce Taiga|Mega Spruce Taiga (Hills)|Mega Taiga|Mega Taiga Hills|Taiga|Taiga Hills|Taiga Hills M|Taiga M" & @LF & _
			"All Beaches=Beach|Beach M|Cold Beach|Cold Beach M|Stone Beach|Stone Beach M" & @LF & _
			"All Birch Forests=Birch Forest|Birch Forest Hills|Birch Forest Hills M|Birch Forest M" & @LF & _
			"All Deserts=Desert|Desert Hills|Desert Hills M|Desert M" & @LF & _
			"All Extreme Hills=Extreme Hills|Extreme Hills Edge|Extreme Hills Edge M|Extreme Hills M|Extreme Hills+|Extreme Hills +M" & @LF & _
			"All Forests=Flower Forest|Forest|Forest Hills|Forest Hills M" & @LF & _
			"All Ice Mountains=Ice Mountains|Ice Mountains M" & @LF & _
			"All Ice Plains=Ice Plains|Ice Plains Spikes" & @LF & _
			"All Jungles=Jungle|Jungle Edge|Jungle Edge M|Jungle Hills|Jungle Hills M|Jungle M" & @LF & _
			"All Mesas=Mesa|Mesa (Bryce)|Mesa Plateau|Mesa Plateau F|Mesa Plateau F M|Mesa Plateau M" & @LF & _
			"All Mushroom Islands=Mushroom Island|Mushroom Island M|Mushroom Island Shore|Mushroom Island Shore M" & @LF & _
			"All Oceans=Deep Ocean|Deep Ocean M|Frozen Ocean|Frozen Ocean M|Ocean|Ocean M" & @LF & _
			"All Plains=Plains|Sunflower Plains" & @LF & _
			"All Rivers=Frozen River|Frozen River M|River|River M" & @LF & _
			"All Roofed Forests=Roofed Forest|Roofed Forest M" & @LF & _
			"All Savannas=Savanna|Savanna M|Savanna Plateau|Savanna Plateau M" & @LF & _
			"All Swamplands=Swampland|Swampland M" & @LF & _
			"All Taigas=Cold Taiga|Cold Taiga Hills|Cold Taiga Hills M|Cold Taiga M|Mega Spruce Taiga|Mega Spruce Taiga (Hills)|Mega Taiga|Mega Taiga Hills|Taiga|Taiga Hills|Taiga Hills M|Taiga M")
		IniWriteSection($settingsINIFile, "StructureList", _
			"Desert Temple=0xBBB36D" 	& @LF & _
			"Igloo=0xA7B8FF" 			& @LF & _
			"Jungle Temple=0x364636" 	& @LF & _
			"Mineshaft=0x76613C" 		& @LF & _
			"Nether Fortress=0x311E24"	& @LF & _
			"Ocean Monument=0x285A45" 	& @LF & _
			"Stronghold=0x4D5A35" 		& @LF & _
			"Village=0x75472F" 			& @LF & _
			"Witch Hut=0x0F41FB"		)
			
		UpdateGlobals()
	EndIf
EndFunc
