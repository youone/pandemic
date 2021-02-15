close all

ft = fittype( 'rmodel( x,nstart,serial,Rstart,Rend,dRestr,scale)' )
options = fitoptions(ft);
p1=Rend;%Rend;
p2=R0;%Rstart;
p3=Rrestr;%dRestr;
p4=N0;%nstart;
p5=max(nCases);%scale;
p6=5;%;
options.Lower = [p1-1 0 p3-10 0 0 5];%[N0,5,R0,Rend,Rrestr-10,max(nCases)];
options.Upper = [p1+1 10 p3+10 10 1000 5];%[N0,5,R0,Rend,Rrestr+10,max(nCases)];
options.Startpoint = [p1 p2 p3 p4 p5 p6];%[N0,5,R0,Rend,Rrestr,max(nCases)];
f = fit( nCasesDay', nCases', ft, options)

plot(nCasesDay,nCases,nCasesDay,rmodel(nCasesDay,N0,5,R0,Rend,Rrestr,max(nCases))); hold on
plot(f)
% feval(f,nCasesDay)
% plot(nCasesDay,rmodel,nCasesDay,feval(f,nCasesDay));
