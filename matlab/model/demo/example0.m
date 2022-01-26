R0 = 3;
t = (0:days); 
tau = 1.0;
n1 = 1*R0.^(t/tau);
n2 = n0*R0.^(t/tau);
ph = plot(t, n1, '.-', t+timeShift, n2, '.-'); xlabel('day'); ylabel('new infetions'); title(['R_0 = 3, \tau = ' num2str(tau)])
% set(gcf,'Visible','on')
%axis([0,11,0,18e4]);
% axis([0,5,0,250]);
grid on
legend('country A, n_0=1',['country B, n_0=' num2str(3*n0)],'Location','northwest');

linkdata on