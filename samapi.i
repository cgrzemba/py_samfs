/************************************************************************
 *
 * Main File check_samfs
 * Written By: Carsten Grzemba (cgrzemba@opencsw.org)
 * Last Modified: 07-06-2012
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

// API description for python module genration with SWIG */ 
%module samapi
 %{
#include <string.h>
#include <errno.h>
#include "lib.h"
#include "stat.h"
/* #include "mig.h" */
#include "rminfo.h"
#include "catalog.h"
#include "devstat.h"

#include "structseq.h"

%}

%inline %{ typedef struct sam_devstat sam_devstat_t; %}

%inline %{
static PyTypeObject DevStatResultType = {0,0,0,0,0,0,0,0,0,0,0,0,0,0};
static PyStructSequence_Field DevStatResultFileds[8]={
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
    DevStatResultFileds,
    7
};
/* needed by sammig
typedef void shm_ptr_tbl_t; 
shm_ptr_tbl_t  *shm_ptr_tbl;
*/

static PyTypeObject StatResultType = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
static PyStructSequence_Field StatResultFileds[25] = {
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
    {0}
};

static PyStructSequence_Desc StatResultDesc = {
    "stat_result", /* name */
    NULL, /* doc */
    StatResultFileds,
    24
};

static PyTypeObject SectionResultType = {0,0,0,0,0,0,0,0};
static PyStructSequence_Field SectionResultFields[] = {
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
static PyStructSequence_Field RminfoResultFields [] = {
       {"flags"," Access flags"},
       {"media"," Media type"},
       {"creation_time","Time file created"},
       {"position","Current position on the media"},
       {"required_size","Required size on a request"},
       {"block_size","Media block size"},
       {"file_id","Recorded file name"},
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
char *sam_devstr(uint_t p);
char *sam_attrtoa(int attr, char *string);

%init %{
    if (DevStatResultType.tp_name == 0) {
        PyStructSequence_InitType(&DevStatResultType, &DevStatResultDesc);
    }
    Py_INCREF((PyObject*) &DevStatResultType);
    PyModule_AddObject(m, "devstat_result", (PyObject*) &DevStatResultType);
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

%typemap(in,numinputs=0) ( struct sam_rminfo *buf, size_t bufsize) %{
 $2 = sizeof (struct sam_rminfo);
 $1 = malloc($2);
%}

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
    if($2 == sizeof(struct sam_section))
	   free($1);
    if (PyErr_Occurred()) {
        Py_DECREF(v);
        goto fail;
    }
    $result = v;
} 

%typemap(out) int %{
  $result = PyInt_FromLong($1);
%}
 
%apply int {ushort_t};

// throw exception if return <> 0
%exception %{
   $action
   if (result!=0) {
       PyErr_SetFromErrno(PyExc_IOError); 
       goto fail;
   }
%}

/* sets results in buf -> return PyObject, status int will override*/
int sam_devstat(ushort_t eq, sam_devstat_t *buf, size_t bufsize);
int sam_vsn_stat(const char *path, int copy, struct sam_section *buf, size_t bufsize);
int sam_readrminfo(const char *path, struct sam_rminfo *buf, size_t bufsize);
int sam_request(const char *path, struct sam_rminfo *buf, size_t bufsize);
int sam_stat(const char *path, struct sam_stat *buf, size_t bufsize);
int sam_lstat(const char *path, struct sam_stat *buf, size_t bufsize);
int sam_segment_stat(const char *path, struct sam_stat *buf, size_t bufsize);
int sam_segment_lstat(const char *path, struct sam_stat *buf, size_t bufsize);
int sam_getcatalog(int cat_handle, uint_t start_slot, uint_t end_slot,
                struct sam_cat_ent *buf, size_t entbufsize);
int sam_restore_copy(const char *path, int copy, struct sam_stat *buf,
        size_t bufsize, struct sam_section *vbuf, size_t vbufsize);
int sam_segment_vsn_stat(const char *path, int copy, int segment_index,
        struct sam_section *buf, size_t bufsize);

int sam_restore_file(const char *path, struct sam_stat *buf, size_t bufsize);
int sam_opencat(const char *path, struct sam_cat_tbl *buf, size_t bufsize);

/* the following functions return status as integer, but all should throw exception on error */


/* %varargs(7,int numopts = 0) sam_rearch; */ 
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


int sam_undamage(const char *path, int num_opts, ... );
int sam_archive(const char *path, const char *ops);
/* int sam_mig_rearchive(char *mount_point, char  **vsns, char *media); */
int sam_stage(const char *path, const char *ops);
int sam_rearch(const char *path, int num_opts, ... );
/* int sam_mig_release_device(char *device); */
int sam_exarchive(const char *path, int num_opts, ... );
int sam_advise(const int fildes, const char *opns);
int sam_cancelstage(const char *name);
/* 
int sam_mig_stage_error(tp_stage_t *, int);
int sam_mig_create_file(char *path, struct sam_stat *buf);
*/
int sam_closecat(int cat_handle);
/*
int sam_mig_stage_write(tp_stage_t *, char *, int, offset_t);
int sam_mig_stage_file(tp_stage_t *);
int sam_mig_stage_end(tp_stage_t *stage_req, int error);
*/
int sam_unarchive(const char *name, int num_opts, ...);
int sam_release(const char *name, const char *opns);
int sam_damage(const char *name, int num_opts, ...);
int sam_ssum(const char *name, const char *opns);
int sam_segment(const char *name, const char *opns);
int sam_unrearch(const char *name, int num_opts, ...);
int sam_setfa(const char *name, const char *opns);
