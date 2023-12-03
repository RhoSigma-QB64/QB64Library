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
'| === LZW-HowTo.bas ===                                             |
'|                                                                   |
'| == A short example to show the usage of the "lzwpacker.bm" func-  |
'| == tions. It takes the QB64 executable and pack / unpack it.      |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

'--- Find the QB64 home folder and EXE name.
'-----
IF _FILEEXISTS("qb64.exe") THEN
    root$ = "" 'compiled to qb64 folder
    qb64$ = "qb64.exe" 'normal version
ELSEIF _FILEEXISTS("qb64pe.exe") THEN
    root$ = "" 'compiled to qb64pe folder
    qb64$ = "qb64pe.exe" 'Phoenix Edition
ELSE
    root$ = "..\..\..\" 'compiled to source folder
    IF _FILEEXISTS(root$ + "qb64.exe") THEN
        qb64$ = "qb64.exe" 'normal version
    ELSE
        qb64$ = "qb64pe.exe" 'Phoenix Edition
    END IF
END IF

'--- Set title and print the program's version string.
'-----
_TITLE "LZW-HowTo Output"
COLOR 9: PRINT VersionLzwHowTo$: COLOR 7

'--- Get QB64 executable into a string.
'-----
PRINT: COLOR 10
PRINT "loading file "; qb64$; " ..."
OPEN "B", #1, root$ + qb64$
file$ = SPACE$(LOF(1))
GET #1, , file$
CLOSE #1

'--- Pack it and print some statistics.
'-----
PRINT: COLOR 12
PRINT "packing ..."
COLOR 15
PRINT " InSize:"; USING " ######.## KiB"; LEN(file$) / 1024
st# = TIMER(0.001)
pack$ = LzwPack$(file$, 0)
en# = TIMER(0.001)
IF en# - st# = 0 THEN en# = en# + 0.001 'avoid division by zero error
PRINT "OutSize:"; USING " ######.## KiB"; LEN(pack$) / 1024
PRINT "   Time:"; USING "    ###.## seconds"; en# - st#
PRINT "  Ratio:"; USING "     ##.## percent"; 100 - (100 / LEN(file$) * LEN(pack$))
PRINT "  Speed:"; USING "  #####.## KiB/sec (of InSize)"; (LEN(file$) / 1024) / (en# - st#)
file$ = "" 'no longer needed, so save the memory

'--- Save the packed data, so you can have a look on it.
'-----
PRINT: COLOR 10
PRINT "saving file as "; qb64$; "_Packed.bin ..."
IF _FILEEXISTS(root$ + qb64$ + "_Packed.bin") THEN KILL root$ + qb64$ + "_Packed.bin"
OPEN "B", #1, root$ + qb64$ + "_Packed.bin"
PUT #1, , pack$
CLOSE #1

'--- Now unpack again and print statistics.
'-----
PRINT: COLOR 12
PRINT "unpacking ..."
COLOR 15
PRINT " InSize:"; USING " ######.## KiB"; LEN(pack$) / 1024
st# = TIMER(0.001)
orig$ = LzwUnpack$(pack$)
en# = TIMER(0.001)
IF en# - st# = 0 THEN en# = en# + 0.001 'avoid division by zero error
PRINT "OutSize:"; USING " ######.## KiB"; LEN(orig$) / 1024
PRINT "   Time:"; USING "    ###.## seconds"; en# - st#
PRINT "  Speed:"; USING "  #####.## KiB/sec (of OutSize)"; (LEN(orig$) / 1024) / (en# - st#)

'--- Save the unpacked data, so you can compare it with the original.
'-----
PRINT: COLOR 10
PRINT "saving file as "; qb64$; "_Unpacked.exe ..."
PRINT: COLOR 7
PRINT "If you wish, run it or use a Diff tool to compare it with "; qb64$
PRINT "to prove its correctly unpacked again."
IF _FILEEXISTS(root$ + qb64$ + "_Unpacked.exe") THEN KILL root$ + qb64$ + "_Unpacked.exe"
OPEN "B", #1, root$ + qb64$ + "_Unpacked.exe"
PUT #1, , orig$
CLOSE #1

'--- Make your best guess what happens here.
'-----
END

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionLzwHowTo$
VersionLzwHowTo$ = MID$("$VER: LZW-HowTo 1.0 (01-Mar-2019) by RhoSigma :END$", 7, 39)
END FUNCTION

'--- Make the required .bm includes,
'--- always specify paths in the $INCLUDE statement assuming the
'--- main QB64 installation folder as root.
'-----
'$INCLUDE: 'QB64Library\LZW-Compress\lzwpacker.bm'

