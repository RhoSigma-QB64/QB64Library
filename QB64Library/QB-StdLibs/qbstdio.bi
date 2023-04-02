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
'| === qbstdio.bi ===                                                |
'|                                                                   |
'| == Definitions required for the routines provided in qbstdio.bm.  |
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
'=====================================================================

'--- Helper functions defined in qbstdio.h, which should reside (along with
'--- the respective .bi/.bm files) in the main QB64 installation folder.
'-----
'--- If you rather place your library files in a sub-directory (as I do),
'--- then you must specify the path within the DECLARE LIBRARY statement
'--- assuming the main QB64 installation folder as root.
'-----
DECLARE LIBRARY "QB64Library\QB-StdLibs\qbstdio" 'Do not add .h here !!
    FUNCTION FormatToBuffer%& ALIAS "rsqbstdio::FormatToBuffer" (BYVAL cFmtStr%&, qbArgStr$)
    'The low level wrapper to "vsprintf()", you should not use this directly,
    'rather use the QB64 SUBs/FUNCTIONs provided in the qbstdio.bm include.
END DECLARE

