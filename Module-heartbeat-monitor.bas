'--------------------------------------------------------------
'                   Thomas Jensen | uCtrl.net
'--------------------------------------------------------------
'  file: AVR_HEARTBEAT_MONITOR
'  date: 15/05/2006
'--------------------------------------------------------------

$regfile = "attiny2313.dat"
$crystal = 4000000
Config Portd = Input
Config Portb = Output
Config Watchdog = 1024

Dim A As Byte
Dim Alarm As Integer
Dim Module0 As Integer
Dim Module1 As Integer
Dim Module2 As Integer
Dim Module3 As Integer
Dim Module4 As Integer
Dim Module5 As Integer
Dim Alarmled As Integer

Alarm = 0
Module0 = 0
Module1 = 0
Module2 = 0
Module3 = 0
Module4 = 0
Module5 = 0
Alarmled = 0

'boot
Portb = 0

For A = 1 To 3
    Portb.0 = 1
    Waitms 50
    Portb.1 = 1
    Waitms 50
    Portb.2 = 1
    Waitms 50
    Portb.3 = 1
    Waitms 50
    Portb.4 = 1
    Waitms 50
    Portb.5 = 1
    Waitms 50
    Portb.7 = 1
    Waitms 50
    Portb.6 = 1
    Waitms 250
    Portb = 0
    Waitms 250
Next A

Waitms 1000
Start Watchdog
Portb = 0

Main:
'setting 10 second timeout
If Pind.0 = 0 And Module0 <> 1 Then Module0 = 101
If Pind.1 = 0 And Module1 <> 1 Then Module1 = 101
If Pind.2 = 0 And Module2 <> 1 Then Module2 = 101
If Pind.3 = 0 And Module3 <> 1 Then Module3 = 101
If Pind.4 = 0 And Module4 <> 1 Then Module4 = 101
If Pind.5 = 0 And Module5 <> 1 Then Module5 = 101

'set status LEDs
If Module0 <> 1 Then Portb.0 = Not Pind.0
If Module1 <> 1 Then Portb.1 = Not Pind.1
If Module2 <> 1 Then Portb.2 = Not Pind.2
If Module3 <> 1 Then Portb.3 = Not Pind.3
If Module4 <> 1 Then Portb.4 = Not Pind.4
If Module5 <> 1 Then Portb.5 = Not Pind.5

'module 0
If Module0 > 1 Then Module0 = Module0 - 1
If Module0 = 1 Then Alarm = 1

'module 1
If Module1 > 1 Then Module1 = Module1 - 1
If Module1 = 1 Then Alarm = 1

'module 2
If Module2 > 1 Then Module2 = Module2 - 1
If Module2 = 1 Then Alarm = 1

'module 3
If Module3 > 1 Then Module3 = Module3 - 1
If Module3 = 1 Then Alarm = 1

'module 4
If Module4 > 1 Then Module4 = Module4 - 1
If Module4 = 1 Then Alarm = 1

'module 5
If Module5 > 1 Then Module5 = Module5 - 1
If Module5 = 1 Then Alarm = 1

'reset switch
If Pind.6 = 0 Then
   Alarm = 0
   Module0 = 0
   Module1 = 0
   Module2 = 0
   Module3 = 0
   Module4 = 0
   Module5 = 0
   End If

'setting alarm
If Alarm = 1 Then
   If Module0 = 1 Then Portb.0 = 1
   If Module1 = 1 Then Portb.1 = 1
   If Module2 = 1 Then Portb.2 = 1
   If Module3 = 1 Then Portb.3 = 1
   If Module4 = 1 Then Portb.4 = 1
   If Module5 = 1 Then Portb.5 = 1
   If Alarmled = 0 Then Alarmled = 6
   End If

'setting alarmled
If Alarmled > 0 Then Alarmled = Alarmled - 1
If Alarmled = 4 Then Portb.6 = 1
If Alarmled = 1 Then Portb.6 = 0

'loop cycle
Reset Watchdog
Portb.7 = 1
Waitms 25
Portb.7 = 0
Waitms 75
Goto Main
End
