classdef Person < handle
    
    properties
        infectSchedule = [];
        index = 0;
        infectionDay = 0;
        deathDay = 0;
        removalDay = 0;
        nInfections = 0;
        suceptible = 1;
    end
    
    methods
        
        function obj = Person(day, R, infecter, idx)
            obj.index = idx;
            
            period = 10;
            obj.infectionDay = day;
            obj.removalDay = day+period;
            %             obj.removalDay = day+period+randi([-2,2],1,1);
            %             obj.deathDay = day+20+randi([-2,2],1,1);
            
            %            obj.nInfections = 3;
            %            obj.nInfections = R;
            
            if (R>1)
%                 obj.nInfections = R;
                obj.nInfections = poissrnd(R);
            else
                obj.nInfections = 0;
                if rand(1,1)<R
                    obj.nInfections=1;
                end
            end
            
            
%             obj.infectSchedule = [obj.infectSchedule (day + [5,5,5])];
%             obj.infectSchedule = [obj.infectSchedule (day + 5*ones(1,obj.nInfections))];
            for i = 1:obj.nInfections
%                 dayToInfect = randi([1,9],1,1);
                dayToInfect = randi([2,10],1,1);
                obj.infectSchedule = [obj.infectSchedule (day + dayToInfect)];
            end
            
%                         fprintf('person %i infected by %i, infects %i on days%g', idx, infecter, obj.nInfections)
%                         fprintf(' %g', obj.infectSchedule)
%                         fprintf('\n')
        end
        
    end
end

