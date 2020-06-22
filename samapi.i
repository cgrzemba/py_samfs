/************************************************************************
 *
 * Main File samfsapi
 * Written By: Carsten Grzemba (cgrzemba@opencsw.org)
 * Last Modified: 29-11-2013
 *
 * # CDDL HEADER START
 * #
 * # The contents of this file are subject to the terms of the
 * # Common Development and Distribution License (the "License").
 * # You may not use this file except in compliance with the License.
 * #
 * # You can obtain a copy of the license at pkg/OPENSOLARIS.LICENSE
 * # or http://www.opensolaris.org/os/licensing.
 * # See the License for the specific language governing permissions
 * # and limitations under the License.
 * #
 * # When distributing Covered Code, include this CDDL HEADER in each
 * # file and include the License file at pkg/OPENSOLARIS.LICENSE.
 * # If applicable, add the following below this CDDL HEADER, with the
 * # fields enclosed by brackets "[]" replaced with your own identifying
 * # information: Portions Copyright [yyyy] [name of copyright owner]
 * #
 * # CDDL HEADER END
 ************************************************************************/

%include <typemaps.i>
// API description for python module genration with SWIG */ 
#if defined(REMOTE)
%module samapi_rpc
#else
%module samapi
#endif
 %{
#include <string.h>
#include <errno.h>
#include "lib.h"
#include "stat.h"
/* #include "mig.h" */ 
#include "rminfo.h"
#if defined(REMOTE)
# include "samrpc.h"
#else
# include "catalog.h"
# include "devstat.h"
#endif /* defined(REMOTE) */

#include "structseq.h"

%}

#if !defined(REMOTE)
%inline %{
 
typedef struct sam_devstat sam_devstat_t; 

static PyTypeObject DevStatResultType = {0,0,0,0,0,0,0,0,0,0,0,0,0,0};
static PyStructSequence_Field DevStatResultFields[8]={
  {"type","Media type"},
  {"name","Device name"},
  {"vsn","VSN of mounted volume"},
  {"state","State - on/ro/idle/off/down"},
  {"status","Device status"},
  {"space","Space left on device"},
  {"capacity","Capacity in blocks"},
  {NULL}
};

static PyStructSequence_Desc DevStatResultDesc = {
    "devstat_result",
    NULL,
    DevStatResultFields,
    7
};

static PyTypeObject CatTblResultType = {0,0,0,0,0,0,0,0};
static PyStructSequence_Field CatTblResultFields[5]={
    { "audit_time", "Audit time" },
	{ "version", "Catalog version number" },
	{ "count", "Number of slots" },
	{ "media", "Media type, if entire catalog is one" },
    {0}
};
static PyStructSequence_Desc CatTblResultDesc = {
    "catalog_table",
    NULL,
    CatTblResultFields,
    4
};


static PyTypeObject CatEntResultType = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
static PyStructSequence_Field CatEntResultFields[12]={
   { "type", "Type of slot"},
	{ "status", "Catalog entry status" },
	{ "media", "Media type" },
	{ "vsn", "VSN" },
	{ "access", "Count of accesses" },
	{ "capacity", "Capacity of volume" },
	{ "space", "Space left on volume" },
	{ "ptoc_fwa", "First word address of PTOC" },
	{ "modification_time", "last modification time" },
	{ "mount_time", "Last mount time"},
	{ "bar_code", "Bar code (zero filled)" },
    {0}
};
static PyStructSequence_Desc CatEntResultDesc = {
    "catalog_entry",
    NULL,
    CatEntResultFields,
    11
};
%}
#endif

%inline %{ 
static PyTypeObject StatResultType = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
static PyStructSequence_Field StatResultFileds[37] = {
    {"st_mode",    "protection bits"},
    {"st_ino",     "inode"},
    {"st_dev",     "device"},
    {"st_nlink",   "number of hard links"},
    {"st_uid",     "user ID of owner"},
    {"st_gid",     "group ID of owner"},
    {"st_size",    "total size, in bytes"},
    {"st_atime",   "time of last access"},
    {"st_mtime",   "time of last modification"},
    {"st_ctime",   "time of last change"},
    {"blocks",  "number of blocks allocated"},
    {"rdev",    "device type (if inode device)"},
    {"gen",    "generation number"},
    {"attr",   "samfs attr"},
    {"flags",   "samfs flags for file"},
    {"copies",   "number of copies"},
    {"copy0_flags", "flags of copy1"}, 
    {"copy1_flags", "flags of copy2"}, 
    {"copy2_flags", "flags of copy3"}, 
    {"copy3_flags", "flags of copy4"}, 
    {"copy0_vsn", "vsn of copy1"}, 
    {"copy1_vsn", "vsn of copy2"}, 
    {"copy2_vsn", "vsn of copy3"}, 
    {"copy3_vsn", "vsn of copy4"}, 
    {"copy0_media", "media of copy1"}, 
    {"copy1_media", "media of copy2"}, 
    {"copy2_media", "media of copy3"}, 
    {"copy3_media", "media of copy4"}, 
    {"copy0_position", "position of copy1"}, 
    {"copy1_position", "position of copy2"}, 
    {"copy2_position", "position of copy3"}, 
    {"copy3_position", "position of copy4"}, 
    {"copy0_offset", "offset of copy1"}, 
    {"copy1_offset", "offset of copy2"}, 
    {"copy2_offset", "offset of copy3"}, 
    {"copy3_offset", "offset of copy4"}, 
    {0}
};

static PyStructSequence_Desc StatResultDesc = {
    "stat_result", /* name */
    NULL, /* doc */
    StatResultFileds,
    36
};

static PyTypeObject SectionResultType = {0,0,0,0,0,0,0,0};
static PyStructSequence_Field SectionResultFields[5] = {
   { "vsn","Section length of file on this volume" },
   { "length","Position of archive file for this section"},
   { "position","Location of copy section in archive file"},
   { "offset","Offset"},
   { NULL }
};

static PyStructSequence_Desc SectionResultDesc = {
    "section_result", /* name */
    NULL, /* doc */
    SectionResultFields,
    4
};

static PyTypeObject RminfoResultType = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
static PyStructSequence_Field RminfoResultFields [15] = {
       {"flags"," Access flags"},
       {"media"," Media type"},
       {"creation_time","Time file created"},
       {"position","Current position on the media"},
       {"required_size","Required size on a request"},
       {"block_size","Media block size"},
       {"file_id","Recorded file ID"},
       {"version","Version number"},
       {"owner_id","Owner identifier"},
       {"group_id","Group identifier"},
       {"info","User information"},
       {"n_vsns","Number of VSNs available"},
       {"c_vsn","Current VSN"},
//       {"sam_section section","VSNs information"}, /* is a PyStructSequence self */
  { NULL }
};

static PyStructSequence_Desc RminfoResultDesc = {
    "rminfo_result", /* name */
    NULL, /* doc */
    RminfoResultFields,
    13
};

%}

/* char *sam_mig_mount_media(char *, char *); */
#if !defined(REMOTE)
char *sam_devstr(uint_t p);
#endif
char *sam_attrtoa(int attr, char *string);

%init %{
#if defined(REMOTE)
	if (sam_initrpc(NULL) < 0) { /* get samhost from getenv("SAMHOST") */
		perror("sam_initrpc");
		exit(1);
	}
#else
    if (DevStatResultType.tp_name == 0) {
        PyStructSequence_InitType(&DevStatResultType, &DevStatResultDesc);
    }
    Py_INCREF((PyObject*) &DevStatResultType);
    PyModule_AddObject(m, "devstat_result", (PyObject*) &DevStatResultType);
#endif /* defined(REMOTE) */
    if (StatResultType.tp_name == 0) {
        PyStructSequence_InitType(&StatResultType, &StatResultDesc);
    }
    Py_INCREF((PyObject*) &StatResultType);
    PyModule_AddObject(m, "stat_result", (PyObject*) &StatResultType);

    if (SectionResultType.tp_name == 0) {
        PyStructSequence_InitType(&SectionResultType, &SectionResultDesc);
    }
    Py_INCREF((PyObject*) &SectionResultType);
    PyModule_AddObject(m, "section_result", (PyObject*) &SectionResultType);

    if (RminfoResultType.tp_name == 0) {
        PyStructSequence_InitType(&RminfoResultType, &RminfoResultDesc);
    }
    Py_INCREF((PyObject*) &RminfoResultType);
    PyModule_AddObject(m, "section_result", (PyObject*) &RminfoResultType);

    if (CatTblResultType.tp_name == 0) {
        PyStructSequence_InitType(&CatTblResultType, &CatTblResultDesc);
    }
    Py_INCREF((PyObject*) &CatTblResultType);
    PyModule_AddObject(m, "opencat_result", (PyObject*) &CatTblResultType);

    if (CatEntResultType.tp_name == 0) {
        PyStructSequence_InitType(&CatEntResultType, &CatEntResultDesc);
    }
    Py_INCREF((PyObject*) &CatEntResultType);
    PyModule_AddObject(m, "catentry_result", (PyObject*) &CatEntResultType);
%}



//To remove the return value, use an "out" typemap to override the return code handling to nothing, like this:
// %typemap(out) int ;
// declare buf as output
/* 
$result           - Result object returned to target language.
$input            - The original input object passed.
$symname          - Name of function/method being wrapped
$source		-  ???
$1		-  local variable
$target		- ???
*/

#if !defined(REMOTE)
%typemap(in,numinputs=0) ( sam_devstat_t *buf, size_t bufsize) %{
 $2 = sizeof (sam_devstat_t);
 $1 = malloc($2);
%}

%typemap(argout) (sam_devstat_t *buf, size_t bufsize) {
    Py_XDECREF($result);
    if (result < 0){
        if($2 == sizeof(sam_devstat_t))
	        free($1);
	    PyErr_SetFromErrno(PyExc_IOError);
 	    goto fail;
    }
    PyObject *v = PyStructSequence_New(&DevStatResultType);
    if (v == NULL){
        if($2 == sizeof(sam_devstat_t))
	    free($1);
        goto fail;
    }
    PyStructSequence_SET_ITEM(v, 0, PyInt_FromLong((long)$1->type));
    PyStructSequence_SET_ITEM(v, 1,
                              PyString_FromString($1->name));
    PyStructSequence_SET_ITEM(v, 2,
                              PyString_FromString($1->vsn));
    PyStructSequence_SET_ITEM(v, 3, PyInt_FromLong((long)$1->state));
    PyStructSequence_SET_ITEM(v, 4, PyInt_FromLong((long)$1->status));
    PyStructSequence_SET_ITEM(v, 5, PyInt_FromLong((long)$1->space));
    PyStructSequence_SET_ITEM(v, 6,
                              PyLong_FromLong((PY_LONG_LONG)$1->capacity));
    if($2 == sizeof(sam_devstat_t))
	free($1);
    if (PyErr_Occurred()) {
        Py_DECREF(v);
        goto fail;
    }
    $result = v;
} 
%apply  sam_devstat_t* { struct sam_devstat * };

#endif

%typemap(in,numinputs=0) (struct sam_stat *buf, size_t bufsize) %{
 $2 = sizeof (struct sam_stat);
 $1 = malloc($2);
%}

%typemap(argout) (struct sam_stat *buf, size_t bufsize) {
    Py_XDECREF($result);
    if (result < 0){
        if($2 == sizeof(struct sam_stat))
            free($1);
        PyErr_SetFromErrno(PyExc_IOError);
        goto fail;
    }
    PyObject *v = PyStructSequence_New(&StatResultType);
    if (v == NULL){
        if($2 == sizeof(struct sam_stat))
            free($1);
        goto fail;
    }

    PyStructSequence_SET_ITEM(v, 0, PyInt_FromLong((long)$1->st_mode));
    PyStructSequence_SET_ITEM(v, 1,
                              PyLong_FromLongLong((PY_LONG_LONG)$1->st_ino));
    PyStructSequence_SET_ITEM(v, 2,
                              PyLong_FromLongLong((PY_LONG_LONG)$1->st_dev));
    PyStructSequence_SET_ITEM(v, 3, PyInt_FromLong((long)$1->st_nlink));
    PyStructSequence_SET_ITEM(v, 4, PyInt_FromLong((long)$1->st_uid));
    PyStructSequence_SET_ITEM(v, 5, PyInt_FromLong((long)$1->st_gid));
    PyStructSequence_SET_ITEM(v, 6,
                              PyLong_FromLongLong((PY_LONG_LONG)$1->st_size));
    PyStructSequence_SET_ITEM(v, 7,
                              PyInt_FromLong((long)$1->st_atime));
    PyStructSequence_SET_ITEM(v, 8,
                              PyInt_FromLong((long)$1->st_mtime));
    PyStructSequence_SET_ITEM(v, 9,
                              PyInt_FromLong((long)$1->st_ctime));
    PyStructSequence_SET_ITEM(v, 10,
                              PyInt_FromLong((long)$1->st_blocks));
    PyStructSequence_SET_ITEM(v, 11,
                              PyInt_FromLong((long)$1->rdev));
    PyStructSequence_SET_ITEM(v, 12,
                              PyInt_FromLong((long)$1->gen));
    PyStructSequence_SET_ITEM(v, 13, PyInt_FromLong((long)$1->attr));
    PyStructSequence_SET_ITEM(v, 14, PyInt_FromLong((long)$1->flags));
    { int n; int copies=0;
#if MAX_ARCHIVE>4
#error struct can only hold 4 copies, update StatResultFileds
#endif
      for (n = 0; n < MAX_ARCHIVE; n++) {
        PyStructSequence_SET_ITEM(v, 16+n , PyInt_FromLong((long)$1->copy[n].flags ));
        PyStructSequence_SET_ITEM(v, 20+n , PyString_FromString($1->copy[n].vsn));
        PyStructSequence_SET_ITEM(v, 24+n , PyString_FromString($1->copy[n].media));
        PyStructSequence_SET_ITEM(v, 28+n , PyInt_FromLong((long)$1->copy[n].position ));
        PyStructSequence_SET_ITEM(v, 32+n , PyInt_FromLong((long)$1->copy[n].offset ));
        if (!($1->copy[n].flags & CF_ARCHIVED)) continue;
        copies++;
      }
      PyStructSequence_SET_ITEM(v, 15, PyInt_FromLong((long)copies));
    }
    if($2 == sizeof(struct sam_stat))
        free($1);
    if (PyErr_Occurred()) {
        Py_DECREF(v);
        goto fail;
    }
    $result = v;
}

%typemap(in,numinputs=0) ( struct sam_section *buf, size_t bufsize) %{
 $2 = sizeof (struct sam_section);
 $1 = malloc($2);
%}

%typemap(argout) (struct sam_section *buf, size_t bufsize) {
    Py_XDECREF($result);
    if (result < 0){
        if($2 == sizeof(struct sam_section))
	       free($1);
        PyErr_SetFromErrno(PyExc_IOError);
	    goto fail;
    }
    PyObject *v = PyStructSequence_New(&SectionResultType);
    if (v == NULL){
        if($2 == sizeof(struct sam_section))
	       free($1);
        goto fail;
    }
    PyStructSequence_SET_ITEM(v, 0,PyString_FromString($1->vsn));
    PyStructSequence_SET_ITEM(v, 1,PyLong_FromLongLong($1->length));
    PyStructSequence_SET_ITEM(v, 2,PyLong_FromLongLong($1->position));
    PyStructSequence_SET_ITEM(v, 3,PyLong_FromLongLong((long)$1->offset));
    if($2 == sizeof(struct sam_section))
	   free($1);
    if (PyErr_Occurred()) {
        Py_DECREF(v);
        goto fail;
    }
    $result = v;
} 



/*
%typemap(in) ( struct sam_rminfo *buf, size_t bufsize) {
    if (PyList_Check($input)) {
        $2 = sizeof (struct sam_rminfo);
        $1 = malloc($2);
        $1->sam_section = (struct sam_section*) malloc (sizeof (struct sam_section))
        
        
        int i=0;
        $1->flags = PyLong_AsUnsignedLong(PyList_GetItem($input,i++));
        strncpy($1->media, PyString_AsString(PyList_GetItem($input,i++)),4);
        $1->creation_time = PyLong_AsUnsignedLong(PyList_GetItem($input,i++));
        $1->sam_section[0]->position = $1->position = PyLong_AsUnsignedLong(PyList_GetItem($input,i++));
        $1->required_size = PyLong_AsUnsignedLong(PyList_GetItem($input,i++));
        strncpy($1->file_id, PyString_AsString(PyList_GetItem($input,i++)),32);
        $1->version = PyInt_AsLong(PyList_GetItem($input,i++));
        $1->owner_id, PyInt_AsLong(PyList_GetItem($input,i++));
        $1->group_id, PyInt_AsLong(PyList_GetItem($input,i++));
        strncpy($1->info, PyString_AsString(PyList_GetItem($input,i++)),160);
        $1->n_vsns, PyInt_AsLong(PyList_GetItem($input,i++));
        $1->c_vsns, PyInt_AsLong(PyList_GetItem($input,i++));
        strncpy($1->sam_section[0]->vsn, String_AsString(PyList_GetItem($input,i++)),32);
        
    } else {
        PyErr_SetString(PyExc_TypeError,"not a list");
        return NULL;
    }
}


%typemap(freearg) (int argc, char **argv) {
    free((char *) $1);
}


*/ 

%typemap(argout) (struct sam_rminfo *buf, size_t bufsize) {
    Py_XDECREF($result);
    if (result < 0){
        if($2 == sizeof(struct sam_rminfo))
	       free($1);
        PyErr_SetFromErrno(PyExc_IOError);
	    goto fail;
    }
    PyObject *v = PyStructSequence_New(&RminfoResultType);
    if (v == NULL){
        if($2 == sizeof(struct sam_rminfo))
	       free($1);
        goto fail;
    }
    PyStructSequence_SET_ITEM(v, 0,PyLong_FromLong((long)$1->flags));
    PyStructSequence_SET_ITEM(v, 1,PyInt_FromString($1->media,NULL,4));
    PyStructSequence_SET_ITEM(v, 2,PyLong_FromLong((long)$1->creation_time));
    PyStructSequence_SET_ITEM(v, 3,PyLong_FromLongLong((long)$1->position));
    PyStructSequence_SET_ITEM(v, 4,PyLong_FromLongLong((long)$1->required_size));
    PyStructSequence_SET_ITEM(v, 5,PyLong_FromLongLong((long)$1->block_size));
    PyStructSequence_SET_ITEM(v, 6,PyString_FromString($1->file_id));
    PyStructSequence_SET_ITEM(v, 7,PyLong_FromLong((long)$1->version));
    PyStructSequence_SET_ITEM(v, 8,PyString_FromString($1->owner_id));
    PyStructSequence_SET_ITEM(v, 9,PyString_FromString($1->group_id));
    PyStructSequence_SET_ITEM(v, 10,PyString_FromString($1->info));
    PyStructSequence_SET_ITEM(v, 11,PyLong_FromLong((long)$1->n_vsns));
    PyStructSequence_SET_ITEM(v, 12,PyLong_FromLong((long)$1->c_vsn));
    if (PyErr_Occurred()) {
        Py_DECREF(v);
        goto fail;
    }
    $result = v;
} 

%typemap(in,noblock=1,numinputs=0) (struct sam_rminfo *buf, size_t bufsize) %{
%}

%feature("pythonprepend") sam_request_mod %{
  args.__add__((args[len(args)-1],))
%}

%rename(sam_request) sam_request_mod;
%inline %{
int sam_request_mod(const char *path,  const char *media, char **vsns, int *pos, size_t len, struct sam_rminfo *buf, size_t bufsize){
    int i;
    
    bufsize=SAM_RMINFO_SIZE(len);
    buf = (struct sam_rminfo *) malloc(bufsize);
    
    buf->n_vsns = len;
    strncpy(buf->media, media, 4);
    for (i=0; i < len; i++) { 
      strncpy (buf->section[i].vsn, vsns[i], 32);
      buf->section[i].position = pos[i];
    }
    sam_request(path, buf, bufsize);
}
%}


%typemap(out) int %{
  $result = PyInt_FromLong($1);
%}

// for sam_opencat
%typemap(in,noblock=1,numinputs=0) (struct sam_cat_tbl *buf, size_t bufsize) %{
 $2 = sizeof (struct sam_cat_tbl);
 $1 = malloc($2);
%}

%typemap(argout) (struct sam_cat_tbl *buf, size_t bufsize) %{
    Py_XDECREF($result);
    if (result < 0){
        if($2 == sizeof(struct sam_cat_tbl))
	       free($1);
        PyErr_SetFromErrno(PyExc_IOError);
	    goto fail;
    }
    PyObject *v = PyStructSequence_New(&CatTblResultType);
    if (v == NULL){
        if($2 == sizeof(struct sam_cat_tbl))
	       free($1);
        goto fail;
    }
    PyStructSequence_SET_ITEM(v, 0,PyLong_FromLong((long)$1->audit_time));
    PyStructSequence_SET_ITEM(v, 1,PyLong_FromLong((long)$1->version));
    PyStructSequence_SET_ITEM(v, 2,PyLong_FromLong((long)$1->count));
    PyStructSequence_SET_ITEM(v, 3,PyString_FromString($1->media));
    if (PyErr_Occurred()) {
        Py_DECREF(v);
        goto fail;
    }
    $result = SWIG_Python_AppendOutput($result,v);
%} 
// for sam_getcatalog, dirty hack: end_slot should not consumed by typemap
%typemap(in,numinputs=1)(uint_t end_slot, struct sam_cat_ent *buf, size_t entbufsize)%{
  int val3;
  ecode2 = SWIG_AsVal_int(swig_obj[2], &val3);
  if (!SWIG_IsOK(ecode2)) {
    SWIG_exception_fail(SWIG_ArgError(ecode2), "in method '" "sam_getcatalog" "', argument " "3"" of type '" "uint_t""'");
  } 
  arg3 = (uint_t)(val3);
  if ($1 > arg2) {
     $3 = sizeof (struct sam_cat_ent);
     $2 = malloc($3 * ($1 - arg2));
  } else {
    SWIG_exception_fail(-1, "in method '" "sam_getcatalog" "', arg3 have to be bigger than arg2");
  }
%}

%typemap(argout) (struct sam_cat_ent *buf, size_t entbufsize) %{
    // Py_XDECREF($result);
    if (result < 0){
        if($2 == sizeof(struct sam_cat_ent))
	       free($1);
        PyErr_SetFromErrno(PyExc_IOError);
	    goto fail;
    }

    $result = PyList_New(result);
    for(int i = 0; i < result; i++) {

        PyObject *v = PyStructSequence_New(&CatEntResultType);
        if (v == NULL){
            if($2 == sizeof(struct sam_cat_ent))
	           free($1);
            goto fail;
        }

        struct sam_cat_ent *ep = &$1[i];
        PyStructSequence_SET_ITEM(v, 0,PyLong_FromUnsignedLong(ep->type));
        PyStructSequence_SET_ITEM(v, 1,PyLong_AsUnsignedLongLong(ep->status));
        PyStructSequence_SET_ITEM(v, 2,PyString_FromString(ep->media));
        PyStructSequence_SET_ITEM(v, 3,PyString_FromString(ep->vsn));
        PyStructSequence_SET_ITEM(v, 4,PyLong_FromLong((long)ep->access));
        PyStructSequence_SET_ITEM(v, 5,PyLong_FromUnsignedLong(ep->capacity));
        PyStructSequence_SET_ITEM(v, 6,PyLong_FromUnsignedLong(ep->space));
        PyStructSequence_SET_ITEM(v, 7,PyLong_FromLong((long)ep->ptoc_fwa));
        PyStructSequence_SET_ITEM(v, 8,PyLong_FromLong((long)ep->modification_time));
        PyStructSequence_SET_ITEM(v, 9,PyLong_FromLong((long)ep->mount_time));
        PyStructSequence_SET_ITEM(v, 10,PyString_FromString((const char*)ep->bar_code));

        if (PyErr_Occurred()) {
            Py_DECREF(v);
            goto fail;
        }
        PyList_SetItem($result,i,v);
    }
%} 


%apply int {ushort_t};
%apply int {uint_t};
// throw exception if return <> 0

%exception %{
   $action
   if (result<0) {
       PyErr_SetFromErrno(PyExc_IOError); 
       goto fail;
   }
%}

#if !defined(REMOTE)
int sam_opencat(const char *path, struct sam_cat_tbl *buf, size_t bufsize);
int sam_getcatalog(int cat_handle, uint_t start_slot, uint_t end_slot, struct sam_cat_ent *buf, size_t entbufsize);
#endif

/* the following functions return status as integer, but all should throw exception on error */

// throw exception if return <> 0
%exception %{
   $action
   if (result!=0) {
       PyErr_SetFromErrno(PyExc_IOError); 
       goto fail;
   }
%}

/* sets results in buf -> return PyObject, status int will override*/
int sam_stat(const char *path, struct sam_stat *buf, size_t bufsize);
int sam_lstat(const char *path, struct sam_stat *buf, size_t bufsize);
#if !defined(REMOTE)
int sam_devstat(ushort_t eq, sam_devstat_t *buf, size_t bufsize);
int sam_vsn_stat(const char *path, int copy, struct sam_section *buf, size_t bufsize);
int sam_readrminfo(const char *path, struct sam_rminfo *buf, size_t bufsize);
/* int sam_request(const char *path, struct sam_rminfo *buf, size_t bufsize);  */
int sam_restore_copy(const char *path, int copy, struct sam_stat *buf,
        size_t bufsize, struct sam_section *vbuf, size_t vbufsize);
int sam_segment_vsn_stat(const char *path, int copy, int segment_index,
        struct sam_section *buf, size_t bufsize);

int sam_restore_file(const char *path, struct sam_stat *buf, size_t bufsize);

#endif

/* %varargs(10,char *arg = NULL) sam_rearch; */ 
/* description here: http://www.swig.org/Doc1.3/Varargs.html */
%typemap(in) ( int num_opts , ...)(char *args[10]) {
    int i;
    int argc = PyInt_AsLong($input);
    for (i = 0; i < 10; i++) args[i] = 0;
    if (argc > 10) {
       PyErr_SetString(PyExc_ValueError,"Too many arguments");
       return NULL;
    }
    for (i = 0; i < argc; i++) {
       PyObject *o = PyTuple_GetItem(varargs,i);
       if (!PyString_Check(o)) {
           PyErr_SetString(PyExc_ValueError,"Expected a string");
           return NULL;
       }
       args[i] = PyString_AsString(o);
    }
    $2 = (void *) args;
    $1 = argc;
}
%feature("action") sam_rearch {
   char **args = args2;
   result = sam_rearch(arg1, arg2, args[0], args[1], args[2], args[3], args[4],
                   args[5],args[6],args[7],args[8],args[9], NULL);
}
%feature("action") sam_undamage {
   char **args = args2;
   result = sam_undamage(arg1, arg2, args[0], args[1], args[2], args[3], args[4],
                   args[5],args[6],args[7],args[8],args[9], NULL);
}
%feature("action") sam_exarchive {
   char **args = args2;
   result = sam_exarchive(arg1, arg2, args[0], args[1], args[2], args[3], args[4],
                   args[5],args[6],args[7],args[8],args[9], NULL);
}
%feature("action") sam_unarchive {
   char **args = args2;
   result = sam_unarchive(arg1, arg2, args[0], args[1], args[2], args[3], args[4],
                   args[5],args[6],args[7],args[8],args[9], NULL);
}
%feature("action") sam_unrearch {
   char **args = args2;
   result = sam_unrearch(arg1, arg2, args[0], args[1], args[2], args[3], args[4],
                   args[5],args[6],args[7],args[8],args[9], NULL);
}

int sam_archive(const char *path, const char *ops);
int sam_stage(const char *path, const char *ops);
int sam_release(const char *name, const char *opns);
int sam_segment(const char *name, const char *opns);
int sam_setfa(const char *name, const char *opns);
#if !defined(REMOTE)
int sam_undamage(const char *path, int num_opts, ... );
/* int sam_mig_rearchive(char *mount_point, char  **vsns, char *media); */
int sam_rearch(const char *path, int num_opts, ... );
/* int sam_mig_release_device(char *device); */
int sam_exarchive(const char *path, int num_opts, ... );
int sam_advise(const int fildes, const char *opns);
int sam_cancelstage(const char *name);
/* 
int sam_mig_stage_error(tp_stage_t *, int);
int sam_mig_create_file(char *path, struct sam_stat *buf);
*/

/*
int sam_mig_stage_write(tp_stage_t *, char *, int, offset_t);
int sam_mig_stage_file(tp_stage_t *);
int sam_mig_stage_end(tp_stage_t *stage_req, int error);
*/
int sam_unarchive(const char *name, int num_opts, ...);
int sam_damage(const char *name, int num_opts, ...);
int sam_ssum(const char *name, const char *opns);
int sam_unrearch(const char *name, int num_opts, ...);

// ignore return, already mapped to exception
// %typemap(out) int %{
// %}
int sam_closecat(int cat_handle);
#endif
