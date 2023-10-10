%% Section3: 1

fs = 1000000;
T = 0.01;
fc = 10000;
fo = 10000;
BW = 1000;
one_pulse = ones(1, 10000); % fs*T =10000
one_pulse(5001:10000) = 0;
zero_pulse = -ones(1, 10000); % fs*T =10000
zero_pulse(5001:10000) = 0;
b_n = (randi([0, 1], [1, 200]));

    %%
[b1 ,b2] = Divide(b_n);
figure();
subplot(2,1,1);
stem(b1);
title('$${b}_{1}\  {and}\  {b}_{2} $$','interpreter','latex');
xlabel("n");
ylabel('$${b}_{1}[n]$$','interpreter','latex');
subplot(2,1,2);
stem(b2);
xlabel("n");
ylabel('$${b}_{2}[n]$$','interpreter','latex');

x1_t = PulseShaping(b1, one_pulse, zero_pulse);
x2_t = PulseShaping(b2, one_pulse, zero_pulse);
figure();
subplot(2,1,1);
plot((0:1/fs:length(b_n)/2*T-1/fs), x1_t);
title('$${x}_{1}(t)\  {and}\  {x}_{2}(t) $$','interpreter','latex');
xlabel("t");
ylabel('x1(t)');
subplot(2,1,2);
plot((0:1/fs:length(b_n)/2*T-1/fs), x2_t);
xlabel("t");
ylabel('x2(t)');

xc_t = AnalogMod(x1_t, x2_t, fs, fc);
figure();
plot((0:1/fs:length(b_n)/2*T-1/fs), xc_t);
title('$${x}_{c}(t)$$','interpreter','latex');
xlabel("t");
ylabel('xc(t)');

x_receive = Channel(xc_t, fs, fo, BW);
figure();
plot((0:1/fs:length(b_n)/2*T-1/fs), (x_receive));
title('$${x}_{receive}(t)$$','interpreter','latex');
xlabel("t");
ylabel('$${x}_{receive}(t)$$','interpreter','latex');

[y1_t, y2_t] = AnalogDemod(x_receive, fs, BW, fc); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure();
subplot(2,1,1);
plot((0:1/fs:length(b_n)/2*T-1/fs), (y1_t));
title('$${y}_{1}(t)\  {and}\  {y}_{2}(t) $$','interpreter','latex');
xlabel("t");
ylabel('$${y}_{1}(t)$$','interpreter','latex');
subplot(2,1,2);
plot((0:1/fs:length(b_n)/2*T-1/fs), (y2_t));
xlabel("t");
ylabel('$${y}_{2}(t)$$','interpreter','latex');


[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
subplot(4,1,1);
plot((0:length(MatFil_one_1)-1)/fs, (MatFil_one_1));
title('$${MatchedFilters}(t)\  {and}\  \hat{b}[n] $$','interpreter','latex');
xlabel("t");
ylabel('$${Matched Filter}_{one}$$','interpreter','latex');
subplot(4,1,2);
plot((0:length(MatFil_zero_1)-1)/fs, (MatFil_zero_1));
xlabel("t");
ylabel('$${Matched Filter}_{zero}$$','interpreter','latex');
subplot(4,1,3);
stem(b_hat_1);
xlabel("n");
ylabel('$$\hat{b}_{1}$$','interpreter','latex');
subplot(4,1,4);
stem(b_hat_2);
xlabel("n");
ylabel('$$\hat{b}_{2}$$','interpreter','latex');

b_hat = Combine(b_hat_1, b_hat_2);
figure();
stem(b_hat);
title('$$Final Output$$','interpreter','latex');
xlabel("n");
ylabel('$$\hat{b}$$','interpreter','latex');

figure();
stem(b_hat-b_n);
title('$${Error}\ { Of }\ {Reconstruction}$$','interpreter','latex');
xlabel("n");
ylabel('$$\hat{b}\ {-} {b}_{n}$$','interpreter','latex');

    %%
[b1 ,b2] = Divide(b_n);
x1_t = PulseShaping(b1, one_pulse, zero_pulse);
x2_t = PulseShaping(b2, one_pulse, zero_pulse);
xc_t = AnalogMod(x1_t, x2_t, fs, fc);
x_receive = Channel(xc_t, fs, fo, BW);

error = zeros(1,40);
for i=1:40
    x_receive_affected = x_receive + normrnd(0,2.5*i,1,length(x_receive)); 
    [y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
    [MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
    [MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
    b_hat = Combine(b_hat_1, b_hat_2);
    error(i) = sumsqr(b_hat-b_n)/length(b_n);
    %figure();
    %stem(b_hat);
end

figure();
plot((0:0.1:4-0.1)*25,error);
title('$${Probability}\ { Of }\ {Reconstruction}\ {Error}$$','interpreter','latex');
xlabel("{\sigma}^2");
ylabel('$${P}_{error}$$','interpreter','latex');


    %%
[b1 ,b2] = Divide(b_n);
x1_t = PulseShaping(b1, one_pulse, zero_pulse);
x2_t = PulseShaping(b2, one_pulse, zero_pulse);
xc_t = AnalogMod(x1_t, x2_t, fs, fc);
x_receive = Channel(xc_t, fs, fo, BW);

x_receive_affected = x_receive + normrnd(0,0,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
scatter(MatFil_one_1,MatFil_one_2);
title('$${Signal }\  {Constellation }\  {for }\ {\sigma^2}\ { =0} $$','interpreter','latex');

x_receive_affected = x_receive + normrnd(0,1,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
scatter(MatFil_one_1,MatFil_one_2);
title('$${Signal }\  {Constellation }\  {for }\ {\sigma^2}\ { =1} $$','interpreter','latex');

x_receive_affected = x_receive + normrnd(0,5,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
scatter(MatFil_one_1,MatFil_one_2);
title('$${Signal }\  {Constellation }\  {for }\ {\sigma^2}\ { =5} $$','interpreter','latex');

x_receive_affected = x_receive + normrnd(0,10,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
scatter(MatFil_one_1,MatFil_one_2);
title('$${Signal }\  {Constellation }\  {for }\ {\sigma^2}\ { =10} $$','interpreter','latex');

x_receive_affected = x_receive + normrnd(0,30,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
scatter(MatFil_one_1,MatFil_one_2);
title('$${Signal }\  {Constellation }\  {for }\ {\sigma^2}\ { =30} $$','interpreter','latex');

x_receive_affected = x_receive + normrnd(0,75,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
scatter(MatFil_one_1,MatFil_one_2);
title('$${Signal }\  {Constellation }\  {for }\ {\sigma^2}\ { =75} $$','interpreter','latex');

%% 2
fs = 1000000;
T = 0.01;
fc = 10000;
fo = 10000;
BW = 1000;
t = (0:10000-1)*1/fs;
one_pulse = 1*sin(2*pi*500*t); % fs*T =10000
zero_pulse = -1*sin(2*pi*500*t); % fs*T =10000
b_n = (randi([0, 1], [1, 200]));


    %%
[b1 ,b2] = Divide(b_n);
figure();
subplot(2,1,1);
stem(b1);
title('$${b}_{1}\  {and}\  {b}_{2} $$','interpreter','latex');
xlabel("n");
ylabel('$${b}_{1}[n]$$','interpreter','latex');
subplot(2,1,2);
stem(b2);
xlabel("n");
ylabel('$${b}_{2}[n]$$','interpreter','latex');

x1_t = PulseShaping(b1, one_pulse, zero_pulse);
x2_t = PulseShaping(b2, one_pulse, zero_pulse);
figure();
subplot(2,1,1);
plot((0:1/fs:length(b_n)/2*T-1/fs), x1_t);
title('$${x}_{1}(t)\  {and}\  {x}_{2}(t) $$','interpreter','latex');
xlabel("t");
ylabel('x1(t)');
subplot(2,1,2);
plot((0:1/fs:length(b_n)/2*T-1/fs), x2_t);
xlabel("t");
ylabel('x2(t)');

xc_t = AnalogMod(x1_t, x2_t, fs, fc);
figure();
plot((0:1/fs:length(b_n)/2*T-1/fs), xc_t);
title('$${x}_{c}(t)$$','interpreter','latex');
xlabel("t");
ylabel('xc(t)');

x_receive = Channel(xc_t, fs, fo, BW);
figure();
plot((0:1/fs:length(b_n)/2*T-1/fs), (x_receive));
title('$${x}_{receive}(t)$$','interpreter','latex');
xlabel("t");
ylabel('$${x}_{receive}(t)$$','interpreter','latex');

[y1_t, y2_t] = AnalogDemod(x_receive, fs, BW, fc); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure();
subplot(2,1,1);
plot((0:1/fs:length(b_n)/2*T-1/fs), (y1_t));
title('$${y}_{1}(t)\  {and}\  {y}_{2}(t) $$','interpreter','latex');
xlabel("t");
ylabel('$${y}_{1}(t)$$','interpreter','latex');
subplot(2,1,2);
plot((0:1/fs:length(b_n)/2*T-1/fs), (y2_t));
xlabel("t");
ylabel('$${y}_{2}(t)$$','interpreter','latex');


[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
subplot(4,1,1);
plot((0:length(MatFil_one_1)-1)/fs, (MatFil_one_1));
title('$${MatchedFilters}(t)\  {and}\  \hat{b}[n] $$','interpreter','latex');
xlabel("t");
ylabel('$${Matched Filter}_{one}$$','interpreter','latex');
subplot(4,1,2);
plot((0:length(MatFil_zero_1)-1)/fs, (MatFil_zero_1));
xlabel("t");
ylabel('$${Matched Filter}_{zero}$$','interpreter','latex');
subplot(4,1,3);
stem(b_hat_1);
xlabel("n");
ylabel('$$\hat{b}_{1}$$','interpreter','latex');
subplot(4,1,4);
stem(b_hat_2);
xlabel("n");
ylabel('$$\hat{b}_{2}$$','interpreter','latex');

b_hat = Combine(b_hat_1, b_hat_2);
figure();
stem(b_hat);
title('$$Final Output$$','interpreter','latex');
xlabel("n");
ylabel('$$\hat{b}$$','interpreter','latex');

figure();
stem(b_hat-b_n);
title('$${Error}\ { Of }\ {Reconstruction}$$','interpreter','latex');
xlabel("n");
ylabel('$$\hat{b}\ {-} {b}_{n}$$','interpreter','latex');

    %%
[b1 ,b2] = Divide(b_n);
x1_t = PulseShaping(b1, one_pulse, zero_pulse);
x2_t = PulseShaping(b2, one_pulse, zero_pulse);
xc_t = AnalogMod(x1_t, x2_t, fs, fc);
x_receive = Channel(xc_t, fs, fo, BW);

error = zeros(1,40);
for i=1:40
    x_receive_affected = x_receive + normrnd(0,2.5*i,1,length(x_receive)); 
    [y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
    [MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
    [MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
    b_hat = Combine(b_hat_1, b_hat_2);
    error(i) = sumsqr(b_hat-b_n)/length(b_n);
    %figure();
    %stem(b_hat);
end

figure();
plot((0:0.1:4-0.1)*25,error);
title('$${Probability}\ { Of }\ {Reconstruction}\ {Error}$$','interpreter','latex');
xlabel("{\sigma}^2");
ylabel('$${P}_{error}$$','interpreter','latex');

    %%
[b1 ,b2] = Divide(b_n);
x1_t = PulseShaping(b1, one_pulse, zero_pulse);
x2_t = PulseShaping(b2, one_pulse, zero_pulse);
xc_t = AnalogMod(x1_t, x2_t, fs, fc);
x_receive = Channel(xc_t, fs, fo, BW);

x_receive_affected = x_receive + normrnd(0,0,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
scatter(MatFil_one_1,MatFil_one_2);
title('$${Signal }\  {Constellation }\  {for }\ {\sigma^2}\ { =0} $$','interpreter','latex');

x_receive_affected = x_receive + normrnd(0,1,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
scatter(MatFil_one_1,MatFil_one_2);
title('$${Signal }\  {Constellation }\  {for }\ {\sigma^2}\ { =1} $$','interpreter','latex');

x_receive_affected = x_receive + normrnd(0,5,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
scatter(MatFil_one_1,MatFil_one_2);
title('$${Signal }\  {Constellation }\  {for }\ {\sigma^2}\ { =5} $$','interpreter','latex');

x_receive_affected = x_receive + normrnd(0,10,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
scatter(MatFil_one_1,MatFil_one_2);
title('$${Signal }\  {Constellation }\  {for }\ {\sigma^2}\ { =10} $$','interpreter','latex');

x_receive_affected = x_receive + normrnd(0,30,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
scatter(MatFil_one_1,MatFil_one_2);
title('$${Signal }\  {Constellation }\  {for }\ {\sigma^2}\ { =30} $$','interpreter','latex');

x_receive_affected = x_receive + normrnd(0,75,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
scatter(MatFil_one_1,MatFil_one_2);
title('$${Signal }\  {Constellation }\  {for }\ {\sigma^2}\ { =75} $$','interpreter','latex');

%% 3
fs = 1000000;
T = 0.01;
fc = 10000;
fo = 10000;
BW = 1000;
t = (0:10000-1)*1/fs;
one_pulse = sin(2*pi*100*t); % fs*T =10000
zero_pulse = sin(2*pi*150*t); % fs*T =10000
b_n = (randi([0, 1], [1, 200]));

    %%
[b1 ,b2] = Divide(b_n);
figure();
subplot(2,1,1);
stem(b1);
title('$${b}_{1}\  {and}\  {b}_{2} $$','interpreter','latex');
xlabel("n");
ylabel('$${b}_{1}[n]$$','interpreter','latex');
subplot(2,1,2);
stem(b2);
xlabel("n"); 
ylabel('$${b}_{2}[n]$$','interpreter','latex');

x1_t = PulseShaping(b1, one_pulse, zero_pulse);
x2_t = PulseShaping(b2, one_pulse, zero_pulse);
figure();
subplot(2,1,1);
plot((0:1/fs:length(b_n)/2*T-1/fs), x1_t);
title('$${x}_{1}(t)\  {and}\  {x}_{2}(t) $$','interpreter','latex');
xlabel("t");
ylabel('x1(t)');
subplot(2,1,2);
plot((0:1/fs:length(b_n)/2*T-1/fs), x2_t);
xlabel("t");
ylabel('x2(t)');

xc_t = AnalogMod(x1_t, x2_t, fs, fc);
figure();
plot((0:1/fs:length(b_n)/2*T-1/fs), xc_t);
title('$${x}_{c}(t)$$','interpreter','latex');
xlabel("t");
ylabel('xc(t)');

x_receive = Channel(xc_t, fs, fo, BW);
figure();
plot((0:1/fs:length(b_n)/2*T-1/fs), (x_receive));
title('$${x}_{receive}(t)$$','interpreter','latex');
xlabel("t");
ylabel('$${x}_{receive}(t)$$','interpreter','latex');

[y1_t, y2_t] = AnalogDemod(x_receive, fs, BW, fc); 
figure();
subplot(2,1,1);
plot((0:1/fs:length(b_n)/2*T-1/fs), (y1_t));
title('$${y}_{1}(t)\  {and}\  {y}_{2}(t) $$','interpreter','latex');
xlabel("t");
ylabel('$${y}_{1}(t)$$','interpreter','latex');
subplot(2,1,2);
plot((0:1/fs:length(b_n)/2*T-1/fs), (y2_t));
xlabel("t");
ylabel('$${y}_{2}(t)$$','interpreter','latex');


[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
subplot(4,1,1);
plot((0:length(MatFil_one_1)-1)/fs, (MatFil_one_1));
title('$${MatchedFilters}(t)\  {and}\  \hat{b}[n] $$','interpreter','latex');
xlabel("t");
ylabel('$${Matched Filter}_{one}$$','interpreter','latex');
subplot(4,1,2);
plot((0:length(MatFil_zero_1)-1)/fs, (MatFil_zero_1));
xlabel("t");
ylabel('$${Matched Filter}_{zero}$$','interpreter','latex');
subplot(4,1,3);
stem(b_hat_1);
xlabel("n");
ylabel('$$\hat{b}_{1}$$','interpreter','latex');
subplot(4,1,4);
stem(b_hat_2);
xlabel("n");
ylabel('$$\hat{b}_{2}$$','interpreter','latex');

b_hat = Combine(b_hat_1, b_hat_2);
figure();
stem(b_hat);
title('$$Final Output$$','interpreter','latex');
xlabel("n");
ylabel('$$\hat{b}$$','interpreter','latex');

figure();
stem(b_hat-b_n);
title('$${Error}\ { Of }\ {Reconstruction}$$','interpreter','latex');
xlabel("n");
ylabel('$$\hat{b}\ {-} {b}_{n}$$','interpreter','latex');

    %%
[b1 ,b2] = Divide(b_n);
x1_t = PulseShaping(b1, one_pulse, zero_pulse);
x2_t = PulseShaping(b2, one_pulse, zero_pulse);
xc_t = AnalogMod(x1_t, x2_t, fs, fc);
x_receive = Channel(xc_t, fs, fo, BW);

error = zeros(1,40);
for i=1:40
    x_receive_affected = x_receive + normrnd(0,2.5*i,1,length(x_receive)); 
    [y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
    [MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
    [MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
    b_hat = Combine(b_hat_1, b_hat_2);
    error(i) = sumsqr(b_hat-b_n)/length(b_n);
    %figure();
    %stem(b_hat);
end

figure();
plot((0:0.1:4-0.1)*25,error);
title('$${Probability}\ { Of }\ {Reconstruction}\ {Error}$$','interpreter','latex');
xlabel("{\sigma}^2");
ylabel('$${P}_{error}$$','interpreter','latex');

    %%
[b1 ,b2] = Divide(b_n);
x1_t = PulseShaping(b1, one_pulse, zero_pulse);
x2_t = PulseShaping(b2, one_pulse, zero_pulse);
xc_t = AnalogMod(x1_t, x2_t, fs, fc);
x_receive = Channel(xc_t, fs, fo, BW);

x_receive_affected = x_receive + normrnd(0,0,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
scatter(MatFil_one_1,MatFil_one_2);
title('$${Signal }\  {Constellation }\  {for }\ {\sigma^2}\ { =0} $$','interpreter','latex');

x_receive_affected = x_receive + normrnd(0,1,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
scatter(MatFil_one_1,MatFil_one_2);
title('$${Signal }\  {Constellation }\  {for }\ {\sigma^2}\ { =1} $$','interpreter','latex');

x_receive_affected = x_receive + normrnd(0,5,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
scatter(MatFil_one_1,MatFil_one_2);
title('$${Signal }\  {Constellation }\  {for }\ {\sigma^2}\ { =5} $$','interpreter','latex');

x_receive_affected = x_receive + normrnd(0,10,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
scatter(MatFil_one_1,MatFil_one_2);
title('$${Signal }\  {Constellation }\  {for }\ {\sigma^2}\ { =10} $$','interpreter','latex');

x_receive_affected = x_receive + normrnd(0,30,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
scatter(MatFil_one_1,MatFil_one_2);
title('$${Signal }\  {Constellation }\  {for }\ {\sigma^2}\ { =30} $$','interpreter','latex');

x_receive_affected = x_receive + normrnd(0,75,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
scatter(MatFil_one_1,MatFil_one_2);
title('$${Signal }\  {Constellation }\  {for }\ {\sigma^2}\ { =75} $$','interpreter','latex');








%% Section4: 2
fs = 1000000;
T = 0.01;
fc = 10000;
fo = 10000;
BW = 1000;
one_pulse = ones(1, 10000); % fs*T =10000
one_pulse(5001:10000) = 0;
zero_pulse = -ones(1, 10000); % fs*T =10000
zero_pulse(5001:10000) = 0;
integers = randi([0 255], [1, 100]);

    %% extra
figure();
stem(integers);
title('$${Transmitted}\ {Digits}$$','interpreter','latex');
xlabel("n");
ylabel('$${d}$$','interpreter','latex');    
    
b_n = SourceGenerator(integers);   
figure();
stem(b_n);
title('$${Source}\ {Generator}\  {Otput}$$','interpreter','latex');
xlabel("n");
ylabel('$${b}[n]$$','interpreter','latex');

[b1 ,b2] = Divide(b_n);
figure();
subplot(2,1,1);
stem(b1);
title('$${b}_{1}\  {and}\  {b}_{2} $$','interpreter','latex');
xlabel("n");
ylabel('$${b}_{1}[n]$$','interpreter','latex');
subplot(2,1,2);
stem(b2);
xlabel("n");
ylabel('$${b}_{2}[n]$$','interpreter','latex');

x1_t = PulseShaping(b1, one_pulse, zero_pulse);
x2_t = PulseShaping(b2, one_pulse, zero_pulse);
figure();
subplot(2,1,1);
plot((0:1/fs:length(b_n)/2*T-1/fs), x1_t);
title('$${x}_{1}(t)\  {and}\  {x}_{2}(t) $$','interpreter','latex');
xlabel("t");
ylabel('x1(t)');
subplot(2,1,2);
plot((0:1/fs:length(b_n)/2*T-1/fs), x2_t);
xlabel("t");
ylabel('x2(t)');

xc_t = AnalogMod(x1_t, x2_t, fs, fc);
figure();
plot((0:1/fs:length(b_n)/2*T-1/fs), xc_t);
title('$${x}_{c}(t)$$','interpreter','latex');
xlabel("t");
ylabel('xc(t)');

x_receive = Channel(xc_t, fs, fo, BW);
figure();
plot((0:1/fs:length(b_n)/2*T-1/fs), (x_receive));
title('$${x}_{receive}(t)$$','interpreter','latex');
xlabel("t");
ylabel('$${x}_{receive}(t)$$','interpreter','latex');

[y1_t, y2_t] = AnalogDemod(x_receive, fs, BW, fc); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure();
subplot(2,1,1);
plot((0:1/fs:length(b_n)/2*T-1/fs), (y1_t));
title('$${y}_{1}(t)\  {and}\  {y}_{2}(t) $$','interpreter','latex');
xlabel("t");
ylabel('$${y}_{1}(t)$$','interpreter','latex');
subplot(2,1,2);
plot((0:1/fs:length(b_n)/2*T-1/fs), (y2_t));
xlabel("t");
ylabel('$${y}_{2}(t)$$','interpreter','latex');


[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
figure();
subplot(4,1,1);
plot((0:length(MatFil_one_1)-1)/fs, (MatFil_one_1));
title('$${MatchedFilters}(t)\  {and}\  \hat{b}[n] $$','interpreter','latex');
xlabel("t");
ylabel('$${Matched Filter}_{one}$$','interpreter','latex');
subplot(4,1,2);
plot((0:length(MatFil_zero_1)-1)/fs, (MatFil_zero_1));
xlabel("t");
ylabel('$${Matched Filter}_{zero}$$','interpreter','latex');
subplot(4,1,3);
stem(b_hat_1);
xlabel("n");
ylabel('$$\hat{b}_{1}$$','interpreter','latex');
subplot(4,1,4);
stem(b_hat_2);
xlabel("n");
ylabel('$$\hat{b}_{2}$$','interpreter','latex');

b_hat = Combine(b_hat_1, b_hat_2);
figure();
stem(b_hat);
title('$$Final Output$$','interpreter','latex');
xlabel("n");
ylabel('$$\hat{b}$$','interpreter','latex');

recunstructed_integers = OutputDecoder(b_hat);
stem(recunstructed_integers);
title('$${Otput}\ {Decoder}\  {Result}$$','interpreter','latex');
xlabel("n");
ylabel('$$\hat{d}$$','interpreter','latex');

figure();
stem(recunstructed_integers - integers);
title('$${Error}\ { Of }\ {Reconstruction}$$','interpreter','latex');
xlabel("n");
ylabel('$$\hat{digits}\ {-} {digits}$$','interpreter','latex');

    %% 2
b_n = SourceGenerator(integers); 
[b1 ,b2] = Divide(b_n);
x1_t = PulseShaping(b1, one_pulse, zero_pulse);
x2_t = PulseShaping(b2, one_pulse, zero_pulse);
xc_t = AnalogMod(x1_t, x2_t, fs, fc);
x_receive = Channel(xc_t, fs, fo, BW);

var_error = zeros(1,40);
for i=1:40
    x_receive_affected = x_receive + normrnd(0,2.5*i,1,length(x_receive)); 
    [y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
    [MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
    [MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
    b_hat = Combine(b_hat_1, b_hat_2);
    recunstructed_integers = OutputDecoder(b_hat);
    var_error(i) = var((recunstructed_integers - integers).^2);
end

figure();
plot((0:0.1:4-0.1)*25,var_error);
title("{\sigma}^2 Of Reconstruction Error");
xlabel("{\sigma}^2 of noise");
ylabel("{\sigma}^2 of digits error");

    %% 3
b_n = SourceGenerator(integers); 
[b1 ,b2] = Divide(b_n);
x1_t = PulseShaping(b1, one_pulse, zero_pulse);
x2_t = PulseShaping(b2, one_pulse, zero_pulse);
xc_t = AnalogMod(x1_t, x2_t, fs, fc);
x_receive = Channel(xc_t, fs, fo, BW);


x_receive_affected = x_receive + normrnd(0,0,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
b_hat = Combine(b_hat_1, b_hat_2);
recunstructed_integers = OutputDecoder(b_hat);
error = (recunstructed_integers - integers).^2;
figure();
stem(error);
title('$${Error }\  {Distribution }\  {for }\ {\sigma^2}_{noise}\ { =0} $$','interpreter','latex');
xlabel("n");
ylabel("Error Distibution");

x_receive_affected = x_receive + normrnd(0,1,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
b_hat = Combine(b_hat_1, b_hat_2);
recunstructed_integers = OutputDecoder(b_hat);
error = (recunstructed_integers - integers).^2;
figure();
stem(error);
title('$${Error }\  {Distribution }\  {for }\ {\sigma^2}_{noise}\ { =1} $$','interpreter','latex');
xlabel("n");
ylabel("Error Distibution");

x_receive_affected = x_receive + normrnd(0,5,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
b_hat = Combine(b_hat_1, b_hat_2);
recunstructed_integers = OutputDecoder(b_hat);
error = (recunstructed_integers - integers).^2;
figure();
stem(error);
title('$${Error }\  {Distribution }\  {for }\ {\sigma^2}_{noise}\ { =5} $$','interpreter','latex');
xlabel("n");
ylabel("Error Distibution");

x_receive_affected = x_receive + normrnd(0,10,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
b_hat = Combine(b_hat_1, b_hat_2);
recunstructed_integers = OutputDecoder(b_hat);
error = (recunstructed_integers - integers).^2;
figure();
stem(error);
title('$${Error }\  {Distribution }\  {for }\ {\sigma^2}_{noise}\ { =10} $$','interpreter','latex');
xlabel("n");
ylabel("Error Distibution");

x_receive_affected = x_receive + normrnd(0,25,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
b_hat = Combine(b_hat_1, b_hat_2);
recunstructed_integers = OutputDecoder(b_hat);
error = (recunstructed_integers - integers).^2;
figure();
stem(error);
title('$${Error }\  {Distribution }\  {for }\ {\sigma^2}_{noise}\ { =25} $$','interpreter','latex');
xlabel("n");
ylabel("Error Distibution");

x_receive_affected = x_receive + normrnd(0,70,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
b_hat = Combine(b_hat_1, b_hat_2);
recunstructed_integers = OutputDecoder(b_hat);
error = (recunstructed_integers - integers).^2;
figure();
stem(error);
title('$${Error }\  {Distribution }\  {for }\ {\sigma^2}_{noise}\ { =70} $$','interpreter','latex');
xlabel("n");
ylabel("Error Distibution");

x_receive_affected = x_receive + normrnd(0,150,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
b_hat = Combine(b_hat_1, b_hat_2);
recunstructed_integers = OutputDecoder(b_hat);
error = (recunstructed_integers - integers).^2;
figure();
stem(error);
title('$${Error }\  {Distribution }\  {for }\ {\sigma^2}_{noise}\ { =150} $$','interpreter','latex');
xlabel("n");
ylabel("Error Distibution");

x_receive_affected = x_receive + normrnd(0,500,1,length(x_receive)); 
[y1_t, y2_t] = AnalogDemod(x_receive_affected, fs, BW, fc);
[MatFil_one_1, MatFil_zero_1, b_hat_1] = MatchedFilt(y1_t, one_pulse, zero_pulse);
[MatFil_one_2, MatFil_zero_2, b_hat_2] = MatchedFilt(y2_t, one_pulse, zero_pulse);
b_hat = Combine(b_hat_1, b_hat_2);
recunstructed_integers = OutputDecoder(b_hat);
error = (recunstructed_integers - integers).^2;
figure();
stem(error);
title('$${Error }\  {Distribution }\  {for }\ {\sigma^2}_{noise}\ { =500} $$','interpreter','latex');
xlabel("n");
ylabel("Error Distibution");



   





%% Section5(8)
iid_generated_symbols = InformationSource(28);

codded_symbols = SourceEncoder(28,iid_generated_symbols);

decodded_codes = SourceDecoder(codded_symbols);

counter = 0 ;
result = zeros(1,2);
for i=1:1:10
    a = InformationSource(i);
    b = SourceEncoder(i,a);
    c = SourceDecoder(b);
    if a == c 
        counter = counter + 1 ; 
    end    
    %result(i/10) = length(b)/i;
end
if counter == 10
     fprintf("true");
else
     print("false");
end    
figure;
plot(1:10:1500,result);
title('$$H_n {X} = {average}\ {bits}\ {needed}\ {for}\ {codding} {n}\ {symbols}$$','interpreter','latex');
xlabel('number of symbol');
ylabel('$$\frac{L_B (n)}{n} $$','interpreter','latex');
% % ylim([0,3]);
% % grid on;
% % grid minor;
% % result = zeros(1,200);
%% %% Section5(9)
iid_generated_symbols = InformationSource(20);

codded_symbols = SourceEncoder(20,iid_generated_symbols);

decodded_codes = SourceDecoder(codded_symbols);


result = zeros(1,100);
for i=10:10:1000
    a = InformationSource(i);
    b = SourceEncoder(i,a);
    
    result(i/10) = length(b)/i;
end
    
figure;
plot(10:10:1000,result);
title('$$H_n {X} = {average}\ {bits}\ {needed}\ {for}\ {codding} {n}\ {symbols}$$','interpreter','latex');
xlabel('number of symbol');
ylabel('$$\frac{L_B (n)}{n} $$','interpreter','latex');
ylim([0,3]);
grid on;
grid minor;
%% Section2
function [b1, b2] = Divide(b)
    b1 = b(1:2:length(b));
    b2 = b(2:2:length(b));
end


function b_hat = Combine(b1_hat, b2_hat)
    b_hat = zeros(1, 2*length(b1_hat));
    for i=1:length(b1_hat)
        b_hat(2*i-1) = b1_hat(i);
        b_hat(2*i) = b2_hat(i);
    end
end

function x_t = PulseShaping(input, one_pulse, zero_pulse)
    x_t = zeros(1, length(input)*length(one_pulse));
    for i=1:length(input)
        if input(i)==0
            x_t((i-1)*length(zero_pulse)+1 : i*length(zero_pulse)) = zero_pulse; %% be ezaye har 0 yek pulse_zero dar khorooji tolid mikonim.
        else
            x_t((i-1)*length(one_pulse)+1 : i*length(one_pulse)) = one_pulse; %% be ezaye har 1 yek pulse_one dar khorooji tolid mikonim.
        end
    end

end

function xc_t = AnalogMod(x1, x2, fs, fc)
    t = (0:length(x1)-1)*1/fs;
    sig1 = x1 .* cos(2*pi*fc*t);
    sig2 = x2 .* sin(2*pi*fc*t);
    xc_t = (sig1 + sig2)/norm(sig1 + sig2); %%%%%
end

function x_receive = Channel(x_transmit, fs, fo, BW)
    t = (0:length(x_transmit)-1)*1/fs;
    filter_t_domain = BW*sinc(BW*t);
    sig1 = filter_t_domain .* exp(1i*2*pi*fo*t);
    sig2 = filter_t_domain .* exp(-1i*2*pi*fo*t);
    filter_f_domain = fftshift(fft(sig1+sig2));
    sig_f_domain = fftshift(fft(x_transmit));
    out = sig_f_domain .* filter_f_domain;
    x_receive = ifftshift(ifft(out));
    x_receive = x_receive/(0.002*norm(x_receive));%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end

function [y1_t, y2_t] = AnalogDemod(x_received, fs, BW, fc)
    t = (0:length(x_received)-1)*1/fs;
    sig1 = x_received .* cos(2*pi*fc*t);
    sig2 = x_received .* sin(2*pi*fc*t);
    
    filter_t_domain = 2*BW*sinc(2*BW*t);
    filter_f_domain = fftshift(fft(filter_t_domain));
    sig_f_domain1 = fftshift(fft(sig1));
    sig_f_domain2 = fftshift(fft(sig2));
    out1 = sig_f_domain1 .* filter_f_domain;
    out2 = sig_f_domain2 .* filter_f_domain;
    y1_t = (ifftshift(ifft(out1)));
    %y1_t = y1_t/norm(y1_t);
    y2_t = (ifftshift(ifft(out2)));
    %y2_t = y2_t;
end

function [MatFil_one, MatFil_zero, b_hat] = MatchedFilt(y_t, one_pulse, zero_pulse)
    MatchedFilter_one = fliplr(one_pulse);
    MatchedFilter_zero = fliplr(zero_pulse); %%tebgh tarif: h=p(T-t)
    
    MF_one_fft = fft(MatchedFilter_one);
    MF_zero_fft = fft(MatchedFilter_zero);
    
    
    for i=1:length(y_t)/length(one_pulse)
        y_f = fft(y_t((i-1)*length(one_pulse)+1:i*length(one_pulse)));
        sig_one((i-1)*length(one_pulse)+1:i*length(one_pulse)) = ifft(y_f .* MF_one_fft);
        sig_zero((i-1)*length(zero_pulse)+1:i*length(zero_pulse)) = ifft(y_f .* MF_zero_fft);
    end
    
    
    MatFil_one = sig_one(length(one_pulse):length(one_pulse):length(sig_one));
    MatFil_zero = sig_zero(length(zero_pulse):length(zero_pulse):length(sig_zero));

    b_hat = zeros(1, length(y_t)/length(one_pulse));
    for i=1:length(b_hat)
        if MatFil_one(i) > MatFil_zero(i)
            b_hat(i) = 1;
        end %else doesn't need, becuse we defined b_hat as zeros at first
    end

    
end

 %% 4_functions 
function binary_out = SourceGenerator(in)
    temp = de2bi(in,8,'left-msb');
    binary_out = zeros(1, 8*length(in));
    
    for i=1:length(in)
        binary_out((i-1)*8+1: i*8) = temp(i,1:8);
    end

end


function integer_out = OutputDecoder(in)
    integer_out = zeros(1, length(in)/8);
    for i=1:length(integer_out)
       integer_out(i) = bi2de(in((i-1)*8+1: i*8),'left-msb');
    end
end

%% 5_functions
function symbols_iid = InformationSource(n)
Ix = [0,50,100,150,200,250]; 
probabilities = [0.5 0.03125 0.125 0.0625 0.03125 0.25];
indices = randsrc(1,n,[1:length(Ix); probabilities]);
symbols_iid = Ix(indices);
end


function codes = SourceEncoder(n,symbols)
if symbols(1) == 0
    codes = 0;
elseif symbols(1) == 250
        codes = [1 0];
elseif symbols(1)== 100
        codes = [1 1 0];
elseif symbols(1)== 150
        codes = [1 1 1 0];
elseif symbols(1)== 200
        codes = [1 1 1 1 0];
else 
        codes = [1 1 1 1 1];
end
        
for i=2:n
    if symbols(i) == 0
        codes(end+1) = 0;
    elseif symbols(i) == 250
        codes(end+1:end+2) = [1 0];
    elseif symbols(i) == 100
        codes(end+1:end+3) = [1 1 0];
    elseif symbols(i) == 150
        codes(end+1:end+4) = [1 1 1 0];
    elseif symbols(i) == 200
        codes(end+1:end+5) = [1 1 1 1 0];
    else
        codes(end+1:end+5) = [1 1 1 1 1];
    end
end
end


function symbols = SourceDecoder(codes)
mapping = {0,0; 250,[1 0]; 100,[1 1 0]; 150,[1 1 1 0]; 200,[1 1 1 1 0]; 50,[1 1 1 1 1]};
temp = huffmandeco(codes,mapping);
symbols = temp;
symbols = strrep(symbols,' ','');
end