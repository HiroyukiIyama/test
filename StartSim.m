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
for index = 1:1000

    %% �p�����[�^�ݒ�

    %�d���d��
    DCVoltage = 100;
    %�A���v�̃p�����[�^
    AmpCarryFreq = 20e3;%PWM�̃L�����A���g��

    MotInertia = 10*rand()*1e-3;
    MotVisco = rand()*1e-6;
    MotPole = 20; %�ɐ�20

    CurNoise = 1e-9;
    CurOfsError_U = 0.5 * rand();%�d��[V]
    CurOfsError_V = 0.5 * rand();%�d��[V]
    CurOfsError_W = 0.5 * rand();%�d��[V]

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

    %% �V�~�����[�V�������{
    tic;
    out = sim('VectorControl003');
    toc;

    %% �f�[�^�ۑ�
    Savedata(out, index, MotPhaseR, MotPhaseL, MotKV,...
             CurGainError_U, CurGainError_V, CurGainError_W,...
             CurOfsError_U, CurOfsError_V, CurOfsError_W,...
             ElecAngOfsError)
end