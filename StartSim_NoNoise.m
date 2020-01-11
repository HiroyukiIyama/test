% ���f���ւ̓���
% �@d���d��(�m�C�Y���܂�)
% �@q���d��(�m�C�Y���܂�)
% �@d���d��(�����_���Ő�����������d��)
% �@q���d��(�����_���ɐ�����������d��)
% �@��]���x
% 
% ���f���̏o��
% �@���[�^��R
% �@���[�^�C���_�N�^���X
% �@���[�^�U�N�d��
% �@U���d���Q�C���΂��
% �@V���d���Q�C���΂��
% �@W���d���Q�C���΂��
% �@U���d���I�t�Z�b�g
% �@V���d���I�t�Z�b�g
% �@W���d���I�t�Z�b�g
% �@�d�C�p�x�I�t�Z�b�g
% 
% ���v��
% �@�d���m�C�Y(���F�m�C�Y��^����)
% �@�p�x�m�C�Y(���F�m�C�Y��^����)
% �@���[�^�C�i�[�V��(����̃V�~�����[�V�����Ń����_���ɕύX)
% �@���[�^���C(����̃V�~�����[�V�����Ń����_���ɕύX)


%% �S�̌J��Ԃ�
for index = 1:1
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
    
    %�}�N�\����m���Œ[�q�Ԓ�R���K�肳��邽��1e3�������ă��ɕϊ�����
    MotPhaseR = MotorSpec(randum_index,12) * 1e3;
    MotPhaseL = MotorSpec(randum_index,13);
    MotKV = MotorSpec(randum_index,15);
    MotInertia = MotorSpec(randum_index,18);
    MotPole = MotorSpec(randum_index,19);    
    %�}�N�\���͒[�q�ԗU�N�d����1/2�Ƃ��Đ��l���K�肳��邽��2�{����
    MotKV = MotKV * 2;
    %�}�N�\���̓C�i�[�V����gcm^2�Ƃ��ċK�肳��邽��1e-7��������kgm^2�ɕϊ�����
    MotInertia = MotInertia * 1e-7;

    %�K��X�y�b�N�́}10%�΂����^����
    MotPhaseR = MotPhaseR * (1 + 0.1 * 2 * (rand() - 0.5));
    MotPhaseL = MotPhaseL * (1 + 0.1 * 2 * (rand() - 0.5));
    MotKV = MotKV * (1 + 0.1 * 2 * (rand() - 0.5));
    MotInertia = MotInertia * (1 + 0.1 * 2 * (rand() - 0.5));
    
    %�d����p�^�[���̍쐬
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

    %% �V�~�����[�V�������{
    tic
    disp(['index : ' num2str(index) ' start...']);
    out = sim('VectorControl_NoNoise');
    toc

    %% �f�[�^�ۑ�
    Savedata_NoNoise(out, index, MotPhaseR, MotPhaseL, MotKV,...
             ElecAngOfsError)

    %% ��n��
    clear all;
end