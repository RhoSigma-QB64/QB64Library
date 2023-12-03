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
'| === AsciiArtDemo.bas ===                                          |
'|                                                                   |
'| == A short example to show the usage of the FUNC MakeAsciiArt$(). |
'| == This function is a prototype and can be certainly improved in  |
'| == various aspects. Note this function is not part of the image   |
'| == processing library, but made for a forum-request by bplus.     |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

_TITLE "Ascii Art Demo"

'--- Set the program's work directory.
'-----
IF _FILEEXISTS("qb64.exe") OR _FILEEXISTS("qb64pe.exe") THEN
    CHDIR "QB64Library\IMG-Support\example"
END IF

'--- Load the test (original) image.
'-----
oImg& = _LOADIMAGE("BeachGirl.jpg", 32)
IF oImg& >= -1 THEN
    PRINT "ERROR: Can't load the test Image, make sure it's in the same"
    PRINT "       directory as this demo program's EXE file !!"
    END
END IF

'--- Make the ASCII art string.
'-----
art$ = MakeAsciiArt$(oImg&, 140, 8, "")

'--- Adjust screen size and font an print the ASCII art.
'-----
WIDTH 141, 106
_FONT 8
PRINT art$;

'--- Make your best guess what happens here.
'-----
SLEEP
SYSTEM

'--------------------
'--- MakeAsciiArt ---
'--------------------
' Take the source image and convert it into a B&W ASCII Art picture.
'----------
' SYNTAX:
'   text$ = MakeAsciiArt$ (shan&, widt%, fhei%, gray$)
'----------
' INPUTS:
'   --- shan& ---
'    The handle of the source image to convert.
'   --- widt% ---
'    The desired width of the ASCII Art in chars, the height will be
'    calculated automatically according to the source image height and
'    the given font height (fhei%) to keep the original aspect ratio.
'   --- fhei% ---
'    The font height should be 8, 14 or 16 according to the QB64 build-in
'    fonts. In most cases it looks best with 8, as these are square chars.
'   --- gray$ ---
'    This is a string of 2-16 chars representing the desired graylevels
'    ascending from black to white. If this is empty or less than two
'    chars, then it defaults to " .:-=+oO80@#".
'----------
' RESULT:
'   --- text$ ---
'    The string containing the created ASCII art. The string contains
'    a newline code after every widt% chars.
'---------------------------------------------------------------------
FUNCTION MakeAsciiArt$ (shan&, widt%, fhei%, gray$)
'--- option _explicit requirements ---
DIM artStr$, v#, i%, swid%, shei%, bsx#, heig%
DIM bsy#, y#, x#, bsum&, by%, soff%&, bx%, orgb~&
'--- now enter the function ---
artStr$ = ""
IF shan& < -1 THEN
    IF _PIXELSIZE(shan&) = 4 THEN
        '--- build histogram transformation table ---
        IF LEN(gray$) < 2 THEN gray$ = " .:-=+oO80@#"
        IF LEN(gray$) > 16 THEN gray$ = LEFT$(gray$, 16)
        REDIM hist%(0 TO 255): v# = LEN(gray$) / 256
        FOR i% = 0 TO 255
            hist%(i%) = FIX((i% * v#) + 1.0#)
        NEXT i%
        '--- calc block size ---
        swid% = _WIDTH(shan&): shei% = _HEIGHT(shan&)
        bsx# = swid% / widt%: heig% = FIX(widt% / swid% * shei%)
        v# = fhei% / 8: heig% = FIX(heig% / v#): bsy# = shei% / heig%
        '--- for speed we do direct memory access ---
        DIM sbuf AS _MEM: sbuf = _MEMIMAGE(shan&)
        '--- iterate through image blocks ---
        FOR y# = 0 TO shei% - 1 STEP bsy#
            FOR x# = 0 TO swid% - 1 STEP bsx#
                '--- iterate through block pixels ---
                bsum& = 0
                FOR by% = 0 TO FIX(bsy#) - 1
                    soff%& = sbuf.OFFSET + ((CINT(y#) + by%) * swid% * 4) + (CINT(x#) * 4)
                    FOR bx% = 0 TO FIX(bsx#) - 1
                        '--- get pixel ARGB value from source ---
                        _MEMGET sbuf, soff%&, orgb~&
                        '--- sum up block pixel gray values ---
                        bsum& = bsum& + CINT((_RED32(orgb~&) * 0.299#) + (_GREEN32(orgb~&) * 0.587#) + (_BLUE32(orgb~&) * 0.114#))
                        '--- set next pixel offset ---
                        soff%& = soff%& + 4
                    NEXT bx%
                NEXT by%
                '--- calc gray average & choose char ---
                artStr$ = artStr$ + MID$(gray$, hist%(CINT(bsum& / (FIX(bsx#) * FIX(bsy#)))), 1)
            NEXT x#
            artStr$ = artStr$ + CHR$(10)
        NEXT y#
        '--- cleanup ---
        _MEMFREE sbuf
        ERASE hist%
    END IF
END IF
MakeAsciiArt$ = artStr$
END FUNCTION

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionAsciiArtDemo$
VersionAsciiArtDemo$ = MID$("$VER: AsciiArtDemo 1.0 (29-Jul-2016) by RhoSigma :END$", 7, 42)
END FUNCTION

