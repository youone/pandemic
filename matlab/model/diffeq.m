clear
% clc
% close all

N = 150;

R0=3;
Rend = 0.9;
% plot(Re,'.-');
serial = 5;

x=[1];
z=[1];
% for t=1:N
dt=0.01;
it=1;
time = dt:dt:150;
Re = (-sigmoid(time,36,0.5)+1)*(R0-Rend)+Rend;
for t=time
    k = log(Re(it))/serial;
%     k = log(3)/5;
    dxdt = k*(x(it)+0.5*dt)*dt;
    x(it+1)=x(it)+dxdt;
    z(it+1) = 3^(t/serial);
    it = it+1;
end

yyaxis right
grid on
plot([0 time],x, '-'); hold on
ylabel('New Cases')

yyaxis left
ylim([0,3])
plot(time, Re, '-'); hold on
ylabel('Reproduction Number (R_e)')
ylim([0,3.1])
% plot([0 time(1:1999)],z(1:2000), '.-'); hold off

xlabel('days')
title('model N(t) ~ \int R_e^{t/\tau} (no immunity)')
