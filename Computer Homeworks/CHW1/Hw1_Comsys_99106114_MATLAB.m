%%
%%1.1
clc
clear
T0 = 10;
f0 = 10;
t = 0:0.01:100;
xt = (t - T0) .^4 .* exp(T0 - t) .* sin(2 .* pi .* f0 .* (t - T0)) .* heaviside(t - T0);
figure('Name','1.1')
plot(t,xt)
legend('input');
%%
%1.3
T0 = 10;
f0 = 10;
t = 0:0.01:100;
xt = (t - T0) .^4 .* exp(T0 - t) .* sin(2 .* pi .* f0 .* (t - T0)) .* heaviside(t - T0);
n = 10001;
fs = 100;
f = fs * ((-n / 2) : ((n - 1) / 2)) / n;
Xf = fft(xt,n);
alpha = 0.3;
b = zeros(1,3);
b(1,1) = raylrnd(1);
b(1,2) = raylrnd(1);
b(1,3) = raylrnd(1);
Hcf1 = (1 ./ (1-(alpha * exp(-1i * 2 * pi * f * T0))-(b(1,1) * exp(-1i * 4 * pi * f * T0))));
Hcf2 = (1 ./ (1-(alpha * exp(-1i * 2 * pi * f * T0))-(b(1,2) * exp(-1i * 4 * pi * f * T0))));
Hcf3 = (1 ./ (1-(alpha * exp(-1i * 2 * pi * f * T0))-(b(1,3) * exp(-1i * 4 * pi * f * T0))));
Yf1 = Hcf1 .* Xf;
Yf2 = Hcf2 .* Xf;
Yf3 = Hcf3 .* Xf;
yt1 = ifft(Yf1);
yt2 = ifft(Yf2);
yt3 = ifft(Yf3);
hold on
plot(t,yt1);
plot(t,yt2);
plot(t,yt3);
legend(strcat('beta = ',num2str(b')))
hold off
%%
%1.4
T0 = 10;
f0 = 10;
t = 0:0.01:100;
xt = (t - T0) .^4 .* exp(T0 - t) .* sin(2 .* pi .* f0 .* (t - T0)) .* heaviside(t - T0);
n = 10001;
fs = 100;
f = fs * ((-n / 2) : ((n - 1) / 2)) / n;
Xf = fft(xt,n);
a = 0.3;
y_mean=zeros(4,10001);
c = 0;
for N = [10 50 100 200]
    c = c + 1;
    y = zeros(N, 10001);
    for r = 1 : N
        b = raylrnd(1);
        Hcf = (1 ./ (1 - (a * exp(-1i * 2 * pi * f))-(b * exp(-1i * 4 * pi * f))));
        Yf = Hcf .* Xf;
        y(1,:) = ifft(Yf);        
    end
    y_mean(c,:) = mean(y);
end
figure('Name','1.4');
subplot(4,1,1);
plot(t,y_mean(1,:));
title('N = 10');
subplot(4,1,2);
plot(t,y_mean(2,:));
title('N = 50');
subplot(4,1,3);
plot(t,y_mean(3,:));
title('N = 200');
subplot(4,1,4);
plot(t,y_mean(4,:));
title('N = 500');
%%
%2.3
clc
clear
T0 = 10;
f0 = 10;
t = 0:0.01:100;
xt = (t - T0) .^4 .* exp(T0 - t) .* sin(2 .* pi .* f0 .* (t - T0)) .* heaviside(t - T0);
n = 10001;
%fs = 100;
%f = fs * ((-n / 2) : ((n - 1) / 2)) / n;
Xf = fft(xt,n);
a = 0.3;
x = linspace(3,10,8);
t0 = 1;
%k = 1;
y = (t - 10 - t0) .^ 4 .* exp(-(t - 10 - t0)) .* sin(20 * pi * (t - 10 - t0)) .* heaviside(t - 10 - t0);
w = zeros(1,8) ;
for m = 3 : 10
    c=0;
    for N = 0:m
        c = c + (0.3 .* (t - 10 - t0 - N * T0 - T0) .^ 4 .* exp(-(t - 10 - t0- N * T0 - T0)) .* sin(20 * pi * (t - 10 - t0 - N * T0 - T0)) .* heaviside(t - 10 - t0- N * T0 - T0)+(t - 10 -t0 - N * T0) .^ 4 .* exp(-(t - 10 - t0 -N * T0)) .* sin(20 * pi * (t - 10 - t0 - N * T0)).*heaviside(t - 10 - t0 - N * T0)) .* (-0.3) .^ N;
    end
    w(m - 2)=sum(abs(c - y).^2);
end 
figure('Name','2.3');
subplot(1,2,1);
plot(x,w);
grid on
subplot(1,2,2);
semilogy(x,w)
grid on
%%
%2.4
clc
clear
T0 = 10;
f0 = 10;
t = 0:0.01:100;
xt = (t - T0) .^4 .* exp(T0 - t) .* sin(2 .* pi .* f0 .* (t - T0)) .* heaviside(t - T0);
n = 10001;
fs = 100;
f = fs * ((-n / 2) : ((n - 1) / 2)) / n;
%Xf = fft(xt,n);
x = 3:0.1:8;
t0 = 1;
k = 1;
yt = (t - 10 - t0).^4.*exp(-(t - 10 - t0)) .* sin(20 * pi * (t - 10 - t0)) .* heaviside(t - 10 - t0);
y = (t - 10) .^ 4 .* exp(-(t - 10)) .* sin(20 * pi * (t - 10)) .* heaviside(t - 10) + 0.3 .* (t - 10 - t0) .^ 4 .* exp(-(t - 10 - t0)) .* sin(20 * pi * (t - 10 - t0)) .* heaviside(t - 10 - t0);
c = 0;
    for N=0:5
        c = c + (0.3 .* (t - 10 - t0 - N * T0 - T0) .^ 4 .* exp(-(t - 10 - t0- N * T0 - T0)) .* sin(20 * pi * (t - 10 - t0 - N * T0 - T0)) .* heaviside(t - 10 - t0- N * T0 - T0)+(t - 10 -t0 - N * T0) .^ 4 .* exp(-(t - 10 - t0 -N * T0)) .* sin(20 * pi * (t - 10 - t0 - N * T0)).*heaviside(t - 10 - t0 - N * T0)) .* (-0.3) .^ N;
    end
figure('Name','2.4');    
subplot(2,2,1)
plot(t,xt)
title('x')
subplot(2,2,2)
plot(t,yt)
title('yh')
subplot(2,2,3)
plot(t,y)
title('y')
subplot(2,2,4)
plot(t,c)
title('x5')