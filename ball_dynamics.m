function dydt = ball_dynamics(t, y, params)
    % Unpack state variables
    x  = y(1);
    y_ = y(2);  % y is overloaded, avoid conflict
    dx = y(3);
    dy = y(4);

    % Unpack parameters
    alpha = params.alpha;
    beta  = params.beta;
    gamma = params.gamma;
    delta = params.delta;
    H0    = params.H0;
    g     = params.g;
    c     = params.c;
    m     = params.m;
    A     = params.A;
    w     = params.omega;
    phi   = params.phi;
    theta = params.theta;

    eps = 1e-8;

    % First partial derivatives of H(x, y)
    Hx  = 2*alpha*x - beta * x / sqrt(x^2 + gamma+eps) - delta * y_;
    Hy  = 2*alpha*y_ - beta * y_ / sqrt(y_^2 + gamma+eps) - delta * x;

    % Second partial derivatives
    Hxx = 2*alpha - beta * gamma / (x^2 + gamma+eps)^(3/2);
    Hyy = 2*alpha - beta * gamma / (y_^2 + gamma+eps)^(3/2);
    Hxy = -delta;

    % Base excitation accelerations
    ddx_base = A * w^2 * sin(w * t + phi) * cos(theta);
    ddy_base = A * w^2 * sin(w * t + phi) * sin(theta);

    % Inertia matrix M
    M = (7/5) * [
        (1 + Hx^2), Hx*Hy;
        Hx*Hy, (1 + Hy^2)
    ];

    % Nonlinear velocity terms (with correct -7/5 factor)
    nonlin_x = -(7/5) * (Hxx * (Hx * dx^2 + Hy * dx * dy) + Hxy * (Hx * dx * dy + Hy * dy^2));
    nonlin_y = -(7/5) * (Hyy * (Hy * dy^2 + Hx * dx * dy) + Hxy * (Hy * dx * dy + Hx * dx^2));

    % Damping terms
    damp_x = (c/m) * ((1 + Hx^2) * dx + Hx * Hy * dy);
    damp_y = (c/m) * ((1 + Hy^2) * dy + Hx * Hy * dx);

    % Force vector F
    F = [
        -nonlin_x - damp_x - Hx * g - ddx_base;
        -nonlin_y - damp_y - Hy * g - ddy_base
    ];

    % Solve for accelerations
    acc = M \ F;

    % Return state derivatives
    dydt = [dx; dy; acc(1); acc(2)];
end

