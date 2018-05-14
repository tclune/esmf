#ifndef ESMCI_PolyFit_H
#define ESMCI_PolyFit_H

#include "ESMCI_Macros.h"
#include <iostream>
#include <vector>
#include <cassert>
#include <cmath>
#include <complex.h>
#include "lapacke.h"
#include "ESMCI_Poly.h"
#include "ESMCI_PolyUV.h"

namespace ESMCI{
  namespace MapperUtil{
    typedef enum{
      POLY_FIT_LS_LAPACK
    } PolyFitAlg;

    /* Use LAPACK to minimize Least square errors and fit a polynomial (of maximum
     * degree, max_deg) on a 2D user data set. The 2D user data is specified via
     * xvals (x values for the user data) and yvals (y values for the user data),
     * and the resulting fit polynomial coefficients are stored (returned via) in
     * coeffs
     */
    inline int LAPACK_2D_Solver(int max_deg, const std::vector<float>& xvals, const std::vector<float> &yvals, std::vector<float> &coeffs)
    {
      if(xvals.size() == 0) return 0;
      assert(xvals.size() == yvals.size());
      // Using LAPACK to solve minimize || Ax - B ||
      int num_obs = xvals.size();
      int NUM_ROWS_IN_A = num_obs;
      const int NUM_COLS_IN_A = max_deg + 1;
      int NUM_ROWS_IN_B = num_obs;
      const int NUM_COLS_IN_B = 1;

      lapack_int info, m, n, lda, ldb, nrhs;
      m = NUM_ROWS_IN_A;
      n = NUM_COLS_IN_A;
      lda = NUM_COLS_IN_A;
      ldb = NUM_COLS_IN_B;
      nrhs = NUM_COLS_IN_B;

      float *A = (float *)calloc(NUM_ROWS_IN_A * NUM_COLS_IN_A, sizeof(float));
      float *B = (float *)calloc(NUM_ROWS_IN_B * NUM_COLS_IN_B, sizeof(float));
      assert(A && B);

      /*
       */ 
      for(int i=0; i<num_obs; i++){
        for(int j=0; j<NUM_COLS_IN_A; j++){
          A[i * NUM_COLS_IN_A + j] = powf(xvals[i], j);
        }
        B[i] = yvals[i];
      }

      info = LAPACKE_sgels(LAPACK_ROW_MAJOR, 'N', m, n, nrhs, A, lda, B, ldb);
      /* info == 0 is success */
      if(info < 0){
        std::cout << "LAPACKE_sgels failed, the " << -info
          << "th arg in the input array, A[" << -info << "] ="
          << A[-info] << " is invalid\n";
        return ESMF_FAILURE;
      }
      else if(info > 0){
        std::cout << "LAPACKE_sgels failed, the " << info
          << "th diagonal element of the triangular factor of input array, A == 0, "
          << "so A has no full rank and LES solution cannot be computed\n";
        return ESMF_FAILURE;
      }

      coeffs.resize(max_deg + 1);
      for(int i=0; i<max_deg+1; i++)
      {
        coeffs[i] = B[max_deg - i];
      }
      return ESMF_SUCCESS;
    }

    /* Fit a polynomial of degree, max_deg, on a 2D user data set with xvalues
     * specified via xvals and y values specified via yvals. The resulting fit
     * polynomial is returned in poly
     */
    template<typename CType, typename VType>
    int PolyFit(PolyFitAlg alg, int max_deg, const std::vector<VType>& xvals, const std::vector<VType>& yvals, UVIDPoly<CType> &poly)
    {
      std::vector<CType> coeffs;
      assert(alg == POLY_FIT_LS_LAPACK);

      int ret = LAPACK_2D_Solver(max_deg, xvals, yvals, coeffs);
      assert(ret == ESMF_SUCCESS);

      poly.set_coeffs(coeffs); 
      return ESMF_SUCCESS;
    }

  } //namespace MapperUtil
} //namespace ESMCI

#endif // ESMCI_PolyFit_H