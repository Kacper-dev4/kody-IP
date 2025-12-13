b = [2,3, 1,1,1];

u100 = load('u100.mat');
u1000 = load('u1000.mat');
u100 = u100.u100;
u1000 = u1000.u1000;

y100 = (b(1) + b(2)*u100) ./ (b(3) + b(4)*u100 + b(5)*u100.^2);
y1000 = (b(1) + b(2)*u1000) ./ (b(3) + b(4)*u1000 + b(5)*u1000.^2);

% Dodanie szumu 

zaklocenie100 = sqrt(0.05 * var(y100,1)) * randn(100,1);
zaklocenie1000 = sqrt(0.05 * var(y1000,1)) * randn(1000,1);

zaklocenie100 = zaklocenie100';
zaklocenie1000 = zaklocenie1000';

y100z = y100 + zaklocenie100;
y1000z = y1000 + zaklocenie1000;



% Metoda najmniejszych kwadratów metodą polyfit

pMNK100 = polyfit(u100,y100z,3);
yMNK100 = polyval(pMNK100,u100);
JMNK100 = sum((y100z - yMNK100).^2);



