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
// | === qbdebug.h ===                                                 |
// |                                                                   |
// | == Common support functions for easy debug output on C/C++ level. |
// |                                                                   |
// +-------------------------------------------------------------------+
// | Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
// | Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
// | any questions or suggestions. Thanx for your interest in my work. |
// +-------------------------------------------------------------------+

#ifndef RSQB_DEBUG_H // include only once
#define RSQB_DEBUG_H

namespace rsqbdebug {

#define fModeNone 0   // do not filter anything
#define fModeSimple 1 // simple filtering, any ASCII < 32 --> |
#define fModeFull 2   // full info filtering, any ASCII < 32 --> |xx| (xx = decimal ASCII value)
                      // NOTE: unknown modes fallback = fModeSimple

char   dbgName[264]; // logfile name buffer
FILE   *dbgFile = 0; // logfile handle
int16_t glbOpen = 0; // global file open flag
int16_t ftrMode = 0; // active filter mode

int32_t numIndt = 0;    // indent count
char   *strIndt = "| "; // indent string

int16_t fcdFlag = 0; // first call done flag
int16_t eclFlag = 0; // empty close line flag

void DebugPuts(const char *dbgStr); // fwd ref

// --- Init the debug output logging system,
// --- needs to be called once to activate debug output. This should only
// --- be called from QB64 level (via SUB LogInit from qbdebug.bm) to keep
// --- debug output under user control. If not initialized, then calls to
// --- any of the other functions are ignored and no output is written.
// ---------------------------------------------------------------------
void DebugInit(const char *logName, int16_t filterMode) {
    if (!fcdFlag) {             // do init only once
        strcpy(dbgName, logName);
        remove(dbgName);
        ftrMode = filterMode;
        fcdFlag = -1;
    }
}

// --- Open a new branch in the debug output tree,
// --- should be called on a function's entry point or as introduction of
// --- a new debug section in the main program. The result must be stored
// --- and passed to a subsequent (matching) call to DebugClose().
// ---------------------------------------------------------------------
int16_t DebugOpen(const char *funcName) {
    int16_t locOpen = glbOpen;       // remember global file open state
    if (!fcdFlag) {return locOpen;}
    if (!glbOpen) {                  // if not already open, then do it now
        dbgFile = fopen(dbgName, "a");
        glbOpen = -1;
        fprintf(dbgFile, "+ [%s]\n", funcName);
    }
    else { // else it's a nested call, increase indention (new branch)
        if (!eclFlag) {
            for (int32_t i = numIndt; i; i--) {fputs(strIndt, dbgFile);}
            fputs("|\n", dbgFile);
        }
        for (int32_t i = numIndt; i; i--) {fputs(strIndt, dbgFile);}
        fprintf(dbgFile, "+-+ [%s]\n", funcName);
        numIndt++;
    }
    DebugPuts("===== enter ====="); // first regular debug output for each function
    return locOpen;                 // must be passed thru to DebugClose()
}

// --- Close a branch in the debug output tree,
// --- should be called on a function's exit point(s!!) or as conclusion
// --- of a debug section in the main program. The stored result of the
// --- respective (matching) DebugOpen() call must be passed in.
// ---------------------------------------------------------------------
void DebugClose(int16_t locOpen) {
    if (!glbOpen) {return;}
    DebugPuts("===== leave ====="); // last regular debug output for each function
    if (!locOpen) {                 // if file wasn't open already on DebugOpen(),
        fputs("\n\n", dbgFile);     // then close it again
        fclose(dbgFile);
        glbOpen = 0;
    }
    else { // else it was a nested call, decrease indention (end branch)
        numIndt--;
        for (int32_t i = numIndt; i; i--) {fputs(strIndt, dbgFile);}
        fputs("|\n", dbgFile);
        eclFlag = -1;
    }
}

// --- Helper function to filter control chars for clean tree layout.
// ---------------------------------------------------------------------
void FilterStr(char *buf, const char *str) {
    for (int32_t i = strlen(str); i ; i--) {
        unsigned char chr = *str++;
        if (chr < '\x20') {
            switch (ftrMode) {
                case fModeNone: {*buf++ = chr; break;}
                case fModeSimple: {*buf++ = '|'; break;}
                case fModeFull: {sprintf(buf, "|%02u|", chr); buf += 4; break;}
                default: {*buf++ = '|'; break;}
            }
        }
        else {*buf++ = chr;}
    }
    *buf = '\0';
}

// --- Puts a literal string to debug output,
// --- control chars will be filtered using the active filter mode.
// ---------------------------------------------------------------------
void DebugPuts(const char *dbgStr) {
    if (!glbOpen) {return;}
    for (int32_t i = numIndt; i; i--) {fputs(strIndt, dbgFile);}
    char *buf = (char*) malloc((strlen(dbgStr) << 2) + 1);
    FilterStr(buf, dbgStr);
    fprintf(dbgFile, "+-> %s\n", buf);
    free((void*) buf);
    eclFlag = 0;
    fflush(dbgFile);
}

// --- Printf a formatted string to debug output,
// --- control chars will be filtered using the active filter mode.
// ---------------------------------------------------------------------
void DebugPrintf(const char *dbgFmtStr, ...) {
    if (!glbOpen) {return;}
    for (int32_t i = numIndt; i; i--) {fputs(strIndt, dbgFile);}
    fputs("+-> ", dbgFile);
    va_list args; va_start(args, dbgFmtStr); // simulate to get buffer size
    int32_t num = vsnprintf(0, 0, dbgFmtStr, args);
    va_end(args);
    char *tmp = (char*) malloc(num + 1); // output to buffer
    va_start(args, dbgFmtStr);
    vsprintf(tmp, dbgFmtStr, args);
    va_end(args);
    char *buf = (char*) malloc((num << 2) + 1); // filter to new buffer
    FilterStr(buf, tmp);
    fprintf(dbgFile, "%s\n", buf);
    free((void*) buf); free((void*) tmp);
    eclFlag = 0;
    fflush(dbgFile);
}

// --- Check if the debug logging system is active,
// --- should be called from QB64 level only. Use it to create IF..THEN
// --- blocks which scope out any prepare/cleanup steps to avoid time
// --- wasting, if logging is off.
// ---------------------------------------------------------------------
int16_t DebugIsActive(void) {
    return glbOpen;
}

} // namespace

#endif // RSQB_DEBUG_H

