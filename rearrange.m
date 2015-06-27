%Sam Nazari
%May 2014

clear all, clc, close all
tr=2;   %Trials per subject
sb=5;   %Subjects

for i=1:sb
    tf=[];
    deeg=[];
    %Loading data for 2 trials per subject
    for j=1:tr
        s=['Sub',num2str(i),'_',num2str(j),'_multitarget.mat'];
        eval(['D=load(s);']);
        tf=[tf D.Data.TargetFrequency];
        deeg=[deeg D.Data.EEG];
    end
    %Rearranging data, creating vectors for each target frequency
    tar=unique(tf);
    for j=1:length(tar)
        eval(['dat.de',num2str(j),'=[];']);
    end
    for j=1:length(tf)
        ind=find(tar==tf(j));
        eval(['dat.de',num2str(ind),'=[dat.de',num2str(ind),'; deeg(:,j)];'])
    end
    dat.tf=tar;
    dat.fs=D.Data.AmpSamlingFrequency;
    eval(['save S',num2str(i),'_mt.mat dat'])
end
