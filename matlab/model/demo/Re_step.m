function Re = Re_step(t, Rstart, Rend, tOnset, slope, slope2)

    stepSize = (Rstart-Rend)/slope;
    Re = -t*slope + slope*tOnset + Rstart;
    Re(t<tOnset) = Rstart;
    Re(t>(tOnset+stepSize)) = Rend;
%     Re = ones(size(t));
% 
%     step = linspace(Rstart, Rend, slope);
%     onsetIndex = 
% 
%     Re(t < tOnset + slope/2) = Rstart;
%     Re(t >= tOnset - slope/2) = Rend;
    
%     Re(t >= tOnset & t < (tOnset+slope)) = linspace(Rstart, Rend, slope);
%     Re(t >= (tOnset+slope)) = Rend;
end

