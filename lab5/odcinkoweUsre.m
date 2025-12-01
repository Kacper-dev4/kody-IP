function [GWMusre, f] = odcinkoweUsre(sygnal, ilePrzedzialow, Fs)

dlu = length(sygnal);
probkiPrzedzial = floor(dlu / ilePrzedzialow);
przedzialy = cell(1, ilePrzedzialow);
GWM = cell(1, ilePrzedzialow);
Tp = 1/Fs;

for i = 1:ilePrzedzialow
    start_idx = (i-1)*probkiPrzedzial + 1;
    if i == ilePrzedzialow
        end_idx = dlu;
    else
        end_idx = i * probkiPrzedzial;
    end
    seg = sygnal(start_idx : end_idx);
    if length(seg) < probkiPrzedzial
        seg(end+1:probkiPrzedzial) = 0;
    end
    GWM{i} = abs(fft(seg));
    
end
GWMusre = 0;
N = probkiPrzedzial;
for i = 1:ilePrzedzialow
 GWM{i} = (Tp/N)*GWM{i}.^2;
 GWMusre = GWMusre + GWM{i};   
end

GWMusre = GWMusre/ilePrzedzialow;
GWMusre = GWMusre(1:floor(length(GWMusre)/2)+1);
f = (0:length(GWMusre)-1) * Fs / N;

figure;
for i = 1:ilePrzedzialow
    plot(f, GWM{i}(1:length(f)));
    hold on;
end
grid on;
xlabel('Częstotliwość [Hz]');
ylabel('GWM');
title('Widma poszczególnych przedziałów');
hold off;

figure;
plot(f, GWMusre);
grid on;
xlabel('Częstotliwość [Hz]');
ylabel('GWM');
title('Uśrednione widmo sygnału');
xlim([0 Fs/2]);

end   

