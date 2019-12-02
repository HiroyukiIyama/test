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
for index = 1760:2000

    %% �p�����[�^�ݒ�

    rng('shuffle'); %�����_���V�[�h�̌��ݎ����𗘗p�����V���b�t��
    %�d���d��
    DCVoltage = 100;
    %�A���v�̃p�����[�^
    AmpCarryFreq = 20e3;%PWM�̃L�����A���g��
    Ts = 1e-6; %�z���C�g�m�C�Y�̃T���v������

    MotInertia = 0.1*rand()*1e-3;
    MotVisco = 0.01*rand()*1e-6;
    MotPole = 1; %�ɐ�20

    MotPhaseR = 0.001 + 10 * rand();
    MotPhaseL = (0.001 + 10 * rand())*1e-3;
    MotKV = 0.01 + 50 * rand();

    VoltAmp = 10;

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

    %% �V�~�����[�V�������{
    tic
    disp(['index : ' num2str(index) ' start...']);
    out = sim('VectorControl_NoNoise');
    disp(['index : ' num2str(index) ' ...end']);
    toc

    %% �f�[�^�ۑ�
    Savedata_NoNoise(out, index, MotPhaseR, MotPhaseL, MotKV,...
             ElecAngOfsError)

    %% ��n��
    clear all;
end