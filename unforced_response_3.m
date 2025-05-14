clc; clear; close all;

% Parameters
params.alpha = 0.07;
params.beta  = 1.017;
params.gamma = 15.103;
params.delta = 0.00656;
params.H0    = 12.065;
params.g     = 9.81*100;
params.m     = 0.1;        % mass in kg
params.c     = 0.0025;     % damping coefficient
params.A     = 0*1.2;        % amplitude of forcing (cm or m)
params.omega = 0*2*pi*1.25;  % frequency in rad/s
params.phi   = 0;          % phase
params.theta = deg2rad(30);  % angle of forcing direction

% Initial conditions: [x0, y0, dx0, dy0]
y0 = [-6.75; 8.0; 0; 0];

% Time span
tspan = [0 10];

% Solve with ode45
[t, Y] = ode45(@(t, y) ball_dynamics(t, y, params), tspan, y0);
% Select time series data from simulation
x = Y(:,1);  % or Y(:,2) for y-coordinate
y = Y(:,2);

% Plot trajectory
figure(31);
plot(Y(:,1), Y(:,2), 'b')
axis equal         % set equal scaling
axis manual        % freeze limits
xlim([-15, 15])    % set limits after axis commands
ylim([-15, 15])
xlabel('x (cm)')
ylabel('y (cm)')
title('Ball Trajectory on the Surface')
grid on


%% %%%%%%%%%%%%%%%%%%%%

% Time lag settings
lag_time = 0.25;                        % seconds (e.g. 1/4 of oscillation period)
dt = mean(diff(t));                     % time step
tau = round(lag_time / dt);             % delay in samples

% Ensure we don’t exceed length
N = length(x);
x1 = x(1:N - tau);
x2 = x(1 + tau:N);

% Plot time-lag embedding
figure(32);
plot(x1, x2, 'b')
% axis equal         % set equal scaling
% axis manual        % freeze limits
% xlim([-8, -3.5])
% ylim([-8, -3.5])
xlabel('x(t)')
ylabel(['x(t + ', num2str(lag_time), ' s)'])
title('Time-Lag Embedding Plot')
axis equal
grid on
