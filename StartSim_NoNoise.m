% モデルへの入力
% 　d軸電流(ノイズを含まない)
% 　q軸電流(ノイズを含まない)
% 　d軸電圧(特定パターンの印加電圧)
% 　q軸電圧(特定パターンの印加電圧)
% 　回転速度
% 
% モデルの出力
% 　モータ抵抗
% 　モータインダクタンス
% 　モータ誘起電圧
% 　電気角度オフセット

%% 全体繰り返し
clear all;
for loop = 1:5
    IndexNum = 200; %時系列データ200セットで約100MByte
    for index = 1:IndexNum
        rng('shuffle'); %ランダムシードの現在時刻を利用したシャッフル

        DCVoltage = 100;
        AmpCarryFreq = 20e3; %PWMのキャリア周波数
        Ts = 1e-6;           %ホワイトノイズのサンプル周期
        MotVisco = 0.01*rand()*1e-6; %モータの粘性摩擦
        ElecAngOfsError = pi * 2.0 * (rand() - 0.5);

        % モータスペックをラベルとして読み込み
        % 01 シリーズ名
        % 02 定格電力 W
        % 03 公称電圧 V
        % 04 無負荷回転数 rpm
        % 05 無負荷電流 mA
        % 06 最大連続トルク時の回転数 rpm
        % 07 最大連続トルク mNm
        % 08 最大連続電流 A
        % 09 停動トルク mNm
        % 10 起動電流 A
        % 11 最大効率 %
        % 12 端子間抵抗 ohm
        % 13 端子間インダクタンス mH
        % 14 トルク定数 mNm/A
        % 15 回転数定数 rpm/V
        % 16 回転数／トルク勾配 rpm/mNm
        % 17 機械的時定数 ms
        % 18 ロータ慣性モーメント gcm2
        % 19 永久磁石磁極ペア数
        % 20 位相数	モータ質量g

        FileName = 'maxon_motors004_enc.csv';
        MotorSpec = readmatrix(FileName);
        [m,n] = size(MotorSpec);
        randum_index = randi(m);

        %公称電圧
        VNorm = MotorSpec(randum_index,3);
        %マクソンはΩで端子間抵抗が規定される
        MotPhaseR = MotorSpec(randum_index,12);
        %マクソンはmHで端子間インダクタンスが規定されるため1e-3をかけてHに変換する
        MotPhaseL = MotorSpec(randum_index,13) * 1e-3;
        %モータ端子間電圧の単位変換、換算
        MotKV = 1 / MotorSpec(randum_index,15); % 単位変換 rpm/V →　V/rpm
        MotKV = 1000 * MotKV;                   % 単位変換 V/rpm →　V/krpm
        MotKV = 2 * MotKV; %マクソンは端子間誘起電圧の1/2として数値が規定されるため2倍する
        %マクソンはイナーシャがgcm^2として規定されるため1e-7をかけてkgm^2に変換する
        MotInertia = MotorSpec(randum_index,18) * 1e-7;
        MotPole = MotorSpec(randum_index,19);    

        %%実機を想定しバラつきを与える(±10%)
        MotPhaseR = MotPhaseR * (1 + 0.1 * 2 * (rand() - 0.5));
        MotPhaseL = MotPhaseL * (1 + 0.1 * 2 * (rand() - 0.5));
        MotKV = MotKV * (1 + 0.1 * 2 * (rand() - 0.5));
        MotInertia = MotInertia * (1 + 0.1 * 2 * (rand() - 0.5));

        VoltAmp = VNorm / 2; %実機を想定し過大にならないように印可電圧を設定
        if VoltAmp > 5.0
           VoltAmp = 5.0;
        end

        VoltAmp = VoltAmp * (1 + 0.1 * 2 * (rand() - 0.5)); %実機を想定しバラつきを与える

        DeltaT = 0.1;
        T0 = 0.01 * rand();                                %実機を想定しバラつきを与える
        T1 = T0 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5));  %実機を想定しバラつきを与える
        T2 = T1 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5));  %実機を想定しバラつきを与える
        T3 = T2 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5));  %実機を想定しバラつきを与える
        T4 = T3 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5));  %実機を想定しバラつきを与える
        T5 = T4 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5));  %実機を想定しバラつきを与える
        T6 = T5 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5));  %実機を想定しバラつきを与える
        T7 = T6 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5));  %実機を想定しバラつきを与える
        T8 = T7 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5));  %実機を想定しバラつきを与える
        T9 = T8 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5));  %実機を想定しバラつきを与える

        qVoltIn = ...
            [ 0        0; T0        0;...
             T0  VoltAmp; T1  VoltAmp;...
             T1 -VoltAmp; T2 -VoltAmp;...
             T2  VoltAmp; T3  VoltAmp;...
             T3 -VoltAmp; T4 -VoltAmp;...
             T4        0; T5        0;...
             ];

        dVoltIn = ...
            [  0       0; T5        0;...
             T5  VoltAmp; T6  VoltAmp;...
             T6 -VoltAmp; T7 -VoltAmp;...
             T7  VoltAmp; T8  VoltAmp;...
             T8 -VoltAmp; T9 -VoltAmp;...
             T9        0; 1.0       0;...
            ];

        %% シミュレーション実施
        tic
        disp(['loop : ' num2str(loop) ' index : ' num2str(index) ' start...']);
        out = sim('VectorControl_NoNoise');
        toc

        %% データ保存
        Savedata_NoNoise(out, loop, index, IndexNum, MotPhaseR, MotPhaseL, MotKV, ElecAngOfsError)

        %% 後始末
        clear out;
    end
end