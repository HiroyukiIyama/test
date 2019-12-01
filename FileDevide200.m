%% Yのデータ
clear all;
Y = csvread('NoNoise000_Y.csv');

Y0200 = Y(1:200,:);
csvwrite('NoNoise_Y0200.csv',Y0200);
clear Y0200;
Y0400 = Y(201:400,:);
csvwrite('NoNoise_Y0400.csv',Y0400);
clear Y0400;
Y0600 = Y(401:600,:);
csvwrite('NoNoise_Y0600.csv',Y0600);
clear Y0600;
Y0800 = Y(601:800,:);
csvwrite('NoNoise_Y0800.csv',Y0800);
clear Y0800;
Y1000 = Y(801:1000,:);
csvwrite('NoNoise_Y1000.csv',Y1000);
clear Y1000;
Y1100 = Y(1001:1100,:);
csvwrite('NoNoise_Y1100.csv',Y1100);
clear Y1100;

%% Xのデータ
clear all;
X = csvread('NoNoise000_X.csv');

X0200 = X(          1 : 200 * 5,:);
csvwrite('NoNoise_X0200.csv',X0200);
clear X0200;
X0400 = X(200 * 5 + 1 : 400 * 5,:);
csvwrite('NoNoise_X0400.csv',X0400);
clear X0400;
X0600 = X(400 * 5 + 1 : 600 * 5,:);
csvwrite('NoNoise_X0600.csv',X0600);
clear X0600;
X0800 = X(600 * 5 + 1 : 800 * 5,:);
csvwrite('NoNoise_X0800.csv',X0800);
clear X0800;
X1000 = X(800 * 5 + 1 : 1000 * 5,:);
csvwrite('NoNoise_X1000.csv',X1000);
clear X1000;
X1100 = X(1000 * 5 + 1 : 1100 * 5,:);
csvwrite('NoNoise_X1100.csv',X1100);
clear X1100;
clear all;