% close all
clear
clc

Ndays = 20;

R0 = 3;
Rend = 3;
N0 = 10;

nInfecteds = [N0];
infecteds = [];
infectionDay = [];
nInf = 0;
nRem = 0;

Rrestr = 10;
slope = 0.3;
slope2 = 0.5;

disp(['DAY .... : ' num2str(0) ]);

% [nCasesMod, Re] = iModel(1:Ndays,1,5,R0,Rend,Rrestr,0.3,0);
[nCasesMod, Re] = iModel(1:Ndays,10,5,R0,Rend,Rrestr,slope,slope2);

index = 1;
for i=1:N0
    patientZero = Person(0, R0, -1, index);
    nInf = nInf +1;
    infecteds = [infecteds patientZero];
    infectionDay = [infectionDay 0];
end

index = index + 1;


% Re = Re_sigmoid(1:Ndays,R0,Rend,Rrestr,0.3,0);
% Re = Re_exponential(1:Ndays,R0,Rend,Rrestr,0.5,0);
% Re = Re_step(1:Ndays,R0,Rend,Rrestr,10,0);
% Re = Re_genlog(1:Ndays,R0,Rend,Rrestr,0.6,10);

% size(Re)
% plot(Re,'.-')
% return

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

h = hist(infectionDay,[0:Ndays-1]);

nCases = h;
% nCases = movmean(h,7);
nCasesDay = (1:Ndays);


% % ft = fittype('n0*3^(x/tau)');
% ft = fittype('iModel(x,a_n0,b_tau,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2)');
% options = fitoptions(ft);
% % options.Lower =      [N0,5,R0,Rend,Rrestr,0.3,0.5];
% % options.Upper =      [N0,5,R0,Rend,Rrestr,0.3,0.5];
% options.Lower =      [0,  5,R0,Rend,0,0,  0];
% options.Upper =      [inf,5,R0,Rend,inf,inf,inf];
% options.Startpoint = [N0, 5,R0,Rend,Rrestr,slope,slope2];
% f = fit( nCasesDay', nCases', ft, options)


ft = fittype('n0*exp(log(r)*x/tau)');
options = fitoptions(ft);
options.Lower = [0 0 5];%[N0,5,R0,Rend,Rrestr-10,max(nCases)];
options.Upper = [inf 3 5];%[N0,5,R0,Rend,Rrestr+10,max(nCases)];
options.Startpoint = [N0/5 3 5];%[N0,5,R0,Rend,Rrestr,max(nCases)];
f = fit( nCasesDay(1:end-1)', nCases(1:end-1)', ft, options)



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
% plot(nCasesDay, nCases, '.-r', nCasesDay, feval(f,nCasesDay)); hold on

% [~, fittedData, Re] = dModel(nCasesDay,f.a_n0,f.b_tau,f.c_Rstart,f.d_Rend,f.e_tOnset,f.f_slope,f.g_slope2);

% yyaxis left
% subplot(211)
% plot(nCasesDay, cumsum(nCases), '.-', nCasesDay, cumsum(nCasesMod), '.-'); hold off
% subplot(212)
% plot(nCasesDay(1:end-1), (nCases(1:end-1)), '.-', nCasesDay, (nCasesMod), '.-'); hold off
plot(nCasesDay(1:end-1), (nCases(1:end-1)), '.-', nCasesDay,feval(f,nCasesDay),'.-'); hold off
% plot(nCasesDay, nCases, '.-',nCasesDay,feval(f,nCasesDay),'.-');

% yyaxis right
% plot(nCasesDay,Re,'.-')
