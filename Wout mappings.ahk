#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#Persistent
#InstallKeybdHook ; hopefully this overrides system global shortcuts
#include Lib\AutoHotInterception.ahk

AHI := new AutoHotInterception()
; Acer built-in keyboard
id1 := AHI.GetDeviceIdFromHandle(false, "ACPI\VEN_1025&DEV_0759")
cm1 := AHI.CreateContextManager(id1)

GroupAdd, Terminal, ahk_exe WindowsTerminal.exe
GroupAdd, Code, ahk_exe Code.exe
GroupAdd, Explorer, ahk_class CabinetWClass
GroupAdd, Chrome, ahk_exe Chrome.EXE

NoPress := true
Return

ShowToolTip(Tip) {
	ToolTip, %Tip%
	SetTimer, RemoveToolTip, -1000
}
RemoveToolTip:
ToolTip
Return

+CapsLock::
NoPress := !NoPress
ShowToolTip(NoPress ? "keyboard disabled": "keyboard enabled")
Return

#if NoPress && cm1.IsActive
::aaa::JACKPOT
q::Return
w::Return
e::Return
r::Return
t::Return
y::Return
u::Return
i::Return
o::Return
p::Return
[::Return
]::Return
a::Return
s::Return
d::Return
f::Return
g::Return
h::Return
j::Return
k::Return
l::Return
SC027::Return
'::Return
SC02B::Return
z::Return
x::Return
c::Return
v::Return
b::Return
n::Return
m::Return
,::Return
.::Return
/::Return
Space::Return
LAlt::Return
#if

Sleep::Return

#IfWinActive, ahk_group Terminal
^BackSpace::Send {Esc}{BackSpace}
#IfWinActive

ShowHide(search, exec) {
	if WinExist(search) {
		if (WinActive(search)) {
			WinMinimize
		} else {
			WinActivate
		}
	} else {
		Run, %exec%
	}
}
GroupOrExec(group, exec) {
	if WinExist("ahk_group ".group) {
		GroupActivate, group, R
	} else {
		Run, %exec%
	}
}

#!^+s::ShowHide("ahk_exe Slack.exe", "Slack.exe")
#!^+b::ShowHide("ahk_exe Station.exe", "Station.exe")
#!^+f::ShowHide("Google Hangouts", "Chrome.exe")

#!^+t::
if WinExist("ahk_group Terminal") {
	GroupActivate, Terminal, R
} else {
	; https://stackoverflow.com/a/54927424/124416
	Run, shell:AppsFolder\Microsoft.WindowsTerminal_8wekyb3d8bbwe!App
}
Return

#!^+d::Run, shell:AppsFolder\Microsoft.WindowsTerminal_8wekyb3d8bbwe!App

#!^+k::
if WinExist("ahk_group Code") {
	GroupActivate, Code, R
} else {
	Run, C:\Program Files\Microsoft VS Code\Code.exe
}
Return

$#!^+r::
if WinActive("ahk_group Explorer") {
	GroupActivate, Explorer, R
} else {
	WinGetTitle, path, A
	if RegExMatch(path, "\*?\K(.*)\\[^\\]+(?= [-*] )", path)
		if (FileExist(path) && A_ThisHotkey = "^+e") {
			Run explorer.exe /select`,"%path%"
			Return
		}
	Run explorer.exe
}
Return

#!^+c::
if WinExist("ahk_group Chrome") {
	GroupActivate, Chrome, R
} else {
	Run, Chrome.exe
}
Return

#^/::
WinGet MX, MinMax, A
if MX {
	WinRestore, A
} else {
	WinMaximize, A
}
Return

#^.::CenterWindow("A")

!SC027::Send …

CenterWindow(WinTitle)
{
	WinGet MX, MinMax, %WinTitle%
	if (MX) {
		Return
	}
	WinGetPos, X, Y, Width, Height, %WinTitle%
	SysGet mc, MonitorCount
	Loop % mc {
		SysGet m, Monitor, %A_Index%
		s = %s%`nx %mLeft%:%mRight%  y %mTop%:%mBottom%
		MsgBox  %s% %X% %Y% %Width% %Height%
		if (X >= mLeft && X <= mRight && Y >= mTop && Y <= mBottom) {
			WinMove, %WinTitle%,, Max(mLeft, mLeft + (mRight - mLeft)/2 - Width/2), Max(mTop, mTop + (mBottom - mTop)/2 - Height/2), Min(mWidth, Width), Min(mHeight, Height)
			Return
		}
	}
	MsgBox  %s% %X% %Y% %Width% %Height%
}

#PgDn:: ; Next window
WinGet, Proc, ProcessName, A
WinSet, Bottom,, A
WinActivate, ahk_exe %Proc%
Return

#PgUp:: ; Last window
WinGet, Proc, ProcessName, A
WinActivateBottom, ahk_exe %Proc%
Return
