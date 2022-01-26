function y = piecewiseNormal(x,h,mu,s1,s2)

y = zeros(size(x));

for i = 1:length(x)
    if x(i) < mu
        y(i) = h*exp(-((x(i)-mu)/s1).^2);
    else
        y(i) = h*exp(-((x(i)-mu)/s2).^2);
    end
end

end