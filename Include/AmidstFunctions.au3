; =============================================================================
; Amidst Seed Hunter - Amidst Functions (AmidstFunctions.au3)
;
; Author: 	Azuntik (seedhunter@azuntik.com)
; Date:		2017.4.22
; Download: https://github.com/azuntik/Amidst-Seed-Hunter/releases
; License:	CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
;
; For use with Amidst v4.2 (https://github.com/toolbox4minecraft/amidst).
; =============================================================================

Func AmidstIsRunning()
	;Return (WinExists($amidstWindowTitle) ? True : False)
	
	If WinExists($amidstWindowTitle) Then
		DebugWrite("Amidst is running")
		Return True
	Else
		DebugWrite("Amidst is not running")
		Return False
	EndIf
EndFunc

Func GetAmidstWindowDimensions()
	Dim $amidstWindow, $amidstWindowSize, $amidstClientSize, $edgeWidth, $menuHeight
	Dim $left, $top, $right, $bottom
	Dim $returnvalues[5]
	
	DebugWrite("Getting Amidst window dimensions")
	
	If AmidstIsRunning() Then
		$amidstWindow = WinGetHandle($amidstWindowTitle)
		$amidstWindowSize = WinGetPos($amidstWindow)
		$amidstClientSize = WinGetClientSize($amidstWindow)
		$edgeWidth = ($amidstWindowSize[2] - $amidstClientSize[0]) / 2
		$menuHeight = $amidstWindowSize[3] - $amidstClientSize[1] + 80 ; 80 pixels includes the menu and the textbox at the top of the map
		$left = $amidstWindowSize[0] + $edgeWidth
		$top = $amidstWindowSize[1] + $menuHeight
		$right = $left + $amidstClientSize[0]
		$bottom = $top + $amidstClientSize[1] - 80 - 60 ; 60 pixels removes the icon in the lower right corner from the search area
		
		DebugWrite("Search coordinates (L, T), (R, B): (" & $left & ", " & $top & "), (" & $right & ", " & $bottom & ")")
		
		$returnvalues[0] = $amidstWindow
		$returnvalues[1] = $left
		$returnvalues[2] = $top
		$returnvalues[3] = $right
		$returnvalues[4] = $bottom

		#cs 
			; The following code was used for debugging the search rectangle
			; I'm leaving it here in case I need it again at some point
			_GDIPlus_Startup()
			$screencapture = _ScreenCapture_Capture("")
			$bitmap = _GDIPlus_BitmapCreateFromHBITMAP($screencapture)
			$graphics = _GDIPlus_ImageGetGraphicsContext($bitmap)
			$pen = _GDIPlus_PenCreate(0xFF000000,3)
			_GDIPlus_GraphicsDrawRect($graphics,$left,$top,$right - $left,$bottom - $top,$pen)
			_GDIPlus_ImageSaveToFile($bitmap, @ScriptDir & "\debug_image.jpg")
			Sleep(10000)
			_GDIPlus_ImageDispose($bitmap)
			_WinAPI_DeleteObject($screencapture)
			_GDIPlus_Shutdown()
			Exit
		#ce
		
		Return $returnvalues
	Else
		If AmidstIsRunning() Then
			WinActivate($amidstWindowTitle)
			WinWaitActive($amidstWindowTitle)
		Else
			DebugWrite("Amidst is not running")
			MsgBox(BitOR($MB_OK, $MB_ICONERROR), "Amidst not running", "Amidst doesn't seem to be running." & @CRLF & @CRLF & "Please start Amidst and configure it as needed before attempting to search again." & @CRLF & @CRLF & "For help setting up Amidst, please enable 'Guided Amidst Setup' in the Options tab.")
			If $showProgressPopupWindow = 1 Then _Toast_Hide()
			DoHideBiomesTab()
			DoHideStructuresTab()
			DoHideResultsTab()
			DoHideDebugTab()
			DoShowOptionsTab()
			_GUICtrlTab_SetCurFocus($tabSet, _GUICtrlTab_FindTab($tabSet, "Options"))
			Return -1
		EndIf
	EndIf
EndFunc

Func DoGuidedAmidstSetup()
	Dim $response = MsgBox(BitOR($MB_OKCANCEL, $MB_ICONINFORMATION), "Start Amidst Guided Setup?", "Amidst Seed Hunter will now guide you through setting up Amidst to best work with your search criteria." & @CRLF & @CRLF & "If you want to skip this guided setup and take care of it yourself, you may cancel now. After you've got things set up the way you want, click 'Begin Search' again to start your search." & @CRLF & @CRLF & "You may also disable guided Amidst setup in the Options tab.")
	Dim $toast, $downloadButton, $button, $msg
	
	DebugWrite("Starting guided Amidst setup")
		
	If $response = $IDCANCEL Then
		DebugWrite("Guided setup canceled")
		Return True
	EndIf
	
	If AmidstIsRunning() = False And FileExists(@ScriptDir & "\amidst-v4-2.exe") Then
		DebugWrite("Amidst found. Starting automatically.")
		$msg = "I found Amidst in the working directory. I'll run it for you."
		$toast = _Toast_Show(0, "Amidst EXE found!", $msg, -5, False)
		Run(@ScriptDir & "\amidst-v4-2.exe")
		Sleep(5000)
	EndIf
	
	_Toast_Set(Default)
	
	; Start Amidst
	While AmidstIsRunning() = False
		If WinExists("Profile Selector") Then
			DebugWrite("Amidst is running, but user needs to select a profile")
			$msg = "Amidst is running, but you have to select your Minecraft profile before you proceed."
			$msg &= @CRLF & @CRLF & "If you don't see a Minecraft profile, you will need to install Minecraft first. You can try searching again after you've done that."
			$toast = _Toast_Show(0, "Choose your Minecraft profile", $msg)
			
			While WinExists("Profile Selector")
				; Wait for the user to select the profile
			Wend
		Else
			DebugWrite("Amidst isn't running")
			$toast = _Toast_Show(0, "Amidst Guided Setup", "Amidst doesn't appear to be running. If you have not downloaded Amidst, that's your first step. You'll need to download and run " & $amidstWindowTitle & ". You can search for it online, or just click here:" & @CRLF & @CRLF & @CRLF & @CRLF & "When it's running, click 'Next Step'." & @CRLF & @CRLF)
			$downloadButton = GUICtrlCreateButton("Download " & $amidstWindowTitle, ($toast[0] - 140) / 2, $toast[1] - 95, 140, 25, $BS_FLAT)
			$button = GUICtrlCreateButton("Next Step", ($toast[0] - 90) / 2, $toast[1] - 35, 90, 25)
		
			While 1
				Switch GUIGetMsg()
					Case $button
						ExitLoop
					Case $downloadButton
						DebugWrite("Launching browser to download Amidst")
						ShellExecute("https://git.io/v9LQc")
				EndSwitch
			Wend
		EndIf
	WEnd
	
	DebugWrite("Continuing guided setup")
	; Get a map (random seed)
	$msg = "Good! Amidst is running! Time to start configuring it." & @CRLF & @CRLF 
	$msg &= "First things first, let's get a map in there. Click the 'File' menu and choose "
	$msg &= "'New from random seed' or just press CTRL+R." & @CRLF & @CRLF
	$msg &= "When you're done, click 'Next Step'" & @CRLF & @CRLF
	$toast = _Toast_Show(0, "Amidst is running!", $msg)
	$button = GUICtrlCreateButton("Next Step", ($toast[0] - 90) / 2, $toast[1] - 35, 90, 25)
	While 1
		Switch GUIGetMsg()
			Case $button
				ExitLoop
		EndSwitch
	WEnd
	
	; Turn on grid
	$msg = "Now that we have a map to play with, click on the 'Layers' menu and turn on the Grid, "
	$msg &= "if it isn't already on." & @CRLF & @CRLF
	$msg &= "When you're done, click 'Next Step'" & @CRLF & @CRLF
	$toast = _Toast_Show(0, "Configuring Amidst", $msg)
	$button = GUICtrlCreateButton("Next Step", ($toast[0] - 90) / 2, $toast[1] - 35, 90, 25)
	While 1
		Switch GUIGetMsg()
			Case $button
				ExitLoop
		EndSwitch
	WEnd
	
	; Adjust zoom and window size
	$msg = "This next step is critical to getting the results you want. We're going to adjust the "
	$msg &= "zoom and window size so that we're only searching the area we care about." & @CRLF & @CRLF
	$msg &= "You can use the scroll wheel on your mouse to zoom in and out. The keyboard shortcuts "
	$msg &= "CTRL+G (zoom in) and CTRL+H (zoom out) also work." & @CRLF & @CRLF
	$msg &= "You can drag the map around in the window using the mouse. Your goal is to get the grid "
	$msg &= "that you want to search inside to fit just under the info window in the upper left and the "
	$msg &= "square icon on the lower right. You'll need to adjust the window size, as well." & @CRLF & @CRLF
	$msg &= "Complicated, I know, but when you're done, you should only be able to see the area you want "
	$msg &= "to search, plus a little on the top and bottom. That extra space doesn't get searched, though, "
	$msg &= "so don't worry." & @CRLF & @CRLF
	$msg &= "When you're done, click 'Next Step'" & @CRLF & @CRLF
	$toast = _Toast_Show(0, "Configuring Amidst", $msg)
	$button = GUICtrlCreateButton("Next Step", ($toast[0] - 90) / 2, $toast[1] - 35, 90, 25)
	While 1
		Switch GUIGetMsg()
			Case $button
				ExitLoop
		EndSwitch
	WEnd
	
	; Turn off the grid and turn on other layers that might be needed
	$msg = "We're almost ready to start our search! Our last step is to turn off the layers we don't need "
	$msg &= "and turn on the layers we do need. First things first: turn off the grid. (Layers menu, in "
	$msg &= "case you forgot)."  & @CRLF & @CRLF
	If $searchForStructures = 0 Then
		$msg &= "While you're there, go ahead and turn off all the other layers. You're not searching for "
		$msg &= "structures, so you don't need them."  & @CRLF & @CRLF
	Else
		$msg &= "While you're there, you'll need to turn on 'Stronghold Icons', 'Village Icons', "
		$msg &= "'Temple/Witch Hut Icons', 'Mineshaft Icons', 'Ocean Monument Icons', and 'Nether Fortress Icons'."
		$msg &= @CRLF & @CRLF & "If you know you're not searching for, say Mineshafts, you can turn off the items "
		$msg &= "you don't need." & @CRLF & @CRLF
	EndIf
	$msg &= "When you're done, click 'Next Step'" & @CRLF & @CRLF
	$toast = _Toast_Show(0, "Configuring Amidst", $msg)
	$button = GUICtrlCreateButton("Next Step", ($toast[0] - 90) / 2, $toast[1] - 35, 90, 25)
	While 1
		Switch GUIGetMsg()
			Case $button
				ExitLoop
		EndSwitch
	WEnd
	
	; We're done!
	$msg = "You're done! As long as you followed the preceeding steps correctly, you should be ready to "
	$msg &= "search for the seed of your dreams!" & @CRLF & @CRLF
	$msg &= "Before we do that, though, here's one last chance to get everything set up the way you want "
	$msg &= "before we start. When you're ready, click 'Next Step'" & @CRLF & @CRLF
	$toast = _Toast_Show(0, "You're done!", $msg)
	$button = GUICtrlCreateButton("Next Step", ($toast[0] - 90) / 2, $toast[1] - 35, 90, 25)
	While 1
		Switch GUIGetMsg()
			Case $button
				ExitLoop
		EndSwitch
	WEnd
	
	_Toast_Hide()
	
	$amidstSetupComplete = True
	
	DebugWrite("Guided setup complete")
	Return True
EndFunc