clear all 
clc

%% Zad1
x = 0:0.01:499.99;
a=0.01;
b = 1;
linia = a*x + b;
%sin = 1*sin(pi*x*0.25 + 0.5);

A = [1, -0.5, 0.2];  
B = [1,  0.4];        

N = 50000;
rng(0);
e = randn(N,1);  

arma = filter(B, A, e);
figure;
freqz(B, A, N, 1/0.01);
grid on;
title('Charakterystyka amplitudowa ARMA');

f_sin = 1;           
A_sin = 1;                
phi = 0.5;                

sinus = A_sin * sin(2*pi*f_sin*x + phi);
arma = arma';
suma = linia+sinus+arma;

plot(x, suma)