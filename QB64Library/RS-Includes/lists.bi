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
'| === lists.bi ===                                                  |
'|                                                                   |
'| == Definitions required for the routines provided in lists.bm.    |
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
'===    - RS-Includes\types  (.bi/.bm)
'===    - RS-Includes\memory (.bi/.bm)
'=====================================================================

'--- Some flags used with the FUNCTION FindName&,
'--- all flags and its effects are described in the function reference.
'-----
CONST lstF_TextArg& = 1
CONST lstF_NoCase& = 2
CONST lstF_Left& = 4
CONST lstF_Mid& = 8
CONST lstF_Right& = 16

'--- Node Types for lh_Type& and ln_Type&,
'--- the types defined so far have more or less just a general meaning,
'--- every type has a range given for nine (9) subtypes, but it's not yet
'--- clear if and how they will be used. Suggestions? -- Every specific
'--- type should represent a specific data type structure.
'-----
CONST NT_UNKNOWN& = 0 'undefined type
CONST NT_MEMORY& = 10 'collection of allocated memory blocks?
CONST NT_MESSAGE& = 20 'message queues (something like GUI events?)
CONST NT_FONT& = 30 'general font related data
CONST NT_IMAGE& = 40 'general image related data
CONST NT_SOUND& = 50 'general sound related data

CONST NT_MORE& = 60 'next general type

CONST NT_USER& = 254 'User node types work down from here
CONST NT_EXTENDED& = 255 'reserved

'--- Minimal List Header,
'--- no type checking possible (best for most applications).
'-----
COMMON SHARED MinListHeader&, MinListHeader_SizeOf&
COMMON SHARED mlh_Head&, mlh_Tail&, mlh_TailPred&
'-----
DefSTRUCTURE MinListHeader&, 0&
DefGPMPTR mlh_Head&
DefGPMPTR mlh_Tail&
DefGPMPTR mlh_TailPred&
DefLABEL MinListHeader_SizeOf&

'--- Full featured List Header
'-----
COMMON SHARED ListHeader&, ListHeader_SizeOf&
COMMON SHARED lh_Head&, lh_Tail&, lh_TailPred&, lh_Type&, lh_Pad&
'-----
DefSTRUCTURE ListHeader&, 0&
DefGPMPTR lh_Head&
DefGPMPTR lh_Tail&
DefGPMPTR lh_TailPred&
DefUBYTE lh_Type&
DefUBYTE lh_Pad&
DefLABEL ListHeader_SizeOf&

'--- Minimal List Node,
'--- no type checking possible.
'-----
COMMON SHARED MinListNode&, MinListNode_SizeOf&
COMMON SHARED mln_Succ&, mln_Pred&
'-----
DefSTRUCTURE MinListNode&, 0&
DefGPMPTR mln_Succ&
DefGPMPTR mln_Pred&
DefLABEL MinListNode_SizeOf&

'--- Full featured List Node
'-----
COMMON SHARED ListNode&, ListNode_SizeOf&
COMMON SHARED ln_Succ&, ln_Pred&, ln_Type&, ln_Pri&, ln_Name&
'-----
DefSTRUCTURE ListNode&, 0&
DefGPMPTR ln_Succ&
DefGPMPTR ln_Pred&
DefUBYTE ln_Type&
DefBYTE ln_Pri&
DefGPMSTR ln_Name&
DefLABEL ListNode_SizeOf&

