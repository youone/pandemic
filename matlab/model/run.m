close all
clear
clc

Ndays = 100;

index = 1;
R0 = 3.0;

nInfecteds = [];
infectionDay = [];
nInf = 0;
nRem = 0;

disp(['DAY .... : ' num2str(0) ]);
patientZero = Person(0, R0, -1, index);
nInf = nInf +1;
index = index + 1;
infecteds = [patientZero];
infectionDay = [infectionDay 0];

Rend = 0.7;
Re = (-sigmoid(1:Ndays,25,0.3)+1)*(R0-Rend)+Rend;

for day = 1:Ndays
    
    nInfecteds = [nInfecteds length(infecteds)];
    
    disp(['DAY .... : ' num2str(day) ' infected: ' num2str(length(infecteds)) ' ' num2str(index)]);
    
    iInfected = 1;
    for infected = infecteds
        
        for daysToInfectDay = infected.infectSchedule
            if day == daysToInfectDay
%                 newInfected = Person(day, R0, infected.index, index);
                newInfected = Person(day, Re(day), infected.index, index);
                nInf = nInf +1;
                index = index + 1;
                infecteds = [infecteds newInfected];
                infectionDay = [infectionDay day];
            end
        end
        
        if day > infected.removalDay
%             iInfected
%             length(infecteds)
            try
                infecteds(iInfected) = [];
                nRem = nRem +1;
            catch
                disp('ERROR!')
            end
        end
        iInfected = iInfected + 1;
    end
end

h = hist(infectionDay,[1:Ndays]);

nCases = h;
% nCases = movmean(h,14);
nCasesDay = (0:Ndays-1);

[curve, goodness, output] = fit(nCasesDay',nCases','smoothingspline','SmoothingParam',0.02);
nCasesSpline = feval(curve,nCasesDay);

g = fittype('a*exp(b*x)');
f0 = fit(nCasesDay(1:20)',nCases(1:20)',g);
nStart = f0.a;

% plot(nCasesDay, nCases/max(nCases), '.-'); hold on
plot(nCasesDay, nCases, '.-'); hold on
plot(nCasesDay, nCasesSpline, '.-');
% plot(0:Ndays-1, nInfecteds, '.-'); hold on


x=[1];
z=[1];
% for t=1:N
dt=0.01;
it=1;
time = dt:dt:Ndays;
% Re = (-sigmoid(time,25,0.3)+1)*(exp(5*f0.b)-Rend)+Rend;
Re = (-sigmoid(time,25,0.3)+1)*(R0-Rend)+Rend;
for t=time
    k = log(Re(it))/5;
%     k = log(3)/5;
    dxdt = k*(x(it)+0.5*dt)*dt;
    x(it+1)=x(it)+dxdt;
    z(it+1) = 3^(t/5);
    it = it+1;
end

% yyaxis right
% grid on
% plot([0 time],x/max(x), '-'); hold on
plot([0 time],1*x, '-'); hold on
% plot([0 time(1:1999)],z(1:2000), '.-');
% ylabel('New Cases')

% x=[1];
% y=[1];
% z=[1];
% for t=1:Ndays
%     k = log(3)/5;
% %     k = log(Re(t))/5;
%     dxdt = k*x(t);
%     x(t+1)=x(t)+dxdt;
%     y(t+1) = exp(k*t);
%     z(t+1) = 3^(t/5);
% end
% 
% % plot(x/max(x), '-')
% plot(x, '-')
% % plot(y, '-')
% % plot(z, '-')

grid on

Rspline = exp(5*diff(nCasesSpline(2:end))./(nCasesSpline(2:end-1)*1));
dum  = interp1(nCasesDay,nCasesSpline,time);
figure
plot(time, exp(5*diff(x)./(x(1:end-1)*0.01))); hold on
plot(time(1:end-1), movmean(exp(5*diff(dum)./(dum(1:end-1)*0.01)),100) );

ReSpline = exp(5*diff(dum)./(dum(1:end-1)*0.01));
z = [1];
it=1;
for t=time(1:end-1)
    k = log(ReSpline(it))/5;
%     k = log(3)/5;
    dxdt = k*(z(it)+0.5*dt)*dt;
    z(it+1)=z(it)+dxdt;
    it = it+1;
end




nInf
nRem
sum(h)
[sum(nCases(1:1+4)) sum(nCases(5:5+4))]