'+---------------+---------------------------------------------------+
'| ###### ###### |     .--. .         .-.                            |
'| ##  ## ##   # |     |   )|        (   ) o                         |
'| ##  ##  ##    |     |--' |--. .-.  `-.  .  .-...--.--. .-.        |
'| ######   ##   |     |  \ |  |(   )(   ) | (   ||  |  |(   )       |
'| ##      ##    |     '   `'  `-`-'  `-'-' `-`-`|'  '  `-`-'`-      |
'| ##     ##   # |       Sources & Documents  ._.'  placed           |
'| ##     ###### | under terms of the RSA Data Security, Inc. License|
'+---------------+---------------------------------------------------+
'|                                                                   |
'| === md5.bi ===                                                    |
'|                                                                   |
'| == Definitions required for the routines provided in md5.bm.      |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

' License to copy and use this software is granted provided that it
' is identified as the "RSA Data Security, Inc. MD5 Message-Digest
' Algorithm" in all material mentioning or referencing this software
' or this function.
'
' License is also granted to make and use derivative works provided
' that such works are identified as "derived from the RSA Data
' Security, Inc. MD5 Message-Digest Algorithm" in all material
' mentioning or referencing the derived work.
'
' RSA Data Security, Inc. makes no representations concerning either
' the merchantability of this software or the suitability of this
' software for any particular purpose. It is provided "as is"
' without express or implied warranty of any kind.
'
' These notices must be retained in any copies of any part of this
' documentation and/or software.

'--- Helper functions defined in md5.h, which should reside (along with
'--- the respective .bi/.bm files) in the main QB64 installation folder.
'-----
'--- If you rather place your library files in a sub-directory (as I do),
'--- then you must specify the path within the DECLARE LIBRARY statement
'--- assuming the main QB64 installation folder as root.
'-----
DECLARE LIBRARY "QB64Library\MD5-Hash\md5" 'Do not add .h here !!
    FUNCTION FileMD5$ ALIAS "rsqbmd5::md5_file" (qbFile$) 'add CHR$(0) to File$
    FUNCTION StringMD5$ ALIAS "rsqbmd5::md5_string" (qbStr$, BYVAL qbStrLen&) 'add CHR$(0) to Str$, but pass Len& without
    'The low level wrappers to MD5, you should not use this directly,
    'rather use the QB64 FUNCTIONs provided in the md5.bm include.
END DECLARE

