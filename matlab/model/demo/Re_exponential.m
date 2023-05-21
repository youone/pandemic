function Re = Re_exponential(t, Rstart, Rend, tOnset, slope, slope2)
    Re = Rend + (Rstart-Rend)*exp(-slope*(t-tOnset));
    Re(t<=tOnset) = Rstart;
end
