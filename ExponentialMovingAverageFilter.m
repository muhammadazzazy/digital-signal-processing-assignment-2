function ExponentialMovingAverageFilter(inputFileName, M, a, outputFileName)
%inputFileName is the file name of an input audio file
%M is the moving average window size
%a is a parameter
%outputFileName is the file name of the output filtered audio file
%The impulse response of the exponential moving average filter
h = zeros(M,1);
L = (M - 1) / 2;
den = 0;
for i = -L:L
    den = den + (1 - a)^(abs(i));
end
for n = 1:M
    if(n < (M + 1) / 2)
        num = (1 - a)^(abs(((M + 1) / 2) - n));
    end
    h(n) = num / den;
end
%Reads from an input audio file
%x is the vector signal for the input
%Fs is the sampling frequency of the audio input signal
[x, Fs] = audioread(inputFileName);
y = conv(x, h);
%To adjust for the attenuation that occurs after filtering, scale the output obtained after filtering to have
%the same maximum value as the input audio.
for k = 1:length(y)
    if(y(k) < 0)
        if(y(k) < -max(x))
            y(k) = -max(x);
        end
    else
        if(y(k) > max(x))
            y(k) = max(x);
        end
    end
end
%Writes to the output filtered audio file
audiowrite(outputFileName, y, Fs);
end