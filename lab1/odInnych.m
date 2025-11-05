%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LABORATORIUM 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

rng(50);

% Współczynniki funkcji wyjściowej
b0 = 1;
b1 = 1;
b3 = 2;
b4 = 2;
b5 = 2;

% Wejścia
u1 = 10 * rand(100,1) - 5;  
u2 = 10 * rand(1000,1) - 5;

% Wyjścia niezakłócone
y1 = (b0 + b1*u1) ./ (b3 + b4*u1 + b5*u1.^2);
y2 = (b0 + b1*u2) ./ (b3 + b4*u2 + b5*u2.^2);

% Zakłócenia
n1 = sqrt(0.05*var(y1,1)) * randn(100,1);
n2 = sqrt(0.05*var(y2,1)) * randn(1000,1);

% Wyjścia zakłócone
y1n = y1 + n1;
y2n = y2 + n2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ZADANIE 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Liczba parametrów
C = 22;

%%%%%%%%%%% Próbki 1

% Macierz sterowań
U1 = zeros(length(u1),C+1);
U1(:,1) = ones(length(u1),1);
for i = 1:C
    U1(:,i+1) = u1.^i;
end

% Wektor paramerów
wektorC1 = (U1'*U1)^(-1)*U1'*y1n;

% Wyjście modelu
y_mnk1 = U1*wektorC1;

% Błąd identyfikacji
error31 = sum((y1n - y_mnk1).^2);



%%%%%%%%%%% Próbki 2

% Macierz sterowań
U2 = zeros(length(u2),C+1);
U2(:,1) = ones(length(u2),1);
for i = 1:C
    U2(:,i+1) = u2.^i;
end

% Wektor paramerów
wektorC2 = (U2'*U2)^(-1)*U2'*y2n;

% Wyjście modelu
y_mnk2 = U2*wektorC2;

% Błąd identyfikacji
error32 = sum((y2n - y_mnk2).^2);



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ZADANIE 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%%%%% Próbki 1
% 
% u41 = num2cell(u1');
% y41 = num2cell(y1n');
% 
% trainFcn = 'trainbr';      % Levenberg-Marquardt backpropagation.
% Neuronsnumber = 3;        % Liczba neuronów warstwy ukrytej
% net1 = feedforwardnet(Neuronsnumber,trainFcn);  % definicja sieci
% net1 = train(net1,u41,y41);                     % uczenie sieci neuronowej
% y_neur1 = net1(u41);              % wyliczanie wyjść sieci neuronowej dla wektora u
% perf = perform(net1,y41,y_neur1); % wyliczenie wskaźnika jakości dla modelu
% 
% % Wyjście modelu
% y_neur11 = cell2mat(y_neur1);
% 
% % Błąd identyfikacji
% error41 = sum((y1n - y_neur11').^2);
% 
% 
% 
% %%%%%%%%%%% Próbki 2
% 
% u42 = num2cell(u2');
% y42 = num2cell(y2n');
% 
% trainFcn = 'trainbr';      % Levenberg-Marquardt backpropagation.
% Neuronsnumber = 3;        % liczba neuronów warstwy ukrytej
% net2 = feedforwardnet(Neuronsnumber,trainFcn);  % definicja sieci
% net2 = train(net2,u42,y42);                     % uczenie sieci neuronowej
% y_neur2 = net2(u42);              % wyliczanie wyjść sieci neuronowej dla wektora u
% perf = perform(net2,y42,y_neur2); % wyliczenie wskaźnika jakości dla modelu
% 
% % Wyjście modelu
% y_neur22 = cell2mat(y_neur2);
% 
% % Błąd identyfikacji
% error42 = sum((y2n - y_neur22').^2);
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ZADANIE 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%%%%% Próbki 1
% 
% % Losowanie parametrów
% B = 10*rand(5,1);
% 
% % Wyjście modelu
% y_los1 = (B(1) + B(2)*u1) ./ (B(3) + B(4)*u1 + B(5)*u1.^2);
% 
% % Błąd identyfikacji
% error51 = sum((y1n - y_los1).^2);
% 
% for i = 1:10000000
% 
%     % Losowanie parametrów
%     B = 10*rand(5,1);
% 
%     % Wyjście modelu
%     y_los1 = (B(1) + B(2)*u1) ./ (B(3) + B(4)*u1 + B(5)*u1.^2);
% 
%     % Błąd identyfikacji
%     error51_New = sum((y1n - y_los1).^2);
% 
%     if error51_New < error51
%         B_best1 = B;
%         error51 = error51_New;
%     end
% end
% 
% % Wyjście modelu dla najlepszych parametrów
% y_los1 = (B_best1(1) + B_best1(2)*u1) ./ (B_best1(3) + B_best1(4)*u1 + B_best1(5)*u1.^2);
% 
% 
% %%%%%%%%%%% Próbki 2
% 
% % Losowanie parametrów
% B = 10*rand(5,1);
% 
% % Wyjście modelu
% y_los2 = (B(1) + B(2)*u2) ./ (B(3) + B(4)*u2 + B(5)*u2.^2);
% 
% % Błąd identyfikacji
% error52 = sum((y2n - y_los2).^2);
% 
% for i = 1:10000000
% 
%     % Losowanie parametrów
%     B = 10*rand(5,1);
% 
%     % Wyjście modelu
%     y_los2 = (B(1) + B(2)*u2) ./ (B(3) + B(4)*u2 + B(5)*u2.^2);
% 
%     % Błąd identyfikacji
%     error52_New = sum((y2n - y_los2).^2);
% 
%     if error52_New < error52
%         B_best2 = B;
%         error52 = error52_New;
%     end
% end
% 
% % Wyjście modelu dla najlepszych parametrów
% y_los2 = (B_best2(1) + B_best2(2)*u2) ./ (B_best2(3) + B_best2(4)*u2 + B_best2(5)*u2.^2);
% 
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ZADANIE 6 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%%%%% Zakres u = (-5,5)
% ux5 = -5:0.01:5;
% 
% % Wyjście funkcji oryginalnej
% yx_5 = (b0 + b1*ux5) ./ (b3 + b4*ux5 + b5*ux5.^2);
% 
% % Wyjścia modelu MNK dla 100 i 1000 próbek
% Ux_5 = zeros(length(ux5),C+1);
% Ux_5(:,1) = ones(length(ux5),1);
% for i = 1:C
%     Ux_5(:,i+1) = ux5.^i;
% end
% yx1_mnk_5 = Ux_5*wektorC1;
% yx2_mnk_5 = Ux_5*wektorC2;
% 
% % Wyjścia sieci neuronowej dla 100 i 1000 próbek
% yx1_neur_5 = net1(ux5);
% yx2_neur_5 = net2(ux5);
% 
% % Wyjścia algorytmu poszukiwania losowego dla 100 i 1000 próbek
% yx_los1_5 = (B_best1(1) + B_best1(2)*ux5) ./ (B_best1(3) + B_best1(4)*ux5 + B_best1(5)*ux5.^2);
% yx_los2_5 = (B_best2(1) + B_best2(2)*ux5) ./ (B_best2(3) + B_best2(4)*ux5 + B_best2(5)*ux5.^2);
% 
% 
% f1 = figure;
% hold on
% p1 = plot(ux5,yx_5,'.');
% p2 = plot(ux5,yx1_mnk_5,'.');
% p3 = plot(ux5,yx1_neur_5,'.');
% p4 = plot(ux5,yx_los1_5,'.');
% set(gca,"FontSize",15);
% xlabel('u');
% ylabel('y');
% grid on
% legend("Funkcja oryginalna","Model MNK","Sieć neuronowa","Poszukiwania losowe","Location","best");
% hold off
% 
% f2 = figure;
% hold on
% p1 = plot(ux5,yx_5,'.');
% p2 = plot(ux5,yx2_mnk_5,'.');
% p3 = plot(ux5,yx2_neur_5,'.');
% p4 = plot(ux5,yx_los2_5,'.');
% set(gca,"FontSize",15);
% xlabel('u');
% ylabel('y');
% grid on
% legend("Funkcja oryginalna","Model MNK","Sieć neuronowa","Poszukiwania losowe","Location","best");
% hold off



%%%%%%%%%%% Zakres u = (-10,10)
ux10 = -10:0.01:10;

% Wyjście funkcji oryginalnej
yx_10 = (b0 + b1*ux10) ./ (b3 + b4*ux10 + b5*ux10.^2);

% Wyjścia modelu MNK dla 100 i 1000 próbek
Ux_10 = zeros(length(ux10),C+1);
Ux_10(:,1) = ones(length(ux10),1);
for i = 1:C
    Ux_10(:,i+1) = ux10.^i;
end
yx1_mnk_10 = Ux_10*wektorC1;
yx2_mnk_10 = Ux_10*wektorC2;

% % Wyjścia sieci neuronowej dla 100 i 1000 próbek
% yx1_neur_10 = net1(ux10);
% yx2_neur_10 = net2(ux10);

% % Wyjścia algorytmu poszukiwania losowego dla 100 i 1000 próbek
% yx_los1_10 = (B_best1(1) + B_best1(2)*ux10) ./ (B_best1(3) + B_best1(4)*ux10 + B_best1(5)*ux10.^2);
% yx_los2_10 = (B_best2(1) + B_best2(2)*ux10) ./ (B_best2(3) + B_best2(4)*ux10 + B_best2(5)*ux10.^2);


f3 = figure;
hold on
p1 = plot(ux10,yx_10,'.');
p2 = plot(ux10,yx1_mnk_10,'.');
p3 = plot(ux10,yx1_neur_10,'.');
p4 = plot(ux10,yx_los1_10,'.');
set(gca,"FontSize",15);
xlabel('u');
ylabel('y');
grid on
legend("Funkcja oryginalna","Model MNK","Sieć neuronowa","Poszukiwania losowe","Location","best");
ylim([-0.5,0.6])
hold off

f4 = figure;
hold on
p1 = plot(ux10,yx_10,'.');
p2 = plot(ux10,yx2_mnk_10,'.');
p3 = plot(ux10,yx2_neur_10,'.');
p4 = plot(ux10,yx_los2_10,'.');
set(gca,"FontSize",15);
xlabel('u');
ylabel('y');
grid on
legend("Funkcja oryginalna","Model MNK","Sieć neuronowa","Poszukiwania losowe","Location","best");
ylim([-0.5,0.6])
hold off



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Zapis obrazów %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% saveas(f1,"./Obrazy/5_100.epsc");
% saveas(f2,"./Obrazy/5_1000.epsc");
% saveas(f3,"./Obrazy/10_100.epsc");
% saveas(f4,"./Obrazy/10_1000.epsc");



