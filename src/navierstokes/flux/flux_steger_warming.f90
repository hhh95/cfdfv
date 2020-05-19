MODULE MOD_flux_steger_warming
!===================================================================================================================================
! Steger Warming
!===================================================================================================================================
! MODULES
IMPLICIT NONE
PRIVATE
!-----------------------------------------------------------------------------------------------------------------------------------
! GLOBAL VARIABLES
!-----------------------------------------------------------------------------------------------------------------------------------
INTERFACE flux_steger_warming
   MODULE PROCEDURE flux_steger_warming
END INTERFACE
!-----------------------------------------------------------------------------------------------------------------------------------
PUBLIC  :: flux_steger_warming
!===================================================================================================================================

CONTAINS

SUBROUTINE flux_steger_warming( rho_l, rho_r, &
                                v1_l, v1_r,   &
                                v2_l, v2_r,   &
                                p_l, p_r,     &
                                flux_side     )
!===================================================================================================================================
! Steger Warming
!===================================================================================================================================
! MODULES
USE MOD_Equation_Vars, ONLY: gamma,gamma1,gamma1q
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
REAL         :: c_l,c_r
REAL         :: ap(4), am(4), a_l(4), a_r(4)
REAL         :: fp(4), fm(4)
REAL         :: gamma2_q
!===================================================================================================================================

!-----------------------------------------------------------------------------------------------------------------------------------
! Calculation of sound speeds
c_l=SQRT(gamma*p_l/rho_l)
c_r=SQRT(gamma*p_r/rho_r)
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
! Auxiliary values
gamma2_q = 0.5/gamma
!-----------------------------------------------------------------------------------------------------------------------------------
! Calculation of eigenvalues
a_l(1) = v1_l-c_l
a_l(2) = v1_l
a_l(3) = v1_l
a_l(4) = v1_l+c_l
a_r(1) = v1_r-c_r
a_r(2) = v1_r
a_r(3) = v1_r
a_r(4) = v1_r+c_r
! Calculation of positive and negative eigenvalues
ap(:) = max(a_l(:),0.)
am(:) = min(a_r(:),0.)
! Positive flux from left to right
fp(1)=rho_l*gamma2_q*(2.*gamma1*ap(2)+ap(1)+ap(4))
fp(2)=fp(1)*v1_l+(ap(4)-ap(1))*rho_l*c_l*gamma2_q
fp(3)=fp(1)*v2_l
fp(4)=fp(1)*0.5*(v1_l*v1_l+v2_l*v2_l)+(ap(4)-ap(1))*rho_l*c_l*v1_l*gamma2_q &
     +(ap(4)+ap(1))*rho_l*c_l*c_l*gamma2_q*gamma1q
! Negative flux from right to left
fm(1)=rho_r*gamma2_q*(2.*gamma1*am(2)+am(1)+am(4))
fm(2)=fm(1)*v1_r+(am(4)-am(1))*rho_r*c_r*gamma2_q
fm(3)=fm(1)*v2_r
fm(4)=fm(1)*0.5*(v1_r*v1_r+v2_r*v2_r)+(am(4)-am(1))*rho_r*c_r*v1_r*gamma2_q &
     +(am(4)+am(1))*rho_r*c_r*c_r*gamma2_q*gamma1q
! Final flux
flux_side(:)=fp(:) + fm(:)
END SUBROUTINE flux_steger_warming

END MODULE MOD_flux_steger_warming
