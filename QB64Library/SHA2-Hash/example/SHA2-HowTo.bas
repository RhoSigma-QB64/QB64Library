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
'| === SHA2-HowTo.bas ===                                            |
'|                                                                   |
'| == This example is to show the usage of the sha2.bi/.bm functions |
'| == for the Secure Hash Algorithm (SHA2) Message-Digest.           |
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
'$INCLUDE: 'QB64Library\SHA2-Hash\sha2.bi'

'--- Find the root of the library's source folder.
'-----
IF _FILEEXISTS("qb64.exe") OR _FILEEXISTS("qb64pe.exe") THEN
    root$ = "QB64Library\SHA2-Hash\" 'compiled to qb64 folder
ELSE
    root$ = "..\" 'compiled to source folder
END IF

'--- Read the file PD-Unlicense.txt from the SHA2-Hash\license folder into
'--- a string and then pass it to the FUNCTION GetStringSHA2$().
'-----
file$ = "license\PD-Unlicense.txt"
OPEN root$ + file$ FOR BINARY AS #1
a$ = SPACE$(LOF(1))
GET #1, , a$
CLOSE #1
PRINT
PRINT "loading a whole file into a string and compute SHA2 ..."
PRINT "SHA2 Digest of file "; CHR$(34); file$; CHR$(34)
PRINT ":  "; GetStringSHA2$(a$)
'-----
'--- Or directly call the FUNCTION GetFileSHA2$() for this kind of usage.
'-----
PRINT
PRINT "and now the same file, but using the file digest function directly ..."
PRINT "SHA2 Digest of file "; CHR$(34); file$; CHR$(34)
PRINT ":  "; GetFileSHA2$(root$ + file$)

'--- Here's a quick try with a simple predefined literal string.
'-----
a$ = "qb64phoenix.com"
PRINT
PRINT "SHA2 Digest of string "; CHR$(34); a$; CHR$(34)
PRINT ":  "; GetStringSHA2$(a$)

'--- Yet another try in a loop.
'-----
PRINT
PRINT "continuously changing, press any key to stop..."
WHILE INKEY$ = ""
    _LIMIT 5
    a$ = DATE$ + " " + TIME$
    LOCATE 14, 1
    PRINT "SHA2 Digest date/time "; CHR$(34); a$; CHR$(34)
    PRINT ":  "; GetStringSHA2$(a$)
WEND
PRINT
PRINT "imagine this method used with counting hours and/or minutes only"
PRINT "to create a timed code lock like on a bank tresor :)"

'--- Make your best guess what happens here.
'-----
END

'--- Make the required .bm includes,
'--- always specify paths in the $INCLUDE statement assuming the
'--- main QB64 installation folder as root.
'-----
'$INCLUDE: 'QB64Library\SHA2-Hash\sha2.bm'

