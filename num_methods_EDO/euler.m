function [y] = euler(edo, y0, interval, h)
    x = interval(1):h:interval(2);
    N = length(x);
    y = zeros(1,N);
    y(1) = y0;

    for i = 1:N-1
        y(i+1) = y(i) + h * edo(x(i), y(i));
    end
end