function [yeq, stability] = find_equilibria(b, yrange, npts)
    P = tribble_params(b);
    if nargin < 2 || isempty(yrange), yrange = [0, P.a/P.b + 20]; end
    if nargin < 3 || isempty(npts),   npts = 200001; end

    f  = @(y) tribble_f(y, P);
    ys = linspace(yrange(1), yrange(2), npts);
    fy = f(ys);

    yeq = [];
    yeq = [yeq, ys(fy == 0)];
    idx = find(fy(1:end-1) .* fy(2:end) < 0);
    for k = idx
        yeq(end+1) = fzero(f, [ys(k), ys(k+1)]);
    end
    yeq = unique(round(yeq * 1e10) / 1e10);

    stability = cell(size(yeq));
    h = 1e-6 * max(1, abs(yrange(2)));
    for k = 1:numel(yeq)
        fl = f(yeq(k) - h);  fr = f(yeq(k) + h);
        if fl > 0 && fr < 0
            stability{k} = 'stable';
        elseif fl < 0 && fr > 0
            stability{k} = 'unstable';
        else
            stability{k} = 'semistable';
        end
    end
end
