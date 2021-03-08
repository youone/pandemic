function [n, Re] = iModel(t,a_n0,b_tau,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2)

    N = length(t);
    n = zeros(N,1);
    b_tau = 5;
%     e_tOnset = 10;

    try
        global rmodel
        Re = feval(['Re_' rmodel], t,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2);
    catch
%         Re = Re_sigmoid(t,c_Rstart,d_Rend,e_tOnset,f_slope);
%         Re = Re_step(t,c_Rstart,d_Rend,e_tOnset,f_slope);
%         Re = Re_exponential(t,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2);
        Re = Re_genlog(t,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2);
    end


    % Re = 3*ones(size(n));
%     Re = Re_sigmoid(t,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2);
%       Re = Re_step(t,c_Rstart,d_Rend,e_tOnset,f_slope);
%     Re = Re_exponential(t,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2);
%     Re = Re_genlog(t,c_Rstart,d_Rend,e_tOnset,f_slope,g_slope2);

    n(1) = a_n0;
    for i=1:length(n)-1
        n(i+1) = exp(log(Re(i))/b_tau + log(n(i))); 
    %     if (i+20 < length(n)-1)
    %         d(i+20) = 0.1*n(i+1);
    %     end
    end
end