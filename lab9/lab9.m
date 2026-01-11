clear all;
clc;
set(groot, 'defaultFigureColor', 'w');
set(groot, 'defaultAxesColor', 'w');
%% Zad2

N_samples = 1000; 
u = randn(N_samples, 1); 

a_true = [0.6, -0.2]; 
b_true = [0.5, 0.3]; 

c_true = 0.8; 
d_true = 0.1;

p_true = [a_true, b_true, c_true, d_true];


z = zeros(N_samples, 1);
for k = 3:N_samples
    z(k) = b_true(1)*u(k) + b_true(2)*u(k-1) - a_true(1)*z(k-1) - a_true(2)*z(k-2);
end


y = c_true*z + d_true*(z.^3);


figure;
subplot(2,1,1);
plot(u);
title('Sygnał wejściowy u');
xlabel('Numer próbki')
ylabel('y')
grid on;

subplot(2,1,2);
plot(y); 
title('Sygnał wyjściowy obiektu Wienera y');
xlabel('Numer próbki');
ylabel('u')
grid on;

%% Zad3

K = 1.5;        
T = 1.0;        
tau = 0.5;     

f_bw = 1 / (2 * pi * T); 
fs = 4 * f_bw;           
Tp = 1 / fs;             

N_samples = 5000;
u = randn(N_samples, 1); 
t = (0:N_samples-1)' * Tp;

s = tf('s');
G_cont = K / (T*s + 1);
G_cont.InputDelay = tau;

z = lsim(G_cont, u, t);
c = 0.6;
d = 0.04;

y = c*z + d*(z.^3);

figure;
subplot(2,1,1);
plot(t, u);
title('Wejście u(t)');
xlabel('Czas, s');
ylabel('u(t)')
grid on;

subplot(2,1,2);
plot(t, y);
title('Próbkowane wyjście y(t) obiektu ciągłego');
xlabel('Czas, s');
ylabel('y(t)');
grid on;




%% %%%%%%%%%%%% Zad4 %%%%%%%%%%%%%% 
clear all;
set(groot, 'defaultFigureColor', 'w');
set(groot, 'defaultAxesColor', 'w');

%% poszukiwanie losowe
N_samples = 1000; 
u = randn(N_samples, 1);
a_true = [0.6, -0.2]; b_true = [0.5, 0.3]; c_true = 0.8; d_true = 0.1;
p_true = [a_true, b_true, c_true, d_true]; 
u_step = ones(100, 1);
y_step_true = symuluj_model_wew4(p_true, u_step);
y = symuluj_model_wew4(p_true, u) + 0.01 * randn(N_samples, 1);
ileLokalnie = 100;
iteracje_test = [50, 200, 1000]; 
kolory = {'r--', 'g--', 'b--'};

% Przygotowanie tabeli wyników
wyniki_losowe = zeros(length(iteracje_test), 2); % [Best_MSE, Mean_MSE]

figure; 
plot(y_step_true, 'k', 'LineWidth', 2.5); hold on;
legend_entries = {'Obiekt rzeczywisty'};

for idx = 1:length(iteracje_test)
    N_iter = iteracje_test(idx);
    mse_proby = zeros(10, 1);
    best_z_10_prob = inf;
    p_best_z_10_prob = zeros(1,7);
    
    for p = 1:10 
        [p_tmp, n_tmp] = puszukiwaniaLosowe4(u, y, 2, N_iter, 0.2, ileLokalnie);
        current_mse = n_tmp / N_samples;
        mse_proby(p) = current_mse;
        
        if n_tmp < best_z_10_prob
            best_z_10_prob = n_tmp;
            p_best_z_10_prob = p_tmp;
        end
    end
    
   stabilne_mse = mse_proby(mse_proby < 100); 
    
    if isempty(stabilne_mse)
        srednie_mse_wynik = NaN; % Wszystkie próby były niestabilne
    else
        srednie_mse_wynik = mean(stabilne_mse);
    end
    
    % Zapis do tabeli
    wyniki_losowe(idx, :) = [min(mse_proby), srednie_mse_wynik];
    
    y_est = symuluj_model_wew4(p_best_z_10_prob, u_step);
    plot(y_est, kolory{idx}, 'LineWidth', 1.5);
    legend_entries{end+1} = sprintf('N=%d (Best MSE: %.2e)', N_iter, min(mse_proby));
end
legend(legend_entries, 'Location', 'best');
xlabel('Próbka');
ylabel('y');
grid on;



T1 = array2table(wyniki_losowe, 'RowNames', {'N_50', 'N_200', 'N_1000'}, ...
    'VariableNames', {'Najlepszy_MSE', 'Sredni_MSE'});
disp(T1);

%% poszukiwanie losowe z lscurve
N_samples = 1000; 
u = randn(N_samples, 1);
y = symuluj_model_wew4(p_true, u) + 0.01 * randn(N_samples, 1);
y_step_true = symuluj_model_wew4(p_true, u_step);
iteracje_test_lsq = [20, 100, 300]; 


lb = [-2.9, -1.9, -10, -10, -10, -10 -2]; 
ub = [ 2.9,  1.9,  10  10,  10,  10 2];



wyniki_lsq = zeros(length(iteracje_test_lsq), 2);

figure; 
plot(y_step_true, 'k', 'LineWidth', 2.5); hold on;
legend_entries = {'Obiekt rzeczywisty'};

for idx = 1:length(iteracje_test_lsq)
    N_iter = iteracje_test_lsq(idx);
    mse_proby = zeros(10, 1);
    best_z_10_prob = inf;
    
    for p = 1:10 
        [p_tmp, n_tmp] = poszukiwaniaLscurve4(u, y, 2, N_iter, lb, ub);
        current_mse = n_tmp / N_samples;
        mse_proby(p) = current_mse;
        
        if n_tmp < best_z_10_prob
            best_z_10_prob = n_tmp;
            p_best_z_10_prob = p_tmp;
        end
    end
    
    % Zapis do tabeli
    wyniki_lsq(idx, :) = [min(mse_proby), mean(mse_proby)];
    
    y_est = symuluj_model_wew4(p_best_z_10_prob, u_step);
    plot(y_est, kolory{idx}, 'LineWidth', 1.5);
    legend_entries{end+1} = sprintf('N=%d (Best MSE: %.2e)', N_iter, min(mse_proby));
end
legend(legend_entries, 'Location', 'best');
xlabel('Próbka');
ylabel('y');
grid on; 


T2 = array2table(wyniki_lsq, 'RowNames', {'N_20', 'N_100', 'N_300'}, ...
    'VariableNames', {'Najlepszy_MSE', 'Sredni_MSE'});
disp(T2);
%%%%%%%%%%%%%%%
%%%%%%%%%%%% Zad5 %%%%%%%%%%%%%% 
%% poszukiwanie losowe
clear all;
N_samples = 1000; 
u = randn(N_samples, 1);
a_true = [0.6, -0.2]; b_true = [0.5, 0.3]; c_true = 0.8; d_true = 0.1;
p_true = [a_true, b_true, c_true, d_true];
u_step = ones(100, 1);
y_step_true = symuluj_model_wew(p_true, u_step);
y = symuluj_model_wew(p_true, u) + 0.01 * randn(N_samples, 1);
ileLokalnie = 100;
iteracje_test = [50, 200, 1000]; 
kolory = {'r--', 'g--', 'b--'};

wyniki_losowe5 = zeros(length(iteracje_test), 2); 

figure; 
plot(y_step_true, 'k', 'LineWidth', 2.5); hold on;
legend_entries = {'Obiekt rzeczywisty'};

for idx = 1:length(iteracje_test)
    N_iter = iteracje_test(idx);
    mse_proby = zeros(10, 1);
    best_z_10_prob = inf;
    p_best_z_10_prob = zeros(1,6);
    
    for p = 1:10 
        [p_tmp, n_tmp] = puszukiwaniaLosowe(u, y, 2, N_iter, 0.2, ileLokalnie);
        current_mse = n_tmp / N_samples;
        mse_proby(p) = current_mse;
        
        if n_tmp < best_z_10_prob
            best_z_10_prob = n_tmp;
            p_best_z_10_prob = p_tmp;
        end
    end
    
 
    stabilne = mse_proby(mse_proby < 100);
    if isempty(stabilne), srednia_val = mean(mse_proby); else srednia_val = mean(stabilne); end
    wyniki_losowe5(idx, :) = [min(mse_proby), srednia_val];
    
    y_est = symuluj_model_wew(p_best_z_10_prob, u_step);
    plot(y_est, kolory{idx}, 'LineWidth', 1.5);
    legend_entries{end+1} = sprintf('N=%d (MSE: %.2e)', N_iter, min(mse_proby));
end
legend(legend_entries, 'Location', 'best');
xlabel('Próbka');
ylabel('y');
grid on; 


T5_1 = array2table(wyniki_losowe5, 'RowNames', {'N_50', 'N_200', 'N_1000'}, ...
    'VariableNames', {'Najlepszy_MSE', 'Sredni_MSE'});
disp(T5_1);

%% poszukiwanie losowe z lscurve
N_samples = 1000; 
u = randn(N_samples, 1);
y = symuluj_model(p_true, u) + 0.01 * randn(N_samples, 1);
iteracje_test_lsq = [20, 100, 500]; 
kolory = {'r--', 'g--', 'm--'}; 
lb = [-2.9, -1.9, -10, -10, -10, -10]; 
ub = [ 2.9,  1.9,  10,  10,  10,  10];

wyniki_lsq5 = zeros(length(iteracje_test_lsq), 2);

figure;
plot(y_step_true, 'k', 'LineWidth', 3); hold on;
legend_entries = {'Obiekt rzeczywisty'};

for idx = 1:length(iteracje_test_lsq)
    N_iter = iteracje_test_lsq(idx);
    mse_proby = zeros(5, 1);
    najlepszy_lokalnie_norm = inf;
    najlepszy_lokalnie_params = [];
       
    for p = 1:5
       [p_est, n_norm] = poszukiwaniaLosoweLscurve(u, y, 2, N_iter, 0.5, lb, ub);
       current_mse = n_norm / length(y);
       mse_proby(p) = current_mse;
        if n_norm < najlepszy_lokalnie_norm
            najlepszy_lokalnie_norm = n_norm;
            najlepszy_lokalnie_params = p_est;
        end 
    end
    
    
    stabilne = mse_proby(mse_proby < 100);
    if isempty(stabilne), srednia_val = mean(mse_proby); else srednia_val = mean(stabilne); end
    wyniki_lsq5(idx, :) = [min(mse_proby), srednia_val];
   
    y_step_est = symuluj_model(najlepszy_lokalnie_params, u_step);
    plot(y_step_est, kolory{idx}, 'LineWidth', 1.5);
    legend_entries{end+1} = sprintf('N=%d (MSE: %.4e)', N_iter, min(mse_proby));
end
xlabel('Próbka'); ylabel('y');
legend(legend_entries, 'Location', 'best');
grid on; 


T5_2 = array2table(wyniki_lsq5, 'RowNames', {'N_20', 'N_100', 'N_500'}, ...
    'VariableNames', {'Najlepszy_MSE', 'Sredni_MSE'});
disp(T5_2);


%% Zad6 


clear all;
set(groot,'defaultFigureColor','w');


K_true = 1.2; T_true = 0.6; tau_true = 0.3;
c_true = 0.8; d_true = 0.08;
p_true = [K_true T_true tau_true c_true d_true];

Tp = 0.1; % 
N_samples = 5000;
u = randn(N_samples,1);

y = symuluj_wiener_ciagly(p_true, u, Tp) + 0.01*randn(N_samples,1);

u_step = ones(200,1);
t_step = (0:length(u_step)-1)' * Tp;
y_step_true = symuluj_wiener_ciagly(p_true, u_step, Tp);



kolory = {'r--', 'g--', 'b--'};
lb = [0.1, 0.05, 0, 0, 0];
ub = [5, 5, 2, 5, 5];       

%% poszukiwanie losowe 
iteracje_test = [50, 200, 1000]; 
wyniki_losowe6 = zeros(length(iteracje_test), 2);

figure;
plot(t_step, y_step_true, 'k', 'LineWidth', 2.5); hold on;
legend_entries = {'Obiekt rzeczywisty'};

for idx = 1:length(iteracje_test)
    N_iter = iteracje_test(idx);
    mse_proby = zeros(5, 1);
    best_err = inf;
    p_best_losowe = zeros(1,5);
    
    for p = 1:5 
        [p_tmp, n_tmp] = puszukiwaniaLosoweCiagle(u, y, N_iter, Tp, lb, ub);
        current_mse = n_tmp / N_samples;
        mse_proby(p) = current_mse;
        
        if n_tmp < best_err
            best_err = n_tmp;
            p_best_losowe = p_tmp;
        end
    end
    
   
    stabilne = mse_proby(mse_proby < 100);
    if isempty(stabilne), srednia_val = mean(mse_proby); else srednia_val = mean(stabilne); end
    wyniki_losowe6(idx, :) = [min(mse_proby), srednia_val];
    
    y_est = symuluj_wiener_ciagly(p_best_losowe, u_step, Tp);
    plot(t_step, y_est, kolory{idx}, 'LineWidth', 1.5);
    legend_entries{end+1} = sprintf('N=%d (MSE: %.2e)', N_iter, min(mse_proby));
end

xlabel('Czas [s]');
ylabel('y');
grid on;
legend(legend_entries);


T6_1 = array2table(wyniki_losowe6, 'RowNames', {'N_50', 'N_100', 'N_1000'}, ...
    'VariableNames', {'Najlepszy_MSE', 'Sredni_MSE'});
disp(T6_1);

%% poszukiwanie losowe z lscurve
wyniki_lsq6 = zeros(length(iteracje_test), 2);
iteracje_test = [20, 100, 300]; 
figure;
plot(t_step, y_step_true, 'k', 'LineWidth', 2.5); hold on;
legend_entries = {'Obiekt rzeczywisty'};

for idx = 1:length(iteracje_test)
    N_iter = iteracje_test(idx);
    mse_proby = zeros(5, 1);
    best_err = inf;
    p_best_lsq = zeros(1,5);
    
    for p = 1:5
        [p_tmp, n_tmp] = poszukiwaniaLscurveCiagle(u, y, Tp, N_iter, lb, ub);
        current_mse = n_tmp / N_samples;
        mse_proby(p) = current_mse;
        
        if n_tmp < best_err
            best_err = n_tmp;
            p_best_lsq = p_tmp;
        end
    end
    
    stabilne = mse_proby(mse_proby < 100);
    if isempty(stabilne), srednia_val = mean(mse_proby); else srednia_val = mean(stabilne); end
    wyniki_lsq6(idx, :) = [min(mse_proby), srednia_val];
    
    y_est = symuluj_wiener_ciagly(p_best_lsq, u_step, Tp);
    plot(t_step, y_est, kolory{idx}, 'LineWidth', 1.5);
    legend_entries{end+1} = sprintf('N=%d (MSE: %.2e)', N_iter, min(mse_proby));
end

xlabel('Czas [s]');
ylabel('y');
grid on;
legend(legend_entries);

T6_2 = array2table(wyniki_lsq6, 'RowNames', {'N_20', 'N_100', 'N_300'}, ...
    'VariableNames', {'Najlepszy_MSE', 'Sredni_MSE'});
disp(T6_2);





%%% funkcje 
function y_mod = symuluj_model(p, u)
    z = zeros(size(u));
    for k = 3:length(u)
        z(k) = p(3)*u(k) + p(4)*u(k-1) - p(1)*z(k-1) - p(2)*z(k-2);
        if abs(z(k)) > 1e4 
            y_mod = ones(size(u)) * 1e6; return;
        end
    end
    y_mod = p(5)*z + p(6)*(z.^3);
end

function y_mod = symuluj_model_wew(p, u)
    z = zeros(size(u));
    for k = 3:length(u)
        z(k) = p(3)*u(k) + p(4)*u(k-1) - p(1)*z(k-1) - p(2)*z(k-2);
        if abs(z(k)) > 1e4, y_mod = zeros(size(u))+1e6; return; end
    end
    y_mod = p(5)*z + p(6)*(z.^3);
end

function [best_p, best_n] = poszukiwaniaLscurve4(u, y, zakres, N, lb, ub)
    options = optimoptions('lsqcurvefit', 'Display', 'off', 'MaxIterations', 5); 
    best_n = inf;
    best_p = zeros(1,7);
    
    for k = 1:N
      
        p_start = zakres * (rand(1, 7) - 0.5);
        p_start(7) = 1 + 0.1*rand(); 
       
        try
            [p_opt, resnorm] = lsqcurvefit(@symuluj_model_wew4, p_start, u, y, lb, ub, options);
            if resnorm < best_n
                best_n = resnorm;
                best_p = p_opt;
            end
        catch
            continue; 
        end
    end
end

function err = obliczBladWienera4(p, u, y)
    z = zeros(size(u));
    a0 = p(7);
    for k = 3:length(u)
        z(k) = (p(3)*u(k) + p(4)*u(k-1) - p(1)*z(k-1) - p(2)*z(k-2)) / a0;
        if abs(z(k)) > 1e4, err = 1e15; 
            return; 
        end 
    end
    y_mod = p(5)*z + p(6)*(z.^3);
    err = sum((y - y_mod).^2);
end

function y_mod = symuluj_model_wew4(p, u)
    z = zeros(size(u));
    if length(p) == 7
        a0 = p(7);
    else
        a0 = 1;
    end
    
    for k = 3:length(u)
        z(k) = (p(3)*u(k) + p(4)*u(k-1) - p(1)*z(k-1) - p(2)*z(k-2)) / a0;
        if abs(z(k)) > 1e4, y_mod = zeros(size(u))+1e6; 
            return;
        end
    end
    y_mod = p(5)*z + p(6)*(z.^3);
end


function [best_params, best_norm] = puszukiwaniaLosowe4(u, y, zakres, N, mi, ileLokalnie)
 
    bn = zakres * (rand(1, 7) - 0.5); 
    bn(7) = 1 + 0.2*rand();
    
    JMPLB = inf;
    B = bn;
    mi_lokalnie = mi / 10; 
    
    for k = 1:N
        bnn = B + mi * (rand(1, 7) - 0.5);
       
        if abs(bnn(7)) < 0.01, bnn(7) = 0.01; end
        
        norm_nowa = obliczBladWienera4(bnn, u, y);
        
        if norm_nowa < JMPLB
            temp_best_bn = bnn;
            temp_best_norm = norm_nowa;
            for j = 1:ileLokalnie
                b_lokalne = temp_best_bn + mi_lokalnie * (rand(1, 7) - 0.5);
                if abs(b_lokalne(7)) < 0.01, b_lokalne(7) = 0.01; end
                
                norm_lokalna = obliczBladWienera4(b_lokalne, u, y);
                if norm_lokalna < temp_best_norm
                    temp_best_norm = norm_lokalna;
                    temp_best_bn = b_lokalne;
                end
            end
            B = temp_best_bn;
            JMPLB = temp_best_norm;
        end
    end
    best_params = B;
    best_norm = JMPLB;
end


function [best_p, best_n] = puszukiwaniaLosoweCiagle(u, y, N, Tp, lb, ub)
    B = lb + (ub - lb).*rand(1,5); % Startowy punkt
    y_mod = symuluj_wiener_ciagly(B, u, Tp);
    JMPLB = sum((y - y_mod).^2);
    mi = (ub - lb) * 0.1; % Krok poszukiwań
    
    for k = 1:N
        bnn = B + mi .* (rand(1, 5) - 0.5);
        
        bnn = max(min(bnn, ub), lb);
        
        y_mod_new = symuluj_wiener_ciagly(bnn, u, Tp);
        norm_nowa = sum((y - y_mod_new).^2);
        
        if norm_nowa < JMPLB
            B = bnn;
            JMPLB = norm_nowa;
        end
    end
    best_p = B; best_n = JMPLB;
end

function [best_p, best_res] = poszukiwaniaLscurveCiagle(u, y, Tp, N, lb, ub)
    options = optimoptions('lsqcurvefit', 'Display', 'off', 'MaxIterations', 10);
    best_res = inf;
    best_p = lb;
    for k = 1:N
        p_start = lb + (ub - lb).*rand(1,5);
        try
            [p_opt, resnorm] = lsqcurvefit(@(p, u) symuluj_wiener_ciagly(p, u, Tp), ...
                                           p_start, u, y, lb, ub, options);
            if resnorm < best_res
                best_res = resnorm;
                best_p = p_opt;
            end
        catch
            continue;
        end
    end
end

function y_mod = symuluj_wiener_ciagly(p, u, Tp)
    K = p(1); T = p(2); tau = p(3); c = p(4); d = p(5);
    
    a = exp(-Tp/T);
    b = K * (1 - a);
    delay = round(tau / Tp);
    z = zeros(size(u));
    for k = (delay + 2):length(u)
        z(k) = a * z(k-1) + b * u(k - delay - 1);
        if abs(z(k)) > 1e4, y_mod = ones(size(u))*1e6; return; end
    end
    y_mod = c*z + d*(z.^3);
end

function [best_params, best_norm] = poszukiwaniaLosoweLscurve(u, y, zakres, N, mi, lb, ub)

    bn = zakres * (rand(1, 6) - 0.5);
    JMPLB = inf;
    B = bn;

    options = optimoptions('lsqcurvefit', 'Display', 'off', 'MaxIterations', 100);

    for k = 1:N
   
        b_start = bn + mi * (rand(1, 6) - 0.5);
        
        [b_opt, resnorm] = lsqcurvefit(@model_wienera, b_start, u, y, lb, ub, options);
        

        if resnorm < JMPLB
            JMPLB = resnorm;
            bn = b_opt; 
            B = b_opt;
        end
        
       
        if JMPLB < 0.01
            break;
        end
    end
    best_params = B;
    best_norm = JMPLB;
end

function y_mod = model_wienera(p, u)
    z = zeros(size(u));
   
    for k = 3:length(u)
        z(k) = p(3)*u(k) + p(4)*u(k-1) - p(1)*z(k-1) - p(2)*z(k-2);
        
       
        if abs(z(k)) > 1e6
            y_mod = ones(size(u)) * 1e10; 
            return;
        end
    end
    y_mod = p(5)*z + p(6)*(z.^3);
    
   
    if any(isnan(y_mod)) || any(isinf(y_mod))
        y_mod = ones(size(u)) * 1e10;
    end
end


function [best_params, best_norm] = puszukiwaniaLosowe(u, y, zakres, N, mi, ileLokalnie)
    % Losowanie punktu startowego
    bn = zakres * (rand(1, 6) - 0.5); 
    JMPLB = inf;
    B = bn;
    mi_lokalnie = mi / 10; 
    
    for k = 1:N
        % Skok algorytmu głównego - skaczemy z punktu B (najlepszego dotąd)
        bnn = B + mi * (rand(1, 6) - 0.5);
        norm_nowa = obliczBladWienera(bnn, u, y);
        
        if norm_nowa < JMPLB
            % Precyzyjne przeszukiwanie okolic (Punkt 1 instrukcji)
            temp_best_bn = bnn;
            temp_best_norm = norm_nowa;
            
            for j = 1:ileLokalnie
                b_lokalne = temp_best_bn + mi_lokalnie * (rand(1, 6) - 0.5);
                norm_lokalna = obliczBladWienera(b_lokalne, u, y);
                if norm_lokalna < temp_best_norm
                    temp_best_norm = norm_lokalna;
                    temp_best_bn = b_lokalne;
                end
            end
            
            
            B = temp_best_bn;
            JMPLB = temp_best_norm;
        end
        if JMPLB < 1e-6, break; end
    end
    best_params = B;
    best_norm = JMPLB;
end

function err = obliczBladWienera(p, u, y)
    z = zeros(size(u));
    for k = 3:length(u)
        % z(k) = b0*u(k) + b1*u(k-1) - a1*z(k-1) - a2*z(k-2)
        z(k) = p(3)*u(k) + p(4)*u(k-1) - p(1)*z(k-1) - p(2)*z(k-2);
        
        if abs(z(k)) > 1e4, err = 1e15; return; end 
    end
    y_mod = p(5)*z + p(6)*(z.^3);
    err = sum((y - y_mod).^2);
end
