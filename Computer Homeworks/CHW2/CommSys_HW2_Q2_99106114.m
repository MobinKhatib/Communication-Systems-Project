%%
%2.1
fs = 10000;
t = 0:1/fs:9;
x1 = (cos(10*pi*t)+sin(12*pi*t)).*(heaviside(t)-heaviside(t-3));
fc1 = 500;
x2 = (cos(14*pi*t)+sin(8*pi*t)).*(heaviside(t-3)-heaviside(t-6));
fc2 = 650;
x3 = (cos(5*pi*t)+sin(15*pi*t)).*(heaviside(t-6)-heaviside(t-9));
fc3 = 800;
%%
%2.2
xc1 = ssbmod(x1,fc1,fs,0,'upper');
xc2 = ssbmod(x2,fc2,fs,0,'upper');
xc3 = ssbmod(x3,fc3,fs,0,'upper');
transmit = xc1+xc2+xc3;
%%
%2.3
figure();
subplot(7,1,1);
plot(t,x1);
title('$$x_1(t)$$','interpreter','latex');
subplot(7,1,2);
plot(t,x2);
title('$$x_2(t)$$','interpreter','latex')
subplot(7,1,3);
plot(t,x3);
title('$$x_3(t)$$','interpreter','latex')
subplot(7,1,4);
plot(t,xc1);
title('$$x_{c1}(t)$$','interpreter','latex')
subplot(7,1,5);
plot(t,xc2);
title('$$x_{c2}(t)$$','interpreter','latex')
subplot(7,1,6);
plot(t,xc3);
title('$$x_{c3}(t)$$','interpreter','latex')
subplot(7,1,7);
plot(t,transmit);
title('$$transmit(t)$$','interpreter','latex')
%%
%2.4
ft_x1 = fft(x1);
ft_x2 = fft(x2);
ft_x3 = fft(x3);
ft_xc1 = fft(xc1);
ft_xc2 = fft(xc2);
ft_xc3 = fft(xc3);
ft_transmit = fft(transmit);
%Now we use 'fftshift' to make the FTs symmetrical
ft_x1 = fftshift(ft_x1);
ft_x2 = fftshift(ft_x2);
ft_x3 = fftshift(ft_x3);
ft_xc1 = fftshift(ft_xc1);
ft_xc2 = fftshift(ft_xc2);
ft_xc3 = fftshift(ft_xc3);
ft_trsnsmit = fftshift(ft_transmit);
freq = -45000:45000;
figure();
subplot(7,1,1);
plot(freq,abs(ft_x1));
title('$$|F\{{x_1}\}|$$','interpreter','latex');
xlabel("frequncy(Hz)");
ylabel("Amplitude");
subplot(7,1,2);
plot(freq,abs(ft_x2));
title('$$|F\{{x_2}\}|$$','interpreter','latex');
xlabel("frequncy(Hz)");
ylabel("Amplitude");
subplot(7,1,3);
plot(freq,abs(ft_x3));
title('$$|F\{{x_3}\}|$$','interpreter','latex');
xlabel("frequncy(Hz)");
ylabel("Amplitude");
subplot(7,1,4);
plot(freq,abs(ft_xc1));
title('$$|F\{{x_c1}\}|$$','interpreter','latex');
xlabel("frequncy(Hz)");
ylabel("Amplitude");
subplot(7,1,5);
plot(freq,abs(ft_xc2));
title('$$|F\{{x_c2}\}|$$','interpreter','latex');
xlabel("frequncy(Hz)");
ylabel("Amplitude");
subplot(7,1,6);
plot(freq,abs(ft_xc3));
title('$$|F\{{x_c3}\}|$$','interpreter','latex');
xlabel("frequncy(Hz)");
ylabel("Amplitude");
subplot(7,1,7);
plot(freq,abs(ft_transmit));
title('$$|F\{{transmit}\}|$$','interpreter','latex');
xlabel("frequncy(Hz)");
ylabel("Amplitude");
%%
%2.5
transmit_noisy = awgn(transmit,5,'measured');
ft_transmit_noisy = fft(transmit_noisy);
%ft_transmit_noisy = fftshift(ft_transmit_noisy);
filter = (heaviside(freq-37000)-heaviside(freq-41000)) + (heaviside(freq+41000)-heaviside(freq+37000));
output = ft_transmit_noisy.*filter;
figure();
subplot(2,1,1);
plot(freq,abs(ft_transmit));
title('$$|F\{{Recieved}\}|$$','interpreter','latex');
xlabel("frequncy(Hz)");
ylabel("Amplitude");
subplot(2,1,2);
plot(freq,abs(output));
title('$$|F\{{Transmit_{BP filtered}}\}|$$','interpreter','latex');
xlabel("frequncy(Hz)");
ylabel("Amplitude");
output_TimeDomain = real((ifft(output)));
%%
%2.6
x1_recieve = ssbdemod(output_TimeDomain.*(heaviside(t)-heaviside(t-3)),fc1,fs);
x2_recieve = ssbdemod(output_TimeDomain.*(heaviside(t-3)-heaviside(t-6)),fc2,fs);
x3_recieve = ssbdemod(output_TimeDomain.*(heaviside(t-6)-heaviside(t-9)),fc3,fs);
figure();
subplot(6,1,1);
plot(t,x1);
title('$$x_1(t)$$','interpreter','latex');
xlabel("Time(s)");
subplot(6,1,2);
plot(t,x1_recieve);
title('$$x_1(t)\ Demodulated$$','interpreter','latex');
xlabel("Time(s)");
subplot(6,1,3);
plot(t,x2);
title('$$x_2(t)$$','interpreter','latex');
xlabel("Time(s)");
subplot(6,1,4);
plot(t,x2_recieve);
title('$$x_2(t)\ Demodulated$$','interpreter','latex');
xlabel("Time(s)");
subplot(6,1,5);
plot(t,x3);
title('$$x_3(t)$$','interpreter','latex');
xlabel("Time(s)");
subplot(6,1,6);
plot(t,x3_recieve);
title('$$x_3(t)\ Demodulated$$','interpreter','latex');
xlabel("Time(s)");
