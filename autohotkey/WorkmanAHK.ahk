; Workman layout for AutoHotkey
; 2017/__/__ ~ 2017/03/07 -> _._._ | Joel May -> Public domain.
; 2024/12/06 ~ 2024/12/06 -> 1.1.0 | XPERZ -> Adjustment tray menu.
; See http://www.autohotkey.com/ for more information.

; Based on Colemak AutoHotkey script from https://colemak.com/Windows by Shai Coleman.

; For this to work you have to make sure that the US (QWERTY) layout is installed,
; that is set as the default layout, and that it is set as the current layout.
; Otherwise some of the key mappings will be wrong.
;
; This is mainly useful for those who don't have privileges to install a new layout
; This doesn't support the international features of the Colemak layout.



#Requires AutoHotkey v2.0.10+
#SingleInstance Force
ListLines(0), KeyHistory(0)
SendMode("Input") ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode(3) ; Exact matching to avoid confusing T/B with Tab/Backspace.



; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



Runtime.Ensurance()
TrayMenu.Construct()

SC011::SC020
SC012::SC013
SC013::SC011
SC014::SC030
SC015::SC024
SC016::SC021
SC017::SC016
SC018::SC019
SC019::SC027
SC020::SC023
SC021::SC014
SC023::SC015
SC024::SC031
SC025::SC012
SC026::SC018
SC027::SC017
SC02E::SC032
SC02F::SC02E
SC030::SC02F
SC031::SC025
SC032::SC026



; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



class Runtime {
	static Ensurance() {
		Runtime.TryUac()
	}



	static TryUac(self := Runtime) {
		if A_IsAdmin == true
			return

		for arg in A_Args
			if (InStr("/restart", arg) != 0)
				return

		self.RestartWithUac()
	}



	static VerifyUac(self := Runtime) {
		if A_IsAdmin == true
			return

		for arg in A_Args
			if (InStr("/restart", arg) != 0) {
				user_choice := MsgBox("Failed to run with administrator rights.`nWant to try again?", A_ThisFunc, "OC Icon!")
				if (user_choice == "Cancel")
					ExitApp()
				break
			}

		self.RestartWithUac()
	}



	static RestartApp() {
		Run '"' A_ScriptFullPath '" /restart'
		ExitApp()
	}



	static RestartWithUac() {
		Run '*RunAs "' A_ScriptFullPath '" /restart'
		ExitApp()
	}
}



class TrayMenu {
	static Construct(self := TrayMenu) {
		Menu := A_TrayMenu
		Menu.Delete()

		Menu.Add("Enable", (*) => self.Callback.Enable(Menu,"Enable")), Menu.Check("Enable")
		Menu.Add("Close", (*) => ExitApp())

		Menu.Default := "Enable"
		Menu.ClickCount := 1

		;@Ahk2Exe-IgnoreBegin
		icon := ".\icon\wm-i1.ico"
		if (FileExist(icon))
			TraySetIcon(icon, , true)
		;@Ahk2Exe-IgnoreEnd
	}



	class Callback {
		static Enable(menu, item) {
			Suspend(!A_IsSuspended)
			menu.ToggleCheck(item)

			;@Ahk2Exe-IgnoreBegin
			icon := A_IsSuspended ? ".\icon\wm-i2.ico" : ".\icon\wm-i1.ico"
			if (FileExist(icon))
				TraySetIcon(icon, , true)
			;@Ahk2Exe-IgnoreEnd
		}
	}
}



; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
/*


BASIC_KEYS := [ ; https://kbdlayout.info/kbdus/scancodes
	"SC029","SC002","SC003","SC004","SC005","SC006","SC007","SC008","SC009","SC00A","SC00B","SC00C","SC00D",      "SC00E",
	"SC00F"   ,"SC010","SC011","SC012","SC013","SC014","SC015","SC016","SC017","SC018","SC019","SC01A","SC01B",   "SC01C",
	"SC03A"      ,"SC01E","SC01F","SC020","SC021","SC022","SC023","SC024","SC025","SC026","SC027","SC028","SC02B", ;  1C ,
	"SC02A"  ,"SC056","SC02C","SC02D","SC02E","SC02F","SC030","SC031","SC032","SC033","SC034","SC035",            "SC036",
	"SC01D"  ,"SC15B"  ,"SC038"  ,                    "SC039"                    ,  "SC138",  "SC15C",  "SC15D",  "SC11D",
]



WORKMAN_MAPPING_LAYOUTS := Map(
	"US", [
		["SC011","SC020"],
		["SC012","SC013"],
		["SC013","SC011"],
		["SC014","SC030"],
		["SC015","SC024"],
		["SC016","SC021"],
		["SC017","SC016"],
		["SC018","SC019"],
		["SC019","SC027"],
		["SC020","SC023"],
		["SC021","SC014"],
		["SC023","SC015"],
		["SC024","SC031"],
		["SC025","SC012"],
		["SC026","SC018"],
		["SC027","SC017"],
		["SC02E","SC032"],
		["SC02F","SC02E"],
		["SC030","SC02F"],
		["SC031","SC025"],
		["SC032","SC026"],
	],
)


*/
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



;@Ahk2Exe-UpdateManifest 0

;@Ahk2Exe-SetDescription Workman layout for AutoHotkey
;@Ahk2Exe-SetFileVersion 1.1.0
;@Ahk2Exe-SetProductName Workman
;@Ahk2Exe-SetProductVersion 　
;@Ahk2Exe-SetCompanyName https://workmanlayout.org
;@Ahk2Exe-SetCopyright The Workman Keyboard Layout created by OJ Bucao.
;@Ahk2Exe-SetLanguage 0x0009 ; English
;@Ahk2Exe-SetOrigFilename WorkmanAHK.exe

;@Ahk2Exe-SetMainIcon .\icon\wm-i1.ico       ; Default icon.
;;@Ahk2Exe-AddResource .\icon\wm-if.ico, 160 ; The .ahk file icon.
;@Ahk2Exe-AddResource .\icon\wm-i2.ico, 206  ; "Suspend Hotkeys" status.
;;@Ahk2Exe-AddResource .\icon\wm-i3.ico, 207 ; "Pause Script" status.
;;@Ahk2Exe-AddResource .\icon\wm-i4.ico, 208 ; "Suspend Hotkeys" and "Pause Script".

