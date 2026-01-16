clear all
clc
close all
set(groot, 'defaultFigureColor', 'w');
set(groot, 'defaultAxesColor', 'w');


N = 10000; 
sigma2 = 1;
u_noise = sqrt(sigma2) * randn(N, 1);


quantize = @(sig) round(sig * (2^16 / 10)) * (10 / 2^16);

%% Zadanie 2 i 4: Obiekt liniowy ARX

A_lin = [1 -1.2 0.36];
B_lin = [0 0.6]; 

y_lin = filter(B_lin, A_lin, u_noise);
y_lin_q = quantize(y_lin); 

% Parametry NARX dla liniowego
dBn = 3; dAn = 4; liczbaneuronow = 20;
trainFcn = 'trainbr'; 

% Przygotowanie danych
us_cell = num2cell(u_noise');
ys_cell = num2cell(y_lin_q');

net_lin = narxnet(0:dBn, 1:dAn, liczbaneuronow, 'open', trainFcn);
[x, xi, ai, t] = preparets(net_lin, us_cell, {}, ys_cell);
net_lin.divideParam.trainRatio = 0.7;
net_lin.divideParam.valRatio = 0.15;
net_lin.divideParam.testRatio = 0.15;

[net_lin, tr_lin] = train(net_lin, x, t, xi, ai);
y_pred_lin = net_lin(x, xi, ai);
mse_zad4 = perform(net_lin, t, y_pred_lin);

figure;
plot(cell2mat(t));
hold on;
plot(cell2mat(y_pred_lin), '--');
legend('obiekt', 'model');
xlabel('i')
ylabel('y(i)')
%% Zadanie 3 i 5: Obiekt Wienera

A_w = [1 -0.7 0.2]; 
B_w = [0 0.5];
v = filter(B_w, A_w, u_noise);

c = 0.8; d = 0.05;
y_w = c*v + d*v.^3;
y_w_q = quantize(y_w); 

% Parametry NARX dla Wienera
dBn_w = 3; dAn_w = 5; liczbaneuronow_w = 15;
trainFcn_w = 'trainlm';

us_w_cell = num2cell(u_noise');
ys_w_cell = num2cell(y_w_q');

net_w = narxnet(0:dBn_w, 1:dAn_w, liczbaneuronow_w, 'open', trainFcn_w);
[x_w, xi_w, ai_w, t_w] = preparets(net_w, us_w_cell, {}, ys_w_cell);
[net_w, tr_w] = train(net_w, x_w, t_w, xi_w, ai_w);
y_pred_w = net_w(x_w, xi_w, ai_w);

mse_zad5 = perform(net_w, t_w, y_pred_w);

figure;
plot(cell2mat(t_w));
hold on;
plot(cell2mat(y_pred_w), '--');
legend('obiekt', 'model'); 
xlabel('i')
ylabel('y(i)')

%% Zadanie 6

L = 4;

us_inv = num2cell(y_w_q');
ys_inv = num2cell(u_noise');


dBn_inv = 7; dAn_inv = 3; liczbaneuronow_inv = 50;


net_inv = narxnet(0:dBn_inv, 1:dAn_inv, liczbaneuronow_inv, 'open', 'trainbr');


target_inv = [num2cell(nan(1,L)), ys_inv(1:end-L)]; 

[x_i, xi_i, ai_i, t_i] = preparets(net_inv, us_inv, {}, target_inv);

[net_inv, tr_inv] = train(net_inv, x_i, t_i, xi_i, ai_i);
y_pred_inv = net_inv(x_i, xi_i, ai_i);

figure;
plot(cell2mat(t_i), 'b');
hold on;
plot(cell2mat(y_pred_inv), 'r--');
legend('obiekt', 'model');
xlabel('i')
ylabel('y(i)')

mse_zad6 = perform(net_inv, t_i, y_pred_inv);

fprintf('MSE Zadanie 4: %f\n', perform(net_lin, t, y_pred_lin));
fprintf('MSE Zadanie 5: %f\n', perform(net_w, t_w, y_pred_w));
fprintf('MSE Zadanie 6: %f\n', perform(net_inv, t_i, y_pred_inv));