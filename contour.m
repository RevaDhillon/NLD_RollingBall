clc; clear; close all;

% Parameters from the paper
alpha = 0.07;
beta = 1.017;
gamma = 15.103;
delta = 0.00656;
H0 = 12.065;

% Create meshgrid for x and y
[x, y] = meshgrid(linspace(-15, 15, 300), linspace(-15, 15, 300));

% Compute H(x, y) with the correct equation
H = alpha * (x.^2 + y.^2) ...
    - beta * (sqrt(x.^2 + gamma) + sqrt(y.^2 + gamma)) ...
    - delta * x .* y + H0;

% Plot 3D surface
figure('Position', [100, 100, 1200, 500])
subplot(1, 2, 1)
surf(x, y, H, 'EdgeColor', 'none')
title('3D Surface of H(x, y)')
xlabel('x (cm)')
ylabel('y (cm)')
zlabel('H(x, y)')
colormap('jet')
view(45, 30)
colorbar

% Plot contour
subplot(1, 2, 2)
contourf(x, y, H, 35)
title('Contour Plot of H(x, y)')
xlabel('x (cm)')
ylabel('y (cm)')
axis equal
colormap('jet')
colorbar
