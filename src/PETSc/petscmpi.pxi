# --------------------------------------------------------------------

cdef extern from "mpi.h":

    MPI_Comm MPI_COMM_NULL
    MPI_Comm MPI_COMM_SELF
    MPI_Comm MPI_COMM_WORLD

    enum: MPI_IDENT
    enum: MPI_CONGRUENT
    int MPI_Comm_compare(MPI_Comm,MPI_Comm,int*)

    int MPI_Comm_size(MPI_Comm,int*)
    int MPI_Comm_rank(MPI_Comm,int*)
    int MPI_Barrier(MPI_Comm)

    int MPI_Initialized(int*)
    int MPI_Finalized(int*)


cdef extern from "petsc.h":

    MPI_Comm PETSC_COMM_SELF
    MPI_Comm PETSC_COMM_WORLD

    int PetscCommDuplicate(MPI_Comm,MPI_Comm*,int*)
    int PetscCommDestroy(MPI_Comm*)

# --------------------------------------------------------------------

cdef extern from "Python.h":
    void* PyCObject_AsVoidPtr(object) except ? NULL

ctypedef MPI_Comm* PyMPICommGet(object) except NULL

cdef inline MPI_Comm mpi4py_Comm(object comm) except *:
    from mpi4py.MPI import __pyx_capi__ as capi
    cdef object cobj = capi['PyMPIComm_Get']
    cdef PyMPICommGet *get = <PyMPICommGet*>PyCObject_AsVoidPtr(cobj)
    if get == NULL: return MPI_COMM_NULL
    cdef MPI_Comm *ptr = get(comm)
    if ptr == NULL: return MPI_COMM_NULL
    return ptr[0]


cdef inline MPI_Comm def_Comm(object comm,
                              MPI_Comm defv) except *:
    cdef MPI_Comm retv = MPI_COMM_NULL
    if comm is None:
        retv = defv
    elif isinstance(comm, Comm):
        retv = (<Comm>comm).comm
    elif type(comm).__module__ == 'mpi4py.MPI':
        retv = mpi4py_Comm(comm)
    else:
        retv = (<Comm?>comm).comm
    return retv


cdef inline Comm new_Comm(MPI_Comm comm):
    cdef Comm ob = <Comm> Comm()
    ob.comm = comm
    return ob

# --------------------------------------------------------------------

cdef inline int comm_size(MPI_Comm comm) except ? -1:
    if comm == MPI_COMM_NULL: raise ValueError("null communicator")
    cdef int size = 0
    CHKERR( MPI_Comm_size(comm, &size) )
    return size

cdef inline int comm_rank(MPI_Comm comm) except ? -1:
    if comm == MPI_COMM_NULL: raise ValueError("null communicator")
    cdef int rank = 0
    CHKERR( MPI_Comm_rank(comm, &rank) )
    return rank

# --------------------------------------------------------------------
