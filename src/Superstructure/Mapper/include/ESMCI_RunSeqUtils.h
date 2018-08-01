#ifndef ESMCI_RunSeqUtils_H
#define ESMCI_RunSeqUtils_H

#include <string>
#include "ESMCI_RunSeqDGraph.h"

namespace ESMCI{
  namespace MapperUtil{
    int CreateDGraphFromRSeq(const std::string &fname, RunSeqDGraph &g);
  } // namespace MapperUtil
} //namespace ESMCI

#endif // ESMCI_RunSeqUtils_H
