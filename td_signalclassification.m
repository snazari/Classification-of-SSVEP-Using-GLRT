%Sam Nazari
%May 2014

%Detection of SSVEP Signal - Time Domain
%Assumption: 
% - Deterministic signal with unknown amplitude
% - Noise with unknown variance
% - SSVEP for frequencies: 6 Hz and 8.2 Hz
%Hypothesis
%H0: x[n]=A0.s0[n]+w0[n]
%H1: x[n]=A1.s1[n]+w1[n]

clear all, clc, close all

sb=5;       %Subjects
ntrial=40;  %Number of trials
correct_det=[];
mean_correct_det=[];
for p=1:sb
    eval(['load S',num2str(p),'_mt.mat'])   %Loading data
    f=dat.tf; fi=[1 5]; %Target frequencies
    Fs=dat.fs;  %Sample rate
    ac=[];
    cm=0;
    for m=1:length(fi)  %Evaluating for each frequency
        c=0;    %Counter of correct detection
        for k=1:ntrial
            %Theoretical signal
            N=1024;                     %Samples
            n=0:N-1;                    %Points
            s0=cos(2*pi*f(fi(1))*n/Fs); %Signal s0
            s1=cos(2*pi*f(fi(2))*n/Fs); %Signal s1
            %Observations
            eval(['x=dat.de',num2str(fi(m)),'((k-1)*N+1:k*N);']) 
            x=x';
            %MLE of amplitude
            A0_MLE=x*s0'/(s0*s0');
            w0=x-A0_MLE*s0;
            A1_MLE=x*s1'/(s1*s1');
            w1=x-A1_MLE*s1;
            %Estimate of noise variance
            var_w0=var(w0);
            var_w1=var(w1);
            %GLRT test
            Ts=(var_w0/var_w1)^N>1;
            if m==1
                c=c+1-Ts;
            else
                c=c+Ts;
            end
        end
        cm=cm+1;
        ac(cm)=c/ntrial*100;
    end
    correct_det(p,:)=ac;
    mean_correct_det(p,1)=mean(ac);  %Mean of right detection by subject  
end
disp('      Time Domain Approach')
disp('Correct Detections per user (%)')
disp('    6Hz       8.2Hz      Total')
disp([correct_det mean_correct_det]) %Results for each test subject  