function [outputArg1,outputArg2] = covidModel(nDays,inputArg2)

person.contagent = [];
person.remove = 0;
person.deathDay = 0;

infecteds(1) = person;
infecteds(1).contagent = [1,2];
infecteds(1).remove = 11;
infecteds(1).deathDay = 15;

is = [];
R0 = 3;
Rend = 0.7;
Re = (-sigmoid(1:200,40,0.5)+1)*(R0-Rend)+Rend;

% nDays = 200;

nInfected = 1;
nRemoved = 0;
deathDays = [];

tholdDay = 0;

for day = 1:nDays
    
    is(day) = length(infecteds);
    
    if tholdDay == 0 && is(day)>500 && is(day) > is(day-1)
        tholdDay = day
    end
    
    i=1;
    for infected = infecteds
        
        
        if ismember(day, infected.contagent)
            newPerson = person;
            
            newPerson.contagent = infect(day, Re(day));
            person.remove = day+11;
            person.deathDay = day+20+randi([-2,2],1,1);
            infecteds = [infecteds, newPerson];
            nInfected = nInfected + 1 ;
        end
        
        if isempty(infected.contagent)
            person.remove = day+11;
            person.deathDay = day+20+randi([-2,2],1,1);
        end
        
        if day >= infected.remove
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

end

