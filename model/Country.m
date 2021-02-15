classdef Country < handle
    
    properties
        deaths = [];
        dates = [];
        days = [];
        population = 0;
        name = '';
        nmean = 14;
    end
    
    methods

        %
        %
        %
        function obj = Country(name, shift)
            if nargin == 0
                clc
                name = 'Belgium';
                shift = 0;
            end
            cdata = obj.getCountry('world', name)
            obj.population = cdata.population;
            plot(obj.days + shift, obj.deaths)
            
        end
        
        %
        %
        %
        function outputArg = method1(obj,inputArg)
            outputArg = obj.Property1 + inputArg;
        end
        
        %
        %
        %
        function country = getCountry(obj, continent, name)
            global allData;
            index = 1;
            for c = {allData.(continent).area}
                if strcmp(c{1}, name)
                    country = allData.(continent)(index);
                end
                index=index+1;
            end
            [obj.deaths obj.dates] = obj.getDeaths(country);
            obj.days=1:length(obj.dates);
        end
        
        %
        %
        %
        function [deaths, day] = getDeaths(obj, country)
            deaths=[];
            ii=1;
            for i=1:length(country.timeSeries)
                ts = cell2mat(country.timeSeries(i));
                try
                    deaths(ii) = ts.new_deaths;
                    day(ii) = datetime(datenum(ts.date,'yyyy-mm-ddTHH:MM:ss.fffZ'),'ConvertFrom','datenum');
                    ii = ii + 1;
                catch
                end
            end
            
            deaths = movmean(deaths, obj.nmean);
%             deaths = deaths/countryPopulation;
            deaths = deaths/max(deaths);

        end
        
    end
end

