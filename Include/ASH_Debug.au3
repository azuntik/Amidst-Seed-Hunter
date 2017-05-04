; =============================================================================
; Amidst Seed Hunter - Debug (ASH_Debug.au3)
;
; Author: 	Azuntik
; Date:		2017.5.2
; License:	CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
;
; This file is part of the Amidst Seed Hunter project
; =============================================================================

Func DebugWrite($data)
	If $enableDebugging = 1 Then
		Dim $timestampedData = GetTimestamp() & " >> " & $data & @CRLF
		If @Compiled = 0 Then ConsoleWrite($timestampedData & @CRLF)
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
