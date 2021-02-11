clear
close all
clc

% dates=[];
% i=1;
% for i=80:400
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
filename = 'movie.gif';

% for i = 10:20
for i = 10:length(files)
    try
%     ['data/' files(i).name]
        data = xlsread(['data/' files(i).name],2);
        plot(data(:,1)-min(data(:,1)), data(:,2));
        ylim([0,120])
        xlim([0,365])
        drawnow
        
       frame = getframe(h); 
       im = frame2im(frame); 
       [imind,cm] = rgb2ind(im,256); 
       if i==10
           imwrite(imind,cm,filename,'gif','Loopcount',inf,'DelayTime',0.1);
       else
           imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.1);
       end
    catch
    end
end
