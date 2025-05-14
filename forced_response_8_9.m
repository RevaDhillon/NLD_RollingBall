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
params.A     = 1.16;        % amplitude of forcing (cm or m)
params.omega = 2*pi*1.25;  % frequency in rad/s
params.phi   = 0;          % phase
params.theta = deg2rad(30);  % angle of forcing direction

% Initial conditions: [x0, y0, dx0, dy0]
eps = 10e-10;
y01 = [-6.55+eps; -6.55+eps; 0; 0];
y02 = [-6.55+eps; -6.55-eps; 0; 0];
y03 = [-6.55-eps; -6.55+eps; 0; 0];
y04 = [-6.55-eps; -6.55-eps; 0; 0];
y05 = [-6.55; -6.55; 0; 0];

% Time span
tspan = [0 50];

% Solve with ode45
opts = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);
[t1, Y1] = ode45(@(t, y) ball_dynamics(t, y, params), tspan, y01, opts);
[t2, Y2] = ode45(@(t, y) ball_dynamics(t, y, params), tspan, y02, opts);
[t3, Y3] = ode45(@(t, y) ball_dynamics(t, y, params), tspan, y03, opts);
[t4, Y4] = ode45(@(t, y) ball_dynamics(t, y, params), tspan, y04, opts);
[t5, Y5] = ode45(@(t, y) ball_dynamics(t, y, params), tspan, y05, opts);


% x vs t
figure(31);

subplot(5, 1, 1)
plot(t1, Y1(:,1), 'r', 'DisplayName', 'x(t)');

subplot(5, 1, 2)
plot(t2, Y2(:,1), 'r', 'DisplayName', 'x(t)');

subplot(5, 1, 3)
plot(t3, Y3(:,1), 'r', 'DisplayName', 'x(t)');

subplot(5, 1, 4)
plot(t4, Y4(:,1), 'r', 'DisplayName', 'x(t)'); 

subplot(5, 1, 5)
plot(t5, Y5(:,1), 'r', 'DisplayName', 'x(t)'); 

han = axes(gcf, 'visible', 'off');
han.XLabel.Visible = 'on';
han.YLabel.Visible = 'on';
xlabel(han, 'Time (s)', 'FontWeight', 'bold');
ylabel(han, 'Displacement (cm)', 'FontWeight', 'bold');

sgtitle('Displacement (x) vs Time for 5 Initial Conditions');

% Plot trajectory
figure(32);
plot(Y1(:,1), Y1(:, 2), 'b')
hold on
plot(Y2(:,1), Y2(:, 2), 'r')
axis equal         % set equal scaling
axis manual        % freeze limits
xlim([-15, 15])    % set limits after axis commands
ylim([-15, 15])
xlabel('x (cm)')
ylabel('y (cm)')
legend()
title('Ball Trajectory on the Surface')
grid on
