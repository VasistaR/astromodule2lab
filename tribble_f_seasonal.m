function dydt = tribble_f_seasonal(t, y, P)
    dydt = P.a.*y - P.b.*y.^2 - P.p.*y.^3 ./ (P.q + y.^3) .* abs(sin(pi*t/365));
end
