%Sam Nazari
%May 2014

%Rearrange of the data
rearrange

%Detection of SSVEP signal - Time Domain
%Assumption: 
% - Deterministic signal with unknown amplitude
% - Noise with unknown variance
% - SSVEP for frequencies: 6 Hz and 8.2 Hz
%Hypothesis
%H0: x[n]=A0.s0[n]+w0[n]
%H1: x[n]=A1.s1[n]+w1[n]
td_signalclassification

%Detection of SSVEP Signal - Frequency Domain
%Assumption: 
% - Constant signal with unknown value
% - Noise with unknown variance
% - SSVEP for frequencies: 6 Hz and 8.2 Hz
%Hypothesis
%H0: x[n]=A0+w0[n]
%H1: x[n]=A1+w1[n]
fd_signalclassification
