function [n, t, Re] = infectmodel( ...
    d, ...
    a_nstart, ...
    b_serial, ...
    c_Rstart, ...
    d_Rend, ...
    e_dRestr, ...
    f_slope, ...
    g_assym, ...
    h_scale ...
    )

ndays = length(d);
% n=[a_nstart];
n=[1];
dt=0.001;
t=0:dt:ndays;

model = 'genlog';

if strcmp(model,'exponential')
    Re = genexp(t, c_Rstart, d_Rend, f_slope, a_nstart);
else strcmp(model,'genlog')
    Re = genlog(t, c_Rstart, d_Rend, f_slope, e_dRestr, g_assym);
end
%Re = (-sigmoid(t,e_dRestr,f_slope)+1)*(c_Rstart-d_Rend)+d_Rend;

% plot(Re); hold on
% plot(Re2); hold off

for it=1:length(t)-1
    k = log(Re(it))/b_serial;
    dn = k*(n(it)+0.5*dt)*dt;
    n(it+1)=n(it)+dn;
    it = it+1;
end

n = h_scale*interp1(t,n,d);
Re = interp1(t,Re,d);
t=d;

% mask = find(t-floor(t)==0);
% n=n(mask);
% t=t(mask);
% Re=Re(mask);

end

function y = genexp(x,A,K,B,start)
    y = K + (A-K)*exp(-B*(x-start));
    y(x<=start) = A;
end

function y = genlog1(x,A,K,B,M,v)
    y = A + (K-A)./((1 + exp(-B.*(x-M))).^(1/v));
end

function y = genlog(x,A,K,B,M,v)
    M=max(x)-M;
    x=fliplr(x);
    y = A + (K-A)./((1 + exp(-B.*(x-M))).^(1/v));
%     nShift = length(find(x<start))
%     y = circshift(y,nShift);
%     y(x<start) = A;
end



