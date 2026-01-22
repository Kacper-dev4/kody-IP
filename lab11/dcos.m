% --- Parametry obiektu (PRZYKŁAD – wstaw swoje) ---
b0 = 1;
a1 = 1;
a2 = -3.5;

% --- Obiekt dyskretny ---
G = tf([b0], [1 a1 a2], -1);  % G(z) = b0 / (1 + a1 z^-1 + a2 z^-2)

% --- Filtr FIR: 1 + z^-1 ---
H0 = tf([3.7], [1 ], -1);
H1 = tf([0.05 ], [1 0], -1);
H2 = tf([0.3],[1 0 0], -1);
H3 = tf([0.25],[1 0 0], -1);
H4 = tf([0.7],[1 0 0], -1);
H = H0+H1;
% --- Opóźnienie o 2 próbki: z^-2 ---
D = tf(1, 1, -1, 'InputDelay', 2);

% --- Pętla otwarta ---
GH = G * H ;

% --- Root locus ---
figure
rlocus(GH)
