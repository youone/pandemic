classdef Country < handle
    
    properties
       population;
       day0;
       day1;
       day2;
       deaths;
%        deathsPeakValue;
       deathsPeakIndex = 0;
       lockdownStringency;
       lockdownStringencyDay;
    end
    
    methods
        
        function obj = Country(country,countryLd)
            global rates;
            global lockdowns;
            
            nmean = 7;
            dateFormat = 7;
            DateString = {'03/01/2020', '03/10/2020',  '03/20/2020', '04/01/2020',  '04/10/2020', '04/20/2020', '05/01/2020',  '05/10/2020', '05/20/2020', '06/01/2020',  '06/10/2020', '06/20/2020'};
            obj.lockdownStringency = [];
            % lockdownStringencyDay = [];
            obj.lockdownStringencyDay = datetime({lockdowns.data.date}');
            for iday = 1:length(obj.lockdownStringencyDay)
                stringency = [lockdowns.data(iday).countries.stringency];
                iso3 = {lockdowns.data(iday).countries.iso3};
                try 
                    if (stringency(countryLd) > -1)
                        obj.lockdownStringency(iday) = stringency(countryLd);
                    else
                        obj.lockdownStringency(iday) = nan;
                    end
                catch
                    obj.lockdownStringency(iday) = 0;
                end

            end

            [obj.day0, obj.day1, obj.day2, obj.deaths] = obj.getDeaths(country,nmean);
        end

        
        function [day0, day1, day2, deaths] = getDeaths(obj, country, nmean)
            global rates;

            countryData = struct2cell(rates.allData.world(country).timeSeries);
            countryPopulation = rates.allData.world(country).population;

            day0 = 1:length(countryData(6,:));
            day1 = [];
            day2 = [];
            for i = (1:length(countryData(6,:)))
              day1(i) = datenum(countryData(6,i),'yyyy-mm-ddTHH:MM:ss.fffZ');
        %       day(i) = datenum(countryData(6,i),'yyyy-mm-ddTHH:MM:ss.fffZ') - datenum([2020 3 1]);
            end

            day2 = datetime(day1,'ConvertFrom','datenum');

            deaths = 1000000*movmean([rates.allData.world(country).timeSeries.new_deaths], nmean)/countryPopulation;
            
            obj.deathsPeakIndex = find(deaths==max(deaths));
        end
        
        function plot1(obj, color)
            plot(obj.day2 + 3 - obj.deathsPeakIndex(1), obj.deaths/max(obj.deaths), ['.-' color]); hold on
%             plot(obj.day2 + 3, obj.deaths/max(obj.deaths), '.-');
            plot(obj.lockdownStringencyDay - obj.deathsPeakIndex(1), obj.lockdownStringency/100, ['.-' color]);
        end
    end
end

