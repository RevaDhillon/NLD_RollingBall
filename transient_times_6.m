
clc; clear; close all;

% PARAMETERS (same as before)
params.alpha = 0.07;
params.beta  = 1.017;
params.gamma = 15.103;
params.delta = 0.00656;
params.H0    = 12.065;
params.g     = 981;
params.c     = 0.0025;
params.m     = 0.1;
params.A     = 0.0;         % No forcing
params.omega = 0.0;
params.phi   = 0;
params.theta = 0;

% Integration settings
opts = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);
tspan = [0 30];

% Initial condition grid
xvals = linspace(-10, 10, 50);
yvals = linspace(-10, 10, 50);
[X0, Y0] = meshgrid(xvals, yvals);
T_settle = nan(size(X0));  % to store settling time

% Velocity threshold to consider "settled"
vel_thresh = 0.75;  % in m/s
settle_hold_time = 0.5;  % how long it must stay settled

% Loop over grid
for i = 1:numel(X0)
    x0 = X0(i);
    y0 = Y0(i);
    yinit = [x0; y0; 0; 0];

    try
        [t, Y] = ode15s(@(t, y) ball_dynamics(t, y, params), tspan, yinit, opts);

        vmag = vecnorm(Y(:,3:4), 2, 2);  % magnitude of velocity
        settled = vmag < vel_thresh;

        % Find when it remains settled for "settle_hold_time"
        for j = 1:length(settled)
            if all(settled(j:end)) && (t(end) - t(j)) >= settle_hold_time
                T_settle(i) = t(j);
                break
            end
        end

        if isnan(T_settle(i))
            T_settle(i) = t(end);  % never fully settled
        end
    catch
        T_settle(i) = NaN;  % Integration failed
    end
end

% Step 1: Define your bins (in seconds)
bin_edges = [0, 7, 16, 21];
n_bins = length(bin_edges) - 1;

% Step 2: Bin the transient times
T_clean = reshape(T_settle, size(X0));
T_binned = zeros(size(T_clean));

for b = 1:n_bins
    in_bin = T_clean >= bin_edges(b) & T_clean < bin_edges(b+1);
    T_binned(in_bin) = b;
end

% Handle NaNs or unsettled points
T_binned(isnan(T_clean)) = 0;  % use 0 for unsettle/fail

% Step 3: Create colormap (discrete colors)
colors = [
    0 0 0;         % 0 = black (did not settle or failed)
    0.2 0.6 1;     % 1 = 0–5 s  (light blue)
    0 0.8 0;       % 2 = 5–10 s (green)
    1 1 0;         % 3 = 10–15 s (yellow)
    % 1 0.5 0;       % 4 = 15–20 s (orange)
    % 1 0 0;         % 5 = 20–25 s (red)
    % 0.5 0 0.5      % 6 = 25–30 s (purple)
];

% Step 4: Plot with discrete colors
figure;
imagesc(xvals, yvals, T_binned);
set(gca, 'YDir', 'normal')
colormap(colors)
colorbar('Ticks', 0:n_bins, ...
         'TickLabels', {'Unsettled', '0–7s', '7–16s', '16–21s'})
title('Transient Duration (Binned)')
xlabel('x_0 (cm)')
ylabel('y_0 (cm)')
axis equal tight

% % Plotting the transient time
% figure;
% imagesc(xvals, yvals, reshape(T_settle, size(X0)));
% set(gca, 'YDir', 'normal')
% colormap(parula)
% colorbar
% title('Transient Duration to Settle (s)')
% xlabel('x_0 (cm)')
% ylabel('y_0 (cm)')
