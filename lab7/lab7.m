clear all 
clc

%% a)

% 945
wejscie945 = load('wejscie945');
wyjscie945 = load('wyjscie945');


U945 = fft(wejscie945,1024);
Y945 = fft(wyjscie945,1024);

G945 = Y945./U9lab745;

figure;
plot(real(G945(1:513)),imag(G945(1:513)),'o')
xlabel('Re(G)')
ylabel('Im(G)')
title('Charakterystyka Nyquista dla danych 945')
grid on

u = wejscie945;
y = wyjscie945;

Nseg = 1000;               
N = length(u);           
L = floor(N / Nseg);     

Gsum = zeros(1024,1);    

for k = 1:Nseg
    idx_start = (k-1)*L + 1;
    idx_end = idx_start + L - 1;

    u_seg = u(idx_start:idx_end);
    y_seg = y(idx_start:idx_end);

    U_k = fft(u_seg, 1024);
    Y_k = fft(y_seg, 1024);

    G_k = Y_k ./ U_k;

    Gsum = Gsum + G_k;
end

G_avg = Gsum / Nseg;

figure;
plot(real(G_avg(1:513)), imag(G_avg(1:513)), 'o')
xlabel('Re(G)')
ylabel('Im(G)')
title('Charakterystyka Nyquista dla danych 945, przetwarzanie odcinkowe')
grid on
xlim([-0.6,1.2])
ylim([-0.8,0.4])


% 1130
wejscie1130 = load('wejscie1130');
wyjscie1130 = load('wyjscie1130');

U1130 = fft(wejscie1130,1024);
Y1130 = fft(wyjscie1130,1024);

G1130 = Y1130./U1130;

figure;
plot(real(G1130(1:513)),imag(G1130(1:513)),'o')
xlabel('Re(G)')
ylabel('Im(G)')
title('Charakterystyka Nyquista dla danych 1130')
grid on

u = wejscie1130;
y = wyjscie1130;

Nseg = 1000;               
N = length(u);           
L = floor(N / Nseg);     

Gsum = zeros(1024,1);    

for k = 1:Nseg
    idx_start = (k-1)*L + 1;
    idx_end = idx_start + L - 1;

    u_seg = u(idx_start:idx_end);
    y_seg = y(idx_start:idx_end);

    U_k = fft(u_seg, 1024);
    Y_k = fft(y_seg, 1024);

    G_k = Y_k ./ U_k;

    Gsum = Gsum + G_k;
end

G_avg = Gsum / Nseg;

figure;
plot(real(G_avg(1:513)), imag(G_avg(1:513)), 'o')
xlabel('Re(G)')
ylabel('Im(G)')
title('Charakterystyka Nyquista dla danych 1130, przetwarzanie odcinkowe')
grid on
xlim([-0.4,1.2])
ylim([-0.8,0.4])

%% b)

% 945
u945 = wejscie945;
y945 = wyjscie945;

[R_yu, lags] = xcorr(y945, u945, 'biased');
[R_uu, ~]   = xcorr(u945, u945, 'biased');
Ruu0 = max(R_uu);
h = R_yu ./ Ruu0;
idx0 = find(lags == 0);
h_pos = h(idx0:idx0+255);  
H = fft(h_pos, 1024);

figure;
plot(real(H(1:513)), imag(H(1:513)), 'o')
xlabel('Re(G)')
ylabel('Im(G)')
title('Charakterystyka Nyquista dla danych 945')
grid on

Nseg = 1000;               
N = length(u945);           
L = floor(N / Nseg);     

Gsum = zeros(1024,1);    

for k = 1:Nseg
    idx_start = (k-1)*L + 1;
    idx_end = idx_start + L - 1;

    u_seg = u945(idx_start:idx_end);
    y_seg = y945(idx_start:idx_end);

    [R_yu, lags] = xcorr(y_seg, u_seg, 'biased');
    [R_uu, ~]   = xcorr(u_seg, u_seg, 'biased');
    Ruu0 = max(R_uu);
    h = R_yu ./ Ruu0;
    idx0 = find(lags == 0);
    maxLen = length(h) - idx0;  
    K = min(50, maxLen); 
    h_pos = h(idx0:idx0+K);
    h_padded = zeros(1024,1);
    h_padded(1:length(h_pos)) = h_pos;
    H = fft(h_padded);

    Gsum = Gsum + H;
end

G_avg = Gsum / Nseg;

figure;
plot(real(G_avg(1:513)), imag(G_avg(1:513)), 'o')
xlabel('Re(G)')
ylabel('Im(G)')
title('Charakterystyka Nyquista dla danych 945, przetwarzanie odcinkowe')
grid on
xlim([-0.2,1])
ylim([-0.7,0.1])

% 1130
u1130 = wejscie1130;
y1130 = wyjscie1130;

[R_yu, lags] = xcorr(y1130, u1130, 'biased');
[R_uu, ~]   = xcorr(u1130, u1130, 'biased');
Ruu0 = max(R_uu);
h = R_yu ./ Ruu0;
idx0 = find(lags == 0);
h_pos = h(idx0:idx0+255);  
H = fft(h_pos, 1024);

figure;
plot(real(H(1:513)), imag(H(1:513)), 'o')
xlabel('Re(G)')
ylabel('Im(G)')
title('Charakterystyka Nyquista dla danych 1130')
grid on

Nseg = 1000;               
N = length(u1130);           
L = floor(N / Nseg);     

Gsum = zeros(1024,1);    

for k = 1:Nseg
    idx_start = (k-1)*L + 1;
    idx_end = idx_start + L - 1;

    u_seg = u1130(idx_start:idx_end);
    y_seg = y1130(idx_start:idx_end);

    [R_yu, lags] = xcorr(y_seg, u_seg, 'biased');
    [R_uu, ~]   = xcorr(u_seg, u_seg, 'biased');
    Ruu0 = max(R_uu);
    h = R_yu ./ Ruu0;
    idx0 = find(lags == 0);
    maxLen = length(h) - idx0;  
    K = min(50, maxLen); 
    h_pos = h(idx0:idx0+K);
    h_padded = zeros(1024,1);
    h_padded(1:length(h_pos)) = h_pos;
    H = fft(h_padded);

    Gsum = Gsum + H;
end

G_avg = Gsum / Nseg;

figure;
plot(real(G_avg(1:513)), imag(G_avg(1:513)), 'o')
xlabel('Re(G)')
ylabel('Im(G)')
title('Charakterystyka Nyquista dla danych 1130, przetwarzanie odcinkowe')
grid on
xlim([-0.2,1])
ylim([-0.7,0.1])

%% c)

% 945
data945 = iddata(y945, u945, 1);   

na = 3;
nb = 2;
nk = 1;

sys_iv = iv4(data945, [na nb nk]);
[b, a] = tfdata(sys_iv, 'v');
Chtykaaf = fft(b, 1024) ./ fft(a, 1024);

figure;
plot(real(Chtykaaf(1:513)), imag(Chtykaaf(1:513)), 'o')
xlabel('Re(G)')
ylabel('Im(G)')
title('Charakterystyka Nyquista dla danych 945')
grid on

% 1130
data1130 = iddata(y1130, u1130, 1);    

na = 3;
nb = 2;
nk = 1;

sys_iv = iv4(data1130, [na nb nk]);
[b, a] = tfdata(sys_iv, 'v');
Chtykaaf = fft(b, 1024) ./ fft(a, 1024);

figure;
plot(real(Chtykaaf(1:513)), imag(Chtykaaf(1:513)), 'o')
xlabel('Re(G)')
ylabel('Im(G)')
title('Charakterystyka Nyquista dla danych 1130')
grid on




