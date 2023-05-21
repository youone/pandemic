classdef Person < handle
    
    properties
        infectSchedule = [];
        index = 0;
        infectionDay = 0;
        deathDay = 0;
        nInfections = 0;
        suceptible = 1;
        R = 0;
    end
    
    methods
        
        function obj = Person(day, R, infecter, idx, Re)
            obj.R = R;
            obj.index = idx;
            obj.infectionDay = day;

            % use future R 
            try
                R = mean(Re(day:day+3));
            catch
            end
            
            obj.nInfections = poissrnd(R);
%             if (R>1)
%                 obj.nInfections = poissrnd(R);
%             else
%                 obj.nInfections = 0;
%                 if rand(1,1)<R
%                     obj.nInfections=1;
%                 end
%             end
            
            obj.infectSchedule = [obj.infectSchedule (day + poissrnd(5,1,obj.nInfections))];
%             for i = 1:obj.nInfections
% %                 dayToInfect = poissrnd(5,1,1);
%                  dayToInfect = randi([4,6],1,1);
%                 obj.infectSchedule = [obj.infectSchedule (day + dayToInfect)];
%             end

            if day==0
                newInfectSchedule = obj.infectSchedule - poissrnd(5,1,1);
                obj.infectSchedule = newInfectSchedule(newInfectSchedule>0);
                obj.nInfections = length(obj.infectSchedule);
            end

        end
        
    end
end

