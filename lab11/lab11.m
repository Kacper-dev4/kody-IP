clear all
clc

%% Zad 1 i 2
kr = 3.75;
w = 1;

b0 = 1;
a1 = 1; 
a2 = -3.5;  

licznik = b0;
mianownik = [1, a1, a2];
G = tf(licznik, mianownik, -1); 


figure;
pzmap(G);

figure;
rlocus(G)

out = sim("simLab11.slx");

y = out.y.Data;
u = out.u.Data;
figure
plot(y(1:100));
xlabel('i')
ylabel('y(i)')

%% Zad 3

na = 2;
nb = 1;
k = 2;

out = sim("simLab11.slx");
y = out.y.Data;
u = out.u.Data;

yDane = y;
uDane = u;
dane = iddata(yDane, uDane);

model_zad3 = arx(dane, [na nb k]);

A_zamkniety = model_zad3.A;
B_zamkniety = model_zad3.B;

A_otwarty_zad3 = A_zamkniety - B_zamkniety; 
B_otwarty_zad3 = B_zamkniety/kr;


figure
plot(y(1:100));
hold on

b0 = B_otwarty_zad3(3);
a1 = A_otwarty_zad3(2);
a2 = A_otwarty_zad3(3);
out = sim("simLab11.slx");
plot(y(1:100),'--');
y = out.y.Data;
xlabel('i')
ylabel('y(i)')
legend('Obiekt','Model')
%%% Zad 4


%% a)
na = 2;
nb = 1;
k = 2;
kr = 3.75;
w = 1;

b0 = 1;
a1 = 1; 
a2 = -3.5;  

out = sim("simLab11.slx");

y = out.y.Data;
u = out.u.Data;

yDane = y(1:100);
uDane = u(1:100);
dane = iddata(yDane, uDane);

model_zad4a = arx(dane, [na nb k]);

A_otwarty_zad4a = model_zad4a.A;
B_otwarty_zad4a = model_zad4a.B;

figure
plot(y(1:100));
hold on

b0 = B_otwarty_zad4a(3);
a1 = A_otwarty_zad4a(2);
a2 = A_otwarty_zad4a(3);
out = sim("simLab11.slx");
plot(y(1:100),'--');
y = out.y.Data;
xlabel('i')
ylabel('y(i)')
legend('Obiekt','Model')

%% b) to samo co poprzednio należy dodać dodtkowy sygnał identyfikujący w simulinku

na = 2;
nb = 1;
k = 2;
kr = 3.75;
w = 1;

b0 = 1;
a1 = 1; 
a2 = -3.5;  

out = sim("simLab11.slx");

y = out.y.Data;
u = out.u.Data;

yDane = y(1:100);
uDane = u(1:100);
dane = iddata(yDane, uDane);

model_zad4b = arx(dane, [na nb k]);

A_otwarty_zad4b = model_zad4b.A;
B_otwarty_zad4b = model_zad4b.B;

figure
plot(y(1:100));
hold on

b0 = B_otwarty_zad4b(3);
a1 = A_otwarty_zad4b(2);
a2 = A_otwarty_zad4b(3);
out = sim("simLab11.slx");
plot(y(1:100),'--');
y = out.y.Data;
xlabel('i')
ylabel('y(i)')
legend('Obiekt','Model')

%% c) jak w a) tylko dodać fitr FIR w simulink
na = 2;
nb = 1;
k = 2;
kr = 3.75;
w = 1;

b0 = 1;
a1 = 1; 
a2 = -3.5;  

out = sim("simLab11.slx");

y = out.y.Data;
u = out.u.Data;

yDane = y(1:100);
uDane = u(1:100);
dane = iddata(yDane, uDane);

model_zad4c = arx(dane, [na nb k]);

A_otwarty_zad4c = model_zad4c.A;
B_otwarty_zad4c = model_zad4c.B;

figure
plot(y(1:100));
hold on

b0 = B_otwarty_zad4c(3);
a1 = A_otwarty_zad4c(2);
a2 = A_otwarty_zad4c(3);
out = sim("simLab11.slx");
plot(y(1:100),'--');
y = out.y.Data;
xlabel('i')
ylabel('y(i)')
legend('Obiekt','Model')

%% d)

na = 2;
nb = 1;
k = 2;
kr = 3.5;
w = 1;

b0 = 1;
a1 = 1; 
a2 = -3.5;  

out = sim("simLab11.slx");

y = out.y.Data;
u = out.u.Data;

yDane = y;
uDane = u;
dane = iddata(yDane, uDane);

model_zad4d = arx(dane, [na nb k]);

A_otwarty_zad4d = model_zad4d.A;
B_otwarty_zad4d = model_zad4d.B;

figure
plot(y);
hold on

b0 = B_otwarty_zad4d(3);
a1 = A_otwarty_zad4d(2);
a2 = A_otwarty_zad4d(3);
out = sim("simLab11.slx");
plot(y,'--');
y = out.y.Data;
xlabel('i')
ylabel('y(i)')
legend('Obiekt','Model')



