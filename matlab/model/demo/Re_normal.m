function Re = Re_normal(t, Rstart, Rend, tOnset, slope, slope2)

%     tOnsett = 200;
    tOnsett = tOnset;
    normDist = -cumsum(((t-tOnsett)<0).*normpdf((t-tOnsett)*slope) + ((t-tOnsett)>=0).*normpdf((t-tOnsett)*slope2));
    Re = (normDist - min(normDist))/(max(normDist)-min(normDist));

%     tShift = tOnsett - sum((Re > 0.99))
%     tOnsett = tOnsett+tShift;
% 
%     normDist = -cumsum(((t-tOnsett)<0).*normpdf((t-tOnsett)*slope) + ((t-tOnsett)>=0).*normpdf((t-tOnsett)*slope2));
%     Re = (normDist - min(normDist))/(max(normDist)-min(normDist));
%     interp1(Re(Re>0 & Re<1),t(Re>0 & Re<1),0.99)
    
%     
    Re = Rend+Re*(Rstart-Rend);
%     Re = [Rstart*ones(1,tOnset) Re(70:end) Rend*ones(1,70-tOnset-1)];

end
