cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
	function aexp(tauu,omegam,omegav)
c  Evaluate a(tau) for Friedmann-Lemaitre-Robertson-Walker (FLRW) cosmology.
c  (Use tauu here to avoid conflict with function tau.)
c  Omegam := Omega today (a=1) in matter.
c  Omegav := Omega today (a=1) in vacuum energy.
c  dtau := H0*dt/a^2.
	real aexp,tauu,omegam,omegav,tau,eta
	external tau
c
c  Initial guess: matter-dominated solution.
	aexp=1.0/(1.0-tauu*(sqrt(omegam)-0.25*omegam*tauu))
c  Newton-Raphson iteration.
	niter=0
10	  niter=niter+1
	  eta=sqrt(omegam/aexp+omegav*aexp*aexp+1.0-omegam-omegav)
	  error=(tau(aexp,omegam,omegav)-tauu)*aexp*aexp*eta
	  aerr=abs(error)
	  rerr=aerr/aexp
	  aexp=aexp-error
	  if (min(aerr,rerr).gt.1.0d-6.and.niter.lt.10) go to 10
	return
	end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
	function tau(a,omegam,omegav)
c  Evaluate tau(a) (inverse of a(tau)) for FLRW cosmology.
c  Omegam := Omega today (a=1) in matter.
c  Omegav := Omega today (a=1) in vacuum energy.
c  dtau := H0*dt/a^2.
	real tau,a,omegam,omegav
	double precision om,ov,adp,rombint,dtauda
	common /omegas/ om,ov
	external dtauda
c
	om=omegam
	ov=omegav
	adp=a
	tau=rombint(dtauda,1.0d0,adp,1.0d-8)
	return
	end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
	function dtauda(a)
	implicit double precision (a-h,o-z)
	common /omegas/ omegam,omegav
c
	eta=sqrt(omegam/a+omegav*a*a+1.0d0-omegam-omegav)
	dtauda=1.0d0/(a*a*eta)
	return
	end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
	function dladt(a,omegam,omegav)
c  Evaluate dln(a)/dtau for FLRW cosmology.
c  Omegam := Omega today (a=1) in matter.
c  Omegav := Omega today (a=1) in vacuum energy.
c  dtau := H0*dt/a^2.
	real dladt,a,omegam,omegav,eta
c
	eta=sqrt(omegam/a+omegav*a*a+1.0-omegam-omegav)
	dladt=a*eta
	return
	end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
	function dplus(a,omegam,omegav)
c  Evaluate D+(a) (linear growth factor) for FLRW cosmology.
c  Omegam := Omega today (a=1) in matter.
c  Omegav := Omega today (a=1) in vacuum energy.
	real dplus,a,omegam,omegav,eta
	double precision om,ov,adp,rombint,ddplus
	common /omegas/ om,ov
	external ddplus
c
	om=omegam
	ov=omegav
	adp=a
	eta=sqrt(omegam/a+omegav*a*a+1.0-omegam-omegav)
	dplus=eta/a*rombint(ddplus,0.0d0,adp,1.0d-8)
	return
	end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
	function ddplus(a)
	implicit double precision (a-h,o-z)
	common /omegas/ omegam,omegav
c
	if (a.eq.0.0d0) then
	  ddplus=0.0d0
	  return
	end if
	eta=sqrt(omegam/a+omegav*a*a+1.0d0-omegam-omegav)
	ddplus=2.5d0/(eta*eta*eta)
	return
	end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
	function adp(dpls,omegam,omegav)
c  Inverts the function dpls=dplus(a,omegam,omegav) for a=adp.
	real adp,dpls,omegam,omegav,dplus,fomega
	external dplus,fomega
c
	if (dpls.eq.0.0) then
	  adp=0.0
	  return
	end if
c  Initial guess.
	adp=1.0e-3
c  Newton-Raphson iteration.
	niter=0
10	  niter=niter+1
	  dpls0=dplus(adp,omegam,omegav)
	  ddplda=dpls0*fomega(adp,omegam,omegav)/adp
	  error=(dpls0-dpls)/ddplda
	  adp=adp-error
	  aerr=abs(error)
	  rerr=aerr/adp
	  if (min(aerr,rerr).gt.1.0e-6.and.niter.lt.10) go to 10
	return
	end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
	function fomega(a,omegam,omegav)
c  Evaluate f := dlog[D+]/dlog[a] (logarithmic linear growth rate) for
c  lambda+matter-dominated cosmology.
c  Omega0 := Omega today (a=1) in matter only.  Omega_lambda = 1 - Omega0.
	real fomega,a,omegam,omegav,dplus,eta
	external dplus
c
	if (omegam.eq.1.0.and.omegav.eq.0.0) then
	  fomega=1.0
	  return
	end if
	omegak=1.0-omegam-omegav
	eta=sqrt(omegam/a+omegav*a*a+omegak)
	fomega=(2.5/dplus(a,omegam,omegav)-1.5*omegam/a-omegak)/(eta*eta)
	return
	end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
	function rombint(f,a,b,tol)
c  Rombint returns the integral from a to b of f(x)dx using Romberg integration.
c  The method converges provided that f(x) is continuous in (a,b).  The function
c  f must be double precision and must be declared external in the calling
c  routine.  tol indicates the desired relative accuracy in the integral.
c
	parameter (MAXITER=16,MAXJ=5)
	implicit double precision (a-h,o-z)
	dimension g(MAXJ+1)
	external f
c
	h=0.5d0*(b-a)
	gmax=h*(f(a)+f(b))
	g(1)=gmax
	nint=1
	error=1.0d20
	i=0
10	  i=i+1
	  if (i.gt.MAXITER.or.(i.gt.5.and.abs(error).lt.tol))
     2      go to 40
c  Calculate next trapezoidal rule approximation to integral.
	  g0=0.0d0
	    do 20 k=1,nint
	    g0=g0+f(a+(k+k-1)*h)
20	  continue
	  g0=0.5d0*g(1)+h*g0
	  h=0.5d0*h
	  nint=nint+nint
	  jmax=min(i,MAXJ)
	  fourj=1.0d0
	    do 30 j=1,jmax
c  Use Richardson extrapolation.
	    fourj=4.0d0*fourj
	    g1=g0+(g0-g(j))/(fourj-1.0d0)
	    g(j)=g0
	    g0=g1
30	  continue
	  if (abs(g0).gt.tol) then
	    error=1.0d0-gmax/g0
	  else
	    error=gmax
	  end if
	  gmax=g0
	  g(jmax+1)=g0
	go to 10
40	rombint=g0
	if (i.gt.MAXITER.and.abs(error).gt.tol)
     2    write(*,*) 'Rombint failed to converge; integral, error=',
     3    rombint,error
	return
	end
