clear; close all; clc;

bvals = [0.005, 0.05, 0.10];

%%Q6
frange = {[0 170], [0 20], [0 10]};
figure('Name', 'Q6 f(y)', 'Position', [100 100 1400 400]);
for i = 1:3
    ax = subplot(1, 3, i);
    plot_f(bvals(i), frange{i}, ax);
end

%zoomed graphs
figure('Name', 'Q6 f(y) zoomed', 'Position', [100 550 1400 400]);
for i = 1:3
    ax = subplot(1, 3, i);
    plot_f(bvals(i), [0 4], ax);
end

%%Q8a
fprintf('\n===== Equilibrium classification (Q8a) =====\n');
fprintf('%8s %14s %12s\n', 'b', 'y*', 'stability');
for i = 1:3
    [yeq, stab] = find_equilibria(bvals(i), frange{i});
    for k = 1:numel(yeq)
        fprintf('%8.3f %14.6f %12s\n', bvals(i), yeq(k), stab{k});
    end
end

%%Q7
dfrange = {[0 180], [0 16], [0 3]};
dftspan = {[0 40],  [0 40], [0 20]};
figure('Name', 'Q7 direction fields', 'Position', [100 100 1400 450]);
for i = 1:3
    ax = subplot(1, 3, i);
    plot_direction_field(bvals(i), [], dftspan{i}, dfrange{i}, ax);
end

%zoomed graphs
figure('Name', 'Q7 direction fields zoomed', 'Position', [100 580 1000 450]);
ax = subplot(1, 2, 1);
plot_direction_field(0.05, [0.5 0.9 1.05 1.1 1.5 1.95 2.03 2.5 3], [0 40], [0 3.5], ax);
ax = subplot(1, 2, 2);
plot_direction_field(0.005, [0.05 0.2 0.5 1 2 4], [0 20], [0 6], ax);

%%Q10a
figure('Name', 'Q10a seasonal hunting', 'Position', [150 50 1400 900]);
for i = 1:3
    ax_full = subplot(3, 2, 2*i - 1);
    ax_zoom = subplot(3, 2, 2*i);
    plot_seasonal(bvals(i), [], [0 6*365], [ax_full ax_zoom], 60);
end