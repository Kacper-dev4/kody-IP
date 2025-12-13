function [params] = poszukiwaniaLosowe(u,y,cus,ilePrzeszukanOkolic)

a = cus * (rand(1,2));
b = cus * (rand(1,2));
c = cus * (rand(1));
d = cus * (rand(1));
yn(1) = b(1)*c*u(1) + d*b(1)*u(1)^3;
yn(2) = b(1)*c*u(2)+ b(2)*c*u(1) + c*a(1)*y(1) + d*b(1)*u(2)^3 + d*b(2)*u(1)^3 - d*a(1)*y(1)^3;
yn(3,:) =b(1)*c*u(3:end)+ b(2)*c*u(2:end-1) + c*a(1)*y(2:end-1) + d*b(1)*u(3:end)^3 + d*b(2)*u(2:end-1)^3 - d*a(1)*y(2:end-1)^3 - c*a(2)*y(1:end-2) - d*a(2)*y(1:end-2)^3;
JMPLn = sum((y - yn).^2);
bnORG = [a,b,c,d];
bn = bnORG;
JMPLB = JMPLn;
for k=1:N

bnn = bn + mi * (rand(1,6)-0.5);
us = u;
ys = y;
b0 = bn;
[bid,norm]=lsqcurvefit(@modelobiektu,b0,us,ys);


if norm < JMPLB
B = bnn;
JMPLB = norm;
bn = bid;
end

for i = ilePrzeszukanOkolic
end

if norm < 1
    break;
end


end
y6_100 = (B(1) + B(2)*u100) ./ (B(3) + B(4)*u100 + B(5)*u100.^2);


end

