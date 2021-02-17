classdef Country < handle
    
    properties
        deaths = [];
        cases = [];
        dates = [];
        days = [];
        population = 0;
        name = '';
        nmean = 14;
        firstCaseDay = 0;
    end
    
    methods

        function projectDeaths(obj)
            plot(obj.deaths)
        end

        %
        %
        %
        function obj = Country(name, shift)

            if nargin == 0
                clc
                name = 'Denmark';
                shift = 0;
            end
            cdata = obj.getCountry('world', name);
            obj.population = cdata.population;
            
            selection = (obj.dates >= datetime(datenum('3-March-2020'),'ConvertFrom','datenum')) & ...
                        (obj.dates < datetime(datenum('1-Aug-2020'),'ConvertFrom','datenum'));

            x = obj.days(selection) + shift;
            xdates = obj.dates(selection) + shift;
            x = 1:length(x);
            y = movmean(obj.deaths(selection),obj.nmean)*1000000/obj.population;

%             plot(obj.dates, obj.cases,'.-'); hold on
%             plot(obj.days(selection), movmean(obj.deaths(selection),14),'.-'); hold off
%             plot(obj.dates(selection)-15,y,'.-'); hold on
            plot(x,y,'.-'); hold on
            
            ft = fittype('infectmodel(x, a_nstart, b_serial, c_Rstart, d_Rend, e_dRestr, f_slope, g_assym, h_scale)');
            coeffnames(ft)
            options = fitoptions(ft);

%             options.Lower = [20 ,5,0  ,0   ,20   ,0   ,0    ,0];
%             options.Upper = [20 ,5,inf,1   ,inf   ,inf ,inf  ,inf];
%             options.Startpoint = [20,5,4,0.5,10,1,1,1];

%%exponential                       nstart  serial  Rstart  Rend  dRestr  slope  assym  scale
%             options.Lower =      [0       5       0       0     0       0      0      0];
%             options.Upper =      [inf     5       inf     1     nan     10     nan    1];
%             options.Startpoint = [20      5       3       0.5   30      0.1    1      0.0055];

%generalized logistic             nstart  serial  Rstart  Rend  dRestr  slope  assym  scale
            options.Lower =      [0      5       0       0     0       0      0      0];
            options.Upper =      [0      5       1       inf   inf     10     10     1];
            options.Startpoint = [0      5       0.5     3     20      3      10     1];
            
            f = fit( x', y', ft, options)
            [n, t, Re] = infectmodel(x,f.a_nstart, f.b_serial, f.c_Rstart, f.d_Rend, f.e_dRestr, f.f_slope, f.g_assym, f.h_scale);

            yyaxis left
%             plot(obj.dates(selection)-15,feval(f,x)); hold on
            plot(x,feval(f,x)); hold on
            
            yyaxis right
%             plot(obj.dates(selection)-15,Re); hold off
            plot(x,Re); hold off
            
            return
            
            Rend=0.8; Rstart=3; dRestr=25; nstart=1; serial=5; slope=0.3; scale=15;
            ft = fittype( 'rmodel( x,nstart,serial,Rstart,Rend,dRestr,slope,scale)' );
            options = fitoptions(ft);
            p1=Rend;
            p2=Rstart;
            p3=dRestr;
            p4=nstart;
            p5=scale;
            p6=serial;
            p7=slope;
%             options.Lower = [p1-1 0 p3-10 0 0 5];%[N0,5,R0,Rend,Rrestr-10,max(nCases)];
%             options.Upper = [p1+1 10 p3+10 10 1000 5];%[N0,5,R0,Rend,Rrestr+10,max(nCases)];

            options.Upper = [1 3 inf 1 inf p6 1];%[N0,5,R0,Rend,Rrestr,max(nCases)];
            options.Lower = [0 3 0 1 0 p6 0];%[N0,5,R0,Rend,Rrestr,max(nCases)];
            options.Startpoint = [p1 p2 p3 p4 p5 p6 p7];%[N0,5,R0,Rend,Rrestr,max(nCases)];
            f = fit( x(1:end-1)', y(1:end-1)', ft, options)
            
            ReFit = (-sigmoid(x,f.dRestr,f.slope)+1)*(f.Rstart-f.Rend)+f.Rend;
            ReFitDk = (-sigmoid(x,26.68,0.2312)+1)*(f.Rstart-0.8167)+0.8167;
            ReFitAlt = (-sigmoid(x,f.dRestr,f.slope)+1)*(f.Rstart-0.8*f.Rend)+0.8*f.Rend;

            nDk = rmodel(x,f.nstart,f.serial,f.Rstart,0.8167,26.68,0.2312,f.scale);
            nAlt = rmodel(x,f.nstart,f.serial,f.Rstart,0.8*f.Rend,f.dRestr,f.slope,f.scale);

            delay = 0;
            
            yyaxis left
            pl4=plot(xdates-delay, ReFit); hold on
            pl5=plot(xdates-delay, ReFitAlt); hold on
            plot(xdates,ones(size(x)),'k:'); hold off
            ylim([0 3])
%             xlim([0 150])
            ylabel('Reproduction Number (R_e)')
            
            yyaxis right
            pl1=plot(xdates-delay, y/max(y),'-', 'color', 0.7*[1 1 1]); hold on
            pl2=plot(xdates-delay, feval(f,x)/max(y), 'linewidth', 2); hold on
            pl3=plot(xdates-delay, nAlt/max(y),'--', 'linewidth', 2); hold on
            ylim([0 1.1])
%             xlim([0 150])
            ylabel('New Cases / peak value')

            xlabel('days')
            title('model N(t) ~ \int R_e^{t/\tau} (no immunity)')
            legend([pl4 pl5 pl1 pl2 pl3],'Re', 'Re, supressed', 'data', 'model, fitted to data', 'model, supressed')
            
            6000*sum(nAlt)/sum(y)
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
            global fohmData;

            index = 1;
            for c = {allData.(continent).area}
                if strcmp(c{1}, name)
                    country = allData.(continent)(index);
                end
                index=index+1;
            end
            
            [obj.deaths, obj.cases, obj.dates, obj.days] = obj.getDeaths(country);
            
            if strcmp(name, 'Sweden')
                 deaths = fohmData(1:end-1,2)';
                 dates = fohmData(1:end-1,1)';
                 deaths = [zeros(1,48), deaths];
                 dates = [dates(1)-48:dates(1)-1, dates];
                
                obj.deaths = deaths;
                obj.dates = datetime(dates - min(dates) + datenum('23-Jan-2020'),'ConvertFrom','datenum');
                obj.days = 1:length(obj.deaths);
                obj.firstCaseDay = min(obj.days(obj.deaths>0));
            end

        end
        
        %
        %
        %
        function [deaths, cases, date, day] = getDeaths(obj, country)
            cases=[];
            deaths=[];
            ii=1;
            for i=1:length(country.timeSeries)
                ts = cell2mat(country.timeSeries(i));
                try
                    deaths(ii) = ts.new_deaths;
                    cases(ii) = ts.new_cases;
                    date(ii) = datetime(datenum(ts.date,'yyyy-mm-ddTHH:MM:ss.fffZ'),'ConvertFrom','datenum');
                    ii = ii + 1;
                catch
                end
            end
            day = 1:length(deaths);
            obj.firstCaseDay = min(day(deaths>0));
        end
        
    end
end

