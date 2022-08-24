clear all

ads = 0.34;
Lpds = 50;
L = 10;

for i = 1:1000
    theta(i) = i/1000;
    WLC1(i) = min(Lpds/(2*ads)*theta(i)^2, Lpds/(2*ads)*(pi/6)^2);
    WLC2(i) = Lpds/(2*ads)*theta(i)^2;
end

plot(theta,WLC1);
hold on
plot(theta,WLC2);
hold off