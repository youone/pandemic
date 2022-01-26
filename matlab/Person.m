classdef Person < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
%         id
        position
        status = 0
%         infected = 0;
%         suceptible = 1;
%         removed = 0;
%         incubation = []
        contagent = []
        incubationTime = 5
    end
    
    methods
        
%         function obj = Person()
%             disp('hej')
%         end
        
        function infect(obj, day)
            obj.status = 1;
%             obj.suceptible = 0;
%             obj.contagent = generation:generation+9;
            obj.contagent = day+obj.incubationTime:day+obj.incubationTime+9+randi([-2,2],1,1);
        end
    end
end

