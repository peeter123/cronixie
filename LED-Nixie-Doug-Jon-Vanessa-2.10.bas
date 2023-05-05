' *************************************
' *      LED-NIXIE Clock Demo         *
' *  LED-Basic >= 15.2.8 required     *
' *  modified by Vanessa Ver. 2.10    *
' *  partially from Doug's ver.D1.02  *
' *  partially from Jon's ver.J2.02   *
' *************************************
'
' Operations manual:
'
' On startup, the display shows the software version for approx. 2 seconds.
' To reset to factory defaults: as soon as the software version number displays,
' press and hold the button until unit beeps.
'
' Usage:
'
' Turn the knob to adjust the display colour.(0-9 solid colour, 10 white, 11 incandecent,
' 12-14 multi colour). Short press knob to switch between Clock and Date display,
' Changing display also ensures colour setting is saved when restarting.
' Date display automatically returns to clock display after approx. 3 seconds.
'
' If Night mode is on, long press spinner button to manual set it to off.
' Long press spinner button during time display to enter settings menu (white).
' Long press button during date display to enter the system menu (blue).
' Turn knob to choose an option, short press to select, long press to exit.
' After 4 seconds inactivity, the unit returns to display mode
'               (without saving changes).
'
' Settings menu (white):
' Setting 0: beeper on / off (default 1)
'                0 = off
'                1 = on
' Setting 1: 12 / 24 hour clock display (default 24)
'                12 = 12 hour clock
'                24 = 24 hour clock
' Setting 2: Set the time (24 hour clock)
'                Short press changes between hours, minutes, seconds
'                long press saves the time
' Setting 3: Date format display (default 0)
'                0 = DDMMYY
'                1 = MMDDYY
'                2 = YYMMDD
' Setting 4: Set the date
'                Short press changes between days, months, years
'                long press saves the date
' Setting 5: Alarm on / off (default 0)
'                0 = off
'                1 = on
' Setting 6: Set alarm time (24 hour clock, default 12:00)
'                Short press changes between hours and minutes
'                Long press saves the alarm time
' Setting 7: Auto date display on / off (default 0)
'                0 = off
'                1 = on
' Setting 8: Timer (max 23:59:00)
'                Short press changes between hours and minutes
'                Long press sets timer duration
'                Then short press to start / stop timer
'                To exit, long press whilst timer stopped
' Setting 9: Stopwatch (max 23:59:59)
'                Short press to start / stop stopwatch
'                To exit, long press whilst stopwatch stopped
'
' System menu (blue):
' System 0: adjust brightness (default 12)
'                1..15 = brightness level,
'                0 = automatic brightness (set using sensor)
' System 1: Minimum brightness for auto brightness (default 2)
'                0...15 = minimum brightness (no brightness level)
' System 2: Time correction offset faster or slower (default 1)
'                0 = slower offset
'                1 = faster offset
' System 3: set Time offset n cycles per 32 sek. (default 0)
'                0...510 = Offset in cycles per 32 sek.
' System 4: Party Mode On / Off (default 0)
'                0 = off
'                1 = on
' System 5: Slot machine mode on / off (default 0)
'                0 = off
'                1 = on
' System 6: Second flipping mode on / off (default 0)
'                0 = off
'                1 = on
' System 7: Digit fade mode (default 3)
'                1..5 = digit fade duration
'                0 = off
' System 8: Set the Night mode duration
'        if begin and end are the same, Night mode is disabled.
'        During Night mode on, Partymode and Slot machine are disabled.
'                Short press changes between begin hour, begin minute (yellow)
'                long press saves, then -->
'                Short press changes between end hour, end minute (green)
'                long press saves
' System 9: Hide seconds shifted / on / off (default 0)
'                0 = off
'                1 = on
'                2 = shifted time to the center of the clock
'
'
' All settings remain in case of power failure (EEPROM).
' The alarm is prioritised over the timer and stopwatch.
' Softwareversion check on startup.
'
' Slot machine mode: at 4, 8, 14, 18, 24... minutes past the hour, LEDs are lit
' at random for 10 seconds.
' Party mode: every other minute (01, 03, 05...), one of 7 "party 'displays" at
' random are shown for a few seconds.
' Second flipping mode: flipping from '9' to '0', the seconds display
' cycles through 9...8...7... ...0. If on, Fade mode has no function !
' When alarm is On, alarm time displays twice every ten minutes (minutes 02, 06,
' 12, 16, 22...) in red.
' Fade mode: Digits are fading depending on value. NOT working when Second flipping
' mode is on !
' Night mode: brightness on minimum at night mode duration.
'        if begin and end are the same, Night mode is disabled.
'        During Night mode on, Partymode and Slot machine are disabled.
'
'
' If connected to a PC running LED-Basic, the current EEPROM values are
' displayed on the screen at program start for debugging purposes.
'
'******************************************************************************
### L60 CGRB P1 S2 M92 F40
' Set initial EEPROM state (for testing, uncomment to set on run)
'    IO.eewrite(0, 210)           ' 0 = Softwareversion
'    IO.eewrite(1, 11)            ' 1 = Time Colour           (11)
'    IO.eewrite(2, 5)             ' 2 = Date Colour            (5)
'    IO.eewrite(3, 1)             ' 3 = Beep                   (1)
'    IO.eewrite(4, 12)            ' 4 = Brightness            (12)
'    IO.eewrite(5, 0)             ' 5 = Alarm                  (0)
'    IO.eewrite(6, 12)            ' 6 = Alarm Hour            (12)
'    IO.eewrite(7, 0)             ' 7 = Alarm Minute           (0)
'    IO.eewrite(8, 0)             ' 8 = Auto Date Display      (0)
'    IO.eewrite(9, 0)             ' 9 = Party Mode             (0)
'    IO.eewrite(10, 0)            ' 10 = Time Offset           (0)
'    IO.eewrite(11, 1)            ' 11 = Time Offset +/-       (1)
'    IO.eewrite(12, 2)            ' 12 = Min Auto Bright       (2)
'    IO.eewrite(13, 0)            ' 13 = Slot Machine          (0)
'    IO.eewrite(14, 1)            ' 14 = 24 Hour Clock         (1)
'    IO.eewrite(15, 0)            ' 15 = Seconds flip          (0)
'    IO.eewrite(16, 0)            ' 16 = Date format           (0)
'    IO.eewrite(17, 3)            ' 17 = Digits fade           (3)
'    IO.eewrite(18, 0)            ' 18 = Nightmode             (0)
'    IO.eewrite(19, 0)            ' 19 = Begin Nightmode Hour  (0)
'    IO.eewrite(20, 0)            ' 20 = Begin Nightmode Minute(0)
'    IO.eewrite(21, 0)            ' 21 = End Nightmode Hour    (0)
'    IO.eewrite(22, 0)            ' 22 = End Nightmode Minute  (0)
'    IO.eewrite(23, 0)            ' 23 = Hide seconds          (0)
'
' Nixie Digit Index
10: data 5,0,6,1,7,2,8,3,9,4
'
' Colour Index (0..14)
20: data 5,20,50,90,130,160,200,260,300,340,1000,1001,1002,1003,1004
'
' Brightness Table
30: data 0,3,6,9,16,25,37,51,68,87,109,133,160,189,221,255
'
' Music Timer / Stopwatch max :-)
40: data 13,200,15,200,17,200,13,200,13,200,15,200,17,200,13
    data 200,17,200,18,200,20,400,17,200,18,200,20,400
'   alternate uk version
'40: data 15,15,15,18,18,18,19,19,20,20,20,21,21,21,22,22
'    data 27,25,0,0,20,22,0,0,32,30,27,30,0,0,37
'
' LED-INDEX SET
    led.ihsv(0, 0, 0, 0)      ' off
    led.ihsv(2, 0, 0, 128)    ' white (settings)
    led.ihsv(3, 2, 255, 128)  ' red (set alarm)
    led.ihsv(4, 110, 254, 96) ' green (timer / stopwatch)
    led.ihsv(5, 37, 254, 96)  ' yellow (set date / time)
    led.ihsv(6, 240, 255, 128)' blue (system menu)
    LED.blackout() ' turn off all LEDs
'
' Version
    LED.iled(2, 30 + read 10, 2)
    LED.iled(2, 40 + read 10, 1)
    LED.iled(2, 50 + read 10, 0)
    LED.show()
    delay 2000
'
' EEPROM INIT
    if (IO.eeread(0)) <> 210 or IO.keystate() = 1 gosub 8000 'first time or reset
' EEPROM Output to Terminal
    gosub 8050
'
'==============================================================================
' GLOBAL VARS
' c = colour, m = mode, t = temp, i = loop, j = counter, r = temp,
' x = alarm silenced, z = counter, h = hue, v = brightness, b = brightness subtraction
' l = transition brightness, u = last second shown for fade
'==== STARTUP ===================================
'
99:
    r = IO.eeread(10)   ' Read Offset Value
    if (IO.eeread(11)) = 0 then r = r * -1 ' negativ cycles
    IO.sys(99, r)
    b = 0  ' brightness subtraction
    l = 0  ' Transition brightness
    u = 11 ' Last second shown
    j = 59 ' Initial LED location for seconds flip
    m = 0  ' Initially in time display
    x = 0  ' Alarm not silenced
    goto 190
'==== MAIN LOOP =================================
100:
    t = IO.getenc()  ' Read Encoder
    if t = c goto 105
    c = t            ' color set (knob turned)
    z = 0            ' counter reset
105:
    r = IO.getrtc(0) ' seconds
    s = IO.getrtc(1) ' minutes
    a = IO.getrtc(2) ' hours
    if r = 0 then x = 0 ' reset alarm silencer
    if r = 0 and (IO.eeread(19)) = (IO.eeread(21)) and (IO.eeread(20)) = (IO.eeread(22)) goto 108 ' no night duration
    if r = 0 and (IO.eeread(19)) = a and (IO.eeread(20)) = s then IO.eewrite(18, 1) ' nightmode on
    if r = 0 and (IO.eeread(21)) = a and (IO.eeread(22)) = s then IO.eewrite(18, 0) ' nightmode off
108:
    if x = 0 and (IO.eeread(5)) = 1 and (IO.eeread(6)) = a and (IO.eeread(7)) = s gosub 9105 ' alarm so ringing
    if s % 10 = 4 or s % 10 = 8 and r = 2 and m = 0 and (IO.eeread(18)) = 0 and (IO.eeread(13)) = 1 gosub 4000 ' random (slot machine)
    if s % 10 = 1 or s % 10 = 3 or s % 10 = 5 or s % 10 = 7 or s % 10 = 9 and m = 0 and (IO.eeread(18)) = 0 and (IO.eeread(9)) = 1 and r = 2 goto 2900 ' party mode
    if m = 0 and r = 50 and (IO.eeread(8)) = 1 goto 180 ' date auto display
    if s % 10 = 2 or s % 10 = 6 and (IO.eeread(5)) = 1 and r = 2 gosub 700 ' show alarm time
    gosub 9000        ' Get key. 0 = none 1 = short press 2 = long press
    if k = 1 goto 110 ' short press: change display mode
    if k = 2 and (IO.eeread(18)) = 1 goto 205 ' nightmode manual off
    if k = 2 and m = 1 goto 10100 ' system menu
    if k = 2 goto 10000 ' settings menu
    goto 200 ' k = 0
110:
'==== SHORT PRESS: MODE SWITCH ====
    gosub 9100         ' BEEP
    if m = 0 goto 180 ' change time to date display
    if m = 1 goto 185 ' change date to time display
180: ' change from time to date display
    if (IO.eeread(m + 1)) <> c then IO.eewrite(m + 1, c)' saves current time colour to EEPROM
    m = 1               ' change to date mode
    if k = 1 then x = 1 ' silence alarm when spinner pressed
    goto 190            ' done
185: ' change from date to time display
    if (IO.eeread(m + 1)) <> c then IO.eewrite(m + 1, c)' saves current date display to EEPROM
    m = 0               ' mode change to time
190: 'NB: also entry point from start
    c = IO.eeread(m + 1) ' sets colour from eeprom
    IO.setenc(c, 14, 0)  ' set spinner to 15 colour options + wraparound
    z = 0 ' reset counter
200:
    if z & 15 <> 0 goto 210 ' only check brightness once per 15 cycles
205:
    if k = 2 then IO.eewrite(18, 0) ' nightmode manual off
    i = IO.getldr() + IO.eeread(12) ' measured brightness + minimum overall brightness
    if i > 254 then i = 254 ' do not exceed max brightness
    if (IO.eeread(4)) = 0 then v = i else v = read 30, IO.eeread(4)' Set brightness from auto or EEPROM
    if (IO.eeread(18)) = 1 then v = read 30, 1 ' Set brightness to nightmode
210:
    LED.iall(0) ' Clear display
    if m <> 0 goto 220 ' If date mode, skip time display
    gosub 500      ' Show time - set LEDs
    LED.show()     ' Show time - show LEDs
    goto 100       ' Back to beginning of loop
220:
    if m <> 1 goto 100 ' If not date mode, re-enter loop
    gosub 600      ' SHOW DATE - set LEDs
    LED.show()     ' Show date - show LEDs
    if z > 120 goto 185  ' Return to TIME display after ca. 3sec
    goto 100 ' Back to beginning of loop
'================================================
' handle flip fade animation
400:
    if g = 0 goto 410
    b = v - l ' set the subtraction value to our transition brightness
    if p <> 0 or n <> 0 or (IO.eeread(14)) = 1 gosub 1000
    b = l
    n = i
410:
    if p <> 0 or n <> 0 or (IO.eeread(14)) = 1 gosub 1000
    b = 0
    return
'================================================
' SHOW TIME routine
' VAR: n, p, j, r, o
500:
    o = 0 ' number offset
    g = 0
    if (IO.eeread(23)) > 0 then goto 515 ' check hide seconds
    if r % 10 = 9 and (IO.eeread(15)) = 1 goto 510  ' seconds flip
    if (IO.eeread(17)) > 0 and (IO.eeread(15)) = 0 then g = 1 ' digit fade if not second flip
    n = r % 10
    p = 50
    ' calculate the flip brightness even if we're not using it
    if u <> n then l = 0
    if u <> n then u = n
    i = 6 - IO.eeread(17) ' fade value
    l = l + 1 + i * (v / 50)  ' increase the level of transition brightness
    if l > v then l = v   ' don't increase the level beyond the set brightness
    ' finished calculating brightness
    i = n - 1
    if i < 0 then i = 9
    gosub 400        ' display seconds 1s
    if g = 1 and r % 10 = 0 then g = 1 else g = 0' 10s seconds flip if our is a 0
    n = r / 10
    p = 40
    i = n - 1
    if i < 0 then i = 5
    gosub 400        ' display seconds 10s
    j = 59
    goto 520          ' to minutes
510:
    n = r / 10        ' Seconds Flip routine
    p = 40
    gosub 1000        ' Seconds 10
    n = j % 10
    p = 50
    gosub 1000        ' Seconds 1
    j = j - 1
    delay 98          ' approx 0.1 seconds between flips
    goto 520
515:
    if (IO.eeread(23)) = 2 then let o = 10
520:
    if g = 1 and r / 10 = 0 then g = 1 else g = 0 'decide if we need to fade this number
    n = s % 10
    p = 30 + o
    i = n - 1
    if i < 0 then i = 9
    gosub 400        ' Minutes 1
    if g = 1 and s % 10 = 0 then g = 1 else g = 0 'decide if we need to fade this number
    n = s / 10
    p = 20 + o
    i = n - 1
    if i < 0 then i = 5
    gosub 400        ' Minutes 10
    if g = 1 and s / 10 = 0 then g = 1 else g = 0 'decide if we need to fade this number
    if (IO.eeread(14)) = 0 and a > 12 then a = a - 12 ' 12 hour clock, hours 13-23 changed to 1-11
    if (IO.eeread(14)) = 0 and a = 0 then a = 12  ' 12 hour clock, hour 0 = 12
    n = a % 10
    p = 10 + o
    i = n - 1
    if i < 0 then i = 9
    if (IO.eeread(14)) = 0 and a / 10 = 0 and n = 1 then i = 2 ' roll to 1:00
    if (IO.eeread(14)) = 1 and a / 10 = 0 and n = 0 then i = 3 ' roll to 0:00
    gosub 400        ' Hours 1
    i = 0 ' figure out if we need to flip the time
    if (IO.eeread(14)) = 0 and a / 10 = 0 and a % 10 = 1 then i = 1 ' we need to handle the rollover to 1:00
    if (IO.eeread(14)) = 1 and a / 10 = 0 and a % 10 = 0 then i = 1 ' we need to handle the rollover to 0:00
    if g = 1 and i = 1 then g = 1 else g = 0 ' 10s hours flip if our 1s minute is a 0
    n = a / 10
    p = 0 + o
    i = n - 1
    if i < 0 and (IO.eeread(14)) = 0 then i = 1
    if i < 0 and (IO.eeread(14)) = 1 then i = 2
    gosub 400        ' Hours 10
    if z < 32761 then z = z + 1 else z = 0
    return
'================================================
' SHOW DATE
' VAR: n, p
600:
    s = IO.getrtc(3)  'day
    n = s / 10
    p = (IO.eeread(16)) * 20 ' Ddmmyy, mmDdyy, yymmDd (IO.eeread(16))=0,1,2
    gosub 1000        ' Day 10s
    n = s % 10
    p = (IO.eeread(16)) * 20 + 10 ' dDmmyy, mmdDyy, yymmdD (IO.eeread(16))=0,1,2
    gosub 1000        ' Day units
    s = IO.getrtc(4)  'month
    n = s / 10
    if (IO.eeread(16)) = 1 then p = 0 else p = 20 ' Mmddyy, ddMmyy / yyMmdd
    gosub 1000        ' Month 10s
    n = s % 10
    if (IO.eeread(16)) = 1 then p = 10 else p = 30 ' mMddyy, ddmMyy / yymMdd
    gosub 1000        ' Month units
    s = IO.getrtc(5)  ' year
    n = (s % 100) / 10 ' 2 digit year
    if (IO.eeread(16)) = 2 then p = 0 else p = 40 ' Yymmdd, ddmmYy / mmddYy
    gosub 1000        ' Year 10s
    n = s % 10
    if (IO.eeread(16)) = 2 then p = 10 else p = 50 ' yYmmdd, ddmmyY/mmddyY
    gosub 1000        ' Year units
    s = IO.getrtc(1) ' minutes reset to s
    z = z + 1
    return
'================================================
' SHOW Alarm
' VAR: n, p, s, i
700:
    if (IO.eeread(5)) = 1 and (IO.eeread(6)) = a and (IO.eeread(7)) = s return ' alarm ringing so don't display alarm time
    LED.iall(0) ' Clear display
    t = IO.eeread(6)
    for i = 50 downto 10 step 10
     LED.iled(3, i + read 10, t / 10)
     LED.show()
     delay 200
     LED.iled(0, i + read 10, t / 10)
    next i
    LED.iled(3,     read 10, t / 10)
    for i = 50 downto 20 step 10
     LED.iled(3, i + read 10, t % 10)
     LED.show() ' display
     delay 200 ' cycle 1/5 second
     LED.iled(0, i + read 10, t % 10)
    next i
    LED.iled(3, 10 + read 10, t % 10)
    t = IO.eeread(7)  ' alarm minutes
    for i = 50 downto 30 step 10
     LED.iled(3, i + read 10, t / 10)
     LED.show()
     delay 200
     LED.iled(0, i + read 10, t / 10)
    next i
    LED.iled(3,20 + read 10, t / 10)
    for i = 50 downto 40 step 10
     LED.iled(3, i + read 10, t % 10)
     LED.show()
     delay 200
     LED.iled(0, i + read 10, t % 10)
    next i
    LED.iled(3, 30 + read 10, t % 10)
    LED.show()
    delay 200
    LED.iled(3, 50 + read 10,0)
    LED.show()
    delay 200
    LED.iled(0, 50 + read 10,0)
    LED.iled(3, 40 + read 10,0)
    LED.show()
    delay 200
    LED.iled(3, 50 + read 10,0)
    LED.show()
    delay 1500
    return
'================================================
' Character display routine for date / time (using set colour mode)
1000:
    t = read 20, c ' read colour value from index
    if t > 360 goto 1010
    LED.ihsv(1, t, 255, v - b) ' set "standard 1 colour" at brightness V
    goto 1090
1010:
    if t <> 1000 goto 1015 ' position 10 = white
    LED.ihsv(1, 0, 0, v - b)
    goto 1090
1015:
    if t <> 1001 goto 1020 ' position 11 = incandecent
    LED.ihsv(1, 25, 205, v - b)
    goto 1090
1020:
    if t <> 1002 goto 1030 ' position 12 = multi-colour
    LED.ihsv(1, h, 255, v - b)
    h = (p * 6 + z) % 360 ' set "standard 1" as 6* position + counter mod 360
    goto 1090
1030:
    if t <> 1003 goto 1040 ' position 13 = gently cycling
    LED.ihsv(1, h, 255, v - b) ' set "standard 1" as counter/4 mod 360
    h = (z / 4) % 360
    goto 1090
1040:
    'we assume t = 1004 = position 14 = gently cycling 2
    led.ihsv(1, h, 255, v - b)
    h = (2 * z + (2 * (50 - p))) % 360
1090:
    LED.iled(1, p + read 10, n) ' show character
    return
'================================================
' party mode
2900:
    if (IO.eeread(5)) = 1 and (IO.eeread(6)) = a and (IO.eeread(7)) = s goto 100 ' alarm ringing so abort
    i = random ' choose one of animations at random
    if i <= 4096 gosub 3000 ' party mode effect 0
    if i > 4096 and i <= 8192 gosub 3100 ' party mode effect 1
    if i > 8192 and i <= 12288 gosub 3200 ' party mode effect 2
    if i > 12288 and i <= 16384 gosub 3300 ' party mode effect 3
    if i > 16484 and i <= 20480 gosub 3400 ' party mode effect 4
    if i > 20480 and i <= 24576 gosub 3500 ' party mode effect 5
    if i > 24576 and i <= 28672 gosub 3600 ' party mode effect 6
    if i > 28672 gosub 3700 ' party mode effect 7
    k = IO.getkey() ' key reset if pressed during Party
    goto 100 ' main loop
'............................................................
3000: ' pixels turning off and on at random, random colours
     for n = 1 to 300
      r = random % 360 ' colour
      a = random % 60  ' position
      led.lhsv(a, r, 255, v)    ' set colour
      if a - 1 >= 0 then LED.iled(0, a - 1) ' turn off pixel below current
      led.show()
      delay 50
     next n
     return
'............................................................
3100: ' two pixels of two random colours cycling and crossing each other
    for n = 1 to 3
3110:
    a = Random % 360
    r = Random % 360
    if a = r goto 3110
     for i = 0 to 60
      LED.iall(0)
      led.lhsv(i, a, 255, v)       ' Colour
      led.lhsv(60 - i, r, 255, v) ' Colour
      led.show()
      delay 80
     next i
    next n
    return
'............................................................
3200: ' two pairs of two pixels cycling and crossing each other
    a = Random % 360
    r = Random % 360
    n = Random % 360
    z = Random % 360
    for i = 0 to 249
     LED.iall(0)
     led.lhsv(i % 60, z, 255, v)
     led.lhsv(60 - ((i + 1) % 60), a, 255, v)
     led.lhsv((i + 9) % 60, r, 255, v)
     led.lhsv(60 - ((i + 10) % 60), n, 255, v)
     led.show()
     delay 80
    next i
    return
'............................................................
3300: ' 6 sweeps of random colour, increasing in change per sweep
    LED.iall(0)
    z = Random % 360
    for n = 0 to 5
     for i = 60 downto 0
      if n % 2 = 0 then led.lhsv(i, (z + n * i) % 360, 255, v) else led.lhsv(60 - i,(z + n * i) % 360, 255, v)
      led.show()
     next i
    next n
    return
'............................................................
3400: ' "turbulent" rainbow over all pixels, speeding up
    h = random % 360
    for i = 1 to 500
     LED.rainbow(h, 255, v, 0, 60, 3)
     LED.show()
     h = (h + i / 10) % 360
    next i
    return
'............................................................
3500: ' all pixels solid varying, varying in brightness.
    for z = 1 to 350
     i = random % 100
     if i < 75 goto 3565
     h = ((random % 129) * v) / 128
     LED.ihsv(9,(i * h) % 360, 255, h)
     LED.iall(9)
3565:
     LED.show()
    next z
    return
'............................................................
3600: ' all pixels white, varying in brightness.(TV mode)
    for z = 1 to 350
     i = random % 100
     if i < 75 goto 3665
     h = ((random % 129) * v) / 128
     LED.ihsv(9, 0, 0, h)
     LED.iall(9)
3665:
     LED.show()
    next z
    return
'............................................................
3700: ' cycling through all LEDs 0-59 in increasing colours with random white
    LED.ihsv(9, 0, 0, v)
    g = 0 'Test variable, to exit routine
3701: 'Pixel counter index
    data 5,0,6,1,7,2,8,3,9,4,
    data 15,10,16,11,17,12,18,13,19,14,
    data 25,20,26,21,27,22,28,23,29,24,
    data 35,30,36,31,37,32,38,33,39,34,
    data 45,40,46,41,47,42,48,43,49,44,
    data 55,50,56,51,57,52,58,53,59,54,
3702: 'Main loop
    for i = 1 to 59
     if i % 20 = 0 then h = random % 4
     if i % 20 = 0 then LED.irange(9, 10 * h, 10 * h + 9)
     led.ihsv(1, ((i + g) * 7) % 360, 255, v)
     LED.iled(1, read 3701, i)
     LED.show()
     g = g + 1
    next i ' cycle through colours
    if g < 450 goto 3702 ' continue for 10ish seconds
    return
'================================================
' SHOW Slot machine
' VAR: s, n, p, i
4000:
    if (IO.eeread(5)) = 1 and (IO.eeread(6)) = a and (IO.eeread(7)) = s return ' alarm sounding so quit
    for i = 1 to 100
     LED.iall(0) ' Clear display
     s = random
     n = s % 10 ' random number between 0 and 9
     p = 40
     gosub 1000        ' 10s Seconds
     n = ((s % 100)/10) + 1 ' random number between 1 and 10?
     p = 50
     gosub 1000        ' Seconds 1s
     n = (s % 1000)/100
     p = 20
     gosub 1000        ' Minutes 10s
     n = (s % 100)/10
     p = 30
     gosub 1000        ' Minutes 1s
     n = (s % 10000)/1000
     p = 0
     gosub 1000        ' Hours 10s
     n = ((s % 1000)/100) + 1
     p = 10
     gosub 1000        ' Hours 1s
     z = z + 4 ' colour cycling
     LED.show()
     delay 10 + i * 2 ' increasingly slow as time goes on
    next i
    s = IO.getrtc(1) ' temporarily used for random number, reset as minutes
    k = IO.getkey()  ' key reset if pressed during Slot machine
    return
'================================================
' EEPROM INIT
8000:
    print "Resetting EEPROM..."
    print " "
    IO.eewrite(0, 210)           ' 0 = Softwareversion
    IO.eewrite(1, 11)            ' 1 = Time Colour (11)
    IO.eewrite(2, 5)             ' 2 = Date Colour (5)
    IO.eewrite(3, 1)             ' 3 = Beep (1)
    IO.eewrite(4, 12)            ' 4 = Brightness (12)
    IO.eewrite(5, 0)             ' 5 = Alarm (0)
    IO.eewrite(6, 12)            ' 6 = Alarm Hour (12)
    IO.eewrite(7, 0)             ' 7 = Alarm Minute (0)
    IO.eewrite(8, 0)             ' 8 = Auto Display Date (0)
    IO.eewrite(9, 0)             ' 9 = Party Mode (0)
    IO.eewrite(10, 0)            ' 10 = Time Offset (0)
    IO.eewrite(11, 1)            ' 11 = Time Offset Pos/Neg (1)
    IO.eewrite(12, 2)            ' 12 = Min Brightness in Auto (2)
    IO.eewrite(13, 0)            ' 13 = Slot Machine (0)
    IO.eewrite(14, 1)            ' 14 = 24 Hour Clock (1)
    IO.eewrite(15, 0)            ' 15 = Seconds flip (0)
    IO.eewrite(16, 0)            ' 16 = Date format (0)
    IO.eewrite(17, 3)            ' 17 = Digits fade (3)
    IO.eewrite(18, 0)            ' 18 = Nightmode (0)
    IO.eewrite(19, 0)            ' 19 = Begin Nightmode Hour (0)
    IO.eewrite(20, 0)            ' 20 = Begin Nightmode Minute (0)
    IO.eewrite(21, 0)            ' 21 = End Nightmode Hour (0)
    IO.eewrite(22, 0)            ' 22 = End Nightmode Minute (0)
    IO.eewrite(23, 0)            ' 23 = Hide seconds (0)
    print "EEPROM reset."
    print " "
    IO.beep(35)
    delay 500
    IO.beep(0)
    return
'================================================
' Print out EEPROM to Terminal
8050:
    print "           LED-NIXIE Clock"
    print "by Vanessa, partially from Doug and Jon"
     for i = 0 to 23   ' EEPROM data output
     t = IO.eeread(i)
     print "EEP[";i;"] = ";t
    next i
    return
'================================================
' GETKEY
' VAR: k, i, RET: k
' k: 0 = No Key, 1 = Short, 2 = LONG press
9000:
    k = IO.getkey()
    if k = 0 return
    i = 0
9010:
    k = IO.keystate()
    if k = 0 goto 9015
    delay 10
    i = i + 1
    if i < 50 goto 9010
    k = 2
    return
9015:
    k = 1        ' SHORT PRESS
    return
'================================================
' BEEP
9100:
    if (IO.eeread(3)) = 0 return ' no beep if set silent
9105: ' actual beep
    IO.beep(35)
    delay 25
    IO.beep(0)
    return
'================================================
' Settings menu
' VAR p: position, t: temp, y: value
10000:
    gosub 9100        ' BEEP
    p = 0
10005:
    z = 0
    IO.setenc(p, 9, 0) ' Set Encoder (Spinner) to give 0-9 positions
10010:
    t = IO.getenc()    ' Read Encoder
    if t = p goto 10020
    p = t
    z = 0              ' counter reset
10020:
    gosub 9000         ' GETKEY
    if k = 0 goto 10050
    if k = 1 goto 10060
    gosub 9100         ' BEEP. K = 2 so long press so exit
    goto 99            ' long press so exit
10050:
    LED.iall(0) ' Clear display
    if z & 15 < 11 then LED.iled(2, read 10, p) ' White first pixel number flashes.
    LED.show()
    z = z + 1
    if z > 300 goto 99    ' Time-out, back to time display
    goto 10010
10060:
    if p = 0 goto 12000 ' F0: Beep on/off
    if p = 1 goto 12400 ' F1: 12/24 hour time display
    if p = 2 goto 13000 ' F2: Time set
    if p = 3 goto 12600 ' F3: Date format
    if p = 4 goto 14000 ' F4: Date set
    if p = 5 goto 15000 ' F5: Alarm on / off
    if p = 6 goto 16000 ' F6: Alarm time set
    if p = 7 goto 17000 ' F7: Auto date display on / off
    if p = 8 goto 18000 ' F8: Timer
    if p = 9 goto 19000 ' F9: Stopwatch
    goto 10010
'================================================
' System menu
' VAR p: position, t: temp, y: value
10100:
    gosub 9100        ' BEEP
    p = 0
10105:
    z = 0 ' counter
    IO.setenc(p, 9, 0) ' 0-9 options
10110:
    t = IO.getenc()    ' Read Encoder
    if t = p goto 10120
    p = t
    z = 0              ' counter reset
10120:
    gosub 9000         ' GETKEY
    if k = 0 goto 10150
    if k = 1 goto 10160
    gosub 9100         ' BEEP
    goto 99            ' long press so exit
10150:
    LED.iall(0) ' Clear display
    if z & 15 < 11 then LED.iled(6, read 10, p) ' Blue menu option Flashing
    LED.show()
    z = z + 1
    if z > 300 goto 99    ' RETURN if timed out
    goto 10110
10160:
    if p = 0 goto 11000 ' S0: Brightness
    if p = 1 goto 11200 ' S1: Minimum brightness on auto
    if p = 2 goto 12100 ' S2: Time offset polarity
    if p = 3 goto 11100 ' S3: Time offset n cycles per 32 sek.
    if p = 4 goto 20000 ' S4: Party mode on/off
    if p = 5 goto 12200 ' S5: Slot machine on/off
    if p = 6 goto 12500 ' S6: Seconds flip on/off
    if p = 7 goto 15100 ' S7: Digit fade
    if p = 8 goto 21000 ' S8: Night mode duration
    if p = 9 goto 24000 ' S9: Hide seconds shifted/on/off
    goto 10110
'================================================
' S0: BRIGHTNESS SELECTION
' VAR: y,t,z,k
11000:
    gosub 9100          ' BEEP
    y = IO.eeread(4)    ' Read Brightness Value from EEPROM
11005:
    z = 0               ' counter
    IO.setenc(y, 15, 0) ' 15 brightness values
11010:
    t = IO.getenc()
    if t = y goto 11020
    y = t
    z = 0                ' movement so reset counter
11020:
    gosub 9000        ' GETKEY
    if k = 0 goto 11050
    gosub 9100        ' BEEP
    goto  11070       ' short press
11050:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 11060 ' (flashing)
    LED.iled(2, 40 + read 10, y / 10) ' brightness display 10s
    LED.iled(2, 50 + read 10, y % 10) ' brightness units
11060:
    LED.iled(6, read 10, 0) ' show in System 0 i.e. brightness
    LED.show()
    z = z + 1
    if z <= 300 goto 11010 ' timeout
    goto 10105 ' return to system menu without save
11070:
    if y <> (IO.eeread(4)) then IO.eewrite(4, y) ' Write Brightness Value
    goto 10105 ' return to system menu
'================================================
' S3: Time offset n cycles per 32 sek.
' VAR: y,t,z,k
11100:
    gosub 9100          ' BEEP
    y = IO.eeread(10)   ' Read Offset Value
11105:
    z = 0
    IO.setenc(y, 510, 0) ' choices 0-510
11110:
    t = IO.getenc()
    if t = y goto 11120
    y = t
    z = 0
11120:
    gosub 9000        ' GETKEY
    if k = 0 goto 11150
    gosub 9100        ' BEEP
    goto  11170       ' short click
11150:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 11160 ' light pixels only 10 in 15 cycles'
    LED.iled(2, 30 + read 10, y / 100) ' light setting 100s
    LED.iled(2, 40 + read 10, (y / 10) % 10)  ' light setting 10s
    LED.iled(2, 50 + read 10, y % 10)  ' light setting units
11160:
    LED.iled(6, read 10, 3) ' set first pixel blue 3 to indicate menu place
    LED.show()
    z = z + 1
    if z <= 300 goto 11110 ' timeout
    goto 10105 ' return to system menu without save
11170:
    if y <> (IO.eeread(10)) then IO.eewrite(10, y) ' Write Offset Value to EE
    goto 10105 ' return to system menu
'================================================
' S1: MIN BRIGHTNESS for Auto Brightness
' VAR: y,t,z,k
11200:
    gosub 9100          ' BEEP
    y = IO.eeread(12)    ' Read Min Brightness Value from EEPROM
11205:
    z = 0
    IO.setenc(y, 15, 0)  ' range from 0 to 15
11210:
    t = (IO.getenc())
    if t = y goto 11220
    y = t
    z = 0
11220:
    gosub 9000        ' GETKEY
    if k = 0 goto 11250
    gosub 9100        ' BEEP, short press one assumes
    goto  11270
11250:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 11260 ' light pixels for 10 in 15 cycles
    t = y
    LED.iled(2, 40 + read 10, t / 10) ' min brightness 10s
    LED.iled(2, 50 + read 10, t % 10) ' min brightness units
11260:
    LED.iled(6, read 10, 1)    ' system menu blue, 1st pos
    LED.show()
    z = z + 1
    if z <= 300 goto 11210 ' time out
    goto 10105 ' return to system menu without save
11270:
    if y <> (IO.eeread(12)) then IO.eewrite(12, y) ' Write Min Brightness Value
    goto 10105
'================================================
' F0: BEEP SETUP on / off
' VAR: y,t,z,k
12000:
    gosub 9100        ' BEEP
    y = IO.eeread(3)  ' Read Beep Setting
12005:
    z = 0
    IO.setenc(y, 1, 0) ' between 0 and 1
12010:
    t = IO.getenc()
    if t = y goto 12020
    y = t
    z = 0
12020:
    gosub 9000        ' GETKEY
    if k = 0 goto 12050 ' no key
    gosub 9100        ' BEEP short press
    goto  12070
12050:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 12060 ' light pixel for 10 / 15 cycles (flash)
    LED.iled(2, 50 + read 10, y)
12060:
    LED.iled(3, read 10, 0) ' settings menu 0th option
    LED.show()
    z = z + 1
    if z <= 300 goto 12010 ' timeout
    goto 10005 ' return to system menu without save
12070:
    if y <> (IO.eeread(3)) then IO.eewrite(3, y) ' Write Beep Value
    goto 10005
'================================================
' S2: TIME OFFSET polarity
' VAR: y,t,z,k
12100:
    gosub 9100        ' BEEP
    y = IO.eeread(11) ' Read offset polarity from EEPROM
12105:
    z = 0
    IO.setenc(y, 1, 0) ' 0 - 1
12110:
    t = IO.getenc()
    if t = y goto 12120
    y = t
    z = 0 ' reset counter
12120:
    gosub 9000        ' GETKEY
    if k = 0 goto 12150 ' no key
    gosub 9100        ' BEEP short press
    goto  12170
12150:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 12160 'light pixels 10 cycles in 15
    LED.iled(2, 50 + read 10, y)
12160:
    LED.iled(6, read 10, 2) ' blue (system menu) option 2
    LED.show()
    z = z + 1
    if z <= 300 goto 12110 ' time out
    goto 10105 ' return to system menu without save
12170:
    if y <> (IO.eeread(11)) then IO.eewrite(11, y) ' Write offset polarity
    goto 10105
'================================================
' S5: Slot machine on / off
' VAR: y,t,z,k
12200:
    gosub 9100        ' BEEP
    y = IO.eeread(13)  ' Read Slot Machine Value
12205:
    z = 0
    IO.setenc(y, 1, 0) 'options on, off
12210:
    t = IO.getenc()
    if t = y goto 12220
    y = t
    z = 0
12220:
    gosub 9000        ' GETKEY
    if k = 0 goto 12250
    gosub 9100        ' BEEP key pressed
    goto  12270
12250:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 12260 ' light LEDs 10 in 15 cycles
    LED.iled(2, 50 + read 10, y)
12260:
    LED.iled(6, read 10, 5) ' System menu option 5
    LED.show()
    z = z + 1
    if z <= 300 goto 12210 ' timeout
    goto 10105 ' return to system menu without save
12270:
    if y <> (IO.eeread(13)) then IO.eewrite(13, y) ' Write slot machine value
    goto 10105
'================================================
' F1: 24 Hour Clock on / off
' VAR: y,t,z,k
12400:
    gosub 9100        ' BEEP
    y = IO.eeread(14)  ' Read Slot Machine Value
12405:
    z = 0
    IO.setenc(y, 1, 0) ' two options
12410:
    t = IO.getenc()
    if t = y goto 12420
    y = t
    z = 0 ' reset counter
12420:
    gosub 9000        ' GETKEY
    if k = 0 goto 12450
    gosub 9100        ' BEEP key pressed
    goto  12470
12450:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 12460
    t = y + 1 '1 if 12 hour, 2 if 24 hour
    LED.iled(2, 40 + read 10, t) ' 1 or 2
    LED.iled(2, 50 + read 10, 2 * t) ' 2 or 4
12460:
    LED.iled(3, read 10, 1) ' Settings menu, option 1
    LED.show()
    z = z + 1
    if z <= 300 goto 12410 ' time out
    goto 10005 ' return to system menu without save
12470:
    if y <> (IO.eeread(14)) then IO.eewrite(14, y) ' Write 12 hour clock Value
    goto 10005
'================================================
' S6: Second flip on / off
' VAR: y,t,z,k
12500:
    gosub 9100        ' BEEP
    y = IO.eeread(15) ' Read Second Flip Value
12505:
    z = 0
    IO.setenc(y, 1, 0) ' two options
12510:
    t = IO.getenc()
    if t = y goto 12520
    y = t
    z = 0 ' reset counter
12520:
    gosub 9000        ' GETKEY
    if k = 0 goto 12550 ' no key
    gosub 9100        ' BEEP, key
    goto  12570
12550:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 12560 ' light pixel 10 out of 15 cycles
    LED.iled(2, 50 + read 10, y)
12560:
    LED.iled(6, read 10, 6) ' 6th option in blue System menu
    LED.show()
    z = z + 1
    if z <= 300 goto 12510
    goto 10105 ' return to system menu without save
12570:
    if y <> (IO.eeread(15)) then IO.eewrite(15, y) ' Write Seconds flip Value
    goto 10105
'================================================
' F3: Date format
' VAR: y,t,z,k
12600:
    gosub 9100        ' BEEP
    y = IO.eeread(16)  ' Read Date Format Value
12605:
    z = 0
    IO.setenc(y, 2, 0) ' three options
12610:
    t = IO.getenc()
    if t = y goto 12620
    y = t
    z = 0 ' reset counter
12620:
    gosub 9000        ' GETKEY
    if k = 0 goto 12650 ' no key
    gosub 9100        ' BEEP, key
    goto  12670
12650:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 12660 ' light pixel 10 out of 15 cycles
    LED.iled(2, 50 + read 10, y)
12660:
    LED.iled(3, read 10, 3) ' 3rd option in red Settings menu
    LED.show()
    z = z + 1
    if z <= 300 goto 12610 ' time out
    goto 10005 ' return to system menu without save
12670:
    if y <> (IO.eeread(16)) then IO.eewrite(16, y) ' Write date format Value
    goto 10005
'================================================
' F2: TIME SET
' VAR: w,x,y,t,z,k
13000:
    y = IO.getrtc(2)  ' Read Hour
    x = IO.getrtc(1)  ' Read Minute
    w = 0             ' Second = 0
13005: ' hours
    gosub 9100        ' BEEP
    z = 0
    IO.setenc(y, 23, 0) ' 0-23 wraparound
13010:
    t = IO.getenc()
    if t = y goto 13020
    y = t
    z = 0 ' reset counter
13020:
    gosub 9000        ' GETKEY
    if k = 1 goto 13100 ' short press > minutes
    if k = 2 goto 13300 ' long press > save, exit
13050: ' no key pressed
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 13060 ' only light 1st 2 pixels 10 / 15 cycles
    LED.iled(2,      read 10, y / 10) ' hours 10s, white
    LED.iled(2, 10 + read 10, y % 10) ' hours units, white
13060:
    LED.iled(5, 20 + read 10, x / 10) ' minutes 10s, yellow
    LED.iled(5, 30 + read 10, x % 10) ' minutes units, yellow
    LED.iled(5, 40 + read 10, (w * 5) / 10) ' seconds 10s, yellow
    LED.iled(5, 50 + read 10, (w * 5) % 10) ' seconds units, yellow
    LED.show()
    z = z + 1
    if z <= 500 goto 13010    ' time out
    goto 13320
'................................................
13100: ' minutes
    gosub 9100        ' BEEP
    z = 0
    IO.setenc(x, 59, 0) ' 0 - 59 wraparound
13110:
    t = IO.getenc()
    if t = x goto 13120
    x = t
    z = 0 ' reset counter
13120:
    gosub 9000        ' GETKEY
    if k = 1 goto 13200 ' short press > seconds
    if k = 2 goto 13300 ' long press > save, exit
13150:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 13160 ' only show minutes 10 / 15 cycles
    LED.iled(2, 20 + read 10, x / 10) ' minutes, 10s, white
    LED.iled(2, 30 + read 10, x % 10) ' minutes, units, white
13160:
    LED.iled(5,      read 10, y / 10) ' hours, 10s, yellow, constant
    LED.iled(5, 10 + read 10, y % 10) ' hours, units, yellow, constant
    LED.iled(5, 40 + read 10, (w * 5) / 10) 'seconds, 10s, yellow, constant
    LED.iled(5, 50 + read 10, (w * 5) % 10) 'seconds, units, yellow, constant
    LED.show()
    z = z + 1
    if z <= 500 goto 13110    ' timeout
    goto 13320
'................................................
13200: ' seconds
    gosub 9100        ' BEEP
    z = 0
    IO.setenc(w, 11, 0) ' 0 - 55 in 5 second increments, wraparound
13210:
    t = IO.getenc()
    if t = w goto 13220
    w = t
    z = 0
13220:
    gosub 9000        ' GETKEY
    if k = 1 goto 13005 ' short click > hours
    if k = 2 goto 13300 ' long click > save, exit
13250:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 13260 ' only light seconds 10 / 15 cycles
    LED.iled(2, 40 + read 10, (w * 5) / 10) ' seconds 10s white
    LED.iled(2, 50 + read 10, (w * 5) % 10) ' seconds units white
13260:
    LED.iled(5,      read 10, y / 10) ' hours 10s yellow constant
    LED.iled(5, 10 + read 10, y % 10) ' hours units yellow constant
    LED.iled(5, 20 + read 10, x / 10) ' minutes 10s yellow constant
    LED.iled(5, 30 + read 10, x % 10) ' minutes units yellow constant
    LED.show()
    z = z + 1
    if z <= 500 goto 13210    ' time out
    goto 13320
'................................................
13300: ' save, exit
    gosub 9100        ' BEEP
13310:
    IO.setrtc(0, w * 5)    ' Write Seconds
    IO.setrtc(1, x)        ' Write Minutes
    IO.setrtc(2, y)        ' Write Hours
13320:
    goto 10005 ' return to settings menu
'================================================
' F4: DATE SETUP
' VAR: w,x,y,t,z,k
14000:
    y = (IO.getrtc(3)) - 1    ' Read Day
    x = (IO.getrtc(4)) - 1    ' Read Month
    w = (IO.getrtc(5)) % 100  ' Read Year
14005: ' days
    gosub 9100                ' BEEP
    z = 0
    IO.setenc(y, 30, 0)  ' day 1-31
14010:
    t = IO.getenc()
    if t = y goto 14020
    y = t
    z = 0 ' counter reset
14020:
    gosub 9000        ' GETKEY
    if k = 1 goto 14100 ' short push, go to month
    if k = 2 goto 14300 ' long push, save and exit
14050: ' flashing LEDs
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 14060 ' show LEDs in 10 out of every 15 cycles (flash)
    r = (IO.eeread(16)) * 20' day position depending on date format
    LED.iled(2, r + read 10, (y + 1) / 10) ' days 10s
    LED.iled(2, r + 10 + read 10, (y + 1) % 10) ' days units
14060: ' static LEDs
    if (IO.eeread(16)) = 1 then r = 0 else r = 20  ' month position depending on format
    LED.iled(5, r + read 10, (x + 1) / 10) ' month 10s
    LED.iled(5, r + 10 + read 10, (x + 1) % 10) ' month units
    if (IO.eeread(16)) = 2 then r = 0 else r = 40 ' year position depending on format
    LED.iled(5, r + read 10, w / 10) ' year tens
    LED.iled(5, r + 10 + read 10, w % 10) ' years units
    LED.show()
    z = z + 1
    if z <= 500 goto 14010    ' time out
    goto 14320 ' exit
'................................................
14100: ' months
    gosub 9100        ' BEEP
    z = 0
    IO.setenc(x, 11, 0) ' 12 months
14110:
    t = IO.getenc()
    if t = x goto 14120
    x = t
    z = 0 ' reset timeout timer
14120:
    gosub 9000        ' GETKEY
    if k = 1 goto 14200 ' short press > years
    if k = 2 goto 14300
14150:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 14160
    if (IO.eeread(16)) = 1 then r = 0 else r = 20
    LED.iled(2, r + read 10, (x + 1) / 10) ' months 10s depending on date format
    LED.iled(2, r + 10 + read 10, (x + 1) % 10) ' months units  depending on date format
14160:
    r = (IO.eeread(16)) * 20' day position depending on date format
    LED.iled(5, r + read 10, (y + 1) / 10) ' day 10s
    LED.iled(5, r + 10 + read 10, (y + 1) % 10) ' day units
    if (IO.eeread(16)) = 2 then r = 0 else r = 40 ' year position depending on format
    LED.iled(5, r + read 10, w / 10)
    LED.iled(5, r + 10 + read 10, w % 10)
    LED.show()
    z = z + 1
    if z <= 500 goto 14110    ' time out check
    goto 14320 ' exit
'................................................
14200: ' years
    gosub 9100        ' BEEP
    z = 0
    IO.setenc(w, 99, 0) ' 2000 - 2099
14210:
    t = IO.getenc()
    if t = w goto 14220
    w = t
    z = 0 ' reset timeout counter
14220:
    gosub 9000        ' GETKEY
    if k = 1 goto 14005 ' short press = back to days
    if k = 2 goto 14300 ' long press = save and exit
14250:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 14260 ' display 10 cycles out of 15 (flash)
    if (IO.eeread(16)) = 2 then r = 0 else r = 40 ' year position depending on format
    LED.iled(2, r + read 10, w / 10)
    LED.iled(2, r + 10 + read 10, w % 10)
14260: ' display solid
    r = (IO.eeread(16)) * 20' day position depending on date format
    LED.iled(5, r + read 10, (y + 1) / 10)
    LED.iled(5, r + 10 + read 10, (y + 1) % 10)
    if (IO.eeread(16)) = 1 then r = 0 else r = 20 ' month position depending on date format
    LED.iled(5, r + read 10, (x + 1) / 10)
    LED.iled(5, r + 10 + read 10, (x + 1) % 10)
    LED.show()
    z = z + 1
    if z <= 500 goto 14210    ' time out check
    goto 14320 ' exit
'................................................
14300:
    gosub 9100        ' BEEP
    r = w + 2000 ' year in 4 digits
    if x = 1 and r % 4 = 0 and y > 28 goto 14330 ' 30/31 days in Feb in leap year. forget year 2000!
    if x = 1 and r % 4 <> 0 and y > 27 goto 14330 ' 29 / 30 / 31 days Feb non-leap year
14305: ' months with 30 days
    if x = 3 or x = 5 or x = 8 or x = 10 and y > 29 goto 14330 ' 31 days in months with 30 days
14310: ' set date
    IO.setrtc(5, w + 2000)     ' Write Year
    IO.setrtc(4, x + 1)        ' Write Month
    IO.setrtc(3, y + 1)        ' Write Day
14320: ' exit
    goto 10005
14330: ' non-sane date
    for r = 1 to 15 ' non-sane days in month beep 15 times
     gosub 9100
    next r
    goto 14005 ' return to day setting
'================================================
' F5: ALARM on / off
' VAR: y,t,z,k
15000:
    gosub 9100        ' BEEP
    y = IO.eeread(5)  ' Read alarm Value
15005:
    z = 0
    IO.setenc(y, 1, 0)
15010:
    t = IO.getenc()
    if t = y goto 15020
    y = t
    z = 0
15020:
    gosub 9000        ' GETKEY
    if k = 0 goto 15050
    gosub 9100        ' BEEP
    goto  15070
15050:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 15060
    LED.iled(2, 50 + read 10, y)
15060:
    LED.iled(3, read 10, 5)
    LED.show()
    z = z + 1
    if z <= 300 goto 15010
    goto 10005 ' return to system menu without save
15070:
    if y <> (IO.eeread(5)) then IO.eewrite(5, y) ' Read alarm Value
    goto 10005
'================================================
' S7: DIGIT FADE
' VAR: y,t,z,k
15100:
    gosub 9100          ' BEEP
    y = IO.eeread(17)   ' Read Digit fade Value from EEPROM
15105:
    z = 0               ' counter
    IO.setenc(y, 5, 0)  ' 5 fade values
15110:
    t = IO.getenc()
    if t = y goto 15120
    y = t
    z = 0                ' movement so reset counter
15120:
    gosub 9000        ' GETKEY
    if k = 0 goto 15150
    gosub 9100        ' BEEP
    goto  15170       ' short press
15150:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 15160 ' (flashing)
    LED.iled(2, 50 + read 10, y) ' fade units
15160:
    LED.iled(6, read 10, 7) ' show in System 7 i.e. fade
    LED.show()
    z = z + 1
    if z <= 300 goto 15110 ' timeout
    goto 10105 ' return to system menu without save
15170:
    if y <> (IO.eeread(17)) then IO.eewrite(17, y) ' Write fade Value
    goto 10105 ' return to system menu
'================================================
' F6: ALARM Time set
' VAR: w,x,y,t,z,k
16000:
    y = IO.eeread(6)  ' Read alarm Hour
    x = IO.eeread(7)  ' Read alarm Minute
    w = 0             ' Second = 0
16005:
    gosub 9100        ' BEEP
    z = 0
    IO.setenc(y, 23, 0)
16010:
    t = IO.getenc()
    if t = y goto 16020
    y = t
    z = 0
16020:
    gosub 9000        ' GETKEY
    if k = 1 goto 16100
    if k = 2 goto 16300
16050:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 16060
    LED.iled(2,      read 10, y / 10)
    LED.iled(2, 10 + read 10, y % 10)
16060:
    LED.iled(3, 20 + read 10, x / 10)
    LED.iled(3, 30 + read 10, x % 10)
    LED.iled(3, 40 + read 10, 0)
    LED.iled(3, 50 + read 10, 0)
    LED.show()
    z = z + 1
    if z <= 500 goto 16010    ' 20 Sek.
    goto 16320
'................................................
16100:
    gosub 9100        ' BEEP
    z = 0
    IO.setenc(x, 59, 0)
16110:
    t = IO.getenc()
    if t = x goto 16120
    x = t
    z = 0
16120:
    gosub 9000        ' GETKEY
    if k = 1 goto 16005
    if k = 2 goto 16300
16150:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 16160
    LED.iled(2, 20 + read 10, x / 10)
    LED.iled(2, 30 + read 10, x % 10)
16160:
    LED.iled(3,      read 10, y / 10)
    LED.iled(3, 10 + read 10, y % 10)
    LED.iled(3, 40 + read 10, 0)
    LED.iled(3, 50 + read 10, 0)
    LED.show()
    z = z + 1
    if z <= 500 goto 16110    ' 20 Sek.
    goto 16320
'................................................
16300:
    gosub 9100        ' BEEP
16310:
    if x <> (IO.eeread(7)) then IO.eewrite(7, x) ' Write alarm Minutes
    if y <> (IO.eeread(6)) then IO.eewrite(6, y) ' Write alarm Hours
16320:
    goto 10005
'================================================
' F7: Date AutoDisplay on / off
' VAR: y,t,z,k
17000:
    gosub 9100        ' BEEP
    y = IO.eeread(8)  ' Read auto Datum Value
17005:
    z = 0
    IO.setenc(y, 1, 0)
17010:
    t = IO.getenc()
    if t = y goto 17020
    y = t
    z = 0
17020:
    gosub 9000        ' GETKEY
    if k = 0 goto 17050
    gosub 9100        ' BEEP
    goto  17070
17050:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 17060
    LED.iled(2, 50 + read 10, y)
17060:
    LED.iled(3, read 10, 7)
    LED.show()
    z = z + 1
    if z <= 300 goto 17010
    goto 10005 ' return to system menu without save
17070:
    if y <> (IO.eeread(8)) then IO.eewrite(8, y) ' Read auto Datum Value
    goto 10005
'================================================
' F8: Timer set and start
' VAR: w,x,y,t,z,k,w,a
18000:
    y = 0  ' Timer Hour = 0
    x = 0  ' Timer Minute = 0
    w = 0  ' Timer Second = 0
18005:
    gosub 9100        ' BEEP
    z = 0
    IO.setenc(y, 23, 0)
18010:
    t = IO.getenc()
    if t = y goto 18020
    y = t
    z = 0
18020:
    gosub 9000        ' GETKEY
    if k = 1 goto 18100
    if k = 2 goto 18300
18050:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 18060
    LED.iled(2,      read 10, y / 10)
    LED.iled(2, 10 + read 10, y % 10)
18060:
    LED.iled(4, 20 + read 10, x / 10)
    LED.iled(4, 30 + read 10, x % 10)
    LED.iled(4, 40 + read 10, 0)
    LED.iled(4, 50 + read 10, 0)
    LED.show()
    z = z + 1
    if z <= 500 goto 18010    ' 20 Seconds.
    goto 18320
'................................................
18100:
    gosub 9100        ' BEEP
    z = 0
    IO.setenc(x, 59, 0)
18110:
    t = IO.getenc()
    if t = x goto 18120
    x = t
    z = 0
18120:
    gosub 9000        ' GETKEY
    if k = 1 goto 18005
    if k = 2 goto 18300
18150:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 18160
    LED.iled(2, 20 + read 10, x / 10)
    LED.iled(2, 30 + read 10, x % 10)
18160:
    LED.iled(4,      read 10, y / 10)
    LED.iled(4, 10 + read 10, y % 10)
    LED.iled(4, 40 + read 10, 0)
    LED.iled(4, 50 + read 10, 0)
    LED.show()
    z = z + 1
    if z <= 500 goto 18110    ' 20 Sek.
    goto 18320
'................................................
' Timer go
18200:
    gosub 9100        ' BEEP
18201:
    s = IO.getrtc(0)
    t = s
18205:
    gosub 9000        ' GETKEY
    if k = 1 gosub 9100 ' BEEP
    if k = 1 goto 18315 ' start /stop
    a = IO.eeread(5)
    if a = 1 gosub 18500
    if a = 2 goto 99     ' alarm prio
    s = IO.getrtc(0)
    if s = t goto 18205
    LED.iall(0) ' Clear display
    LED.iled(4,      read 10, y / 10)
    LED.iled(4, 10 + read 10, y % 10)
    LED.iled(4, 20 + read 10, x / 10)
    LED.iled(4, 30 + read 10, x % 10)
    LED.iled(4, 40 + read 10, w / 10)
    LED.iled(4, 50 + read 10, w % 10)
    LED.show()
    if w + x + y = 0 goto 18230 ' timer end music
    w = w - 1
    if w < 0 gosub 18210
    if x < 0 gosub 18220
    goto 18201
18210:
    w = 59
    x = x - 1
    return
18220:
    x = 59
    y = y - 1
    return
18230:
    n = 0
18240:
    LED.iall(0) ' Clear display
    LED.show()
18241:
    t = read 40, n
    d = read 40, n + 1
    n = n + 2
    if t = 0 goto 99 ' timer end
    LED.iled(4,      read 10, 0)
    LED.iled(4, 10 + read 10, 0)
    LED.iled(4, 20 + read 10, 0)
    LED.iled(4, 30 + read 10, 0)
    LED.iled(4, 40 + read 10, 0)
    LED.iled(4, 50 + read 10, 0)
    LED.show()
    IO.beep(t)
    delay d
    IO.beep(0)
    LED.iall(0) ' Clear display
    LED.show()
    delay 100
    goto 18241
'................................................
18300:
    gosub 9100        ' BEEP
18310:
    LED.irange(0, 0, 39)
    LED.iled(4,      read 10, y / 10)
    LED.iled(4, 10 + read 10, y % 10)
    LED.iled(4, 20 + read 10, x / 10)
    LED.iled(4, 30 + read 10, x % 10)
    LED.show()
18315:
    if x + y + w = 0 goto 10005 ' no timer
    a = IO.eeread(5)
    if a = 1 gosub 18500
    if a = 2 goto 99  ' alarm prio
    gosub 9000        ' GETKEY
    if k = 0 goto 18315
    if k = 1 goto 18200
    if k = 2 goto 18320
18320:
    gosub 9100        ' BEEP
    goto 10005
'================================================
' Alarm has priority over Timer / Stopwatch
18500:
    if (IO.eeread(6)) = (IO.getrtc(2)) and (IO.eeread(7)) = (IO.getrtc(1)) then a = 2
    return
'================================================
' F9: Stopwatch
' VAR: w,x,y,t,z,k,w,a
19000:
    y = 0  ' Stopwatch Hour = 0
    x = 0  ' Stopwatch Minute = 0
    w = 0  ' Stopwatch Second = 0
    LED.iall(0) ' Clear display
    LED.iled(4,      read 10, y / 10) ' hours 10s
    LED.iled(4, 10 + read 10, y % 10) ' hours 1s
    LED.iled(4, 20 + read 10, x / 10) ' minutes 10s
    LED.iled(4, 30 + read 10, x % 10) ' minutes 1s
    LED.iled(4, 40 + read 10, w / 10) ' seconds 10s
    LED.iled(4, 50 + read 10, w % 10) ' seconds 1s
    LED.show()
    w = w + 1
    goto 19300
'.......................................
' Start stopwatch
19195:
    gosub 9100        ' BEEP
19200:
    s = IO.getrtc(0)
    t = s
19205:
    gosub 9000        ' GETKEY
    if k = 1 goto 19300 ' start /stop
    a = IO.eeread(5)
    if a = 1 gosub 18500
    if a = 2 goto 99 ' alarm prio
    s = IO.getrtc(0)
    if s = t goto 19205
    LED.iall(0) ' Clear display
    LED.iled(4,      read 10, y / 10)
    LED.iled(4, 10 + read 10, y % 10)
    LED.iled(4, 20 + read 10, x / 10)
    LED.iled(4, 30 + read 10, x % 10)
    LED.iled(4, 40 + read 10, w / 10)
    LED.iled(4, 50 + read 10, w % 10)
    LED.show()
    w = w + 1
    if w > 59 gosub 19210
    if x > 59 gosub 19220
    if w + x + y = 141 goto 19230 ' Stopwatch exceeded max (23:59:59)
    goto 19200
19210:
    w = 0
    x = x + 1
    return
19220:
    x = 0
    y = y + 1
    return
19230:
    n = 0
19240:
    t = read 40, n
    d = read 40, n + 1
    n = n + 2
    if t = 0 goto 99 ' Stopwatch exceeded max so exit
    IO.beep(t)
    delay d
    IO.beep(0)
    delay 100
    goto 19240
'................................................
19300:
    gosub 9100        ' BEEP
19315:
    a = IO.eeread(5)
    if a = 1 gosub 18500
    if a = 2 goto 99  ' alarm prio
    gosub 9000        ' GETKEY
    if k = 0 goto 19315
    if k = 1 goto 19195
    if k = 2 goto 19320 ' long press
19320: ' long press
    gosub 9100        ' BEEP
    goto 10005
'================================================
' S4: party mode SETUP on / off
' VAR: y,t,z,k
20000:
    gosub 9100        ' BEEP
    y = IO.eeread(9)  ' Read Partymode Value
20005:
    z = 0
    IO.setenc(y, 1, 0)
20010:
    t = IO.getenc()
    if t = y goto 20020
    y = t
    z = 0
20020:
    gosub 9000        ' GETKEY
    if k = 0 goto 20050
    gosub 9100        ' BEEP
    goto  20070
20050:
    LED.iall(0) ' Clear display
    if z & 15 > 10 goto 20060
    LED.iled(2, 50 + read 10, y)
20060:
    LED.iled(6, read 10, 4)
    LED.show()
    z = z + 1
    if z <= 300 goto 20010
    goto 10105 ' return to system menu without save
20070:
    if y <> (IO.eeread(9)) then IO.eewrite(9, y) ' Read Partymode Value
    goto 10105
'================================================
' night mode duration set
' BEGIN
21000:
    y = IO.eeread(19)  ' Read Begin Nightmode Hour
    x = IO.eeread(20)  ' Read Begin Nightmode Minute
    w = 0              ' Second = 0
21005: ' hours
    gosub 9100        ' BEEP
    z = 0
    IO.setenc(y, 23, 0) ' 0-23 wraparound
21010:
    t = IO.getenc()
    if t = y goto 21020
    y = t
    z = 0 ' reset counter
21020:
    gosub 9000        ' GETKEY
    if k = 1 goto 21100 ' short press > minutes
    if k = 2 goto 21300 ' long press > save
21050: ' no key pressed
    LED.iall(0) ' blank out LEDs
    if z & 15 > 10 goto 21060 ' only light cycles
    LED.iled(2,      read 10, y / 10) ' hours 10s, white
    LED.iled(2, 10 + read 10, y % 10) ' hours units, white
21060:
    LED.iled(5, 20 + read 10, x / 10) ' minutes 10s, yellow
    LED.iled(5, 30 + read 10, x % 10) ' minutes units, yellow
    LED.iled(5, 40 + read 10, w / 10) ' seconds 10s, yellow
    LED.iled(5, 50 + read 10, w % 10) ' seconds units, yellow
    LED.show()
    z = z + 1
    if z <= 500 goto 21010    ' time out
    goto 10105 ' return to system menu
'................................................
21100: ' minutes
    gosub 9100        ' BEEP
    z = 0
    IO.setenc(x, 59, 0) ' 0 - 59 wraparound
21110:
    t = IO.getenc()
    if t = x goto 21120
    x = t
    z = 0 ' reset counter
21120:
    gosub 9000        ' GETKEY
    if k = 1 goto 21005 ' short click > hours
    if k = 2 goto 21300 ' long press > save
21150:
    LED.iall(0) ' blank out
    if z & 15 > 10 goto 21160 ' only show cycles
    LED.iled(2, 20 + read 10, x / 10) ' minutes, 10s, white
    LED.iled(2, 30 + read 10, x % 10) ' minutes, units, white
21160:
    LED.iled(5,      read 10, y / 10) ' hours, 10s, yellow, constant
    LED.iled(5, 10 + read 10, y % 10) ' hours, units, yellow, constant
    LED.iled(5, 40 + read 10, w / 10) ' seconds 10s, yellow
    LED.iled(5, 50 + read 10, w % 10) ' seconds units, yellow
    LED.show()
    z = z + 1
    if z <= 500 goto 21110    ' timeout
    goto 10105 ' return to system menu
'................................................
21300: ' save Begin Nightmode
    IO.eewrite(19, y) ' Begin Nightmode Hour
    IO.eewrite(20, x) ' Begin Nightmode Minute
'................................................
' night mode duration set
' END
22000:
    y = IO.eeread(21)  ' Read end Nightmode Hour
    x = IO.eeread(22)  ' Read end Nightmode Minute
22005: ' hours
    gosub 9100        ' BEEP
    z = 0
    IO.setenc(y, 23, 0) ' 0-23 wraparound
22010:
    t = IO.getenc()
    if t = y goto 22020
    y = t
    z = 0 ' reset counter
22020:
    gosub 9000        ' GETKEY
    if k = 1 goto 22100 ' short press > minutes
    if k = 2 goto 22300 ' long press > save
22050: ' no key pressed
    LED.iall(0) ' blank out LEDs
    if z & 15 > 10 goto 22060 ' only light cycles
    LED.iled(2,      read 10, y / 10) ' hours 10s, white
    LED.iled(2, 10 + read 10, y % 10) ' hours units, white
22060:
    LED.iled(4, 20 + read 10, x / 10) ' minutes 10s, green
    LED.iled(4, 30 + read 10, x % 10) ' minutes units, green
    LED.iled(4, 40 + read 10, w / 10) ' seconds 10s, green
    LED.iled(4, 50 + read 10, w % 10) ' seconds units, green
    LED.show()
    z = z + 1
    if z <= 500 goto 22010    ' time out
    goto 10105 ' return to system menu
'................................................
22100: ' minutes
    gosub 9100        ' BEEP
    z = 0
    IO.setenc(x, 59, 0) ' 0 - 59 wraparound
22110:
    t = IO.getenc()
    if t = x goto 22120
    x = t
    z = 0 ' reset counter
22120:
    gosub 9000        ' GETKEY
    if k = 1 goto 22005 ' short click > hours
    if k = 2 goto 22300 ' long press > save
22150:
    LED.iall(0) ' blank out
    if z & 15 > 10 goto 22160 ' only show cycles
    LED.iled(2, 20 + read 10, x / 10) ' minutes, 10s, white
    LED.iled(2, 30 + read 10, x % 10) ' minutes, units, white
22160:
    LED.iled(4,      read 10, y / 10) ' hours, 10s, green, constant
    LED.iled(4, 10 + read 10, y % 10) ' hours, units, green, constant
    LED.iled(4, 40 + read 10, w / 10) ' seconds 10s, green
    LED.iled(4, 50 + read 10, w % 10) ' seconds units, green
    LED.show()
    z = z + 1
    if z <= 500 goto 22110    ' timeout
    goto 10105 ' return to system menu
'................................................
22300: ' save Begin Nightmode
    gosub 9100        ' BEEP
    IO.eewrite(21, y) ' end Nightmode Hour
    IO.eewrite(22, x) ' end Nightmode Minute
    goto 10105 ' return to system menu
'================================================
' S9: Hide seconds display shifted / on / off
' VAR: y,t,z,k
24000:
    gosub 9100        ' BEEP
    y = IO.eeread(23) ' Read Second Display Value
24005:
    z = 0
    IO.setenc(y, 2, 0) ' three options
24010:
    t = IO.getenc()
    if t = y then goto 24020
    y = t
    z = 0 ' reset counter
24020:
    gosub 9000        ' GETKEY
    if k = 0 then goto 24050 ' no key
    gosub 9100        ' BEEP, key
    goto  24070
24050:
    LED.irange(0, 0, 59) ' blank LEDs
    if z & 15 > 10 then goto 24060 ' light pixel 10 out of 15 cycles
    LED.iled(2, 50 + read 10, y)
24060:
    LED.iled(6, read 10, 9) ' 9th option in blue System menu
    LED.show()
    z = z + 1
    if z <= 300 then goto 24010
    goto 10105 ' return to system menu without save
24070:
    if y <> (IO.eeread(23)) then IO.eewrite(23, y) ' Write Seconds Hide Value
    goto 10105
'================================================
end

