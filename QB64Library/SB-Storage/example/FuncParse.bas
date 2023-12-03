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
'| === FuncParse.bas ===                                             |
'|                                                                   |
'| == This example illustrates the use of various buffer functions   |
'| == by parsing the simplebuffer.bm file into its single SUB/FUNCs. |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

_TITLE "Simplebuffers usage example"

'--- Make the required .bi includes,
'--- always specify paths in the $INCLUDE statement assuming the
'--- main QB64 installation folder as root.
'-----
'$INCLUDE: 'QB64Library\SB-Storage\simplebuffer.bi'

'--- Find the root of the library's source folder.
'-----
IF _FILEEXISTS("qb64.exe") OR _FILEEXISTS("qb64pe.exe") THEN
    root$ = "QB64Library\SB-Storage\" 'compiled to qb64 folder
ELSE
    root$ = "..\" 'compiled to source folder
END IF

'--- load the file into a buffer
'-----
fileBuf% = FileToBuf%(root$ + "simplebuffer.bm")
ConvBufToNativeEol fileBuf%

'--- init search parameters
'-----
'--- SUB/FUNC name delimiters
findDelim% = SetBufFind%(fileBuf%, " ~`%&!#$(" + BufEolSeq$(fileBuf%))

'--- first look for functions
'-----
findStart% = SetBufFind%(fileBuf%, "FUNCTION ")
findEnd% = SetBufFind%(fileBuf%, "END FUNCTION")
prefix$ = root$ + "Func_" 'save file path/prefix
GOSUB doParse
result% = RemoveBufFind%(fileBuf%, findEnd%)
result% = RemoveBufFind%(fileBuf%, findStart%)

'--- rewind to buffer start position
'-----
result& = SeekBuf&(fileBuf%, 0, SBM_BufStart)

'--- now look for subroutines
'-----
findStart% = SetBufFind%(fileBuf%, "SUB ")
findEnd% = SetBufFind%(fileBuf%, "END SUB")
prefix$ = root$ + "Sub_" 'save file path/prefix
GOSUB doParse
result% = RemoveBufFind%(fileBuf%, findEnd%)
result% = RemoveBufFind%(fileBuf%, findStart%)

'--- that's all folks
'-----
PRINT: PRINT "You may safely delete the Sub_/Func_ files in the SB-Storage folder..."
PRINT "done..."

'--- cleanup & exit
'-----
result% = RemoveBufFind%(fileBuf%, findDelim%)
DisposeBuf fileBuf%
END

'--- this routine will parse the loaded buffer contents to find the
'--- individual SUBs and FUNCTIONs, note this is not a bulletproof
'--- routine, it just checks if a found SUB/FUNC keyword is at start
'--- of line (ie. not after a REM or inside of a DECLARE LIBRARY block)
'-----
doParse:
DO
    'find next SUB/FUNCTION keyword & check validity
    subfuncStart& = FindBufFwd&(fileBuf%, findStart%, SBF_FullData, SBF_IgnoreCase)
    result& = SeekBuf&(fileBuf%, 0, SBM_LineStart)
    IF subfuncStart& > 0 AND GetBufPos&(fileBuf%) <> subfuncStart& THEN
        'invalid, keyword not at start of line (maybe commented
        'or part of a DECLARE LIBRARY block)
        result& = SeekBuf&(fileBuf%, subfuncStart&, SBM_PosRestore)
        subfuncStart& = -1 'skip this
    END IF
    IF subfuncStart& > 0 THEN
        'if found, then find & extract the SUB/FUNC name
        nameStart& = FindBufFwd&(fileBuf%, findDelim%, SBF_Delimiter, SBF_AsWritten)
        nameEnd& = FindBufFwd&(fileBuf%, findDelim%, SBF_Delimiter, SBF_AsWritten)
        result& = SeekBuf&(fileBuf%, nameStart&, SBM_PosRestore)
        subfuncName$ = LTRIM$(RTRIM$(ReadBufRawData$(fileBuf%, nameEnd& - nameStart&)))
        'look if there are descriptions before SUB/FUNCTION
        DO
            result& = SeekBuf&(fileBuf%, -LEN(BufEolSeq$(fileBuf%)), SBM_LineStart)
            result& = SeekBuf&(fileBuf%, 0, SBM_LineStart)
            temp$ = ReadBufRawData$(fileBuf%, 3)
            result& = SeekBuf&(fileBuf%, -3, SBM_BufCurrent)
        LOOP WHILE UCASE$(temp$) = "REM" OR LEFT$(temp$, 1) = "'"
        result& = SeekBuf&(fileBuf%, LEN(BufEolSeq$(fileBuf%)), SBM_LineEnd)
        subfuncStart& = GetBufPos&(fileBuf%)
        'now find END SUB/END FUNCTION keyword
        subfuncEnd& = FindBufFwd&(fileBuf%, findEnd%, SBF_FullData, SBF_IgnoreCase)
        IF subfuncEnd& > 0 THEN
            'if found, then seek to next line or buffer end (whichever
            'is first), so we catch the entire SUB/FUNCTION to copy
            result& = SeekBuf&(fileBuf%, LEN(BufEolSeq$(fileBuf%)), SBM_LineEnd)
            IF result& < 0 THEN result& = SeekBuf&(fileBuf%, 0, SBM_BufEnd)
            result% = CopyBufBlock%(fileBuf%, subfuncStart&)
            'the folowing delay is just to avoid a clipboard race
            'condition, as the copy & paste calls are very close to
            'each other (time wise) in this example, if you comment
            'this out, then you'll probably find some of the created
            'files being empty or have wrong contents
            _DELAY 0.05
            'init a new buffer and paste the copied SUB/FUNCTION into it
            subfuncBuf% = CreateBuf%
            result% = PasteBufBlock%(subfuncBuf%, 0)
            'then save the new buffer and destroy the buffer after saving
            BufToFile subfuncBuf%, prefix$ + subfuncName$ + ".bm"
            DisposeBuf subfuncBuf%
            PRINT "wrote "; prefix$; subfuncName$; ".bm"
        END IF
    END IF
LOOP UNTIL subfuncStart& = 0
RETURN

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionFuncParse$
VersionFuncParse$ = MID$("$VER: FuncParse 1.0 (18-Oct-2022) by RhoSigma :END$", 7, 39)
END FUNCTION

'--- Make the required .bm includes,
'--- always specify paths in the $INCLUDE statement assuming the
'--- main QB64 installation folder as root.
'-----
'$INCLUDE: 'QB64Library\SB-Storage\simplebuffer.bm'

