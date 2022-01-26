clc
close all

se = Country('Sweden',0);
bg = Country('Belgium',0);

subplot(2,1,1)
plot(se.dates, movmean(se.deaths,14)/sum( movmean(se.deaths,14)),'linewidth',1.5); hold on
plot(bg.dates, movmean(bg.deaths,14)/sum( movmean(bg.deaths,14)),'linewidth',1.5); hold on
xlim(datetime(datenum({'1-Mars-2020', '1-Mars-2021'}),'ConvertFrom','datenum'))
set(gca,'XTick', datetime(datenum({'1-Mars-2020', '1-May-2020', '1-Jul-2020', '1-Sept-2020', '1-Nov-2020', '1-Jan-2021', '1-Mar-2021'}),'ConvertFrom','datenum'))
get(gca,'XTick')
ylabel({'tidsfordelning av', 'bekr. dodsfall'})
set(gca,'YTick', [])
legend('Sverige', 'Belgien', 'Location', 'north')
datetick('x','mmm yyyy','keeplimits','keepticks')
grid on

subplot(2,1,2)
plot(se.dates, movmean(se.deaths,14)/sum( movmean(se.deaths,14)),'linewidth',1.5); hold on
plot(bg.dates, movmean(bg.deaths,14)/sum( movmean(bg.deaths,14)),'linewidth',1.5); hold off
xlim(datetime(datenum({'1-Jan-2020', '1-Jan-2021'}),'ConvertFrom','datenum'))
ylabel({'tidsfordelning', 'bekr. dodsfall'})
set(gca,'YTick', [])
set(gca,'XTick', datetime(datenum({'1-January-2020',  '1-Mars-2020', '1-May-2020', '1-Jul-2020', '1-Sept-2020', '1-Nov-2020', '1-Jan-2021'}),'ConvertFrom','datenum'))
legend('Sverige', 'Belgien', 'Location', 'north')
datetick('x','mmm yyyy','keeplimits','keepticks')
grid on

title('')
