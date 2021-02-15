function [n, t, Re] = rmodel(d,nstart,serial,Rstart,Rend,dRestr,scale)

ndays = length(d);
n=[nstart];
dt=0.001;
t=0:dt:ndays-dt;

Re = (-sigmoid(t,dRestr,0.3)+1)*(Rstart-Rend)+Rend;

for it=1:length(t)-1
    k = log(Re(it))/serial;
    dn = k*(n(it)+0.5*dt)*dt;
    n(it+1)=n(it)+dn;
    it = it+1;
end


n = scale*interp1(t,n,d)/max(n);
Re = interp1(t,Re,d);
t=d;

% mask = find(t-floor(t)==0);
% n=n(mask);
% t=t(mask);
% Re=Re(mask);

end

