function plot_direction_field(b, y0list, tspan, yrange, ax)
    P = tribble_params(b);
    if nargin < 3 || isempty(tspan),  tspan  = [0 30]; end
    if nargin < 4 || isempty(yrange), yrange = [0, 1.2*(P.a/P.b)]; end
    if nargin < 5 || isempty(ax)
        figure('Name', sprintf('Q7 direction field, b = %g', b), 'NumberTitle', 'off'); ax = gca;
    end

    yeq = find_equilibria(b, [0, max(yrange(2), P.a/P.b + 20)]);
    yeq_in = yeq(yeq >= yrange(1) & yeq <= yrange(2));

    if nargin < 2 || isempty(y0list)
        d = 0.05 * (yrange(2) - yrange(1));
        near = [yeq_in - d, yeq_in + d, yeq_in - d/5, yeq_in + d/5];
        extra = linspace(yrange(1), yrange(2), 6);
        y0list = unique([near, extra(2:end)]);
        y0list = y0list(y0list > yrange(1) & y0list <= yrange(2));
    end

    [T, Y] = meshgrid(linspace(tspan(1), tspan(2), 25), ...
                      linspace(yrange(1), yrange(2), 25));
    dY = tribble_f(Y, P);
    dT = ones(size(dY));
    sx = (tspan(2) - tspan(1));  sy = (yrange(2) - yrange(1));
    L  = sqrt((dT/sx).^2 + (dY/sy).^2);
    quiver(ax, T, Y, dT./L, dY./L, 0.5, 'Color', [0.6 0.6 0.6]);
    hold(ax, 'on');

    for k = 1:numel(yeq_in)
        plot(ax, tspan, [yeq_in(k) yeq_in(k)], 'r--', 'LineWidth', 1.2);
        text(ax, tspan(1) + 0.01*(tspan(2)-tspan(1)), yeq_in(k), ...
             sprintf('y* = %.4g', yeq_in(k)), 'Color', 'r', ...
             'VerticalAlignment', 'bottom');
    end

    opts = odeset('RelTol', 1e-8, 'AbsTol', 1e-10);
    for y0 = y0list
        [t, y] = ode45(@(t, y) tribble_f(y, P), tspan, y0, opts);
        plot(ax, t, y, 'b-', 'LineWidth', 1.3);
    end

    hold(ax, 'off');
    xlim(ax, tspan); ylim(ax, yrange);
    xlabel(ax, 't (days)'); ylabel(ax, 'y (hundreds)');
    title(ax, sprintf('Direction field and solutions, b = %g', b));
end