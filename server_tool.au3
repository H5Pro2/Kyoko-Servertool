#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\Kyoko saves\autoit saves\Server.ico
#AutoIt3Wrapper_Res_Description=Server Tool
#AutoIt3Wrapper_Res_Fileversion=1.0.2.0
#AutoIt3Wrapper_Res_ProductName=Bot Start exe
#AutoIt3Wrapper_Res_ProductVersion=1.0.2
#AutoIt3Wrapper_Res_LegalCopyright=H5Pro2
#AutoIt3Wrapper_Res_Language=1031
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;------------------------
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <TreeViewConstants.au3>
#include <ListViewconstants.au3>
#include <GuiListView.au3>
#include <GUITreeView.au3>
#include <File.au3>
#include <Array.au3>
;------------------------
#include <WinAPI.au3>
#include <WinAPISysWin.au3>
#include <GuiStatusBar.au3>
;------------------------

Global $arrFileIcons[1] = ["shell32.dll"], $sortdir = 0

Global $Gray = 0xcfd0d1
Global $Yelow_Gray = 0xd7d8c7
Global $GUI_COLOR = 0x7b72f9
Global $Green = 0x49fc4f
Global $Orange = 0xe2cb46
Global $Black = 0x000000

Global $title = "MusicBot ServerTool...  createt by H5Pro2"

Local $hGUI

Local $gui = GUICreate($title, 800, 500, -1, -1)
	;------------------------------------
	$treeview = GUICtrlCreateTreeView(25, 800, 150, 25)
	GUICtrlSetBkColor($treeview, $Yelow_Gray)
	;------------------------------------
	;$listview = GUICtrlCreateListView("Name|Type|Size|Modified", 212, 25, 510, 350, BitOR($LVS_REPORT,$LVS_SHOWSELALWAYS,$WS_BORDER))
	$listview = GUICtrlCreateListView("Name|Size", 250, 40, 510, 400)
	GUICtrlSetBkColor($listview, $Yelow_Gray)
	_ColumnResize($listview)
	;------------------------------------
	$guipic = GUICtrlCreatePic("bot_files\bot_stuff\st_files\anime-grey-wallpaper.jpg", 0, 0, 800, 480, $WS_SIZEBOX + $WS_SYSMENU)
	GUICtrlSetResizing(-5, $GUI_DOCKAUTO)
	GUICtrlSetState($guipic, $GUI_DISABLE)
	;------------------------------------

;------------------------------------
Local $idFileMenu = GUICtrlCreateMenu("&File")
Local $idreadme = GUICtrlCreateMenuItem("readme", $idFileMenu)
GUICtrlSetState(-1, $GUI_DEFBUTTON)
Local $idgithub = GUICtrlCreateMenuItem("H5Pro2 - github", $idFileMenu)
Local $idExit = GUICtrlCreateMenuItem("Exit", $idFileMenu)
;------------------------------------
Local $idAnimation = GUICtrlCreateAvi("bot_files\bot_stuff\st_files\loading.avi", 0, 25, 400, 150, 26, $WS_EX_TRANSPARENT, $WS_EX_COMPOSITED)
GUICtrlSetResizing($idAnimation, $GUI_DOCKAUTO & $GUI_DOCKSIZE)
GUICtrlSetState($idAnimation, $GUI_HIDE)
;------------------------------------
$GUI_Button_DELETE = GUICtrlCreateButton("Delete user songlist", 25, 40, 120, 40)
GUICtrlSetState($GUI_Button_DELETE, 0)
GUICtrlSetResizing($GUI_Button_DELETE, $GUI_DOCKAUTO)
GUICtrlSetBkColor($GUI_Button_DELETE, $Orange)


$GUI_Button_ListUpdate = GUICtrlCreateButton("List Update", 25, 90, 120, 40)
GUICtrlSetState($GUI_Button_DELETE, 0)
GUICtrlSetResizing($GUI_Button_DELETE, $GUI_DOCKAUTO)
GUICtrlSetBkColor($GUI_Button_DELETE, $Orange)
;------------------------------------
$GUI_Button_Serverstart = GUICtrlCreateButton("Server Start", 25, 150, 80, 40)
GUICtrlSetState($GUI_Button_Serverstart, 0)
GUICtrlSetResizing($GUI_Button_Serverstart, $GUI_DOCKAUTO)
GUICtrlSetBkColor($GUI_Button_Serverstart, $Gray)
$GUI_Button_CloseServer = GUICtrlCreateButton("Server End", 130, 150, 80, 40)
GUICtrlSetState($GUI_Button_CloseServer, 0)
GUICtrlSetResizing($GUI_Button_CloseServer, $GUI_DOCKAUTO)
GUICtrlSetBkColor($GUI_Button_CloseServer, $Gray)

$GUI_Button_RestartServer = GUICtrlCreateButton("Server Restart", 25, 200, 80, 40)
GUICtrlSetState($GUI_Button_RestartServer, 0)
GUICtrlSetResizing($GUI_Button_RestartServer, $GUI_DOCKAUTO)
GUICtrlSetBkColor($GUI_Button_RestartServer, $Gray)
;------------------------------------
$GUI_Button_UpdateServer = GUICtrlCreateButton("Server Install / Update", 25, 350, 150, 40)
GUICtrlSetState($GUI_Button_UpdateServer, $GUI_SHOW)
GUICtrlSetResizing($GUI_Button_UpdateServer, $GUI_DOCKAUTO)
GUICtrlSetBkColor($GUI_Button_UpdateServer, $Gray)
;------------------------------------
$GUI_Button_Wait = GUICtrlCreateButton("Installed or Updated", 25, 350, 150, 40)
GUICtrlSetState($GUI_Button_Wait, $GUI_HIDE)
GUICtrlSetResizing($GUI_Button_Wait, $GUI_DOCKAUTO)
GUICtrlSetBkColor($GUI_Button_Wait, $Gray)
;------------------------------------
Global $ordner = "bot_files\user_songlist"
;-------------------
Global $servbat = "bot_files\win_bot_run.exe"
;Global $servbat = "bot_files\test.exe" ;for testing a simple batch file comile in to a .exe
;-------------------
Global $updatebat = "bot_files\win_npm.exe"
;Global $updatebat = "bot_files\test.exe" ;for testing a simple batch file comile in to a .exe
Global $readmePath = "bot_files\bot_stuff\readme.html"
;------------------------------------
Global $server_path = _WinAPI_GetFullPathName($servbat)
Global $updbat = _WinAPI_GetFullPathName($updatebat)
Global $readmehtmlpath = _WinAPI_GetFullPathName($readmePath)
;------------------------------------
Global $global_file_delete
Global $serverstart = False
Global $serverlock = False
Global $iTh = 0
;------------------------------------
Global $updatefiles = False
Global $updatelock = False
Global $aktiv = False
Global $hWbd = 0
;------------------------------------
Global $restarting = False
;------------------------------------
Global $serverclosed = False
;------------------------------------
$tImage = _GUIImageList_Create(16, 16, 5, 2) ;Treeview Icon Image List
_GUIImageList_AddIcon($tImage, @SystemDir & "\shell32.dll", 3) ;Folder
_GUIImageList_AddIcon($tImage, @SystemDir & "\shell32.dll", 4) ;Folder Open
_GUIImageList_AddIcon($tImage, @SystemDir & "\shell32.dll", 181) ;Cdr
_GUIImageList_AddIcon($tImage, @SystemDir & "\shell32.dll", 8) ;Fixed
_GUIImageList_AddIcon($tImage, @SystemDir & "\shell32.dll", 7) ;Removable
_GUIImageList_AddIcon($tImage, @SystemDir & "\shell32.dll", 9) ;Network
_GUIImageList_AddIcon($tImage, @SystemDir & "\shell32.dll", 11) ;CDRom
_GUIImageList_AddIcon($tImage, @SystemDir & "\shell32.dll", 109) ;No Symbol for Burner

_GUICtrlTreeView_SetNormalImageList("", $tImage)
;------------------------------------
$main = _GUICtrlTreeView_AddChild($treeview, "", $ordner)
;------------------------------------
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY") ;Last steps before GUI Display
;-----------------------------------
GUISetState(@SW_SHOW)
;-----------------------------------
While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE, $idExit
			WinKill($server_path)
			WinKill($updbat)
			ExitLoop
		Case $GUI_Button_DELETE
			If $global_file_delete == "" Then
			Else
				FileDelete($ordner & "\" & $global_file_delete)
				$global_file_delete = "clear" ;clear die variable
				_ShowFolder($treeview, $listview, $gui)
			EndIf
		Case $GUI_Button_ListUpdate
			_ShowFolder($treeview, $listview, $gui)
		Case $GUI_Button_Serverstart
			If $serverstart = False Then
				If $updatefiles = False Then
					$serverstart = True
					$serverlock = True
					;~------------------------
					Run($server_path)
					WinWaitActive($server_path, "", 10)
					$iTh = WinGetHandle($server_path)
					;~------------------------
					Local $iPID = 0
					Local $iThread = _WinAPI_GetWindowThreadProcessId ( $iTh ,$iPID )
					;~------------------------
				EndIf
			EndIf
		Case $GUI_Button_CloseServer
 			;ConsoleWrite($serverstart & @CRLF)
			If $serverstart = True Then
				;~------------------------
				$serverlock = False
				$serverstart = False
				$serverclosed = true
				WinKill($iTh)
			Else
				GUICtrlSetBkColor($GUI_Button_Serverstart, $Gray)
			EndIf
		Case $GUI_Button_RestartServer
			If $serverstart = True Then
				ConsoleWrite($GUI_Button_RestartServer & @CRLF)
				$serverstart = False
				$serverlock = False
				$restarting = True
				;~------------------------
				WinKill($iTh)
				$iTh=0
			EndIf
		Case $GUI_Button_UpdateServer
			If $serverstart = False Then
				$updatefiles = True
				$updatelock = True
				;~------------------------
				Run($updbat)
				WinWait($updbat, "", 10)
				;~------------------------
				$hWbd = WinGetHandle($updbat)
				;~------------------------
				Local $ibd = 0
				Local $iThreadbd = _WinAPI_GetWindowThreadProcessId($hWbd, $ibd)
				;~------------------------
			EndIf
		Case $idreadme
			ShellExecute("https://h5pro2.github.io/Kyoko.github.io/index.html")
		Case $idgithub
			ShellExecute("https://github.com/H5Pro2/Kyoko-Musicbot")

	EndSwitch

	;~------------------------
	If WinExists($hWbd) Then
		_update()
	Else
		$updatefiles = False
		_update()
	EndIf
	;~------------------------
	If WinExists($iTh) Then
		_Serverstart()
	Else
		$serverstart = False
		_Serverstart()
	EndIf
	;~------------------------
WEnd

Func _update()
	If $updatefiles = true Then
		If $updatelock = true Then
			$updatelock = False
			GUICtrlSetState($GUI_Button_Wait, $GUI_SHOW)
			GUICtrlSetBkColor($GUI_Button_Wait, $Green)
			GUICtrlSetState($GUI_Button_UpdateServer, $GUI_HIDE)
			GUICtrlSetState($idAnimation, $GUI_SHOW)
			GUICtrlSetState($idAnimation, $GUI_AVISTART)
		EndIf
	Else
		$hWbd=0
		If $updatelock = False Then
			$updatelock = true
			GUICtrlSetBkColor($GUI_Button_UpdateServer, $Gray)
			GUICtrlSetState($GUI_Button_Wait, $GUI_HIDE)
			GUICtrlSetState($GUI_Button_UpdateServer, $GUI_SHOW)
			GUICtrlSetState($idAnimation, $GUI_AVISTOP)
			GUICtrlSetState($idAnimation, $GUI_HIDE)
		EndIf
	EndIf
EndFunc

Func _Serverstart()
	If $serverstart = true Then
		If $serverlock = true Then
			$serverlock = False
			GUICtrlSetBkColor($GUI_Button_Serverstart, $Green)
		EndIf
	Else
		$iTh=0
		If $serverlock = False Then
			$serverlock = true
			GUICtrlSetBkColor($GUI_Button_Serverstart, $Gray)
			if $restarting = true Then
				Sleep(5000)
				_restartserver()
			EndIf

			if $serverclosed = true Then
				Sleep(5000)
				_closewserver()
			EndIf
		EndIf
	EndIf
EndFunc

func _restartserver()
	;~------------------------
	$serverstart = True
	$serverlock = True
	$restarting = False
	;~------------------------
	Run($server_path)
	WinWait($server_path, "", 10)
	$iTh = WinGetHandle($server_path)
	;~------------------------
	Local $iPID = 0
	Local $iThread = _WinAPI_GetWindowThreadProcessId ( $iTh ,$iPID )
	;~------------------------
EndFunc

Func _closewserver()
	$serverclosed = False
	$iTh=0
	GUICtrlSetBkColor($GUI_Button_Serverstart, $Gray)
EndFunc

Func _ColumnResize(ByRef $hWnd, $type = 0) ;Resize Listview Column routine
	$winpos = WinGetPos($gui)
	_GUICtrlListView_SetColumnWidth($hWnd, 0, $winpos[2] * .5500)
	_GUICtrlListView_SetColumnWidth($hWnd, 1, $winpos[2] * .25)
EndFunc   ;==>_ColumnResize

Func _FileGetIcon(ByRef $szIconFile, ByRef $nIcon, $szFile)
	Dim $szRegDefault = "", $szDefIcon = ""
	$szExt = StringMid($szFile, StringInStr($szFile, '.', 0, -1))
	If $szExt = '.lnk' Then
		$details = FileGetShortcut($szIconFile)
		$szIconFile = $details[0]
		$szExt = StringMid($details[0], StringInStr($details[0], '.', 0, -1))
	EndIf
	$szRegDefault = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\" & $szExt, "ProgID")
	If $szRegDefault = "" Then $szRegDefault = RegRead("HKCR\" & $szExt, "")
	If $szRegDefault <> "" Then $szDefIcon = RegRead("HKCR\" & $szRegDefault & "\DefaultIcon", "")
	If $szDefIcon = "" Then $szRegDefault = RegRead("HKCR\" & $szRegDefault & "\CurVer", "")
	If $szRegDefault <> "" Then $szDefIcon = RegRead("HKCR\" & $szRegDefault & "\DefaultIcon", "")
	If $szDefIcon = "" Then
		$szIconFile = "shell32.dll"
	ElseIf $szDefIcon <> "%1" Then
		$arSplit = StringSplit($szDefIcon, ",")
		If IsArray($arSplit) Then
			$szIconFile = $arSplit[1]
			If $arSplit[0] > 1 Then $nIcon = $arSplit[2]
		Else
			Return 0
		EndIf
	EndIf
	Return 1
EndFunc   ;==>_FileGetIcon

Func _FillFolder(ByRef $hWnd) ;Fill Folder in TreeView
	$item = _GUICtrlTreeView_GetSelection($hWnd)
	If _GUICtrlTreeView_GetChildCount($hWnd, $item) <= 0 Then
		_GUICtrlTreeView_BeginUpdate($treeview)
		$txt = _TreePath($hWnd, $item)
		_SearchFolder($txt, $item)
		_GUICtrlTreeView_EndUpdate($treeview)
	EndIf
EndFunc   ;==>_FillFolder

Func _FolderFunc($folders, $folder, $parent, $level) ;Add Folder to Source TreeView
	If $parent = 0x00000000 Then Return
	For $i = 1 To UBound($folders) - 1
		$parentitem = _GUICtrlTreeView_AddChild($treeview, $parent, $folders[$i], 0, 1)
		_SearchFolder($folder & "\" & $folders[$i], $parentitem, $level + 1)
	Next
EndFunc   ;==>_FolderFunc

Func _FriendlyDate($date) ;Convert Date for Readability
	If Not IsArray($date) Then Return ""
	Local $datetime = ""
	For $i = 0 To 5
		$datetime &= $date[$i]
		If $i < 2 Then $datetime &= "-"
		If $i = 2 Then $datetime &= " "
		If $i > 2 And $i < 5 Then $datetime &= ":"
	Next
	Return $datetime
EndFunc   ;==>_FriendlyDate

Func _GetSelectedItems($hWnd, $list, $tree) ;Get list of Selected Items in Source ListView
	$items = _GUICtrlListView_GetSelectedIndices($list, True)
	For $i = 1 To $items[0]
		$items[$i] = _TreePath($tree, _GUICtrlTreeView_GetSelection($tree)) & "\" & _GUICtrlListView_GetItemText(ControlGetHandle($hWnd, "", $list), $items[$i], 0)
	Next
	Return $items
EndFunc   ;==>_GetSelectedItems

Func _ReduceMemory($i_PID = -1) ;Reduces Memory Usage -- Special thanks to w0uter and jftuga
	If $i_PID <> -1 Then
		Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Else
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory

Func _SearchFolder($folder, $parent, $level = 0) ;Recursive Folder Search for Source Treeview/Listview
	If $level >= 1 Then Return
	$folders = _FileListToArray($folder, "*", 2)
	_FolderFunc($folders, $folder, $parent, $level)
EndFunc   ;==>_SearchFolder

;~ -----------------------------------------

Func _ShowFolder($tree, $list, $hWnd, $sort = 0) ;Show folder in Source Folder
	Dim $arrCurrentFolder[1][2]
	$item = _GUICtrlTreeView_GetSelection($tree)
	If $item = 0x000000 Then Return 0
	_GUICtrlListView_BeginUpdate($list)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($list))
	$path = _TreePath($tree, $item)
	For $type = 1 To 2
		Local $Sch
		If $type = 1 Then $Sch = _FileListToArray($path, "*", 2)
		If $type = 2 Then $Sch = _FileListToArray($path, "*", 1)
		If UBound($Sch) > 0 Then
			For $i = 1 To $Sch[0]
				ReDim $arrCurrentFolder[UBound($arrCurrentFolder) + 1][2]
				If $type = 1 Then
					$size = " "
				Else
					$size = FileGetSize($path & "\" & $Sch[$i])
				EndIf
				$arrCurrentFolder[UBound($arrCurrentFolder) - 1][0] = $Sch[$i]
				$arrCurrentFolder[UBound($arrCurrentFolder) - 1][1] = $size
			Next
			If $type = 1 And $sort <> 3 Then
				_ArraySort($arrCurrentFolder, $sortdir, 0, 0, 0)
			Else
				_ArraySort($arrCurrentFolder, $sortdir, 0, 0, $sort)
			EndIf
			If $type = 1 Then
				For $x = 0 To UBound($arrCurrentFolder) - 1
					If $arrCurrentFolder[$x][0] Then
						$idx = GUICtrlCreateListViewItem($arrCurrentFolder[$x][0] & "|" & $arrCurrentFolder[$x][1], $list)
						GUICtrlSetImage(-1, $arrFileIcons[0], -4)
					EndIf
				Next
				$arrCurrentFolder = 0
				Dim $arrCurrentFolder[1][2]
			EndIf
			If $type = 2 Then
				For $x = 0 To UBound($arrCurrentFolder) - 1
					If $arrCurrentFolder[$x][0] Then
						$idx = GUICtrlCreateListViewItem($arrCurrentFolder[$x][0] & "|" & $arrCurrentFolder[$x][1], $list)
						If StringRight($arrCurrentFolder[$x][0], 2) = ".exe" Then
							$found = _ArraySearch($arrFileIcons, $arrCurrentFolder[$x][0], 0, 0, 0, 1)
							If $found <> -1 Then
								GUICtrlSetImage(-1, $arrFileIcons[$found], 0)
							Else
								If GUICtrlSetImage(-1, $path & "\" & $arrCurrentFolder[$x][0], 0) = 0 Then
									GUICtrlSetImage(-1, $arrFileIcons[0], -3)
								Else
									ReDim $arrFileIcons[UBound($arrFileIcons) + 1]
									$arrFileIcons[UBound($arrFileIcons) - 1] = $path & "\" & $arrCurrentFolder[$x][0]
									GUICtrlSetImage(-1, $arrFileIcons[UBound($arrFileIcons) - 1], 0)
								EndIf
							EndIf
						ElseIf StringRight($arrCurrentFolder[$x][0], 3) = "htm" Or StringRight($arrCurrentFolder[$x][0], 3) = "html" Then
							GUICtrlSetImage(-1, $arrFileIcons[0], -221)
						Else
							$strExtension = StringTrimLeft($arrCurrentFolder[$x][0], StringInStr($arrCurrentFolder[$x][0], ".", 0, -1) - 1)
							If Not StringInStr($strExtension, ".lnk", 0, 0, 0, 1) Then
								$found = _ArraySearch($arrFileIcons, $arrCurrentFolder[$x][0], 0, 0, 0, 1)
							Else
								$found = _ArraySearch($arrFileIcons, $strExtension, 0, 0, 0, 1)
							EndIf
							If $found <> -1 Then
								$icon = StringTrimLeft($arrFileIcons[$found], StringInStr($arrFileIcons[$found], "|", 0, -2))
								$icon = StringLeft($icon, StringInStr($icon, "|") - 1)
								$nIcon = StringRight($arrFileIcons[$found], StringLen($arrFileIcons[$found]) - StringInStr($arrFileIcons[$found], "|", 0, -1))
								GUICtrlSetImage(-1, $icon, $nIcon)
							Else
								Local $szIconFile = $path & "\" & $arrCurrentFolder[$x][0], $nIcon = 0
								_FileGetIcon($szIconFile, $nIcon, $arrCurrentFolder[$x][0])
								If $nIcon <> 0 Then $nIcon = -$nIcon
								ReDim $arrFileIcons[UBound($arrFileIcons) + 1]
								$arrFileIcons[UBound($arrFileIcons) - 1] = $path & "\" & $arrCurrentFolder[$x][0] & "|" & StringReplace($szIconFile, Chr(34), "") & "|" & StringReplace($nIcon, Chr(34), "")
								GUICtrlSetImage(-1, $szIconFile, $nIcon)
							EndIf
						EndIf
					EndIf
				Next
			EndIf
		EndIf
	Next
	$Sch = 0
	$nIcon = 0
	$szIconFile = 0
	$arrCurrentFolder = 0
	_GUICtrlListView_EndUpdate($list)
	_ReduceMemory()
EndFunc   ;==>_ShowFolder

Func _TreePath($hWnd, $item) ;Determine full path of selected item in TreeView
	$txt = _GUICtrlTreeView_GetText($hWnd, $item)
	Do
		$parent = _GUICtrlTreeView_GetParentHandle($hWnd, $item)
		If $parent <> 0 Then
			$txt = _GUICtrlTreeView_GetText($hWnd, $parent) & "\" & $txt
			$item = $parent
		EndIf
	Until $parent = 0
	Return $txt
EndFunc   ;==>_TreePath

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam) ;Notify func
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR
	$srctree = ControlGetHandle($hWnd, "", $treeview)
	$srclist = ControlGetHandle($hWnd, "", $listview)
	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	If $iCode = -12 Or $iCode = -17 Then Return False

	Switch $hWndFrom
		Case $srclist
			$item = _GetSelectedItems($gui, $listview, $treeview)
			Switch $iCode
				Case $NM_DBLCLK
					If $item[0] <> 0 Then

						$filefolder = _GUICtrlListView_GetSelectedIndices($listview, True)

						If _GUICtrlListView_GetItemText($listview, $filefolder[1], 1) = "Folder" Then
							$idx = _GUICtrlTreeView_GetSelection($treeview)
							$item = StringTrimLeft($item[1], StringInStr($item[1], "\", 0, -1))
							$found = _GUICtrlTreeView_FindItem($treeview, $item, False, $idx)
							_GUICtrlTreeView_SelectItem($treeview, $found)
							_FillFolder($treeview)
							_ShowFolder($treeview, $listview, $gui)
						Else
							Run(@ComSpec & " /c " & Chr(34) & $item[1] & Chr(34), "", @SW_HIDE)
							Sleep(1500)
						EndIf

					EndIf
					Return True

				Case $NM_CLICK
					If $item[0] <> 0 Then
						$idx = _GUICtrlTreeView_GetSelection($treeview)
						$item = StringTrimLeft($item[1], StringInStr($item[1], "\", 0, -1))
					EndIf
					Return True
			EndSwitch


		Case $srctree
			Switch $iCode
				Case $NM_RCLICK
					Local $tPOINT = _WinAPI_GetMousePos(True, $srctree)
					Local $iX = DllStructGetData($tPOINT, "X")
					Local $iY = DllStructGetData($tPOINT, "Y")

					Local $hItem = _GUICtrlTreeView_HitTestItem($srctree, $iX, $iY)
					If $hItem <> 0 Then _GUICtrlTreeView_SelectItem($srctree, $hItem, $TVGN_CARET)

				Case -451
					_FillFolder($treeview)
					_ShowFolder($treeview, $listview, $gui)
					Return True

			EndSwitch

		Case Else
			Switch $iCode
				Case $NM_CLICK ; The user has clicked the left mouse button within the control
					_SendMessage($gui, $WM_SYSCOMMAND, 0xF012, 2, 1)
			EndSwitch
	EndSwitch
EndFunc   ;==>WM_NOTIFY
