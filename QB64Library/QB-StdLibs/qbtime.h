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
// | === qbtime.h ===                                                  |
// |                                                                   |
// | == Some low level support functions for routines in qbtime.bm.    |
// |                                                                   |
// +-------------------------------------------------------------------+
// | Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
// | Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
// | any questions or suggestions. Thanx for your interest in my work. |
// +-------------------------------------------------------------------+

#ifndef RSQB_TIME_H // include only once
#define RSQB_TIME_H

//#define RSQBTIME_DEBUG // debug output flag

#ifdef RSQBTIME_DEBUG
#include "..\QB-Debug\qbdebug.h"
using rsqbdebug::DebugOpen;
using rsqbdebug::DebugClose;
using rsqbdebug::DebugPuts;
using rsqbdebug::DebugPrintf;
#endif

#include "qbstdarg.h"
using rsqbstdarg::MakeCString;

namespace rsqbtime {

// --- Formatted write of current date and time, using the given format
// --- template, to a fixed size string buffer.
// ---------------------------------------------------------------------
ptrszint CurrentTimeToBuffer(ptrszint cFmtStr) {
    #ifdef RSQBTIME_DEBUG
    int16_t locOpen = DebugOpen("CurrentTimeToBuffer (qbtime.h)");
    DebugPuts("given input...");
    DebugPrintf("pointer (cFmtStr)  = 0x%016X", cFmtStr);
    DebugPrintf("content (*cFmtStr) = %s", cFmtStr);
    #endif
    char *cStr = (char*) MakeCString(0, 1024); // create output buffer
    cStr[0] = '\0'; // for safety, in case nothing is written
    time_t curr; time(&curr); // get current time
    int32_t num = strftime(cStr, 1024, (const char*) cFmtStr, localtime(&curr)); // format to buffer
    #ifdef RSQBTIME_DEBUG
    DebugPuts("result variables...");
    DebugPrintf("written (num)   = %ld", num);
    DebugPrintf("pointer (cStr)  = 0x%016X", cStr);
    DebugPrintf("content (*cStr) = %s", cStr);
    DebugClose(locOpen);
    #endif
    return (ptrszint) cStr;
}

// --- Formatted write of given date and time, using the given format
// --- template, to a fixed size string buffer.
// ---------------------------------------------------------------------
ptrszint GivenTimeToBuffer(ptrszint cFmtStr, const char *qbArgStr) {
    #ifdef RSQBTIME_DEBUG
    int16_t locOpen = DebugOpen("GivenTimeToBuffer (qbtime.h)");
    DebugPuts("given input...");
    DebugPrintf("pointer (cFmtStr)  = 0x%016X", cFmtStr);
    DebugPrintf("content (*cFmtStr) = %s", cFmtStr);
    DebugPrintf("pointer (qbArgStr) = 0x%016X", qbArgStr);
    struct tm *tmp = (struct tm*) qbArgStr;
    DebugPrintf("content (tm_mday)  = %hu", tmp -> tm_mday);
    DebugPrintf("content (tm_mon)   = %hu", tmp -> tm_mon);
    DebugPrintf("content (tm_year)  = %hu", tmp -> tm_year);
    DebugPrintf("content (tm_hour)  = %hu", tmp -> tm_hour);
    DebugPrintf("content (tm_min)   = %hu", tmp -> tm_min);
    DebugPrintf("content (tm_sec)   = %hu", tmp -> tm_sec);
    #endif
    char *cStr = (char*) MakeCString(0, 1024); // create output buffer
    cStr[0] = '\0'; // for safety, in case nothing is written
    if (-1 == mktime((struct tm*) qbArgStr)) { // adjust given tm structure
        #ifdef RSQBTIME_DEBUG
        DebugPuts("error, date/time out of supported range...");
        #endif
    } else {
        int32_t num = strftime(cStr, 1024, (const char*) cFmtStr, (const struct tm*) qbArgStr); // format to buffer
        #ifdef RSQBTIME_DEBUG
        DebugPuts("result variables...");
        DebugPrintf("written (num)   = %ld", num);
        DebugPrintf("pointer (cStr)  = 0x%016X", cStr);
        DebugPrintf("content (*cStr) = %s", cStr);
        #endif
    }
    #ifdef RSQBTIME_DEBUG
    DebugClose(locOpen);
    #endif
    return (ptrszint) cStr;
}

} // namespace

#endif // RSQB_TIME_H

