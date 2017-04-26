; =============================================================================
; Amidst Seed Hunter - Search Functions (SearchFunctions.au3)
;
; Author: 	Azuntik (seedhunter@azuntik.com)
; Date:		2017.4.22
; Download: https://github.com/azuntik/Amidst-Seed-Hunter/releases
; License:	CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
;
; For use with Amidst v4.2 (https://github.com/toolbox4minecraft/amidst).
; =============================================================================

Func StopExecution()
	DebugWrite("Terminate loop signal received. Finishing current loop and exiting")
EndFunc

Func ResetHotKey()
	; Don't do anything
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

Func EvaluateSeed($seed, $criteriaArray, $listArray, $include)
	Dim $reason, $index, $searchColor
	Dim $windowDims = GetAmidstWindowDimensions()
	
	If $windowDims = -1 Then
		DoClearResultsEdit(False)
		Return -1
	EndIf
	
	SetError(0)
	
	For $i = 1 to UBound($criteriaArray) - 1
		$index = _ArraySearch($listArray, $criteriaArray[$i])
		$searchColor = $listArray[$index][1]
		DebugWrite("Searching for " & $criteriaArray[$i] & " (" & $searchColor & ")")
		WinActivate($amidstWindowTitle)
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
	Dim $numIncluded, $numExcluded, $timer, $time, $hours, $minutes, $seconds
	Dim $searchColor, $index, $currentSeed, $handle, $reason, $numSeedsInFile
	Dim $includedBiomesSearchArray = []
	Dim $excludedBiomesSearchArray = []
	Dim $includedStructsSearchArray = []
	Dim $excludedStructsSearchArray = []
	Dim $searchCount = 0
	Dim $seedsFoundCount = 0
	Dim $rejected = False
	
	$newSearch = True
	
	If $guidedAmidstSetup = 1 And $amidstSetupComplete = False Then
		$amidstSetupComplete = DoGuidedAmidstSetup()
		If $amidstSetupComplete = False Then
			Return
		EndIf
	EndIf
	
	If $showResultsTab = 1 And $enableDebugging = 0 Then
		DoHideBiomesTab()
		DoHideStructuresTab()
		DoHideOptionsTab()
		DoHideDebugTab()
		DoShowResultsTab()
		_GUICtrlTab_SetCurFocus($tabSet, _GUICtrlTab_FindTab($tabSet, "Search Results"))
	ElseIf $enableDebugging = 1 Then
		DoHideBiomesTab()
		DoHideStructuresTab()
		DoHideOptionsTab()
		DoHideResultsTab()
		DoShowDebugTab()
		_GUICtrlTab_SetCurFocus($tabSet, _GUICtrlTab_FindTab($tabSet, "Debug"))
	EndIf
	
	ResultsWrite("Seed search initiated " & GetTimestamp() & @CRLF)
	
	If $useRandomSeeds = 0 Then
		ResultsWrite("Seed source: File")
		ResultsWrite("Seed list file: " & $seedListFile)
		ResultsWrite($seedFileInfo)
		ResultsWrite("Seed offset: " & String($seedOffset))
		$numSeedsInFile = _FileCountLines($seedListFile)
		If $seedOffset >= $numSeedsInFile Then
			ResultsWrite("Seed offset is greater than number of seeds in file. Offset will be reset to 0.")
			$seedOffset = 0
		EndIf
		DebugWrite(@CRLF & "Seed list file: " & $seedListFile)
	Else
		ResultsWrite("Seed source: Random" & @CRLF)
	EndIf
	
	ResultsWrite("Max. seeds to evaluate: " & ($maxSeedsToEvaluate = 0 ? "∞" : String($maxSeedsToEvaluate)))
	ResultsWrite("Number of seeds to find: " & ($seedsToFind = 0 ? "∞" : String($seedsToFind)))
	
	If $maxSeedsToEvaluate = 0 And $useRandomSeeds = 0 And $seedsToFind > 0 Then
		ResultsWrite(@CRLF & "Search will continue until " & $seedsToFind & " seed" & ($seedsToFind = 1 ? " is " : "s are ") & "found or all seeds are exhausted.")
	ElseIf $maxSeedsToEvaluate = 0 And $useRandomSeeds = 0 And $seedsToFind = 0 Then
		ResultsWrite(@CRLF & "Search will continue until all seeds matching the criteria above are found in the seed list file (" & StringRegExpReplace(String($numSeedsInFile), '(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))', '\1,') & ($numSeedsInFile = 1 ? " seed" : " seeds") & "). Press ESC to terminate early.")
	ElseIf $maxSeedsToEvaluate = 0 And $useRandomSeeds = 1 And $seedsToFind = 0 Then
		ResultsWrite(@CRLF & "Search will continue until terminated by the user. Press ESC to terminate.")
	ElseIf $maxSeedsToEvaluate = 0 And $useRandomSeeds = 1 And $seedsToFind > 0 Then
		ResultsWrite(@CRLF & "Search will continue until " & $seedsToFind & " seed" & ($seedsToFind = 1 ? " is " : "s are ") & "found. Press ESC to terminate early.")
	ElseIf $maxSeedsToEvaluate > 0 And $useRandomSeeds = 0 And $seedsToFind = 0 Then
		ResultsWrite(@CRLF & StringRegExpReplace(String($maxSeedsToEvaluate), '(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))', '\1,') & ($numSeedsInFile = 1 ? " seed" : " seeds") & " will be evaluated and any seeds matching your criteria will be listed.")
	ElseIf $maxSeedsToEvaluate > 0 And $useRandomSeeds = 1 And $seedsToFind = 0 Then
		ResultsWrite(@CRLF & "Search will continue until " & $maxSeedsToEvaluate & " seed" & ($seedsToFind = 1 ? " is " : "s are ") & "evaluated. Press ESC to terminate early.")
	EndIf

	If $includeRejectedSeeds = 1 Then
		ResultsWrite(@CRLF & "Rejected seeds are included in results below.")
		DebugWrite("Including rejected seeds")
	EndIf
	
	ResultsWrite(@CRLF & "Search Criteria:" & @CRLF & "====================")
	DebugWrite("Getting biome criteria")
	If $searchForBiomes = 1 Then
		$numIncluded = _GUICtrlListBox_GetListBoxInfo($includedBiomeList)
		$numExcluded = _GUICtrlListBox_GetListBoxInfo($excludedBiomeList)
		DoSelectAllListItems($includedBiomeList)
		$includedBiomesSearchArray = _GUICtrlListBox_GetSelItemsText($includedBiomeList)
		ResultsWrite("Included Biomes:")
		DebugWrite("Included biomes")
		If UBound($includedBiomesSearchArray) = 1 Then
			ResultsWrite("- None")
			DebugWrite("None")
		Else
			For $i = 1 To UBound($includedBiomesSearchArray) - 1
				ResultsWrite("- " & $includedBiomesSearchArray[$i])
				DebugWrite($includedBiomesSearchArray[$i])
			Next
		EndIf
		DoSelectAllListItems($excludedBiomeList)
		$excludedBiomesSearchArray = _GUICtrlListBox_GetSelItemsText($excludedBiomeList)
		ResultsWrite("Excluded Biomes:")
		DebugWrite("Excluded biomes")
		If UBound($excludedBiomesSearchArray) = 1 Then
			ResultsWrite("- None")
			DebugWrite("None")
		Else
			For $i = 1 To UBound($excludedBiomesSearchArray) - 1
				ResultsWrite("- " & $excludedBiomesSearchArray[$i])
				DebugWrite($excludedBiomesSearchArray[$i])
			Next
		EndIf
	Else
		DebugWrite("No biomes selected")
	EndIf

	DebugWrite("Getting structure criteria")
	If $searchForStructures = 1 Then
		$numIncluded = _GUICtrlListBox_GetListBoxInfo($includedStructList)
		$numExcluded = _GUICtrlListBox_GetListBoxInfo($excludedStructList)
		DoSelectAllListItems($includedStructList)
		$includedStructsSearchArray = _GUICtrlListBox_GetSelItemsText($includedStructList)
		ResultsWrite("Included Structures:")
		DebugWrite("Included structures")
		If UBound($includedStructsSearchArray) = 1 Then
			ResultsWrite("- None")
			DebugWrite("None")
		Else
			For $i = 1 To UBound($includedStructsSearchArray) - 1
				ResultsWrite("- " & $includedStructsSearchArray[$i])
				DebugWrite($includedStructsSearchArray[$i])
			Next
		EndIf
		DoSelectAllListItems($excludedStructList)
		$excludedStructsSearchArray = _GUICtrlListBox_GetSelItemsText($excludedStructList)
		ResultsWrite("Excluded Structures:")
		DebugWrite("Excluded structures")
		If UBound($excludedStructsSearchArray) = 1 Then
			ResultsWrite("- None")
			DebugWrite("None")
		Else
			For $i = 1 To UBound($excludedStructsSearchArray) - 1
				ResultsWrite("- " & $excludedStructsSearchArray[$i])
				DebugWrite($excludedStructsSearchArray[$i])
			Next
		EndIf
	Else
		DebugWrite("No structures selected")
	EndIf
	
	; False positives warning
	If $searchForBiomes = 1 And $searchForStructures = 1 And (_ArraySearch($includedBiomesSearchArray, "Extreme Hills") Or _ArraySearch($includedBiomesSearchArray, "Extreme Hills M") Or _ArraySearch($includedBiomesSearchArray, "Ice Mountains") Or _ArraySearch($includedBiomesSearchArray, "Ice Plains") Or _ArraySearch($excludedBiomesSearchArray, "Extreme Hills") Or _ArraySearch($excludedBiomesSearchArray, "Extreme Hills M") Or _ArraySearch($excludedBiomesSearchArray, "Ice Mountains") Or _ArraySearch($excludedBiomesSearchArray, "Ice Plains")) Then
		_WinAPI_MessageBoxCheck(BitOR($MB_OK, $MB_ICONQUESTION), "Possible False Positives/Negatives", "Warning: Searching for certain biomes (Extreme Hills, Extreme Hills M, Ice Mountains, Ice Plains) can generate false positives/negatives when also searching for structures." & @CRLF & @CRLF & "When searching for these biomes (included or excluded), we recommend double-checking any results to eliminate these possible false results", "{3AC815B9-2394-4E3C-92CA-E51BCBDEDE16}", $IDOK)
		ResultsWrite(@CRLF & "WARNING: There is a (small) possibility of false positives/negatives in these search results. Manual evaluation is recommended.")
	EndIf
	
	_WinAPI_MessageBoxCheck(BitOR($MB_OK, $MB_ICONINFORMATION), "Beginning Search", "Depending on your search criteria, this process can take a long time." & @CRLF & @CRLF & "To end execution early, press ESC.", "{2D6A1CA1-EE2B-4AD2-9FB8-60052F49C56B}", $IDOK)
	
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
	
	If $seedsToFind = 0 Then 
		If $maxSeedsToEvaluate = 0 Or ($useRandomSeeds = 0 And ($maxSeedsToEvaluate - $seedOffset) < $numSeedsInFile) Then
			MsgBox(0,"","MaxSeeds = " & $maxSeedsToEvaluate & @CRLF & "SeedOffset = " & $seedOffset & @CRLF & "NumSeedsInFile = " & $numSeedsInFile)
			$maxSeedsToEvaluate = $numSeedsInFile - $seedOffset
		EndIf
	EndIf

	$timer = TimerInit()
	
	; Hotkeys are set here to avoid interference with other programs as much as possible
	HotKeySet("{ESC}", "StopExecution")
	HotKeySet("{BACKSPACE}", "ResetHotkey")
	
	; Search loop
	While 1
		If @HotKeyPressed = "{ESC}" Then ExitLoop
		
		; If seedsToFind is 0, keep searching until you run out of seeds
		If $seedsFoundCount >= $seedsToFind And $seedsToFind > 0 Then ExitLoop
		
		; If maxSeeds is 0, keep searching until you find all the seeds requested
		If $searchCount >= $maxSeedsToEvaluate And $maxSeedsToEvaluate > 0 Then ExitLoop
		
		WinActivate($amidstWindowTitle)
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
		$reason = EvaluateSeed($currentSeed, $includedBiomesSearchArray, $biomeArray, True)
		If $reason = -1 Then Return -1
		If $reason = "" Then $reason = EvaluateSeed($currentSeed, $excludedBiomesSearchArray, $biomeArray, False)
		If $reason = "" Then $reason = EvaluateSeed($currentSeed, $includedStructsSearchArray, $structArray, True)
		If $reason = "" Then $reason = EvaluateSeed($currentSeed, $excludedStructsSearchArray, $structArray, False)
		
		If $reason = "" Then
			If $includeRejectedSeeds = 0 Then
				ResultsWrite($currentSeed)
			Else
				ResultsWrite("▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀" & @CRLF & $currentSeed & @CRLF & "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄")
			EndIf
			$seedsFoundCount += 1
		Else
			If $includeRejectedSeeds = 1 Then
				ResultsWrite("Rejected: " & $currentSeed & _StringRepeat(" ", 24 - StringLen(String($currentSeed))) & $reason)
			EndIf
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
			If $seedsToFind = 0 And $useRandomSeeds = 0 Then
				GUICtrlSetData($progressLabel2, $seedsFoundCount & "/∞ seeds found")
				GUICtrlSetData($progressBar2, 100)
			Else
				GUICtrlSetData($progressLabel2, $seedsFoundCount & "/" & $seedsToFind & " seeds found")
				GUICtrlSetData($progressBar2, ($seedsFoundCount / $seedsToFind) * 100)
			EndIf
		EndIf
		
		If @HotKeyPressed = "{ESC}" Then ExitLoop
	Wend
	
	; Update offset if we're using a seed list file
	If $useRandomSeeds = 0 Then
		IniWrite($settingsINIFile, "Options", "SeedOffset", $seedOffset)
	EndIf
	
	$time = TimerDiff($timer)
	_TicksToTime($time, $hours, $minutes, $seconds)
	
	WinActivate("Amidst Seed Hunter")
	
	If $showProgressPopupWindow = 1 Then _Toast_Hide()
	
	ResultsWrite(@CRLF & "Summary:" & @CRLF & "====================")
	ResultsWrite($searchCount & " seed" & ($searchCount = 1 ? " " : "s ") & "evaluated")
	ResultsWrite($seedsFoundCount & " seed" & ($seedsFoundCount = 1 ? " " : "s ") & "found")
	ResultsWrite(Round((($searchCount - $seedsFoundCount) / $searchCount) * 100, 1) & "% rejection rate")
	ResultsWrite("Time elapsed: " & StringFormat("%02d:%02d:%02d", $hours, $minutes, $seconds))
	
	If @HotKeyPressed = "{ESC}" Then
		Dim $winCoords = WinGetPos("Amidst Seed Hunter")
		Dim $resetESCForm = GUICreate("", 250, 100, $winCoords[0] + ($winCoords[2] - 250) / 2, $winCoords[1] + ($winCoords[3] - 100) / 2, $WS_POPUP, -1, $form)
		GUICtrlCreateLabel("Search terminated early. Please press the BACKSPACE key to reset the search function.", 20, 30, 210, 80, $SS_CENTER)
		GUISetState(@SW_SHOW)
		GUISwitch($form)
		GUISetState(@SW_DISABLE)
		While @HotKeyPressed <> "{BACKSPACE}"
			; Wait for the user to press BACKSPACE
		Wend
		GUIDelete($resetESCForm)
		GUISetState(@SW_ENABLE)
		GUISwitch($form)
		;MsgBox(BitOR($MB_OK, $MB_ICONINFORMATION), "Early termination reset", "Early search termination has been reset.")
	EndIf
	
	; Unset hotkey
	HotKeySet("{ESC}") 
	HotKeySet("{BACKSPACE}")
EndFunc