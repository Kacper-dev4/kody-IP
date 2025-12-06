
clear all
clc

%% Zad 1 i 2 
N = 5000;
b0 = 1;
a1 = 1.5;
a2 = 1;
wariancja1 = 1;
wariancja2 = 0.2;
u = sqrt(wariancja1) * randn(1,N);
%u = 2 * ones(1,N);
e = sqrt(wariancja2) * randn(1,N);
y = zeros(1,N);
for i=1:N
    switch i
        case 1
            y(i) = e(i);
        case 2
            y(i) = b0*u(i-1)+e(i)-a1*y(i-1);
        case 1500
            a1 = 0.125;
            a2 = 0.25;
            y(i) = b0*u(i-1)+e(i)-a1*y(i-1)-a2*y(i-2);
        case 2500
            a1 = 1.5;
            a2 = 1;
            y(i) = b0*u(i-1)+e(i)-a1*y(i-1)-a2*y(i-2);
        otherwise
    y(i) = b0*u(i-1)+e(i)-a1*y(i-1)-a2*y(i-2);
    end
end

figure;
plot(y)

%% Zad3


bWRLS = WRLS(y,u,100,0,0.8);

