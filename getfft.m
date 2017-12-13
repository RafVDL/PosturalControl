function [f, P1] = getfft(data, window)
    Fs = 250;
    T = 1/Fs;
    L = length(data);
    switch (window)
        case Window.Bartlett
            windowData = data .* bartlett(L);
        case Window.Blackman
            windowData = data .* blackman(L);
        case Window.Boxcar
            windowData = data .* boxcar(L);
        case Window.Hamming
            windowData = data .* hamming(L);
        case Window.Hann
            windowData = data .* hann(L);
        case Window.Taylor
            windowData = data .* taylorwin(L);
        case Window.Triang
            windowData = data .* triang(L);
        otherwise
            windowData = data;
    end
    Y = fft(windowData);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    t = 1:L;
end