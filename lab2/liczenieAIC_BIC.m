function [AIC, BIC] = liczenieAIC_BIC(N, S, dk)

AIC = N*log10(S) + 2*dk;
BIC = N*log10(S) + dk*log(N);

end

