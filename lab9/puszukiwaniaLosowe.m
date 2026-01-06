% function [params] = puszukiwanieLosowe(u,y,cus,ilePrzeszukanOkolic)
% 
% a = cus * (rand(1,2));
% b = cus * (rand(1,2));
% c = cus * (rand(1));
% d = cus * (rand(1));
% yn(1) = b(1)*c*u(1) + d*b(1)*u(1)^3;
% yn(2) = b(1)*c*u(2)+ b(2)*c*u(1) + c*a(1)*y(1) + d*b(1)*u(2)^3 + d*b(2)*u(1)^3 - d*a(1)*y(1)^3;
% yn(3,:) =b(1)*c*u(3:end)+ b(2)*c*u(2:end-1) + c*a(1)*y(2:end-1) + d*b(1)*u(3:end)^3 + d*b(2)*u(2:end-1)^3 - d*a(1)*y(2:end-1)^3 - c*a(2)*y(1:end-2) - d*a(2)*y(1:end-2)^3;
% JMPLn = sum((y - yn).^2);
% bnORG = [a,b,c,d];
% bn = bnORG;
% JMPLB = JMPLn;
% for k=1:N
% 
% bnn = bn + mi * (rand(1,6)-0.5);
% 
% yn(3,:) =bnn(3)*bnn(5)*u(3:end)+ bnn(4)*bnn(5)*u(2:end-1) + bnn(5)*bnn(1)*y(2:end-1) + bnn(6)*bnn(3)*u(3:end)^3 + bnn(6)*bnn(4)*u(2:end-1)^3 - bnn(6)*bnn(1)*y(2:end-1)^3 - bnn(5)*bnn(2)*y(1:end-2) - bnn(6)*bnn(2)*y(1:end-2)^3;
% norm = sum((y - yn).^2);
% if norm < JMPLB
% B = bnn;
% JMPLB = norm;
% bn = bid;
% end
% 
% for i = ilePrzeszukanOkolic
% end
% 
% if norm < 1
%     break;
% end
% 
% 
% end
% 
% %y6_100 = (B(1) + B(2)*u100) ./ (B(3) + B(4)*u100 + B(5)*u100.^2);
% params = B;
% 
% end
%




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
            
            % Aktualizacja najlepszego punktu
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
        % Zabezpieczenie przed niestabilnością (Inf)
        if abs(z(k)) > 1e4, err = 1e15; return; end 
    end
    y_mod = p(5)*z + p(6)*(z.^3);
    err = sum((y - y_mod).^2);
end

