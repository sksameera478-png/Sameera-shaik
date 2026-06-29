% 4-Tap Low Pass FIR Filter Design
Fs = 1000; % Sampling Frequency 1kHz
Fc = 100; % Cutoff Frequency 100Hz
N = 4; % Filter order = 4, so 4 taps

% Generate coefficients using Hamming window
b = fir1(N-1, Fc/(Fs/2), 'low', hamming(N));

% Quantize to 8-bit signed fixed point for FPGA
b_quantized = round(b * 2^7); % Q1.7 format

% Display for Verilog
fprintf('parameter h0 = 8''sd%d;\n', b_quantized(1));
fprintf('parameter h1 = 8''sd%d;\n', b_quantized(2));
fprintf('parameter h2 = 8''sd%d;\n', b_quantized(3));
fprintf('parameter h3 = 8''sd%d;\n', b_quantized(4));
