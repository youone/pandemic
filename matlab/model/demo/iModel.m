function [nNewCases, Re, nCases] = iModel(t,a_n0,b_tau,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2)

    N = length(t);
    nCases = zeros(N,1);

    try
        global rmodel
        disp(['GLOBAL ' rmodel])
        Re = feval(['Re_' rmodel], t,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2);
    catch
        disp(['DEFAULT sigmoid'])
        Re = Re_sigmoid(t,c_Rstart,d_Rend,e_tOnset,f_slope);
%         Re = Re_step(t,c_Rstart,d_Rend,e_tOnset,f_slope);
%         Re = Re_exponential(t,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2);
%         Re = Re_genlog(t,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2);
    end

    nCases(1) = a_n0;
    for i=1:length(nCases)-1
        nCases(i+1) = nCases(i)*(exp(log(Re(i))/b_tau)); 
%         n(i+1) = exp(log(Re(i))/b_tau + log(n(i))); 
    end
    
    nNewCases = nCases*(c_Rstart^(1/b_tau)-1);

end




