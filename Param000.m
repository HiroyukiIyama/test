%% モデルで利用するパラメータ群の設定
clear all;

%電源電圧
DCVoltage = 24;

%アンプのパラメータ
AmpCarryFreq = 20e3;%PWMのキャリア周波数

%モータのパラメータ
MotPhaseR = 25e-3; %1相あたりの抵抗値。線間抵抗の1/2。
MotPhaseL = 38.7e-6; %1相あたりのインダクタンス。線間インダクタンスの1/2。
MotVoltageConst = 1000/27; %誘起電圧定数
MotInertia = 0.184e-3; %非公開なので類似モータの値を仮設定
MotVisco = 1e-6; %1e-6 %非公開なので類似モータの値を仮設定
MotPole = 20; %極数20
MAXRPM = 10000;

Register = [0.01 0.1 1 10 100]; %ohm
Inductance =  [0.01 0.1 1 10 100]; %mH
MotVolt = [0.1 1 10 100 1000]; %V/krpm
[~, size_R] = size(Register);
[~, size_L] = size(Inductance);
[~, size_V] = size(MotVolt);
Table = zeros(size_R * size_L * size_V, 3);
i = 0;
for R = Register
    for L = Inductance
        for V = MotVolt
            s = [R L V];
            i = i+1;
            Table(i,:) = s;

            % Parameters to be predicted
            MotPhaseR = R;
            MotPhaseL = L;
            MotVoltageConst = V;

            for i = 1:10
                % Conditions to cover various motion
                % VdとVqはsimulinkの中で100msごとに変化するようにしたほうがよさそう
                % 実際のVdとVqの操作はコントローラ次第
                % スタート地点と増減の傾きを指定して、一定電圧で飽和させるほうがよさそう
%                 Vq_start = DCVoltage * sqrt(3) * 2 * (rand - 0.5)
%                 Vd_start = DCVoltage * sqrt(3) * 2 * (rand - 0.5)
%                 Vq_end = DCVoltage * sqrt(3) * 2 * (rand - 0.5)
%                 Vd_end = DCVoltage * sqrt(3) * 2 * (rand - 0.5)
                RPM_start = MAXRPM * 2 * (rand - 0.5)
                RPM_end = MAXRPM * 2 * (rand - 0.5)
%                 sim("VectorControl003");
%                 save to csv or something;
%                 clear all;
            end
        end
    end
end
