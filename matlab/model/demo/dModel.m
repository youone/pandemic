function [nDeseased, nNewCases, Re, nCases] = dModel(t,a_n0,b_tau,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2)

    global rmodel

    N = length(t);
    nCases = zeros(N,1);
    b_tau = 5;

    try
        Re = feval(['Re_' rmodel], t,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2);
    catch
         Re = Re_sigmoid(t,c_Rstart,d_Rend,e_tOnset,f_slope);
%         Re = Re_step(t,c_Rstart,d_Rend,e_tOnset,f_slope);
%         Re = Re_exponential(t,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2);
%        Re = Re_genlog(t,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2);
    end
    
    nCases(1) = a_n0;
    for i=1:length(nCases)-1
        nCases(i+1) = nCases(i)*(exp(log(Re(i))/b_tau)); 
%         nCases(i+1) = exp(log(Re(i))/b_tau + log(nCases(i))); 
    end
    
    nNewCases = nCases*(c_Rstart^(1/b_tau)-1);

    t=t(:);
    deathPdf = lognpdf(1:40,log(20),0.2)';
    nDeseased = zeros(N,1);
    for nd = t'
        if (nd < N-38) 
            nDeseased(nd:nd+40-1) = nDeseased(nd:nd+40-1) + 0.01*nNewCases(nd)*deathPdf;
        end
    end
    
end