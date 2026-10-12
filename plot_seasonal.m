function plot_seasonal(b, y0list, tspan, ax, tzoom)
    P = tribble_params(b);
    if nargin < 2 || isempty(y0list)
        yeq = find_equilibria(b);
        top = max(yeq) * 1.3;
        y0list = unique([0.5, 1, 1.5, 2.5, linspace(top/4, top, 4)]);
    end
    if nargin < 3 || isempty(tspan), tspan = [0 6*365]; end
    if nargin < 4 || isempty(ax)
        figure('Name', sprintf('Q10a seasonal, b = %g', b), 'NumberTitle', 'off');
        ax = [subplot(1, 2, 1), subplot(1, 2, 2)];
    end
    if nargin < 5 || isempty(tzoom), tzoom = 60; end

    opts = odeset('RelTol', 1e-8, 'AbsTol', 1e-10, 'MaxStep', 1);
    n = numel(y0list);
    T = cell(1, n); Y = cell(1, n);
    fprintf('\nSeasonal hunting, b = %g, t in [%g, %g]\n', b, tspan(1), tspan(2));
    for k = 1:n
        [T{k}, Y{k}] = ode45(@(t, y) tribble_f_seasonal(t, y, P), tspan, y0list(k), opts);
        t = T{k}; y = Y{k};
        fprintf('   y0 = %9.4f  ->  y(%g) = %9.4f   (min over last year %8.4f, max %8.4f)\n', ...
            y0list(k), t(end), y(end), min(y(t >= t(end)-365)), max(y(t >= t(end)-365)));
    end

    cols = lines(n);
    styles = {'-', '--', ':', '-.'};
    for j = 1:numel(ax)
        a = ax(j);
        hold(a, 'on');
        for k = 1:n
            plot(a, T{k}, Y{k}, styles{mod(k-1, 4) + 1}, 'Color', cols(k,:), ...
                 'LineWidth', 1.5, 'DisplayName', sprintf('y_0 = %.3g', y0list(k)));
        end
        hold(a, 'off'); grid(a, 'on');
        xlabel(a, 't (days)'); ylabel(a, 'y (hundreds)');
        if j == 1
            xlim(a, tspan);
            yl = ylim(a); hold(a, 'on');
            for yr = 365:365:tspan(2)
                plot(a, [yr yr], yl, ':', 'Color', [0.7 0.7 0.7], 'HandleVisibility', 'off');
            end
            hold(a, 'off');
            title(a, sprintf('Seasonal hunting, b = %g (full run)', b));
        else
            xlim(a, [tspan(1), tspan(1) + tzoom]);
            title(a, sprintf('b = %g, first %g days', b, tzoom));
            legend(a, 'Location', 'eastoutside');
        end
    end
    if numel(ax) == 1
        legend(ax(1), 'Location', 'eastoutside');
    end
end