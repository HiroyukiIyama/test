%% aa
% arg1 �V�~�����[�V�������ʁ@sim�R�}���h�̏o�͂Ƃ��ĕۑ������C���X�^���X
% arg3 �V�~�����[�V������ʁ@X��Y�̊֘A�t���ɗ��p����B����index�̃f�[�^���m���y�A
% arg5 to  8 ���f���o��Y�i���[�^����R�A���[�^�C���_�N�^���X�A���[�^�U�N�d���萔�j
% CSV�ۑ��`���@X�Frow1��index�Arow2�ȍ~�Ɏ��n��f�[�^�Bcolumn1��dCur, column2��qCur...
% CSV�ۑ��`���@Y�Frow1��index�Arow2��MotPhaseR, row3��MotPhaseL...

function Savedata_NoNoise(SimOut, loop, index, IndexNum, MotPhaseR, MotPhaseL, MotKV, ElecAngOfsError)

    SampleTime = 50e-6;%���T���v�����邽�߂̎���
    
    XFileName = strcat('Data_X',num2str(loop,'%d'),'.csv');
    YFileName = strcat('Data_Y',num2str(loop,'%d'),'.csv');
    SFileName = strcat('Data_S',num2str(loop,'%d'),'.csv');

    index = index + (loop - 1)*IndexNum;
    step = [0:SampleTime:1-SampleTime];
    %resample�֐���timeseries�������Ƃ��ēn���K�v������
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
    X = transpose(X);%�e�s�ɓ����ʂ����Ԃ悤�ɐ��`�@ex�F1�s�ڂ�d���d���A2�s�ڂ�q���d���A�A
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