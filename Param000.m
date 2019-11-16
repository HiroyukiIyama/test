%% ���f���ŗ��p����p�����[�^�Q�̐ݒ�
clear all;

%�d���d��
DCVoltage = 24;

%�A���v�̃p�����[�^
AmpCarryFreq = 20e3;%PWM�̃L�����A���g��

%���[�^�̃p�����[�^
MotPhaseR = 25e-3; %1��������̒�R�l�B���Ԓ�R��1/2�B
MotPhaseL = 38.7e-6; %1��������̃C���_�N�^���X�B���ԃC���_�N�^���X��1/2�B
MotVoltageConst = 1000/27; %�U�N�d���萔
MotInertia = 0.184e-3; %����J�Ȃ̂ŗގ����[�^�̒l�����ݒ�
MotVisco = 1e-6; %1e-6 %����J�Ȃ̂ŗގ����[�^�̒l�����ݒ�
MotPole = 20; %�ɐ�20
MAXRPM = 10000;

Register = [0.01 0.1 1 10 100]; %ohm
Inductance =  [0.01 0.1 1 10 100]; %mH
MotVolt = [0.1 1 10 100 1000]; %V/krpm
[~, size_R] = size(Register);
[~, size_L] = size(Inductance);
[~, size_V] = size(MotVolt);
Table = zeros(size_R * size_L * size_V, 3);
i = 0;
for R = Register
    for L = Inductance
        for V = MotVolt
            s = [R L V];
            i = i+1;
            Table(i,:) = s;

            % Parameters to be predicted
            MotPhaseR = R;
            MotPhaseL = L;
            MotVoltageConst = V;

            for i = 1:10
                % Conditions to cover various motion
                % Vd��Vq��simulink�̒���100ms���Ƃɕω�����悤�ɂ����ق����悳����
                % ���ۂ�Vd��Vq�̑���̓R���g���[������
                % �X�^�[�g�n�_�Ƒ����̌X�����w�肵�āA���d���ŖO�a������ق����悳����
%                 Vq_start = DCVoltage * sqrt(3) * 2 * (rand - 0.5)
%                 Vd_start = DCVoltage * sqrt(3) * 2 * (rand - 0.5)
%                 Vq_end = DCVoltage * sqrt(3) * 2 * (rand - 0.5)
%                 Vd_end = DCVoltage * sqrt(3) * 2 * (rand - 0.5)
                RPM_start = MAXRPM * 2 * (rand - 0.5)
                RPM_end = MAXRPM * 2 * (rand - 0.5)
%                 sim("VectorControl003");
%                 save to csv or something;
%                 clear all;
            end
        end
    end
end
