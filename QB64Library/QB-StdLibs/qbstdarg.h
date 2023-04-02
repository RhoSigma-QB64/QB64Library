// +---------------+---------------------------------------------------+
// | ###### ###### |     .--. .         .-.                            |
// | ##  ## ##   # |     |   )|        (   ) o                         |
// | ##  ##  ##    |     |--' |--. .-.  `-.  .  .-...--.--. .-.        |
// | ######   ##   |     |  \ |  |(   )(   ) | (   ||  |  |(   )       |
// | ##      ##    |     '   `'  `-`-'  `-'-' `-`-`|'  '  `-`-'`-      |
// | ##     ##   # |                            ._.'                   |
// | ##     ###### |  Sources & Documents placed in the Public Domain. |
// +---------------+---------------------------------------------------+
// |                                                                   |
// | === qbstdarg.h ===                                                |
// |                                                                   |
// | == Some low level support functions for routines in qbstdarg.bm.  |
// |                                                                   |
// +-------------------------------------------------------------------+
// | Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
// | Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
// | any questions or suggestions. Thanx for your interest in my work. |
// +-------------------------------------------------------------------+

#ifndef RSQB_STDARG_H // include only once
#define RSQB_STDARG_H

//#define RSQBSTDARG_DEBUG // debug output flag

#ifdef RSQBSTDARG_DEBUG
#include "..\QB-Debug\qbdebug.h"
using rsqbdebug::DebugOpen;
using rsqbdebug::DebugClose;
using rsqbdebug::DebugPuts;
using rsqbdebug::DebugPrintf;
#endif

namespace rsqbstdarg {

int16_t  fcdFlag = 0;   // first call done flag
ptrszint cMemBrain = 0; // CString memory brain (list anchor)

void FreeCString(ptrszint cStr); // fwd ref

// --- Internal function never called from QB64 level, it's linked into the
// --- program's exit procedure to automatically free all remaining CStrings
// --- right before the program is finally terminated.
// ---------------------------------------------------------------------
void ExitCStringCleanup (void)
{
    #ifdef RSQBSTDARG_DEBUG
    int16_t locOpen = DebugOpen("ExitCStringCleanup (qbstdarg.h)");
    if (cMemBrain) {
    #endif
        while (cMemBrain) {
            #ifdef RSQBSTDARG_DEBUG
            DebugPuts("remaining item found, freeing...");
            #endif
            FreeCString(cMemBrain + ptrsz); // memptr + linkptr = strptr
        }
    #ifdef RSQBSTDARG_DEBUG
    }
    else {DebugPuts("no remaining items found, done...");}
    DebugClose(locOpen);
    #endif
}

// --- Create a independent copy of the given QB64 string, also evaluate
// --- the usual C/C++ escape sequences and octal or hex escaped characters.
// ---------------------------------------------------------------------
ptrszint MakeCString(char *qbStr, int32_t qbStrLen) {
    if (!fcdFlag) {
        atexit(ExitCStringCleanup); // init auto-cleanup on 1st call
        fcdFlag = -1;
    }
    ptrszint *cMemPtr = (ptrszint*) malloc(qbStrLen + ptrsz + 1); // + linkptrsz & zero termination
    *cMemPtr = cMemBrain; cMemBrain = (ptrszint) cMemPtr++; // memptr + linkptrsz = strptr (cMemPtr++)
    char *cStr = (char*) cMemPtr;
    #ifdef RSQBSTDARG_DEBUG
    ptrszint qbStrOri = (ptrszint) qbStr; // remember for position calculation
    int16_t locOpen = DebugOpen("MakeCString (qbstdarg.h)");
    DebugPuts("given input...");
    DebugPrintf("pointer (qbStr)    = 0x%016X", qbStr);
    if (qbStr != 0) DebugPrintf("content (*qbStr)   = %s", qbStr);
    DebugPrintf("length  (qbStrLen) = %ld", qbStrLen);
    DebugPuts("runtime variables...");
    DebugPrintf("pointer (cMemPtr)  = 0x%016X (allocated)", &cMemPtr[-1]);
    DebugPrintf("content (*cMemPtr) = 0x%016X (link to previous CString in brain)", cMemPtr[-1]);
    DebugPrintf("pointer (cMemPtr)  = 0x%016X (adjusted (++ from allocated))", cMemPtr);
    DebugPrintf("pointer (cStr)     = 0x%016X (cast from adjusted)", cStr);
    if (qbStr != 0) DebugPuts("## begin string processing ##");
    #endif
    if (qbStr != 0) {
        char *seq; int32_t len; // sequence temporaries
        for (int16_t esc = 0; qbStrLen; qbStrLen--) {
            unsigned char chr = *qbStr++;
            if (chr == '\\' && !esc) {esc = -1;}
            else if (esc) {
                esc = 0; len = 0;
                switch (chr) {
                    case 'a': {*cStr++ = '\a'; seq = "\\a"; break;}
                    case 'b': {*cStr++ = '\b'; seq = "\\b"; break;}
                    case 't': {*cStr++ = '\t'; seq = "\\t"; break;}
                    case 'n': {*cStr++ = '\n'; seq = "\\n"; break;}
                    case 'v': {*cStr++ = '\v'; seq = "\\v"; break;}
                    case 'f': {*cStr++ = '\f'; seq = "\\f"; break;}
                    case 'r': {*cStr++ = '\r'; seq = "\\r"; break;}
                    case 'e': {*cStr++ = '\e'; seq = "\\e"; break;}
                    case '\"': {*cStr++ = '\"'; seq = "\\\x22"; break;}
                    case '\'': {*cStr++ = '\''; seq = "\\'"; break;}
                    case '?': {*cStr++ = '\?'; seq = "\\?"; break;}
                    case '\\': {*cStr++ = '\\'; seq = "\\\\"; break;}
                    case '0': case '1': case '2': case '3': case 'x': case 'X': {
                        char tmp = qbStr[2]; qbStr[2] = '\0'; char *eptr;
                        if (chr == 'x' || chr == 'X') {*cStr++ = strtoul(qbStr, &eptr, 16);} // hex value
                        else {*cStr++ = strtoul(&qbStr[-1], &eptr, 8);} // octal value
                        qbStr[2] = tmp; len = eptr - qbStr; qbStrLen -= len; qbStr = eptr;
                        seq = 0; // oct/hex indicator for debug output
                        break;
                    }
                    default: {*cStr++ = chr; break;} // no valid sequence (= literal)
                }
                #ifdef RSQBSTDARG_DEBUG
                len++; // for already processed backslash
                int32_t sspo = (ptrszint) qbStr - qbStrOri - len; int32_t sepo = sspo + len; // source start, end position
                int32_t tspo = (ptrszint) cStr - (ptrszint) cMemPtr; // target start position
                if (!seq && (chr == '0' || chr == '1' || chr == '2' || chr == '3')) {
                    DebugPrintf("octal token \\%03o replaced at positions %ld-%ld(%ld) in source(target) string", cStr[-1], sspo, sepo, tspo);}
                else if (!seq && (chr == 'x' || chr == 'X')) {
                    DebugPrintf("hex token \\x%02x replaced at positions %ld-%ld(%ld) in source(target) string", cStr[-1], sspo, sepo, tspo);}
                else {
                    DebugPrintf("token %s replaced at positions %ld-%ld(%ld) in source(target) string", seq, sspo, sepo, tspo);
                }
                #endif
            }
            else {*cStr++ = chr;} // regular literal char
        }
    }
    *cStr = '\0'; // zero terminate
    #ifdef RSQBSTDARG_DEBUG
    if (qbStr != 0) DebugPuts("## end string processing ##");
    DebugPrintf("results (*cStr)    = %s", cMemPtr);
    DebugClose(locOpen);
    #endif
    return (ptrszint) cMemPtr;
}

// --- Return the length (without zero termination) of the given CString
// --- copy previously made with MakeCString().
// ---------------------------------------------------------------------
int32_t LenCString(ptrszint cStr) {
    if (!fcdFlag) {return 0;} // nothing there yet
    #ifdef RSQBSTDARG_DEBUG
    int16_t locOpen = DebugOpen("LenCString (qbstdarg.h)");
    DebugPuts("given input...");
    DebugPrintf("pointer (cStr)  = 0x%016X", cStr);
    DebugPrintf("content (*cStr) = %s", cStr);
    #endif
    int32_t len = strlen((const char*) cStr);
    #ifdef RSQBSTDARG_DEBUG
    DebugPuts("result variables...");
    DebugPrintf("results (len)   = %ld", len);
    DebugClose(locOpen);
    #endif
    return len;
}

// --- Return the given CString copy, previously made with MakeCString(),
// --- back into a regular QB64 string.
// ---------------------------------------------------------------------
const char *ReadCString(ptrszint cStr) {
    if (!fcdFlag) {return "";} // nothing there yet
    #ifdef RSQBSTDARG_DEBUG
    int16_t locOpen = DebugOpen("ReadCString (qbstdarg.h)");
    DebugPuts("given input...");
    DebugPrintf("pointer (cStr)  = 0x%016X", cStr);
    DebugPrintf("content (*cStr) = %s", cStr);
    DebugPuts("returned as is...");
    DebugClose(locOpen);
    #endif
    return (const char*) cStr;
}

// --- Free the given CString copy made with MakeCString().
// ---------------------------------------------------------------------
void FreeCString(ptrszint cStr) {
    if (!fcdFlag) {return;} // nothing to free yet
    ptrszint *cMemPtr = (ptrszint*) cStr; cMemPtr--; // strptr - linkptrsz = memptr (cMemPtr--)
    #ifdef RSQBSTDARG_DEBUG
    int16_t locOpen = DebugOpen("FreeCString (qbstdarg.h)");
    DebugPuts("given input...");
    DebugPrintf("pointer (cStr)  = 0x%016X", cStr);
    DebugPrintf("content (*cStr) = %s", cStr);
    DebugPuts("runtime variables...");
    DebugPrintf("pointer (cMemPtr) = 0x%016X (adjusted (-- from casted cStr input))", cMemPtr);
    DebugPuts("## begin searching brain ##");
    #endif
    ptrszint *cMemPre = &cMemBrain;
    ptrszint *cMemTmp = (ptrszint*) cMemBrain;
    while (cMemTmp && (cMemTmp != cMemPtr)) { // verify given pointer
        #ifdef RSQBSTDARG_DEBUG
        DebugPrintf("pointer (cMemTmp) = 0x%016X (no match)", cMemTmp);
        #endif
        cMemPre = cMemTmp;
        cMemTmp = (ptrszint*) *cMemTmp;
    }
    #ifdef RSQBSTDARG_DEBUG
    DebugPrintf("pointer (cMemTmp) = 0x%016X (match or zero reached)", cMemTmp);
    DebugPuts("## end searching brain ##");
    #endif
    if (cMemTmp) { // if valid entry found, then unlink & free
        *cMemPre = *cMemTmp;
        free((void*) cMemTmp);
        #ifdef RSQBSTDARG_DEBUG
        DebugPuts("unlinked & freed...");
        #endif
    }
    #ifdef RSQBSTDARG_DEBUG
    DebugClose(locOpen);
    #endif
}

// --- Helper function to convert _OFFSET into _INTEGER64, which is not
// --- possible on the QB64 language level.
// ---------------------------------------------------------------------
int64_t OffToInt(ptrszint offs) {
    return (int64_t) offs;
}

} // namespace

#endif // RSQB_STDARG_H

