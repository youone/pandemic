close all
clear 
clc

N = 150;
tau = 5;

d = zeros(N,1);
t = (1:N);

[n, Re] = model(t,1,tau,3,0.7,20,10);

yyaxis left
% plot(t,n,'.-',t,d,'.-');
plot(t,n,'.-');
yyaxis right
plot(t,Re,'.-');

grid
