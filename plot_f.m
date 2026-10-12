function yeq = plot_f(b, yrange, ax)
    P = tribble_params(b);
    if nargin < 2 || isempty(yrange), yrange = [0, P.a/P.b + 20]; end
    if nargin < 3 || isempty(ax), figure; ax = gca; end

    [yeq, stab] = find_equilibria(b, yrange);

    ys = linspace(yrange(1), yrange(2), 5000);
    plot(ax, ys, tribble_f(ys, P), 'b-', 'LineWidth', 1.5); hold(ax, 'on');
    plot(ax, yrange, [0 0], 'k-');
    for k = 1:numel(yeq)
        if strcmp(stab{k}, 'stable')
            plot(ax, yeq(k), 0, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 7);
        else
            plot(ax, yeq(k), 0, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 7);
        end
    end
    hold(ax, 'off'); grid(ax, 'on');
    xlabel(ax, 'y (hundreds of tribbles)');
    ylabel(ax, 'f(y) (hundreds of tribbles / day)');
    title(ax, sprintf('f(y), b = %g   (filled = stable, open = unstable)', b));
    xlim(ax, yrange);

    fprintf('\nb = %g : equilibria on [%g, %g]\n', b, yrange(1), yrange(2));
    for k = 1:numel(yeq)
        fprintf('   y* = %12.6f   (%s)\n', yeq(k), stab{k});
    end
end