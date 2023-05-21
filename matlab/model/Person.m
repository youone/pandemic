classdef Person < handle
    
    properties
        infectSchedule = [];
        index = 0;
        infectionDay = 0;
        deathDay = 0;
        removalDay = 0;
    end
    
    methods
        
        function obj = Person(day, R, infecter, idx)
            obj.index = idx;

            period = 10;
            obj.infectionDay = day;
            obj.removalDay = day+period+randi([-2,2],1,1);
%             obj.deathDay = day+20+randi([-2,2],1,1);
            
%             nInfections = 3;
            nInfections = R;
            if day >= 0
                 nInfections = poissrnd(R);
            end
            
%              obj.infectSchedule = [obj.infectSchedule (day + [5,5,5])];
%              obj.infectSchedule = [obj.infectSchedule (day + 5*ones(1,nInfections))];
            for i = 1:nInfections
                dayToInfect = randi([1,10],1,1);
                obj.infectSchedule = [obj.infectSchedule (day + dayToInfect)];
            end
            
%             fprintf('person %i infected by %i, infects %i on days%g', idx, infecter, nInfections)
%             fprintf(' %g', obj.infectSchedule)
%             fprintf('\n')
        end
        
    end
end

