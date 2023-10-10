%%
%1.1&2&3
fs = 10000;
t = 0:1/fs:1;
m = cos(5*pi*t) + sin(8*pi*t);

fc = 1000;
mu = 0.8;
Ac = 1;
xc = Ac*(1+mu.*m./max(m)).*cos(2*pi*fc*t);

m_hat = circuit(xc,50E-6,1000,fs);

figure();
subplot(4,1,1);
plot(t,m);
title('$$m(t)$$','interpreter','latex');
subplot(4,1,2);
plot(t,xc);
title('$${x}_{c}(t)$$','interpreter','latex');
subplot(4,1,3);
plot(t,m_hat);
title('$$\hat{m}(t)$$','interpreter','latex');
output = m_hat - mean(m_hat);
subplot(4,1,4);
plot(t,output);
title('$$Output$$','interpreter','latex');




function Vc = circuit(xc,C,R,fs) 
    Vc = zeros(1,fs+1);
    for i= 1:1:fs
        if(Vc(i)<xc(i+1))
            Vc(i+1)=xc(i+1);
        else
            Vc(i+1)=Vc(i)*exp(-1/(fs*R*C));
        end
    end     
end 
