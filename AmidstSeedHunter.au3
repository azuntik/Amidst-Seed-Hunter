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
#include <GuiMenu.au3>
#include <GuiTab.au3>
#include <StaticConstants.au3>
#include <String.au3>
#include <WinAPI.au3>
#include <WinAPIDlg.au3>
#include <WindowsConstants.au3>

#include "Include\ASH_Amidst.au3"
#include "Include\ASH_Debug.au3"
#include "Include\ASH_Globals.au3"
#include "Include\ASH_GUI.au3"
#include "Include\ASH_Presets.au3"
#include "Include\ASH_Search.au3"
#include "Include\ASH_Toast.au3" ; This is a lightly modified version of Melba23's Toast UDF

Func Main()
	UpdateGlobals()
	
	Dim $tabName, $msg
	
	DebugWrite("Initializing main GUI")
	DoBuildMainGUI()
	
	; Register message handlers
    GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
    GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	
	$previousTab = _GUICtrlTab_GetCurFocus($tabSet)
	
	; Main loop
	While 1
		$msg = GUIGetMsg($GUI_EVENT_ARRAY)
		
		If $msg[1] = $form Then
			Switch $msg[0]
				Case $GUI_EVENT_CLOSE
					Exit
				Case $GUI_EVENT_SECONDARYUP ; Right-click released
					DoRightClickAction()
				Case $cancelQuitButton
					DebugWrite("Cancel/Quit button pressed")
					Exit
				Case $beginSearchButton
					DebugWrite("Begin Search button pressed")
					DoSearch()
				Case $advancedSearchMenuItem
					DoAdvancedSearch()
				;Case $includedBiomeGroupButton
				;	DoBiomeGroupPopupMenu($includedBiomeGroupButton)
				;Case $excludedBiomeGroupButton
				;	DoBiomeGroupPopupMenu($excludedBiomeGroupButton)
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
				Case $removePreset0
					DoRemovePreset(0, True)
					DoUpdatePresets()
				Case $preset1Button
					DebugWrite("Preset 1 button pressed")
					DoPresetButton(1)
				Case $removePreset1
					DoRemovePreset(1, True)
					DoUpdatePresets()
				Case $preset2Button
					DebugWrite("Preset 2 button pressed")
					DoPresetButton(2)
				Case $removePreset2
					DoRemovePreset(2, True)
					DoUpdatePresets()
				Case $preset3Button
					DebugWrite("Preset 3 button pressed")
					DoPresetButton(3)
				Case $removePreset3
					DoRemovePreset(3, True)
					DoUpdatePresets()
				Case $preset4Button
					DebugWrite("Preset 4 button pressed")
					DoPresetButton(4)
				Case $removePreset4
					DoRemovePreset(4, True)
					DoUpdatePresets()
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
				Case $removePreset5
					DoRemovePreset(5, True)
					DoUpdatePresets()
				Case $preset6Button
					DebugWrite("Preset 6 button pressed")
					DoPresetButton(6)
				Case $removePreset6
					DoRemovePreset(6, True)
					DoUpdatePresets()
				Case $preset7Button
					DebugWrite("Preset 7 button pressed")
					DoPresetButton(7)
				Case $removePreset7
					DoRemovePreset(7, True)
					DoUpdatePresets()
				Case $preset8Button
					DebugWrite("Preset 8 button pressed")
					DoPresetButton(8)
				Case $removePreset8
					DoRemovePreset(8, True)
					DoUpdatePresets()
				Case $preset9Button
					DebugWrite("Preset 9 button pressed")
					DoPresetButton(9)
				Case $removePreset9
					DoRemovePreset(9, True)
					DoUpdatePresets()
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
				Case $enableBiomeGroupsChkbx
					If $enableBiomeGroups = 0 Then
						IniWrite($settingsINIFile, "Options", "EnableBiomeGroups", 1)
						DoAddBiomeGroupsToList()
						UpdateGlobals()
						DebugWrite("EnableBiomeGroups set to '" & $enableBiomeGroups & "'")
					Else
						IniWrite($settingsINIFile, "Options", "EnableBiomeGroups", 0)
						DoRemoveBiomeGroupsFromList()
						UpdateGlobals()
						DebugWrite("EnableBiomeGroups set to '" & $enableBiomeGroups & "'")
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
					_GUICtrlTab_SetCurFocus($tabSet, _GUICtrlTab_FindTab($tabSet, "Biomes"))
				Case "Structures"
					DoHideBiomesTab()
					DoHideOptionsTab()
					DoHideResultsTab()
					DoHideDebugTab()
					DoShowStructuresTab()
					_GUICtrlTab_SetCurFocus($tabSet, _GUICtrlTab_FindTab($tabSet, "Structures"))
				Case "Options"
					DoHideBiomesTab()
					DoHideStructuresTab()
					DoHideResultsTab()
					DoHideDebugTab()
					DoShowOptionsTab()
					_GUICtrlTab_SetCurFocus($tabSet, _GUICtrlTab_FindTab($tabSet, "Options"))
				Case "Search Results"
					DoHideBiomesTab()
					DoHideStructuresTab()
					DoHideOptionsTab()
					DoHideDebugTab()
					DoShowResultsTab()
					_GUICtrlTab_SetCurFocus($tabSet, _GUICtrlTab_FindTab($tabSet, "Search Results"))
				Case "Debug"
					DoHideBiomesTab()
					DoHideStructuresTab()
					DoHideOptionsTab()
					DoHideResultsTab()
					DoShowDebugTab()
					_GUICtrlTab_SetCurFocus($tabSet, _GUICtrlTab_FindTab($tabSet, "Debug"))
				Case Else
					; Do nothing
			EndSwitch
		EndIf
		
		
		
		#cs
		; Show a tooltip for biome group items in the AvailableBiomeList
		If $enableBiomeGroups = 1 Then
			; Tooltip on hover
			Dim $cursorInfo = GUIGetCursorInfo($form)
			
			If $cursorInfo[4] = GUICtrlGetHandle($availableBiomeList) Then
				;Dim $itemIndex = _GUICtrlListBox_ItemFromPoint($availableBiomeList, $cursorInfo[0] - 8, $cursorInfo[1] - 55)
				Dim $itemIndex = _GUICtrlListBox_GetSelItems($availableBiomeList)
				If UBound($itemIndex) <> 2 Then
					ToolTip("")
				Else
					Dim $itemText = _GUICtrlListBox_GetText($availableBiomeList, $itemIndex[1])
					Dim $itemLeft3Letters = StringLeft($itemText, 3)
					If $itemLeft3Letters = "Any" Or $itemLeft3Letters = "All" Then
						Dim $index = _ArraySearch($biomeGroupArray, $itemText)
						Dim $tooltip = $biomeGroupArray[$index][1]
						ToolTip($tooltip)
					EndIf
				EndIf
			Else
				ToolTip("")
			EndIf
		Else
			ToolTip("")
		EndIf
		#ce
	Wend
EndFunc

Main()