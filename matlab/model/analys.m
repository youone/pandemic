clc
% clear
close all 

websave('fohmData.xlsx', 'https://github.com/adamaltmejd/covid/blob/master/data/FHM/Folkhalsomyndigheten_Covid19_2021-02-19.xlsx?raw=true')
%websave('worldData.json', 'https://ig.ft.com/coronavirus-chart/data.json')

% data = webread('https://ig.ft.com/coronavirus-chart/data.json')
%allData = jsondecode(fileread('worldData.json'));
% allData = jsondecode(fileread('..\data\ft_rates_new.json'));
%fohmData = xlsread('fohmData.xlsx',2);
% load('countryData');
% disp('loaded');
global allData;
global fohmData;

countries(1) = Country('Denmark',0); hold on
countries(1) = Country('Belgium',-2); hold on

return

dkData = getCountry('world','Denmark');
itData = getCountry('world','Norway');
beData = getCountry('world','Belgium');
spData = getCountry('world','Spain');
itData = getCountry('world','Italy');
frData = getCountry('world','France');
ukData = getCountry('world','United Kingdom');
irData = getCountry('world','Ireland');
auData = getCountry('world','Austria');
neData = getCountry('world','Netherlands');

% [deaths, day] = getDeaths('world','Portugal');
deathsFoHM = fohmData(:,2);
dayFoHM = datetime(fohmData(:,1) - min(fohmData(:,1)) + datenum('11-Mars-2020'),'ConvertFrom','datenum');

serialInterval = 5.5;

cases = movmean(fohmData(1:200,2),7);
day = 1:length(cases);
dayDate = dayFoHM(1:length(cases));
[curve, goodness, output] = fit(day',cases,'smoothingspline','SmoothingParam',0.02);
casesSpline = feval(curve, day);
casesSpline = casesSpline-min(casesSpline)+1;
ReSpline = exp(serialInterval*diff(casesSpline)./(casesSpline(1:end-1)*1));

% x = [1.65];
% z = [1.65];
% it=1;
% dt=1;
% for t=day(1:end-1)
%     k = log(ReSpline(it))/5;
%     k_ = log(ReSpline(it).*ReMod(it))/5;
% %     k = log(3)/5;
%     dxdt = k*(z(it)+0.5*dt)*dt;
%     dxdt_ = k_*(x(it)+0.5*dt)*dt;
%     z(it+1)=z(it)+dxdt;
%     x(it+1)=x(it)+dxdt_;
%     it = it+1;
% end


figure('position', [100 100 707 700]);

[~, remod1] = getCases(-0.8, ReSpline, 0.9, serialInterval);
[~, remod2] = getCases(-0.8, ReSpline, 0.8, serialInterval);

sp1 = subplot(2,1,1)
sp1.Position(2)= sp1.Position(2) + 0.13;
sp1.Position(4)= 0.2;
p0 = plot(dayDate(1:end-1)-20, 100*remod1, '-k', 'linewidth',2); hold on
p0 = plot(dayDate(1:end-1)-20, 100*remod2, '-k', 'linewidth',2); hold on
plot(datetime([datenum('2020-03-18'), datenum('2020-03-18')],'ConvertFrom','datenum'),[70,110],':k'); hold on;
set(gca,'XTick',[])
ylim([70, 110])
ylabel('R suppression (%)')

sp2=subplot(2,1,2)
sp2.Position = [0.1300    0.1100    0.7750    0.6];

yyaxis left
p1 = plot(dayDate-20, casesSpline/max(casesSpline), '-', ...
    dayDate-20, getCases(0.5, ReSpline, 0.9, serialInterval)/max(casesSpline), ':', ...
    dayDate-20, getCases(0.5, ReSpline, 0.8, serialInterval)/max(casesSpline), ':', ...
    dayDate-20, getCases(0.5, ReSpline, 0.7, serialInterval)/max(casesSpline), ':', ...
    'linewidth',2);
ylim([0,1.1])
ylabel('no. new infections (normalized)')
%     dayDate(1:end-1)-20, remod, '-k', ...


yyaxis right
p2 = plot(dayDate, movmean(fohmData(1:200,2),1), '-', dayDate, casesSpline, '-');
set(p2(2),'linewidth',2);
ylim([0,120])
ylabel('no. deaths')
legend([p2(1) p2(2) p1(1) p1(2)], 'deaths (data)','deaths (model)','new infections (model)', 'suppressed R-value')


% figure
% plot(ReSpline); hold on
% plot(ReSpline.*ReMod); hold on

% figure
% plot(dayFoHM, movmean(deathsFoHM,7), day, movmean(deaths,7));


function [x, ReMod]  = getCases(x0, Re, sup, serialInterval)
    ReMod = (-sigmoid(1:length(Re),28,1.0)+1)*(1-sup)+sup
    x = [x0];
    it=1;
    dt=1;
    for t = 1:length(Re)
%         k = log(Re(it)*ReMod(it))/5;
        k = log(Re(it)*ReMod(it))/serialInterval;
        dx = k*(x(it)+0.5*dt)*dt;
        x(it+1)=x(it)+dx;
        it = it+1;
    end
end


function country = getCountry(continent, name)
    global allData;
    index = 1;
    for c = {allData.(continent).area}
        if strcmp(c{1}, name)
            country = allData.(continent)(index);
        end
        index=index+1;
    end

    [country.deaths country.days] = getDeaths(country);
end

function [deaths, day] = getDeaths(country)

     deaths=[];
%      day={};
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
%     dateindex.us = 8;
%     dateindex.world = 6;
%     countryData = struct2cell(country.timeSeries);
%     countryPopulation = country.population;
% 
%     day0 = 1:length(countryData(dateindex.(continent),:));
%     day1 = [];
%     day2 = [];
%     for i = (1:length(countryData(dateindex.(continent),:)))
%       day1(i) = datenum(countryData(dateindex.(continent),i),'yyyy-mm-ddTHH:MM:ss.fffZ') + 5;
% %       day(i) = datenum(countryData(6,i),'yyyy-mm-ddTHH:MM:ss.fffZ') - datenum([2020 3 1]);
%     end
% 
%     day2 = datetime(day1,'ConvertFrom','datenum') + shift;
% 
%     deaths = 1000000*movmean([country.timeSeries.new_deaths], nmean);
%     deaths = deaths /countryPopulation;
%     deaths = deaths/max(deaths);
end