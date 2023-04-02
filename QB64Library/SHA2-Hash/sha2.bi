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
'| === sha2.bi ===                                                   |
'|                                                                   |
'| == Definitions required for the routines provided in sha2.bm.     |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

'--- Helper functions defined in sha2.h, which should reside (along with
'--- the respective .bi/.bm files) in the main QB64 installation folder.
'-----
'--- If you rather place your library files in a sub-directory (as I do),
'--- then you must specify the path within the DECLARE LIBRARY statement
'--- assuming the main QB64 installation folder as root.
'-----
DECLARE LIBRARY "QB64Library\SHA2-Hash\sha2" 'Do not add .h here !!
    FUNCTION FileSHA2$ ALIAS "rsqbsha2::sha2_file" (qbFile$) 'add CHR$(0) to File$
    FUNCTION StringSHA2$ ALIAS "rsqbsha2::sha2_string" (qbStr$, BYVAL qbStrLen&) 'add CHR$(0) to Str$, but pass Len& without
    'The low level wrappers to SHA2, you should not use this directly,
    'rather use the QB64 FUNCTIONs provided in the sha2.bm include.
END DECLARE

