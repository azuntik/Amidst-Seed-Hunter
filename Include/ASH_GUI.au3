; =============================================================================
; Amidst Seed Hunter - GUI (ASH_GUI.au3)
;
; Author: 	Azuntik
; Date:		2017.5.2
; License:	CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
;
; This file is part of the Amidst Seed Hunter project
; =============================================================================

#Region Build GUI Functions
Func DoBuildMainGUI()
	$form = GUICreate("Amidst Seed Hunter v" & $versionNumber, 500, 500)

	$tabSet = _GUICtrlTab_Create($form, 5, 5, 490, 457)

	$beginSearchButton = GUICtrlCreateButton("Begin Search...", 397, 467, 95, 25)
	$searchContextMenu = GUICtrlCreateContextMenu($beginSearchButton)
	$advancedSearchMenuItem = GUICtrlCreateMenuItem("Advanced Search...", $searchContextMenu)
	$cancelQuitButton = GUICtrlCreateButton("Cancel/Quit", 5, 467, 95, 25)

	If $searchForBiomes = 1 Then DoBuildBiomesTab()
	If $searchForStructures = 1 Then DoBuildStructuresTab()
	DoBuildOptionsTab()
	If $showResultsTab = 1 Then DoBuildResultsTab()
	If $enableDebugging = 1 Then DoBuildDebugTab()

	GUISetState(@SW_SHOW, $form)

	If $searchForBiomes = 0 Then
		If $searchForStructures = 0 Then
			DebugWrite("Focusing options tab")
			DoShowOptionsTab()
		Else
			DebugWrite("Focusing structures tab")
			DoShowStructuresTab()
		EndIf
	Else
		DebugWrite("Focusing biomes tab")
		DoShowBiomesTab()
	EndIf
EndFunc

Func DoBuildBiomesTab()
	Dim $temp

	$biomesTab = _GUICtrlTab_InsertItem($tabSet, 0, "Biomes")

	$availableBiomeList = _GUICtrlListBox_Create($tabSet, "", 8, 50, 180, 380, BitOR($LBS_SORT, $LBS_DISABLENOSCROLL, $LBS_EXTENDEDSEL, $WS_VSCROLL))
	_ArrayAdd($biomeTabControlsArray, $availableBiomeList)

	$includedBiomeList = _GUICtrlListBox_Create($tabSet, "", 300, 50, 180, 180, BitOR($LBS_SORT, $LBS_DISABLENOSCROLL, $LBS_EXTENDEDSEL, $WS_VSCROLL))
	_ArrayAdd($biomeTabControlsArray, $includedBiomeList)

	$excludedBiomeList = _GUICtrlListBox_Create($tabSet, "", 300, 245, 180, 180, BitOR($LBS_SORT, $LBS_DISABLENOSCROLL, $LBS_EXTENDEDSEL, $WS_VSCROLL))
	_ArrayAdd($biomeTabControlsArray, $excludedBiomeList)

	$availableBiomeLabel = GUICtrlCreateLabel("Available Biomes:", 14, 37)
	GUICtrlSetBkColor($availableBiomeLabel, $GUI_BKCOLOR_TRANSPARENT)
	_ArrayAdd($biomeTabControlsArray, $availableBiomeLabel)

	$includedBiomeLabel = GUICtrlCreateLabel("Included Biomes:", 306, 37)
	GUICtrlSetBkColor($includedBiomeLabel, $GUI_BKCOLOR_TRANSPARENT)
	_ArrayAdd($biomeTabControlsArray, $includedBiomeLabel)

	$excludedBiomeLabel = GUICtrlCreateLabel("Excluded Biomes:", 306, 233)
	GUICtrlSetBkColor($excludedBiomeLabel, $GUI_BKCOLOR_TRANSPARENT)
	_ArrayAdd($biomeTabControlsArray, $excludedBiomeLabel)
	
	#cs
	$includedBiomeGroupButton = GUICtrlCreateButton("Biome Group...", 392, 33, 94, 20, $BS_SPLITBUTTON)
	;$includedBiomeGroupButton = _GUICtrlButton_Create($form, "Biome Group...", 392, 33, 94, 20, $BS_SPLITBUTTON)
	_ArrayAdd($biomeTabControlsArray, $includedBiomeGroupButton)
	
	$excludedBiomeGroupButton = GUICtrlCreateButton("Biome Group...", 392, 229, 94, 20, $BS_SPLITBUTTON)
	;$excludedBiomeGroupButton = _GUICtrlButton_Create($form, "Biome Group...", 392, 229, 94, 20, $BS_SPLITBUTTON)
	_ArrayAdd($biomeTabControlsArray, $excludedBiomeGroupButton)
	
	If $enableBiomeGroups = 0 Then
		GUICtrlSetState($includedBiomeGroupButton, $GUI_HIDE)
		GUICtrlSetState($excludedBiomeGroupButton, $GUI_HIDE)
	EndIf
	#ce
	
	$includeBiomeButton = GUICtrlCreateButton("Include ->", 203, 105, 90, 25)
	_ArrayAdd($biomeTabControlsArray, $includeBiomeButton)

	$removeIncludedBiomeButton = GUICtrlCreateButton("<- Remove", 203, 135, 90, 25)
	_ArrayAdd($biomeTabControlsArray, $removeIncludedBiomeButton)

	$removeAllIncludedBiomeButton = GUICtrlCreateButton("Remove All", 203, 165, 90, 25)
	_ArrayAdd($biomeTabControlsArray, $removeAllIncludedBiomeButton)

	$excludeBiomeButton = GUICtrlCreateButton("Exclude ->", 203, 300, 90, 25)
	_ArrayAdd($biomeTabControlsArray, $excludeBiomeButton)

	$removeExcludedBiomeButton = GUICtrlCreateButton("<- Remove", 203, 330, 90, 25)
	_ArrayAdd($biomeTabControlsArray, $removeExcludedBiomeButton)

	$removeAllExcludedBiomeButton = GUICtrlCreateButton("Remove All", 203, 360, 90, 25)
	_ArrayAdd($biomeTabControlsArray, $removeAllExcludedBiomeButton)

	$temp = _ArraySearch($presetArray, "Preset0Name")
	$preset0Button = GUICtrlCreateButton($presetArray[$temp][1], 12, 429, 90, 25)
	$preset0ContextMenu = GUICtrlCreateContextMenu($preset0Button)
	$removePreset0 = GUICtrlCreateMenuItem("Remove this preset", $preset0ContextMenu)
	_ArrayAdd($biomeTabControlsArray, $preset0Button)

	$temp = _ArraySearch($presetArray, "Preset1Name")
	$preset1Button = GUICtrlCreateButton($presetArray[$temp][1], 108, 429, 90, 25)
	$preset1ContextMenu = GUICtrlCreateContextMenu($preset1Button)
	$removePreset1 = GUICtrlCreateMenuItem("Remove this preset", $preset1ContextMenu)
	_ArrayAdd($biomeTabControlsArray, $preset1Button)

	$temp = _ArraySearch($presetArray, "Preset2Name")
	$preset2Button = GUICtrlCreateButton($presetArray[$temp][1], 204, 429, 90, 25)
	$preset2ContextMenu = GUICtrlCreateContextMenu($preset2Button)
	$removePreset2 = GUICtrlCreateMenuItem("Remove this preset", $preset2ContextMenu)
	_ArrayAdd($biomeTabControlsArray, $preset2Button)

	$temp = _ArraySearch($presetArray, "Preset3Name")
	$preset3Button = GUICtrlCreateButton($presetArray[$temp][1], 300, 429, 90, 25)
	$preset3ContextMenu = GUICtrlCreateContextMenu($preset3Button)
	$removePreset3 = GUICtrlCreateMenuItem("Remove this preset", $preset3ContextMenu)
	_ArrayAdd($biomeTabControlsArray, $preset3Button)

	$temp = _ArraySearch($presetArray, "Preset4Name")
	$preset4Button = GUICtrlCreateButton($presetArray[$temp][1], 396, 429, 90, 25)
	$preset4ContextMenu = GUICtrlCreateContextMenu($preset4Button)
	$removePreset4 = GUICtrlCreateMenuItem("Remove this preset", $preset4ContextMenu)
	_ArrayAdd($biomeTabControlsArray, $preset4Button)

	For $i = 1 to UBound($biomeArray) - 1
		_GUICtrlListBox_AddString($availableBiomeList, $biomeArray[$i][0])
	Next
	
	If $enableBiomeGroups = 1 Then
		For $i = 1 to UBound($biomeGroupArray) - 1
			_GUICtrlListBox_AddString($availableBiomeList, $biomeGroupArray[$i][0])
		Next
	EndIf

	DoHideBiomesTab()
EndFunc

Func DoBuildStructuresTab()
	Dim $temp, $index

	; If Biomes tab isn't found, $index will be set to 0, which puts Structures first
	; otherwise, it will come after the Biomes tab
	$index = _GUICtrlTab_FindTab($tabSet, "Biomes") + 1

	$structuresTab = _GUICtrlTab_InsertItem($tabSet, $index, "Structures")

	$availableStructList = _GUICtrlListBox_Create($tabSet, "", 8, 50, 180, 380, BitOR($LBS_SORT, $LBS_DISABLENOSCROLL, $LBS_EXTENDEDSEL, $WS_VSCROLL))
	_ArrayAdd($structTabControlsArray, $availableStructList)

	$includedStructList = _GUICtrlListBox_Create($tabSet, "", 300, 50, 180, 180, BitOR($LBS_SORT, $LBS_DISABLENOSCROLL, $LBS_EXTENDEDSEL, $WS_VSCROLL))
	_ArrayAdd($structTabControlsArray, $includedStructList)

	$excludedStructList = _GUICtrlListBox_Create($tabSet, "", 300, 245, 180, 180, BitOR($LBS_SORT, $LBS_DISABLENOSCROLL, $LBS_EXTENDEDSEL, $WS_VSCROLL))
	_ArrayAdd($structTabControlsArray, $excludedStructList)

	$availableStructLabel = GUICtrlCreateLabel("Available Structures:", 14, 37)
	GUICtrlSetBkColor($availableStructLabel, $GUI_BKCOLOR_TRANSPARENT)
	_ArrayAdd($structTabControlsArray, $availableStructLabel)

	$includedStructLabel = GUICtrlCreateLabel("Included Structures:", 306, 37)
	GUICtrlSetBkColor($includedStructLabel, $GUI_BKCOLOR_TRANSPARENT)
	_ArrayAdd($structTabControlsArray, $includedStructLabel)

	$excludedStructLabel = GUICtrlCreateLabel("Excluded Structures:", 306, 233)
	GUICtrlSetBkColor($excludedStructLabel, $GUI_BKCOLOR_TRANSPARENT)
	_ArrayAdd($structTabControlsArray, $excludedStructLabel)

	$includeStructButton = GUICtrlCreateButton("Include ->", 203, 105, 90, 25)
	_ArrayAdd($structTabControlsArray, $includeStructButton)

	$removeIncludedStructButton = GUICtrlCreateButton("<- Remove", 203, 135, 90, 25)
	_ArrayAdd($structTabControlsArray, $removeIncludedStructButton)

	$removeAllIncludedStructButton = GUICtrlCreateButton("Remove All", 203, 165, 90, 25)
	_ArrayAdd($structTabControlsArray, $removeAllIncludedStructButton)

	$excludeStructButton = GUICtrlCreateButton("Exclude ->", 203, 300, 90, 25)
	_ArrayAdd($structTabControlsArray, $excludeStructButton)

	$removeExcludedStructButton = GUICtrlCreateButton("<- Remove", 203, 330, 90, 25)
	_ArrayAdd($structTabControlsArray, $removeExcludedStructButton)

	$removeAllExcludedStructButton = GUICtrlCreateButton("Remove All", 203, 360, 90, 25)
	_ArrayAdd($structTabControlsArray, $removeAllExcludedStructButton)

	$temp = _ArraySearch($presetArray, "Preset5Name")
	$preset5Button = GUICtrlCreateButton($presetArray[$temp][1], 12, 429, 90, 25)
	$preset5ContextMenu = GUICtrlCreateContextMenu($preset5Button)
	$removePreset5 = GUICtrlCreateMenuItem("Remove this preset", $preset5ContextMenu)
	_ArrayAdd($structTabControlsArray, $preset5Button)

	$temp = _ArraySearch($presetArray, "Preset6Name")
	$preset6Button = GUICtrlCreateButton($presetArray[$temp][1], 108, 429, 90, 25)
	$preset6ContextMenu = GUICtrlCreateContextMenu($preset6Button)
	$removePreset6 = GUICtrlCreateMenuItem("Remove this preset", $preset6ContextMenu)
	_ArrayAdd($structTabControlsArray, $preset6Button)

	$temp = _ArraySearch($presetArray, "Preset7Name")
	$preset7Button = GUICtrlCreateButton($presetArray[$temp][1], 204, 429, 90, 25)
	$preset7ContextMenu = GUICtrlCreateContextMenu($preset7Button)
	$removePreset7 = GUICtrlCreateMenuItem("Remove this preset", $preset7ContextMenu)
	_ArrayAdd($structTabControlsArray, $preset7Button)

	$temp = _ArraySearch($presetArray, "Preset8Name")
	$preset8Button = GUICtrlCreateButton($presetArray[$temp][1], 300, 429, 90, 25)
	$preset8ContextMenu = GUICtrlCreateContextMenu($preset8Button)
	$removePreset8 = GUICtrlCreateMenuItem("Remove this preset", $preset8ContextMenu)
	_ArrayAdd($structTabControlsArray, $preset8Button)

	$temp = _ArraySearch($presetArray, "Preset9Name")
	$preset9Button = GUICtrlCreateButton($presetArray[$temp][1], 396, 429, 90, 25)
	$preset9ContextMenu = GUICtrlCreateContextMenu($preset9Button)
	$removePreset9 = GUICtrlCreateMenuItem("Remove this preset", $preset9ContextMenu)
	_ArrayAdd($structTabControlsArray, $preset9Button)

	For $i = 1 to UBound($structArray) - 1
		_GUICtrlListBox_AddString($availableStructList, $structArray[$i][0])
	Next

	DoHideStructuresTab()
EndFunc

Func DoBuildOptionsTab()
	Dim $index

	; Position the options tab relative to other tabs
	$index = _GUICtrlTab_FindTab($tabSet, "Structures") + 1
	If $index = 0 Then ; Structures tab wasn't found
		$index = _GUICtrlTab_FindTab($tabSet, "Biomes") + 1
		; If Biomes isn't found either, $index will be set to 0, putting it on the far left
	EndIf

	$optionsTab = _GUICtrlTab_InsertItem($tabSet, $index, "Options")

	$seedOptionsGroup = GUICtrlCreateGroup("Seed Options", 13, 32, 472, 90)
	GUICtrlSetBkColor($seedOptionsGroup, $COLOR_WHITE) ;$GUI_BKCOLOR_TRANSPARENT)
	_ArrayAdd($optionsTabControlsArray, $seedOptionsGroup)

	$useRandomSeedsRadio = GUICtrlCreateRadio("Use random seeds", 20, 50)
	GUICtrlSetBkColor($useRandomSeedsRadio, $COLOR_WHITE) ;$GUI_BKCOLOR_TRANSPARENT)
	If $useRandomSeeds = 1 Then GUICtrlSetState($useRandomSeedsRadio, $GUI_CHECKED)
	_ArrayAdd($optionsTabControlsArray, $useRandomSeedsRadio)

	$useSeedListFileRadio = GUICtrlCreateRadio("Use seed list from file", 20, 70)
	GUICtrlSetBkColor($useSeedListFileRadio, $COLOR_WHITE) ;$GUI_BKCOLOR_TRANSPARENT)
	If $useRandomSeeds = 0 Then GUICtrlSetState($useSeedListFileRadio, $GUI_CHECKED)
	_ArrayAdd($optionsTabControlsArray, $useSeedListFileRadio)

	$seedListFileLabel = GUICtrlCreateLabel("Seed list file:", 155, 55, 250, 20)
	GUICtrlSetBkColor($seedListFileLabel, $GUI_BKCOLOR_TRANSPARENT)
	_ArrayAdd($optionsTabControlsArray, $seedListFileLabel)

	$seedListFileInput = GUICtrlCreateInput($seedListFile, 155, 70, 250, 20)
	_ArrayAdd($optionsTabControlsArray, $seedListFileInput)

	$seedListFileBrowseButton = GUICtrlCreateButton("Browse...", 405, 69, 70, 22)
	_ArrayAdd($optionsTabControlsArray, $seedListFileBrowseButton)

	$seedOffsetLabel = GUICtrlCreateLabel("Seed offset:", 35, 97)
	GUICtrlSetBkColor($seedOffsetLabel, $GUI_BKCOLOR_TRANSPARENT)
	_ArrayAdd($optionsTabControlsArray, $seedOffsetLabel)

	$seedOffsetInput = GUICtrlCreateInput($seedOffset, 100, 95, 80, 20)
	_ArrayAdd($optionsTabControlsArray, $seedOffsetInput)

	$seedListInfoLabel = GUICtrlCreateLabel($seedFileInfo, 275, 97, 200, 30, $SS_RIGHT)
	GUICtrlSetBkColor($seedListInfoLabel, $GUI_BKCOLOR_TRANSPARENT)
	_ArrayAdd($optionsTabControlsArray, $seedListInfoLabel)

	$searchOptionsGroup = GUICtrlCreateGroup("Search Options", 13, 125, 472, 140)
	GUICtrlSetBkColor($searchOptionsGroup, $COLOR_WHITE) ;$GUI_BKCOLOR_TRANSPARENT)
	_ArrayAdd($optionsTabControlsArray, $searchOptionsGroup)

	$searchForBiomeChkbx = GUICtrlCreateCheckbox("Search for biomes", 20, 145)
	GUICtrlSetBkColor($searchForBiomeChkbx, $COLOR_WHITE) ;$GUI_BKCOLOR_TRANSPARENT)
	If $searchForBiomes = 1 Then GUICtrlSetState($searchForBiomeChkbx, $GUI_CHECKED)
	_ArrayAdd($optionsTabControlsArray, $searchForBiomeChkbx)

	#cs
	$enableBiomeGroupsChkbx = GUICtrlCreateCheckbox("Enable biome groups", 20, 169)
	GUICtrlSetBkColor($enableBiomeGroupsChkbx, $COLOR_WHITE) ;$GUI_BKCOLOR_TRANSPARENT)
	If $enableBiomeGroups = 1 Then GUICtrlSetState($enableBiomeGroupsChkbx, $GUI_CHECKED)
	_ArrayAdd($optionsTabControlsArray, $enableBiomeGroupsChkbx)
	#ce
	
	$searchForStructChkbx = GUICtrlCreateCheckbox("Search for structures", 20, 193)
	GUICtrlSetBkColor($searchForStructChkbx, $COLOR_WHITE) ;$GUI_BKCOLOR_TRANSPARENT)
	If $searchForStructures = 1 Then GUICtrlSetState($searchForStructChkbx, $GUI_CHECKED)
	_ArrayAdd($optionsTabControlsArray, $searchForStructChkbx)

	$saveResultsToFileChkbx = GUICtrlCreateCheckbox("Save search results to file", 20, 217)
	GUICtrlSetBkColor($saveResultsToFileChkbx, $COLOR_WHITE) ;$GUI_BKCOLOR_TRANSPARENT)
	If $saveSearchResultsToFile = 1 Then GUICtrlSetState($saveResultsToFileChkbx, $GUI_CHECKED)
	_ArrayAdd($optionsTabControlsArray, $saveResultsToFileChkbx)

	$includeRejectedSeedsChkbx = GUICtrlCreateCheckbox("Include rejected seeds in search results", 275, 193)
	GUICtrlSetBkColor($includeRejectedSeedsChkbx, $COLOR_WHITE) ;$GUI_BKCOLOR_TRANSPARENT)
	If $includeRejectedSeeds = 1 Then GUICtrlSetState($includeRejectedSeedsChkbx, $GUI_CHECKED)
	_ArrayAdd($optionsTabControlsArray, $includeRejectedSeedsChkbx)

	$resultsOutputFileLabel = GUICtrlCreateLabel("Search results output file:", 35, 242)
	GUICtrlSetBkColor($resultsOutputFileLabel, $GUI_BKCOLOR_TRANSPARENT)
	_ArrayAdd($optionsTabControlsArray, $resultsOutputFileLabel)

	$resultsOutputFileInput = GUICtrlCreateInput($resultsFile, 160, 238, 245, 20)
	_ArrayAdd($optionsTabControlsArray, $resultsOutputFileInput)

	$resultsOutputFileBrowseButton = GUICtrlCreateButton("Browse...", 405, 237, 70, 22)
	_ArrayAdd($optionsTabControlsArray, $resultsOutputFileBrowseButton)

	$maxSeedsLabel = GUICtrlCreateLabel("Max. seeds to evaluate:", 275, 150)
	GUICtrlSetBkColor($maxSeedsLabel, $GUI_BKCOLOR_TRANSPARENT)
	_ArrayAdd($optionsTabControlsArray, $maxSeedsLabel)

	$maxSeedsInput = GUICtrlCreateInput($maxSeedsToEvaluate, 395, 147, 80, 20)
	_ArrayAdd($optionsTabControlsArray, $maxSeedsInput)

	$numSeedsToEvaluateLabel = GUICtrlCreateLabel("Matching seeds to find:", 275, 174)
	GUICtrlSetBkColor($numSeedsToEvaluateLabel, $GUI_BKCOLOR_TRANSPARENT)
	_ArrayAdd($optionsTabControlsArray, $numSeedsToEvaluateLabel)

	$numSeedsToEvaluateInput = GUICtrlCreateInput($seedsToFind, 395, 171, 80, 20)
	_ArrayAdd($optionsTabControlsArray, $numSeedsToEvaluateInput)

	$overwriteOutputFileChkbx = GUICtrlCreateCheckbox("Overwrite results file each run", 275, 217)
	GUICtrlSetBkColor($overwriteOutputFileChkbx, $COLOR_WHITE) ;$GUI_BKCOLOR_TRANSPARENT)
	If $overwriteResults = 1 Then GUICtrlSetState($overwriteOutputFileChkbx, $GUI_CHECKED)
	_ArrayAdd($optionsTabControlsArray, $overwriteOutputFileChkbx)

	$otherOptionsGroup = GUICtrlCreateGroup("Other Options", 13, 268, 472, 155)
	GUICtrlSetBkColor($otherOptionsGroup, $COLOR_WHITE) ;$GUI_BKCOLOR_TRANSPARENT)
	_ArrayAdd($optionsTabControlsArray, $otherOptionsGroup)

	$guidedAmidstSetupChkbx = GUICtrlCreateCheckbox("Guided Amidst setup", 20, 288)
	GUICtrlSetBkColor($guidedAmidstSetupChkbx, $COLOR_WHITE) ;$GUI_BKCOLOR_TRANSPARENT)
	If $guidedAmidstSetup = 1 Then GUICtrlSetState($guidedAmidstSetupChkbx, $GUI_CHECKED)
	_ArrayAdd($optionsTabControlsArray, $guidedAmidstSetupChkbx)

	#cs
	$saveScreenshotChkbx = GUICtrlCreateCheckbox("Save screenshot of matching seed maps", 20, 312)
	GUICtrlSetBkColor($saveScreenshotChkbx, $COLOR_WHITE) ;$GUI_BKCOLOR_TRANSPARENT)
	If $saveScreenshots = 1 Then GUICtrlSetState($saveScreenshotChkbx, $GUI_CHECKED)
	_ArrayAdd($optionsTabControlsArray, $saveScreenshotChkbx)

	$rememberAmidstWinSizeChkbx = GUICtrlCreateCheckbox("Remember Amidst window size", 20, 336)
	GUICtrlSetBkColor($rememberAmidstWinSizeChkbx, $COLOR_WHITE) ;$GUI_BKCOLOR_TRANSPARENT)
	If $rememberAmidstWindowSize = 1 Then GUICtrlSetState($rememberAmidstWinSizeChkbx, $GUI_CHECKED)
	_ArrayAdd($optionsTabControlsArray, $rememberAmidstWinSizeChkbx)

	$macLinuxCompatChkbx = GUICtrlCreateCheckbox("Mac/Linux Compatibility (Wine) EXPERIMENTAL", 20, 360)
	GUICtrlSetBkColor($macLinuxCompatChkbx, $COLOR_WHITE) ;$GUI_BKCOLOR_TRANSPARENT)
	If $macLinuxCompatibility = 1 Then GUICtrlSetState($macLinuxCompatChkbx, $GUI_CHECKED)
	_ArrayAdd($optionsTabControlsArray, $macLinuxCompatChkbx)
	#ce
	
	$showProgressPopupChkbx = GUICtrlCreateCheckbox("Show progress popup window", 275, 288)
	GUICtrlSetBkColor($showProgressPopupChkbx, $COLOR_WHITE) ;$GUI_BKCOLOR_TRANSPARENT)
	If $showProgressPopupWindow = 1 Then GUICtrlSetState($showProgressPopupChkbx, $GUI_CHECKED)
	_ArrayAdd($optionsTabControlsArray, $showProgressPopupChkbx)

	$showResultsTabChkbx = GUICtrlCreateCheckbox("Show search results tab", 275, 312)
	GUICtrlSetBkColor($showResultsTabChkbx, $COLOR_WHITE) ;$GUI_BKCOLOR_TRANSPARENT)
	If $showResultsTab = 1 Then GUICtrlSetState($showResultsTabChkbx, $GUI_CHECKED)
	_ArrayAdd($optionsTabControlsArray, $showResultsTabChkbx)

	$enableDebugChkbx = GUICtrlCreateCheckbox("Enable debugging output", 275, 336)
	GUICtrlSetBkColor($enableDebugChkbx, $COLOR_WHITE) ;$GUI_BKCOLOR_TRANSPARENT)
	If $enableDebugging = 1 Then GUICtrlSetState($enableDebugChkbx, $GUI_CHECKED)
	_ArrayAdd($optionsTabControlsArray, $enableDebugChkbx)

	$restoreHiddenDialogsButton = GUICtrlCreateButton("Restore Hidden Dialogs", 13, 430, 125, 25)
	_ArrayAdd($optionsTabControlsArray, $restoreHiddenDialogsButton)

	$reloadSettingsINIButton = GUICtrlCreateButton("Reload Settings.ini", 141, 430, 113, 25)
	_ArrayAdd($optionsTabControlsArray, $reloadSettingsINIButton)

	$resetAllOptionsButton = GUICtrlCreateButton("Reset All Options", 257, 430, 113, 25)
	_ArrayAdd($optionsTabControlsArray, $resetAllOptionsButton)

	$removePresetButton = GUICtrlCreateButton("Remove Preset...", 373, 430, 113, 25)
	_ArrayAdd($optionsTabControlsArray, $removePresetButton)

	DoHideOptionsTab()
EndFunc

Func DoBuildResultsTab()
	Dim $index

	; Position the results tab relative to the options tab
	$index = _GUICtrlTab_FindTab($tabSet, "Options") + 1

	$resultsTab = _GUICtrlTab_InsertItem($tabSet, $index, "Search Results")

	$resultsEdit = _GUICtrlEdit_Create($tabSet, "", 2, 22, 484, 397, BitOR($WS_VSCROLL, $ES_MULTILINE))
	_ArrayAdd($resultsTabControlsArray, $resultsEdit)

	$clearResultsButton = GUICtrlCreateButton("Clear Search Results", 59, 428, 120, 25)
	_ArrayAdd($resultsTabControlsArray, $clearResultsButton)

	$copyResultsButton = GUICtrlCreateButton("Copy to Clipboard", 190, 428, 120, 25)
	_ArrayAdd($resultsTabControlsArray, $copyResultsButton)

	$saveResultsButton = GUICtrlCreateButton("Save to File...", 320, 428, 120, 25)
	_ArrayAdd($resultsTabControlsArray, $saveResultsButton)

	DoHideResultsTab()
EndFunc

Func DoBuildDebugTab()
	Dim $index

	; Position the debug tab relative to the options tab
	$index = _GUICtrlTab_FindTab($tabSet, "Options") + 2

	$debugTab = _GUICtrlTab_InsertItem($tabSet, 4, "Debug")

	$debugEdit = _GUICtrlEdit_Create($tabSet, "", 2, 22, 484, 397, BitOR($WS_VSCROLL, $ES_MULTILINE))
	_ArrayAdd($debugTabControlsArray, $debugEdit)

	$clearDebugButton = GUICtrlCreateButton("Clear Debug Data", 59, 428, 120, 25)
	_ArrayAdd($debugTabControlsArray, $clearDebugButton)

	$copyDebugButton = GUICtrlCreateButton("Copy to Clipboard", 190, 428, 120, 25)
	_ArrayAdd($debugTabControlsArray, $copyDebugButton)

	$saveDebugButton = GUICtrlCreateButton("Save to File...", 320, 428, 120, 25)
	_ArrayAdd($debugTabControlsArray, $saveDebugButton)

	DoHideDebugTab()
EndFunc

Func DoBuildRemovePresetsGUI()
	Dim $count, $temp

	DebugWrite("Building remove presets GUI")

	$removePresetsForm = GUICreate("Remove Presets", 300, 195, -1, -1, BitOr($WS_POPUP, $WS_CAPTION, $WS_SYSMENU), -1, $form)

	GUICtrlCreateLabel("Select the presets you would like to remove and click OK.", 5, 10, 290, 30, $SS_CENTER)

	GUICtrlCreateGroup("Biome Presets", 5, 40, 142, 120)
		$preset0Chkbx = GUICtrlCreateCheckbox($presetArray[1][1] <> "" ? $presetArray[1][1] : "[EMPTY]", 10, 55)
		$preset1Chkbx = GUICtrlCreateCheckbox($presetArray[4][1] <> "" ? $presetArray[4][1] : "[EMPTY]", 10, 75)
		$preset2Chkbx = GUICtrlCreateCheckbox($presetArray[7][1] <> "" ? $presetArray[7][1] : "[EMPTY]", 10, 95)
		$preset3Chkbx = GUICtrlCreateCheckbox($presetArray[10][1] <> "" ? $presetArray[10][1] : "[EMPTY]", 10, 115)
		$preset4Chkbx = GUICtrlCreateCheckbox($presetArray[13][1] <> "" ? $presetArray[13][1] : "[EMPTY]", 10, 135)

	GUICtrlCreateGroup("Structure Presets", 153, 40, 142, 120)
		$preset5Chkbx = GUICtrlCreateCheckbox($presetArray[16][1] <> "" ? $presetArray[16][1] : "[EMPTY]", 158, 55)
		$preset6Chkbx = GUICtrlCreateCheckbox($presetArray[19][1] <> "" ? $presetArray[19][1] : "[EMPTY]", 158, 75)
		$preset7Chkbx = GUICtrlCreateCheckbox($presetArray[22][1] <> "" ? $presetArray[22][1] : "[EMPTY]", 158, 95)
		$preset8Chkbx = GUICtrlCreateCheckbox($presetArray[25][1] <> "" ? $presetArray[25][1] : "[EMPTY]", 158, 115)
		$preset9Chkbx = GUICtrlCreateCheckbox($presetArray[28][1] <> "" ? $presetArray[28][1] : "[EMPTY]", 158, 135)

	$cancelButton = GUICtrlCreateButton("Cancel", 5, 165, 90, 25)

	$okButton = GUICtrlCreateButton("OK", 205, 165, 90, 25)

	GUISetState(@SW_HIDE)
EndFunc
#EndRegion

#Region Show/Hide Tab Functions
Func DoShowBiomesTab()
	For $i = 0 To UBound($biomeTabControlsArray) - 1
		ControlShow($tabSet, "", $biomeTabControlsArray[$i])
		GUICtrlSetState($biomeTabControlsArray[$i], $GUI_SHOW)
	Next
	
	If $enableBiomeGroups = 0 Then
		GUICtrlSetState($includedBiomeGroupButton, $GUI_HIDE)
		GUICtrlSetState($excludedBiomeGroupButton, $GUI_HIDE)
	EndIf
EndFunc

Func DoHideBiomesTab()
	For $i = 0 To UBound($biomeTabControlsArray) - 1
		ControlHide($tabSet, "", $biomeTabControlsArray[$i])
		GUICtrlSetState($biomeTabControlsArray[$i], $GUI_HIDE)
	Next
EndFunc

Func DoShowStructuresTab()
	For $i = 0 To UBound($structTabControlsArray) - 1
		ControlShow($tabSet, "", $structTabControlsArray[$i])
		GUICtrlSetState($structTabControlsArray[$i], $GUI_SHOW)
	Next
EndFunc

Func DoHideStructuresTab()
	For $i = 0 To UBound($structTabControlsArray) - 1
		ControlHide($tabSet, "", $structTabControlsArray[$i])
		GUICtrlSetState($structTabControlsArray[$i], $GUI_HIDE)
	Next
EndFunc

Func DoShowOptionsTab()
	For $i = 0 to UBound($optionsTabControlsArray) - 1
		ControlShow($tabSet, "", $optionsTabControlsArray[$i])
		GUICtrlSetState($optionsTabControlsArray[$i], $GUI_SHOW)
	Next
EndFunc

Func DoHideOptionsTab()
	For $i = 0 to UBound($optionsTabControlsArray) - 1
		ControlHide($tabSet, "", $optionsTabControlsArray[$i])
		GUICtrlSetState($optionsTabControlsArray[$i], $GUI_HIDE)
	Next
EndFunc

Func DoShowResultsTab()
	For $i = 0 to UBound($resultsTabControlsArray) - 1
		ControlShow($tabSet, "", $resultsTabControlsArray[$i])
		GUICtrlSetState($resultsTabControlsArray[$i], $GUI_SHOW)
	Next
EndFunc

Func DoHideResultsTab()
	For $i = 0 to UBound($resultsTabControlsArray) - 1
		ControlHide($tabSet, "", $resultsTabControlsArray[$i])
		GUICtrlSetState($resultsTabControlsArray[$i], $GUI_HIDE)
	Next
EndFunc

Func DoShowDebugTab()
	For $i = 0 to UBound($debugTabControlsArray) - 1
		ControlShow($tabSet, "", $debugTabControlsArray[$i])
		GUICtrlSetState($debugTabControlsArray[$i], $GUI_SHOW)
	Next
EndFunc

Func DoHideDebugTab()
	For $i = 0 to UBound($debugTabControlsArray) - 1
		ControlHide($tabSet, "", $debugTabControlsArray[$i])
		GUICtrlSetState($debugTabControlsArray[$i], $GUI_HIDE)
	Next
EndFunc
#EndRegion

#Region GUI Manipulation Functions
#cs
Func WM_COMMAND($hWnd, $iMsg, $wParam, $lParam)
    #forceref $hWnd, $iMsg
    Local $nNotifyCode = BitShift($wParam, 16)
    Local $nID = BitAND($wParam, 0x0000FFFF)
    Local $hCtrl = $lParam
    Local $sText = ""

	Switch $hCtrl
        Case $g_idBtn, $g_idBtn2
            Switch $nNotifyCode
                Case $BN_CLICKED
                    $sText = "$BN_CLICKED" & @CRLF
                Case $BN_PAINT
                    $sText = "$BN_PAINT" & @CRLF
                Case $BN_PUSHED, $BN_HILITE
                    $sText = "$BN_PUSHED, $BN_HILITE" & @CRLF
                Case $BN_UNPUSHED, $BN_UNHILITE
                    $sText = "$BN_UNPUSHED" & @CRLF
                Case $BN_DISABLE
                    $sText = "$BN_DISABLE" & @CRLF
                Case $BN_DBLCLK, $BN_DOUBLECLICKED
                    $sText = "$BN_DBLCLK, $BN_DOUBLECLICKED" & @CRLF
                Case $BN_SETFOCUS
                    $sText = "$BN_SETFOCUS" & @CRLF
                Case $BN_KILLFOCUS
                    $sText = "$BN_KILLFOCUS" & @CRLF
            EndSwitch
            Return 0 ; Only workout clicking on the button
    EndSwitch
    ; Proceed the default AutoIt3 internal message commands.
    ; You also can complete let the line out.
    ; !!! But only 'Return' (without any value) will not proceed
    ; the default AutoIt3-message in the future !!!
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
    #forceref $hWnd, $iMsg, $wParam
    Local Const $BCN_HOTITEMCHANGE = -1249
    Local $tNMBHOTITEM = DllStructCreate("hwnd hWndFrom;int IDFrom;int Code;dword dwFlags", $lParam)
    Local $nNotifyCode = DllStructGetData($tNMBHOTITEM, "Code")
    Local $nID = DllStructGetData($tNMBHOTITEM, "IDFrom")
    Local $hCtrl = DllStructGetData($tNMBHOTITEM, "hWndFrom")
    Local $iFlags = DllStructGetData($tNMBHOTITEM, "dwFlags")
    Local $sText = ""
	
	DoBiomeGroupPopupMenu($hCtrl)
	
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func DoBiomeGroupPopupMenu($hCtrl)
	Local $hMenu
    Local Enum $e_idOpen = 1000, $e_idSave, $e_idInfo
    $hMenu = _GUICtrlMenu_CreatePopup()
    _GUICtrlMenu_InsertMenuItem($hMenu, 0, "Open", $e_idOpen)
    _GUICtrlMenu_InsertMenuItem($hMenu, 1, "Save", $e_idSave)
    _GUICtrlMenu_InsertMenuItem($hMenu, 3, "", 0)
    _GUICtrlMenu_InsertMenuItem($hMenu, 3, "Info", $e_idInfo)
    Switch _GUICtrlMenu_TrackPopupMenu($hMenu, $hCtrl, -1, -1, 1, 1, 2)
        Case $e_idOpen
            MemoWrite("Open - Selected")
        Case $e_idSave
            MemoWrite("Save - Selected")
        Case $e_idInfo
            MemoWrite("Info - Selected")
    EndSwitch
    _GUICtrlMenu_DestroyMenu($hMenu)
EndFunc

Func DoUpdateBiomeGroup($list)
	
EndFunc

Func DoRightClickAction()
	Dim $cursorInfo = GUIGetCursorInfo($form)
	Dim $controlUnderMouse = $cursorInfo[4]
	
	;MsgBox(0,"Right click", "You clicked " & $controlUnderMouse)
EndFunc
#ce

Func DoSelectAllListItems($list)
	DebugWrite("Selecting all items in list " & $list)
	Dim $numItems = _GUICtrlListBox_GetListBoxInfo($list)
	_GUICtrlListBox_SelItemRange($list, 0, $numItems - 1)
EndFunc

Func DoMoveListItems($fromList, $toList)
	DebugWrite("Moving items from list " & $fromList & " to list " & $toList)
	Dim $selected, $selectedIndices

	If _GUICtrlListBox_GetSelCount($fromList) <= 0 Then
		DebugWrite("Nothing selected. Aborting move.")
	Else
		$selected = _GUICtrlListBox_GetSelItemsText($fromList)
		$selectedIndices = _GUICtrlListBox_GetSelItems($fromList)
		For $i = 1 To UBound($selected) - 1
			_GUICtrlListBox_AddString($toList, $selected[$i])
			DebugWrite($selected[$i] & " moved to list " & $toList)
		Next
		For $i = UBound($selectedIndices) - 1 To 1 Step -1 ; Removing items works better backward
			_GUICtrlListBox_DeleteString($fromList, $selectedIndices[$i])
			DebugWrite("Item at index " & $selectedIndices[$i] & " removed from list " & $fromList)
		Next
		DebugWrite("Move complete")
	EndIf
EndFunc

Func DoGetSeedListFile()
	$seedListFile = FileOpenDialog("Choose seed list file", @ScriptDir, "Text Files (*.*)", BitOR($FD_FILEMUSTEXIST, $FD_PATHMUSTEXIST))
	IniWrite($settingsINIFile, "Options", "SeedListFile", $seedListFile)
	$seedFileInfo = "Seed file contains " & StringRegExpReplace(String(_FileCountLines($seedListFile)), '(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))', '\1,') & " seeds."
	IniWrite($settingsINIFile, "Options", "SeedFileInfo", $seedFileInfo)
	UpdateGlobals()
	GUICtrlSetData($seedListFileInput, $seedListFile)
	DebugWrite("SeedListFile set to '" & $seedListFile & "'")
	GUICtrlSetData($seedListInfoLabel, $seedFileInfo)
	DebugWrite("SeedListInfo set to '" & $seedFileInfo & "'")
EndFunc

Func DoGetResultsOutputFile()
	$resultsFile = FileOpenDialog("Choose search results output file", @ScriptDir, "Text Files (*.*)", BitOR($FD_PATHMUSTEXIST, $FD_PROMPTCREATENEW))
	IniWrite($settingsINIFile, "Options", "ResultsFile", $resultsFile)
	UpdateGlobals()
	GUICtrlSetData($resultsOutputFileInput, $resultsFile)
	DebugWrite("ResultsFile set to '" & $resultsFile & "'")
EndFunc

#cs
Func DoAddBiomeGroupsToList()
	For $i = 1 to UBound($biomeGroupArray) - 1
		; Make sure the string doesn't exist before adding it
		If _GUICtrlListBox_FindString($availableBiomeList, $biomeGroupArray[$i][0]) = -1 Then
			_GUICtrlListBox_AddString($availableBiomeList, $biomeGroupArray[$i][0])
		EndIf
	Next
EndFunc

Func DoRemoveBiomeGroupsFromList()
	For $i = 1 to UBound($biomeGroupArray) - 1
		_GUICtrlListBox_DeleteString($availableBiomeList, $biomeGroupArray[$i][0])
	Next
EndFunc
#ce

Func DoRestoreHiddenDialogs()
	Dim $response

	$response = MsgBox(BitOR($MB_YESNO, $MB_ICONWARNING), "Are you sure?", "This action will restore all messages that you have previously hidden." & @CRLF & @CRLF & "Are you sure?")

	If $response = $IDYES Then
		; Preset warning dialog box
		RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\DontShowMeThisDialogAgain", "{5BB57EAD-D839-4605-8B91-523203CE3935}")
		; False postivies/negatives warning dialog box
		RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\DontShowMeThisDialogAgain", "{3AC815B9-2394-4E3C-92CA-E51BCBDEDE16}")
		; Begin search info dialog box
		RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\DontShowMeThisDialogAgain", "{2D6A1CA1-EE2B-4AD2-9FB8-60052F49C56B}")
		; Reset preset button dialog box
		RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\DontShowMeThisDialogAgain", "{E0E777CD-DA7B-40E0-9ECC-9ADD4F2BE0E9}")

		If @error = 0 Then
			MsgBox(BitOR($MB_OK, $MB_ICONINFORMATION), "Hidden messages restored", "All hidden messages have been restored.")
		EndIf
	EndIf
EndFunc

Func DoUpdateOptionsTabFromINIFile()
	UpdateGlobals()

	If $useRandomSeeds = 0 Then
		GUICtrlSetState($useRandomSeedsRadio, $GUI_UNCHECKED)
		GUICtrlSetState($useSeedListFileRadio, $GUI_CHECKED)
	Else
		GUICtrlSetState($useRandomSeedsRadio, $GUI_CHECKED)
		GUICtrlSetState($useSeedListFileRadio, $GUI_UNCHECKED)
	EndIf

	GUICtrlSetData($seedListFileInput, $seedListFile)

	GUICtrlSetData($seedListFileLabel, $seedFileInfo)

	GUICtrlSetData($seedOffsetInput, $seedOffset)

	If $searchForBiomes = 0 Then
		GUICtrlSetState($searchForBiomeChkbx, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($searchForBiomeChkbx, $GUI_CHECKED)
	EndIf

	If $enableBiomeGroups = 0 Then
		GUICtrlSetState($enableBiomeGroupsChkbx, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($enableBiomeGroupsChkbx, $GUI_CHECKED)
	EndIf

	If $searchForStructures = 0 Then
		GUICtrlSetState($searchForStructChkbx, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($searchForStructChkbx, $GUI_CHECKED)
	EndIf

	If $saveSearchResultsToFile = 0 Then
		GUICtrlSetState($saveResultsToFileChkbx, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($saveResultsToFileChkbx, $GUI_CHECKED)
	EndIf

	If $includeRejectedSeeds = 0 Then
		GUICtrlSetState($includeRejectedSeedsChkbx, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($includeRejectedSeedsChkbx, $GUI_CHECKED)
	EndIf

	GUICtrlSetData($resultsOutputFileInput, $resultsFile)

	GUICtrlSetData($maxSeedsInput, $maxSeedsToEvaluate)

	GUICtrlSetData($numSeedsToEvaluateInput, $seedsToFind)

	If $overwriteResults = 0 Then
		GUICtrlSetState($overwriteOutputFileChkbx, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($overwriteOutputFileChkbx, $GUI_CHECKED)
	EndIf

	If $guidedAmidstSetup = 0 Then
		GUICtrlSetState($guidedAmidstSetupChkbx, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($guidedAmidstSetupChkbx, $GUI_CHECKED)
	EndIf

	If $saveScreenshots = 0 Then
		GUICtrlSetState($saveScreenshotChkbx, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($saveScreenshotChkbx, $GUI_CHECKED)
	EndIf

	If $rememberAmidstWindowSize = 0 Then
		GUICtrlSetState($rememberAmidstWinSizeChkbx, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($rememberAmidstWinSizeChkbx, $GUI_CHECKED)
	EndIf

	If $macLinuxCompatibility = 0 Then
		GUICtrlSetState($macLinuxCompatChkbx, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($macLinuxCompatChkbx, $GUI_CHECKED)
	EndIf

	If $showProgressPopupWindow = 0 Then
		GUICtrlSetState($showProgressPopupChkbx, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($showProgressPopupChkbx, $GUI_CHECKED)
	EndIf

	If $showResultsTab = 0 Then
		GUICtrlSetState($showResultsTabChkbx, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($showResultsTabChkbx, $GUI_CHECKED)
	EndIf

	If $enableDebugging = 0 Then
		GUICtrlSetState($enableDebugChkbx, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($enableDebugChkbx, $GUI_CHECKED)
	EndIf
EndFunc

Func DoResetINIFileToDefaults($prompt = True)
	Dim $response

	If $prompt Then
		$response = MsgBox(BitOR($MB_YESNO, $MB_ICONWARNING), "Are you sure?", "This action will reset all options (except presets) to their defaults. This cannot be undone." & @CRLF & @CRLF & "Are you sure?")
	EndIf

	If $response = $IDYES Or $prompt = False Then
		IniWrite($settingsINIFile, "Options", "UseRandomSeeds", 1)
		IniWrite($settingsINIFile, "Options", "SeedListFile", "")
		IniWrite($settingsINIFile, "Options", "SeedOffset", 0)
		IniWrite($settingsINIFile, "Options", "SeedFileInfo", "")
		IniWrite($settingsINIFile, "Options", "SearchForBiomes", 1)
		IniWrite($settingsINIFile, "Options", "EnableBiomeGroups", 0)
		IniWrite($settingsINIFile, "Options", "SaveSearchResultsToFile", 0)
		IniWrite($settingsINIFile, "Options", "SearchForStructures", 0)
		IniWrite($settingsINIFile, "Options", "IncludeRejectedSeeds", 0)
		IniWrite($settingsINIFile, "Options", "MaxSeedsToEvaluate", 100)
		IniWrite($settingsINIFile, "Options", "SeedsToFind", 1)
		IniWrite($settingsINIFile, "Options", "ResultsFile", "")
		IniWrite($settingsINIFile, "Options", "OverwriteResults", 0)
		IniWrite($settingsINIFile, "Options", "GuidedAmidstSetup", 1)
		IniWrite($settingsINIFile, "Options", "SaveScreenshots", 0)
		IniWrite($settingsINIFile, "Options", "RememberAmidstWindowSize", 0)
		IniWrite($settingsINIFile, "Options", "ShowProgressPopupWindow", 1)
		IniWrite($settingsINIFile, "Options", "MacLinuxCompatibility", 0)
		IniWrite($settingsINIFile, "Options", "ShowResultsTab", 0)
		IniWrite($settingsINIFile, "Options", "EnableDebugging", 0)
	EndIf
EndFunc

Func DoClearResultsEdit($prompt = True)
	Dim $response

	If $prompt Then
		$response = MsgBox(BitOR($MB_YESNO, $MB_ICONQUESTION), "Clear Search Results?", "This action will clear all search results from this window. This cannot be undone." & @CRLF & @CRLF & "Are you sure?")
	Else
		$response = $IDYES
	EndIf

	If $response = $IDYES Then
		DebugWrite("Clearing search results edit")
		_GUICtrlEdit_SetText($resultsEdit, "")
	Else
		DebugWrite("Clearing search results canceled")
		Return
	EndIf
EndFunc

Func DoCopyResultsToClipboard()
	Dim $text = _GUICtrlEdit_GetText($resultsEdit)

	If _ClipBoard_SetData($text, $CF_TEXT) = 0 Then
		MsgBox(BitOR($MB_OK, $MB_ICONERROR), "Error", "An error was encountered while attempting to copy to clipboard. Please try again.")
		DebugWrite("Error copying to clipboard")
	Else
		MsgBox(BitOR($MB_OK, $MB_ICONINFORMATION), "Success!", "Search results successfully copied to clipboard!")
		DebugWrite("Copied to clipboard")
	EndIf
EndFunc

Func DoSaveResultsToFile()
	Dim $text, $file, $handle

	$text = _GUICtrlEdit_GetText($resultsEdit)

	$file = FileSaveDialog("Save search results to file", @ScriptDir, "Text Files (*.*)", BitOR($FD_PATHMUSTEXIST, $FD_PROMPTOVERWRITE))
	DebugWrite("Results file to save to: " & $file)

	$handle = FileOpen($file, $FO_OVERWRITE)
	If FileWrite($handle, $text) = 0 Then
		MsgBox(BitOR($MB_OK, $MB_ICONERROR), "Error", "An error was encountered while attempting to save search results. Please try again.")
		DebugWrite("File error. Search results not saved")
	Else
		MsgBox(BitOR($MB_OK, $MB_ICONINFORMATION), "Success!", "Search results successfully saved to " & $file)
		DebugWrite("Results written to file")
	EndIf
	FileClose($handle)
EndFunc

Func DoClearDebugEdit()
	Dim $response

	$response = MsgBox(BitOR($MB_YESNO, $MB_ICONQUESTION), "Clear debug data?", "This action will clear all debug data from this window. This cannot be undone." & @CRLF & @CRLF & "Are you sure?")

	If $response = $IDYES Then
		DebugWrite("Clearing debug edit")
		_GUICtrlEdit_SetText($debugEdit, "")
	Else
		DebugWrite("Clearing debug edit canceled")
		Return
	EndIf
EndFunc

Func DoCopyDebugToClipboard()
	Dim $text = _GUICtrlEdit_GetText($debugEdit)

	If _ClipBoard_SetData($text, $CF_TEXT) = 0 Then
		MsgBox(BitOR($MB_OK, $MB_ICONERROR), "Error", "An error was encountered while attempting to copy to clipboard. Please try again.")
		DebugWrite("Error copying to clipboard")
	Else
		MsgBox(BitOR($MB_OK, $MB_ICONINFORMATION), "Success!", "Debug data successfully copied to clipboard!")
		DebugWrite("Copied to clipboard")
	EndIf
EndFunc

Func DoSaveDebugToFile()
	Dim $text, $file, $handle

	$text = _GUICtrlEdit_GetText($debugEdit)

	$file = FileSaveDialog("Save debug data to file", @ScriptDir, "Text Files (*.*)", BitOR($FD_PATHMUSTEXIST, $FD_PROMPTOVERWRITE))
	DebugWrite("Debug file to save to: " & $file)

	$handle = FileOpen($file, $FO_OVERWRITE)
	If FileWrite($handle, $text) = 0 Then
		MsgBox(BitOR($MB_OK, $MB_ICONERROR), "Error", "An error was encountered while attempting to save debug data. Please try again.")
		DebugWrite("File error. Debug data not saved")
	Else
		MsgBox(BitOR($MB_OK, $MB_ICONINFORMATION), "Success!", "Debug data successfully saved to " & $file)
		DebugWrite("Debug data written to file")
	EndIf
	FileClose($handle)
EndFunc
#EndRegion

