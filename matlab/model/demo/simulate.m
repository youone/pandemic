% close all
clear
clc

Ndays = 32;

index = 1;
R0 = 3;
Rend = 3;
N0 = 1;

nInfecteds = [N0];
infecteds = [];
infectionDay = [];
nInf = 0;
nRem = 0;

disp(['DAY .... : ' num2str(0) ]);

for i=1:N0
    patientZero = Person(0, R0, -1, index);
    nInf = nInf +1;
    infecteds = [infecteds patientZero];
    infectionDay = [infectionDay 0];
end

index = index + 1;
Rrestr = 25;

Re = (-sigmoid(1:Ndays,Rrestr,0.3)+1)*(R0-Rend)+Rend;

for day = 1:Ndays
    
    nInfecteds = [nInfecteds length(infecteds(find([infecteds.suceptible] == 1)))];
    
    disp(['DAY .... : ' num2str(day) ' infected: ' num2str(length(infecteds(find([infecteds.suceptible] == 1)))) ' ' num2str(index)]);
    
    iInfected = 1;
    for infected = infecteds(find([infecteds.suceptible] == 1))
        
        for daysToInfectDay = infected.infectSchedule
            if day == daysToInfectDay
                newInfected = Person(day, Re(day), infected.index, index);
                nInf = nInf +1;
                index = index + 1;
                infecteds = [infecteds newInfected];
                infectionDay = [infectionDay day];
            end
        end
        
        if day >= infected.removalDay
            infected.suceptible = 0;
            nRem = nRem + 1;
        end

        iInfected = iInfected + 1;
    end
end

h = hist(infectionDay,[0:Ndays]);

nCases = h;
% nCases = movmean(h,7);
nCasesDay = (0:Ndays);


ft = fittype('n0*3^(x/tau)');
options = fitoptions(ft);
options.Lower = [0 5];%[N0,5,R0,Rend,Rrestr-10,max(nCases)];
options.Upper = [inf 5];%[N0,5,R0,Rend,Rrestr+10,max(nCases)];
options.Startpoint = [1,5];%[N0,5,R0,Rend,Rrestr,max(nCases)];
f = fit( nCasesDay', nCases', ft, options)


% [n,t,Re]=rmodel(1:Ndays,N0,5,R0,Rend,Rrestr,max(nCases));
% % plot(t,n)
% % plot(t,n/max(n))
% plot(t,n,'.-')
% grid
% hold on 

% ft = fittype( 'rmodel( d,N0,5,R0,Rend,Rrestr,max(nCases) )' )
% f = fit( nCasesDay, nCases, ft, 'StartPoint', [N0,5,R0,Rend,Rrestr,max(nCases)])

% plot(nCasesDay, nCases/max(nCases), '.-'); hold on
% plot(nCasesDay-1, max(n)*nCases/max(nCases), '.-')
plot(nCasesDay, nCases, '.-r', nCasesDay, feval(f,nCasesDay)); hold on

