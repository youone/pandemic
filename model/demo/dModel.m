function [nDeathsDist, n, Re] = dModel(t,a_n0,b_tau,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2)

    global rmodel

    N = length(t);
    n = zeros(N,1);
    b_tau = 5;

    try
        Re = feval(['Re_' rmodel], t,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2);
    catch
%         Re = Re_sigmoid(t,c_Rstart,d_Rend,e_tOnset,f_slope);
%         Re = Re_step(t,c_Rstart,d_Rend,e_tOnset,f_slope);
%         Re = Re_exponential(t,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2);
        Re = Re_genlog(t,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2);
    end
    
    n(1) = a_n0;
    for i=1:length(n)-1
        n(i+1) = exp(log(Re(i))/b_tau + log(n(i))); 
    end
    
    t=t(:);
    deathPdf = lognpdf(1:40,log(20),0.1)';
    nDeathsDist = zeros(N,1);
    for nd = t'
        if (nd < N-38) 
            nDeathsDist(nd:nd+40-1) = nDeathsDist(nd:nd+40-1) + 0.01*n(nd)*deathPdf;
%         else
%             nLeft = N - nd
%             nd:nd+nLeft
%              nDeathsDist(nd:nd+nLeft)
%             nDeathsDist(nd:nd+nLeft) = nDeathsDist(nd:nd+nLeft) + 0.01*n(nd)*deathPdf(1:nLeft+1);
        end
    end
end