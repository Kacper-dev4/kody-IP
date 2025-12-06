function [b] = WRLS(y,u,P0,b0,alfa)

N = length(y); 
b = zeros(1,N);
P = zeros(1,N);

for i=1:N
    if i == 1
        P(i) = (1/alfa)* (P0*u(i)*u(i)*P0)/(alfa + u(i)*P0*u(i));
        k = (P0 * u(i))/(alfa + u(i)*P0*u(i));
        b(i) = b0 + k*(y(i) - u(i)/b0);
    else
        P(i) = (1/alfa)* (P(i-1)*u(i)*u(i)*P(i-1))/(alfa + u(i)*P(i-1)*u(i));
        k = (P(i-1) * u(i))/(alfa + u(i)*P(i-1)*u(i));
        b(i) = b(i-1) + k*(y(i) - u(i)/b(i-1));
    end
end

