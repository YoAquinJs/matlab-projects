function [y] = rk_2_middle(func, y0, interval, h)
    x = interval(1):h:interval(2);
    N = length(x);
    y = zeros(1,N);
    y(1) = y0;

    for i=1:N-1
        k1 = func(x(i), y(i));
        k2 = func(x(i) + 1/2*h, y(i) + 1/2*k1*h);
        y(i+1) = y(i) + k2*h;
    end
end