function C = gplumeNS( x, y, z, H, Q, U)
% GPLUMENS: Compute contaminant concentration (kg/m^3)  using the standard Gaussian plume
%   solution.  This code handles a single source (located at the
%   origin).
%
% Input parameters:
%
%     x - distance along the wind direction, with
%         the source at x=0 (m) 
%     y -  cross-wind direction (m)
%     z -  vertical height (m)
%     H - source height (m)
%     Q - contaminant emission rate (kg/s)
%     U - wind velocity (m/s)
%
% Output:
%
%     C - contaminant concentration (kg/m^3)
%

% First, define the cut-off velocity, below which concentration = 0.
Umin      = 0.0;

% Determine the sigma coefficients based on stability class A,B --
sigmay =(0.320*abs(x).*(1+0.0004.*abs(x)).^(-0.5)).*(x>0);
sigmaz = (0.240*abs(x).*(1+0.001.*abs(x)).^0.5).*(x>0) ;
% Stability class C
%sigmay=(0.22*abs(x).*(1+0.0004.*abs(x)).^(-0.5)).*(x>0);
%sigmaz=0.2*abs(x);
%Stability class D
%sigmay=(0.16*abs(x).*(1+0.0004.*abs(x)).^(-0.5)).*(x>0);
%sigmaz = (0.14*abs(x).*(1+0.003.*abs(x)).^0.5).*(x>0) ;
% Stability Class E,F
%sigmay=0.11*abs(x).*(1+0.0004.*abs(x)).^(-0.5);
%sigmaz=0.08*abs(x).*(1+0.015.*x)).^(-0.5);
% Calculate the contaminant concentration (kg/m^3) using Ermak's formula.
if U < Umin,
  C = 0 * z;
else
  C  = Q ./ (2*pi*U*sigmay.*sigmaz) .* exp( -0.5*y.^2./sigmay.^2 ) .* ...
       ( exp( -0.5*(z-H).^2./sigmaz.^2 ) + exp( -0.5*(z+H).^2./sigmaz.^2 ) );
  ii = find(isnan(C) | isinf(C));
  C(ii) = 0;   % Set all NaN or inf values to zero.
end