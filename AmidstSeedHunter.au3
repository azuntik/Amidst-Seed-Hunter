; =============================================================================
; Amidst Seed Hunter (AmidstSeedHunter.au3)
;
; Author: 	Azuntik (seedhunter@azuntik.com)
; Date:		2017.4.14
; Download: https://github.com/azuntik/Amidst-Seed-Hunter/releases
; License:	CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
;
; For use with Amidst v4.2 (https://github.com/toolbox4minecraft/amidst).
; =============================================================================

AutoItSetOption("MustDeclareVars", 1)
HotKeySet("{ESC}","StopExecution") ; For early termination of the search loop

#include <Array.au3>
#include <Clipboard.au3>
#include <ColorConstants.au3>
#include <Date.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <FontConstants.au3>
#include <GuiButton.au3>
#include <GuiConstantsEx.au3>
#include <GuiEdit.au3>
#include <GuiListBox.au3>
#include <GuiTab.au3>
#include <StaticConstants.au3>
#include <String.au3>
#include <WinAPIDlg.au3>
#include <WindowsConstants.au3>
#include "Toast.au3"
#include "GuiFunctions.au3"

#Region Globals
Global $debugBuffer, $searchResults, $newSearch

; GUI control globals
Global $form, $tabSet, $biomesTab, $structuresTab, $optionsTab, $resultsTab, $debugTab
Global $cancelQuitButton, $beginSearchButton, $currentTab, $previousTab

Global $availableBiomeList, $includedBiomeList, $excludedBiomeList
Global $availableBiomeLabel, $includedBiomeLabel, $excludedBiomeLabel
Global $includeBiomeButton, $removeIncludedBiomeButton, $removeAllIncludedBiomeButton
Global $excludeBiomeButton, $removeExcludedBiomeButton, $removeAllExcludedBiomeButton
Global $preset0Button, $preset1Button, $preset2Button, $preset3Button, $preset4Button

Global $availableStructList, $includedStructList, $excludedStructList
Global $availableStructLabel, $includedStructLabel, $excludedStructLabel
Global $includeStructButton, $removeIncludedStructButton, $removeAllIncludedStructButton
Global $excludeStructButton, $removeExcludedStructButton, $removeAllExcludedStructButton
Global $preset5Button, $preset6Button, $preset7Button, $preset8Button, $preset9Button

Global $seedOptionsGroup, $searchOptionsGroup, $otherOptionsGroup
Global $useRandomSeedsRadio, $useSeedListFileRadio, $seedListFileLabel, $seedListFileInput
Global $seedListFileBrowseButton, $seedOffsetLabel, $seedOffsetInput, $seedListInfoLabel
Global $searchForBiomeChkbx, $searchForStructChkbx, $saveResultsToFileChkbx
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
Global $searchForBiomes, $searchForStructures, $saveSearchResultsToFile, $includeRejectedSeeds
Global $maxSeedsToEvaluate, $seedsToFind, $resultsFile, $overwriteResults, $guidedAmidstSetup
Global $saveScreenshots, $rememberAmidstWindowSize, $showProgressPopupWindow, $macLinuxCompatibility
Global $showResultsTab, $enableDebugging
Global $presetArray = []
Global $biomeArray = []
Global $structArray = []

Func UpdateGlobals()
	$settingsINIFile = @ScriptDir & "\Settings.ini"
	
	If FileExists($settingsINIFile) Then	
		$useRandomSeeds = IniRead($settingsINIFile, "Options", "UseRandomSeeds", 1)
		$seedListFile = IniRead($settingsINIFile, "Options", "SeedListFile", "")
		$seedOffset = IniRead($settingsINIFile, "Options", "SeedOffset", 0)
		$seedFileInfo = IniRead($settingsINIFile, "Options", "SeedFileInfo", "")
		$searchForBiomes = IniRead($settingsINIFile, "Options", "SearchForBiomes", 1)
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
		$structArray = IniReadSection($settingsINIFile, "StructureList")
	Else
		DoResetINIFileToDefaults(False) ; Create INI File
		IniWriteSection($settingsINIFile, "Presets", "Preset0Name=" & @LF & "Preset0Include=" & @LF & _
			"Preset0Exclude=" & @LF & "Preset1Name=" & @LF & "Preset1Include=" & @LF & "Preset1Exclude=" & _
			@LF & "Preset2Name=" & @LF & "Preset2Include=" & @LF & "Preset2Exclude=" & @LF & "Preset3Name=" _
			& @LF & "Preset3Include=" & @LF & "Preset3Exclude=" & @LF & "Preset4Name=" & @LF & _
			"Preset4Include=" & @LF & "Preset4Exclude=" & @LF & "Preset5Name=" & @LF & "Preset5Include=" & _
			@LF & "Preset5Exclude=" & @LF & "Preset6Name=" & @LF & "Preset6Include=" & @LF & _
			"Preset6Exclude=" & @LF & "Preset7Name=" & @LF & "Preset7Include=" & @LF & "Preset7Exclude=" & _
			@LF & "Preset8Name=" & @LF & "Preset8Include=" & @LF & "Preset8Exclude=" & @LF & "Preset9Name=" _
			& @LF & "Preset9Include=" & @LF & "Preset9Exclude=")
		IniWriteSection($settingsINIFile, "BiomeList", "Beach=0xFADE55" & @LF & "Beach M=0xFFFF7D" & @LF & _
			"Birch Forest=0x307444" & @LF & "Birch Forest Hills=0x1F5F32" & @LF & _
			"Birch Forest Hills M=0x47875A" & @LF & "Birch Forest M=0x589C6C" & @LF & "Cold Beach=0xFAF0C0" _
			& @LF & "Cold Beach M=0xFFFFE8" & @LF & "Cold Taiga=0x31554A" & @LF & "Cold Taiga Hills=0x243F36" _
			& @LF & "Cold Taiga Hills M=0x4C675E" & @LF & "Cold Taiga M=0x597D72" & @LF & "Deep Ocean=0x000030" _
			& @LF & "Deep Ocean M=0x282858" & @LF & "Desert=0xFA9418" & @LF & "Desert Hills=0xD25F12" & @LF & _
			"Desert Hills M=0xFA873A" & @LF & "Desert M=0xFFBC40" & @LF & "Extreme Hills+=0x507050" & @LF & _
			"Extreme Hills=0x606060" & @LF & "Extreme Hills Edge=0x72789A" & @LF & _
			"Extreme Hills Edge M=0x9AA0C2" & @LF & "Extreme Hills M=0x888888" & @LF & _
			"Extreme Hills+ M=0x789878" & @LF & "Flower Forest=0x2D8E49" & @LF & "Forest=0x056621" & @LF & _
			"Forest Hills=0x22551C" & @LF & "Forest Hills M=0x4A7D44" & @LF & "Frozen Ocean=0x9090A0" & @LF _
			& "Frozen Ocean M=0xB8B8C8" & @LF & "Frozen River=0xA0A0FF" & @LF & "Frozen River M=0xC8C8FF" & _
			@LF & "Ice Mountains=0xA0A0A0" & @LF & "Ice Mountains M=0xC8C8C8" & @LF & "Ice Plains=0xFFFFFF" & _
			@LF & "Ice Plains Spikes=0xB4DCDC" & @LF & "Jungle=0x537B09" & @LF & "Jungle Edge=0x628B17" & @LF _
			& "Jungle Edge M=0x8AB33F" & @LF & "Jungle Hills=0x2C4205" & @LF & "Jungle Hills M=0x546A2D" & @LF _
			& "Jungle M=0x7BA331" & @LF & "Mega Spruce Taiga=0x818E79" & @LF & _
			"Mega Spruce Taiga (Hills)=0x6D7766" & @LF & "Mega Taiga=0x596651" & @LF & _
			"Mega Taiga Hills=0x454F3E" & @LF & "Mesa=0xD94515" & @LF & "Mesa (Bryce)=0xFF6D3D" & @LF & _
			"Mesa Plateau=0xCA8C65" & @LF & "Mesa Plateau F=0xB09765" & @LF & "Mesa Plateau F M=0xD8BF8D" & @LF _
			& "Mesa Plateau M=0xF2B48D" & @LF & "Mushroom Island=0xFF00FF" & @LF & "Mushroom Island M=0xFF28FF" _
			& @LF & "Mushroom Island Shore=0xA000FF" & @LF & "Mushroom Island Shore M=0xC828FF" & @LF & _
			"Ocean=0x000070" & @LF & "Ocean M=0x282898" & @LF & "Plains=0x8DB360" & @LF & "River=0x0000FF" & @LF _
			& "River M=0x2828FF" & @LF & "Roofed Forest=0x40511A" & @LF & "Roofed Forest M=0x687942" & @LF & _
			"Savanna=0xBDB25F" & @LF & "Savanna M=0xE5DA87" & @LF & "Savanna Plateau=0xA79D64" & @LF & _
			"Savanna Plateau M=0xCFC58C" & @LF & "Stone Beach=0xA2A284" & @LF & "Stone Beach M=0xCACAAC" & @LF & _
			"Sunflower Plains=0xB5DB88" & @LF & "Swampland=0x07F9B2" & @LF & "Swampland M=0x2FFFDA" & @LF & _
			"Taiga=0x0B6659" & @LF & "Taiga Hills=0x163933" & @LF & "Taiga Hills M=0x3E615B" & @LF & _
			"Taiga M=0x338E81")
		IniWriteSection($settingsINIFile, "StructureList", "Desert Temple=0xBBB36D" & @LF & "Igloo=0xA7B8FF" & @LF & _
			"Jungle Temple=0x364636" & @LF & "Mineshaft=0x76613C" & @LF & "Nether Fortress=0x311E24" & @LF & _
			"Ocean Monument=0x285A45" & @LF & "Stronghold=0x4D5A35" & @LF & "Village=0x75472F" & @LF & _
			"Witch Hut=0x0F41FB")
		UpdateGlobals()
	EndIf
EndFunc
#EndRegion

#Region Debug Functions
Func DebugWrite($data)
	If $enableDebugging = 1 Then
		Dim $timestampedData = GetTimestamp() & " >> " & $data & @CRLF
		ConsoleWrite($timestampedData & @CRLF)
		If $debugEdit = Null Then ; Debug edit control does not exist
			$debugBuffer = $debugBuffer & $timestampedData
		Else
			_GUICtrlEdit_AppendText($debugEdit, $debugBuffer)
			_GUICtrlEdit_AppendText($debugEdit, $timestampedData)
			
			; Scroll to the bottom of the control
			_GUICtrlEdit_LineScroll($debugEdit, 0, _GUICtrlEdit_GetLineCount($debugEdit))
			
			; Buffer is no longer needed, since control exists
			$debugBuffer = ""
		EndIf
	EndIf
EndFunc

Func GetTimestamp()
	Return _Date_Time_SystemTimeToDateTimeStr(_Date_Time_GetLocalTime())
EndFunc
#EndRegion

#Region Preset Functions
Func DoPresetButton($preset)
	Dim $arrayOffset, $name, $includes, $excludes
	
	$arrayOffset = $preset * 3 + 1 ; Offset to preset name
	$name = $presetArray[$arrayOffset][1]
	$includes = $presetArray[$arrayOffset + 1][1]
	$excludes = $presetArray[$arrayOffset + 2][1]
	
	If $name = "" Then ; Preset not set
		DebugWrite("Preset not set. Creating...")
		DoCreatePreset($preset)
	Else
		DebugWrite("Preset found. Applying...")
		DoApplyPreset($preset)
	EndIf
EndFunc

Func DoCreatePreset($preset)
	Dim $includedList, $excludedList, $numIncluded, $numExcluded
	Dim $response, $name, $selected, $arrayOffset
	Dim $includedItemsString = ""
	Dim $excludedItemsString = ""
	Dim $isUnique = False

	If $preset <= 4 Then ; Biomes tab
		DebugWrite("Creating biome preset")
		$includedList = $includedBiomeList
		$excludedList = $excludedBiomeList
	Else ; Structures tab
		DebugWrite("Creating structure preset")
		$includedList = $includedStructList
		$excludedList = $excludedStructList
	EndIf
	
	$numIncluded = _GUICtrlListBox_GetListBoxInfo($includedList)
	DebugWrite("Included item count: " & $numIncluded)
	$numExcluded = _GUICtrlListBox_GetListBoxInfo($excludedList)
	DebugWrite("Excluded item count: " & $numExcluded)
	
	If $numIncluded > 0 Or $numExcluded > 0 Then
		$response = MsgBox(BitOR($MB_YESNO, $MB_ICONQUESTION), "Create Preset?", "This action will set this preset to the current selections. If you proceed, you will be prompted to name this preset." & @CRLF & @CRLF & "Are you sure?")
		If $response = $IDYES Then
			$name = InputBox("Name Preset", "Please enter a name for this preset. The name must be unique. Long names will be truncated.")
			
			If @error = 1 Then ; Cancel button was pressed on naming
				DebugWrite("Name entry canceled. Aborting")
				MsgBox(BitOR($MB_OK, $MB_ICONERROR), "Preset Creation Canceled", "Preset creation has been canceled. Please try again.")
				Return
			Else
				While Not $isUnique
					If $name <> "" Then
						For $i = 1 To UBound($presetArray) - 1 Step 3
							If $name = $presetArray[$i][1] Then 
								MsgBox(BitOR($MB_OK, $MB_ICONERROR), "Preset name not unique", "Preset names must be unique. Please try again.")
								$isUnique = False
								DebugWrite("Preset name is not unique. Retrying.")
								$name = InputBox("Name Preset", "Please enter a name for this preset. The name must be unique. Long names will be truncated.")
								ExitLoop
							Else
								$isUnique = True
							EndIf
						Next
					Else
						While $name = ""
							DebugWrite("Preset name is blank. Retrying.")
							$name = InputBox("Name Preset", "No name was entered." & @CRLF & @CRLF & "Please enter a name for the preset. Keep it short and descriptive. Long names will be truncated.")
						WEnd
					EndIf
				WEnd
				DebugWrite("Preset name accepted")
			EndIf
			
			; Get included items
			If $numIncluded > 0 Then
				DebugWrite("Adding included items to preset:")
				DoSelectAllListItems($includedList)
				$selected = _GUICtrlListBox_GetSelItemsText($includedList)
				For $i = 1 to UBound($selected) - 1
					If $i > 1 Then $includedItemsString &= "|"
					$includedItemsString &= $selected[$i]
					DebugWrite($selected[$i])
				Next
				DebugWrite("String: " & $includedItemsString)
			EndIf
			
			; Get excluded items
			If $numExcluded > 0 Then
				DebugWrite("Adding excluded items to preset:")
				DoSelectAllListItems($excludedList)
				$selected = _GUICtrlListBox_GetSelItemsText($excludedList)
				For $i = 1 to UBound($selected) - 1
					If $i > 1 Then $excludedItemsString &= "|"
					$excludedItemsString &= $selected[$i]
					DebugWrite($selected[$i])
				Next
				DebugWrite("String: " & $excludedItemsString)
			EndIf
			
			; Write the preset to the INI file
			IniWrite($settingsINIFile, "Presets", "Preset" & $preset & "Name", $name)
			IniWrite($settingsINIFile, "Presets", "Preset" & $preset & "Include", $includedItemsString)
			IniWrite($settingsINIFile, "Presets", "Preset" & $preset & "Exclude", $excludedItemsString)
			DebugWrite("Settings.ini updated")
			
			; Update presets array
			$arrayOffset = $preset * 3 + 1
			$presetArray[$arrayOffset][1] = $name
			$presetArray[$arrayOffset + 1][1] = $includedItemsString
			$presetArray[$arrayOffset + 2][1] = $excludedItemsString
			DebugWrite("Preset array updated")
			
			DoUpdatePresets()
		Else
			DebugWrite("Preset creation canceled")
		EndIf
	Else
		MsgBox(BitOR($MB_OK, $MB_ICONERROR), "Make a Selection", "Please define your criteria before attempting to set this preset. After selecting items to include/exclude, click this button again and it will assign those items to this preset.")
	  Return
	EndIf
EndFunc

Func DoApplyPreset($preset)
	Dim $availableList, $includedList, $excludedList, $numIncluded, $numExcluded
	Dim $name, $selected, $arrayOffset, $searchType, $itemIndex
	Dim $response = $IDYES
	Dim $includedItemsString = ""
	Dim $excludedItemsString = ""
	Dim $isUnique = False

	$arrayOffset = $preset * 3 + 1
	$name = $presetArray[$arrayOffset][1]
	DebugWrite("Applying preset " & $preset & " (" & $name & ")")
	$includedItemsString = $presetArray[$arrayOffset + 1][1]
	DebugWrite("Included items string: " & $includedItemsString)
	$excludedItemsString = $presetArray[$arrayOffset + 2][1]
	DebugWrite("Excluded items string: " & $excludedItemsString)
	
	Dim $includedItemsArray = _StringExplode($includedItemsString, "|")
	Dim $excludedItemsArray = _StringExplode($excludedItemsString, "|")
	
	If $preset <= 4 Then ; Biomes tab
		DebugWrite("Applying biome preset")
		$availableList = $availableBiomeList
		$includedList = $includedBiomeList
		$excludedList = $excludedBiomeList
		$searchType = "Biome"
	Else ; Structures tab
		DebugWrite("Applying structure preset")
		$availableList = $availableStructList
		$includedList = $includedStructList
		$excludedList = $excludedStructList
		$searchType = "Structure"
	EndIf
	
	$numIncluded = _GUICtrlListBox_GetListBoxInfo($includedList)
	$numExcluded = _GUICtrlListBox_GetListBoxInfo($excludedList)
	
	If $numIncluded > 0 Or $numExcluded > 0 Then
		$response = _WinAPI_MessageBoxCheck(BitOR($MB_YESNO, $MB_ICONQUESTION), "Reset " & $searchType & " Selections?", "This action will remove all current " & $searchType & " selections and apply the '" & $presetArray[$arrayOffset][1] & "' preset." & @CRLF & @CRLF & "Are you sure?", "{5BB57EAD-D839-4605-8B91-523203CE3935}", $IDYES)
	EndIf
	
	If $response = $IDYES Then
		; Clear out any current selections
		DebugWrite("Clearing current selections, if any")
		If $numIncluded > 0 Then
			DoSelectAllListItems($includedList)
			DoMoveListItems($includedList, $availableList)
		EndIf
		If $numExcluded > 0 Then
			DoSelectAllListItems($excludedList)
			DoMoveListItems($excludedList, $availableList)
		EndIf
		
		; Go through the preset item lists and add them to the selection
		DebugWrite("Adding preset included items")
		For $i = 0 to UBound($includedItemsArray) - 1
			$itemIndex = _GUICtrlListBox_FindString($availableList, $includedItemsArray[$i], True)
			_GUICtrlListBox_SelItemRange($availableList, $itemIndex, $itemIndex)
			DoMoveListItems($availableList, $includedList)
		Next
		
		DebugWrite("Adding preset excluded items")
		For $i = 0 to UBound($excludedItemsArray) - 1
			$itemIndex = _GUICtrlListBox_FindString($availableList, $excludedItemsArray[$i], True)
			_GUICtrlListBox_SelItemRange($availableList, $itemIndex, $itemIndex)
			DoMoveListItems($availableList, $excludedList)
		Next
		
		DebugWrite("Preset " & $name & " applied")
	Else
		DebugWrite("Preset application canceled")
		Return
	EndIf
EndFunc

Func DoRemovePreset($preset)
	Dim $arrayOffset
	
	IniWrite($settingsINIFile, "Presets", "Preset" & $preset & "Name", "")
	IniWrite($settingsINIFile, "Presets", "Preset" & $preset & "Include", "")
	IniWrite($settingsINIFile, "Presets", "Preset" & $preset & "Exclude", "")
	
	$arrayOffset = $preset * 3 + 1 ; Each preset takes 3 rows, starting with row 1
	
	$presetArray[$arrayOffset][1] = ""
	$presetArray[$arrayOffset + 1][1] = ""
	$presetArray[$arrayOffset + 2][1] = ""
	
	DebugWrite("Preset " & $preset & " removed")
EndFunc

Func DoUpdatePresets()
	GUICtrlSetData($preset0Button, $presetArray[1][1])
	GUICtrlSetData($preset1Button, $presetArray[4][1])
	GUICtrlSetData($preset2Button, $presetArray[7][1])
	GUICtrlSetData($preset3Button, $presetArray[10][1])
	GUICtrlSetData($preset4Button, $presetArray[13][1])
	GUICtrlSetData($preset5Button, $presetArray[16][1])
	GUICtrlSetData($preset6Button, $presetArray[19][1])
	GUICtrlSetData($preset7Button, $presetArray[22][1])
	GUICtrlSetData($preset8Button, $presetArray[25][1])
	GUICtrlSetData($preset9Button, $presetArray[28][1])
	DebugWrite("Preset buttons updated")
EndFunc
#EndRegion

#Region Search Functions
Func StopExecution()
	DebugWrite("Execution terminated early")
EndFunc

Func GetAmidstWindowDimensions($windowTitle)
	Dim $amidstWindow, $amidstWindowSize, $amidstClientSize, $edgeWidth, $menuHeight
	Dim $left, $top, $right, $bottom
	Dim $returnvalues[5]
	
	If WinExists($windowTitle) Then
		$amidstWindow = WinGetHandle($windowTitle)
		$amidstWindowSize = WinGetPos($amidstWindow)
		$amidstClientSize = WinGetClientSize($amidstWindow)
		$edgeWidth = ($amidstWindowSize[2] - $amidstClientSize[0]) / 2
		$menuHeight = $amidstWindowSize[3] - $amidstClientSize[1] + 80 ; 80 pixels includes the menu and the textbox at the top of the map
		$left = $amidstWindowSize[0] + $edgeWidth
		$top = $amidstWindowSize[1] + $menuHeight
		$right = $left + $amidstClientSize[0]
		$bottom = $top + $amidstClientSize[1] - 80 - 60 ; 60 pixels removes the icon in the lower right corner from the search area
   
		$returnvalues[0] = $amidstWindow
		$returnvalues[1] = $left
		$returnvalues[2] = $top
		$returnvalues[3] = $right
		$returnvalues[4] = $bottom

		#cs The following code was used for debugging the search rectangle
			_GDIPlus_Startup()
			$screencapture = _ScreenCapture_Capture("")
			$bitmap = _GDIPlus_BitmapCreateFromHBITMAP($screencapture)
			$graphics = _GDIPlus_ImageGetGraphicsContext($bitmap)
			$pen = _GDIPlus_PenCreate(0xFF000000,3)
			_GDIPlus_GraphicsDrawRect($graphics,$left,$top,$right - $left,$bottom - $top,$pen)
			_GDIPlus_ImageSaveToFile($bitmap, @MyDocumentsDir & "\debug_image.jpg")
			Sleep(10000)
			_GDIPlus_ImageDispose($bitmap)
			_WinAPI_DeleteObject($screencapture)
			_GDIPlus_Shutdown()
			Exit
		#ce
		
		Return $returnvalues
	EndIf
EndFunc

Func ResultsWrite($data)
	Dim $handle
	
	If $showResultsTab = 1 Then
		If $newSearch And _GUICtrlEdit_GetTextLen($resultsEdit) > 0 Then
			DoClearResultsEdit()
		EndIf
		_GUICtrlEdit_AppendText($resultsEdit, $data & @CRLF)
	EndIf
	If $saveSearchResultsToFile = 1 Then
		If $resultsFile = "" Then
			DoGetResultsOutputFile()
		EndIf
		If $newSearch Then
			$handle = FileOpen($resultsFile, $FO_OVERWRITE)
		Else
			$handle = FileOpen($resultsFile, $FO_APPEND)
		EndIf
		FileWriteLine($handle, $data & @CRLF)
		FileClose($handle)
	EndIf
	
	$newSearch = False
EndFunc

Func EvaluateSeed($seed, $criteriaArray, $listArray, $windowDims, $include)
	Dim $reason, $index, $searchColor
	
	SetError(0)
	
	For $i = 1 to UBound($criteriaArray) - 1
		$index = _ArraySearch($listArray, $criteriaArray[$i])
		$searchColor = $listArray[$index][1]
		DebugWrite("Searching for " & $criteriaArray[$i] & " (" & $searchColor & ")")
		WinActivate("Amidst v4.2")
		PixelSearch($windowDims[1], $windowDims[2], $windowDims[3], $windowDims[4], $searchColor, 0, 1, $windowDims[0])
		If $include And @error = 1 Then ; Should be found and wasn't
			$reason = " (missing " & $criteriaArray[$i] & ")"
			DebugWrite("Seed rejected" & $reason)
			Return $reason
		ElseIf Not $include And @error = 0 Then ; Shouldn't be found, but was
			$reason = " (contains " & $criteriaArray[$i] & ")"
			DebugWrite("Seed rejected" & $reason)
			Return $reason
		EndIf
	Next
	
	$reason = ""
	Return $reason
EndFunc

Func DoSearch()
	Dim $numIncluded, $numExcluded
	Dim $searchColor, $index, $currentSeed, $handle, $reason
	Dim $includedBiomesSearchArray = []
	Dim $excludedBiomesSearchArray = []
	Dim $includedStructsSearchArray = []
	Dim $excludedStructsSearchArray = []
	Dim $searchCount = 0
	Dim $seedsFoundCount = 0
	Dim $rejected = False
	Dim $windowDims = GetAmidstWindowDimensions("Amidst v4.2")
	
	$newSearch = True
	
	If $showResultsTab = 1 Then
		DoHideBiomesTab()
		DoHideStructuresTab()
		DoHideOptionsTab()
		DoHideDebugTab()
		DoShowResultsTab()
		_GUICtrlTab_SetCurFocus($tabSet, _GUICtrlTab_FindTab($tabSet, "Search Results"))
	EndIf
	
	ResultsWrite("Seed search initiated " & GetTimestamp() & @CRLF)
	
	If $useRandomSeeds = 0 Then
		ResultsWrite("Seed source: File")
		ResultsWrite("Seed list file: " & $seedListFile)
		ResultsWrite($seedFileInfo)
		ResultsWrite("Seed offset: " & String($seedOffset) & @CRLF)
		DebugWrite("Seed list file: " & $seedListFile)
	Else
		ResultsWrite("Seed source: Random" & @CRLF)
	EndIf
	
	ResultsWrite("Max. seeds to evaluate: " & ($maxSeedsToEvaluate = 0 ? "∞" : String($maxSeedsToEvaluate)))
	ResultsWrite("Number of seeds to find: " & String($seedsToFind) & @CRLF)

	If $includeRejectedSeeds = 1 Then
		ResultsWrite("Rejected seeds are included in results below" & @CRLF)
		DebugWrite("Including rejected seeds")
	EndIf
	
	ResultsWrite("Biome search criteria:")
	DebugWrite("Getting biome criteria")
	If $searchForBiomes = 1 Then
		$numIncluded = _GUICtrlListBox_GetListBoxInfo($includedBiomeList)
		$numExcluded = _GUICtrlListBox_GetListBoxInfo($excludedBiomeList)
		DoSelectAllListItems($includedBiomeList)
		$includedBiomesSearchArray = _GUICtrlListBox_GetSelItemsText($includedBiomeList)
		ResultsWrite("  Include:")
		DebugWrite("Included biomes")
		If UBound($includedBiomesSearchArray) = 1 Then
			ResultsWrite("   - None")
			DebugWrite("None")
		Else
			For $i = 1 To UBound($includedBiomesSearchArray) - 1
				ResultsWrite("   - " & $includedBiomesSearchArray[$i])
				DebugWrite($includedBiomesSearchArray[$i])
			Next
		EndIf
		DoSelectAllListItems($excludedBiomeList)
		$excludedBiomesSearchArray = _GUICtrlListBox_GetSelItemsText($excludedBiomeList)
		ResultsWrite("  Exclude:")
		DebugWrite("Excluded biomes")
		If UBound($excludedBiomesSearchArray) = 1 Then
			ResultsWrite("   - None")
			DebugWrite("None")
		Else
			For $i = 1 To UBound($excludedBiomesSearchArray) - 1
				ResultsWrite("   - " & $excludedBiomesSearchArray[$i])
				DebugWrite($excludedBiomesSearchArray[$i])
			Next
		EndIf
	Else
		ResultsWrite("  None selected")
		DebugWrite("No biomes selected")
	EndIf
	
	ResultsWrite("Structure search criteria:")
	DebugWrite("Getting structure criteria")
	If $searchForStructures = 1 Then
		$numIncluded = _GUICtrlListBox_GetListBoxInfo($includedStructList)
		$numExcluded = _GUICtrlListBox_GetListBoxInfo($excludedStructList)
		DoSelectAllListItems($includedStructList)
		$includedStructsSearchArray = _GUICtrlListBox_GetSelItemsText($includedStructList)
		ResultsWrite("  Include:")
		DebugWrite("Included structures")
		If UBound($includedStructsSearchArray) = 1 Then
			ResultsWrite("   - None")
			DebugWrite("None")
		Else
			For $i = 1 To UBound($includedStructsSearchArray) - 1
				ResultsWrite("   - " & $includedStructsSearchArray[$i])
				DebugWrite($includedStructsSearchArray[$i])
			Next
		EndIf
		DoSelectAllListItems($excludedStructList)
		$excludedStructsSearchArray = _GUICtrlListBox_GetSelItemsText($excludedStructList)
		ResultsWrite("  Exclude:")
		DebugWrite("Excluded structures")
		If UBound($excludedStructsSearchArray) = 1 Then
			ResultsWrite("   - None")
			DebugWrite("None")
		Else
			For $i = 1 To UBound($excludedStructsSearchArray) - 1
				ResultsWrite("   - " & $excludedStructsSearchArray[$i])
				DebugWrite($excludedStructsSearchArray[$i])
			Next
		EndIf
	Else
		ResultsWrite("  None selected")
		DebugWrite("No structures selected")
	EndIf
	
	; False positives warning
	If $searchForBiomes = 1 And $searchForStructures = 1 And (_ArraySearch($includedBiomesSearchArray, "Extreme Hills") Or _ArraySearch($includedBiomesSearchArray, "Extreme Hills M") Or _ArraySearch($includedBiomesSearchArray, "Ice Mountains") Or _ArraySearch($includedBiomesSearchArray, "Ice Plains") Or _ArraySearch($excludedBiomesSearchArray, "Extreme Hills") Or _ArraySearch($excludedBiomesSearchArray, "Extreme Hills M") Or _ArraySearch($excludedBiomesSearchArray, "Ice Mountains") Or _ArraySearch($excludedBiomesSearchArray, "Ice Plains")) Then
		_WinAPI_MessageBoxCheck(BitOR($MB_OK, $MB_ICONQUESTION), "Possible False Positives/Negatives", "Warning: Searching for certain biomes (Extreme Hills, Extreme Hills M, Ice Mountains, Ice Plains) can generate false positives/negatives when also searching for structures." & @CRLF & @CRLF & "When searching for these biomes (included or excluded), we recommend double-checking any results to eliminate these possible false results", "{3AC815B9-2394-4E3C-92CA-E51BCBDEDE16}", $IDOK)
	EndIf
	
	MsgBox($MB_OK + $MB_ICONINFORMATION, "Beginning Search", "Depending on your search criteria, this process can take a long time." & @CRLF & @CRLF & "To end execution early, press ESC.")
	
	If $showProgressPopupWindow = 1 Then
		_Toast_Set(Default)
		Dim $toast = _Toast_Show(64, "", "Amidst Seed Hunter" & @CRLF & "Search Progress" & @CRLF  & @CRLF & @CRLF & @CRLF & @CRLF & @CRLF & @CRLF & @CRLF, 0)
		
		Dim $progressLabel1 = GUICtrlCreateLabel("0000000/0000000 seeds searched", 10, 50)
		Dim $progressBar1 = GUICtrlCreateProgress(10, 68, $toast[0] - 20, 20)
		
		Dim $progressLabel2 = GUICtrlCreateLabel("0000000/0000000 seeds found", 10, 103)
		Dim $progressBar2 = GUICtrlCreateProgress(10, 121, $toast[0] - 20, 20)
		
		Dim $progressLabel3 = GUICtrlCreateLabel("Press ESC to stop search early", 10, 156)
		
		If $maxSeedsToEvaluate = 0 Then
			GUICtrlSetData($progressLabel1, $searchCount & "/∞ seeds searched")
			GUICtrlSetData($progressBar1, 100)
		Else
			GUICtrlSetData($progressLabel1, $searchCount & "/" & $maxSeedsToEvaluate & " seeds searched")
			GUICtrlSetData($progressBar1, ($searchCount / $maxSeedsToEvaluate) * 100)
		EndIf
		GUICtrlSetData($progressLabel2, $seedsFoundCount & "/" & $seedsToFind & " seeds found")
		GUICtrlSetData($progressBar2, ($seedsFoundCount / $seedsToFind) * 100)
	EndIf
	
	ResultsWrite(@CRLF & "Search Results:" & @CRLF & "====================")
	
	; Search loop
	While 1
		If @HotKeyPressed = "{ESC}" Then ExitLoop
		
		If $searchCount >= $maxSeedsToEvaluate And $maxSeedsToEvaluate > 0 Then ExitLoop
		
		If $seedsFoundCount >= $seedsToFind Then ExitLoop
		
		WinActivate("Amidst v4.2")
		If $useRandomSeeds = 1 Then
			DebugWrite("Getting new random seed")
			Send("^r") ; New random seed
			Sleep(1500)
			Send("^c") ; Copy seed to clipboard
			Sleep(500)
			$currentSeed = _ClipBoard_GetData($CF_TEXT)
			DebugWrite("New random seed: " & $currentSeed)
		Else
			DebugWrite("Getting new seed from file")
			Send("^n")
			$handle = FileOpen($seedListFile, $FO_READ)
			If $handle <> -1 Then
				$currentSeed = FileReadLine($handle, $seedOffset + 1)
				DebugWrite("New numeric seed: " & $currentSeed)
				FileClose($handle)
				_ClipBoard_SetData($currentSeed, $CF_TEXT)
				Sleep(500)
				Send("^v") ; Paste seed from clipboard
				;Send($currentSeed)
				Sleep(500)
				Send("{ENTER}")
				Sleep(1500)
				$seedOffset += 1
			Else
				DebugWrite("Error retrieving seed from file")
			EndIf
		EndIf
		
		; Evaluate seed (included/excluded biomes/structures)
		$reason = EvaluateSeed($currentSeed, $includedBiomesSearchArray, $biomeArray, $windowDims, True)
		If $reason = "" Then $reason = EvaluateSeed($currentSeed, $excludedBiomesSearchArray, $biomeArray, $windowDims, False)
		If $reason = "" Then $reason = EvaluateSeed($currentSeed, $includedStructsSearchArray, $structArray, $windowDims, True)
		If $reason = "" Then $reason = EvaluateSeed($currentSeed, $excludedStructsSearchArray, $structArray, $windowDims, False)
		
		If $reason = "" Then
			If $includeRejectedSeeds = 0 Then
				ResultsWrite($currentSeed)
			Else
				ResultsWrite("▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀" & @CRLF & $currentSeed & @CRLF & "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄")
			EndIf
			$seedsFoundCount += 1
		Else
			ResultsWrite($currentSeed & _StringRepeat(" ", 24 - StringLen(String($currentSeed))) & $reason)
		EndIf
		
		$searchCount += 1
		
		If $showProgressPopupWindow = 1 Then
			If $maxSeedsToEvaluate = 0 Then
				GUICtrlSetData($progressLabel1, $searchCount & "/∞ seeds searched")
				GUICtrlSetData($progressBar1, 100)
			Else
				GUICtrlSetData($progressLabel1, $searchCount & "/" & $maxSeedsToEvaluate & " seeds searched")
				GUICtrlSetData($progressBar1, ($searchCount / $maxSeedsToEvaluate) * 100)
			EndIf
			GUICtrlSetData($progressLabel2, $seedsFoundCount & "/" & $seedsToFind & " seeds found")
			GUICtrlSetData($progressBar2, ($seedsFoundCount / $seedsToFind) * 100)
		EndIf
	Wend
	
	WinActivate("Amidst Seed Hunter")
	
	_Toast_Hide()
	
	ResultsWrite(@CRLF & $searchCount & " seed" & ($searchCount = 1 ? " " : "s ") & "evaluated")
	ResultsWrite($seedsFoundCount & " seed" & ($seedsFoundCount = 1 ? " " : "s ") & "found")
EndFunc
#EndRegion

Func Main()
	UpdateGlobals()
	
	Dim $tabName, $msg
	
	DebugWrite("Initializing main GUI")
	DoBuildMainGUI()
	
	$previousTab = _GUICtrlTab_GetCurFocus($tabSet)
	
	; Main loop
	While 1
		$msg = GUIGetMsg($GUI_EVENT_ARRAY)
		
		;_ArrayDisplay($msg)
		
		If $msg[1] = $form Then
			Switch $msg[0]
				Case $GUI_EVENT_CLOSE
					Exit
				Case $cancelQuitButton
					DebugWrite("Cancel/Quit button pressed")
					Exit
				Case $beginSearchButton
					DebugWrite("Begin Search button pressed")
					DoSearch()
				Case $includeBiomeButton
					DebugWrite("Include biome button pressed")
					DoMoveListItems($availableBiomeList, $includedBiomeList)
				Case $removeIncludedBiomeButton
					DebugWrite("Remove included biome button pressed")
					DoMoveListItems($includedBiomeList, $availableBiomeList)
				Case $removeAllIncludedBiomeButton
					DebugWrite("Remove all included biomes button pressed")
					DoSelectAllListItems($includedBiomeList)
					DoMoveListItems($includedBiomeList, $availableBiomeList)
				Case $excludeBiomeButton
					DebugWrite("Exclude biome button pressed")
					DoMoveListItems($availableBiomeList, $excludedBiomeList)
				Case $removeExcludedBiomeButton
					DebugWrite("Remove excluded biome button pressed")
					DoMoveListItems($excludedBiomeList, $availableBiomeList)
				Case $removeAllExcludedBiomeButton
					DebugWrite("Remove all excluded biomes button pressed")
					DoSelectAllListItems($excludedBiomeList)
					DoMoveListItems($excludedBiomeList, $availableBiomeList)
				Case $preset0Button
					DebugWrite("Preset 0 button pressed")
					DoPresetButton(0)
				Case $preset1Button
					DebugWrite("Preset 1 button pressed")
					DoPresetButton(1)
				Case $preset2Button
					DebugWrite("Preset 2 button pressed")
					DoPresetButton(2)
				Case $preset3Button
					DebugWrite("Preset 3 button pressed")
					DoPresetButton(3)
				Case $preset4Button
					DebugWrite("Preset 4 button pressed")
					DoPresetButton(4)
				Case $includeStructButton
					DebugWrite("Include structure button pressed")
					DoMoveListItems($availableStructList, $includedStructList)
				Case $removeIncludedStructButton
					DebugWrite("Remove included structure button pressed")
					DoMoveListItems($includedStructList, $availableStructList)
				Case $removeAllIncludedStructButton
					DebugWrite("Remove all included structures button pressed")
					DoSelectAllListItems($includedStructList)
					DoMoveListItems($includedStructList, $availableStructList)
				Case $excludeStructButton
					DebugWrite("Exclude structure button pressed")
					DoMoveListItems($availableStructList, $excludedStructList)
				Case $removeExcludedStructButton
					DebugWrite("Remove excluded structure button pressed")
					DoMoveListItems($excludedStructList, $availableStructList)
				Case $removeAllExcludedStructButton
					DebugWrite("Remove all excluded structures button pressed")
					DoSelectAllListItems($excludedStructList)
					DoMoveListItems($excludedStructList, $availableStructList)
				Case $preset5Button
					DebugWrite("Preset 5 button pressed")
					DoPresetButton(5)
				Case $preset6Button
					DebugWrite("Preset 6 button pressed")
					DoPresetButton(6)
				Case $preset7Button
					DebugWrite("Preset 7 button pressed")
					DoPresetButton(7)
				Case $preset8Button
					DebugWrite("Preset 8 button pressed")
					DoPresetButton(8)
				Case $preset9Button
					DebugWrite("Preset 9 button pressed")
					DoPresetButton(9)
				Case $useRandomSeedsRadio				
					If $useRandomSeeds = 0 Then
						IniWrite($settingsINIFile, "Options", "UseRandomSeeds", 1)
					Else
						IniWrite($settingsINIFile, "Options", "UseRandomSeeds", 0)
					EndIf
					UpdateGlobals()
					DebugWrite("UseRandomSeeds set to '" & $useRandomSeeds & "'")
				Case $useSeedListFileRadio
					If $useRandomSeeds = 0 Then
						IniWrite($settingsINIFile, "Options", "UseRandomSeeds", 1)
					Else
						IniWrite($settingsINIFile, "Options", "UseRandomSeeds", 0)
					EndIf
					UpdateGlobals()
					DebugWrite("UseRandomSeeds set to " & $useRandomSeeds)
				Case $seedListFileBrowseButton
					DoGetSeedListFile()
				Case $seedOffsetInput
					$seedOffset = GUICtrlRead($seedOffsetInput)
					IniWrite($settingsINIFile, "Options", "SeedOffset", $seedOffset)
					UpdateGlobals()
					DebugWrite("SeedOffset set to '" & $seedOffset & "'")
				Case $searchForBiomeChkbx
					If $searchForBiomes = 0 Then
						IniWrite($settingsINIFile, "Options", "SearchForBiomes", 1)
						DoBuildBiomesTab()
						DoHideBiomesTab()
						DoShowOptionsTab()
						UpdateGlobals()
						DebugWrite("SearchForBiomes set to '" & $searchForBiomes & "'")
					Else
						IniWrite($settingsINIFile, "Options", "SearchForBiomes", 0)
						_GUICtrlTab_DeleteItem($tabSet, _GUICtrlTab_FindTab($tabSet, "Biomes"))
						DoShowOptionsTab()
						UpdateGlobals()
						DebugWrite("SearchForBiomes set to '" & $searchForBiomes & "'")
					EndIf
				Case $searchForStructChkbx
					If $searchForStructures = 0 Then
						IniWrite($settingsINIFile, "Options", "SearchForStructures", 1)
						DoBuildStructuresTab()
						DoHideStructuresTab()
						DoShowOptionsTab()
						UpdateGlobals()
						DebugWrite("SearchForStructures set to '" & $searchForStructures & "'")
					Else
						IniWrite($settingsINIFile, "Options", "SearchForStructures", 0)
						_GUICtrlTab_DeleteItem($tabSet, _GUICtrlTab_FindTab($tabSet, "Structures"))
						DoShowOptionsTab()
						UpdateGlobals()
						DebugWrite("SearchForStructures set to '" & $searchForStructures & "'")
					EndIf
				Case $saveResultsToFileChkbx
					If $saveSearchResultsToFile = 0 Then
						IniWrite($settingsINIFile, "Options", "SaveSearchResultsToFile", 1)
					Else
						IniWrite($settingsINIFile, "Options", "SaveSearchResultsToFile", 0)
					EndIf
					UpdateGlobals()
					DebugWrite("SaveSearchResultsToFile set to '" & $saveSearchResultsToFile & "'")
				Case $includeRejectedSeedsChkbx
					If $includeRejectedSeeds = 0 Then
						IniWrite($settingsINIFile, "Options", "IncludeRejectedSeeds", 1)
					Else
						IniWrite($settingsINIFile, "Options", "IncludeRejectedSeeds", 0)
					EndIf
					UpdateGlobals()
					DebugWrite("IncludeRejectedSeeds set to '" & $includeRejectedSeeds & "'")
				Case $maxSeedsInput
					$maxSeedsToEvaluate = GUICtrlRead($maxSeedsInput)
					IniWrite($settingsINIFile, "Options", "MaxSeedsToEvaluate", $maxSeedsToEvaluate)
					UpdateGlobals()
					DebugWrite("MaxSeedsToEvaluate set to '" & $maxSeedsToEvaluate & "'")
				Case $numSeedsToEvaluateInput
					$seedsToFind = GUICtrlRead($numSeedsToEvaluateInput)
					IniWrite($settingsINIFile, "Options", "SeedsToFind", $seedsToFind)
					UpdateGlobals()
					DebugWrite("SeedsToFind set to '" & $seedsToFind & "'")
				Case $overwriteOutputFileChkbx
					If $overwriteResults = 0 Then
						IniWrite($settingsINIFile, "Options", "OverwriteResults", 1)
					Else
						IniWrite($settingsINIFile, "Options", "OverwriteResults", 0)
					EndIf
					UpdateGlobals()
					DebugWrite("OverwriteResults set to '" & $overwriteResults & "'")
				Case $resultsOutputFileBrowseButton
					DoGetResultsOutputFile()
				Case $guidedAmidstSetupChkbx
					If $guidedAmidstSetup = 0 Then
						IniWrite($settingsINIFile, "Options", "GuidedAmidstSetup", 1)
					Else
						IniWrite($settingsINIFile, "Options", "GuidedAmidstSetup", 0)
					EndIf
					UpdateGlobals()
					DebugWrite("GuidedAmidstSetup set to '" & $guidedAmidstSetup & "'")
				Case $saveScreenshotChkbx
					If $saveScreenshots = 0 Then
						IniWrite($settingsINIFile, "Options", "SaveScreenshots", 1)
					Else
						IniWrite($settingsINIFile, "Options", "SaveScreenshots", 0)
					EndIf
					UpdateGlobals()
					DebugWrite("SaveScreenshots set to '" & $saveScreenshots & "'")
				Case $rememberAmidstWinSizeChkbx
					If $rememberAmidstWindowSize = 0 Then
						IniWrite($settingsINIFile, "Options", "RememberAmidstWindowSize", 1)
					Else
						IniWrite($settingsINIFile, "Options", "RememberAmidstWindowSize", 0)
					EndIf
					UpdateGlobals()
					DebugWrite("RememberAmidstWindowSize set to '" & $rememberAmidstWindowSize & "'")
				Case $macLinuxCompatChkbx
					If $macLinuxCompatibility = 0 Then
						IniWrite($settingsINIFile, "Options", "MacLinuxCompatibility", 1)
					Else
						IniWrite($settingsINIFile, "Options", "MacLinuxCompatibility", 0)
					EndIf
					UpdateGlobals()
					DebugWrite("MacLinuxCompatibility set to '" & $macLinuxCompatibility & "'")
				Case $showProgressPopupChkbx
					If $showProgressPopupWindow = 0 Then
						IniWrite($settingsINIFile, "Options", "ShowProgressPopupWindow", 1)
					Else
						IniWrite($settingsINIFile, "Options", "ShowProgressPopupWindow", 0)
					EndIf
					UpdateGlobals()
					DebugWrite("ShowProgressPopupWindow set to '" & $showProgressPopupWindow & "'")
				Case $showResultsTabChkbx
					If $showResultsTab = 0 Then
						IniWrite($settingsINIFile, "Options", "ShowResultsTab", 1)
						DoBuildResultsTab()
						DoHideResultsTab()
						DoShowOptionsTab()
						UpdateGlobals()
						DebugWrite("Search results tab enabled")
					Else
						IniWrite($settingsINIFile, "Options", "ShowResultsTab", 0)
						_GUICtrlTab_DeleteItem($tabSet, _GUICtrlTab_FindTab($tabSet, "Search Results"))
						DoShowOptionsTab()
						UpdateGlobals()
						DebugWrite("Search results tab disabled")
					EndIf
				Case $enableDebugChkbx
					If $enableDebugging = 0 Then
						IniWrite($settingsINIFile, "Options", "EnableDebugging", 1)
						DoBuildDebugTab()
						DoHideDebugTab()
						DoShowOptionsTab()
						UpdateGlobals()
						DebugWrite("Debug tab enabled")
					Else
						IniWrite($settingsINIFile, "Options", "EnableDebugging", 0)
						_GUICtrlTab_DeleteItem($tabSet, _GUICtrlTab_FindTab($tabSet, "Debug"))
						DoShowOptionsTab()
						UpdateGlobals()
						DebugWrite("Debug tab disabled")
					EndIf
				Case $restoreHiddenDialogsButton
					DebugWrite("Restore hidden dialogs requested")
					DoRestoreHiddenDialogs()
				Case $reloadSettingsINIButton
					DebugWrite("Reload options from INI file requested")
					DoUpdateOptionsTabFromINIFile()
				Case $resetAllOptionsButton
					DebugWrite("Reset all options requested")
					DoResetINIFileToDefaults()
					DoUpdateOptionsTabFromINIFile()
					GUIDelete($form)
					DoBuildMainGUI()
				Case $removePresetButton
					DebugWrite("Remove preset requested")
					DoBuildRemovePresetsGUI()
					DebugWrite("Remove preset GUI built")
					GUISetState(@SW_DISABLE, $form)
					DebugWrite("Main GUI disabled")
					GUISwitch($removePresetsForm)
					GUISetState(@SW_SHOW, $removePresetsForm)
					DebugWrite("Remove presets GUI enabled")
				Case $clearResultsButton
					DebugWrite("Clear search results requested")
					DoClearResultsEdit()
				Case $copyResultsButton
					DebugWrite("Copy search results to clipboard requested")
					DoCopyResultsToClipboard()
				Case $saveResultsButton
					DebugWrite("Save search results to file requested")
					DoSaveResultsToFile()
				Case $clearDebugButton
					DebugWrite("Clear debug data requested")
					DoClearDebugEdit()
				Case $copyDebugButton
					DebugWrite("Copy debug data to clipboard requested")
					DoCopyDebugToClipboard()
				Case $saveDebugButton
					DebugWrite("Save debug data to file requested")
					DoSaveDebugToFile()
				Case Else
					; Do nothing
			EndSwitch
		ElseIf $msg[1] = $removePresetsForm Then
			Switch $msg[0]
				Case $GUI_EVENT_CLOSE
					DebugWrite("Remove presets form closed")
					GUISetState(@SW_HIDE, $removePresetsForm)
					DebugWrite("Remove presets form disabled")
					GUISwitch($form)
					GUISetState(@SW_ENABLE, $form)
					GUISetState(@SW_SHOW, $form)
					DebugWrite("Main GUI enabled")
					WinActivate("Amidst Seed Hunter")
				Case $cancelButton
					DebugWrite("Remove presets canceled")
					GUISetState(@SW_HIDE, $removePresetsForm)
					DebugWrite("Remove presets form disabled")
					GUISwitch($form)
					GUISetState(@SW_ENABLE, $form)
					GUISetState(@SW_SHOW, $form)
					DebugWrite("Main GUI enabled")
					WinActivate("Amidst Seed Hunter")
				Case $okButton
					DebugWrite("Remove presets requested")
					GUISwitch($removePresetsForm)
					If GUICtrlRead($preset0Chkbx) = $GUI_CHECKED Then DoRemovePreset(0)
					If GUICtrlRead($preset1Chkbx) = $GUI_CHECKED Then DoRemovePreset(1)
					If GUICtrlRead($preset2Chkbx) = $GUI_CHECKED Then DoRemovePreset(2)
					If GUICtrlRead($preset3Chkbx) = $GUI_CHECKED Then DoRemovePreset(3)
					If GUICtrlRead($preset4Chkbx) = $GUI_CHECKED Then DoRemovePreset(4)
					If GUICtrlRead($preset5Chkbx) = $GUI_CHECKED Then DoRemovePreset(5)
					If GUICtrlRead($preset6Chkbx) = $GUI_CHECKED Then DoRemovePreset(6)
					If GUICtrlRead($preset7Chkbx) = $GUI_CHECKED Then DoRemovePreset(7)
					If GUICtrlRead($preset8Chkbx) = $GUI_CHECKED Then DoRemovePreset(8)
					If GUICtrlRead($preset9Chkbx) = $GUI_CHECKED Then DoRemovePreset(9)
					DoUpdatePresets()
					GUISwitch($form)
					GUIDelete($removePresetsForm)
					DoBuildRemovePresetsGUI()
					GUISetState(@SW_ENABLE, $form)
					GUISetState(@SW_SHOW, $form)
					DebugWrite("Main GUI enabled")
					WinActivate("Amidst Seed Hunter")
			EndSwitch
		EndIf
		
		; Tab control
		$currentTab = _GUICtrlTab_GetCurFocus($tabSet)
		
		If $currentTab <> $previousTab Then
			$previousTab = $currentTab
			$tabName = _GUICtrlTab_GetItemText($tabSet, $currentTab)
			Switch $tabName
				Case "Biomes"
					DoHideStructuresTab()
					DoHideOptionsTab()
					DoHideResultsTab()
					DoHideDebugTab()
					DoShowBiomesTab()
				Case "Structures"
					DoHideBiomesTab()
					DoHideOptionsTab()
					DoHideResultsTab()
					DoHideDebugTab()
					DoShowStructuresTab()
				Case "Options"
					DoHideBiomesTab()
					DoHideStructuresTab()
					DoHideResultsTab()
					DoHideDebugTab()
					DoShowOptionsTab()
				Case "Search Results"
					DoHideBiomesTab()
					DoHideStructuresTab()
					DoHideOptionsTab()
					DoHideDebugTab()
					DoShowResultsTab()
				Case "Debug"
					DoHideBiomesTab()
					DoHideStructuresTab()
					DoHideOptionsTab()
					DoHideResultsTab()
					DoShowDebugTab()
				Case Else
					; Do nothing
			EndSwitch
		EndIf
	Wend
EndFunc

Main()