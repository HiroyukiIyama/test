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
for index = 1:1000

    %% パラメータ設定

    %電源電圧
    DCVoltage = 100;
    %アンプのパラメータ
    AmpCarryFreq = 20e3;%PWMのキャリア周波数

    MotInertia = 10*rand()*1e-3;
    MotVisco = rand()*1e-6;
    MotPole = 20; %極数20

    CurNoise = 1e-9;
    CurOfsError_U = 0.5 * rand();%電圧[V]
    CurOfsError_V = 0.5 * rand();%電圧[V]
    CurOfsError_W = 0.5 * rand();%電圧[V]

    CurGainError_U = 1 + 0.2*(rand() - 0.5);
    CurGainError_V = 1 + 0.2*(rand() - 0.5);
    CurGainError_W = 1 + 0.2*(rand() - 0.5);

    ElecAngNoise = 1e-9;
    ElecAngOfsError = pi*2.0*(rand() - 0.5);

    MotPhaseR = 0.01 + 100 * rand();
    MotPhaseL = 0.01 + 100 * rand();
    MotKV = 0.1 + 1000 * rand();

    VoltAmp = 5;
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
    tic;
    out = sim('VectorControl003');
    toc;

    %% データ保存
    Savedata(out, index, MotPhaseR, MotPhaseL, MotKV,...
             CurGainError_U, CurGainError_V, CurGainError_W,...
             CurOfsError_U, CurOfsError_V, CurOfsError_W,...
             ElecAngOfsError)
end