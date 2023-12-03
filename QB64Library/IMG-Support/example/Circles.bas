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
'| === Circles.bas ===                                               |
'|                                                                   |
'| == A short example to show the usage of some "converthelper.bm"   |
'| == functions.                                                     |
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
_TITLE "Circles"
COLOR 9: PRINT VersionCircles$: COLOR 7

'--- Set some variables.
'-----
mx% = 200: my% = 200 'initial rotation center
px% = 370: py% = 240 'given point

'--- Show the given point and wait 2 seconds.
'-----
CIRCLE (px%, py%), 2, 15
PSET (px%, py%), 12
mpx% = MovePointX%(px%, py%, -20, 70)
mpy% = MovePointY%(px%, py%, -20, 70)
LINE -(mpx%, mpy%), 12
COLOR 12
_PRINTSTRING (mpx% + 6, mpy% - 8), "given point"
COLOR 7
_DELAY 2

'--- Draw a circle by rotating the given point around
'--- the actual center point.
'-----
CIRCLE (mx%, my%), 2, 15
FOR a% = 0 TO 359
    nx% = RotPointX%(px%, py%, a%, mx%, my%)
    ny% = RotPointY%(px%, py%, a%, mx%, my%)
    CIRCLE (nx%, ny%), 2, 15
    _DELAY 0.01
NEXT a%
PSET (mx%, my%), 12 'pin current center

'--- Move the center and repeat the rotation circle.
'-----
mx% = MovePointX%(mx%, my%, 50, 50)
my% = MovePointY%(mx%, my%, 50, 50)
LINE -(mx%, my%), 12
CIRCLE (mx%, my%), 2, 10
FOR a% = 0 TO 359
    nx% = RotPointX%(px%, py%, a%, mx%, my%)
    ny% = RotPointY%(px%, py%, a%, mx%, my%)
    CIRCLE (nx%, ny%), 2, 10
    _DELAY 0.01
NEXT a%
PSET (mx%, my%), 12 'pin current center

'--- Move the center and repeat the rotation circle.
'-----
mx% = MovePointX%(mx%, my%, -10, 100)
my% = MovePointY%(mx%, my%, -10, 100)
LINE -(mx%, my%), 12
CIRCLE (mx%, my%), 2, 14
FOR a% = 0 TO 359
    nx% = RotPointX%(px%, py%, a%, mx%, my%)
    ny% = RotPointY%(px%, py%, a%, mx%, my%)
    CIRCLE (nx%, ny%), 2, 14
    _DELAY 0.01
NEXT a%
PSET (mx%, my%), 12 'pin current center

'--- Move the center and repeat the rotation circle.
'-----
mx% = MovePointX%(mx%, my%, 90, 80)
my% = MovePointY%(mx%, my%, 90, 80)
LINE -(mx%, my%), 12
CIRCLE (mx%, my%), 2, 9
FOR a% = 0 TO 359
    nx% = RotPointX%(px%, py%, a%, mx%, my%)
    ny% = RotPointY%(px%, py%, a%, mx%, my%)
    CIRCLE (nx%, ny%), 2, 9
    _DELAY 0.01
NEXT a%

'--- Make your best guess what happens here.
'-----
END

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionCircles$
VersionCircles$ = MID$("$VER: Circles 1.0 (29-Jul-2016) by RhoSigma :END$", 7, 37)
END FUNCTION

'--- Make the required .bm includes,
'--- always specify paths in the $INCLUDE statement assuming the
'--- main QB64 installation folder as root.
'-----
'$INCLUDE: 'QB64Library\IMG-Support\converthelper.bm'

