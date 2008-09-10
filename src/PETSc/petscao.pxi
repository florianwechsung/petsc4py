cdef extern from "petscao.h":

    ctypedef enum PetscAOType "AOType":
        AO_BASIC
        AO_MAPPING

    int AOView(PetscAO,PetscViewer)
    int AODestroy(PetscAO)
    int AOCreateBasic(MPI_Comm,PetscInt,const_PetscInt[],const_PetscInt[],PetscAO*)
    int AOCreateBasicIS(PetscIS,PetscIS,PetscAO*)
    int AOCreateMapping(MPI_Comm,PetscInt,const_PetscInt[],const_PetscInt[],PetscAO*)
    int AOCreateMappingIS(PetscIS,PetscIS,PetscAO*)
    int AOGetType(PetscAO,PetscAOType*)

    int AOApplicationToPetsc(PetscAO,PetscInt,PetscInt[])
    int AOApplicationToPetscIS(PetscAO,PetscIS)
    int AOPetscToApplication(PetscAO,PetscInt,PetscInt[])
    int AOPetscToApplicationIS(PetscAO,PetscIS)