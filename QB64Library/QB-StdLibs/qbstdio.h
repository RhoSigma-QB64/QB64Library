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
// | === qbstdio.h ===                                                 |
// |                                                                   |
// | == Some low level support functions for routines in qbstdio.bm.   |
// |                                                                   |
// +-------------------------------------------------------------------+
// | Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
// | Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
// | any questions or suggestions. Thanx for your interest in my work. |
// +-------------------------------------------------------------------+

#ifndef RSQB_STDIO_H // include only once
#define RSQB_STDIO_H

//#define RSQBSTDIO_DEBUG // debug output flag

#ifdef RSQBSTDIO_DEBUG
#include "..\QB-Debug\qbdebug.h"
using rsqbdebug::DebugOpen;
using rsqbdebug::DebugClose;
using rsqbdebug::DebugPuts;
using rsqbdebug::DebugPrintf;
#endif

#include "qbstdarg.h"
using rsqbstdarg::MakeCString;

namespace rsqbstdio {

// --- Formatted write of given variable arguments, using the given format
// --- template, to auto-sized string buffer.
// ---------------------------------------------------------------------
ptrszint FormatToBuffer(ptrszint cFmtStr, const char *qbArgStr) {
    #ifdef RSQBSTDIO_DEBUG
    int16_t locOpen = DebugOpen("FormatToBuffer (qbstdio.h)");
    DebugPuts("given input...");
    DebugPrintf("pointer (cFmtStr)  = 0x%016X", cFmtStr);
    DebugPrintf("content (*cFmtStr) = %s", cFmtStr);
    DebugPrintf("pointer (qbArgStr) = 0x%016X", qbArgStr);
    #endif
    int32_t num = vsnprintf(0, 0, (const char*) cFmtStr, (va_list) qbArgStr); // simulate to get buffer size
    char *cStr = (char*) MakeCString(0, num); // create output buffer
    cStr[0] = '\0'; // for safety, in case nothing is written
    vsprintf(cStr, (const char*) cFmtStr, (va_list) qbArgStr); // format to buffer
    #ifdef RSQBSTDIO_DEBUG
    DebugPuts("result variables...");
    DebugPrintf("written (num)   = %ld", num);
    DebugPrintf("pointer (cStr)  = 0x%016X", cStr);
    DebugPrintf("content (*cStr) = %s", cStr);
    DebugClose(locOpen);
    #endif
    return (ptrszint) cStr;
}

} // namespace

#endif // RSQB_STDIO_H

