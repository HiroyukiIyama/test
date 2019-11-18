%% ���f���ŗ��p����p�����[�^�Q�̐ݒ�
clear all;

%�d���d��
DCVoltage = 100;

%�A���v�̃p�����[�^
AmpCarryFreq = 20e3;%PWM�̃L�����A���g��

%���[�^�̃p�����[�^
MotPhaseR = 25e-3; %1��������̒�R�l�B���Ԓ�R��1/2�B
MotPhaseL = 38.7e-6; %1��������̃C���_�N�^���X�B���ԃC���_�N�^���X��1/2�B
MotVoltageConst = 1000/27; %�U�N�d���萔

% MotInertia = 0.184e-3; %����J�Ȃ̂ŗގ����[�^�̒l�����ݒ�
% MotVisco = 1e-6; %1e-6 %����J�Ȃ̂ŗގ����[�^�̒l�����ݒ�
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

qVoltIn = ...
    [  0  10; 0.1  10;...
     0.1 -10; 0.2 -10;...
     0.2  10; 0.3  10;...
     0.3 -10; 0.4 -10;...
     0.4   0; 0.5   0;...
     ];

dVoltIn = ...
    [  0   0; 0.1   0;...
     0.1   0; 0.2   0;...
     0.2   0; 0.3   0;...
     0.3   0; 0.4   0;...
     0.4   0; 0.5   0;...
     0.5  10; 0.6  10;...
     0.6 -10; 0.7 -10;...
     0.7  10; 0.8  10;...
     0.8 -10; 0.9 -10;...
     0.9   0; 1.0   0;...
    ];

% Register = [0.01 0.1 1 10 100]; %ohm
% Inductance =  [0.01 0.1 1 10 100]; %mH
% MotVolt = [0.1 1 10 100 1000]; %V/krpm
% for R = Register
%     for L = Inductance
%         for V = MotVolt
%             % Parameters to be predicted
% %             MotPhaseR = R;
% %             MotPhaseL = L;
% %             MotVoltageConst = V;
% 
%             for i = 1:10
%                 % Conditions to cover various motion
%                 % Vd��Vq��simulink�̒���100ms���Ƃɕω�����悤�ɂ����ق����悳����
%                 % ���ۂ�Vd��Vq�̑���̓R���g���[������
%                 % �X�^�[�g�n�_�Ƒ����̌X�����w�肵�āA���d���ŖO�a������ق����悳����
% %                 Vq_start = DCVoltage * sqrt(3) * 2 * (rand - 0.5)
% %                 Vd_start = DCVoltage * sqrt(3) * 2 * (rand - 0.5)
% %                 Vq_end = DCVoltage * sqrt(3) * 2 * (rand - 0.5)
% %                 Vd_end = DCVoltage * sqrt(3) * 2 * (rand - 0.5)
%                 RPM_start = MAXRPM * 2 * (rand - 0.5);
%                 RPM_end = MAXRPM * 2 * (rand - 0.5);
% %                 sim("VectorControl003");
% %                 save to csv or something;
% %                 clear all;
%             end
%         end
%     end
% end
