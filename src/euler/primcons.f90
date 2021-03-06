MODULE MOD_EOS
!===================================================================================================================================
! Module to convert conservative variables to primitive and vis-versa
!===================================================================================================================================
! IMPLICIT VARIABLE HANDLING
IMPLICIT NONE
PRIVATE
!-----------------------------------------------------------------------------------------------------------------------------------
! GLOBAL VARIABLES
!-----------------------------------------------------------------------------------------------------------------------------------
INTERFACE PrimCons
   MODULE PROCEDURE PrimCons
END INTERFACE
INTERFACE ConsPrim
   MODULE PROCEDURE ConsPrim
END INTERFACE
INTERFACE CharCons
   MODULE PROCEDURE CharCons
END INTERFACE
INTERFACE ConsChar
   MODULE PROCEDURE ConsChar
END INTERFACE
!-----------------------------------------------------------------------------------------------------------------------------------
PUBLIC  :: PrimCons, ConsPrim, CharCons, ConsChar
!===================================================================================================================================

CONTAINS


SUBROUTINE PrimCons(pvar, cvar)
!===================================================================================================================================
! Convert primitive variables into conservative
!===================================================================================================================================
! MODULES
USE MOD_Globals
USE MOD_Equation_Vars,ONLY:gamma1q
!-----------------------------------------------------------------------------------------------------------------------------------
! IMPLICIT VARIABLE HANDLING
IMPLICIT NONE
!-----------------------------------------------------------------------------------------------------------------------------------
! INPUT VARIABLES
REAL,INTENT(IN)             :: pvar(NVAR)
!-----------------------------------------------------------------------------------------------------------------------------------
! OUTPUT VARIABLES
REAL,INTENT(OUT)            :: cvar(NVAR)
!-----------------------------------------------------------------------------------------------------------------------------------
! LOCAL VARIABLES 
!===================================================================================================================================

! Primitive to conservative transformation
cvar(RHO) = pvar(RHO)
cvar(M1)  = pvar(V1)*pvar(RHO)
cvar(M2)  = pvar(V2)*pvar(RHO)
cvar(E)   = gamma1q*pvar(P) + 0.5*((cvar(M1)*pvar(V1)) + (cvar(M2)*pvar(V2)))
!-----------------------------------------------------------------------------------------------------------------------------------
END SUBROUTINE PrimCons



SUBROUTINE ConsPrim(pvar, cvar)
!===================================================================================================================================
! conservative to primitive variables
!===================================================================================================================================
! MODULES
USE MOD_Globals
USE MOD_Equation_Vars,ONLY:gamma1
!-----------------------------------------------------------------------------------------------------------------------------------
! IMPLICIT VARIABLE HANDLING
IMPLICIT NONE
!-----------------------------------------------------------------------------------------------------------------------------------
! INPUT VARIABLES
REAL,INTENT(IN)             :: cvar(NVAR)
!-----------------------------------------------------------------------------------------------------------------------------------
! OUTPUT VARIABLES
REAL,INTENT(OUT)            :: pvar(NVAR)
!-----------------------------------------------------------------------------------------------------------------------------------
! LOCAL VARIABLES 
!===================================================================================================================================

! Conservative to primitive transformation
pvar(RHO) = cvar(RHO)
pvar(V1)  = cvar(M1) / cvar(RHO)
pvar(V2)  = cvar(M2) / cvar(RHO)
pvar(P)   = gamma1*(cvar(E) -0.5 * (cvar(M1)*pvar(V1)+cvar(M2)*pvar(V2)))
! check if density or pressure are negative
IF (pvar(RHO) < 1.e-19) THEN
  pvar(RHO) = 1.e-10
END IF
IF (pvar(P) < 1.e-19) THEN
  pvar(P) = 1.e-10
END IF
!---------------------------------------------------------------------------!
END SUBROUTINE ConsPrim


SUBROUTINE ConsChar(charac, cvar, pvar_ref)
!===================================================================================================================================
! conservative to characteristic variables
!===================================================================================================================================
! MODULES
USE MOD_Globals
USE MOD_Equation_Vars,ONLY:gamma,gamma1q
!-----------------------------------------------------------------------------------------------------------------------------------
! IMPLICIT VARIABLE HANDLING
IMPLICIT NONE
!-----------------------------------------------------------------------------------------------------------------------------------
! INPUT VARIABLES
REAL,INTENT(IN)             :: cvar(NVAR)
REAL,INTENT(IN)             :: pvar_ref(NVAR)
!-----------------------------------------------------------------------------------------------------------------------------------
! OUTPUT VARIABLES
REAL,INTENT(OUT)            :: charac(3)
!-----------------------------------------------------------------------------------------------------------------------------------
! LOCAL VARIABLES 
REAL             :: phi, c, a1, a2, a3, u, H
REAL             :: cvar1D(3)
REAL             :: K(3,3)
!===================================================================================================================================

! auxiliary variables
c   = SQRT(gamma*pvar_ref(P) / pvar_ref(RHO))
u   = pvar_ref(V1)
H   = gamma1q*c*c + 0.5*u*u
phi = u*u - 2.*H
a1  = 1. / (2.*c*phi)
a2  = 1. / phi
a3  = u*c

cvar1D(1:2) = cvar(RHO:M1)
cvar1D(3)   = cvar(E)
! Inverse of Eigenvector Matrix
K(1,:) = (/a1*u*(phi-a3), -a1*(phi-2.*a3), -a2/)
K(2,:) = (/a2*(u*u+phi), -2.*u*a2, 2.*a2/)
K(3,:) = (/-a1*u*(a3+phi), a1*(phi+2.*a3), -a2/)
! multiplication to yield characteristic variables
charac=MATMUL(K,cvar1D)
!-----------------------------------------------------------------------------------------------------------------------------------
END SUBROUTINE ConsChar



SUBROUTINE CharCons(charac, cvar, pvar_ref)
!===================================================================================================================================
! characteristic variables to conservative
!===================================================================================================================================
! MODULES
USE MOD_Globals
USE MOD_Equation_Vars,ONLY:gamma,gamma1q
!-----------------------------------------------------------------------------------------------------------------------------------
! IMPLICIT VARIABLE HANDLING
IMPLICIT NONE
!-----------------------------------------------------------------------------------------------------------------------------------
! INPUT VARIABLES
REAL,INTENT(IN)             :: pvar_ref(NVAR)
REAL,INTENT(IN)             :: charac(3)
!-----------------------------------------------------------------------------------------------------------------------------------
! OUTPUT VARIABLES
REAL,INTENT(OUT)            :: cvar(NVAR)
!-----------------------------------------------------------------------------------------------------------------------------------
! LOCAL VARIABLES 
REAL             :: K(3, 3)
REAL             :: H, u, c
REAL             :: cvar1D(3)
!===================================================================================================================================

! Auxiliary Variables
u = pvar_ref(V1)
c = SQRT(gamma * pvar_ref(P) / pvar_ref(RHO))
H = gamma1q*c*c + 0.5*u*u
! Eigenvector Matrix
K(1,:) = (/1., 1., 1./)
K(2,:) = (/u-c, u, u+c/)
K(3,:) = (/H-u*c, 0.5*u*u, H+u*c/)
! multiplication to yield conservative variables
cvar1D = MATMUL(K, charac)
cvar(RHO:M1) = cvar1D(1:2)
cvar(E)      = cvar1D(3)
!-----------------------------------------------------------------------------------------------------------------------------------
END SUBROUTINE CharCons

END MODULE MOD_EOS
