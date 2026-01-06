% function [b] = WRLS(y,u,P0,b0,alfa)
% 
% N = length(y); 
% b = zeros(3,1,N);
% P = zeros(3,3,N);
% 
% b(:,:,2) = b0;
% P(:,:,2) = P0;
% 
% for i=3:N
%     fi = [u(i-1); -y(i-1); -y(i-2)];
%     if i == 3
%         P(:,:,i) = (1/alfa)* (P0*fi*fi'*P0)/(alfa + fi'*P0*fi);
%         k = (P0 * fi)/(alfa + fi'*P0*fi);
%         b(:,:,i) = b0 + k*(y(i) - fi'*b0);
%     else
%         P(:,:,i) = (1/alfa)* (P(:,:,i-1)*fi*fi'*P(:,:,i-1))/(alfa + fi'*P(:,:,i-1)*fi);
%         k = (P(:,:,i-1) * fi)/(alfa + fi'*P(:,:,i-1)*fi);
%         b(:,:,i) = b(:,:,i-1) + k*(y(i) - fi'*b(:,:,i-1));
%     end
% end
% 


function b = WRLS(y,u,P0,b0,alfa)

N = length(y); 
b = zeros(3,1,N);
P = zeros(3,3,N);

b(:,:,2) = b0;
P(:,:,2) = P0;

for i = 3:N
    fi = [u(i-1); -y(i-1); -y(i-2)];

    P_prev = P(:,:,i-1);
    b_prev = b(:,:,i-1);

    k = (P_prev*fi)/(alfa + fi'*P_prev*fi);

    b(:,:,i) = b_prev + k*(y(i) - fi'*b_prev);

    %P(:,:,i) = (1/alfa)*(P_prev - k*fi'*P_prev);
    P(:,:,i) = (1/alfa)*(P_prev - ((P_prev*fi*fi'*P_prev)/(alfa+fi'*P_prev*fi)));
end
end

