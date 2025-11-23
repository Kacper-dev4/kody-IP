function [GWMusre, f] = odcinkoweUsre(sygnal, ilePrzedzialow, Fs)

dlu = length(sygnal);
probkiPrzedzial = floor(dlu / ilePrzedzialow);
przedzialy = cell(1, ilePrzedzialow);
GWM = cell(1, ilePrzedzialow);
GWMusre = zeros(1, probkiPrzedzial);

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
    GWMusre = GWMusre + GWM{i}(1:probkiPrzedzial);
end

GWMusre = GWMusre / ilePrzedzialow;
N = probkiPrzedzial;

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

