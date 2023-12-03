'+---------------+---------------------------------------------------+
'| ###### ###### |     .--. .         .-.                            |
'| ##  ## ##   # |     |   )|        (   ) o                         |
'| ##  ##  ##    |     |--' |--. .-.  `-.  .  .-...--.--. .-.        |
'| ######   ##   |     |  \ |  |(   )(   ) | (   ||  |  |(   )       |
'| ##      ##    |     '   `'  `-`-'  `-'-' `-`-`|'  '  `-`-'`-      |
'| ##     ##   # |                            ._.'                   |
'| ##     ###### |   Sources & Documents placed under GNU GPL v2.0   |
'+---------------+---------------------------------------------------+
'|                                                                   |
'| === DES56-HowTo.bas ===                                           |
'|                                                                   |
'| == This is an example to show the usage of the des56.bi/.bm       |
'| == functions for en-/decryption using the DES-56 algorithm.       |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

' This program is free software; you can redistribute it and/or modify
' it under the terms of the GNU General Public License as published by
' the Free Software Foundation; either version 2, or (at your option)
' any later version.
'
' This program is distributed in the hope that it will be useful,
' but WITHOUT ANY WARRANTY; without even the implied warranty of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
' GNU General Public License for more details.
'
' You should have received a copy of the GNU General Public License
' along with this program; if not, write to the Free Software
' Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

'--- Make the required .bi includes,
'--- always specify paths in the $INCLUDE statement assuming the
'--- main QB64 installation folder as root.
'-----
'$INCLUDE: 'QB64Library\DES56-Crypt\des56.bi'

'--- Find the root of the library's source folder.
'-----
IF _FILEEXISTS("qb64.exe") OR _FILEEXISTS("qb64pe.exe") THEN
    root$ = "QB64Library\DES56-Crypt\" 'compiled to qb64 folder
ELSE
    root$ = "..\" 'compiled to source folder
END IF

'--- Set title and print the program's version string.
'-----
_TITLE "DES56-HowTo Output"
COLOR 9: PRINT VersionDes56HowTo$: PRINT: COLOR 7

'--- Encrypt a password for use in .htaccess files.
'-----
PRINT "Encrypt the QB64 version string as password for a .htaccess protected"
PRINT "Web-Site, consult the HTACCESS docs in the internet on how to use the"
PRINT "encrypted password string."
PRINT
PRINT "Original password: QB64 v0.954 / Encrypted: "; EncryptPassword$("QB64 v0.954", "i3")
PRINT

'--- Encrypt the file GPL-2.0.txt in the DES56-Crypt\license folder.
'-----
file$ = root$ + "license\GPL-2.0.txt" 'wanna try another file?, change it here
'-----
PRINT "Encrypt the file GPL-2.0.txt in the QB64Library\DES56-Crypt\license folder."
PRINT "After that use another FUNCTION to prove the file is encrypted."
PRINT
LINE INPUT "Enter password for encryption: "; pw$
IF EncryptFile%(file$, pw$) THEN
    PRINT "FUNCTION EncryptFile% did return an error!"
ELSE
    PRINT "FUNCTION EncryptFile% was successful!"
    IF IsCryptedFile%(file$) THEN
        PRINT "FUNCTION IsCryptedFile% confirms the file is encrypted now, you may try to"
        PRINT "open and read the file before it will be decrypted again."
    ELSE
        PRINT "Oops, but FUNCTION IsCryptedFile% cannot confirm the file is encrypted now."
        PRINT "Please let me know, if you see this message."
    END IF
END IF
PRINT

'--- Now decrypt the file GPL-2.0.txt again.
'-----
IF IsCryptedFile%(file$) THEN 'print only if encrypted
    PRINT "Now it's time to decrypt the file GPL-2.0.txt again. Feel free to try"
    PRINT "a wrong password first."
END IF
WHILE IsCryptedFile%(file$) 'run loop until decrypted
    PRINT
    LINE INPUT "Enter password for decryption: "; pw$
    res% = DecryptFile%(file$, pw$)
    IF res% = DES56_ERROR_WRONGCRC THEN
        PRINT "Oops, seems this was the wrong password, try again!"
    ELSEIF res% <> DES56_ERROR_NONE THEN
        PRINT "FUNCTION DecryptFile% did return an error!"
        EXIT WHILE
    ELSE
        PRINT "FUNCTION DecryptFile% was successful!"
    END IF
WEND

'--- Make your best guess what happens here.
'-----
END

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionDes56HowTo$
VersionDes56HowTo$ = MID$("$VER: DES56-HowTo 1.0 (12-May-2015) by RhoSigma :END$", 7, 41)
END FUNCTION

'--- Make the required .bm includes,
'--- always specify paths in the $INCLUDE statement assuming the
'--- main QB64 installation folder as root.
'-----
'$INCLUDE: 'QB64Library\DES56-Crypt\des56.bm'

