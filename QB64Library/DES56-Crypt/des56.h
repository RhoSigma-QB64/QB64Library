/*
** des56.h - API to 56-bit DES encryption
**
** Copyright (C) 1991 Jochen Obalek
** Revision  (1) 2005 RhoSigma, Roland Heyder
** Revision  (2) 2013 RhoSigma, Roland Heyder (for QB64 use)
**
** Changes done by RhoSigma, Roland Heyder:
** -------(1)-------(1)-------(1)-------(1)-------(1)-------(1)--------
**   (1) general cleanup (bad tab usage, function/variable names were
**       mixed half english half german)
**   (2) complete rework of typing, only using common types to make
**       the source easier portable to another hardware platform
**   (3) function crypt() renamed -> cryptpass()
**   (4) some low-level functions added:
**       - makekey()    - conversion Password -> Key Bits
**       - splitbytes() - conversion Data(byte)chunk -> Data Bits
**       - joinbytes()  - conversion Data Bits -> Data(byte)chunk
**   (5) some high-level functions added:
**       - encryptfile() - encrypt a file with given password of
**                         unlimited length
**       - decryptfile() - decrypt a file with given password of
**                         unlimited length
**   (6) added defines for error numbers and special values used by
**       encryptfile() and decryptfile()
**   (7) added complete documentation for all functions
** -------(2)-------(2)-------(2)-------(2)-------(2)-------(2)--------
**   (8) some minor changes for use as a QB64 library
**       - renamed encrypt.c/h to des56.c/h respectivly to clearly
**         name the cryptographic algorithm contained
**       - joint des56.h and des56.c into one file for DECLARE LIBRARY
**       - addded "RSQB" include guard and namespace
**       - removed progress display stuff, as QB64 cannot pass callback
**         hooks (pointer to function) to called C/C++ functions
**       - flipped some 4-Byte identifiers for little endian usage
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2, or (at your option)
** any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
**
*/

#ifndef RSQB_DES56_H
#define RSQB_DES56_H

namespace rsqbdes56 {

/***********************************************************/
/* Error Codes returned by encryptfile() and decryptfile() */
/***********************************************************/

#define WARN_NOTCRYPTED -1 /* returned by decryptfile() only, */
                           /* given file is not encrypted, at */
                           /* least not with encryptfile() of */
                           /* this API                        */

#define ERROR_NONE       0 /* no error, file was successfully */
                           /* encrypted or decrypted          */

#define ERROR_NOACCESS   1 /* specified file could not be opened */
                           /* either not found or not accessible */

#define ERROR_NOPASS     2 /* pointer to password was 0, or the */
                           /* password is empty (zero length)   */

#define ERROR_BADCHUNK   3 /* returned by decryptfile() only, */
                           /* expected data chunk not found,  */
                           /* either encrypted by a diff. API */
                           /* version or file is truncated    */

#define ERROR_TRUNCATED  4 /* returned by decryptfile() only, */
                           /* file is certainly truncated     */

#define ERROR_WRONGCRC   5 /* returned by decryptfile() only, */
                           /* wrong checksum indicates either */
                           /* file damage, file manipulation  */
                           /* or (most probably case) wrong   */
                           /* password for decryption         */

#define ERROR_FILEOP     6 /* error during common file operation */
                           /* like fseek(), ftell() etc.         */

#define ERROR_FILEREAD   7 /* error while reading data from file */
#define ERROR_FILEWRITE  8 /* error while writing data to file   */

#define ERROR_LOWMEM     9 /* running out of memory during */
                           /* file buffering               */

/**********************************************************/
/* Normal Level Functions (user API to DES-56 encryption) */
/**********************************************************/

/*------------------------------------------------------------*/
/* Injects the key derived from the given password to DES-56. */
/*------------------------------------------------------------*/
/* key: a pointer to a 64 bytes long chain of 0x00 and 0x01   */
/*      bytes, which represents the bit pattern of an 1-8     */
/*      characters long password (use makekey() to generate   */
/*      such a chain from your given password)                */
/*------------------------------------------------------------*/
extern void setkey(char *key);

/*---------------------------------------------------------------*/
/* After injecting a key you may use this function to encrypt or */
/* decrypt a given block of data.                                */
/*---------------------------------------------------------------*/
/*  block: a pointer to a 64 bytes long chain of 0x00 and 0x01   */
/*         bytes, which represents the bit pattern of an 8 bytes */
/*         long chunk of your data buffer (use splitbytes() to   */
/*         generate the chain from your data chunk)              */
/*                                                               */
/* edflag: FALSE (zero) to encrypt the given chain of bytes      */
/*         TRUE (non-zero) to decrypt the given chain of bytes   */
/*                                                               */
/* RESULT: the passed through pointer to your data "block",      */
/*         containing the 64 bytes of 0x00 and 0x01 in its       */
/*         en-/decrypted order, these must be reassembled to get */
/*         back the regular 8 bytes (use joinbytes() for this)   */
/*---------------------------------------------------------------*/
extern char *encrypt(char *block, int16_t edflag);

/*************************************************************************/
/* Normal Level Functions (user API support for Byte <-> Bit conversion) */
/*************************************************************************/

/*-------------------------------------------------------------*/
/* Generates a 64 bytes long chain of 0x00 and 0x01 bytes from */
/* a given 1-8 characters long password.                       */
/*-------------------------------------------------------------*/
/*  passw: a pointer to the password to use (1-8 characters    */
/*         terminated by a byte of zero (0x00))                */
/*                                                             */
/* RESULT: a pointer to a 64 bytes long chain of 0x00 and 0x01 */
/*         bytes, which represents the bit pattern of the      */
/*         given password (suitable for setkey() call)         */
/*                                                             */
/*   NOTE: the result is static, means it will be overwritten  */
/*         at the next time this function is called, so any    */
/*         processing of the chain should be done first, or    */
/*         you must create a copy of it for later use          */
/*                                                             */
/* WARNING: this function seems to be similar to splitbytes(), */
/*          but is NOT, use it only for passwords and use the  */
/*          result only for setkey() calls                     */
/*-------------------------------------------------------------*/
extern char *makekey(const char *passw);

/*-------------------------------------------------------------*/
/* Generates a 64 bytes long chain of 0x00 and 0x01 bytes from */
/* a given 8 bytes long chunk of data.                         */
/*-------------------------------------------------------------*/
/*  block: a pointer to the data chunk (must be 8 bytes long,  */
/*         fill with zero bytes (0x00) if required)            */
/*                                                             */
/* RESULT: a pointer to a 64 bytes long chain of 0x00 and 0x01 */
/*         bytes, which represents the bit pattern of the      */
/*         given data chunk (suitable for encrypt() call)      */
/*                                                             */
/*   NOTE: the result is static, means it will be overwritten  */
/*         at the next time this function is called, so any    */
/*         processing of the chain should be done first, or    */
/*         you must create a copy of it for later use          */
/*                                                             */
/* WARNING: this function seems to be similar to makekey(),    */
/*          but is NOT, use it only for data chunk and use the */
/*          result only for encrypt() calls                    */
/*-------------------------------------------------------------*/
extern char *splitbytes(char *block);

/*-------------------------------------------------------------*/
/* Generates an 8 bytes long data chunk from a given 64 bytes  */
/* long chain of 0x00 and 0x01 bytes.                          */
/*-------------------------------------------------------------*/
/*  block: a pointer to a 64 bytes long chain of 0x00 and 0x01 */
/*         bytes, which contains the bit pattern for the new   */
/*         data chunk (as returned by encrypt() call)          */
/*                                                             */
/* RESULT: a pointer to the 8 bytes long data chunk (if this   */
/*         was an encryption, then you must save all 8 bytes,  */
/*         even if you've filled the original data with zeros, */
/*         because all bytes are needed to properly decrypt    */
/*         the data chunk again)                               */
/*                                                             */
/*   NOTE: the result is static, means it will be overwritten  */
/*         at the next time this function is called, so any    */
/*         processing of the data chunk should be done first,  */
/*         or you must create a copy of it for later use       */
/*-------------------------------------------------------------*/
extern char *joinbytes(char *block);

/****************************************************************/
/* Higher Level Functions (user API support for specific tasks) */
/****************************************************************/

/*------------------------------------------------------------*/
/* One way encryption of a given user password (e.g. for      */
/* .htaccess based Web-Site protection). This encryption is   */
/* non-reversible.                                            */
/*------------------------------------------------------------*/
/*  passw: a pointer to the password to use (1-8 characters   */
/*         terminated by a byte of zero (0x00))               */
/*                                                            */
/*   salt: a pointer to an 1-2 characters long salt string,   */
/*         which randomizes the encryption (for Web-Passwords */
/*         this string must match the string prescribed by    */
/*         the webspace provider for that particular Web-Site */
/*         (you have to ask for it, if required))             */
/*                                                            */
/* RESULT: a pointer to the encrypted password for .htaccess  */
/*         based protection (13 characters terminated by 0)   */
/*                                                            */
/*   NOTE: the result is static, means it will be overwritten */
/*         at the next time this function is called, so any   */
/*         processing of the data chunk should be done first, */
/*         or you must create a copy of it for later use      */
/*------------------------------------------------------------*/
extern char *cryptpass(const char *passw, const char *salt);

/*-------------------------------------------------------------------*/
/* This function will encrypt a whole file using the given password. */
/*-------------------------------------------------------------------*/
/*    fname: a pointer to the full filename (if required with path), */
/*           which is terminated by a byte of zero (0x00)            */
/*                                                                   */
/*    passw: a pointer to the password to use (unlimited number of   */
/*           characters terminated by zero)(see also notes)          */
/*                                                                   */
/*   RESULT: 0 for success, else any of the errors defined above     */
/*                                                                   */
/*     NOTE: if the password is longer than 8 characters, then auto- */
/*           maticly a multi pass encryption is done, i.e. the pw is */
/*           cutted in pieces of 8 chars and every pass will use one */
/*           of the pieces for encryption, this way you really must  */
/*           provide the very same password for decryption, even if  */
/*           the algorithm only use 8 char passwords                 */
/*-------------------------------------------------------------------*/
extern int16_t encryptfile(const char *fname, const char *passw);

/*-------------------------------------------------------------------*/
/* This function will decrypt a whole file using the given password. */
/*-------------------------------------------------------------------*/
/* Synopsis of this function is equal to encryptfile(), see there... */
/*-------------------------------------------------------------------*/
extern int16_t decryptfile(const char *fname, const char *passw);



/********************************/
/* joining des56.c into des56.h */
/********************************/



/*
** des56.c - providing 56-bit DES encryption
**
** Copyright (C) 1991 Jochen Obalek
** Revision  (1) 2005 RhoSigma, Roland Heyder
** Revision  (2) 2013 RhoSigma, Roland Heyder (for QB64 use)
**
** Changes done by RhoSigma, Roland Heyder:
** -------(1)-------(1)-------(1)-------(1)-------(1)-------(1)--------
**   (1) general cleanup (bad tab usage, function/variable names were
**       mixed half english half german)
**   (2) complete rework of typing, only using common types to make
**       the source easier portable to another hardware platform
**   (3) function crypt() renamed -> cryptpass()
**   (4) some low-level functions added:
**       - makekey()    - conversion Password -> Key Bits
**       - splitbytes() - conversion Data(byte)chunk -> Data Bits
**       - joinbytes()  - conversion Data Bits -> Data(byte)chunk
**   (5) some high-level functions added:
**       - encryptfile() - encrypt a file with given password of
**                         unlimited length
**       - decryptfile() - decrypt a file with given password of
**                         unlimited length
**   (6) added defines for error numbers and special values used by
**       encryptfile() and decryptfile()
**   (7) added complete documentation for all functions
** -------(2)-------(2)-------(2)-------(2)-------(2)-------(2)--------
**   (8) some minor changes for use as a QB64 library
**       - renamed encrypt.c/h to des56.c/h respectivly to clearly
**         name the cryptographic algorithm contained
**       - joint des56.h and des56.c into one file for DECLARE LIBRARY
**       - addded "RSQB" include guard and namespace
**       - removed progress display stuff, as QB64 cannot pass callback
**         hooks (pointer to function) to called C/C++ functions
**       - flipped some 4-Byte identifiers for little endian usage
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2, or (at your option)
** any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
**
*/

#define BS  64  /* block size */
#define BS2 32  /* half block */
#define KS  48  /* key size   */
#define KS2 24  /* half key   */
#define IS  56  /* input size */
#define IS2 28  /* half input */

#define FBUF_SIZE 10240 /* file buffer size (in multiples of 16) */

/* 16x48 Bits */
static char keyBlock[16][KS];

/* 56 Bits */
static char PC1[] =
{
    56, 48, 40, 32, 24, 16,  8,  0,
    57, 49, 41, 33, 25, 17,  9,  1,
    58, 50, 42, 34, 26, 18, 10,  2,
    59, 51, 43, 35,
    62, 54, 46, 38, 30, 22, 14,  6,
    61, 53, 45, 37, 29, 21, 13,  5,
    60, 52, 44, 36, 28, 20, 12,  4,
    27, 19, 11,  3
};

/* 48 Bits */
static char PC2[] =
{
    13, 16, 10, 23,  0,  4,  2, 27,
    14,  5, 20,  9, 22, 18, 11,  3,
    25,  7, 15,  6, 26, 19, 12,  1,
    40, 51, 30, 36, 46, 54, 29, 39,
    50, 44, 32, 47, 43, 48, 38, 55,
    33, 52, 45, 41, 49, 35, 28, 31
};

/* 64 Bits */
static char IP[] =
{
    57, 49, 41, 33, 25, 17,  9,  1,
    59, 51, 43, 35, 27, 19, 11,  3,
    61, 53, 45, 37, 29, 21, 13,  5,
    63, 55, 47, 39, 31, 23, 15,  7,
    56, 48, 40, 32, 24, 16,  8,  0,
    58, 50, 42, 34, 26, 18, 10,  2,
    60, 52, 44, 36, 28, 20, 12,  4,
    62, 54, 46, 38, 30, 22, 14,  6
};

/* 64 Bits */
static char EP[] =
{
     7, 39, 15, 47, 23, 55, 31, 63,
     6, 38, 14, 46, 22, 54, 30, 62,
     5, 37, 13, 45, 21, 53, 29, 61,
     4, 36, 12, 44, 20, 52, 28, 60,
     3, 35, 11, 43, 19, 51, 27, 59,
     2, 34, 10, 42, 18, 50, 26, 58,
     1, 33,  9, 41, 17, 49, 25, 57,
     0, 32,  8, 40, 16, 48, 24, 56
};

/* 48 Bits */
static char E0[] =
{
    31,  0,  1,  2,  3,  4,  3,  4,
     5,  6,  7,  8,  7,  8,  9, 10,
    11, 12, 11, 12, 13, 14, 15, 16,
    15, 16, 17, 18, 19, 20, 19, 20,
    21, 22, 23, 24, 23, 24, 25, 26,
    27, 28, 27, 28, 29, 30, 31,  0
};

/* 48 Bits */
static char E[KS];

/* 24 Bits */
static char PERM[] =
{
    15,  6, 19, 20, 28, 11, 27, 16,
     0, 14, 22, 25,  4, 17, 30,  9,
     1,  7, 23, 13, 31, 26,  2,  8,
    18, 12, 29,  5, 21, 10,  3, 24
};

/* 8x64 Bits */
static char S_BOX[][64] =
{
    {
        14,  0,  4, 15, 13,  7,  1,  4,  2, 14, 15,  2, 11, 13,  8,  1,
         3, 10, 10,  6,  6, 12, 12, 11,  5,  9,  9,  5,  0,  3,  7,  8,
         4, 15,  1, 12, 14,  8,  8,  2, 13,  4,  6,  9,  2,  1, 11,  7,
        15,  5, 12, 11,  9,  3,  7, 14,  3, 10, 10,  0,  5,  6,  0, 13
    },
    {
        15,  3,  1, 13,  8,  4, 14,  7,  6, 15, 11,  2,  3,  8,  4, 14,
         9, 12,  7,  0,  2,  1, 13, 10, 12,  6,  0,  9,  5, 11, 10,  5,
         0, 13, 14,  8,  7, 10, 11,  1, 10,  3,  4, 15, 13,  4,  1,  2,
         5, 11,  8,  6, 12,  7,  6, 12,  9,  0,  3,  5,  2, 14, 15,  9
    },
    {
        10, 13,  0,  7,  9,  0, 14,  9,  6,  3,  3,  4, 15,  6,  5, 10,
         1,  2, 13,  8, 12,  5,  7, 14, 11, 12,  4, 11,  2, 15,  8,  1,
        13,  1,  6, 10,  4, 13,  9,  0,  8,  6, 15,  9,  3,  8,  0,  7,
        11,  4,  1, 15,  2, 14, 12,  3,  5, 11, 10,  5, 14,  2,  7, 12
    },
    {
         7, 13, 13,  8, 14, 11,  3,  5,  0,  6,  6, 15,  9,  0, 10,  3,
         1,  4,  2,  7,  8,  2,  5, 12, 11,  1, 12, 10,  4, 14, 15,  9,
        10,  3,  6, 15,  9,  0,  0,  6, 12, 10, 11,  1,  7, 13, 13,  8,
        15,  9,  1,  4,  3,  5, 14, 11,  5, 12,  2,  7,  8,  2,  4, 14
    },
    {
         2, 14, 12, 11,  4,  2,  1, 12,  7,  4, 10,  7, 11, 13,  6,  1,
         8,  5,  5,  0,  3, 15, 15, 10, 13,  3,  0,  9, 14,  8,  9,  6,
         4, 11,  2,  8,  1, 12, 11,  7, 10,  1, 13, 14,  7,  2,  8, 13,
        15,  6,  9, 15, 12,  0,  5,  9,  6, 10,  3,  4,  0,  5, 14,  3
    },
    {
        12, 10,  1, 15, 10,  4, 15,  2,  9,  7,  2, 12,  6,  9,  8,  5,
         0,  6, 13,  1,  3, 13,  4, 14, 14,  0,  7, 11,  5,  3, 11,  8,
         9,  4, 14,  3, 15,  2,  5, 12,  2,  9,  8,  5, 12, 15,  3, 10,
         7, 11,  0, 14,  4,  1, 10,  7,  1,  6, 13,  0, 11,  8,  6, 13
    },
    {
         4, 13, 11,  0,  2, 11, 14,  7, 15,  4,  0,  9,  8,  1, 13, 10,
         3, 14, 12,  3,  9,  5,  7, 12,  5,  2, 10, 15,  6,  8,  1,  6,
         1,  6,  4, 11, 11, 13, 13,  8, 12,  1,  3,  4,  7, 10, 14,  7,
        10,  9, 15,  5,  6,  0,  8, 15,  0, 14,  5,  2,  9,  3,  2, 12
    },
    {
        13,  1,  2, 15,  8, 13,  4,  8,  6, 10, 15,  3, 11,  7,  1,  4,
        10, 12,  9,  5,  3,  6, 14, 11,  5,  0,  0, 14, 12,  9,  7,  2,
         7,  2, 11,  1,  4, 14,  1,  7,  9,  4, 12, 10, 14,  8,  2, 13,
         0, 15,  6, 12, 10,  9, 13,  0, 15,  3,  3,  5,  5,  6,  8, 11
    }
};

/* Lowest Level (internal help) Functions (not called from outside) */
static void transpose(char *dest, char *source, char *trans, uint32_t numBits)
{
    for (; numBits--; trans++, dest++)
     *dest = source[*trans];
}

static uint32_t sumalgo(uint32_t *block, uint32_t numLongs)
{
    uint32_t slw, shw;
    uint16_t *sptr = (uint16_t*) block;

    for (sptr += (numLongs << 1), slw = shw = 0; numLongs--; )
    {
        slw += *--sptr;
        if (slw >= 65536) shw++, slw -= 65536;
        shw += *--sptr;
    }

    shw <<= 16, shw |= slw;
    return -shw;
}

/* Lower Level (internal core) Functions (not called from outside) */
static void scramble(char *leftBlk, char *rightBlk, char *key)
{
    char tmp[KS];
    int32_t sbval;
    char *tp = tmp;
    char *ep = E;
    int32_t i, j;

    for (i = 0; i < 8; i++)
    {
        for (j = 0, sbval = 0; j < 6; j++)
         sbval = (sbval << 1) | (rightBlk[*ep++] ^ *key++);

        sbval = S_BOX[i][sbval];

        for (tp += 4, j = 4; j--; sbval >>= 1)
         *--tp = sbval & 1;

        tp += 4;
    }

    ep = PERM;
    for (i = 0; i < BS2; i++)
     *leftBlk++ ^= tmp[*ep++];
}

static int16_t cryptfile(const char *fname, const char *passw, int16_t edflag, uint32_t bsize)
{
    uint32_t form[3]; /* FORM,SIZE,CRYP */
    uint32_t fhdr[6]; /* FHDR,SIZE,BCNT,BSIZ,LSIZ,HCRC */
    uint32_t **bvp = 0, *bpl, dsize;
    FILE *fh = 0;
    uint64_t *dunit;
    int32_t tmp, pwl, cnt, rws, i, j, k, kd, kl;
    int16_t err = ERROR_NONE;

    if (bsize < 96) bsize = 96; /* minimum 8 data chunks (64 bytes) + meta data (32 bytes) */
    else if (bsize > 32752) bsize = 32752; /* maximum because of sumalgo limit */
    else bsize = (bsize + 15) & 0xfffffff0;
    dsize = bsize - 16;

    if (!(fh = fopen(fname,"rb"))) err = ERROR_NOACCESS;
    else
    {
        if ((passw == 0) || ((pwl = strlen(passw)) == 0)) err = ERROR_NOPASS;

        if (!err && !edflag)
        {
            if (fseek(fh,0,SEEK_END)) err = ERROR_FILEOP;
            else
            {
                if ((tmp = ftell(fh)) == EOF) err = ERROR_FILEOP;
                else
                {
                    cnt = tmp / dsize; if (tmp % dsize) cnt++;
                    if (fseek(fh,0,SEEK_SET)) err = ERROR_FILEOP;
                }
            }
        }
        else if (!err && edflag)
        {
            if (fread(form,1,12,fh) < 12) err = ERROR_FILEREAD;
            else
            {
                if ((form[0] == 'MROF') && (form[2] == 'PYRC')) /* flipped for little endian */
                {
                    if (fread(fhdr,1,24,fh) < 24) err = ERROR_FILEREAD;
                    else
                    {
                        if ((fhdr[0] == 'RDHF') && (fhdr[1] == 16)) /* flipped for little endian */
                        {
                            if (fhdr[5] != sumalgo(fhdr, 5)) err = ERROR_WRONGCRC;
                            else
                            {
                                cnt = fhdr[2];
                                bsize = fhdr[3];
                                dsize = bsize - 16;
                            }
                        }
                        else err = ERROR_BADCHUNK;
                    }
                }
                else err = WARN_NOTCRYPTED;
            }
        }

        if (!err)
        {
            if (!(bvp = (uint32_t**) malloc(cnt * sizeof(uint32_t*)))) err = ERROR_LOWMEM;
            else
            {
                memset(bvp,0,cnt * sizeof(uint32_t*));
                for (i = 0; (!err) && (i < cnt); i++)
                {
                    if (!(bvp[i] = (uint32_t*) malloc(bsize))) err = ERROR_LOWMEM;
                }
            }
        }

        if (!err)
        {

            rws = edflag ? bsize : dsize;
            for (i = 0; (!err) && (i < cnt); i++)
            {
                bpl = bvp[i]; if (!edflag) bpl += 4;
                if ((tmp = fread(bpl,1,rws,fh)) < rws) err = ERROR_FILEREAD;
                if (err && (i == (cnt - 1)) && (tmp > 0)) err = ERROR_NONE;
                if (!err && !edflag)
                {
                    bpl[-4] = 'FUBF'; /* flipped for little endian */
                    bpl[-3] = ((tmp + 7) & 0xfffffff8) + 8;
                    bpl[-2] = i;
                    bpl[-1] = sumalgo(bpl, (bpl[-3] - 8) / 4);
                }
                else if (!err && edflag)
                {
                    if (bpl[0] == 'FUBF') /* flipped for little endian */
                    {
                        if (bpl[2] != i) err = ERROR_TRUNCATED;
                    }
                    else err = ERROR_BADCHUNK;
                }
            }
        }
        fclose(fh);
        fh = 0;
    }

    if (!err)
    {
        for (i = 0; (!err) && (i < cnt); i++)
        {
            bpl = bvp[i];
            if (!edflag)
            {
                k  = 0;
                kd = 8;
                kl = (pwl + 7) & 0xfffffff8;
            }
            else
            {
                k  = (pwl - 1) & 0xfffffff8;
                kd = -8;
                kl = -8;
            }
            for (; k != kl; k += kd)
            {
                setkey(makekey(&passw[k]));
                dunit = (uint64_t*) bvp[i];
                for (dunit += 2, j = (bpl[1] - 8) / 8; j--; dunit++)
                {
                    memcpy(dunit,joinbytes(encrypt(splitbytes((char*) dunit),edflag)),8);
                }
            }
            if (edflag)
            {
                if (bpl[3] != sumalgo(&bpl[4], (bpl[1] - 8) / 4)) err = ERROR_WRONGCRC;
            }
        }
    }

    if (!err)
    {
        if (!(fh = fopen(fname,"wb"))) err = ERROR_FILEWRITE;
        else
        {
            if (!edflag)
            {
                form[0] = 'MROF'; form[2] = 'PYRC'; /* flipped for little endian */
                if (fwrite(form,1,12,fh) < 12) err = ERROR_FILEWRITE;
                if (!err)
                {
                    fhdr[0] = 'RDHF'; fhdr[1] = 16; /* flipped for little endian */
                    fhdr[2] = cnt; fhdr[3] = bsize; fhdr[4] = tmp;
                    fhdr[5] = sumalgo(fhdr, 5);
                    if (fwrite(fhdr,1,24,fh) < 24) err = ERROR_FILEWRITE;
                }
            }
            rws = edflag ? dsize : bsize;
            for (i = 0; (!err) && (i < (cnt - 1)); i++)
            {
                bpl = bvp[i]; if (edflag) bpl += 4;
                if (fwrite(bpl,1,rws,fh) < rws) err = ERROR_FILEWRITE;
            }
            if (!err)
            {
                bpl = bvp[cnt - 1];
                rws = edflag ? fhdr[4] : bpl[1] + 8; if (edflag) bpl += 4;
                if (fwrite(bpl,1,rws,fh) < rws) err = ERROR_FILEWRITE;
            }
            if (!err && !edflag)
            {
                if (fseek(fh,0,SEEK_END)) err = ERROR_FILEOP;
                else
                {
                    if ((tmp = ftell(fh)) == EOF) err = ERROR_FILEOP;
                    else
                    {
                        if (fseek(fh,4,SEEK_SET)) err = ERROR_FILEOP;
                        else
                        {
                            tmp -= 8;
                            if (fwrite(&tmp,1,4,fh) < 4) err = ERROR_FILEWRITE;
                        }
                    }
                }
            }
            fclose(fh);
            fh = 0;
        }
    }

    if (bvp)
    {
        for (i = 0; (bvp[i] != 0) && (i < cnt); i++) free(bvp[i]);
        free(bvp);
    }
    if (fh) fclose(fh);

    return err;
}

/* Normal Level Functions (user API to DES-56 encryption) */
void setkey(char *key)
{
    char tmp[IS];
    uint32_t magic = 0x7efc;
    int32_t i, j, k;
    int32_t shval = 0;
    char *currKey;

    memcpy(E, E0, KS);
    transpose(tmp, key, PC1, IS);

    for (i = 0; i < 16; i++)
    {
        shval += 1 + (magic & 1);
        currKey = keyBlock[i];

        for (j = 0; j < KS; j++)
        {
            if ((k = PC2[j]) >= IS2)
            {
                if ((k += shval) >= IS)
                 k = (k - IS2) % IS2 + IS2;
            }
            else
            {
                if ((k += shval) >= IS2)
                 k %= IS2;
            }
            *currKey++ = tmp[k];
        }

        magic >>= 1;
    }
}

char *encrypt(char *block, int16_t edflag)
{
    char *key = edflag ? (char*) keyBlock + (15 * KS) : (char*) keyBlock;
    char tmp[BS];
    int32_t i;

    transpose(tmp, block, IP, BS);

    for (i = 8; i--;)
    {
        scramble(tmp, tmp + BS2, key);
        if (edflag) key -= KS;
        else        key += KS;

        scramble(tmp + BS2, tmp, key);
        if (edflag) key -= KS;
        else        key += KS;
    }

    transpose(block, tmp, EP, BS);
    return block;
}

/* Normal Level Functions (user API support for Byte <-> Bit conversion) */
char *makekey(const char *passw)
{
    static char keyChain[BS];
    char *kp;
    int32_t keyByte;
    int32_t i, j;

    memset(keyChain, 0, BS);
    for (kp = keyChain, i = 0; i < BS; i++)
    {
        if (!(keyByte = *passw++)) break;
        kp += 7;
        for (j = 0; j < 7; j++, i++)
        {
            *--kp = keyByte & 1;
            keyByte >>= 1;
        }
        kp += 8;
    }

    return keyChain;
}

char *splitbytes(char *block)
{
    static char bitChain[BS];
    char *bp;
    int32_t datByte;
    int32_t i, j;

    for (bp = bitChain, i = 0; i < 8; i++)
    {
        datByte = *block++;
        bp += 8;
        for (j = 0; j < 8; j++)
        {
            *--bp = datByte & 1;
            datByte >>= 1;
        }
        bp += 8;
    }

    return bitChain;
}

char *joinbytes(char *block)
{
    static char byteChain[8];
    char *bp;
    int32_t datByte;
    int32_t i, j;

    for (bp = block, i = 0; i < 8; i++)
    {
        for (j = datByte = 0; j < 8; j++)
        {
            datByte <<= 1;
            datByte |= *bp++;
        }
        byteChain[i] = datByte;
    }

    return byteChain;
}

/* Higher Level Functions (user API support for specific tasks) */
char *cryptpass(const char *passw, const char *salt)
{
    static char retKey[14];
    char key[BS + 2];
    char *kp;
    int32_t tmp, keyByte;
    int32_t i, j;

    setkey(makekey(passw));

    for (kp = E, i = 0; i < 2; i++)
    {
        retKey[i] = keyByte = *salt++;
        if (keyByte > 'Z') keyByte -= 'a' - 'Z' - 1;
        if (keyByte > '9') keyByte -= 'A' - '9' - 1;
        keyByte -= '.';

        for (j = 0; j < 6; j++, keyByte >>= 1, kp++)
        {
            if (!(keyByte & 1)) continue;

            tmp = *kp;
            *kp = kp[24];
            kp[24] = tmp;
        }
    }

    memset(key, 0, BS + 2);
    for (i = 0; i < 25; i++)
     encrypt(key, 0);

    for (kp = key, i = 0; i < 11; i++)
    {
        for (j = keyByte = 0; j < 6; j++)
        {
            keyByte <<= 1;
            keyByte |= *kp++;
        }

        keyByte += '.';
        if (keyByte > '9') keyByte += 'A' - '9' - 1;
        if (keyByte > 'Z') keyByte += 'a' - 'Z' - 1;
        retKey[i + 2] = keyByte;
    }
    retKey[i + 2] = 0;

    if (!retKey[1])
     retKey[1] = *retKey;

    return retKey;
}

int16_t encryptfile(const char *fname, const char *passw)
{
    return cryptfile(fname,passw,0,FBUF_SIZE);
}

int16_t decryptfile(const char *fname, const char *passw)
{
    return cryptfile(fname,passw,1,0);
}

} // namespace

#endif /* RSQB_DES56_H */

