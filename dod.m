close all;

dexpected = load('ginput');
dexp = -(800/368)*dexpected.m(:,2)+2000;
wexp = linspace(0,dexpected.m(32,1)-dexpected.m(1,1), 52);
% wexp = wexp*52/max(wexp);

X=wexp*52/max(wexp);
Y=spline(m(:,1),dexp,wexp);
Y=circshift(polyval(polyfit(X,Y,11),X),26);

figure;
% plot(dexpected.m(:,1), dexp, '.-'); hold on;
% figure;
plot((1:52),Y, '.-'); hold on;
% plot(wexp*52/max(wexp), polyval(polyfit(m(:,1),dexp,5),wexp*52/max(wexp)), '.-'); hold off;

d = load('agemean.txt');
d = [0.8*sum(d([1,53],:)); d(2:52,:)];
deadNormal = sum(d(:,2:4)')+sum(d(:,6:8)')
plot(deadNormal, '.-')

d = load('age2020.txt');
d = [0.6*sum(d([1,23],:)); d(2:22,:)];
dead2020 = sum(d(:,2:4)')+sum(d(:,6:8)');
plot(dead2020, '.-')

title('Overdodlighet 2020, 65ar och uppat');
xlabel('vecka')
ylabel('antal/vecka')

legend('forvantad dodlighet', 'medel 2015-2019', '2020')

% d = load('dod.txt');
% 
% figure;
% plot(1:365,d(:,1), ...
%     366:365+365,d(:,2), ...
%     2*365+1:2*365+365,d(:,3), ...
%     3*365+1:3*365+365,d(:,4), ...
%     4*365+1:4*365+365,d(:,5)...
%     );
% hold on;
% 
% % plot(1:5*365, movmean(repmat(d(:,7),5,1), 7), 'k');
% % hold off;
% 
% plot(1:5*365, 7*movmean(reshape(d(:,1:5),1,365*5), 7), 'k');
% hold off;
