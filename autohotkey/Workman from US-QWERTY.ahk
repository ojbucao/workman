; Workman layout for AutoHotkey - Based US-QWERTY
; 2024/12/08 ~ 2024/12/08 -> 1.0.0 | XPERZ -> Separate from WorkmanAHK v1.3.0.



#Requires AutoHotkey v2.0.10+
#SingleInstance Force
ListLines(0), KeyHistory(0)
SetTitleMatchMode(3)
SendMode("Input")
;Persistent



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
		A_IconTip := ""

		; MENU BEGIN --------

		item_name__Enable := "Enable"
		item_hotkey_name_lalt := GetKeyName("SC038"), item_hotkey_name_ralt := GetKeyName("SC138")
		item_name__Enable := item_name__Enable " (" item_hotkey_name_lalt " + " item_hotkey_name_ralt ")"
		Menu.Add(item_name__Enable, (*) => self.Callback.Toggle_Enable(Menu, item_name__Enable))
		Menu.Check(item_name__Enable)
		Hotkey(item_hotkey_name_lalt " & " item_hotkey_name_ralt, (*) => self.Callback.Toggle_Enable(Menu, item_name__Enable), "S")
		Hotkey(item_hotkey_name_ralt " & " item_hotkey_name_lalt, (*) => self.Callback.Toggle_Enable(Menu, item_name__Enable), "S")

		item_name__Exit := "Exit"
		Menu.Add(item_name__Exit, (*) => ExitApp())

		; MENU END ----------

		Menu.Default := item_name__Enable
		Menu.ClickCount := 1

		self.RefreshTrayIcon()
	}



	class Callback {
		static Toggle_Enable(menu, item, self := TrayMenu) {
			if (!A_IsSuspended) {
				Suspend(true)
				menu.Check(item)
			}
			else {
				Suspend(false)
				menu.Uncheck(item)
			}

			self.RefreshTrayIcon()
		}
	}



	static RefreshTrayIcon() {
		;@Ahk2Exe-IgnoreBegin
		icon := A_IsSuspended ? ".\icon\wm-i2.ico" : ".\icon\wm-i1.ico"
		if (FileExist(icon))
			TraySetIcon(icon, , true)
		;@Ahk2Exe-IgnoreEnd
	}
}



; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



;@Ahk2Exe-UpdateManifest 0

;@Ahk2Exe-SetDescription Workman layout for AutoHotkey - Based US-QWERTY
;@Ahk2Exe-SetFileVersion 1.0.0
;@Ahk2Exe-SetProductName WorkmanAHK
;@Ahk2Exe-SetProductVersion 1.3.0
;@Ahk2Exe-SetCompanyName https://workmanlayout.org
;@Ahk2Exe-SetCopyright The Workman Keyboard Layout created by OJ Bucao.
;@Ahk2Exe-SetLanguage 0x0409 ; English_US    ; 0009 and 04B0 as appropriate.
;@Ahk2Exe-SetOrigFilename Workman from US-QWERTY.exe

;@Ahk2Exe-SetMainIcon .\icon\wm-i1.ico       ; Default icon.
;;@Ahk2Exe-AddResource .\icon\wm-if.ico, 160 ; The .ahk file icon.
;@Ahk2Exe-AddResource .\icon\wm-i2.ico, 206  ; "Suspend Hotkeys" status.
;;@Ahk2Exe-AddResource .\icon\wm-i3.ico, 207 ; "Pause Script" status.
;;@Ahk2Exe-AddResource .\icon\wm-i4.ico, 208 ; "Suspend Hotkeys" and "Pause Script".

