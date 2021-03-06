function [n,Re] = model(t,n0,tau,Rstart,Rend,tOnset,slope)

    N = length(t);
    n = zeros(1,N);

    % Re = 3*ones(size(n));
%     Re = Re_step(t,Rstart,Rend,tOnset,slope);
    Re = Re_exponential(t,Rstart,Rend,tOnset,slope);

    n(1) = n0;
    for i=1:length(n)-1
        n(i+1) = exp(log(Re(i))/tau + log(n(i))); 
    %     if (i+20 < length(n)-1)
    %         d(i+20) = 0.1*n(i+1);
    %     end
    end

end