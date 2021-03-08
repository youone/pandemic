function Re = Re_step(t, Rstart, Rend, tOnset, slope, slope2)
    Re = ones(size(t));
    Re(t < tOnset) = Rstart;
    Re(t >= tOnset & t < (tOnset+slope)) = linspace(Rstart, Rend, slope);
    Re(t >= (tOnset+slope)) = Rend;
end

