%% Yのデータ(NoNoise000_Y.csv)
Y = csvread('NoNoise000_Y.csv');

csvwrite('NoNoise_Y0200.csv',Y(   1: 200,:));
csvwrite('NoNoise_Y0400.csv',Y( 201: 400,:));
csvwrite('NoNoise_Y0600.csv',Y( 401: 600,:));
csvwrite('NoNoise_Y0800.csv',Y( 601: 800,:));
csvwrite('NoNoise_Y1000.csv',Y( 801:1000,:));
csvwrite('NoNoise_Y1100.csv',Y(1001:1100,:));
clear all;

%% Xのデータ(NoNoise000_X.csv)
X = csvread('NoNoise000_X.csv');

csvwrite('NoNoise_X0200.csv',X(           1 :  200 * 5,:));
csvwrite('NoNoise_X0400.csv',X( 200 * 5 + 1 :  400 * 5,:));
csvwrite('NoNoise_X0600.csv',X( 400 * 5 + 1 :  600 * 5,:));
csvwrite('NoNoise_X0800.csv',X( 600 * 5 + 1 :  800 * 5,:));
csvwrite('NoNoise_X1000.csv',X( 800 * 5 + 1 : 1000 * 5,:));
csvwrite('NoNoise_X1100.csv',X(1000 * 5 + 1 : 1100 * 5,:));
clear all;

%% Yのデータ(NoNoise001_Y.csv)
Y = csvread('NoNoise001_Y.csv');

csvwrite('NoNoise_Y1200.csv',Y(  1 + 1 : 100 + 1, :));
csvwrite('NoNoise_Y1400.csv',Y(101 + 1 : 300 + 1, :));
csvwrite('NoNoise_Y1500.csv',Y(301 + 1 : 400 + 1, :));
clear all;

%% Xのデータ(NoNoise001_X.csv)
clear all;
X = csvread('NoNoise001_X.csv');

csvwrite('NoNoise_X1200.csv',X(  1 * 5 + 1 : (100 + 1) * 5,:));
csvwrite('NoNoise_X1400.csv',X(101 * 5 + 1 : (300 + 1) * 5,:));
csvwrite('NoNoise_X1500.csv',X(301 * 5 + 1 : (400 + 1) * 5,:));
clear all;