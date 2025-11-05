clear all
clc
b = [2,3, 1,1,1];

u100 = load('u100.mat');
u1000 = load('u1000.mat');
u100 = u100.u100;
u1000 = u1000.u1000;

y100 = (b(1) + b(2)*u100) ./ (b(3) + b(4)*u100 + b(5)*u100.^2);
y1000 = (b(1) + b(2)*u1000) ./ (b(3) + b(4)*u1000 + b(5)*u1000.^2);

% Dodanie szumu 

% zaklocenie100 = sqrt(0.05 * var(y100,1)) * randn(100,1);
% zaklocenie1000 = sqrt(0.05 * var(y1000,1)) * randn(1000,1);
% 
% zaklocenie100 = zaklocenie100';
% zaklocenie1000 = zaklocenie1000';

% y100z = y100 + zaklocenie100;
% y1000z = y1000 + zaklocenie1000;

y100z = load("y100z.mat");
y100z = y100z.y100z;


y1000z = load("y1000z.mat");
y1000z = y1000z.y1000z;


%% Metoda najmniejszych kwadratów metodą polyfit

pMNK100 = polyfit(u100,y100z,40);
yMNK100 = polyval(pMNK100,u100);
JMNK100 = sum((y100z - yMNK100).^2)

pMNK1000 = polyfit(u1000,y1000z,44);
yMNK1000 = polyval(pMNK1000,u1000);
JMNK1000 = sum((y1000z - yMNK1000).^2)

%% Sieć neuronowa

us = u100;
ys = y100z;
us = num2cell(us);
ys = num2cell(ys);
trainFcn = 'trainbr'; % Levenberg-Marquardt backpropagation.
Neuronsnumber = 2; %liczba neuronów warstwy ukrytej
net = feedforwardnet(Neuronsnumber,trainFcn);%definicja sieci
%neuronowej
net = train(net,us,ys); %uczenie sieci neuronowej
y0100 = net(us); % wyliczanie wyjść sieci neuronowej dla wektora us
perf = perform(net,ys,y0100) %wyliczenie wskaźnika jakości dla
%zidentyfikowanego modelu

y0100 = cell2mat(y0100);

us = u1000;
ys = y1000z;
us = num2cell(us);
ys = num2cell(ys);
trainFcn = 'trainbr'; % Levenberg-Marquardt backpropagation.
Neuronsnumber = 2; %liczba neuronów warstwy ukrytej
net = feedforwardnet(Neuronsnumber,trainFcn);%definicja sieci
%neuronowej
net = train(net,us,ys); %uczenie sieci neuronowej
y01000 = net(us); % wyliczanie wyjść sieci neuronowej dla wektora us
perf = perform(net,ys,y01000) %wyliczenie wskaźnika jakości dla
%zidentyfikowanego modelu

y01000 = cell2mat(y01000);

%% Metoda poszukiwań losowych
N = 1000000;
mi = 1;

bn = 5*(rand(1,5));

yn = (bn(1) + bn(2)*u100) ./ (bn(3) + bn(4)*u100 + bn(5)*u100.^2);
JMPLn = sum((y100z - yn).^2);
bnORG = bn;
JMPLB = JMPLn;
for k=1:N

bnn = 5*(rand(1,5));%bn + mi * (rand(1,5)-0.5);
ynn = (bnn(1) + bnn(2)*u100) ./ (bnn(3) + bnn(4)*u100 + bnn(5)*u100.^2);
JMPL100 = sum((y100z - ynn).^2);

if JMPL100 < JMPLB
B = bnn;
JMPLB = JMPL100;
end

if JMPL100 < 1
    break;
end

bn = bnn;
end
y5_100 = (B(1) + B(2)*u100) ./ (B(3) + B(4)*u100 + B(5)*u100.^2);


bn = 5*(rand(1,5));

yn = (bn(1) + bn(2)*u1000) ./ (bn(3) + bn(4)*u1000 + bn(5)*u1000.^2);
JMPLn = sum((y1000z - yn).^2);
bnORG = bn;
JMPLB = JMPLn;
for k=1:N

bnn = 5*(rand(1,5));%bn + mi * (rand(1,5)-0.5);
ynn = (bnn(1) + bnn(2)*u1000) ./ (bnn(3) + bnn(4)*u1000 + bnn(5)*u1000.^2);
JMPL100 = sum((y1000z - ynn).^2);

if JMPL100 < JMPLB
B = bnn;
JMPLB = JMPL100;
end

if JMPL100 < 1
    break;
end

bn = bnn;
end
y5_1000 = (B(1) + B(2)*u1000) ./ (B(3) + B(4)*u1000 + B(5)*u1000.^2);



%% Zad 6 Metoda poszukiwań losowych z dodatkowym elementem 

N = 100;

bn = 5*(rand(1,5));

yn = (bn(1) + bn(2)*u100) ./ (bn(3) + bn(4)*u100 + bn(5)*u100.^2);
JMPLn = sum((y100z - yn).^2);
bnORG = bn;
JMPLB = JMPLn;
for k=1:N

bnn = bn + mi * (rand(1,5)-0.5);
us = u100;
ys = y100z;
b0 = bn;
[bid,norm]=lsqcurvefit(@modelobiektu,b0,us,ys);


if norm < JMPLB
B = bnn;
JMPLB = norm;
bn = bnn;
end

if norm < 1
    break;
end


end
y6_100 = (B(1) + B(2)*u100) ./ (B(3) + B(4)*u100 + B(5)*u100.^2);

N = 100;

bn = 5*(rand(1,5));

yn = (bn(1) + bn(2)*u1000) ./ (bn(3) + bn(4)*u1000 + bn(5)*u1000.^2);
JMPLn = sum((y1000z - yn).^2);
bnORG = bn;
JMPLB = JMPLn;
for k=1:N

bnn = 5*(rand(1,5));%bn + mi * (rand(1,5)-0.5);
us = u1000;
ys = y1000z;
b0 = bn;
[bid,norm]=lsqcurvefit(@modelobiektu,b0,us,ys);


if norm < JMPLB
B = bnn;
JMPLB = norm;
end

if norm < 1
    break;
end

bn = bnn;
end
y6_1000 = (B(1) + B(2)*u1000) ./ (B(3) + B(4)*u1000 + B(5)*u1000.^2);




%% Zad 6 wyświetalnie i porównanie otrzymanych modeli 

figure(1)
hold on
plot(u100,y100,'o')
plot(u100,y100z,'o')
title('Dane z 100 pomiarów')
legend('Sygnał oryginalny','Sygnał zaszumiony')
hold off

figure(2)
hold on
plot(u1000,y1000,'o')
plot(u1000,y1000z,'o')
title('Dane z 1000 pomiarów')
legend('Sygnał oryginalny','Sygnał zaszumiony')
hold off

figure(3)
hold on
plot(u100,y100,'o')
plot(u100,yMNK100,'o')
legend('Sygnał oryginalny','Sygnał z metody MNK')
title('Wynik metody MNK dla 100 pomiarów')

figure(4)
hold on 
plot(u1000,y1000,'o')
plot(u1000,yMNK1000,'o')
legend('Sygnał oryginalny','Sygnał z metody MNK')
title('Wynik metody MNK dla 1000 pomiarów')
    
figure(5)
hold on 
plot(u100,y100,'o')
plot(u100,y0100,'o')
legend('Sygnał oryginalny','Sygnał z metody sieci neuronowej')
title('Wynik sieci neuronowej dla 100 pomiarów')
    

figure(6)
hold on 
plot(u1000,y1000,'o')
plot(u1000,y01000,'o')
legend('Sygnał oryginalny','Sygnał z metody sieci neuronowej')
title('Wynik sieci neuronowej dla 1000 pomiarów')

figure(7)
hold on 
plot(u100,y100,'o')
plot(u100,y5_100,'o')
legend('Sygnał oryginalny','Sygnał z metody poszukiwań losowych')
title('Wynik metody poszukiwań losowych dla 100 pomiarów')
    

figure(8)
hold on 
plot(u1000,y1000,'o')
plot(u1000,y5_1000,'o')
legend('Sygnał oryginalny','Sygnał z metody poszukiwań losowych')
title('Wynik metody poszukiwań losowych dla 1000 pomiarów')

figure(9)
hold on 
plot(u100,y100,'o')
plot(u100,y6_100,'o')
legend('Sygnał oryginalny','Sygnał z metody poszukiwań losowych')
title('Wynik metody poszukiwań losowych z dodatkowym lsqcurvefit dla 100 pomiarów')
    

figure(10)
hold on 
plot(u1000,y1000,'o')
plot(u1000,y6_1000,'o')
legend('Sygnał oryginalny','Sygnał z metody poszukiwań losowych')
title('Wynik metody poszukiwań losowych z dodatkowym lsqcurvefit dla 1000 pomiarów')





function f=modelobiektu(bin,wej)
 f = (bin(1) + bin(2)*wej) ./ (bin(3) + bin(4)*wej + bin(5)*wej.^2);
 end
