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
'| === Phonebook.bas ===                                             |
'|                                                                   |
'| == A short example to show the proper usage of the RS-Includes,   |
'| == carefully read the comments in the code.                       |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

_TITLE "Phonebook"

'--- The required include files (the init stuff).
'-----
'$INCLUDE: 'QB64Library\RS-Includes\types.bi'
'$INCLUDE: 'QB64Library\RS-Includes\memory.bi'
'$INCLUDE: 'QB64Library\RS-Includes\lists.bi'
'-----
'--- Many SUBs and FUNCTIONs used in this program are part of the include
'--- files types.bm, memory.bm and lists.bm included at the end of this main
'--- source file.

'--- The program's work directory.
'-----
IF _FILEEXISTS("qb64.exe") OR _FILEEXISTS("qb64pe.exe") THEN
    CHDIR "QB64Library\RS-Includes\example"
END IF

'--- Let's get started,
'--- 1. Init the General Purpose Memory System with max. size 8KiB.
'--- 2. Make a dump of the just initialized memory, if you take a look into
'---    the dumpfile then you should find all memory marked free (except the
'---    first 32 bytes, which are used by the GPM System itself).
'--- 3. Reserve a piece of memory for the Phonebook MinListHeader& structure.
'--- 4. If we got the memory, then init the new list, else panic with
'---    an "Out of Memory" error.
'-----
InitGPMem 8192&, 0&
DumpGPMem "phbDump-AfterInit.txt", gpmF_MarkFree& 'gpmF_ flags in memory.bi
phbList& = AllocGPMem&(MinListHeader_SizeOf&, gpmF_Clear&) 'MinListHeader_SizeOf& in lists.bi
IF phbList& <> 0 THEN
    NewList phbList&
ELSE
    ERROR 7 'this condition should be handled properly in a real application
END IF

'--- Define a structure to hold the data of a person,
'--- 1. We incorporate a ListNode& structure directly at the head for linkage,
'---    the ListNode& structure already has a name field, we use it for the
'---    person's last name, so we can use the FUNCTION FindName& on it.
'--- 2. Define a pointer to a string holding the person's first name.
'--- 3. Define a pointer to a string representing the person's phone number.
'--- 4. Define a label containing the size of the complete Person& structure.
'-----
DefSTRUCTURE Person&, ListNode_SizeOf& 'ListNode_SizeOf& in lists.bi
DefGPMSTR p_firstName&
DefGPMSTR p_phoneNumber&
DefLABEL Person_SizeOf&
lastState$ = "init sequence done..." 'guess what

'--- The program's main menu,
'--- not much to say about, everybody should be able to understand this code.
'-----
chooseAction:
GOSUB headLine
PRINT "State: "; lastState$ 'message returned by last action
PRINT "~~~~~~"
PRINT
PRINT "Phonebook - What to do:"
PRINT "~~~~~~~~~~~~~~~~~~~~~~~"
PRINT "1 - Add a Person"
PRINT "2 - Remove a Person"
PRINT "3 - Clear all"
PRINT
PRINT "4 - Find a Person(s)"
PRINT "5 - Show all Persons"
PRINT
PRINT "6 - Load Phonebook"
PRINT "7 - Save Phonebook"
PRINT
PRINT "8 - Make a memory dump"
PRINT "9 - Quit"
todo% = 0
WHILE (todo% < 1) OR (todo% > 9)
    _LIMIT 50
    todo% = VAL(INKEY$)
WEND
IF todo% = 9 GOTO quit
ON todo% GOSUB addPerson, remPerson, clearAll, lookPerson, showAll, loadBook, saveBook, memDump
GOTO chooseAction

'--- Cleanup and exit program,
'--- 1. Clear all persons in the current Phonebook list (ie. remove them from
'---    the list and free the memory they used).
'--- 2. Free the memory used by the Phonebook MinListHeader& structure.
'--- 3. Make a dump of the just cleaned memory (all memory should be marked
'---    free again after this cleanup, if everything worked as intended).
'-----
quit:
GOSUB clearAll
FreeGPMem phbList&, MinListHeader_SizeOf& 'MinListHeader_SizeOf& in lists.bi
DumpGPMem "phbDump-AfterCleanup.txt", gpmF_MarkFree& 'gpmF_ flags in memory.bi
SYSTEM

'--- The program's title bar,
'--- this is called from the main menu and many other places.
'-----
headLine:
CLS
COLOR 9: PRINT VersionPhonebook$: COLOR 7
PRINT
PRINT "A simple example to show the usage of types/memory/lists include file routines."
PRINT "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
RETURN

'--- Add a new person to the Phonebook list,
'--- see comments inside...
'-----
addPerson:
'--- first try getting memory for a new Person& structure
newPerson& = AllocGPMVec&(Person_SizeOf&, gpmF_Clear&)
'--- if ok, then init and link the new person
'--- else set error message (see ELSE branch) --> done...
IF newPerson& <> 0 THEN
    GOSUB headLine
    '--- ask for the new person's data
    LINE INPUT "First Name..: "; fn$
    LINE INPUT "Last Name...: "; ln$
    LINE INPUT "Phone Number: "; pn$
    '--- try creating zero terminated strings of it, and remember its pointers
    lnMStr& = CreateGPMString&(ln$)
    fnMStr& = CreateGPMString&(fn$)
    pnMStr& = CreateGPMString&(pn$)
    IF (lnMStr& = 0) OR (fnMStr& = 0) OR (pnMStr& = 0) THEN
        '--- if just one string creation did fail, then we need to free again
        '--- the strings, which were successful and also the already allocated
        '--- Person& structure, then set error message --> done...
        IF lnMStr& <> 0 THEN DisposeGPMString lnMStr&
        IF fnMStr& <> 0 THEN DisposeGPMString fnMStr&
        IF pnMStr& <> 0 THEN DisposeGPMString pnMStr&
        FreeGPMVec newPerson&
        lastState$ = "not enough memory for another Person..."
    ELSE
        '--- if we got all strings, then init the Person& structure with its
        '--- pointers, also we use the negative ASCII value of the last name's
        '--- first letter as node priority to achieve a ascending "pseudo"
        '--- alphabetical order (ie. just sorted by the first letter)
        '--- ln_Pri& and ln_Name& in lists.bi
        PokeB newPerson&, (Person& + ln_Pri&), -(ASC(UCASE$(LEFT$(ln$, 1))))
        PokeL newPerson&, (Person& + ln_Name&), lnMStr&
        PokeL newPerson&, p_firstName&, fnMStr&
        PokeL newPerson&, p_phoneNumber&, pnMStr&
        '--- finally link the initialized Person& structure by priority into
        '--- our Phonebook list, as the Person& structure has a incorporated
        '--- ListNode& structure directly at its head, we can hand over the
        '--- new Person& structure directly to "Enqueue"
        '-----
        '--- JUST AS NOTE: Would the ListNode& not be at the head, but anywhere
        '--- else in the Person& structure, then it were required to add the
        '--- ListNode&'s offset to the new Person& structure's address pointer,
        '--- so it's not really required to have the ListNode& always at the
        '--- head of a custom structure, but it makes things much easier
        Enqueue phbList&, newPerson&
        '--- set ok message --> done...
        lastState$ = "Person " + CHR$(34) + fn$ + " " + ln$ + CHR$(34) + " added..."
    END IF
ELSE
    lastState$ = "not enough memory for another Person..."
END IF
RETURN

'--- Remove a person from the Phonebook list,
'--- see comments inside...
'-----
remPerson:
GOSUB headLine
'--- ask for the person's full name
LINE INPUT "First Name..: "; fn$
LINE INPUT "Last Name...: "; ln$
'--- first try to find the person by its last name
oldPerson& = FindName&(phbList&, 0&, ln$, lstF_TextArg& + lstF_NoCase&)
'--- if found, then go on matching it against first name
'--- else set error message (see ELSE branch) --> done...
IF oldPerson& <> 0 THEN
    '--- if a person with matching last name was found, then try matching the
    '--- first name, if no match, then continue search by last name until the
    '--- entire list is done, otherwise exit search loop (EXIT WHILE)
    WHILE oldPerson& <> 0
        IF UCASE$(PeekSTR$(PeekL&(oldPerson&, p_firstName&), 0&)) <> UCASE$(fn$) THEN
            oldPerson& = FindName&(oldPerson&, 0&, ln$, lstF_TextArg + lstF_NoCase)
            '--- Note that we did use the last found person (by last name) in
            '--- the last call, instead of the phbList&, to continue the search
            '--- (see also RSI-Docs / Searching by Name and FindName& reference)
        ELSE
            EXIT WHILE
        END IF
    WEND
    '--- when the program arrives at this point, then either the entire list is
    '--- done without success, or the person in question was found, we check
    '--- this via the oldPerson& pointer, if the person was found, then this
    '--- pointer is non-zero, pointing to the found person's Person& structure,
    '--- else set error message --> done...
    IF oldPerson& <> 0 THEN
        '--- if the person was found, then first remove it's Person& structure
        '--- from the Phonebook list, once again it comes in handy, that the
        '--- ListNode& structure is at the head of the Person& structure, so we
        '--- just hand over the Person& structure to "Remove"
        Remove oldPerson&
        '--- now dispose all the strings stored in the Person& structure
        DisposeGPMString PeekL&(oldPerson&, (Person& + ln_Name&))
        DisposeGPMString PeekL&(oldPerson&, p_firstName&)
        DisposeGPMString PeekL&(oldPerson&, p_phoneNumber&)
        '--- finally dispose (free) the Person& structure itself
        FreeGPMVec oldPerson&
        '--- set ok message --> done...
        lastState$ = "Person " + CHR$(34) + fn$ + " " + ln$ + CHR$(34) + " removed..."
    ELSE
        lastState$ = "Person " + CHR$(34) + fn$ + " " + ln$ + CHR$(34) + " not found..."
    END IF
ELSE
    lastState$ = "Person " + CHR$(34) + fn$ + " " + ln$ + CHR$(34) + " not found..."
END IF
RETURN

'--- Clear all persons in the current Phonebook list,
'--- see comments inside...
'-----
clearAll:
'--- remove a person from list, if any
onePerson& = RemHead&(phbList&) 'RemTail&() would do it too here
'--- if the list is already empty, then the WHILE..WEND loop is skipped
'--- at all --> done...
WHILE onePerson& <> 0
    '--- dispose all the strings stored in the just removed Person& structure
    DisposeGPMString PeekL&(onePerson&, (Person& + ln_Name&))
    DisposeGPMString PeekL&(onePerson&, p_firstName&)
    DisposeGPMString PeekL&(onePerson&, p_phoneNumber&)
    '--- finally dispose (free) the Person& structure itself
    FreeGPMVec onePerson&
    '--- remove the next person from the list, if any
    onePerson& = RemHead&(phbList&) 'RemTail&() would do it too here
WEND
'--- set message --> done...
lastState$ = "all Persons cleared, Phonebook empty..."
RETURN

'--- Search person(s) by (partial) last name,
'--- see comments inside...
'-----
lookPerson:
GOSUB headLine
'--- ask for last name or part of it
LINE INPUT "(partial) Last Name...: "; ln$
PRINT
'--- search the first person matching the given name (part), take notice of
'--- the lstF_Mid& flag used in the call (btw. lstF_ flags in lists.bi)
onePerson& = FindName&(phbList&, 0&, ln$, lstF_TextArg& + lstF_NoCase& + lstF_Mid&)
'--- if a match was found, then print info and continue search,
'--- else set error message (see ELSE branch) --> done...
IF onePerson& <> 0 THEN
    WHILE onePerson& <> 0
        '--- if we got a match, then read out the strings and print them,
        '--- note that the 2nd argument to the PeekSTR$ function, which is
        '--- usually the offset within the structure, is zero (see also the
        '--- RSI-Docs about the addr& and offs& arguments of the various
        '--- PokeXX and PeekXX SUBs and FUNCTIONs)
        PRINT PeekSTR$(PeekL&(onePerson&, (Person& + ln_Name&)), 0&); ", ";
        PRINT PeekSTR$(PeekL&(onePerson&, p_firstName&), 0&); " - Ph#: ";
        PRINT PeekSTR$(PeekL&(onePerson&, p_phoneNumber&), 0&)
        '--- continue the search
        onePerson& = FindName&(onePerson&, 0&, ln$, lstF_TextArg + lstF_NoCase + lstF_Mid&)
        '--- Note that we did use the last found person in the last call,
        '--- instead of the phbList&, to continue the search (see also the
        '--- RSI-Docs / Searching by Name and FindName& reference)
    WEND
    PRINT
    '--- wait until the user has read the results
    PRINT "press any key..."
    WHILE INKEY$ = ""
        SLEEP
    WEND
    '--- set message --> done...
    lastState$ = "listing of Person(s) with (partial) Last Name " + CHR$(34) + ln$ + CHR$(34) + " done..."
ELSE
    lastState$ = "no Person with (partial) Last Name " + CHR$(34) + ln$ + CHR$(34) + " found..."
END IF
RETURN

'---------------------------------------------------------------------
'--- That's all, right here I stop extensive commenting, it sucks :-)
'--- many parts following are similar to the already commented parts,
'--- and learning by doing is still the best method...
'---------------------------------------------------------------------

'--- View all persons currently in the Phonebook list,
'--- similar as the lookPerson: routine above, just without the FindName&
'--- stuff, which is replaced by GetHead& and GetSucc& to scan the entire list.
'-----
showAll:
GOSUB headLine
onePerson& = GetHead&(phbList&)
IF onePerson& <> 0 THEN
    WHILE onePerson& <> 0
        PRINT PeekSTR$(PeekL&(onePerson&, (Person& + ln_Name&)), 0&); ", ";
        PRINT PeekSTR$(PeekL&(onePerson&, p_firstName&), 0&); " - Ph#: ";
        PRINT PeekSTR$(PeekL&(onePerson&, p_phoneNumber&), 0&)
        onePerson& = GetSucc&(onePerson&)
    WEND
    PRINT
    PRINT "press any key..."
    WHILE INKEY$ = ""
        SLEEP
    WEND
    lastState$ = "listing of all Person(s) done..."
ELSE
    lastState$ = "Phonebook is empty..."
END IF
RETURN

'--- Load all persons from a former saved file,
'--- the operations performed here are similar to the addPerson: routine above,
'--- the persons data are read from file instead of asking the user, notice the
'--- IsListEmpty& function, which is used here for the first time.
'-----
loadBook:
IF NOT IsListEmpty&(phbList&) THEN
    GOSUB headLine
    LINE INPUT "Phonebook not empty, load and append? (y/N): "; ask$
    IF UCASE$(ask$) <> "Y" THEN
        lastState$ = "loading Phonebook aborted by user..."
        RETURN
    END IF
END IF
IF NOT _FILEEXISTS("phbook.txt") THEN
    lastState$ = "Phonebook file " + CHR$(34) + "phbook.txt" + CHR$(34) + " does not exist..."
    RETURN
END IF
OPEN "I", #1, "phbook.txt"
WHILE NOT EOF(1)
    newPerson& = AllocGPMVec&(Person_SizeOf&, gpmF_Clear&)
    IF newPerson& <> 0 THEN
        INPUT #1, fn$, ln$, pn$
        lnMStr& = CreateGPMString&(ln$)
        fnMStr& = CreateGPMString&(fn$)
        pnMStr& = CreateGPMString&(pn$)
        IF (lnMStr& = 0) OR (fnMStr& = 0) OR (pnMStr& = 0) THEN
            IF lnMStr& <> 0 THEN DisposeGPMString lnMStr&
            IF fnMStr& <> 0 THEN DisposeGPMString fnMStr&
            IF pnMStr& <> 0 THEN DisposeGPMString pnMStr&
            FreeGPMVec newPerson&
            lastState$ = "not enough memory to load all Persons..."
            EXIT WHILE
        ELSE
            PokeB newPerson&, (Person& + ln_Pri&), -(ASC(UCASE$(LEFT$(ln$, 1))))
            PokeL newPerson&, (Person& + ln_Name&), lnMStr&
            PokeL newPerson&, p_firstName&, fnMStr&
            PokeL newPerson&, p_phoneNumber&, pnMStr&
            Enqueue phbList&, newPerson&
            lastState$ = "all Persons loaded from " + CHR$(34) + "phbook.txt" + CHR$(34) + "..."
        END IF
    ELSE
        lastState$ = "not enough memory to load all Persons..."
        EXIT WHILE
    END IF
WEND
CLOSE #1
RETURN

'--- Save all persons currently in the Phonebook list,
'--- similar as the lookPerson: and showAll: routines above, once again
'--- GetHead& and GetSucc& are used to scan the entire list, the strings
'--- are read out and written to a file.
'-----
saveBook:
onePerson& = GetHead&(phbList&)
IF onePerson& <> 0 THEN
    OPEN "O", #1, "phbook.txt"
    WHILE onePerson& <> 0
        ln$ = PeekSTR$(PeekL&(onePerson&, (Person& + ln_Name&)), 0&)
        fn$ = PeekSTR$(PeekL&(onePerson&, p_firstName&), 0&)
        pn$ = PeekSTR$(PeekL&(onePerson&, p_phoneNumber&), 0&)
        WRITE #1, fn$, ln$, pn$
        onePerson& = GetSucc&(onePerson&)
    WEND
    CLOSE #1
    lastState$ = "all Persons saved to " + CHR$(34) + "phbook.txt" + CHR$(34) + "..."
ELSE
    lastState$ = "Phonebook is empty..."
END IF
RETURN

'--- Make another memory dump,
'--- you may use this, if you're curious about how the data is stored.
'-----
memDump:
GOSUB headLine
LINE INPUT "Filename for memory dumpfile: "; df$
DumpGPMem df$, gpmF_MarkFree&
lastState$ = "memory dumpfile " + CHR$(34) + df$ + CHR$(34) + " written..."
RETURN

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionPhonebook$
VersionPhonebook$ = MID$("$VER: Phonebook 1.0 (09-Mar-2012) by RhoSigma :END$", 7, 39)
END FUNCTION

'--- The required include files (the SUBs and FUNCTIONs).
'-----
'$INCLUDE: 'QB64Library\RS-Includes\types.bm'
'$INCLUDE: 'QB64Library\RS-Includes\memory.bm'
'$INCLUDE: 'QB64Library\RS-Includes\lists.bm'

