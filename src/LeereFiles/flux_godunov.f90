MODULE MOD_flux_godunov
!===================================================================================================================================
! Godunov flux
!-----------------------------------------------------------------------------------------------------------------------------------
! IMPLICIT VARIABLE HANDLING
IMPLICIT NONE
PRIVATE
!-----------------------------------------------------------------------------------------------------------------------------------
! GLOBAL VARIABLES
!-----------------------------------------------------------------------------------------------------------------------------------
INTERFACE flux_godunov
   MODULE PROCEDURE flux_godunov
END INTERFACE
!-----------------------------------------------------------------------------------------------------------------------------------
PUBLIC  :: flux_godunov
!===================================================================================================================================

CONTAINS

SUBROUTINE flux_godunov(rho_l, rho_r, &
                        v1_l, v1_r,   &
                        v2_l, v2_r,   &
                        p_l, p_r,     &
                        flux_side     )
!===================================================================================================================================
! Godunov flux which is exact flux
!===================================================================================================================================
! MODULES
USE MOD_Equation_Vars, ONLY : gamma
USE MOD_ExactRiemann,  ONLY : exact_riemann 
!-----------------------------------------------------------------------------------------------------------------------------------
! IMPLICIT VARIABLE HANDLING
  IMPLICIT NONE
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
REAL                        :: c_l,c_r
REAL                        :: rho, v1, p, v2
!===================================================================================================================================

! Compute speed of sound for u_l and u_r
    ! Insert your Code here

! Compute exact riemann solution at the cell interface
! input values:
!  gamma, rho_l, rho_r, v1_l, v1_r, p_l, p_r, c_l, c_r
! output values:
!  rho, v1, p
CALL exact_riemann(gamma,             &
                   rho_l,rho_r,rho,   &
                   v1_l ,v1_r ,v1 ,   &
                   p_l  ,p_r  ,p  ,   &
                   c_l  ,c_r  ,0.0    )

! Determine v2 at the cell interface
    ! Insert your Code here

! Compute intercell flux 
    ! Insert your Code here
!-----------------------------------------------------------------------------------------------------------------------------------
END SUBROUTINE flux_godunov

END MODULE MOD_flux_godunov
