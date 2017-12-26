function [fftFreqVector, P1] = getfft(data, Fs, window)
    L = length(data);       % Length of the time domain signal
    
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
    if(rem(L,2) == 0)                   % Fft of even amount of points => (f0 and fN/2+1 are unique)
        P1 = Y(1:L/2+1);                % P1 is single side of spectrum
        P1(2:end-1) = 2*P1(2:end-1);
    else                                % Fft of even amount of points => (f0 is unique)
        P1 = Y(1:round(L/2));           % P1 is single side of spectrum
        P1(2:end) = 2*P1(2:end);
    end

    fftFreqVector = Fs*(0:(L/2))/L;     % frequency vector
end