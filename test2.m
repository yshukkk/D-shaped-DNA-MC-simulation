syms lp
N=50;

t = 8;
y = 2*lp*(N-1)*0.34*(1-lp/((N-1)*0.34)*(1-exp(-(N-1)*0.34/lp)));

for i = 1:30
    persistence2(i,t) = double(vpasolve(y-end_distance(i,t)^2,[0 100]));
end