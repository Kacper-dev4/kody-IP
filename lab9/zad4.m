clear all;
close all;
clc;
set(groot, 'defaultFigureColor', 'w');
set(groot, 'defaultAxesColor', 'w');

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

figure('Color', 'w'); 
plot(y_step_true, 'k', 'LineWidth', 2.5); hold on;
legend_entries = {'Obiekt rzeczywisty'};

for idx = 1:length(iteracje_test)
    N_iter = iteracje_test(idx);
    fprintf('Zadanie 4: N = %d (szukanie 7 parametrow)... ', N_iter);
    
    best_z_10_prob = inf;
    p_best_z_10_prob = zeros(1,7);
    
    for p = 1:10 
        [p_tmp, n_tmp] = puszukiwaniaLosowe4(u, y, 2, N_iter, 0.2, ileLokalnie);
        if n_tmp < best_z_10_prob
            best_z_10_prob = n_tmp;
            p_best_z_10_prob = p_tmp;
        end
    end
    
    y_est = symuluj_model_wew4(p_best_z_10_prob, u_step);
    plot(y_est, kolory{idx}, 'LineWidth', 1.5);
    mse_val = best_z_10_prob / N_samples;
    legend_entries{end+1} = sprintf('N=%d (MSE: %.2e)', N_iter, mse_val);
end

legend(legend_entries, 'Location', 'best');
title('Zadanie 4: Identyfikacja z dodatkowym parametrem a0');
xlabel('Próbka'); ylabel('y'); grid on;

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

function err = obliczBladWienera4(p, u, y)
    z = zeros(size(u));
    a0 = p(7);
    for k = 3:length(u)
        z(k) = (p(3)*u(k) + p(4)*u(k-1) - p(1)*z(k-1) - p(2)*z(k-2)) / a0;
        if abs(z(k)) > 1e4, err = 1e15; return; end 
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
        if abs(z(k)) > 1e4, y_mod = zeros(size(u))+1e6; return; end
    end
    y_mod = p(5)*z + p(6)*(z.^3);
end