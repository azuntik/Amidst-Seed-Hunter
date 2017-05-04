; =============================================================================
; Amidst Seed Hunter - Presets (ASH_Presets.au3)
;
; Author: 	Azuntik
; Date:		2017.5.2
; License:	CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
;
; This file is part of the Amidst Seed Hunter project
; =============================================================================

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

Func DoRemovePreset($preset, $prompt = False)
	Dim $arrayOffset, $response
	
	If $prompt Then
		$response = _WinAPI_MessageBoxCheck(BitOR($MB_YESNO, $MB_ICONQUESTION), "Remove preset", "You are about to remove this preset. This action cannot be undone." & @CRLF & @CRLF & "Are you sure?", "{E0E777CD-DA7B-40E0-9ECC-9ADD4F2BE0E9}", $IDYES)
	Else
		$response = $IDYES
	EndIf
	
	If $response = $IDYES Then
		IniWrite($settingsINIFile, "Presets", "Preset" & $preset & "Name", "")
		IniWrite($settingsINIFile, "Presets", "Preset" & $preset & "Include", "")
		IniWrite($settingsINIFile, "Presets", "Preset" & $preset & "Exclude", "")
		
		$arrayOffset = $preset * 3 + 1 ; Each preset takes 3 rows, starting with row 1
		
		$presetArray[$arrayOffset][1] = ""
		$presetArray[$arrayOffset + 1][1] = ""
		$presetArray[$arrayOffset + 2][1] = ""
	
		DebugWrite("Preset " & $preset & " removed")
	EndIf
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