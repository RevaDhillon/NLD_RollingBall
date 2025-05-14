
clc; clear; close all;

% PARAMETERS (you can tweak these)
params.alpha = 0.07;
params.beta  = 1.017;
params.gamma = 15.103;
params.delta = 0.00656;
params.H0    = 12.065;
params.g     = 9.81*100;
params.c     = 0.0025;
params.m     = 0.1;
params.A     = 0.0;         % No forcing
params.omega = 0.0;
params.phi   = 0;
params.theta = 0;

% Integration settings
opts = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);
tspan = [0 50];  % enough time to settle

% Define grid of initial positions
xvals = linspace(-10, 10, 100);
yvals = linspace(-10, 10, 100);
[X0, Y0] = meshgrid(xvals, yvals);
Z = zeros(size(X0));  % for well index

% Define well centers (from the paper)
well_centers = [
    6.555,  6.555;
   -6.555,  -6.555;
    -5.747, 5.747;
   5.747, -5.747
];
n_wells = size(well_centers, 1);

% Threshold for convergence
thresh = 1.5;  % distance to count as "in the well"

% Loop over grid
for i = 1:numel(X0)
    x0 = X0(i);
    y0 = Y0(i);
    yinit = [x0; y0; 0; 0];

    try
        [~, Y] = ode15s(@(t, y) ball_dynamics(t, y, params), tspan, yinit, opts);
        final = Y(end, 1:2);  % final position

        % Compare to wells
        dists = vecnorm(well_centers - final, 2, 2);  % Euclidean distance
        [min_dist, idx] = min(dists);

        if min_dist < thresh
            Z(i) = idx;  % Assign well ID
        else
            Z(i) = 0;    % Did not settle
        end
    catch
        Z(i) = -1;  % Integration failure
    end
end

% Plotting
figure;
imagesc(xvals, yvals, reshape(Z, size(X0)));
set(gca, 'YDir', 'normal')
colormap([0 0 0; 1 0 0; 0 1 0; 0 0 1; 1 1 0])  % 0=black, 1=red, 2=green, 3=blue, 4=yellow
colorbar
title('Basins of Attraction')
xlabel('x_0 (cm)')
ylabel('y_0 (cm)')
