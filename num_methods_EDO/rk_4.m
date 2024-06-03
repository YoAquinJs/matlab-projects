function [y] = rk_4(func, y0, interval, h)
    x = interval(1):h:interval(2);
    N = length(x);
    y = zeros(1,N);
    y(1) = y0;

    for i=1:N-1
        k1 = func(x(i), y(i));
        k2 = func(x(i) + h/2, y(i) + k1*h/2);
        k3 = func(x(i) + h/2, y(i) + k2*h/2);
        k4 = func(x(i) + h, y(i) + k3*h);
        y(i+1) = y(i) + (k1 + 2*k2 + 2*k3 + k4)*h/6;
    end
end
