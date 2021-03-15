function Re = Re_sigmoid(t, Rstart, Rend, tOnset, slope, slope2)
    onsetShifted = tOnset + log(-1+1/0.01)/slope;
    Re = (-1./(1 + exp(-slope.*(t-(onsetShifted))))+1)*(Rstart-Rend)+Rend;
end

