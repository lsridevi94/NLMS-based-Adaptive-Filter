clear all;
clc;
%ecg: Clean ECG signal
%no: The reference noise
%ecgn: Noised ECG Signal
load('ecg.mat'); 

%Initializing variables for function call
org=ecg;%org-original signal
x=no;%x-reference input, here the reference to noise
d=ecgn;%d-desired or primary input, here the signal plus noise
N=input('Enter the filter order: ');%N-no. of taps i.e., filter length or order
figure; subplot(3,1,1); plot(ecg);
    title('Pure ECG Signal');
    xlabel('Sample Index');
    ylabel('Amplitude(mV)');
    
subplot(3,1,2); plot(ecgn);
    title('ECG Signal with Noise');
    xlabel('Sample Index');
    ylabel('Amplitude(mV)');
subplot(3,1,3); 
%mu-step-size or convergence parameter usually 
%(i) 0<mu<1/lambdam where lambdam is the largest diagonal value of eignvalue matrix of autocorrelation matrix of x or 
autocorr_x=corrmtx(x,N,'autocorrelation');
ac_x=toeplitz(autocorr_x);
eig_x=eig(ac_x);
lambda_m1=max(eig_x);
mu1=1/lambda_m1;

%(ii) 0<mu<(1/N*Sxm) where Sxm-maximum of PSD of x or
p_x=periodogram(x);
Sxm=max(p_x);
mu2=1/((N*(Sxm+0.1)));

%(iii) 0<mu<(1/N*Px),where Px-signal power of x or approximately 
Px=norm(x)^2/length(x);
mu3=1/((N*(Px+0.01)));

%(iv) 0<mu<1;
mu4=0.01;

%lower the mu value, better the noise removal but slower the speed of
%convergence and VICE VERSA. 
%Add a small positive value < 0.1 to
%denominator of (ii) and (iii) in order to avoid division-by-zero in case of zero signal power

alpha=0.9;%alpha-small positive real value approximately 0<alpha<1, closer to unity

W_ini=randn(N,1);%W_ini-initial weight vector
X_ini=rand(N-1,1);%X_ini-initial state vector i.e., initial values of reference input

mu=input('Enter a number, either 1,2,3 or 4: ');
switch mu
    case 1
        nlms2(org,x,d,N,mu1,alpha,W_ini,X_ini)
    case 2
        nlms2(org,x,d,N,mu2,alpha,W_ini,X_ini)
    case 3
        nlms2(org,x,d,N,mu3,alpha,W_ini,X_ini)
    case 4
        nlms2(org,x,d,N,mu4,alpha,W_ini,X_ini)
    otherwise
        disp('Invalid Input')
end

        
    
