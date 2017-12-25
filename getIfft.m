function [time_data] = getIfft(freqVector, magnitudes, lowerBound, upperBound)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Set amplitudes outside of the frequency bounds to 0
for i = 1:length(freqVector)
    if(freqVector(i) < lowerBound || freqVector(i) > upperBound)
        magnitudes(i) = 0;
    end
end

time_data = real(ifft(magnitudes));
end
