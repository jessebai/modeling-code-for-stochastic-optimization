function [Profit] = singleMachine(Time)
%singleMachine 单个机器在一定时间的理想状态下的收益

%Time=总时间/单次时间
%Profit利润
TransMat=cell(1,3);%运转时的状态转移矩阵
TransMat{1}=[0.7 0.15 0.1 0.05;%设备1从1转到1，2，3，4状态的概率，4为彻底坏
    0 0.7 0.2 0.1;
    0 0 0.6 0.4;
    0 0 0 1;];
TransMat{2}=[0.65 0.2 0.1 0.05;%设备2
    0 0.55 0.3 0.15;
    0 0 0.55 0.45;
    0 0 0 1;];
TransMat{3}=[0.75 0.1 0.08 0.07;
    0 0.65 0.2 0.15;
    0 0 0.52 0.48;
    0 0 0 1;];
TransMatIdle=cell(1,3);%空闲时的状态转移矩阵
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

TransMatPre=cell(1,3);%空闲时的状态转移矩阵
TransMatPre{1}=diag([1,1,1,1]);
TransMatPre{2}=diag([1,1,1,1]);
TransMatPre{3}=diag([1,1,1,1]);

Condition=1;%状态值
ConTh=3;%状态阈值
temp=0;
TotalCostOp=0;%运行总维护费
TotalCostRe=0;%维修总费用
Num=0;%产品总数
% Condition=10;%状态最高值
% CostOp=0;%总维护费
% CostRe=0;%总维修费
% Price=1;%单次价格

% PerCostOp=1;%单次维护费用
% PerDegradation=1;%单次运行后机器退化程度=PerDegradation*rand
% PerCostRe=10;%单次维修费用
% RePro=0.5;%单次维修成功率
%维修成功后提升的状态值=5+rand*2;

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
            Condition=1;%维修成功后状态值
        end
    end
end
        
Profit=Num*RevenueOfUnit-TotalCostOp-TotalCostRe;

end

