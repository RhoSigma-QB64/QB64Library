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
'| === qbdebug.bi ===                                                |
'|                                                                   |
'| == Definitions required for the routines provided in qbdebug.bm.  |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

'====================
'=== Dependencies ===
'====================
'=== If you wanna use this library in your project, then you must also
'=== include the following other libaries into your project:
'===    - QB-StdLibs\qbstdarg (.bi/.bm)
'===    - QB-StdLibs\qbstdio  (.bi/.bm)
'=====================================================================

'--- Helper functions defined in qbdebug.h, which should reside (along with
'--- the respective .bi/.bm files) in the main QB64 installation folder.
'-----
'--- If you rather place your library files in a sub-directory (as I do),
'--- then you must specify the path within the DECLARE LIBRARY statement
'--- assuming the main QB64 installation folder as root.
'-----
DECLARE LIBRARY "QB64Library\QB-Debug\qbdebug" 'Do not add .h here !!
    SUB DebugInit ALIAS "rsqbdebug::DebugInit" (logName$, BYVAL filterMode%) 'add CHR$(0) to name
    FUNCTION DebugOpen% ALIAS "rsqbdebug::DebugOpen" (funcName$) 'add CHR$(0) to name
    SUB DebugClose ALIAS "rsqbdebug::DebugClose" (BYVAL locOpen%)
    SUB DebugPuts ALIAS "rsqbdebug::DebugPuts" (dbgStr$) 'add CHR$(0) to string
    'Some low level support functions, you should not use these directly,
    'rather use the QB64 SUBs/FUNCTIONs provided in the qbdebug.bm include.
    FUNCTION DebugIsActive% ALIAS "rsqbdebug::DebugIsActive" ()
    'Use this function to create IF..THEN blocks which scope out any
    'prepare/cleanup steps to avoid time wasting, if logging is off.
    'NOTE: Never lock out LogOpen/LogClose calls using this method !!
END DECLARE

'--- Filter modes used for SUB LogInit()
'-----
CONST QBDEBUG_FilterNone = 0
CONST QBDEBUG_FilterSimple = 1
CONST QBDEBUG_FilterFull = 2

