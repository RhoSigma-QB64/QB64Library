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
'| === RotatePolygon.bas ===                                         |
'|                                                                   |
'| == A short example to show the usage of some "converthelper.bm"   |
'| == functions. It does also utilize "polygons.bm" functions from   |
'| == the DRF-Polygons library.                                      |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

'--- Make a graphics screen.
'-----
SCREEN _NEWIMAGE(640, 480, 256)
_DELAY 0.2
_TITLE "Rotating polygon"

'--- Set some variables.
'-----
REDIM px%(9), py%(9) 'polygon corners
rcx% = 320: rcy% = 240 'initial rotation center
ra% = 0 'initial rotation angle

'--- Main loop.
'-----
DO
    _LIMIT 50
    ra% = ra% + 2 'increment rotation angle
    IF ra% = 360 THEN ra% = 0

    SELECT CASE _KEYHIT
        CASE 18432: rcy% = rcy% - 5 'CsrUp
        CASE 20480: rcy% = rcy% + 5 'CsrDn
        CASE 19200: rcx% = rcx% - 5 'CsrLft
        CASE 19712: rcx% = rcx% + 5 'CsrRgt
    END SELECT
    CLS
    PRINT "Use arrow keys to move the rotation center, close window to quit:"
    PRINT "rcx% ="; rcx%; "  rcy% ="; rcy%

    RESTORE PolyStar
    FOR i% = 0 TO 9
        READ tmpX%, tmpY%
        'rotate nominal coords by current angle and around current center
        px%(i%) = RotPointX%(tmpX%, tmpY%, ra%, rcx%, rcy%)
        py%(i%) = RotPointY%(tmpX%, tmpY%, ra%, rcx%, rcy%)
    NEXT i%
    FillPolygon px%(), py%(), 9, 15
    CIRCLE (rcx%, rcy%), 2, 10
    CIRCLE (rcx%, rcy%), 4, 10

    _DISPLAY
LOOP UNTIL _EXIT
SYSTEM

'--- Nominal poly coords (0 deg.)
'-----
PolyStar:
DATA 240,310
DATA 300,310
DATA 320,240
DATA 340,310
DATA 400,310
DATA 350,340
DATA 370,400
DATA 320,360
DATA 270,400
DATA 290,340

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionRotatePolygon$
VersionRotatePolygon$ = MID$("$VER: RotatePolygon 1.0 (29-Jul-2016) by RhoSigma :END$", 7, 43)
END FUNCTION

'--- Make the required .bm includes,
'--- always specify paths in the $INCLUDE statement assuming the
'--- main QB64 installation folder as root.
'-----
'$INCLUDE: 'QB64Library\IMG-Support\converthelper.bm'
'$INCLUDE: 'QB64Library\DRF-Polygons\polygons.bm'

