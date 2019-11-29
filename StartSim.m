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
for index = 1054:1500

    %% パラメータ設定

    rng('shuffle'); %ランダムシードの現在時刻を利用したシャッフル
    %電源電圧
    DCVoltage = 100;
    %アンプのパラメータ
    AmpCarryFreq = 20e3;%PWMのキャリア周波数
    Ts = 1e-6; %ホワイトノイズのサンプル周期

    MotInertia = 0.1*rand()*1e-3;
    MotVisco = 0.01*rand()*1e-6;
    MotPole = 1; %極数20

    MotPhaseR = 0.001 + 10 * rand();
    MotPhaseL = (0.001 + 10 * rand())*1e-3;
    MotKV = 0.01 + 50 * rand();

    VoltAmp = 10;

    SignaltoNoise = 1000;
    AmpSignal = VoltAmp / MotPhaseR;
    AmpNoise = AmpSignal/SignaltoNoise;% 電流ノイズのピーク値[A]
    
    CurOfsError_U = AmpNoise * rand();
    CurOfsError_V = AmpNoise * rand();
    CurOfsError_W = AmpNoise * rand();

    CurGainError_U = 1 + 0.2*(rand() - 0.5);
    CurGainError_V = 1 + 0.2*(rand() - 0.5);
    CurGainError_W = 1 + 0.2*(rand() - 0.5);

    ElecAngNoise = 0.01;% 角度ノイズのピーク値[rad]
    ElecAngOfsError = pi * 2.0 * (rand() - 0.5);

    qVoltIn = ...
        [  0  VoltAmp; 0.1  VoltAmp;...
         0.1 -VoltAmp; 0.2 -VoltAmp;...
         0.2  VoltAmp; 0.3  VoltAmp;...
         0.3 -VoltAmp; 0.4 -VoltAmp;...
         0.4   0; 0.5   0;...
         ];

    dVoltIn = ...
        [  0   0; 0.1   0;...
         0.1   0; 0.2   0;...
         0.2   0; 0.3   0;...
         0.3   0; 0.4   0;...
         0.4   0; 0.5   0;...
         0.5  VoltAmp; 0.6  VoltAmp;...
         0.6 -VoltAmp; 0.7 -VoltAmp;...
         0.7  VoltAmp; 0.8  VoltAmp;...
         0.8 -VoltAmp; 0.9 -VoltAmp;...
         0.9   0; 1.0   0;...
        ];

    %% シミュレーション実施
    tic
    disp(['index : ' num2str(index) ' start...']);
    out = sim('VectorControl003');
    disp(['index : ' num2str(index) ' ...end']);
    toc

    %% データ保存
    Savedata(out, index, MotPhaseR, MotPhaseL, MotKV,...
             CurGainError_U, CurGainError_V, CurGainError_W,...
             CurOfsError_U, CurOfsError_V, CurOfsError_W,...
             ElecAngOfsError)

    %% 後始末
    clear all;
end