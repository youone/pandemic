function nDeathsDist = dModel(t,a_n0,b_tau,c_Rstart,d_Rend,e_tOnset,f_slope)

    N = length(t);
    n = zeros(N,1);
    b_tau = 5;
    
    % Re = 3*ones(size(n));
%     Re = Re_step(t,c_Rstart,d_Rend,e_tOnset,f_slope);
    Re = Re_exponential(t,c_Rstart,d_Rend,e_tOnset,f_slope);

    n(1) = a_n0;
    for i=1:length(n)-1
        n(i+1) = exp(log(Re(i))/b_tau + log(n(i))); 
    %     if (i+20 < length(n)-1)
    %         d(i+20) = 0.1*n(i+1);
    %     end
    end
    
    deathPdf = lognpdf(1:40,log(20),0.1)';
    nDeathsDist = zeros(N,1);
    for nd = t'
        if (nd < N-38) 
             nDeathsDist(nd:nd+40-1) = nDeathsDist(nd:nd+40-1) + 0.01*n(nd)*deathPdf;
        end
    end

    size(t)
    size(nDeathsDist)

end