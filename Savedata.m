%% aa
% arg1 �V�~�����[�V�������ʁ@sim�R�}���h�̏o�͂Ƃ��ĕۑ������C���X�^���X
% arg2 �V�~�����[�V������ʁ@X��Y�̊֘A�t���ɗ��p����B����index�̃f�[�^���m���y�A
% arg3 to  5 ���f���o��Y�i���[�^����R�A���[�^�C���_�N�^���X�A���[�^�U�N�d���萔�j
% arg6 to 11 ���f������X (�d���Z���T�Q�C���G���[U�AV�AW�A�d���Z���T�I�t�Z�b�g�G���[U�AV�AW�A�d�C�p�I�t�Z�b�g�G���[
% CSV�ۑ��`���@X�Frow1��index�Arow2�ȍ~�Ɏ��n��f�[�^�Bcolumn1��dCur, column2��qCur...
% CSV�ۑ��`���@Y�Frow1��index�Arow2��MotPhaseR, row3��MotPhaseL...

function Savedata(SimOut, index, MotPhaseR, MotPhaseL, MotKV,...
                  CurGainError_U, CurGainError_V, CurGainError_W,...
                  CurOfsError_U, CurOfsError_V, CurOfsError_W,...
                  ElecAngOfsError)
    %�V�~�����[�V�������f�[�^�̃T���v�����Ԃ͔��ɍׂ������@�ł̎擾������
    %���@�őz�肳���T���v�����ԂŐ��f�[�^���T���v�����O����
    SampleTime = 50e-6;%���T���v�����邽�߂̎���
    XFileName = 'dataset_X.csv';
    YFileName = 'dataset_Y.csv';
    
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
         CurGainError_U, CurGainError_V, CurGainError_W,...
         CurOfsError_U, CurOfsError_V, CurOfsError_W,...
         ElecAngOfsError];
     
    dlmwrite(XFileName, X, '-append');
    dlmwrite(YFileName, Y, '-append');
end
%% bb