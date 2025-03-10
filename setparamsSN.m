% setparamsSN: Set up various physical parameters for the atmospheric dispersion problem.

% Stack emission source data:
source.n = 2;  % # of sources; 
source.x = [120, 3830]; % x-location respecting a virtual origin(m)
source.y = [ 250, 4900];% y-location respecting the virtual origin (m)
source.z = [ 200,  185];     % height (m)
source.label=[' S1'; ' S2'];%S1:Power plant and S2:Oil refinery.
Em=4.2; % Emission factor:4.2 kg NOx/tonFuel; 38 kg SOx/tonFuel
d2s = 1.0 / 86400;    % conversion factor (1/d to 1/s)
CF=[1780,1500]; % Consumed Fuel ton/d
source.Q = [CF*Em, CF*Em] * d2s; % emission rate (kg/s)
