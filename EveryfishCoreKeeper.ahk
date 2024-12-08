#SingleInstance Force
#Include "lib/FishingStateMachine.ahk"
readyToStart := false
startFishing := false
instructions := "1. Abre Core Keeper (¿no me digas? 😄)`n2. Mueve tu personaje a una posición donde el agua esté a tu derecha`n3. Equipa tu caña de pescar`n4. Presiona CTRL + F para comenzar a pescar. No te muevas.`n`nControles:`nPresiona CTRL + F para detener/iniciar el proceso`nPresiona CTRL + Q para cerrar este script"
resultOk := MsgBox("¡Hola pescadores de Core Keeper!`n`n¡Es un buen día para ir a pescar, ¿verdad? ¡Huho!`n`n" . instructions, "Core Keeper - Pescador Automático", 0)
readyToStart := resultOk = "OK"
if !readyToStart
    ExitApp
fishingMachine := FishingStateMachine()
Loop {
    if (!startFishing) {
        continue
    }
    If !WinExist("Core Keeper") {
        MsgBox("Core Keeper no está abierto. Necesitas seguir estas instrucciones:`n`n" . instructions, "Pescador Automático - Core Keeper no está abierto", "OK")
        startFishing := false
        fishingMachine.reset()
        continue
    }
    If !WinActive("Core Keeper") {
        yesResult := MsgBox("Core Keeper necesita estar en primer plano.`n`n¿Quieres que lo active por ti?", "Pescador Automático - Core Keeper no está activo", "YesNo")
        if (yesResult = "Yes"){
            WinActivate("Core Keeper")
            setMachinesWindowBoundries()
            startFishing := true
        } else if (yesResult = "No"){
            startFishing := false
        }
        fishingMachine.reset()
        continue
    } else if (!fishingMachine.areWindowBoundriesSet()){
        setMachinesWindowBoundries()
    }
    fishingMachine.handleState()
}
setMachinesWindowBoundries(){
    global fishingMachine
    WinGetPos(&WinX, &WinY, &WinW, &WinH)
    fishingMachine.setWindowBoundaries(WinW, WinH)
}
$^f::{
    global
    if(readyToStart) {
        startFishing := !startFishing
        fishingMachine.reset()
    }
}
$^q::ExitApp
