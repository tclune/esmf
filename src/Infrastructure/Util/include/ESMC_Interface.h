// $Id: ESMC_Interface.h,v 1.1 2008/03/05 05:49:08 theurich Exp $
//
// Earth System Modeling Framework
// Copyright 2002-2007, University Corporation for Atmospheric Research, 
// Massachusetts Institute of Technology, Geophysical Fluid Dynamics 
// Laboratory, University of Michigan, National Centers for Environmental 
// Prediction, Los Alamos National Laboratory, Argonne National Laboratory, 
// NASA Goddard Space Flight Center.
// Licensed under the University of Illinois-NCSA License.
//
//-------------------------------------------------------------------------
// (all lines below between the !BOP and !EOP markers will be included in
//  the automated document processing.)
//-------------------------------------------------------------------------
// these lines prevent this file from being read more than once if it
// ends up being included multiple times

#ifndef ESMC_Interface_H
#define ESMC_Interface_H

//-----------------------------------------------------------------------------
//BOPI
//
// !DESCRIPTION:
//
// The code in this file provides a types used in the public ESMC interfaces of
// ESMF.
//
//EOPI
//-----------------------------------------------------------------------------


extern "C" {

// Class declaration type
typedef struct{
  void *ptr;
}ESMC_InterfaceInt;

// Class API
ESMC_InterfaceInt ESMC_InterfaceIntCreate(int *arrayArg, int lenArg, int *rc);
int ESMC_InterfaceIntDestroy(ESMC_InterfaceInt *interfaceIntArg);


}; // extern "C"


#endif  // ESMC_Interface_H
