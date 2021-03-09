classdef Person < handle
    
    properties
        infectSchedule = [];
        index = 0;
        infectionDay = 0;
        deathDay = 0;
        removalDay = 0;
        nInfections = 0;
        suceptible = 1;
        R = 0;
    end
    
    methods
        
        function obj = Person(day, R, infecter, idx, Re)
            obj.R = R;
            obj.index = idx;
            
            try
% %                 Re(day:day+10)*(poisspdf(1,0:10)')
% %                 disp([R mean(Re(day:day+3)) Re(day:day+20)*(poisspdf(5,0:20)')]);
                R = mean(Re(day:day+3));
% %                    R=Re(day:day+20)*(poisspdf(1,0:20)');
            catch e
                
            end
            
            period = 10;
            obj.infectionDay = day;
            obj.removalDay = day+period;
            %             obj.removalDay = day+period+randi([-2,2],1,1);
            %             obj.deathDay = day+20+randi([-2,2],1,1);
            
            %            obj.nInfections = 3;
            %            obj.nInfections = R;
            
            if (R>1)
%                 obj.nInfections = 3;
                obj.nInfections = poissrnd(R);
            else
                obj.nInfections = 0;
                if rand(1,1)<R
                    obj.nInfections=1;
                end
            end
            
%             poissrnd(5,1,obj.nInfections)
            obj.infectSchedule = [obj.infectSchedule (day + poissrnd(5,1,obj.nInfections))];
%             obj.infectSchedule = [obj.infectSchedule (day + [5,5,5])];
%             obj.infectSchedule = [obj.infectSchedule (day + 5*ones(1,obj.nInfections))];
%             for i = 1:obj.nInfections
%                 dayToInfect = poissrnd(5,1,1);
% %                  dayToInfect = randi([1,9],1,1);
%                 obj.infectSchedule = [obj.infectSchedule (day + dayToInfect)];
%             end
            
%             fprintf('person %i infected by %i, infects %i on days%g', idx, infecter, obj.nInfections)
%             fprintf(' %g', obj.infectSchedule)
%             fprintf('\n')
        end
        
    end
end

