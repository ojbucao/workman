﻿; Workman layout for AutoHotkey
; 2017/__/__ ~ 2017/03/07 -> _._._ | Joel May -> Public domain.
; 2024/12/06 ~ 2024/12/06 -> 1.1.0 | XPERZ -> Adjustment tray menu.
; 2024/12/06 ~ 2024/12/07 -> 1.2.0 | XPERZ -> Supports DVORAK layout and reverse mode.



#Requires AutoHotkey v2.0.10+
#SingleInstance Force
ListLines(0), KeyHistory(0)
SetTitleMatchMode(3) ; Exact matching to avoid confusing T/B with Tab/Backspace. (1.2.0 | XPERZ: Has some doubts about this.)
SendMode("Input")
Persistent



; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



/*BASIC_KEYS := [ ; https://kbdlayout.info/kbdus/scancodes
	"SC029","SC002","SC003","SC004","SC005","SC006","SC007","SC008","SC009","SC00A","SC00B","SC00C","SC00D",      "SC00E",
	"SC00F"   ,"SC010","SC011","SC012","SC013","SC014","SC015","SC016","SC017","SC018","SC019","SC01A","SC01B",   "SC01C",
	"SC03A"      ,"SC01E","SC01F","SC020","SC021","SC022","SC023","SC024","SC025","SC026","SC027","SC028","SC02B", ;  1C ,
	"SC02A"  ,"SC056","SC02C","SC02D","SC02E","SC02F","SC030","SC031","SC032","SC033","SC034","SC035",            "SC036",
	"SC01D"  ,"SC15B"  ,"SC038"  ,                    "SC039"                    ,  "SC138",  "SC15C",  "SC15D",  "SC11D",
]*/



WORKMAN_MAPPING_LAYOUTS := Map(
	; https://kbdlayout.info/kbddv
	"US DVORAK", [
		["SC00C","SC028"],
		["SC00D","SC01B"],
		["SC010","SC02D"],
		["SC011","SC023"],
		["SC012","SC018"],
		["SC013","SC033"],
		["SC014","SC031"],
		["SC015","SC02E"],
		["SC016","SC015"],
		["SC017","SC021"],
		["SC018","SC013"],
		["SC019","SC02C"],
		["SC01A","SC00C"],
		["SC01B","SC00D"],
		["SC01F","SC027"],
		["SC020","SC024"],
		["SC021","SC025"],
		["SC022","SC016"],
		["SC023","SC014"],
		["SC024","SC026"],
		["SC025","SC020"],
		["SC026","SC01F"],
		["SC027","SC022"],
		["SC028","SC010"],
		["SC02C","SC035"],
		["SC02D","SC030"],
		["SC02E","SC032"],
		["SC02F","SC017"],
		["SC030","SC034"],
		["SC031","SC02F"],
		["SC032","SC019"],
		["SC033","SC011"],
		["SC034","SC012"],
		["SC035","SC01A"],
	],

	; https://kbdlayout.info/kbdus
	"US QWERTY", [
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



; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



Runtime.Ensurance()
Config.Initiation()

; Must be after `Config.Initiation()`.
LAYOUT_HOTKEYS := Hotkeys()

; Must be after `Config.Initiation()` and `LAYOUT_HOTKEYS`.
TrayMenu.Construct()



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



class Config {
	static Initiation(self := Config) {
		self.File.Unique.Read()
	}



	static Persistence(self := Config) {
		self.File.Unique.Write()
	}



	class File {
		class Unique {
			static name := UserInterface.GetFileName(A_ScriptName) ".ini"
			static path := A_ScriptDir "\" Config.File.Unique.name

			class BaseLayout {
				static name := "BaseLayout"

				class LayoutName {
					static name := "LayoutName"
					static value := "US QWERTY"
				}
			}

			class SpecialMode {
				static name := "SpecialMode"

				class ReversMode {
					static name := "ReversMode"
					static value := false
				}
			}

			class ScriptStatus {
				static name := "ScriptStatus"

				class Enable {
					static name := "Enable"
					static value := true
				}
			}



			static Read(self := Config.File.Unique, base := Config) {
				path := self.path

				; Use default value when the file is not exist.
				if (!FileExist(path))
					return

				; Try if can be opened.
				file_try := UserInterface.OpenFileHasCheck(path)
				file_try.Close()

				ini_value_temp := IniRead(path
					, self.BaseLayout.name
					, self.BaseLayout.LayoutName.name
					, self.BaseLayout.LayoutName.value)
				self.BaseLayout.LayoutName.value := base.Analyze.LayoutType(ini_value_temp
					, self.BaseLayout.LayoutName.value)

				ini_value_temp := IniRead(path
					, self.SpecialMode.name
					, self.SpecialMode.ReversMode.name
					, self.SpecialMode.ReversMode.value)
				self.SpecialMode.ReversMode.value := base.Analyze.BoolenType(ini_value_temp
					, self.SpecialMode.ReversMode.value)

				ini_value_temp := IniRead(path
					, self.ScriptStatus.name
					, self.ScriptStatus.Enable.name
					, self.ScriptStatus.Enable.value)
				self.ScriptStatus.Enable.value := base.Analyze.BoolenType(ini_value_temp
					, self.ScriptStatus.Enable.value)
			}



			static Write(self := Config.File.Unique) {
				path := self.path

				; Try to create or override.
				file_temp := UserInterface.CreateFileHasCheck(path)

				IniWrite(
					self.BaseLayout.LayoutName.name "=" self.BaseLayout.LayoutName.value
					, path, self.BaseLayout.name)

				IniWrite(
					self.SpecialMode.ReversMode.name "=" self.SpecialMode.ReversMode.value
					, path, self.SpecialMode.name)

				IniWrite(
					self.ScriptStatus.Enable.name "=" self.ScriptStatus.Enable.value
					, path, self.ScriptStatus.name)
			}
		}
	}




	class Analyze {
		static IntegerType(source, min, max, default) {
			if (IsInteger(source) == false)
				return default

			return source < min ? min
			     : source > max ? max 
			     : source
		}



		static BoolenType(source, default) {
			if (source != true and source != false)
				return default

			return source
		}



		static LayoutType(source, default) {
			for layout_name in WORKMAN_MAPPING_LAYOUTS
				if (source == layout_name)
					return source

			return default
		}
	}
}



class TrayMenu {
	static Construct(self := TrayMenu) {
		Menu := A_TrayMenu
		Menu.Delete()

		; MENU BEGIN --------

		for layout_name in WORKMAN_MAPPING_LAYOUTS
			Menu.Add(layout_name, self.Callback.Switch_Layout(layout_name))
		Menu.Check(Config.File.Unique.BaseLayout.LayoutName.value)

		Menu.Add() ; --------

		item_name__Revers := "Revers Mode"
		Menu.Add(item_name__Revers, (*) => self.Callback.Toggle_Revers(Menu, item_name__Revers))
		if (Config.File.Unique.SpecialMode.ReversMode.value == true)
			Menu.Check(item_name__Revers)

		Menu.Add() ; --------

		item_name__Enable := "Enable"
		Menu.Add(item_name__Enable, (*) => self.Callback.Toggle_Enable(Menu, item_name__Enable))
		if (Config.File.Unique.ScriptStatus.Enable.value == true)
			Menu.Check(item_name__Enable)
		else { ; Assign value in advance to prepare for toggle.
			Config.File.Unique.ScriptStatus.Enable.value := true
			self.Callback.Toggle_Enable(Menu, item_name__Enable)
		}

		item_name__Exit := "Exit"
		Menu.Add(item_name__Exit, (*) => ExitApp())

		; MENU END ----------

		Menu.Default := item_name__Enable
		Menu.ClickCount := 1

		;@Ahk2Exe-IgnoreBegin
		icon := ".\icon\wm-i1.ico"
		if (!A_IsSuspended and FileExist(icon))
			TraySetIcon(icon, , true)
		;@Ahk2Exe-IgnoreEnd
	}



	class Callback {
		class Switch_Layout {
			layout_name := ""

			__New(layout_name) {
				this.layout_name := layout_name
			}

			Call(item_name, _, menu, self := TrayMenu) {
				cfg := Config.File.Unique.BaseLayout.LayoutName

				cfg.value := this.layout_name
				LAYOUT_HOTKEYS.Exchange()

				Config.File.Unique.Write()
				for item_name in WORKMAN_MAPPING_LAYOUTS
					menu.Uncheck(item_name)
				menu.Check(cfg.value)
			}
		}



		static Toggle_Revers(menu, item) {
			cfg := Config.File.Unique.SpecialMode.ReversMode

			cfg.value := !cfg.value
			LAYOUT_HOTKEYS.Exchange()

			Config.File.Unique.Write()
			if (cfg.value == true)
				menu.Check(item)
			else
				menu.Uncheck(item)
		}



		static Toggle_Enable(menu, item) {
			cfg := Config.File.Unique.ScriptStatus.Enable

			cfg.value := !cfg.value
			Suspend(!cfg.value)

			Config.File.Unique.Write()
			if (cfg.value == true)
				menu.Check(item)
			else
				menu.Uncheck(item)

			;@Ahk2Exe-IgnoreBegin
			icon := A_IsSuspended ? ".\icon\wm-i2.ico" : ".\icon\wm-i1.ico"
			if (FileExist(icon))
				TraySetIcon(icon, , true)
			;@Ahk2Exe-IgnoreEnd
		}
	}
}



class Hotkeys {
	layout := Config.File.Unique.BaseLayout.LayoutName.value
	revers := Config.File.Unique.SpecialMode.ReversMode.value

	__New() {
		this.__Create()
	}

	__Create(self := Hotkeys) {
		idx_base := 1, idx_from := 2
		if (this.revers == true)
			idx_base := 2, idx_from := 1

		for key_pair in WORKMAN_MAPPING_LAYOUTS.Get(this.layout) {
			key_base := key_pair[idx_base], key_from := key_pair[idx_from]
			Hotkey(key_base, self.Callback.Sender(key_from), "On")
		}
	}

	__Nestle() {
		idx_base := 1, idx_from := 2
		if (this.revers == true)
			idx_base := 2, idx_from := 1

		for key_pair in WORKMAN_MAPPING_LAYOUTS.Get(this.layout) {
			key_base := key_pair[idx_base], key_from := key_pair[idx_from]
			Hotkey(key_base, , "Off")
		}
	}

	Exchange(other := Config.File.Unique) {
		this.__Nestle()

		this.layout := other.BaseLayout.LayoutName.value
		this.revers := other.SpecialMode.ReversMode.value

		this.__Create()
	}



	class Callback {
		class Sender {
			keyname := ""

			__New(keyname) {
				this.keyname := keyname
			}
	
			Call(*) {
				Send("{" this.keyname "}")
			}
		}
	}
}



class UserInterface {
	static CreateFileHasCheck(path, self := UserInterface) {
		if (FileExist(path))
			return

		try {
			tFile := FileOpen(path, "w", "UTF-16")
			tFile.Close()

		} catch Error as e
			self.PanicMessage("Failed to create file.`nError detail: " e.Message "`n" e.Stack, A_ThisFunc)
	}



	static OpenFileHasCheck(path, self := UserInterface) {
		try {
			if (FileExist(path))
				FileSetAttrib("-R", path)
			return FileOpen(path, "rw", "UTF-16")

		} catch Error as e
			self.PanicMessage("Failed to open file.`nError detail: " e.Message "`n" e.Stack, A_ThisFunc)
	}



	static GetFileName(path) {
		back_slash_pos := InStr(path, "\", , -1), forw_slash_pos := InStr(path, "/", , -1)
		file_full_name := back_slash_pos == 0 and forw_slash_pos == 0
			? path
			: SubStr(path, back_slash_pos > forw_slash_pos ? back_slash_pos+1 : forw_slash_pos+1)

		dot_pos := InStr(file_full_name, ".", , -1)
		file_name := dot_pos == 0
			? file_full_name
			: SubStr(file_full_name, 1, dot_pos-1)

		return StrLen(file_name) == 0
			? false
			: file_name
	}



	static PanicMessage(msg, from := "") {
		MsgBox(msg, "Panic" (from == "" ? "" : " at " from), "Iconx")
		ExitApp
	}
}



; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



;@Ahk2Exe-UpdateManifest 0

;@Ahk2Exe-SetDescription Workman layout for AutoHotkey
;@Ahk2Exe-SetFileVersion 1.2.0
;@Ahk2Exe-SetProductName Workman
;@Ahk2Exe-SetProductVersion 　
;@Ahk2Exe-SetCompanyName https://workmanlayout.org
;@Ahk2Exe-SetCopyright The Workman Keyboard Layout created by OJ Bucao.
;@Ahk2Exe-SetLanguage 0x0409 ; English_US
;@Ahk2Exe-SetOrigFilename WorkmanAHK.exe

;@Ahk2Exe-SetMainIcon .\icon\wm-i1.ico       ; Default icon.
;;@Ahk2Exe-AddResource .\icon\wm-if.ico, 160 ; The .ahk file icon.
;@Ahk2Exe-AddResource .\icon\wm-i2.ico, 206  ; "Suspend Hotkeys" status.
;;@Ahk2Exe-AddResource .\icon\wm-i3.ico, 207 ; "Pause Script" status.
;;@Ahk2Exe-AddResource .\icon\wm-i4.ico, 208 ; "Suspend Hotkeys" and "Pause Script".

