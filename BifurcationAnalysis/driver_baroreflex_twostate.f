C * * * * * * * * * * * * * * * 
C --- DRIVER FOR RADAR5 
C * * * * * * * * * * * * * * *
C       Use make command (relevant to Makefile)

        IMPLICIT REAL*8 (A-H,O-Z)

        INTEGER, PARAMETER :: DP=kind(1D0)
C --->  PARAMETERS FOR RADAR5 (FULL JACOBIAN) <---
        INTEGER, PARAMETER :: ND=2
        INTEGER, PARAMETER :: NRDENS=1
        INTEGER, PARAMETER :: NGRID=1
        INTEGER, PARAMETER :: NLAGS=1
        INTEGER, PARAMETER :: NJACL=1
        INTEGER, PARAMETER :: MXST=60000
        INTEGER, PARAMETER :: LWORK=30
        INTEGER, PARAMETER :: LIWORK=30
        INTEGER, PARAMETER :: NRPAR=60000
        REAL(kind=DP), dimension(ND) :: Y
        REAL(kind=DP), dimension(NGRID+1) :: GRID
        REAL(kind=DP), dimension(LWORK) :: WORK
        INTEGER, dimension(LIWORK) :: IWORK
        INTEGER, dimension(NRDENS+1) :: IPAST
        REAL(kind=DP), dimension(NRPAR) :: RPAR
        REAL(kind=DP), dimension(3) :: IPAR
        INTEGER, dimension(22) :: ISTAT
        REAL(kind=DP), dimension(:), allocatable :: PAR(:)
        REAL(kind=DP), dimension(:), allocatable :: INIT(:)
        REAL(kind=DP), dimension(:), allocatable :: TIME(:)
        REAL(kind=DP), dimension(:), allocatable :: PDATA(:)
        REAL(kind=DP), dimension(:), allocatable :: PTHDATA(:)
        REAL(kind=DP), dimension(:), allocatable :: PDSPL(:)
        REAL(kind=DP), dimension(:), allocatable :: PTHSPL(:)
        INTEGER :: NPAR,NINIT,NTIME,NPDATA,NPTHDATA
        REAL(kind=DP) :: Delay,dt
        EXTERNAL  FCN,PHI,ARGLAG,JFCN,JACLAG,SOLOUT

C ------ FILE TO OPEN ----------
        OPEN(9,FILE='sol.out')
        OPEN(10,FILE='cont.out')
        REWIND 9
        REWIND 10
        
        OPEN(31,file="FortranData/Pars.txt")
        READ(31,*) NPAR
        ALLOCATE(PAR(NPAR))
        READ(31,*) PAR
        CLOSE(31)

        OPEN(32,file="FortranData/Init.txt")
        READ(32,*) NINIT
        ALLOCATE(INIT(NINIT))
        READ(32,*) INIT
        CLOSE(32)

        OPEN(33,file="FortranData/Time.txt")
        READ(33,*) NTIME
        ALLOCATE(TIME(NTIME))
        READ(33,*) TIME
        CLOSE(33)

        OPEN(34,file="FortranData/dt.txt")
        READ(34,*) dt
        CLOSE(34)

        OPEN(35,file="FortranData/Pmean.txt")
        READ(35,*) NPDATA
        ALLOCATE(PDATA(NPDATA))
        READ(35,*) PDATA
        CLOSE(35)

        OPEN(36,file="FortranData/Pthdata.txt")
        READ(36,*) NPTHDATA
        ALLOCATE(PTHDATA(NPTHDATA))
        READ(36,*) PTHDATA
        CLOSE(36)

! --- ALLOCATE SPACE FOR INTERPOLANTS        
        ALLOCATE(PDSPL(NPDATA))
        ALLOCATE(PTHSPL(NPTHDATA))
        CALL spline(TIME,PDATA,NPDATA,0,0,PDSPL)
        CALL spline(TIME,PTHDATA,NPTHDATA,0,0,PTHSPL)

C --- Build Parameter Vector ----
        RPAR(1) = dt
        DO I=1,NPAR
           RPAR(I+1) = PAR(I)
        END DO
        DO I=1,NINIT
           RPAR(I+1+NPAR) = INIT(I)
        END DO
        DO I=1,NTIME
           RPAR(I+1+NPAR+NINIT) = TIME(I)
        END DO
        DO I=1,NPDATA
           RPAR(I+1+NPAR+NINIT+NTIME) = PDATA(I)
        END DO
        DO I=1,NPTHDATA
           RPAR(I+1+NPAR+NINIT+2*NTIME) = PTHDATA(I)
        END DO
        DO I=1,NPTHDATA
           RPAR(I+1+NPAR+NINIT+3*NTIME) = PDSPL(I)
        END DO
        DO I=1,NPTHDATA
           RPAR(I+1+NPAR+NINIT+4*NTIME) = PTHSPL(I)
        END DO
        
C --- Vector of lengths of each input
        IPAR(1) = NPAR
        IPAR(2) = NINIT
        IPAR(3) = NTIME
        
C --- DIMENSION OF THE SYSTEM
        N=ND
C --- COMPUTE THE JACOBIAN WITH FINITE DIFFERENCES
        IJAC=0
C --- JACOBIAN IS A FULL MATRIX
        MLJAC=N
C --- DIFFERENTIAL EQUATION IS IN EXLPICIT FORM
        IMAS=0
        MLMAS=N
C --- OUTPUT ROUTINE IS USED DURING INTEGRATION
        IOUT=1
C --- Delay
        Delay = PAR(14)
C --- Initial Conditions        
        Y = INIT        
C --- INITIAL VALUES 
        X=TIME(1)
C --- ENDPOINT OF INTEGRATION
        XEND=TIME(NTIME)
C --- REQUIRED (RELATIVE AND ABSOLUTE) TOLERANCE
        ITOL=0
        RTOL=1.D-8
        ATOL=RTOL*1.0D0
C --- INITIAL STEP SIZE
        H=1.0D-4
C --- DEFAULT VALUES FOR PARAMETERS
        DO I=1,20
           IWORK(I)=0
           WORK(I)=0.0D0
        END DO
        
C --- WORKSPACE FOR PAST 
        IWORK(12)=MXST
C --- THE FOURTH COMPONENT USES RETARDED ARGUMENTS
        IWORK(15)=NRDENS
        IPAST(1)=1
C ---  SET THE PRESCRIBED GRID-POINTS
        DO I=1,NGRID
          GRID(I)=Delay*I
        END DO
C --- WORKSPACE FOR GRID
        IWORK(13)=NGRID

C --- CALL OF THE SUBROUTINE RADAR5   
        CALL RADAR5(N,FCN,PHI,ARGLAG,X,Y,XEND,H,
     &                  RTOL,ATOL,ITOL,
     &                  JFCN,IJAC,MLJAC,MUJAC,
     &                  JACLAG,NLAGS,NJACL,
     &                  IMAS,SOLOUT,IOUT,
     &                  WORK,IWORK,RPAR,IPAR,IDID,
     &                  GRID,IPAST,DUMMY,MLMAS,MUMAS)

!C --- PRINT FINAL SOLUTION SOLUTION
        WRITE (6,*) X,Y(1),Y(2)
        WRITE(6,*)' ***** TOL=',RTOL,' ****'
        WRITE(6,*) 'SOLUTION IS TABULATED IN FILES: sol.out & cont.out'

        END PROGRAM

C----------------------------------------------------------------------
        SUBROUTINE SOLOUT (NR,XOLD,X,HSOL,Y,CONT,LRC,N,
     &                     RPAR,IPAR,IRTRN)
C ----- PRINTS THE DISCRETE OUTPUT AND THE CONTINUOUS OUTPUT
C       AT EQUIDISTANT OUTPUT-POINTS
        IMPLICIT REAL*8 (A-H,O-Z)
        INTEGER, PARAMETER :: DP=kind(1D0)
        REAL(kind=DP) :: XSTEP,XEND
        REAL(kind=DP), dimension(N) :: Y
        REAL(kind=DP), dimension(LRC) :: CONT
        REAL(kind=DP), dimension(60000) :: RPAR
        REAL(kind=DP), dimension(3) :: IPAR
        REAL(kind=DP), dimension(:), ALLOCATABLE :: TIME(:)
        EXTERNAL PHI
C       XOUT IS USED FOR THE DENSE OUTPUT
        COMMON /INTERN/XOUT

        XSTEP = RPAR(1)

        NPAR  = IPAR(1)
        NINIT = IPAR(2)
        NTIME = IPAR(3)
        
        ALLOCATE(TIME(NTIME))
        DO I=1,NTIME
           TIME(I) = RPAR(1+NPAR+NINIT+I)
        END DO

        XEND = TIME(NTIME)
        
        WRITE (9,*) X,Y(1),Y(2)

        IF (NR.EQ.1) THEN
           WRITE (10,*) X,Y(1),Y(2)
           XOUT=XSTEP
        ELSE
 10        CONTINUE
           IF (X.GE.XOUT) THEN
              WRITE (10,*) XOUT,CONTR5(1,N,XOUT,CONT,X,HSOL),
     &                           CONTR5(2,N,XOUT,CONT,X,HSOL)
              XOUT=XOUT+XSTEP
              GOTO 10
           END IF
        END IF

        IF (X .EQ. XEND) THEN
                     WRITE (10,*) XEND,CONTR5(1,N,XEND,CONT,X,HSOL),
     &                           CONTR5(2,N,XEND,CONT,X,HSOL)
        END IF
             
        
        RETURN
        END
C
        FUNCTION ARGLAG(IL,X,Y,RPAR,IPAR,PHI,PAST,IPAST,NRDS)
        IMPLICIT REAL*8 (A-H,O-Z)
        INTEGER, PARAMETER :: DP=kind(1D0)
        REAL(kind=DP), dimension(1) :: Y
        REAL(kind=DP), dimension(1) :: PAST
        INTEGER, dimension(1) :: IPAST
        REAL(kind=DP), dimension(60000) :: RPAR
        INTEGER, dimension(1) :: IPAR
        
        ARGLAG=X-RPAR(1+14)

        RETURN
        END
C----------------------------------------------------------------------
        SUBROUTINE FCN(N,X,Y,F,ARGLAG,PHI,RPAR,IPAR,
     &                  PAST,IPAST,NRDS)
        IMPLICIT REAL*8 (A-H,K,O-Z)
        INTEGER, PARAMETER :: DP=kind(1D0)
        REAL(kind=DP), PARAMETER :: PI=3.1415926536
        REAL(kind=DP), dimension(N) :: Y
        REAL(kind=DP), dimension(N) :: F
        REAL(kind=DP), dimension(1) :: PAST
        INTEGER, dimension(1) :: IPAST
        REAL(kind=DP), dimension(60000) :: RPAR
        REAL(kind=DP), dimension(:), allocatable :: PAR(:)
        REAL(kind=DP), dimension(:), allocatable :: TIME(:)
        REAL(kind=DP), dimension(:), allocatable :: PD(:)
        REAL(kind=DP), dimension(:), allocatable :: PTH(:)
        REAL(kind=DP), dimension(:), allocatable :: PDSPL(:)
        REAL(kind=DP), dimension(:), allocatable :: PTHSPL(:)
        REAL(kind=DP), dimension(3) :: IPAR
        REAL(kind=DP) :: Pc, Pthor, Resp
        REAL(kind=DP) :: Pa, ewa, ea, nb, Gpb, Gs
        REAL(kind=DP) :: Htilde
        EXTERNAL PHI,ARGLAG

        dt = RPAR(1)
        
        NPAR  = IPAR(1)
        NINIT = IPAR(2)
        NTIME = IPAR(3)
        
        ALLOCATE(PAR(NPAR))
        DO I=1,NPAR
           PAR(I) = RPAR(1+I)
        END DO
        ALLOCATE(TIME(NTIME))
        DO I=1,NTIME
           TIME(I) = RPAR(1+NPAR+NINIT+I)
        END DO
        ALLOCATE(PD(NTIME))
        DO I=1,NTIME
           PD(I) = RPAR(1+NPAR+NINIT+NTIME+I)
        END DO
        ALLOCATE(PTH(NTIME))
        DO I=1,NTIME
           PTH(I) = RPAR(1+NPAR+NINIT+2*NTIME+I)
        END DO
        ALLOCATE(PDSPL(NTIME))
        DO I=1,NTIME
           PDSPL(I) = RPAR(1+NPAR+NINIT+3*NTIME+I)
         END DO
        ALLOCATE(PTHSPL(NTIME))
        DO I=1,NTIME
           PTHSPL(I) = RPAR(1+NPAR+NINIT+4*NTIME+I)
        END DO
        
C       FIRST DELAY
        CALL LAGR5(1,X,Y,ARGLAG,PAST,ALPHA1,IPOS1,RPAR,IPAR,
     &       PHI,IPAST,NRDS)

        Y1L1=YLAGR5(1,ALPHA1,IPOS1,PHI,RPAR,IPAR,
     &       PAST,IPAST,NRDS)
        
!     --- INTERPOLATE DATA
        CALL splint(TIME,PD,PDSPL,NTIME,X,Pc,dt)
        CALL splint(TIME,PTH,PTHSPL,NTIME,X,Pthor,dt)

        A     = PAR(1)
        Ks    = PAR(2)
        taus  = PAR(3)
        tauH  = PAR(4)
        qw    = PAR(5)
        qpb   = PAR(6)
        qs    = PAR(7)
        sw    = PAR(8)
        spb   = PAR(9)
        ss    = PAR(10)
        HI    = PAR(11)
        Hpb   = PAR(12)
        Hs    = PAR(13)

        Pa  = Pc - Pthor
        ewa = 1-SQRT((1+EXP(-qw*(Pa-sw)))/(A+EXP(-qw*(Pa-sw))))

        Gpb = 1/(1 + EXP(-qpb*(ewa- spb)))
        Gs = 1/(1 + EXP(qs*(ewa - ss)))

        Htilde = HI*(1 - Hpb*Gpb + Hs*Y(1))

        F(1) = (-Y1L1 + Ks*Gs)/taus
        F(2) = (-Y(2) + Htilde)/tauH
        
        RETURN
        END
C------------------------------------------------------------------------
        SUBROUTINE JFCN(N,X,Y,DFY,LDFY,ARGLAG,PHI,RPAR,IPAR,
     &                  PAST,IPAST,NRDS)
C ----- STANDARD JACOBIAN OF THE EQUATION
        IMPLICIT REAL*8 (A-H,K,O-Z)
        INTEGER, PARAMETER :: DP=kind(1D0)
        REAL(kind=DP), dimension(N) :: Y
        REAL(kind=DP), dimension(LDFY,N) :: DFY
        REAL(kind=DP), dimension(1) :: PAST
        INTEGER, dimension(1) :: IPAST
        REAL(kind=DP), dimension(1) :: RPAR
        REAL(kind=DP), dimension(1) :: IPAR
        EXTERNAL PHI,ARGLAG

        RETURN
        END
C----------------------------------------------------------------------
        SUBROUTINE JACLAG(N,X,Y,DFYL,ARGLAG,PHI,IVE,IVC,IVL,
     &                    RPAR,IPAR,PAST,IPAST,NRDS)
C ----- JACOBIAN OF DELAY TERMS IN THE EQUATION
        IMPLICIT REAL*8 (A-H,O-Z)
        INTEGER, PARAMETER :: DP=kind(1D0)
        REAL(kind=DP), dimension(N) :: Y
        REAL(kind=DP), dimension(1) :: DFYL
        REAL(kind=DP), dimension(1) :: PAST
        INTEGER, dimension(1) :: IPAST
        REAL(kind=DP), dimension(60000) :: RPAR
        REAL(kind=DP), dimension(1) :: IPAR
        INTEGER, dimension(1) :: IVE,IVC,IVL
        EXTERNAL PHI
        
        IVL(1)=1
        IVE(1)=1
        IVC(1)=1
        DFYL(1)= -1/RPAR(1+3)

        RETURN
        END
C-----------------------------------------------------------------------
        FUNCTION PHI(I,X,RPAR,IPAR)
        IMPLICIT REAL*8 (A-H,O-Z)
        INTEGER, PARAMETER :: DP=kind(1D0)
        REAL(kind=DP), dimension(60000) :: RPAR
        REAL(kind=DP), dimension(3) :: IPAR
        REAL(kind=DP), dimension(7) :: INIT

        NPAR = IPAR(1)
        NINIT = IPAR(2)
        INIT = RPAR(1+NPAR+1:1+NPAR+NINIT)

        SELECT CASE (I)
        CASE (1)
            PHI=INIT(1)
        CASE (2) 
            PHI=INIT(2)
        END SELECT
        RETURN
        END

