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
'| === StdLibs-Test.bas ===                                          |
'|                                                                   |
'| == This short test program serves to make sure, that everything   |
'| == is working on your system as intended, as pointer sizes and    |
'| == padding sizes do vary between QB64 x32 and x64 and maybe even  |
'| == between Windows, Linux and MacOS. If everything is good, then  |
'| == the output should match the StdLibs-Test.png screenshot.       |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

'--- Make the required .bi includes,
'--- always specify paths in the $INCLUDE statement assuming the
'--- main QB64 installation folder as root.
'-----
'$INCLUDE: 'QB64Library\QB-StdLibs\qbstdarg.bi'
'$INCLUDE: 'QB64Library\QB-StdLibs\qbstdio.bi'
'$INCLUDE: 'QB64Library\QB-StdLibs\qbtime.bi'

'--- Make a couple argument tests.
'-----
InitArgs a$
StrArg a$, "Hello World !!"
IntArg a$, &H7FFF
LongArg a$, &H7FFFFFFF
Int64Arg a$, &H7FFFFFFFFFFFFFFF
DoubleArg a$, 123.456789
VPrintF "   String: %s\n" +_
        "  Integer: %hd\n" +_
        "     Long: %ld\n" +_
        "Integer64: %lld\n" +_
        "   Double: %5.3f\n", a$
FreeArgs a$

'--- And here a time test.
'-----
PRINT StrFGivenTime$("This test was written at %X on %A %B %d %Y.\n", 2018, 8, 19, 18, 32, 8)

'--- Make your best guess what happens here.
'-----
PRINT "done..."
END

'--- Make the required .bm includes,
'--- always specify paths in the $INCLUDE statement assuming the
'--- main QB64 installation folder as root.
'-----
'$INCLUDE: 'QB64Library\QB-StdLibs\qbstdarg.bm'
'$INCLUDE: 'QB64Library\QB-StdLibs\qbstdio.bm'
'$INCLUDE: 'QB64Library\QB-StdLibs\qbtime.bm'

