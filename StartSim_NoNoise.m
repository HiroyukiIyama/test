% モデルへの入力
% 　d軸電流(ノイズを含む)
% 　q軸電流(ノイズを含む)
% 　d軸電圧(ランダムで生成した印加電圧)
% 　q軸電圧(ランダムに生成した印加電圧)
% 　回転速度
% 
% モデルの出力
% 　モータ抵抗
% 　モータインダクタンス
% 　モータ誘起電圧
% 　U相電流ゲインばらつき
% 　V相電流ゲインばらつき
% 　W相電流ゲインばらつき
% 　U相電流オフセット
% 　V相電流オフセット
% 　W相電流オフセット
% 　電気角度オフセット
% 
% 環境要因
% 　電流ノイズ(白色ノイズを与える)
% 　角度ノイズ(白色ノイズを与える)
% 　モータイナーシャ(毎回のシミュレーションでランダムに変更)
% 　モータ摩擦(毎回のシミュレーションでランダムに変更)


%% 全体繰り返し
for index = 1:1
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
    
    %マクソンはmΩで端子間抵抗が規定されるため1e3をかけてΩに変換する
    MotPhaseR = MotorSpec(randum_index,12) * 1e3;
    MotPhaseL = MotorSpec(randum_index,13);
    MotKV = MotorSpec(randum_index,15);
    MotInertia = MotorSpec(randum_index,18);
    MotPole = MotorSpec(randum_index,19);    
    %マクソンは端子間誘起電圧の1/2として数値が規定されるため2倍する
    MotKV = MotKV * 2;
    %マクソンはイナーシャがgcm^2として規定されるため1e-7をかけてkgm^2に変換する
    MotInertia = MotInertia * 1e-7;

    %規定スペックの±10%ばらつきを与える
    MotPhaseR = MotPhaseR * (1 + 0.1 * 2 * (rand() - 0.5));
    MotPhaseL = MotPhaseL * (1 + 0.1 * 2 * (rand() - 0.5));
    MotKV = MotKV * (1 + 0.1 * 2 * (rand() - 0.5));
    MotInertia = MotInertia * (1 + 0.1 * 2 * (rand() - 0.5));
    
    %電圧印可パターンの作成
    VoltAmp = 10 * (1 + 0.1 * 2 * (rand() - 0.5));
    DeltaT = 0.1;
    T0 = 0.01 * rand();
    T1 = T0 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5)); 
    T2 = T1 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5)); 
    T3 = T2 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5)); 
    T4 = T3 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5)); 
    T5 = T4 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5)); 
    T6 = T5 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5)); 
    T7 = T6 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5)); 
    T8 = T7 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5)); 
    T9 = T8 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5)); 

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
   
%     qVoltIn = ...
%         [  0  VoltAmp; 0.1  VoltAmp;...
%          0.1 -VoltAmp; 0.2 -VoltAmp;...
%          0.2  VoltAmp; 0.3  VoltAmp;...
%          0.3 -VoltAmp; 0.4 -VoltAmp;...
%          0.4   0; 0.5   0;...
%          ];
% 
%     dVoltIn = ...
%         [  0   0; 0.1   0;...
%          0.1   0; 0.2   0;...
%          0.2   0; 0.3   0;...
%          0.3   0; 0.4   0;...
%          0.4   0; 0.5   0;...
%          0.5  VoltAmp; 0.6  VoltAmp;...
%          0.6 -VoltAmp; 0.7 -VoltAmp;...
%          0.7  VoltAmp; 0.8  VoltAmp;...
%          0.8 -VoltAmp; 0.9 -VoltAmp;...
%          0.9   0; 1.0   0;...
%         ];

    %% シミュレーション実施
    tic
    disp(['index : ' num2str(index) ' start...']);
    out = sim('VectorControl_NoNoise');
    toc

    %% データ保存
    Savedata_NoNoise(out, index, MotPhaseR, MotPhaseL, MotKV,...
             ElecAngOfsError)

    %% 後始末
    clear all;
end