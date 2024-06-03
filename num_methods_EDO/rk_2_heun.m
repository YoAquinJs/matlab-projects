function [y] = rk_2_heun(edo, y0, interval, h)
    x = interval(1):h:interval(2);
    N = length(x);
    y = zeros(1,N);
    y(1) = y0;

    for i=1:N-1
        k1 = edo(x(i), y(i));
        k2 = edo(x(i) + h, y(i)*h);
        y(i+1) = y(i) + h*(1/2*k1 + 1/2*k2);
    end
end