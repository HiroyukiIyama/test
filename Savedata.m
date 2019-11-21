%% aa
% arg1 シミュレーション結果　simコマンドの出力として保存したインスタンス
% arg2 シミュレーション種別　XとYの関連付けに利用する。同じindexのデータ同士がペア
% arg3 to  5 モデル出力Y（モータ相抵抗、モータインダクタンス、モータ誘起電圧定数）
% arg6 to 11 モデル入力X (電流センサゲインエラーU、V、W、電流センサオフセットエラーU、V、W、電気角オフセットエラー
% CSV保存形式　X：row1にindex、row2以降に時系列データ。column1にdCur, column2にqCur...
% CSV保存形式　Y：row1にindex、row2にMotPhaseR, row3にMotPhaseL...

function Savedata(SimOut, index, MotPhaseR, MotPhaseL, MotKV,...
                  CurGainError_U, CurGainError_V, CurGainError_W,...
                  CurOfsError_U, CurOfsError_V, CurOfsError_W,...
                  ElecAngOfsError)
    %シミュレーション生データのサンプル時間は非常に細かく実機での取得が困難
    %実機で想定されるサンプル時間で生データをサンプリングする
    SampleTime = 50e-6;%リサンプルするための時間
    XFileName = 'dataset_X.csv';
    YFileName = 'dataset_Y.csv';
    
    step = [0:SampleTime:1-SampleTime];
    %resample関数はtimeseriesを引数として渡す必要がある
    dCurRes = resample(SimOut.sigsOut.get('dCur').Values, step);
    dCurRes = [index; dCurRes.Data];
    qCurRes = resample(SimOut.sigsOut.get('qCur').Values, step);
    qCurRes = [index; qCurRes.Data];
    dVoltRes = resample(SimOut.sigsOut.get('dVolt').Values, step);
    dVoltRes = [index; dVoltRes.Data];
    qVoltRes = resample(SimOut.sigsOut.get('qVolt').Values, step);
    qVoltRes = [index; qVoltRes.Data];
    rpmRes = resample(SimOut.sigsOut.get('rpm').Values, step);
    rpmRes = [index; rpmRes.Data];

    X = [dCurRes, qCurRes, dVoltRes, qVoltRes, rpmRes];
    X = transpose(X);%各行に特徴量が並ぶように整形　ex：1行目はd軸電流、2行目はq軸電流、、
    Y = [index, MotPhaseR, MotPhaseL, MotKV,...
         CurGainError_U, CurGainError_V, CurGainError_W,...
         CurOfsError_U, CurOfsError_V, CurOfsError_W,...
         ElecAngOfsError];
     
    dlmwrite(XFileName, X, '-append');
    dlmwrite(YFileName, Y, '-append');
end
%% bb