#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;mouse movement library
#include, %A_ScriptDir%\MouseDelta.ahk
;perlin noise library
#Include, %A_ScriptDir%\noise.ahk

#SingleInstance, Force

md := new MouseDelta("MouseEvent").Start()

MouseEvent(MouseID, x := 0, y := 0){
    MouseGetPos, mX, mY
	ScaleFactor := noise(mX / 100, mY / 100) * 2
 
	if (MouseID){
		x *= ScaleFactor, y *= ScaleFactor
		DllCall("mouse_event",uint,1,int, x ,int, y,uint,0,int,0)
	}
}