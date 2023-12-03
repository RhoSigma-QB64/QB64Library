'+---------------+---------------------------------------------------+
'| ###### ###### |     .--. .         .-.                            |
'| ##  ## ##   # |     |   )|        (   ) o                         |
'| ##  ##  ##    |     |--' |--. .-.  `-.  .  .-...--.--. .-.        |
'| ######   ##   |     |  \ |  |(   )(   ) | (   ||  |  |(   )       |
'| ##      ##    |     '   `'  `-`-'  `-'-' `-`-`|'  '  `-`-'`-      |
'| ##     ##   # |                            ._.'                   |
'| ##     ###### |  Sources & Documents placed in the Public Domain. |
'+---------------+---------------------------------------------------+
'|                                                                   |
'| === Debug-HowTo.bas ===                                           |
'|                                                                   |
'| == A short example to show the usage of qbdebug.bi/.bm logging    |
'| == functions on QB64 level.                                       |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

'====================
'=== Instructions ===
'====================
'=== 1. Compile & Run this program as it is right now. As the LogInit call
'===    below (line 62) is commented out, no debug logfile is written.
'=== 2. Now uncomment the LogInit call below and Compile & Run again, this
'===    should write the named logfile to this program's "example" directory.
'=====
'=== As you can see, the debug logging system can be switched on/off simply
'=== by using or omitting the LogInit call. There is no need to remove or
'=== comment all debug output instructions in your program just to switch
'=== the logging system off. However, you may want to avoid time wasting
'=== for any prepare/cleanup steps needed for debug output (eg. creating
'=== variable args for formatted output), if the logging system is inactive.
'=== Simply use the helper function DebugIsActive%() for an IF..THEN block
'=== to scope out those operations as shown in FUNCTION Permut&(n%) below,
'=== but NEVER lock out LogOpen and/or LogClose calls using this method.
'=====================================================================

'--- Make the required .bi includes,
'--- always specify paths in the $INCLUDE statement assuming the
'--- main QB64 installation folder as root.
'-----
'$INCLUDE: 'QB64Library\QB-Debug\qbdebug.bi'
'$INCLUDE: 'QB64Library\QB-StdLibs\qbstdarg.bi'
'$INCLUDE: 'QB64Library\QB-StdLibs\qbstdio.bi'

'--- Find the root of the library's source folder.
'-----
IF _FILEEXISTS("qb64.exe") OR _FILEEXISTS("qb64pe.exe") THEN
    root$ = "QB64Library\QB-Debug\" 'compiled to qb64 folder
ELSE
    root$ = "..\" 'compiled to source folder
END IF

'--- Set title and print the program's version string.
'-----
_TITLE "Debug-HowTo Output"
COLOR 9: PRINT VersionDebugHowTo$: PRINT: COLOR 7

'LogInit root$ + "example\Debug-HowTo.txt", QBDEBUG_FilterSimple

'--- This is the 1st test section, showing how the debug output functions
'--- hierarchically follow up the nesting of function calls.
'-----
lo% = LogOpen%("1. Test Section", "Main")
LogStr "calculating permutation of 6..."
r& = Permut&(6)
PRINT "6! ="; r&
InitArgs a$ 'make vargs for use in LogFmt
IntArg a$, 6
LongArg a$, r&
LogFmt "permutation of %hd = %ld", a$
FreeArgs a$ 'destroy vargs
LogClose lo%

'--- The 2nd test section, showing a even deeper nesting.
'-----
lo% = LogOpen%("2. Test Section", "Main")
LogStr "calculating permutation of 9..."
r& = Permut&(9)
PRINT "9! ="; r&
InitArgs a$ 'make vargs for use in LogFmt
IntArg a$, 9
LongArg a$, r&
LogFmt "permutation of %hd = %ld", a$
FreeArgs a$ 'destroy vargs
LogClose lo%

'--- You may also manually nest debug output sections, just make sure to
'--- carfully store the state values returned by FUNCTION LogOpen%() and
'--- pass each of it back to its matching respective SUB LogClose() call,
'--- ie. in reverse order.
'-----
lo1% = LogOpen%("1. Nest", "Main")
'--- do something here ---
lo2% = LogOpen%("2. Nest", "Main")
'--- do some more here ---
lo3% = LogOpen%("3. Nest", "Main")
'--- and even more here ---
LogClose lo3%
'--- you could also do something here ---
LogClose lo2%
'--- and here too ---
LogClose lo1%

'--- Make your best guess what happens here.
'-----
END

'--- Always a nice example for nesting, calculate the permutations of
'--- a number using a recursive (self calling) function.
'-----
FUNCTION Permut& (n%)
lo% = LogOpen%("Permut&(n%)", "")
IF DebugIsActive% THEN 'avoid time wasting, if logging is off
    LogStr "given input..."
    InitArgs a$ 'make vargs for use in LogFmt
    IntArg a$, n%
    LogFmt "n%% = %hd", a$
    LogArgs a$
    FreeArgs a$ 'destroy vargs
END IF
IF n% > 0 THEN
    prod& = n% * Permut&(n% - 1)
ELSE
    prod& = 1
END IF
IF DebugIsActive% THEN 'avoid time wasting, if logging is off
    LogStr "function result..."
    InitArgs a$ 'make vargs for use in LogFmt
    LongArg a$, prod&
    LogFmt "Permut& = %ld", a$
    FreeArgs a$ 'destroy vargs
END IF
LogClose lo%
Permut& = prod&
END FUNCTION

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionDebugHowTo$
VersionDebugHowTo$ = MID$("$VER: Debug-HowTo 1.0 (14-Mar-2013) by RhoSigma :END$", 7, 41)
END FUNCTION

'--- Make the required .bm includes,
'--- always specify paths in the $INCLUDE statement assuming the
'--- main QB64 installation folder as root.
'-----
'$INCLUDE: 'QB64Library\QB-Debug\qbdebug.bm'
'$INCLUDE: 'QB64Library\QB-StdLibs\qbstdarg.bm'
'$INCLUDE: 'QB64Library\QB-StdLibs\qbstdio.bm'

