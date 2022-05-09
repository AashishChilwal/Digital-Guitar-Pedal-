%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 362 Project Template File
% student name: Aashish Chilwal
% student number: 86923679
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all,  clear, clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import audio data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y = importdata('ENGR_362_guitar_Fs_is_48000_Hz.txt');
Fs = 48000;                             % sampling freq

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Play sound of raw audio data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
soundsc(y,Fs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graph in time domain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ts = 1/Fs;                              % sampling period       
Length_y = length(y(:,1));              % length of signal
time = (0:Length_y-1)*Ts;               % time vector
figure,plot(time,y), axis tight
title('y(t) vs t')                      % labels
xlabel('t (s)')                         % labels
ylabel('y(t)')                          % labels

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graph with DFT/FFT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DFT = fft(y);                             % Discrete Fourier transform
Figure_1 = abs(DFT/Length_y);                   % frequency
Figure_2 = Figure_1(1:Length_y/2+1);                % half of frequency
Figure_2(2:end-1) = 2*Figure_2(2:end-1);            % Discrete Fourier transform
freq_vector = Fs*(0:(Length_y/2))/Length_y;       % freq vector [Hz]
freq_kHz = freq_vector/1000;                         % freq vector [kHz]
figure,plot(freq_kHz,Figure_2)                   % plot 
axis([0  max(freq_kHz) 0 max(Figure_2)])         % axis details
title('Y(F) vs F')                           % labels
xlabel('F (kHz)')                       % labels
ylabel('Y(F)')                          % labels

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% D major chord frequencies for notes D3, A3, D4, F#4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D3 = 146.83;                            % freq of note D3 [Hz]
D3_int = round(D3/max(freq_vector)*length(freq_vector)) ;    % associated integer to above freq
A3 = 220.00;                            % freq of note A3 [Hz]
A3_int = round(A3/max(freq_vector)*length(freq_vector));    % associated integer to above freq
D4 = 293.66;                            % freq of note D4 [Hz]
D4_int = round(D4/max(freq_vector)*length(freq_vector));     % associated integer to above freq
F_sharp_4 = 369.99;                     % freq of note F#4 [Hz]
F_sharp_4_int = ...
    round(F_sharp_4/max(freq_vector)*length(freq_vector));   % associated integer to above freq

note_freq = [D3 A3 D4 F_sharp_4];       % vector of all note freqs
note_freq_int = ...
  [D3_int A3_int D4_int F_sharp_4_int]; % vector of all int note freqs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loop to apply filter bank
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Please continue writing code from here...
Nfreq = Fs/2;                              % defining the Nyquist Frequency
order_1 = [4 7 8 8];                      % Initializing an order
Rp=6;
chord = [D3 A3 D4 F_sharp_4];           % Placing chords in a matrix
for i=1:4                               % Initializing for loop
    n = order_1(i);
    FcLPF = chord(i)+5;
    FcHPF = chord(i)-5;
    Wp = FcLPF/Nfreq;
    Wp1 = FcHPF/Nfreq;
    [high,low] = cheby1(n,Rp,Wp,"high");  
    [b,a] = cheby1(n,Rp,Wp1,"low");
   figure,freqz(high,low)
   figure,freqz(b,a)
    if i == 1
       D3filter = filter(b,a, filter(high,low,y));
    elseif i == 2
        A3filter = filter(b,a, filter(high,low,y));
    elseif i == 3
        D4filter = filter(b,a, filter(high,low,y));
    else
        F4filter = filter(b,a, filter(high,low,y));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% graphing individual frequencies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


DFT = fft(D3filter);                      % Discrete Fourier transform
Figure_1 = abs(DFT/Length_y);                   % frequency
Figure_2 = Figure_1(1:Length_y/2+1);                % half of frequency
Figure_2(2:end-1) = 2*Figure_2(2:end-1);            % Discrete Fourier transform
freq_vector = Fs*(0:(Length_y/2))/Length_y;       % freq vector [Hz]
freq_kHz = freq_vector/1000;                         % freq vector [kHz]
figure,plot(freq_kHz,Figure_2)                   % plot 
axis([0  0.4 0 max(Figure_2)])                % axis details
title('D3 vs F')                        % labels
xlabel('F (kHz)')                       % labels
ylabel('D3(F)')                         % labels
maxD3 = max(Figure_2);

DFT = fft(A3filter);                      % Discrete Fourier transform
Figure_1 = abs(DFT/Length_y);                   % frequency
Figure_2 = Figure_1(1:Length_y/2+1);                % half of frequency
Figure_2(2:end-1) = 2*Figure_2(2:end-1);            % Discrete Fourier transform
freq_vector = Fs*(0:(Length_y/2))/Length_y;       % freq vector [Hz]
freq_kHz = freq_vector/1000;                         % freq vector [kHz]
figure,plot(freq_kHz,Figure_2)                   % plot 
axis([0  0.4 0 max(Figure_2)])                % axis details
title('A3 vs F')                        % labels
xlabel('F (kHz)')                       % labels
ylabel('A3(F)')                         % labels
maxA3 = max(Figure_2);


DFT = fft(D4filter);                      % Discrete Fourier transform
Figure_1 = abs(DFT/Length_y);                   % frequency
Figure_2 = Figure_1(1:Length_y/2+1);                % half of frequency
Figure_2(2:end-1) = 2*Figure_2(2:end-1);            % Discrete Fourier transform
freq_vector = Fs*(0:(Length_y/2))/Length_y;       % freq vector [Hz]
freq_kHz = freq_vector/1000;                         % freq vector [kHz]
figure,plot(freq_kHz,Figure_2)                   % plot 
axis([0  0.4 0 max(Figure_2)])                % axis details
title('D4 vs F')                        % labels
xlabel('F (kHz)')                       % labels
ylabel('D4(F)')                         % labels
maxD4 = max(Figure_2);

DFT = fft(F4filter);                      % Discrete Fourier transform
Figure_1 = abs(DFT/Length_y);                   % frequency
Figure_2 = Figure_1(1:Length_y/2+1);                % half of frequency
Figure_2(2:end-1) = 2*Figure_2(2:end-1);            % Discrete Fourier transform
freq_vector = Fs*(0:(Length_y/2))/Length_y;       % freq vector [Hz]
freq_kHz = freq_vector/1000;                         % freq vector [kHz]
figure,plot(freq_kHz,Figure_2)                   % plot 
axis([0  0.4 0 max(Figure_2)])                % axis details
title('F4 vs F')                        % labels
xlabel('F (kHz)')                       % labels
ylabel('F4(F)')
maxF4 = max(Figure_2);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Normalizing the Signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Normalized_Total = D3filter/maxD3 + A3filter/maxA3 + D4filter/maxD4 + F4filter/maxF4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graphing total normalized signal in frequency domain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DFT = fft(Normalized_Total);               % Discrete Fourier transform
Figure_1 = abs(DFT/Length_y);                   % frequency
Figure_2 = Figure_1(1:Length_y/2+1);                % half of frequency
Figure_2(2:end-1) = 2*Figure_2(2:end-1);            % Discrete Fourier transform
freq_vector = Fs*(0:(Length_y/2))/Length_y;       % freq vector [Hz]
freq_kHz = freq_vector/1000;                         % freq vector [kHz]
figure,plot(freq_kHz,Figure_2)                   % plot 
axis([0 0.6 0 max(Figure_2)])         % axis details
title('Normalized Y(F) vs F')                           % labels
xlabel('F (kHz)')                       % labels
ylabel('Y(F)')
