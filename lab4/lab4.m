clear all
clc

%% Zad1 
a = [0.9, 0.2, -0.2, -0.9];
b = [0.9, 0.2, -0.2, -0.9];
% AR
ile = 99;
ya = zeros(length(a),ile);
for i=1:length(a)
for j=0:ile
    ya(i,j+1) = (-a(i))^j;
end

figure(1)
subplot(2,2,i)
stem(0:ile, ya(i,:))
title(sprintf('a1 = %.1f',a(i)))
xlabel('Przesunięcie');
ylabel('Autokorelacja');

end

% MA
yb = zeros(length(b),ile);
for i=1:length(b)
for j=0:ile
if j == 0
    yb(i,1) = 1;
elseif j==1
    yb(i,2) = b(i)/(1+b(i)^2);
else
   yb(i,j+1) = 0;
end
end

figure(2)
subplot(2,2,i)
stem(0:ile, yb(i,:))
title(sprintf('b1 = %.1f',b(i)))
xlabel('Przesunięcie');
ylabel('Autokorelacja');

end

%% Zad2

e = randn(1,100);
a = [1.5, 1.01,0.9,0.2,-0.2,-0.9,-1.01,-1.5];
b = [1.5, 1.01,0.9,0.2,-0.2,-0.9,-1.01,-1.5];



for i = 1:length(a)
    afil = filter(1, [1 a(i)],  e); 
figure(3)
subplot(2,4,i)
stem(0:99, afil)
title(sprintf('a1 = %.2f',a(i)))
xlabel('i');
ylabel('y(i)');
end

for i = 1:length(a)
    bfil = filter([1 b(i)], 1,  e); 
figure(4)
subplot(2,4,i)
stem(0:99, bfil)
title(sprintf('b1 = %.2f',b(i)))
xlabel('i');
ylabel('y(i)');
end

%% Zad3
e2 = randn(1,10000);
e = randn(1,100);

a1 = filter(1, [1 -0.9],  e);    
a2 = filter(1, [1 -0.2],  e);   
a3 = filter(1, [1 +0.2],  e);    
a4 = filter(1, [1 +0.9],  e);  

b1 = filter([1 -0.9], 1,  e);    
b2 = filter([1 -0.2], 1,  e);   
b3 = filter([1 +0.2], 1,  e);    
b4 = filter([1 +0.9], 1,  e); 

[R1, lags1] = xcorr(a1, 'normalized');
[R2, lags2] = xcorr(a2, 'normalized');
[R3, lags3] = xcorr(a3, 'normalized');
[R4, lags4] = xcorr(a4, 'normalized');

figure(5)
subplot(2,2,1)
hold on
stem(lags1(100:end), R1(100:end))
stem(0:ile, ya(4,:))
legend('xcorr','wzory')
title('a1 = -0.9')
subplot(2,2,2)
hold on
stem(lags2(100:end), R2(100:end))
stem(0:ile, ya(3,:))
legend('xcorr','wzory')
title('a1 = -0.2')
subplot(2,2,3)
hold on
stem(lags3(100:end), R3(100:end))
stem(0:ile, ya(2,:))
legend('xcorr','wzory')
title('a1 = 0.2')
subplot(2,2,4)
hold on
stem(lags4(100:end), R4(100:end))
stem(0:ile, ya(1,:))
legend('xcorr','wzory')
title('a1 = 0.9')
xlabel('Przesunięcie');
ylabel('Autokorelacja');

[R1, lags1] = xcorr(b1, 'normalized');
[R2, lags2] = xcorr(b2, 'normalized');
[R3, lags3] = xcorr(b3, 'normalized');
[R4, lags4] = xcorr(b4, 'normalized');

figure(6)
subplot(2,2,1)
hold on
stem(lags1(100:end), R1(100:end))
stem(0:ile, yb(4,:))
legend('xcorr','wzory')
title('b1 = -0.9')
subplot(2,2,2)
hold on
stem(lags2(100:end), R2(100:end))
stem(0:ile, yb(3,:))
legend('xcorr','wzory')
title('b1 = -0.2')
subplot(2,2,3)
hold on
stem(lags3(100:end), R3(100:end))
stem(0:ile, yb(2,:))
legend('xcorr','wzory')
title('b1 = 0.2')
subplot(2,2,4)
hold on
stem(lags4(100:end), R4(100:end))
stem(0:ile, yb(1,:))
legend('xcorr','wzory')
title('b1 = 0.9')
xlabel('Przesunięcie');
ylabel('Autokorelacja');


a1 = filter(1, [1 -0.9],  e2);    
a2 = filter(1, [1 -0.2],  e2);   
a3 = filter(1, [1 +0.2],  e2);    
a4 = filter(1, [1 +0.9],  e2);  

b1 = filter([1 -0.9], 1,  e2);    
b2 = filter([1 -0.2], 1,  e2);   
b3 = filter([1 +0.2], 1,  e2);    
b4 = filter([1 +0.9], 1,  e2); 

[R1, lags1] = xcorr(a1, 'normalized');
[R2, lags2] = xcorr(a2, 'normalized');
[R3, lags3] = xcorr(a3, 'normalized');
[R4, lags4] = xcorr(a4, 'normalized');

figure(7)
subplot(2,2,1)
hold on
stem(lags1(10000:10099), R1(10000:10099))
stem(0:ile, ya(4,:))
legend('xcorr','wzory')
title('a1 = -0.9')
subplot(2,2,2)
hold on
stem(lags2(10000:10099), R2(10000:10099))
stem(0:ile, ya(3,:))
legend('xcorr','wzory')
title('a1 = -0.2')
subplot(2,2,3)
hold on
stem(lags3(10000:10099), R3(10000:10099))
stem(0:ile, ya(2,:))
legend('xcorr','wzory')
title('a1 = 0.2')
subplot(2,2,4)
hold on
stem(lags4(10000:10099), R4(10000:10099))
stem(0:ile, ya(1,:))
legend('xcorr','wzory')
title('a1 = 0.9')
xlabel('Przesunięcie');
ylabel('Autokorelacja');

[R1, lags1] = xcorr(b1, 'normalized');
[R2, lags2] = xcorr(b2, 'normalized');
[R3, lags3] = xcorr(b3, 'normalized');
[R4, lags4] = xcorr(b4, 'normalized');

figure(8)
subplot(2,2,1)
hold on
stem(lags1(10000:10099), R1(10000:10099))
stem(0:ile, yb(4,:))
legend('xcorr','wzory')
title('b1 = -0.9')
subplot(2,2,2)
hold on
stem(lags2(10000:10099), R2(10000:10099))
stem(0:ile, yb(3,:))
legend('xcorr','wzory')
title('b1 = -0.2')
subplot(2,2,3)
hold on
stem(lags3(10000:10099), R3(10000:10099))
stem(0:ile, yb(2,:))
legend('xcorr','wzory')
title('b1 = 0.2')
subplot(2,2,4)
hold on
stem(lags4(10000:10099), R4(10000:10099))
stem(0:ile, yb(1,:))
legend('xcorr','wzory')
title('b1 = 0.9')
xlabel('Przesunięcie');
ylabel('Autokorelacja');

%% Zad4
N2 = 10000;
eN2 = randn(1,N2);
ile = 10000;
% AR 
AR1 = filter(1, [1 -0.2],  eN2);
AR2 = filter(1, [1 -0.5 0.3],  eN2);
AR3 = filter(1, [1 -0.4 0.2 -0.1],  eN2);


figure(9)
subplot(1,3,1)
stem(0:99,AR1(1:100))
xlabel('i');
ylabel('y(i)');
title('AR(1)')

subplot(1,3,2)
stem(0:99,AR2(1:100))
xlabel('i');
ylabel('y(i)');
title('AR(2)')

subplot(1,3,3)
stem(0:99,AR3(1:100))
xlabel('i');
ylabel('y(i)');
title('AR(3)')

 % MA
MA1 = filter([1 -0.3],1,eN2);
MA2 = filter([1 -0.5 0.3], 1,  eN2);
MA3 = filter([1 -0.4 0.2 -0.1], 1,  eN2);
MA5 = filter([1, -0.8, 0.6, -0.4, 0.2, 0.1],1,eN2);

figure(10)
subplot(1,4,1)
stem(0:99,MA1(1:100))
xlabel('i');
ylabel('y(i)');
title('MA(1)')

subplot(1,4,2)
stem(0:99,MA2(1:100))
xlabel('i');
ylabel('y(i)');
title('MA(2)')

subplot(1,4,3)
stem(0:99,MA3(1:100))
xlabel('i');
ylabel('y(i)');
title('MA(3)')


subplot(1,4,4)
stem(0:99,MA5(1:100))
xlabel('i');
ylabel('y(i)');
title('MA(5)')

 % ARMA

 ARMA33 = filter([1, -0.7, -0.04,  0.078], [1, -0.8,  0.21, -0.02],  eN2);
 ARMA13 = filter([1 -0.3], [1 -0.4 0.2 -0.1],  eN2);

 figure(11)
subplot(1,2,1)
stem(0:99,ARMA13(1:100))
xlabel('i');
ylabel('y(i)');
title('ARMA(1,3)')

subplot(1,2,2)
stem(0:99,ARMA33(1:100))
xlabel('i');
ylabel('y(i)');
title('ARMA(3,3)')

%% Zad5
tau = 20;
[R_AR1, lags_AR1] = xcorr(AR1,tau, 'normalized');
par_AR1 = parcorr(AR1,'NumLags',tau);

[R_AR2, lags_AR2] = xcorr(AR2,tau, 'normalized');
par_AR2 = parcorr(AR2,'NumLags',tau);

[R_AR3, lags_AR3] = xcorr(AR3,tau, 'normalized');
par_AR3 = parcorr(AR3,'NumLags',tau);


figure(12)
subplot(1,3,1)
hold on
stem(lags_AR1(21:end), R_AR1(21:end))
stem(lags_AR1(21:end),par_AR1)
xlabel('Przesunięcie')
ylabel('Autokorelacja i korelacja cząstkowa')
legend('autokorelacja','korelacja cząstkowa')
title('AR(1)')

subplot(1,3,2)
hold on
stem(lags_AR2(21:end), R_AR2(21:end))
stem(lags_AR2(21:end),par_AR2)
xlabel('Przesunięcie')
ylabel('Autokorelacja i korelacja cząstkowa')
legend('autokorelacja','korelacja cząstkowa')
title('AR(2)')

subplot(1,3,3)
hold on
stem(lags_AR3(21:end), R_AR3(21:end))
stem(lags_AR3(21:end),par_AR3)
xlabel('Przesunięcie')
ylabel('Autokorelacja i korelacja cząstkowa')
legend('autokorelacja','korelacja cząstkowa')
title('AR(3)')


[R_MA1, lags_MA1] = xcorr(MA1,tau, 'normalized');
par_MA1 = parcorr(MA1,'NumLags',tau);

[R_MA2, lags_MA2] = xcorr(MA2,tau, 'normalized');
par_MA2 = parcorr(MA2,'NumLags',tau);

[R_MA3, lags_MA3] = xcorr(MA3,tau, 'normalized');
par_MA3 = parcorr(MA3,'NumLags',tau);

[R_MA5, lags_MA5] = xcorr(MA5,tau, 'normalized');
par_MA5 = parcorr(MA5,'NumLags',tau);


figure(13)
subplot(1,4,1)
hold on
stem(lags_MA1(21:end), R_MA1(21:end))
stem(lags_MA1(21:end),par_MA1)
xlabel('Przesunięcie')
ylabel('Autokorelacja i korelacja cząstkowa')
legend('autokorelacja','korelacja cząstkowa')
title('MA(1)')

subplot(1,4,2)
hold on
stem(lags_MA2(21:end), R_MA2(21:end))
stem(lags_MA2(21:end),par_MA2)
xlabel('Przesunięcie')
ylabel('Autokorelacja i korelacja cząstkowa')
legend('autokorelacja','korelacja cząstkowa')
title('MA(2)')

subplot(1,4,3)
hold on
stem(lags_MA3(21:end), R_MA3(21:end))
stem(lags_MA3(21:end),par_MA3)
xlabel('Przesunięcie')
ylabel('Autokorelacja i korelacja cząstkowa')
legend('autokorelacja','korelacja cząstkowa')
title('MA(3)')

subplot(1,4,4)
hold on
stem(lags_MA5(21:end), R_MA5(21:end))
stem(lags_MA5(21:end),par_MA5)
xlabel('Przesunięcie')
ylabel('Autokorelacja i korelacja cząstkowa')
legend('autokorelacja','korelacja cząstkowa')
title('MA(5)')


[R_ARMA13, lags_ARMA13] = xcorr(ARMA13,tau, 'normalized');
par_ARMA13 = parcorr(ARMA13,'NumLags',tau);

[R_ARMA33, lags_ARMA33] = xcorr(ARMA33,tau, 'normalized');
par_ARMA33 = parcorr(ARMA33,'NumLags',tau);


figure(14)

subplot(1,2,1)
hold on
stem(lags_ARMA13(21:end), R_ARMA13(21:end))
stem(lags_ARMA13(21:end),par_ARMA13)
xlabel('Przesunięcie')
ylabel('Autokorelacja i korelacja cząstkowa')
legend('autokorelacja','korelacja cząstkowa')
title('ARMA(1,3)')

subplot(1,2,2)
hold on
stem(lags_ARMA33(21:end), R_ARMA33(21:end))
stem(lags_ARMA33(21:end),par_ARMA33)
xlabel('Przesunięcie')
ylabel('Autokorelacja i korelacja cząstkowa')
legend('autokorelacja','korelacja cząstkowa')
title('ARMA(3,3)')

