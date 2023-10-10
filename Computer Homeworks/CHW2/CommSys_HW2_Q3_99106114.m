%%
%3.1
fs = 10000;
t = 0:1/fs:1;
Ac = 1;
fc = 200;
fd = 30;
m = sin(25*pi*t);
xc = fmmod(m,fc,fs,fd);
%%
%3.2
x_restore_ideal = fmdemod(xc,fc,fs,fd);
%%
%3.3
xd = diff(xc);
x_restore_EnvDet = EnvelopeDetector(xc,50E-6,100,fs);
%%
%3.4
ZeroCrosDet = abs(diff(sign(xc)));
ZeroCrosDet = ZeroCrosDet/max(ZeroCrosDet); %normalization
pulse = zeros(1,fs+1);
for i=1:fs-4
    if(ZeroCrosDet(i))
        pulse(i:i+5) = 1;
    end
end
lp_filter = lowpass_filter;
x_restore_ZeroCrosDet = filter(lp_filter,pulse);
%%
%3.5
figure();
subplot(5,1,1);
plot(t,m);
title('$$m(t)$$','interpreter','latex');
xlabel("Time(s)");
subplot(5,1,2);
plot(t,xc);
title('$${FM\ of\ m}$$','interpreter','latex');
xlabel("Time(s)");
subplot(5,1,3);
plot(t,x_restore_ideal);
title('$${Ideal\ Restore\ of\ FM}$$','interpreter','latex')
xlabel("Time(s)");
subplot(5,1,4);
plot(t(2:fs+1),(x_restore_EnvDet(2:fs+1)-mean(x_restore_EnvDet)));
title('$${EnvelopeDetector\ Restore\ of\ FM}$$','interpreter','latex')
xlabel("Time(s)");
subplot(5,1,5);
plot(t,x_restore_ZeroCrosDet);
title('$${ZeroCrossing\ Restore\ of\ FM}$$','interpreter','latex')
xlabel("Time(s)");





function Vc = EnvelopeDetector(xc,C,R,fs) 
    Vc = zeros(1,fs+1);
    for i= 1:1:fs
        if(Vc(i)<xc(i+1))
            Vc(i+1)=xc(i+1);
        else
            Vc(i+1)=Vc(i)*exp(-1/(0.5*fs*R*C));
        end
    end     
end 