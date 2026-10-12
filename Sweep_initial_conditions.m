function results = Sweep_initial_conditions(b, y0list, T, seasonal)
    if nargin < 3 || isempty(T), T = 200; end
    if nargin < 4, seasonal = false; end
    P = tribble_params(b);
    opts = odeset('RelTol', 1e-8, 'AbsTol', 1e-10);
    if seasonal, opts = odeset(opts, 'MaxStep', 1); end

    yT = zeros(size(y0list)); ymin = yT; ymax = yT;
    for k = 1:numel(y0list)
        if seasonal
            [t, y] = ode45(@(t, y) tribble_f_seasonal(t, y, P), [0 T], y0list(k), opts);
            last = t >= T - 365;
        else
            [t, y] = ode45(@(t, y) tribble_f(y, P), [0 T], y0list(k), opts);
            last = t >= 0.9*T;
        end
        yT(k) = y(end); ymin(k) = min(y(last)); ymax(k) = max(y(last));
    end
    results = table(y0list(:), yT(:), ymin(:), ymax(:), ...
        'VariableNames', {'y0', 'yT', 'min_late', 'max_late'});

    figure;
    plot(y0list, yT, 'o-', 'LineWidth', 1.2); grid on;
    xlabel('initial population y_0 (hundreds)');
    ylabel(sprintf('y(%g) (hundreds)', T));
    if seasonal, s = 'seasonal'; else, s = 'constant'; end
    title(sprintf('Final population vs y_0, b = %g (%s hunting)', b, s));
end