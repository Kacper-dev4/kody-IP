function [b] = LMS(y,u,b0,mi)

N = length(y);
b = zeros(3,1,N);
b(:,:,2) = b0;

for i=3:N
    fi = [u(i-1); -y(i-1); -y(i-2)];
    b(:,:,i) = b(:,:,i-1) + mi.*fi*(y(i) - fi'*b(:,:,i-1));
end
end

