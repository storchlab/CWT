%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Description: 
% Import the raw locomotor activity (or other) data in one minute bins
% ensuring that first day of the file is padded backwards to midnight and 
% the last day is padded forward to 11:59 PM with zeros.
% raw data should be imported into a vector called "thedata".
% 
% Input:
% thedata   - the signal
% sr        - sampling rate of the signal
% freqs     - vector containing the frequency values for which the 
%               coefficientsN will be calculated
% min/maxcyc- the frequency range of interest in cycles per day
% freqs     - vector containing the frequency values for which the coefficients
%         will be calculated

% Written by Ian David Blum 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

first=input('Enter the first day of the record to use');
last=input('Enter the last day of the record to use');
be=1;
nd=last-first+1;
a=be;b=nd;
% this is only necessary if you want to normalize to a baseline period
% for better visualization of any changes due to manipulation. Replace the
% variable a and b with the following lines if you do:
% a=input('Enter the first day of the record to use for baseline');
% b=input('Enter the last day of the record to use for baseline');

%determines the frequency range of interest in cycles/day
mincyc=2.4; %10 hour period
maxcyc=24; %1 hour period


% imput the sampling rate (per day) given you have one value for
% every minute
sr = 60*24;
%trim first and last day off records
thedata=thedata((first-1)*sr+1:last*sr);
% input vector representing frequency range of interest
freqs=linspace(mincyc,maxcyc,300);
freqslog=logspace(log10(mincyc),log10(maxcyc),300);
% input a vector for the time (in days)
time=(1:length(thedata))/sr;

% Run Morlet CWT on data
CWT=morlet_wave_IDB(thedata,sr,freqs);
CWTabs=abs(CWT);

% converting CWT to dB scaling
CWTdB=zeros(size(CWT));
meanCWTfreq=mean(CWT(:,(a-1)*sr+1:b*sr),2);
SDCWTfreq=std(CWT(:,a*sr:b*sr),0,2);
for p=1:size(CWT,1);
    for q=1:size(CWT,2);
    CWTdB(p,q)=(CWT(p,q)-meanCWTfreq(p))/(SDCWTfreq(p));
    end
end
maxCWTdb=max(CWTdB(:,a*sr:b*sr),[],2);
for p=1:size(CWT,1);
    for q=1:size(CWT,2);
    CWTdB(p,q)=CWTdB(p,q)./maxCWTdb(p);
    end
end
    
    
%% plotting the data in a linear trace.

figure
plot(time,thedata)
ylabel('Activity (rpm)');
xlabel('Time (Days)');
title(strcat('Activity Profile'));
xlim([0 max(time)]);

%%  Plotting CWT

% colormap of the CWTdB
clims=[0 1];
figure
imagesc(time,freqs,abs(CWTdB),clims);
set(gca,'YDir','normal')
ylabel('Frequency (Cycles/Day)');
xlabel('Time (Days)');
title(strcat('CWT'));
colorbar
hold on

%% defining the wavelet ridges

[maxamp,ridgeind]=max(abs(CWTdB(:,(be-1)*sr+1:nd*sr)));
ridge=freqs(ridgeind);
for n=1:length(ridge)
if ridge(n) < (mincyc+0.1)
    ridge(n)=NaN;
elseif ridge(n) > (maxcyc-0.1)
    ridge(n)=NaN;
end
end 
plot(time,ridge,'marker','.','linestyle','none','markeredgecolor',[0 0 0]);
set(gca,'YDir','normal')
hold on

%% calculating the average and standard deviation
ridgeper=24./ridge;
aperiod=nanmean(ridgeper);
astddev=nanstd(ridgeper);

S1=sprintf('Period= %.2fHrs StDev= %.2fHrs',aperiod,astddev);
text(5,25,S1,'Fontsize',10)
