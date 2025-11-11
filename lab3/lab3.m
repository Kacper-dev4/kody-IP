clear all 
clc
%% Zad1
A = 1;
t = 0:0.1:9.9;
t2 = 0:0.01:9.99;
p100 = (rand(1,100)-0.5)*2;
p1000 = (rand(1,1000)-0.5)*2;

p100(p100<0) = -A;
p100(p100>=0) = A;

p1000(p1000<0) = -A;
p1000(p1000>=0) = A;

%fazy  = rand(1,6)*2*pi;
fazy = load("fazy.mat");
fazy = fazy.fazy;
psin = A*sin(pi*t*0.24 + fazy(1)) + A*sin(pi*t*0.42+ fazy(2)) + A*sin(pi*t*0.14+ fazy(3)) + A*sin(pi*t*0.74+ fazy(4)) + A*sin(pi*t*0.36+ fazy(5)) + A*sin(pi*t*0.66+ fazy(6));
psin1000 = A*sin(pi*t2*0.24 + fazy(1)) + A*sin(pi*t2*0.42+ fazy(2)) + A*sin(pi*t2*0.14+ fazy(3)) + A*sin(pi*t2*0.74+ fazy(4)) + A*sin(pi*t2*0.36+ fazy(5)) + A*sin(pi*t2*0.66+ fazy(6));



%% Zad2
A = [ 1 -0.5 -0.7 0.5];  
B = [ 0 0 0.7 0.3];

y100 = filter(B,A,p100);
figure(1)
plot(y100);

y1000 = filter(B,A,p1000);
figure(2)
plot(y1000)

ysin = filter(B,A,psin);
figure(3)
plot(ysin)

ysin1000 = filter(B,A,psin1000);
figure(4)
plot(ysin1000)

w100  = y100 + randn(size(y100))  * sqrt(0.1 * var(y100));
w1000 = y1000 + randn(size(y1000)) * sqrt(0.1 * var(y1000));
wsin  = ysin + randn(size(ysin))  * sqrt(0.1 * var(ysin));
wsin1000  = ysin1000 + randn(size(ysin1000))  * sqrt(0.1 * var(ysin1000));



%% Zad3 

M =length(y100);
N = 10;

U = zeros(M-N+1, N);
for k = N:M
    U(k-N+1,:) = p100(k:-1:k-N+1);
end
y = w100(N:M)';    
b100 = (U' * U) \ (U' * y);

J 100 = sum((U*b100-y).^2)/100;


 [Ryu, lags] = xcorr(w100, p100, 'unbiased');
 [Ruu, ~] = xcorr(p100, p100, 'unbiased');
 Ruu_matrix = toeplitz(Ruu(length(p100):length(p100)+N-1));
 Ryu_vector = Ryu(length(p100):length(p100)+N-1)';
 kore100 = Ruu_matrix \ Ryu_vector;

x = (0:N-1)';

impulosowaPrawdziwa = impz(B, A, N);  
figure(5)
stem(x,impulosowaPrawdziwa(), 'b');
hold on;
stem(x,b100, 'r--');
stem(x,kore100,'o--')
legend('Wzorzec','MNK','Korelacyjna');
xlabel('n'); ylabel('h[n]');


M =length(y1000);
N = 10;

U = zeros(M-N+1, N);
for k = N:M
    U(k-N+1,:) = p1000(k:-1:k-N+1);
end
y = w1000(N:M)';    
b1000 = (U' * U) \ (U' * y);

D1000 = sum((U*b1000-y).^2)/1000;

x = (0:N-1)';

figure(6)
stem(x,impulosowaPrawdziwa, 'b');
hold on;
stem(x,b1000, 'r--');
legend('Wzorzec', 'MNK');
xlabel('n');
ylabel('h[n]');




 






