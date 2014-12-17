% Continuous wavelet tranform using the morlet wavelet
%
% Syntax:
% coeffs = morlet_wavelet(thedata,sr,freqs);
% 
% Input:
% thedata   - the signal
% sr        - sampling rate of the signal
% freqs     - vector containing the frequency values for which the 
%               coefficientsN will be calculated
%
%
% Written by Ian David Blum 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 z0 = 5;
    
    isodd = mod(length(thedata),2)==1;
    if isodd
        thedata = thedata(1:end-1);
    end
    if size(thedata,1)==1
        thedata = thedata';
    end
    fftd = fft(thedata);
    CWT = zeros(length(thedata),length(freqs));
    
    
    
    for ii = 1:length(freqs);
        x = [0:length(thedata)/2,-length(thedata)/2+1:-1]';
        x = x*freqs(ii)/sr;
        morletwavelet = (cos(2*pi*x) + 1i*sin(2*pi*x)).* ...
            exp(-2*x.^2*pi^2/z0^2) - exp(-z0^2/2-2*x.^2*pi^2/z0^2);
        CWT(:,ii) = ifft(fftd.*fft(morletwavelet));
        display(['frequency: ' num2str(ii)]);
    end
    CWT = CWT';
    if isodd
        CWT = [CWT,CWT(:,end)];
    end
end
