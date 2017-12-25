clear
clc

Fs = 1000;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = 500;             % Length of signal
t = (0:L-1)*T;        % Time vector
window = 4;

S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
X = S;% + 2*randn(size(t));

figure(1)
plot(Fs*t,X)
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('t (milliseconds)')
ylabel('X(t)')

figure(2)
% f = Fs*(0:L-1)/L;
[f, P1] = getfft(X, Fs, window);
plot(f, P1);
title('FFT')

figure(1)
hold on;
% ifftData = ifft(P1);
ifftData = getIfft(f, P1, 0, 140);
t = 1:2:length(ifftData)*2;
plot(t, 275*ifftData)
title('InverseFFT')