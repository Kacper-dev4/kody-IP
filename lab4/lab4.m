% Zadanie 1
e = randn(1,101);
x1 = filter(1, [1 -0.9],  e);    % a1 = 0.9
x2 = filter(1, [1 -0.2],  e);    % a1 = 0.2
x3 = filter(1, [1 +0.2],  e);    % a1 = -0.2
x4 = filter(1, [1 +0.9],  e);    % a1 = -0.9
figure(1)
subplot(2,2,1)
stem(0:100, x1)
title('a1 = 0.9')
subplot(2,2,2)
stem(0:100, x2)
title('a1 = 0.2')
subplot(2,2,3)
stem(0:100, x3)
title('a1 = -0.2')
subplot(2,2,4)
stem(0:100, x4)
title('a1 = -0.9')