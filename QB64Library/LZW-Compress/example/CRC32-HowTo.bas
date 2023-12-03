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
'| === CRC32-HowTo.bas ===                                           |
'|                                                                   |
'| == This example is to show the usage of the lzwpacker.bm function |
'| == GetCRC32&() to compute the Cyclic Redundant Checksum.          |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

'--- Find the root of the library's source folder.
'-----
IF _FILEEXISTS("qb64.exe") OR _FILEEXISTS("qb64pe.exe") THEN
    root$ = "QB64Library\LZW-Compress\" 'compiled to qb64 folder
ELSE
    root$ = "..\" 'compiled to source folder
END IF

'--- Set title and print the program's version string.
'-----
_TITLE "CRC32-HowTo Output"
COLOR 9: PRINT VersionCrc32HowTo$: COLOR 7

'--- Read the file PD-Unlicense.txt from the LZW-Compress\license folder
'--- into a string and then pass it to the FUNCTION GetCRC32&().
'-----
file$ = "license\PD-Unlicense.txt"
OPEN root$ + file$ FOR BINARY AS #1
a$ = SPACE$(LOF(1))
GET #1, , a$
CLOSE #1
PRINT
PRINT "loading a whole file into a string and compute CRC32 ..."
PRINT "CRC32 checksum of file "; CHR$(34); file$; CHR$(34)
PRINT ":  "; HEX$(GetCRC32&(a$))

'--- Here's a quick try with a simple predefined literal string.
'-----
a$ = "qb64phoenix.com"
PRINT
PRINT "CRC32 checksum of string "; CHR$(34); a$; CHR$(34)
PRINT ":  "; HEX$(GetCRC32&(a$))

'--- Yet another try in a loop.
'-----
PRINT
PRINT "continuously changing, press any key to stop ..."
WHILE INKEY$ = ""
    _LIMIT 5
    a$ = DATE$ + " " + TIME$
    LOCATE 11, 1
    PRINT "CRC32 checksum date/time "; CHR$(34); a$; CHR$(34)
    PRINT ":  "; HEX$(GetCRC32&(a$))
WEND

'--- Make your best guess what happens here.
'-----
END

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionCrc32HowTo$
VersionCrc32HowTo$ = MID$("$VER: CRC32-HowTo 1.0 (01-Mar-2019) by RhoSigma :END$", 7, 41)
END FUNCTION

'--- Make the required .bm includes,
'--- always specify paths in the $INCLUDE statement assuming the
'--- main QB64 installation folder as root.
'-----
'$INCLUDE: 'QB64Library\LZW-Compress\lzwpacker.bm'

