% function [params] = poszukiwaniaLosoweLscurve(u,y,cus,ilePrzeszukanOkolic)
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
% us = u;
% ys = y;
% b0 = bn;
% [bid,norm]=lsqcurvefit(@modelobiektu,b0,us,ys);
% 
% 
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
% %y6_100 = (B(1) + B(2)*u100) ./ (B(3) + B(4)*u100 + B(5)*u100.^2);
% params = B;
% 
% end


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
