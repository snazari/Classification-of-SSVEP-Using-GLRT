%Sam Nazari
%May 2014

%Detection of SSVEP Signal - Frequency Domain
%Assumption: 
% - Constant signal with unknown value
% - Noise with unknown variance
% - SSVEP for frequencies: 6 Hz and 8.2 Hz
%Hypothesis
%H0: x[n]=A0+w0[n]
%H1: x[n]=A1+w1[n]

sb=5;       %Subjects
ntrial=40;  %Number of trials
win=0.5;
correct_det=[];
mean_correct_det=[];
for p=1:sb
    eval(['load S',num2str(p),'_mt.mat'])   %Loading data
    tf=dat.tf; tfi=[1 5]; %Target frequencies
    Fs=dat.fs;          %Sample rate  
    N=1024;                     %Samples
    f=linspace(0,1,N)*Fs;  %Frequencies
    %Calculating means and variance
    for m=1:length(tfi)
        eval(['powv',num2str(m),'=[];'])
        for k=1:32
            eval(['x=dat.de',num2str(tfi(m)),'((k-1)*N+1:k*N);'])
            X=abs(fft(x,N));        %Frequency analysis
            %Taking the magnitude for the target frequencies
            for j=1:length(tfi)
                eval(['powv',num2str(m),'(k,j)=(cpow(X,f,tf(tfi(j)),win)+cpow(X,f,2*tf(tfi(j)),win))/2;'])
            end
        end
        eval(['m',num2str(m),'=mean(powv',num2str(m),');']) %Calculating the mean
        eval(['v',num2str(m),'=var(powv',num2str(m),');'])  %Calculating the var
        %Calculating the covariance matrix
        %Assuming that magnitudes of each frequency are uncorrelated 
        eval(['C',num2str(m),'=diag(v',num2str(m),');'])    
    end
   %GLRT
    ac=[];
    cm=0;
    for m=1:length(tfi)  %Evaluating for each frequency
        X=[];
        c=0;    %Counter of correct detection
        for k=33:40
            %Observations
            eval(['x=dat.de',num2str(tfi(m)),'((k-1)*N+1:k*N);']) 
            Xf=abs(fft(x,N));        %Frequency analysis
            %Taking the magnitude for the target frequencies
            for j=1:length(tfi)
                X(j)=(cpow(Xf,f,tf(tfi(j)),win)+cpow(Xf,f,2*tf(tfi(j)),win))/2;
            end
            %GLRT test
            %Assuming equal prior probabilities
            Ts=((X-m1)*inv(C1)*(X-m1)'>(X-m2)*inv(C2)*(X-m2)'+log(det(C2)/det(C1)));
            %Counting correct detections
            if m==1
                c=c+1-Ts;
            else
                c=c+Ts;
            end
        end
        cm=cm+1;
        ac(cm)=c/8*100; %Percentage of correct detections
    end
    correct_det(p,:)=ac;
    mean_correct_det(p,1)=mean(ac); %Mean of right detection by subject
end
disp('   Frequency Domain Approach')
disp('Correct Detections per user (%)')
disp('    6Hz       8.2Hz      Total')
disp([correct_det mean_correct_det]) %Results for each test subject  