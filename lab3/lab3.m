clear all 
clc
%% Zad1
A = 1;
t = 0:0.01:10;
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
plot(psin,'o')

%% Zad2
A = [1 -0.5 -0.7 0.5];  
B = [0.7 0.3];

y100 = filter(B,A,p100); 
plot(y100);

y1000 = filter(B,A,p1000);
plot(y1000)

ysin = filter(B,A,psin);
plot(ysin)

w100  = randn(size(y100))  * sqrt(0.1 * var(y100));
w1000 = randn(size(y1000)) * sqrt(0.1 * var(y1000));
wsin  = randn(size(ysin))  * sqrt(0.1 * var(ysin));


%% Zad3 
N = length(w100); % liczba pomiarów
M = 5; % liczba parametrów
for i=1:N-M
    for j=1:M+1
        U(i,j) = w100(N+2-j-i);
    end

end

