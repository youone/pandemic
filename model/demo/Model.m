classdef Model < matlab.mixin.Copyable
    
    properties
        name = '';
        serialInterval = 5;
        nDays = 200;
        n0 = 1;
        reModelName = 'sigmoid'
        rStart = 3;
        rEnd = 0.7;
        rSlope = 0.5;
        rSlope2 = 0.5;
        rOnset = 18;
        dDelay = 20;
        dVariance = 0.2;
        infectionFatalityRatio = 0.01;
        zeroCross = 1;
        day = [];
        date = [];
        re = [];
        reUpper = [];
        reLower = [];
        infecteds = [];
        newInfecteds = [];
        deceased = [];
        deceasedUpper = [];
        deceasedLower = [];
        fitData = [];
    end
    
    methods
        
        function obj = Model(reModelName)
            global reModel;
            reModel = reModelName;
            obj.reModelName = reModelName;
            obj.day = 1:obj.nDays;
        end
        
        function update(obj)
            [obj.deceased, obj.infecteds, obj.newInfecteds, obj.re] = obj.deceaseModel(...
                obj.day ,...
                obj.n0,...
                obj.serialInterval,...
                obj.rStart,...
                obj.rEnd,...
                obj.rOnset,...
                obj.rSlope,...
                obj.rSlope2,...
                obj.dDelay,...
                obj.dVariance,...
                obj.infectionFatalityRatio...
                );
            obj.zeroCross = obj.zeroCrossing(obj.re-1);
%             plot(diff(diff(obj.newInfecteds)))
            
        end
        
        function simulate(obj, nGenerations, updatecallback)
            N0 = obj.n0;
%             N0 = 1;
            nInfecteds = N0;
            infecteds = [];
            infectionDay = [];
            infectionHist = zeros(size(obj.day));
            deceasedHist = zeros(size(obj.day));
            nInf = 0;
            nRem = 0;

            simStatusMessage = '';
            
            index = 1;
            for i=1:N0
                patientZero = Person(0, obj.rStart, -1, index, obj.re);
                
                simStatusMessage = [simStatusMessage, ...
                    sprintf('day %03i: person %4i infected by    X and infects %i others on days ',...
                    0, ...
                    index, ...
                    patientZero.nInfections),...
                    sprintf('%g ', patientZero.infectSchedule),...
                    sprintf('\n')
                    ];
                
                nInf = nInf +1;
                index = index + 1;
                infecteds = [infecteds patientZero];
                infectionDay = [infectionDay 0];
                
            end
            updatecallback(simStatusMessage, infectionHist, deceasedHist);
            
            
            for day = 1:nGenerations
                
                simStatusMessage = '';
                
                nInfecteds = [nInfecteds length(infecteds(find([infecteds.suceptible] == 1)))];
                
                iInfected = 1;
                for infected = infecteds(find([infecteds.suceptible] == 1))
                    
                    for daysToInfectDay = infected.infectSchedule
                        if day == daysToInfectDay
                            Rmodified = obj.re(day);
                            newInfected = Person(day, Rmodified, infected.index, index, obj.re);
                            
                            simStatusMessage = [simStatusMessage, ...
                                sprintf('day %03i: person %4i infected by %4i and infects %i others on days ',...
                                day, ...
                                index, ...
                                infected.index,...
                                newInfected.nInfections),...
                                sprintf('%g ', newInfected.infectSchedule),...
                                sprintf('\n')
                                ];
                            
                            nInf = nInf +1;
                            index = index + 1;
                            infecteds = [infecteds newInfected];
                            infectionDay = [infectionDay day];
                            infectionHist(day) = infectionHist(day)+1;
                            
                            if (rand<0.01)
                                deceaseDay = day + round(lognrnd(log(20),0.2));
                                deceasedHist(deceaseDay) = deceasedHist(deceaseDay) + 1;
                            end
                            
                        end
                    end
                    
                    if day >= infected.removalDay
                        infected.suceptible = 0;
                        nRem = nRem + 1;
                    end
                    iInfected = iInfected + 1;
                end
                
                updatecallback(simStatusMessage, infectionHist, deceasedHist);
                
            end
            
        end
        
        function fit(obj, data, firstDate)
            obj.fitData = data(1:obj.nDays);
            fitModel = fittype('Model.deceaseModel(t,a_n0,b_tau,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2,h_dDelay,i_dVariance,j_ifr)','independent','t','coefficients', {'a_n0','b_tau','c_Rstart','d_Rend','e_tOnset','f_slope','g_slope2','h_dDelay','i_dVariance','j_ifr'});
            fitOptions = fitoptions(fitModel);
            
            fitLimits = [
                [obj.n0 0 inf];
                [obj.serialInterval obj.serialInterval obj.serialInterval];
                [obj.rStart 0 5];
                [obj.rEnd 0 1];
                [obj.rOnset obj.rOnset obj.rOnset];
                [obj.rSlope 0 inf];
                [obj.rSlope2 obj.rSlope2 obj.rSlope2];
                [obj.dDelay obj.dDelay obj.dDelay];
                [obj.dVariance obj.dVariance obj.dVariance];
                [obj.infectionFatalityRatio obj.infectionFatalityRatio obj.infectionFatalityRatio]
                ]
            
            fitOptions.Lower = fitLimits(:,2);
            fitOptions.Upper = fitLimits(:,3);
            fitOptions.Startpoint = fitLimits(:,1);
            
            fitResult = fit(obj.day(:), obj.fitData(:), fitModel, fitOptions)

            predictionConfidence = predint(fitResult,obj.day,0.95,'functional','off');
%             parameterConfidence = confint(fitResult);
            obj.deceasedUpper = predictionConfidence(:,1);
            obj.deceasedLower = predictionConfidence(:,2);

            fu = fit(obj.day(:), obj.deceasedUpper, fitModel, fitOptions)
            fl = fit(obj.day(:), obj.deceasedLower, fitModel, fitOptions)
            obj.reUpper = Model.reSeries(obj.day(:),fu.c_Rstart, fu.d_Rend, fu.e_tOnset, fu.f_slope, fu.g_slope2);
            obj.reLower = Model.reSeries(obj.day(:),fl.c_Rstart, fl.d_Rend, fl.e_tOnset, fl.f_slope, fl.g_slope2);
            
            obj.serialInterval = fitResult.b_tau;
            obj.rOnset = fitResult.e_tOnset;
            obj.n0 = fitResult.a_n0;
            obj.rStart = fitResult.c_Rstart;
            obj.rEnd = fitResult.d_Rend;
            obj.rSlope = fitResult.f_slope;
            
            obj.update()

            plot(predictionConfidence(:,2)'); hold on
            plot(predictionConfidence(:,1)'); hold on
            plot(obj.deceased); hold off
            
        end
        
    end
    
    methods(Static)
        
        function Re = reSeries(t, c_Rstart, d_Rend, e_tOnset, f_slope, g_slope2)
            global reModel
            try
                %                 disp(['GLOBAL ' reModel])
                Re = feval(['Re_' reModel], t, c_Rstart, d_Rend, e_tOnset, f_slope, g_slope2);
            catch e
                disp(e)
                disp(['DEFAULT sigmoid'])
                Re = Re_sigmoid(t,c_Rstart,d_Rend,e_tOnset,f_slope);
            end
        end
        
        function [nNewInfecteds, nInfecteds, Re] = infectModel(t,a_n0,b_tau,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2)
            nInfecteds = zeros(size(t));
            Re = Model.reSeries(t, c_Rstart, d_Rend, e_tOnset, f_slope, g_slope2);
            nInfecteds(1) = a_n0;
            for i=1:length(nInfecteds)-1
                nInfecteds(i+1) = nInfecteds(i)*(exp(log(Re(i))/b_tau));
            end
            nNewInfecteds = nInfecteds*(c_Rstart^(1/b_tau)-1);
            if (c_Rstart < 1)
%                 nNewInfecteds = nInfecteds;
                nNewInfecteds = -nNewInfecteds;
            end
        end
        
        function [nDeseased, nInfecteds, nNewInfecteds, Re] = deceaseModel(t,a_n0,b_tau,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2,h_dDelay,i_dVariance,j_ifr)
            N = length(t);
            [nNewInfecteds, nInfecteds, Re] = Model.infectModel(t,a_n0,b_tau,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2);
            t=t(:);
%             deathPdf = normpdf(1:length(t), h_dDelay, 5)';
            deathPdf = lognpdf(1:length(t), log(h_dDelay), i_dVariance)';
            nDeseased = 0.01*conv(deathPdf, nNewInfecteds);
            nDeseased = nDeseased(1:length(t));

%             nDeseased = zeros(N,1);
%             for nd = 1:length(t)
%                 if (nd < N-38)
%                     nDeseased(nd:nd+40-1) = nDeseased(nd:nd+40-1) + j_ifr * nNewInfecteds(nd)*deathPdf;
%                 else
%                     nLeft = N - nd;
%                     nDeseased(nd:nd+nLeft) = nDeseased(nd:nd+nLeft) + 0.01*nNewInfecteds(nd)*deathPdf(1:nLeft+1);
%                 end
%             end
        end
        
        function result = zeroCrossing(y)
            try
                zc = find(y(:).*circshift(y(:), [-1 0]) <= 0);
                result = zc(1);
            catch
                result = -1;
            end
        end
        
    end
    
end

