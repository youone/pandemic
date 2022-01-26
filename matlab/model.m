clear 
close all
clc

% subplot(2,1,1)
% is1 = run(0.95);
% plot(1:200,is1/max(is1)); hold on;
[is2, Re] = run(0.75);
plot(1:200,log10(is2/max(is2))); hold on;
% is3 = run(0.5);
% plot(1:200,is3/max(is3)); hold on;

% subplot(2,1,2)
% plot(1:200, Re)

function [is, Re] = run(Rend)

N=10000000;

pzero = Person();
pzero.infect(2);
personsMap = containers.Map(uint32(1), pzero);

% persons(1,N) = Person();
% persons(1).infect(1);

suceptibles = 2:N;
infecteds = [1];
removeds = [];

ss = [];
is = [];
rs = [];

R0=3;
% Rend=1.0;
Re = (-sigmoid(1:200,70,0.5)+1)*(R0-Rend)+Rend;

for day = 1:200
    
    disp([day, length(suceptibles), length(infecteds), length(removeds), length(suceptibles)+length(infecteds)+length(removeds)])
    ss(day) = length(suceptibles);
    is(day) = length(infecteds);
    rs(day) = length(removeds);
    
    for iinf = infecteds
%         infected = persons(iinf);
        infected = personsMap(iinf);
%             doInfect = rand < 2*0.1*length(suceptibles)/N;
%             doInfect = rand < R_E(day,30,70,2.5,0.9)*1/length(infected.contagent);
            doInfect = rand < Re(day)*1/(length(infected.contagent));
%             doInfect = rand < Re(day)*1/9;
        if ismember(day, infected.contagent) 
            if doInfect
                personToInfect = randi([1,N], 1, 1);
%                 personToInfect = randi([1,length(suceptibles)], 1, 1);
%                 persons(personToInfect).infect(day);
                newInfectedPerson = Person();
                newInfectedPerson.infect(day);
                personsMap(personToInfect) = newInfectedPerson;
                infecteds = [infecteds, personToInfect];
%                 suceptibles(personToInfect) = [];
            end
        end
        if day == infected.contagent(end) || day == infected.contagent(end)+1
            removeds = [removeds, iinf];
            infecteds(find(iinf)) = [];
        end
    end
end


end

function val = R_E(day,start,stop,r0,rend)
    val = r0;
    if day > start 
        val = r0 - (day-start)*(2-0.9)/(stop-start);
    end
    if day > stop 
        val = rend;
    end
%     if day > 70 
%         val = 0.9;
%     end
end
