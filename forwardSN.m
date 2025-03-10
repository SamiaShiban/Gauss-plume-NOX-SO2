% FORWARD: Solve the forward atmospheric dispersion problem using the
%    **standard Gaussian plume solution**.  That is, given the source
%    emission rates for SOx, NOx (in kg/s), calculate and plot the
%    ground-level  concentrations (in mg/m^3). 

clear all
setparamsSN;   % read parameters from a file
Uwind = 3.3;   % wind speed (m/s) 
alpha=pi/4;%wind angel
% Set plotting parameters.
nx = 100;
ny = nx;
xlim = [0, 10000];
ylim = [-1000,  10000];
x0 = xlim(1) + [0:nx]/nx * (xlim(2)-xlim(1)); % distance along wind direction (m)
y0 = ylim(1) + [0:ny]/ny * (ylim(2)-ylim(1)); % cross-wind distance (m)
[xmesh, ymesh] = meshgrid( x0, y0 );          % mesh points for contour plot
smallfont = 14;

glc = 0;
warning( 'OFF', 'MATLAB:divideByZero' );
for i = 1 : source.n
  % Sum up ground-level concentrations from each source at all mesh
  % points, shifting the (x,y) coordinates so the source location is
  % at the origin.
   glc = glc + gplumeNS( (xmesh-source.x(i))*cos(alpha)+(ymesh-source.y(i))*sin(alpha),(ymesh-source.y(i))*cos(alpha)-(xmesh-source.x(i))*sin(alpha), 0.0,source.z(i), source.Q(i), Uwind ); 
end
warning( 'ON', 'MATLAB:divideByZero' );

% Plot contours of ground-level concentration.
figure(1)
clist = [ 1,5, 10, 20, 50, 100, 500 ]; 
glc2 = glc*1e9;  % convert concentration to µg/m^3
[c2, h2] = contourf( xmesh, ymesh, glc2, clist );
% axis equal     % (for plots in paper)
clabel(c2, h2, 'FontSize', smallfont-2 )
colormap(1-winter)  % These colors make the labels more readable
colorbar
set(gca, 'XLim', xlim ), set(gca, 'YLim', ylim )
xlabel('x (m)'), ylabel('y (m)')
title(['NOx concentration (µg/m^3), max = ', sprintf('%5.2f', max(glc2(:))),' µg/m^3'])
grid on

% Draw and label the source locations.
hold on
plot( source.x, source.y, 'ro', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r' )
text( source.x, source.y, source.label, 'FontSize', smallfont, 'FontWeight','bold' );
quiver(7000, 2000, 1000,1000,'linewidth', 2) 
text( 7000, 1800, 'wind= 3.3 m/s','fontsize',16 )
hold off