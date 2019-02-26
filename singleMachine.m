function [Profit] = singleMachine(Time)
%singleMachine ����������һ��ʱ�������״̬�µ�����

%Time=��ʱ��/����ʱ��
%Profit����
TransMat=cell(1,3);%��תʱ��״̬ת�ƾ���
TransMat{1}=[0.7 0.15 0.1 0.05;%�豸1��1ת��1��2��3��4״̬�ĸ��ʣ�4Ϊ���׻�
    0 0.7 0.2 0.1;
    0 0 0.6 0.4;
    0 0 0 1;];
TransMat{2}=[0.65 0.2 0.1 0.05;%�豸2
    0 0.55 0.3 0.15;
    0 0 0.55 0.45;
    0 0 0 1;];
TransMat{3}=[0.75 0.1 0.08 0.07;
    0 0.65 0.2 0.15;
    0 0 0.52 0.48;
    0 0 0 1;];
TransMatIdle=cell(1,3);%����ʱ��״̬ת�ƾ���
TransMatIdle{1}=[0.9 0.05 0.03 0.02;
    0 0.8 0.15 0.05;
    0 0 0.8 0.2;
    0 0 0 1;];
TransMatIdle{2}=[0.85 0.08 0.04 0.03;
    0 0.75 0.2 0.05;
    0 0 0.75 0.25;
    0 0 0 1;];
TransMatIdle{3}=[0.95 0.03 0.01 0.01;
    0 0.85 0.1 0.05;
    0 0 0.8 0.2;
    0 0 0 1;];
%buffer capacity
Buf=[5 5];
%buffer hold cost rate
CostBuf=[0.5 0.4];
%production rate
ProRate=[3 2 1];
%operation cost rate
CostOp=[0.5 0.8 1];
%preventive maintenance cost rate
CostPre=[3 3 4];
%corrective maintenance cost rate
CostCor=[10 10 11];
%probability of successful preventive maintenance
ProbPre=[0.9 0.85 0.95];
%probability of successful corrective maintenance
ProbCor=[0.6 0.55 0.5];
%revenue of unit production of system 
RevenueOfUnit=15;

TransMatPre=cell(1,3);%����ʱ��״̬ת�ƾ���
TransMatPre{1}=diag([1,1,1,1]);
TransMatPre{2}=diag([1,1,1,1]);
TransMatPre{3}=diag([1,1,1,1]);

Condition=1;%״ֵ̬
ConTh=3;%״̬��ֵ
temp=0;
TotalCostOp=0;%������ά����
TotalCostRe=0;%ά���ܷ���
Num=0;%��Ʒ����
% Condition=10;%״̬���ֵ
% CostOp=0;%��ά����
% CostRe=0;%��ά�޷�
% Price=1;%���μ۸�

% PerCostOp=1;%����ά������
% PerDegradation=1;%�������к�����˻��̶�=PerDegradation*rand
% PerCostRe=10;%����ά�޷���
% RePro=0.5;%����ά�޳ɹ���
%ά�޳ɹ���������״ֵ̬=5+rand*2;

for t=1:Time
    if Condition<=ConTh
        Num=Num+ProRate(1);
        TotalCostOp=TotalCostOp+CostOp(1);
        TransMatPre{1}=TransMatPre{1}*TransMat{1};
        temp=rand;
        if temp<TransMatPre{1}(Condition,1)
            Condition=1;
        elseif temp<TransMatPre{1}(Condition,1)+TransMatPre{1}(Condition,2)
            Condition=2;
        elseif temp<TransMatPre{1}(Condition,1)+TransMatPre{1}(Condition,2)+TransMatPre{1}(Condition,3)
            Condition=3;
        else
            Condition=4;
        end
    else
        TotalCostRe=TotalCostRe+CostPre(1);
        if rand<ProbPre(1)
            Condition=1;%ά�޳ɹ���״ֵ̬
        end
    end
end
        
Profit=Num*RevenueOfUnit-TotalCostOp-TotalCostRe;

end

