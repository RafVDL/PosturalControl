function [time_data] = getIfft(frequencies, amplitudes, lowerBound, upperBound)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Set amplitudes outside of the frequency bounds to 0
for i = 1:length(frequencies)
    if(frequencies(i) < lowerBound || frequencies(i) > upperBound)
        amplitudes(i) = 0;
    end
end

time_data = real(ifft(amplitudes));
end
