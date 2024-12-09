; QWERTY layout for AutoHotkey - UK
; 2024/12/08 ~ 2024/12/08 -> 1.0.0 | XPERZ -> Separate from WorkmanAHK v1.3.0.
; 2024/12/08 ~ 2024/12/08 -> 1.0.1 | XPERZ -> Fixes problems during UAC attempts.
; 2024/12/09 ~ 2024/12/09 -> 1.1.0 | XPERZ -> Full support for UK layout.



#Requires AutoHotkey v2.0.10+
#SingleInstance Force
ListLines(0), KeyHistory(0)
SetTitleMatchMode(3)
SendMode("Input")
;Persistent



; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



Runtime.Ensurance()
TrayMenu.Construct()

SC029::VKDF
SC002::VK31
SC003::VK32
SC004::VK33
SC005::VK34
SC006::VK35
SC007::VK36
SC008::VK37
SC009::VK38
SC00A::VK39
SC00B::VK30
SC00C::VKBD
SC00D::VKBB

SC010::VK51
SC011::VK57
SC012::VK45
SC013::VK52
SC014::VK54
SC015::VK59
SC016::VK55
SC017::VK49
SC018::VK4F
SC019::VK50
SC01A::VKDB
SC01B::VKDD

SC01E::VK41
SC01F::VK53
SC020::VK44
SC021::VK46
SC022::VK47
SC023::VK48
SC024::VK4A
SC025::VK4B
SC026::VK4C
SC027::VKBA
SC028::VKC0
SC02B::VKDE

SC02C::VK5A
SC02D::VK58
SC02E::VK43
SC02F::VK56
SC030::VK42
SC031::VK4E
SC032::VK4D
SC033::VKBC
SC034::VKBE
SC035::VKBF

SC039::VK20

SC053::VK6E



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

		Try
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
		A_IconTip := "QWERTY UK"

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

;@Ahk2Exe-SetDescription QWERTY layout for AutoHotkey - UK
;@Ahk2Exe-SetFileVersion 1.1.0
;@Ahk2Exe-SetProductName WorkmanAHK
;@Ahk2Exe-SetProductVersion 1.4.0
;@Ahk2Exe-SetCompanyName https://workmanlayout.org
;@Ahk2Exe-SetCopyright The Workman Keyboard Layout created by OJ Bucao.
;@Ahk2Exe-SetLanguage 0x0809 ; English_UK
;@Ahk2Exe-SetOrigFilename QWERTY UK.exe

;@Ahk2Exe-SetMainIcon .\icon\wm-i1.ico       ; Default icon.
;;@Ahk2Exe-AddResource .\icon\wm-if.ico, 160 ; The .ahk file icon.
;@Ahk2Exe-AddResource .\icon\wm-i2.ico, 206  ; "Suspend Hotkeys" status.
;;@Ahk2Exe-AddResource .\icon\wm-i3.ico, 207 ; "Pause Script" status.
;;@Ahk2Exe-AddResource .\icon\wm-i4.ico, 208 ; "Suspend Hotkeys" and "Pause Script".

