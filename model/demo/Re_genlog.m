function Re = Re_genlog(t, Rstart, Rend, tOnset, slope, slope2)
    Re = Rstart + (Rend-Rstart)./((1 + exp(-slope.*(t-tOnset))).^(1/slope2));
end
