function Re = Re_sigmoid(t, Rstart, Rend, tOnset, slope, slope2)
    Re = (-sigmoid(t,tOnset,slope)+1)*(Rstart-Rend)+Rend;
end

