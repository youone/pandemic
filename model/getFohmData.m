clear
close all
clc

% dates=[];
% i=1;
% for i=200:400
%     date = datestr(datenum('2020-03-26')+i, 'yyyy-mm-dd');
%     url = ['https://github.com/adamaltmejd/covid/blob/master/data/FHM/Folkhalsomyndigheten_Covid19_' date '.xlsx?raw=true']
%     filename = ['data/fohmData_' date '.xlsx']
%     try
%         websave(filename, url);
%         dates(i)=datenum('2020-03-26')+i
%         i=i+1;
%     catch
%         disp('ERROR!');
%     end
% end

h=figure
axis
ylim([0,120])
xlim([0,365])
files = dir('data');
% for i = 10:40
filename = 'fohmdata_movie.gif';

start = 175;
% for i = 10:20
for i = start:length(files)
    try
%     ['data/' files(i).name]
        data = xlsread(['data/' files(i).name],2);
%         min(data(:,1))
        plot(data(:,1)-43901, movmean(data(:,2),1),'.-');
        ylim([0,120])
        xlim([200,420])
%         xlim([min(data(:,1)),max(data(:,1))])
        title(['FoHM data ' files(i).name(10:19)], 'Interpreter', 'none')
        set(gca,'XTickLabel',[]);
%         set(gca,'YTickLabel',[]);
        ylabel('antal avlidna')
        drawnow
        
       frame = getframe(h); 
       im = frame2im(frame); 
       [imind,cm] = rgb2ind(im,256); 
       if i==start
           imwrite(imind,cm,filename,'gif','Loopcount',inf,'DelayTime',0.2);
       else
           imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.2);
       end
    catch
    end
end
