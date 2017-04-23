; =============================================================================
; Amidst Seed Hunter
;
; Author: 	Azuntik (seedhunter@azuntik.com)
; Download:
; License:	CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
;
; For use with Amidst v4.2 (https://github.com/toolbox4minecraft/amidst).
; =============================================================================

#include <GUIConstantsEx.au3>
#include <GuiListBox.au3>
#include <MsgBoxConstants.au3>
#include <ListBoxConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <Clipboard.au3>
#include <Misc.au3>
#include <UpDownConstants.au3>
#include <ProgressConstants.au3>
#include <File.au3>
;#include <GDIPlus.au3>
;#include <ScreenCapture.au3>
#include "Toast.au3"

HotKeySet("{ESC}","dummy") ; For early termination of the search loop
Func dummy()
EndFunc

Global $biomeslistarray[76][2] = [['Beach',0xFADE55],['Beach M',0xFFFF7D],['Birch Forest',0x307444],['Birch Forest Hills',0x1F5F32],['Birch Forest Hills M',0x47875A],['Birch Forest M',0x589C6C],['Cold Beach',0xFAF0C0],['Cold Beach M',0xFFFFE8],['Cold Taiga',0x31554A],['Cold Taiga Hills',0x243F36],['Cold Taiga Hills M',0x4C675E],['Cold Taiga M',0x597D72],['Deep Ocean',0x000030],['Deep Ocean M',0x282858],['Desert',0xFA9418],['Desert Hills',0xD25F12],['Desert Hills M',0xFA873A],['Desert M',0xFFBC40],['Extreme Hills+',0x507050],['Extreme Hills',0x606060],['Extreme Hills Edge',0x72789A],['Extreme Hills Edge M',0x9AA0C2],['Extreme Hills M',0x888888],['Extreme Hills+ M',0x789878],['Flower Forest',0x2D8E49],['Forest',0x056621],['Forest Hills',0x22551C],['Forest Hills M',0x4A7D44],['Frozen Ocean',0x9090A0],['Frozen Ocean M',0xB8B8C8],['Frozen River',0xA0A0FF],['Frozen River M',0xC8C8FF],['Ice Mountains',0xA0A0A0],['Ice Mountains M',0xC8C8C8],['Ice Plains',0xFFFFFF],['Ice Plains Spikes',0xB4DCDC],['Jungle',0x537B09],['Jungle Edge',0x628B17],['Jungle Edge M',0x8AB33F],['Jungle Hills',0x2C4205],['Jungle Hills M',0x546A2D],['Jungle M',0x7BA331],['Mega Spruce Taiga',0x818E79],['Mega Spruce Taiga (Hills)',0x6D7766],['Mega Taiga',0x596651],['Mega Taiga Hills',0x454F3E],['Mesa',0xD94515],['Mesa (Bryce)',0xFF6D3D],['Mesa Plateau',0xCA8C65],['Mesa Plateau F',0xB09765],['Mesa Plateau F M',0xD8BF8D],['Mesa Plateau M',0xF2B48D],['Mushroom Island',0xFF00FF],['Mushroom Island M',0xFF28FF],['Mushroom Island Shore',0xA000FF],['Mushroom Island Shore M',0xC828FF],['Ocean',0x000070],['Ocean M',0x282898],['Plains',0x8DB360],['River',0x0000FF],['River M',0x2828FF],['Roofed Forest',0x40511A],['Roofed Forest M',0x687942],['Savanna',0xBDB25F],['Savanna M',0xE5DA87],['Savanna Plateau',0xA79D64],['Savanna Plateau M',0xCFC58C],['Stone Beach',0xA2A284],['Stone Beach M',0xCACAAC],['Sunflower Plains',0xB5DB88],['Swampland',0x07F9B2],['Swampland M',0x2FFFDA],['Taiga',0x0B6659],['Taiga Hills',0x163933],['Taiga Hills M',0x3E615B],['Taiga M',0x338E81]]
Global $version = 0.1

Func BuildGUI()
   GUICreate("Amidst Seed Hunter v" & $version,500,508)

   GUICtrlCreateLabel("Biomes",10,8)
   GUICtrlCreateLabel("Include",294,8)
   GUICtrlCreateLabel("Exclude",294,241)
   GUICtrlCreateLabel("Max. Seeds to Search:",165,480)

   Global $biomeslist = GUICtrlCreateList("",8,25,200,450,BitOR($LBS_SORT,$LBS_DISABLENOSCROLL,$LBS_EXTENDEDSEL,$WS_VSCROLL))

   For $i = 0 To UBound($biomeslistarray) - 1
	  GUICtrlSetData($biomeslist,$biomeslistarray[$i][0])
   Next

   Global $includelist = GUICtrlCreateList("",292,25,200,220,BitOR($LBS_SORT,$LBS_DISABLENOSCROLL,$LBS_EXTENDEDSEL,$WS_VSCROLL))
   Global $excludelist = GUICtrlCreateList("",292,258,200,220,BitOR($LBS_SORT,$LBS_DISABLENOSCROLL,$LBS_EXTENDEDSEL,$WS_VSCROLL))

   Global $includebutton = GUICtrlCreateButton("Include ->",215,93,70,25)
   Global $removeincludedbutton = GUICtrlCreateButton("<- Remove",215,123,70,25)
   Global $removeallincludedbutton = GUICtrlCreateButton("Remove All",215,153,70,25)
   Global $excludebutton = GUICtrlCreateButton("Exclude ->",215,326,70,25)
   Global $removeexcludedbutton = GUICtrlCreateButton("<- Remove",215,356,70,25)
   Global $removeallexcludedbutton = guictrlcreatebutton("Remove All",215,386,70,25)

   Global $cancelquitbutton = GUICtrlCreateButton("Cancel/Quit",8,475,95,25)
   Global $beginsearchbutton = GUICtrlCreateButton("Begin Search",397,475,95,25)

   Global $searchmax = GUICtrlCreateInput("100",280,477,60,20)
   GUICtrlCreateUpdown(-1,$UDS_NOTHOUSANDS + $UDS_ALIGNRIGHT + $UDS_SETBUDDYINT)
   GUICtrlSetLimit(-1,1000,1)

   GUISetState(@SW_SHOW)
EndFunc

Func MoveListItems($fromlist,$tolist)
   If _GUICtrlListBox_GetSelCount($fromlist) <= 0 Then
	  MsgBox($MB_ICONSTOP + $MB_OK,"Nothing selected","Please select one or more items before clicking a button.")
   Else
	  $selected = _GUICtrlListBox_GetSelItemsText($fromlist)
	  $selectedindices = _GUICtrlListBox_GetSelItems($fromlist)
	  For $i = 1 To UBound($selected) - 1
		 _GUICtrlListBox_AddString($tolist,$selected[$i])
	  Next
	  For $i = UBound($selectedindices) - 1 to 1 step -1
		 _GUICtrlListBox_DeleteString($fromlist,$selectedindices[$i])
	  Next
   EndIf
EndFunc

Func GetAmidstWindowDimensions($windowtitle)
   If WinExists($windowtitle) Then
	  MsgBox($MB_OK + $MB_ICONINFORMATION, "Configure Amidst", "If you need to make changes to Amidst's configuration, please do so now. When you're done, click OK to continue.")
   EndIf

   If WinExists($windowtitle) Then
	  WinActivate($windowtitle)
   ElseIf WinExists("Profile Selector") Then
	  MsgBox($MB_OK + $MB_ICONINFORMATION, "Select a Profile", "Amidst appears to be running, but you haven't selected a profile yet. Execution will continue after your selection.")
	  WinActivate("Profile Selector")
	  WinWaitActive($windowtitle)
   Else
	  $response = MsgBox($MB_OK + $MB_ICONINFORMATION, "Amidst is not running", "Amidst is not running. Please locate the Amidst executable and this script will launch it for you.")
	  $amidstPath = FileOpenDialog("Locate Amidst Executable","c:\","Executables (*.exe)",$FD_FILEMUSTEXIST + $FD_PATHMUSTEXIST)
	  $response = MsgBox($MB_OK + $MB_ICONINFORMATION, "Starting Amidst...", "Amidst will now launch. If the Profile Selector appears, please choose the desired profile. Execution will continue after your selection.")
	  Run($amidstPath)
	  WinWaitActive($windowtitle)
	  MsgBox($MB_OK + $MB_ICONINFORMATION, "Configure Amidst", "If you need to make changes to Amidst's configuration, please do so now. When you're done, click OK to continue.")
   EndIf

   $amidstWindow = WinGetHandle($windowtitle)

   $amidstWindowSize = WinGetPos($amidstWindow)
   $amidstClientSize = WinGetClientSize($amidstWindow)
   $edgewidth = ($amidstWindowSize[2] - $amidstClientSize[0]) / 2
   $menuheight = $amidstWindowSize[3] - $amidstClientSize[1] + 80 ; 80 pixels includes the menu and the textbox at the top of the map
   $left = $amidstWindowSize[0] + $edgewidth
   $top = $amidstWindowSize[1] + $menuheight
   $right = $left + $amidstClientSize[0]
   $bottom = $top + $amidstClientSize[1] - 80 - 60 ; 60 pixels removes the icon in the lower right corner from the search area

   Dim $returnvalues[5]
   $returnvalues[0] = $amidstWindow
   $returnvalues[1] = $left
   $returnvalues[2] = $top
   $returnvalues[3] = $right
   $returnvalues[4] = $bottom

   ; The following code was used for debugging the search rectangle
   ;_GDIPlus_Startup()
   ;$screencapture = _ScreenCapture_Capture("")
   ;$bitmap = _GDIPlus_BitmapCreateFromHBITMAP($screencapture)
   ;$graphics = _GDIPlus_ImageGetGraphicsContext($bitmap)
   ;$pen = _GDIPlus_PenCreate(0xFF000000,3)
   ;_GDIPlus_GraphicsDrawRect($graphics,$left,$top,$right - $left,$bottom - $top,$pen)
   ;_GDIPlus_ImageSaveToFile($bitmap, @MyDocumentsDir & "\debug_image.jpg")
   ;Sleep(10000)
   ;_GDIPlus_ImageDispose($bitmap)
   ;_WinAPI_DeleteObject($screencapture)
   ;_GDIPlus_Shutdown()
   ;Exit

   Return $returnvalues

EndFunc

Func SearchBiomes($include,$exclude,$maxseeds)
   $windowdims = GetAmidstWindowDimensions("Amidst v4.2")

   ConsoleWrite("Compiling biomes to search for..." & @CRLF)

   ConsoleWrite("Included biomes:" & @CRLF)
   If $include = 0 Then
	  ConsoleWrite("None" & @CRLF)
	  $includecolors = 0
   Else
	  Dim $includecolors[UBound($include)]
	  For $i = 1 To UBound($include) - 1
		 ConsoleWrite($include[$i])
		 $index = _ArraySearch($biomeslistarray, $include[$i])
		 $includecolors[$i] = $biomeslistarray[$index][1]
		 ConsoleWrite(" (" & $includecolors[$i] & ")" & @CRLF)
	  Next
   EndIf

   ConsoleWrite("Excluded biomes:" & @CRLF)
   If $exclude = 0 Then
	  ConsoleWrite("None" & @CRLF)
	  $excludecolors = 0
   Else
	  Dim $excludecolors[UBound($exclude)]
	  For $i = 1 To UBound($exclude) - 1
		 ConsoleWrite($exclude[$i])
		 $index = _ArraySearch($biomeslistarray,$exclude[$i])
		 $excludecolors[$i] = $biomeslistarray[$index][1]
		 ConsoleWrite(" (" & $excludecolors[$i] & ")" & @CRLF)
	  Next
   EndIf

   MsgBox($MB_OK + $MB_ICONINFORMATION, "Beginning Search", "Depending on your search criteria, this process can take a long time." & @CRLF & @CRLF & "To end execution early, press ESC.")

   $seedfound = False
   $searchcount = 0

   _Toast_Set(Default)
   $toast = _Toast_Show(0, "", "Amidst Seed Hunter" & @CRLF & "Search Progress" & @CRLF & @CRLF & @CRLF, 0)
   $progressbar = GUICtrlCreateProgress(10, 68, $toast[0] - 20, 20)
   $progresslabel = GUICtrlCreateLabel($searchcount & "/" & $maxseeds, $toast[0] / 2 - 20, 45)

   While $seedfound = False And $searchcount < $maxseeds
	  If @HotKeyPressed = "{ESC}" Then ExitLoop ; ESC will terminate the loop early

	  WinActivate("Amidst v4.2")

	  ConsoleWrite("Evaluating new random seed... ")
	  Send("^r") ; New random seed
	  Sleep(1500)

	  $searchcount += 1

	  GUICtrlSetData($progressbar, ($searchcount / $maxseeds) * 100)
	  GUICtrlSetData($progresslabel, $searchcount & "/" & $maxseeds)

	  ConsoleWrite("Attempt " & $searchcount & @CRLF)

	  $seedrejected = True

	  SetError(0)

	  If $excludecolors = 0 Then
		 ConsoleWrite("No excluded biomes selected" & @CRLF)
		 $seedrejected = False
	  Else
		 ConsoleWrite("Checking for excluded biomes..." & @CRLF)
		 For $i = 1 to UBound($excludecolors) - 1
			WinActivate("Amidst v4.2")
			$coord = PixelSearch($windowdims[1], $windowdims[2], $windowdims[3], $windowdims[4], $excludecolors[$i], 0, 1, $windowdims[0])
			If @error = 1 Then ; Not found, which is what we want
			   $seedrejected = False
			   SetError(0)
			Else
			   ConsoleWrite("Excluded biome found: " & $excludecolors[$i] & @CRLF & "Rejecting seed..." & @CRLF)
			   $seedrejected = True
			   ExitLoop
			EndIf
		 Next
	  EndIf

	  SetError(0)

	  If $seedrejected = False Then
		 ConsoleWrite("No excluded biomes found." & @CRLF)
		 If $includecolors = 0 Then
			ConsoleWrite("No included biomes selected" & @CRLF)
			$seedrejected = False
		 Else
			ConsoleWrite("Checking for included biomes..." & @CRLF)
			For $i = 1 to UBound($includecolors) - 1
			   WinActivate("Amidst v4.2")
			   $coord = PixelSearch($windowdims[1], $windowdims[2], $windowdims[3], $windowdims[4], $includecolors[$i], 0, 1, $windowdims[0])
			   If @error = 1 Then ; Not found, which is not what we want
				  ConsoleWrite("Included biome not found: " & $includecolors[$i] & @CRLF & "Rejecting seed..." & @CRLF)
				  $seedrejected = True
				  ExitLoop
			   Else
				  $seedrejected = False
				  SetError(0)
			   EndIf
			Next
		 EndIf
	  EndIf

	  If $seedrejected = False Then
		 ConsoleWrite("All included biomes found." & @CRLF)
		 GUICtrlSetData($progressbar, 100)
		 _ClipBoard_Empty()
		 _ClipBoard_SetData("", $CF_TEXT)
		 Sleep(1500)
		 WinActivate("Amidst v4.2")
		 Send("^c") ; Copy seed to clipboard
		 Sleep(1500)
		 $seed = _ClipBoard_GetData($CF_TEXT)
		 ConsoleWrite("Seed found! " & $seed)
		 ExitLoop
	  EndIf

	  ConsoleWrite("=========================" & @CRLF & @CRLF)
   WEnd

   _Toast_Hide()

   If $seedrejected = False Then
	  MsgBox($MB_OK + $MB_ICONINFORMATION,"Seed found!","After searching " & $searchcount & " seeds, a seed matching your criteria has been found!" & @CRLF & @CRLF & $seed & @CRLF & @CRLF & "It has been copied to the clipboard.")
   Else
	  MsgBox($MB_OK + $MB_ICONINFORMATION,"Seed not found",$searchcount & " seeds evaluated. A seed matching your criteria could not be found before the search was terminated. Sorry.")
   EndIf

   WinActivate("Amidst Seed Hunter v" & $version)

   Return $seed
EndFunc

BuildGUI()

While 1
   Switch GUIGetMsg()
	  Case $GUI_EVENT_CLOSE
		 Exit
	  Case $cancelquitbutton
		 Exit
	  Case $includebutton
		 MoveListItems($biomeslist,$includelist)
	  Case $excludebutton
		 MoveListItems($biomeslist,$excludelist)
	  Case $removeincludedbutton
		 MoveListItems($includelist,$biomeslist)
	  Case $removeexcludedbutton
		 MoveListItems($excludelist,$biomeslist)
	  Case $removeallincludedbutton
		 $numitems = _GUICtrlListBox_GetListBoxInfo($includelist)
		 _GUICtrlListBox_SelItemRange($includelist,0,$numitems - 1)
		 MoveListItems($includelist,$biomeslist)
	  Case $removeallexcludedbutton
		 $numitems = _GUICtrlListBox_GetListBoxInfo($excludelist)
		 _GUICtrlListBox_SelItemRange($excludelist,0,$numitems - 1)
		 MoveListItems($excludelist,$biomeslist)
	  Case $beginsearchbutton
		 $numitems = _GUICtrlListBox_GetListBoxInfo($includelist)
		 If $numitems = 0 Then
			$includeditems = 0
		 Else
			_GUICtrlListBox_SelItemRange($includelist,0,$numitems - 1)
			$includeditems = _GUICtrlListBox_GetSelItemsText($includelist)
		 EndIf

		 $numitems = _GUICtrlListBox_GetListBoxInfo($excludelist)
		 If $numitems = 0 Then
			$excludeditems = 0
		 Else
			_GUICtrlListBox_SelItemRange($excludelist,0,$numitems - 1)
			$excludeditems = _GUICtrlListBox_GetSelItemsText($excludelist)
		 EndIf

		 $seedsmax = GUICtrlRead($searchmax)
		 SearchBiomes($includeditems,$excludeditems,$seedsmax)
	  Case Else

   EndSwitch
WEnd