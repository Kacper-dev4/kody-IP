function [y, t] = yBJ(d, B, C, D, F, u)


% liczba próbek sterowania:
N = length(u);

% chwile próbkowania (okres próbkowania = 1):
t = 0 : N-1;

% biały szum do modelowania zakłócenia (niemierzalny):
e = randn(N, 1);

% tworzymy obiekt dynamiczny Box-Jenkins:
% układ ma dwa wejścia: sterowanie u oraz zakłócenie e
obiekt = tf({B C}, {F D}, 1, 'variable', 'z^-1', 'inputDelay', [d 0]);

% symulacja wyjścia układu:
y = lsim(obiekt, [u e], t);

end
