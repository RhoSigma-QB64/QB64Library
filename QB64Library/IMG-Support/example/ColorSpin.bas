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
'| === ColorSpin.bas ===                                             |
'|                                                                   |
'| == A short example to show the usage of some "converthelper.bm"   |
'| == functions. This were the first conceptional steps to build a   |
'| == HSB colorpicker, where the Hue (color) is selected by rotating |
'| == the main corner of the triangle around the colorwheel and then |
'| == picking the desired Saturation and Brightness values clicking  |
'| == in the gradient triangle.                                      |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

'--- Set the colorwheel's radius in pixels.
'-----
radi! = 200

'--- Now compute all positions and sizes.
'-----
widt% = (radi! * 2) + 10: heig% = widt%
cenx% = INT(widt% / 2): ceny% = cenx%
ring! = (radi! * 0.1)
marg! = (radi! * 0.015)
trwi% = ((radi! - marg! - ring! - marg! - 5) * 2) + 2: trhe% = trwi%
trcx% = CINT(trwi% / 2): trcy% = trcx%

'--- Make a graphics screen.
'-----
scre& = _NEWIMAGE(widt%, heig%, 32)
SCREEN scre&
_DELAY 0.2
_TITLE "Color Spin"

'--- Make the colorwheel image.
'-----
rimg& = _NEWIMAGE(widt%, heig%, 32)
_DEST rimg&
FOR huee! = 0 TO 360 STEP 0.125
    FOR satu! = radi! TO radi! - marg! - ring! - marg! STEP -0.125
        poix% = CINT(satu! * COS(huee! * 0.017453))
        poiy% = CINT(satu! * SIN(huee! * 0.017453))
        IF satu! > radi! - marg! OR satu! < radi! - marg! - ring! THEN
            PSET (poix% + cenx%, ceny% - poiy%), HSB32~&(0, 0, 100)
        ELSE
            PSET (poix% + cenx%, ceny% - poiy%), HSB32~&(huee!, 100, 100)
        END IF
    NEXT satu!
NEXT huee!

'--- Compute triangle corners.
'-----
satu! = (satu! - 5) 'use some offset to the wheel
REDIM arrx%(2), arry%(2)
arrx%(0) = PolToCartX%(90, satu!) + trcx%
arry%(0) = trcy% - PolToCartY%(90, satu!)
arrx%(1) = PolToCartX%(210, satu!) + trcx%
arry%(1) = trcy% - PolToCartY%(210, satu!)
arrx%(2) = PolToCartX%(330, satu!) + trcx%
arry%(2) = trcy% - PolToCartY%(330, satu!)

'--- Gradient fill the triangle and rotate.
'-----
timg& = _NEWIMAGE(trwi%, trhe%, 32)
rtim& = _NEWIMAGE(trwi%, trhe%, 32)
WHILE INKEY$ = ""
    FOR huee! = 0 TO 359
        _LIMIT 60
        _DISPLAY
        _DEST timg&: CLS , _RGBA32(0, 0, 0, 0)
        FillPolygon arrx%(), arry%(), huee!
        _DEST rtim&: CLS , _RGBA32(0, 0, 0, 0)
        RotoZoom trcx%, trcy%, timg&, 1.0, huee! - 90

        _DEST 0: CLS
        _PUTIMAGE , rimg&
        _PUTIMAGE (cenx% - trcx%, ceny% - trcy%), rtim&
    NEXT huee!
WEND

'--- Make your best guess what happens here.
'-----
SYSTEM

'=====================================================================
'SUB RotoZoom is taken from Example 1 of the _MAPTRIANGLE wiki page.
'=====================================================================
SUB RotoZoom (X AS LONG, Y AS LONG, Image AS LONG, Scale AS SINGLE, Rotation AS SINGLE)
DIM px(3) AS SINGLE: DIM py(3) AS SINGLE
W& = _WIDTH(Image&): H& = _HEIGHT(Image&)
px(0) = -W& / 2: py(0) = -H& / 2: px(1) = -W& / 2: py(1) = H& / 2
px(2) = W& / 2: py(2) = H& / 2: px(3) = W& / 2: py(3) = -H& / 2
sinr! = SIN(Rotation / 57.2957795131): cosr! = COS(Rotation / 57.2957795131)
FOR i& = 0 TO 3
    x2& = (px(i&) * cosr! + sinr! * py(i&)) * Scale + X: y2& = (py(i&) * cosr! - px(i&) * sinr!) * Scale + Y
    px(i&) = x2&: py(i&) = y2&
NEXT
_MAPTRIANGLE (0, 0)-(0, H& - 1)-(W& - 1, H& - 1), Image& TO(px(0), py(0))-(px(1), py(1))-(px(2), py(2))
_MAPTRIANGLE (0, 0)-(W& - 1, 0)-(W& - 1, H& - 1), Image& TO(px(0), py(0))-(px(3), py(3))-(px(2), py(2))
END SUB

'=== RS:COPYFROM:polygons.bm/FillPolygon (++RS:CHG) ==================
SUB FillPolygon (srcPolyX%(), srcPolyY%(), hu!) 'RS:CHG hu!
'--- check arrays ---
sLow% = LBOUND(srcPolyX%): sUpp% = UBOUND(srcPolyX%)
IF LBOUND(srcPolyY%) <> sLow% OR UBOUND(srcPolyY%) <> sUpp% THEN ERROR 97 'mismatch of X and Y array (source polygon)
'--- find bounding box of entire polygon ---
minX% = 32767: maxX% = 0: minY% = 32767: maxY% = 0
FOR cur% = sLow% TO sUpp%
    IF srcPolyX%(cur%) < minX% THEN minX% = srcPolyX%(cur%)
    IF srcPolyX%(cur%) > maxX% THEN maxX% = srcPolyX%(cur%)
    IF srcPolyY%(cur%) < minY% THEN minY% = srcPolyY%(cur%)
    IF srcPolyY%(cur%) > maxY% THEN maxY% = srcPolyY%(cur%)
NEXT cur%
'--- build a list of nodes ---
FOR pixY% = minY% TO maxY%
    REDIM nodeX%(0 TO sUpp% + 2)
    nCnt% = 0: pre% = sUpp%
    FOR cur% = sLow% TO sUpp%
        IF (srcPolyY%(cur%) < pixY% AND srcPolyY%(pre%) >= pixY%) OR (srcPolyY%(pre%) < pixY% AND srcPolyY%(cur%) >= pixY%) THEN
            nodeX%(nCnt%) = srcPolyX%(cur%) + ((pixY% - srcPolyY%(cur%)) / (srcPolyY%(pre%) - srcPolyY%(cur%)) * (srcPolyX%(pre%) - srcPolyX%(cur%)))
            nCnt% = nCnt% + 1
        END IF
        pre% = cur%
    NEXT cur%
    '--- sort the nodes via a simple Bubble sort ---
    cur% = 0
    WHILE cur% < (nCnt% - 1)
        IF nodeX%(cur%) > nodeX%(cur% + 1) THEN
            SWAP nodeX%(cur%), nodeX%(cur% + 1)
            IF cur% THEN cur% = cur% - 1
        ELSE
            cur% = cur% + 1
        END IF
    WEND
    '--- fill the pixels between node pairs ---
    sa& = 65535 - CLNG((pixY% - minY%) * (65535 / (maxY% - minY%)))
    FOR cur% = 0 TO nCnt% STEP 2
        IF nodeX%(cur%) >= maxX% THEN EXIT FOR
        IF nodeX%(cur% + 1) > minX% THEN
            IF nodeX%(cur%) < minX% THEN nodeX%(cur%) = minX%
            IF nodeX%(cur% + 1) > maxX% THEN nodeX%(cur% + 1) = maxX%
            'RS:CHG gradient HSB model
            HSBtoRGB CLNG(hu! * 182.041666#), sa&, 32768&, re&, gr&, bl&
            IF nodeX%(cur%) = nodeX%(cur% + 1) THEN
                PSET (nodeX%(cur%), pixY%), _RGB32(255, 255, 255)
            ELSE
                FOR pixX% = nodeX%(cur%) + 1 TO nodeX%(cur% + 1)
                    br& = CLNG((pixX% - (nodeX%(cur%) + 1)) * (65535 / (nodeX%(cur% + 1) - (nodeX%(cur%) + 1))))
                    HSBtoRGB (hu! * 182.041666#), sa&, br&, re&, gr&, bl&
                    PSET (pixX%, pixY%), _RGB32(re& \ 256, gr& \ 256, bl& \ 255)
                NEXT pixX%
            END IF
            'RS:END gradient HSB model
        END IF
    NEXT cur%
NEXT pixY%
'--- draw surrounding border ---
pre% = sUpp%
FOR cur% = sLow% TO sUpp%
    LINE (srcPolyX%(pre%), srcPolyY%(pre%))-(srcPolyX%(cur%), srcPolyY%(cur%)), _RGB32(255, 255, 255)
    pre% = cur%
NEXT cur%
END SUB

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionColorSpin$
VersionColorSpin$ = MID$("$VER: ColorSpin 1.0 (29-Jul-2016) by RhoSigma :END$", 7, 39)
END FUNCTION

'--- Make the required .bm includes,
'--- always specify paths in the $INCLUDE statement assuming the
'--- main QB64 installation folder as root.
'-----
'$INCLUDE: 'QB64Library\IMG-Support\converthelper.bm'

