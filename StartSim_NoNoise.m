% ���f���ւ̓���
% �@d���d��(�m�C�Y���܂܂Ȃ�)
% �@q���d��(�m�C�Y���܂܂Ȃ�)
% �@d���d��(����p�^�[���̈���d��)
% �@q���d��(����p�^�[���̈���d��)
% �@��]���x
% 
% ���f���̏o��
% �@���[�^��R
% �@���[�^�C���_�N�^���X
% �@���[�^�U�N�d��
% �@�d�C�p�x�I�t�Z�b�g

%% �S�̌J��Ԃ�
clear all;
for loop = 1:5
    IndexNum = 200; %���n��f�[�^200�Z�b�g�Ŗ�100MByte
    for index = 1:IndexNum
        rng('shuffle'); %�����_���V�[�h�̌��ݎ����𗘗p�����V���b�t��

        DCVoltage = 100;
        AmpCarryFreq = 20e3; %PWM�̃L�����A���g��
        Ts = 1e-6;           %�z���C�g�m�C�Y�̃T���v������
        MotVisco = 0.01*rand()*1e-6; %���[�^�̔S�����C
        ElecAngOfsError = pi * 2.0 * (rand() - 0.5);

        % ���[�^�X�y�b�N�����x���Ƃ��ēǂݍ���
        % 01 �V���[�Y��
        % 02 ��i�d�� W
        % 03 ���̓d�� V
        % 04 �����׉�]�� rpm
        % 05 �����דd�� mA
        % 06 �ő�A���g���N���̉�]�� rpm
        % 07 �ő�A���g���N mNm
        % 08 �ő�A���d�� A
        % 09 �⓮�g���N mNm
        % 10 �N���d�� A
        % 11 �ő���� %
        % 12 �[�q�Ԓ�R ohm
        % 13 �[�q�ԃC���_�N�^���X mH
        % 14 �g���N�萔 mNm/A
        % 15 ��]���萔 rpm/V
        % 16 ��]���^�g���N���z rpm/mNm
        % 17 �@�B�I���萔 ms
        % 18 ���[�^�������[�����g gcm2
        % 19 �i�v���Ύ��Ƀy�A��
        % 20 �ʑ���	���[�^����g

        FileName = 'maxon_motors004_enc.csv';
        MotorSpec = readmatrix(FileName);
        [m,n] = size(MotorSpec);
        randum_index = randi(m);

        %���̓d��
        VNorm = MotorSpec(randum_index,3);
        %�}�N�\���̓��Œ[�q�Ԓ�R���K�肳���
        MotPhaseR = MotorSpec(randum_index,12);
        %�}�N�\����mH�Œ[�q�ԃC���_�N�^���X���K�肳��邽��1e-3��������H�ɕϊ�����
        MotPhaseL = MotorSpec(randum_index,13) * 1e-3;
        %���[�^�[�q�ԓd���̒P�ʕϊ��A���Z
        MotKV = 1 / MotorSpec(randum_index,15); % �P�ʕϊ� rpm/V ���@V/rpm
        MotKV = 1000 * MotKV;                   % �P�ʕϊ� V/rpm ���@V/krpm
        MotKV = 2 * MotKV; %�}�N�\���͒[�q�ԗU�N�d����1/2�Ƃ��Đ��l���K�肳��邽��2�{����
        %�}�N�\���̓C�i�[�V����gcm^2�Ƃ��ċK�肳��邽��1e-7��������kgm^2�ɕϊ�����
        MotInertia = MotorSpec(randum_index,18) * 1e-7;
        MotPole = MotorSpec(randum_index,19);    

        %%���@��z�肵�o������^����(�}10%)
        MotPhaseR = MotPhaseR * (1 + 0.1 * 2 * (rand() - 0.5));
        MotPhaseL = MotPhaseL * (1 + 0.1 * 2 * (rand() - 0.5));
        MotKV = MotKV * (1 + 0.1 * 2 * (rand() - 0.5));
        MotInertia = MotInertia * (1 + 0.1 * 2 * (rand() - 0.5));

        VoltAmp = VNorm / 2; %���@��z�肵�ߑ�ɂȂ�Ȃ��悤�Ɉ�d����ݒ�
        if VoltAmp > 5.0
           VoltAmp = 5.0;
        end

        VoltAmp = VoltAmp * (1 + 0.1 * 2 * (rand() - 0.5)); %���@��z�肵�o������^����

        DeltaT = 0.1;
        T0 = 0.01 * rand();                                %���@��z�肵�o������^����
        T1 = T0 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5));  %���@��z�肵�o������^����
        T2 = T1 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5));  %���@��z�肵�o������^����
        T3 = T2 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5));  %���@��z�肵�o������^����
        T4 = T3 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5));  %���@��z�肵�o������^����
        T5 = T4 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5));  %���@��z�肵�o������^����
        T6 = T5 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5));  %���@��z�肵�o������^����
        T7 = T6 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5));  %���@��z�肵�o������^����
        T8 = T7 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5));  %���@��z�肵�o������^����
        T9 = T8 + DeltaT * (1 + 0.1 * 2 * (rand() -0.5));  %���@��z�肵�o������^����

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

        %% �V�~�����[�V�������{
        tic
        disp(['loop : ' num2str(loop) ' index : ' num2str(index) ' start...']);
        out = sim('VectorControl_NoNoise');
        toc

        %% �f�[�^�ۑ�
        Savedata_NoNoise(out, loop, index, IndexNum, MotPhaseR, MotPhaseL, MotKV, ElecAngOfsError)

        %% ��n��
        clear out;
    end
end