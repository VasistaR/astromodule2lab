function dydt = tribble_f(y, P)
    dydt = P.a.*y - P.b.*y.^2 - P.p.*y.^3 ./ (y.^3 + P.q);
end
