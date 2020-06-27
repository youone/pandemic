clc;
clear;
close all;
global rates;

rates = jsondecode(fileread('data\ft_rates.json'));
[~,index] = sortrows({rates.allData.world.area}.'); rates.allData.world = rates.allData.world(index); clear index

lockdowns = jsondecode(fileread('data\ft_lockdown.json'));
% [~,index] = sortrows({lockdowns.data(4).countries.iso3}.'); lockdowns.data(4).countries = lockdowns.data(4).countries(index); clear index
% [val.allData.world(53).timeSeries.date]';

% country = 182; countryLd = 152;
% country = 74; countryLd = 43;
% country = 53; countryLd = 46;
% country = 144; countryLd = 119;
% country = 200; countryLd = 59;
% country = 176; countryLd = 52; % Spain
% country = 97; countryLd = 82; % Italy
country = 20; countryLd = 12; % Belgium
nmean = 7;
dateFormat = 7;

DateString = {'03/01/2020', '03/10/2020',  '03/20/2020', '04/01/2020',  '04/10/2020', '04/20/2020', '05/01/2020',  '05/10/2020', '05/20/2020', '06/01/2020',  '06/10/2020', '06/20/2020'};
datetime(DateString)

lockdownStringency = [];
% lockdownStringencyDay = [];
lockdownStringencyDay = datetime({lockdowns.data.date}');
for iday = 1:length(lockdownStringencyDay)
% for iday = 6
    stringency = [lockdowns.data(iday).countries.stringency]
    iso3 = {lockdowns.data(iday).countries.iso3}
%     disp(iday)
%     disp(lockdownStringencyDay(iday))
%     disp([iso3((countryLd)), stringency(countryLd)])
    try 
        if (stringency(countryLd) > -1)
            lockdownStringency(iday) = stringency(countryLd);
        else
            lockdownStringency(iday) = nan;
        end
    catch
        lockdownStringency(iday) = 0;
    end
    
end

% [day0, day1, day2, deaths] = getDeathsSweden(nmean);
% plot(day0(1:178), deaths, '.-'); hold on
% % set(gca, 'XTick', datetime(DateString,'format','MM/dd/yyyy'))
% % datetick('x',dateFormat, 'keepticks')

[day0, day1, day2, deaths] = getDeaths(country,nmean);
plot(day2, deaths/max(deaths), '.-'); hold on
plot(lockdownStringencyDay, lockdownStringency/100, '.-'); hold on
grid on
title([rates.allData.world(country).area iso3(countryLd)]);
% Xfit=1:1+160-68;
% Yfit=deaths(68:160);
% set(gca, 'XTick', datetime(DateString,'format','MM/dd/yyyy'))
% datetick('x',dateFormat, 'keepticks')

% [day0, day1, day2, deaths] = getDeaths(53,nmean);
% plot(day0(1:178), deaths, '.-'); hold off
% % set(gca, 'XTick', datetime(DateString,'format','MM/dd/yyyy'))
% % datetick('x',dateFormat, 'keepticks')

%datenum('2020-06-24T00:00:00.000Z','yyyy-mm-ddTHH:MM:ss.fffZ')

function [day0, day1, day2, deaths] = getDeaths(country, nmean)
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

end

function [day0, day1, day2, deaths] = getDeathsSweden(nmean)
    global rates;

    countryData = struct2cell(rates.allData.world(182).timeSeries);
    countryPopulation = rates.allData.world(182).population;

    day0 = 1:length(countryData(6,:));
    day1 = [];
    day2 = [];
    for i = (1:length(countryData(6,:)))
      day1(i) = datenum(countryData(6,i),'yyyy-mm-ddTHH:MM:ss.fffZ');
%       day(i) = datenum(countryData(6,i),'yyyy-mm-ddTHH:MM:ss.fffZ') - datenum([2020 3 1]);
    end

    day2 = datetime(day1,'ConvertFrom','datenum');
    
    sDeaths = load('data\sverige.txt');
    d = [rates.allData.world(182).timeSeries.new_deaths]
    
    d = zeros(size(d));
    d(74:74+104) = sDeaths(1:1+104);
    
    deaths = 1000000*movmean(d, nmean)/countryPopulation;

end



