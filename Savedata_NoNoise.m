%% aa
% arg1 シミュレーション結果　simコマンドの出力として保存したインスタンス
% arg3 シミュレーション種別　XとYの関連付けに利用する。同じindexのデータ同士がペア
% arg5 to  8 モデル出力Y（モータ相抵抗、モータインダクタンス、モータ誘起電圧定数）
% CSV保存形式　X：row1にindex、row2以降に時系列データ。column1にdCur, column2にqCur...
% CSV保存形式　Y：row1にindex、row2にMotPhaseR, row3にMotPhaseL...

function Savedata_NoNoise(SimOut, loop, index, IndexNum, MotPhaseR, MotPhaseL, MotKV, ElecAngOfsError)

    SampleTime = 50e-6;%リサンプルするための時間
    
    XFileName = strcat('Data_X',num2str(loop,'%d'),'.csv');
    YFileName = strcat('Data_Y',num2str(loop,'%d'),'.csv');
    SFileName = strcat('Data_S',num2str(loop,'%d'),'.csv');

    index = index + (loop - 1)*IndexNum;
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
         ElecAngOfsError];
    Summary = [index,...
               min(SimOut.sigsOut.get('dCur').Values), max(SimOut.sigsOut.get('dCur').Values),...
               min(SimOut.sigsOut.get('qCur').Values), max(SimOut.sigsOut.get('qCur').Values),...
               min(SimOut.sigsOut.get('dVolt').Values), max(SimOut.sigsOut.get('dVolt').Values),...
               min(SimOut.sigsOut.get('qVolt').Values), max(SimOut.sigsOut.get('qVolt').Values),...
               min(SimOut.sigsOut.get('rpm').Values), max(SimOut.sigsOut.get('rpm').Values),...
              ];
     
    dlmwrite(XFileName, X, '-append');
    dlmwrite(YFileName, Y, '-append');
    dlmwrite(SFileName, Summary, '-append');
end
%% bb