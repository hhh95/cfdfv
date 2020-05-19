MODULE MOD_flux_hllc
!-----------------------------------------------------------------------------------------------------------------------------------
! HLLC flux 
!-----------------------------------------------------------------------------------------------------------------------------------
! IMPLICIT VARIABLE HANDLING
IMPLICIT NONE
PRIVATE
!-----------------------------------------------------------------------------------------------------------------------------------
! GLOBAL VARIABLES
!-----------------------------------------------------------------------------------------------------------------------------------
INTERFACE flux_hllc
   MODULE PROCEDURE flux_hllc
END INTERFACE
!-----------------------------------------------------------------------------------------------------------------------------------
PUBLIC  :: flux_hllc
!===================================================================================================================================

CONTAINS

SUBROUTINE flux_hllc( rho_l, rho_r, &
                      v1_l, v1_r,   &
                      v2_l, v2_r,   &
                      p_l, p_r,     &
                      flux_side     )
!===================================================================================================================================
! Computation of the HLLC flux
!===================================================================================================================================
! MODULES
USE MOD_Globals
USE MOD_Equation_Vars, ONLY: gamma,gamma1,gamma1q
!-----------------------------------------------------------------------------------------------------------------------------------
! INPUT VARIABLES
REAL,INTENT(IN)             :: rho_l, rho_r
REAL,INTENT(IN)             :: v1_l , v1_r
REAL,INTENT(IN)             :: v2_l , v2_r
REAL,INTENT(IN)             :: p_l  , p_r
!-----------------------------------------------------------------------------------------------------------------------------------
! OUTPUT VARIABLES
REAL,INTENT(OUT)            :: flux_side(4)
!-----------------------------------------------------------------------------------------------------------------------------------
! LOCAL VARIABLES 
REAL                        :: e_l, e_r
REAL                        :: fl(4),fr(4),ul(4),ur(4),us(4)
REAL                        :: c_l,c_r,H_l,H_r
REAL                        :: um, vm, Hm, cm
REAL                        :: arp, alm, as
REAL                        :: sqrt_rho_r, sqrt_rho_l, sum_sqrt_rho_q
REAL                        :: rho_lq, rho_rq, factor
!===================================================================================================================================

   ! Insert your Code here
   
!-----------------------------------------------------------------------------------------------------------------------------------
END SUBROUTINE flux_hllc

END MODULE MOD_flux_hllc
