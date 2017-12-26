function [fftFreqVector, P1] = getfft(data, Fs, window)
    Ts = 1/Fs;              % Sampling period
    L = length(data);       % Length of the time domain signal [s]
    
    switch (window)
        case Window.Bartlett
            windowData = data .* bartlett(L)';
        case Window.Blackman
            windowData = data .* blackman(L)';
        case Window.Boxcar
            windowData = data .* boxcar(L)';
        case Window.Hamming
            windowData = data .* hamming(L)';
        case Window.Hann
            windowData = data .* hann(L)';
        case Window.Taylor
            windowData = data .* taylorwin(L)';
        case Window.Triang
            windowData = data .* triang(L)';
        otherwise
            windowData = data;
    end
    
    Y = fft(windowData, L);
    P2 = Y;                    % P2: Two-sided spectrum
    P1 = P2(1:L/2+1);                 % P1: Single-sided spectrum
    P1(2:end-1) = 2*P1(2:end-1);
    fftFreqVector = Fs*(0:(L/2))/L;   % frequency vector
end