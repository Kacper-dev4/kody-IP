
clear all
clc

set(groot, 'defaultLineLineWidth', 1);
set(groot, 'defaultFigureColor', 'w');
set(groot, 'defaultAxesColor', 'w');

%% Zad 1 i 2 
N = 5000;
b0 = 1;
a1 = 1.5;
a2 = 0.8;

b0Rzeczywiste = zeros(1,N);
a1Rzeczywiste = zeros(1,N);
a2Rzeczywiste = zeros(1,N);

wariancja1 = 1;
wariancja2 = 0.2;
%wariancja2 = 0;
u = sqrt(wariancja1) * randn(1,N);
%u = ones(1,N);
%u(1:99) = 0;
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
              % a1 = 1;
              % a2 = 0.5;
            y(i) = b0*u(i-1)+e(i)-a1*y(i-1)-a2*y(i-2);
        case 2500
            a1 = 1.5;
            a2 = 0.8;
            y(i) = b0*u(i-1)+e(i)-a1*y(i-1)-a2*y(i-2);
        otherwise
    y(i) = b0*u(i-1)+e(i)-a1*y(i-1)-a2*y(i-2);
    end
    b0Rzeczywiste(i) = b0;
    a1Rzeczywiste(i) = a1;
    a2Rzeczywiste(i) = a2;
end

figure;
plot(y)
xlabel('i')
ylabel('y(i)')




%% Zad3 WRLS

bWRLS = WRLS(y,u,[100,0,0;0,100,0;0,0,100],[0;0;0],0.5);

figure
hold on
plot(squeeze(bWRLS(1,1,:)))
plot(squeeze(bWRLS(2,1,:)))
plot(squeeze(bWRLS(3,1,:)))

grid on
legend('WRLS b0','WRLS a1','WRLS a2')
xlabel('i')
ylabel('Wartości parametrów')

figure
subplot(3,1,1)
hold on
plot(squeeze(bWRLS(1,1,:)))
plot(b0Rzeczywiste)
legend('WRLS b0', 'Rzeczywiste b0')
xlabel('i')
ylabel('Wartości parametrów')

subplot(3,1,2)
hold on
plot(squeeze(bWRLS(2,1,:)))
plot(a1Rzeczywiste)
legend('WRLS a1', 'Rzeczywiste a1')
xlabel('i')
ylabel('Wartości parametrów')

subplot(3,1,3)
hold on
plot(squeeze(bWRLS(3,1,:)))
plot(a2Rzeczywiste)
legend('WRLS a2', 'Rzeczywiste a2')
xlabel('i')
ylabel('Wartości parametrów')

bladWRLS = sum((squeeze(bWRLS(1,1,:)) - b0Rzeczywiste').^2)/N ... 
    +  sum((squeeze(bWRLS(2,1,:)) - a1Rzeczywiste').^2)/N ...
    + sum((squeeze(bWRLS(3,1,:)) - a2Rzeczywiste').^2)/N;


%% LMS
bLMS = LMS(y,u,[0;0;0],0.01);%[ 0.0008 ;0.000853; 0.000853]);

figure
hold on
plot(squeeze(bLMS(1,1,:)))
plot(squeeze(bLMS(2,1,:)))
plot(squeeze(bLMS(3,1,:)))
grid on
legend('LMS b0','LMS a1','LMS a2')
xlabel('i')
ylabel('Wartości parametrów')

figure
subplot(3,1,1)
hold on
plot(squeeze(bLMS(1,1,:)))
plot(b0Rzeczywiste)
legend('LMS b0', 'Rzeczywiste b0')
xlabel('i')
ylabel('Wartości parametrów')

subplot(3,1,2)
hold on
plot(squeeze(bLMS(2,1,:)))
plot(a1Rzeczywiste)
legend('LMS a1', 'Rzeczywiste a1')
xlabel('i')
ylabel('Wartości parametrów')

subplot(3,1,3)
hold on
plot(squeeze(bLMS(3,1,:)))
plot(a2Rzeczywiste)
legend('LMS a2', 'Rzeczywiste a2')
xlabel('i')
ylabel('Wartości parametrów')

bladLMS = sum((squeeze(bLMS(1,1,:)) - b0Rzeczywiste').^2)/N ... 
    +  sum((squeeze(bLMS(2,1,:)) - a1Rzeczywiste').^2)/N ...
    + sum((squeeze(bLMS(3,1,:)) - a2Rzeczywiste').^2)/N;

