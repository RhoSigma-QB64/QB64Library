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
'| === memory.bi ===                                                 |
'|                                                                   |
'| == Definitions required for the routines provided in memory.bm.   |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

'====================
'=== Dependencies ===
'====================
'=== If you wanna use this library in your project, then you must also
'=== include the following other libaries into your project:
'===    - RS-Includes\types (.bi/.bm)
'=====================================================================

'--- The general purpose memory region,
'--- never access this array directly, use the provided PokeXX and PeekXX
'--- SUBs and FUNCTIONs instead !!
'-----
COMMON SHARED gpMemory&&()

'--- Some flags used with the various memory functions,
'--- which flags may be used with which functions and what effect they will
'--- have to them is described in the function reference. In general it
'--- won't hurt to pass unsupported flags to any function, those flags will
'--- be simply ignored.
'-----
CONST gpmF_MarkFree& = 1
CONST gpmF_NoFreeList& = 2
CONST gpmF_NoAdd& = 4
CONST gpmF_Largest& = 8
CONST gpmF_Total& = 16
CONST gpmF_Clear& = 32
CONST gpmF_Unsigned& = 64

'--- AlignGPMSize& constants,
'--- this function is used to align given sizes to a multiple of the mimimum
'--- supported memory block size, if required.
'-----
CONST gpm_BlockSize& = 8
CONST gpm_BlockPad& = 7
CONST gpm_BlockMask& = -8

'--- Some private structures,
'--- these are intentionally not commented, don't mess with it !!
'-----
COMMON SHARED MemHeader&, MemHeader_SizeOf&
COMMON SHARED mh_First&, mh_Free&, mh_AddSize&, mh_MaxSize&, mh_Lower&, mh_Upper&
'-----
DefSTRUCTURE MemHeader&, 0&
DefGPMPTR mh_First&
DefULONG mh_Free&
DefULONG mh_AddSize&
DefULONG mh_MaxSize&
DefGPMPTR mh_Lower&
DefGPMPTR mh_Upper&
DefLABEL MemHeader_SizeOf&
'-----
COMMON SHARED MemChunk&, MemChunk_SizeOf&
COMMON SHARED mc_Next&, mc_Free&
'-----
DefSTRUCTURE MemChunk&, 0&
DefGPMPTR mc_Next&
DefULONG mc_Free&
DefLABEL MemChunk_SizeOf&
'-----
COMMON SHARED MemVector&, MemVector_SizeOf&
COMMON SHARED mv_MemSize&, mv_MatchTag&
'-----
DefSTRUCTURE MemVector&, 0&
DefULONG mv_MemSize&
DefGPMPTR mv_MatchTag&
DefLABEL MemVector_SizeOf&

