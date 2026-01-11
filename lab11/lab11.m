clear all
clc


kr = 0.7;
w = 1;

b0 = 0.5;
a1 = -1.95;
a2 = 1.01;

out = sim("simLab11.slx");

y = out.y;
plot(y);
ylim([-100,100])