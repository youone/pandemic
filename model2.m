clc
clear 
% close all

person.contagent = [];
person.infectSchedule = [];
person.infectionDay = 0;
person.removalDay = 0;
person.deathDay = 0;

[daysToInfect, infectSchedule, removalDay, deathDay] = infect(1,3);
infecteds(1) = person; 
infecteds(1).contagent = [1,2];
infecteds(1).infectSchedule = infectSchedule;
infecteds(1).infectionDay = 1;
infecteds(1).removalDay = removalDay;
infecteds(1).deathDay = deathDay;

is = [];
% Re = [];
R0 = 3;
Rend = 0.9;
Re = (-sigmoid(1:200,40,0.3)+1)*(R0-Rend)+Rend;

nDays = 200;

nInfected = 1;
nRemoved = 0;
deathDays = [];

tholdDay = 0;

for day = 1:nDays
%         disp(ismember(day, infected.contagent))

        
    is(day) = length(infecteds);
    disp(is(day))
%     Re(day) = (-sigmoid(day,40,0.3)+1)*(R0-Rend)+Rend;

    if tholdDay == 0 && is(day)>500 && is(day) > is(day-1)
        tholdDay = day
    end
%     
%     Re(day) = 3;
%     if tholdDay > 0
%         Re(day) = (-sigmoid(day-tholdDay,40,1)+1)*(R0-Rend)+Rend;
%     end

    i=1;
    for infected = infecteds

%         infected.infectionDay + find(infected.infectSchedule)
%         infected.infectSchedule(find(infected.infectSchedule))
        [daysToInfect, infectSchedule, removalDay, deathDay] = infect(day, Re(day));
        
        if ismember(day, infected.contagent)
            newPerson = person; 

            newPerson.contagent = daysToInfect;
            newPerson.infectSchedule = infectSchedule;
            newPerson.infectionDay = day;
            newPerson.removalDay = removalDay;
            newPerson.deathDay = deathDay;

            infecteds = [infecteds, newPerson];
            nInfected = nInfected + 1 ;
        end
        if isempty(infected.contagent)
            person.removalDay = removalDay;
            person.deathDay = deathDay;
        end

        if day >= infected.removalDay
%             disp([day, i, length(infecteds)])
            deathDays = [deathDays, infected.deathDay];
            try
                infecteds(i) = [];
            catch
                disp('ERROR')
            end
            nRemoved = nRemoved + 1 ;
%             disp([length(infecteds)])
        end

    i=i+1;
    end

end

% deathDays
nInfected
nRemoved
nInfected-nRemoved
infecteds
tholdDay
dd = movmean(hist(deathDays, 1:220), 7);
yyaxis right
plot(Re, '-'); hold on
yyaxis left
semilogy(is, '.-'); hold on
semilogy(dd, '.-k'); hold on
xlim([1,200])
% plot(is/max(is), '.-'); hold on
% axis equal
% grid on

% is(nDays)/is(nDays-10)

% dum=[];
% for i=1:1000
%     dum(i)=length(infect(1,0.9));
% end
% mean(dum)

function [daysToInfect, infectSchedule, removalDay, deathDay] = infect(day, R)
    incubation = 1;
    period = 10;
    removalDay = day+period+1;
    deathDay = day+20+randi([-2,2],1,1);
    infectSchedule = hist(randi([1,period],1,poissrnd(R)),1:period);
    daysToInfect = day + find(rand(1,period) < R*(1/period)*ones(1,period)) + incubation;
%     daysToInfect = [day+1, day+2];
    
%     range = day+incubation:day+incubation+period-1;
end
