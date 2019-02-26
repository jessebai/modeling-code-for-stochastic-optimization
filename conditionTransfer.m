function Condition = conditionTransfer(Condition,i,j,t)
%Condition是机器状态，i是第i个机器，j=0是运行，j=1是空闲,t是时间

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

TransMatPre=cell(1,3);%储存用的状态转移矩阵
TransMatPre{1}=diag([1,1,1,1]);
TransMatPre{2}=diag([1,1,1,1]);
TransMatPre{3}=diag([1,1,1,1]);



Temp=rand;

if j==0
    TransMatPre{i}=TransMatPre{i}*TransMat{i}^t;
    if Temp<TransMatPre{i}(Condition,1)
        Condition=1;
    elseif Temp<TransMatPre{i}(Condition,1)+TransMatPre{i}(Condition,2)
        Condition=2;
    elseif Temp<TransMatPre{i}(Condition,1)+TransMatPre{i}(Condition,2)+TransMatPre{i}(Condition,3)
        Condition=3;
    else
        Condition=4;
    end
elseif j==1
    TransMatPre{i}=TransMatPre{i}*TransMatIdle{i}^t;
    if Temp<TransMatPre{i}(Condition,1)
        Condition=1;
    elseif Temp<TransMatPre{i}(Condition,1)+TransMatPre{i}(Condition,2)
        Condition=2;
    elseif Temp<TransMatPre{i}(Condition,1)+TransMatPre{i}(Condition,2)+TransMatPre{i}(Condition,3)
        Condition=3;
    else
        Condition=4;
    end
end

end

