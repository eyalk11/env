﻿#Requires AutoHotkey v2.0
#Warn  ; Enable warnings to assist with detecting common errors.
KeyHistory(0)
#SingleInstance Force
; #NoTrayIcon
#InputLevel 0
#UseHook true
SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_MyDocuments "\..")

#include %A_ScriptDir%\programs_setup.ahk

A_HotkeyModifierTimeout := 10
A_MenuMaskKey := "vkFF"

; Include if exists - intended to be local to each machine
; Example: Google suite, override and add new
; GCalendar(){
;     Run C:\Users\user\Desktop\Google Calendar.lnk
; }
; calendar=GCalendar
; GChat(){
;     Run C:\Users\user\Desktop\Google Chat.lnk
; }
; chat=GChat
; #If IsPrefix("exe")
; m::Run C:\Users\user\Desktop\Gmail.lnk
; c::Run C:\Users\user\Desktop\Google Meet.lnk
; #If
#Include *i %A_MyDocuments%\local shortcuts.ahk

#Include %A_Scriptdir%\programs_hotkeys.ahk


