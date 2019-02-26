function [Profit] = ThreeMachineTwoBufferTemp(Time)
%TwoMOneB 三个机器两个缓冲区在一定时间的理想状态下的收益
%可修改保存前一次的矩阵来减少运算量

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

% %电脑内存足够，所以牺牲一部分存储空间，提高运算速度。
% %将状态转移矩阵的10000次方都计算好，到时直接调用
% %在运算次数不多时直接把这一部分注释掉
% TransMatPower=cell(1,3);
% TransMatIdlePower=cell(1,3);
% for j=1:3
%     TransMatPower{j}=zeros(10000*4,4);
%     TransMatIdlePower{j}=zeros(10000*4,4);
% end
% 
% for j=1:3
%     TransMatPower{j}(1:4,:)=diag([1,1,1,1]);
%     TransMatIdlePower{j}(1:4,:)=diag([1,1,1,1]);
%     for k=2:10000
%         TransMatPower{j}(k*4-3:k*4,:)=TransMatPower{j}(k*4-7:k*4-4,:)*TransMat{j};
%         TransMatIdlePower{j}(k*4-3:k*4,:)=TransMatIdlePower{j}(k*4-7:k*4-4,:)*TransMatIdle{j};
%     end
% end

%buffer capacity
MaxBuf=[5 5];
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
UnitPrice=15;

TransMatPre=cell(1,3);%储存用的状态转移矩阵
TransMatPre{1}=diag([1,1,1,1]);
TransMatPre{2}=diag([1,1,1,1]);
TransMatPre{3}=diag([1,1,1,1]);
Buf=[0,0];

Condition=[1,1,1];%状态初始值
ConTh=[3,4,3];%状态阈值
TotalCostOp=0;%运行总维护费
TotalCostRe=0;%维修总费用
TotalCostBuf=0;%缓冲区运营费用

TotalNum=0;%输出的总产品数

for t=1:Time
    
    IsEmpty=[0,0];%Buf是否空
    IsFull=[0,0];%Buf是否满
    
    Num=[0,0,0];%产品输出数，第一个数代表本次循环第一个机器的输出数，依此类推，最后一个数是最后机器的输出，即产线的输出
    
    if Condition(1)<ConTh(1)%1机器正常运转
        Num(1)=ProRate(1);
        %更新维护费
        TotalCostOp=TotalCostOp+CostOp(1);
        %更新机器1的状态
        TempCondition=Condition(1);
        TransMatPre{1}=TransMatPre{1}*TransMat{1}^t;
        Temp=rand;
        if Temp<TransMatPre{1}(Condition(1),1)
            Condition(1)=1;
        elseif Temp<TransMatPre{1}(Condition(1),1)+TransMatPre{1}(Condition(1),2)
            Condition(1)=2;
        elseif Temp<TransMatPre{1}(Condition(1),1)+TransMatPre{1}(Condition(1),2)+TransMatPre{1}(Condition(1),3)
            Condition(1)=3;
        else
            Condition(1)=4;
        end
    else
        %更新维修费
        if Condition(1)==4%看是不是故障修
            TotalCostRe=TotalCostRe+CostCor(1);
        else
            TotalCostRe=TotalCostRe+CostPre(1);
        end
        %更新机器1的状态
        Temp=rand;
        if Condition(1)==4
            if Temp<ProbCor(1)
                Condition(1)=1;
            end
        else
            if Temp<ProbPre(1)
                Condition(1)=1;
            end
        end
    end
    
    
    

    Max=3;%多少个机器
    
    for i=2:Max%第一个机器单独一段，在上面已经计算过花费和产品，下面进入下一段计算，计算一个缓冲区加一台机器的花费和产品
        if Num(i-1)~=0%上一段机器正常运转
            if Condition(i)<ConTh(i)%上一段机器正常运转且2机器正常运转
                %更新缓冲区和产品
                Buf(i-1)=Buf(i-1)+Num(i-1)-ProRate(i);
                if Buf(i-1)>MaxBuf(i-1)
                    Buf(i-1)=MaxBuf(i-1);
                    Num(i)=ProRate(i);%如果缓冲区算出来超过最大值，则取最大值，同时更新该段对应的输出产品数
                elseif Buf(i-1)<0
                    Num(i)=ProRate(i)+Buf(i-1);
                    Buf(i-1)=0;%如果缓冲区算出来小于0，则取0，同时更新该段对应的输出产品数
                else
                    Num(i)=ProRate(i);%如果缓冲区正常，更新该段对应的输出产品数
                end
                %更新维护费
                TotalCostOp=TotalCostOp+CostOp(i);
                %更新机器2的状态
                TransMatPre{i}=TransMatPre{i}*TransMat{i}^t;
                Temp=rand;
                TempCondition=Condition(i);%记下当前的状态值防止后面发现其实机器2在空运行，要换一种状态更新方式
                if Temp<TransMatPre{i}(Condition(i),1)
                    Condition(i)=1;
                elseif Temp<TransMatPre{i}(Condition(i),1)+TransMatPre{i}(Condition(i),2)
                    Condition(i)=2;
                elseif Temp<TransMatPre{i}(Condition(i),1)+TransMatPre{i}(Condition(i),2)+TransMatPre{i}(Condition(i),3)
                    Condition(i)=3;
                else
                    Condition(i)=4;
                end
            else%上一段机器正常运转且2机器坏了
                if Buf(i-1)==MaxBuf(i-1)
                    IsFull(i-1)=1;%标记是否该段缓冲区已满
                end
                %更新缓冲区，更新完若缓冲区超过最大值，则取最大值
                Buf(i-1)=Buf(i-1)+Num(i-1);
                if Buf(i-1)>MaxBuf(i-1)
                    Buf(i-1)=MaxBuf(i-1);
                end
                %更新维修费
                if Condition(i)==4
                    TotalCostRe=TotalCostRe+CostCor(i);
                else
                    TotalCostRe=TotalCostRe+CostPre(i);
                end
                
                %如果缓冲区满了，则上一个机器是空闲状态，重新更新上一个机器的状态
                if IsFull==0
                    TransMatPre{i-1}=TransMatPre{i-1}*TransMatIdle{i-1}^t;
                    Temp=rand;
                    if Temp<TransMatPre{i-1}(TempCondition,1)
                        Condition(i-1)=1;
                    elseif Temp<TransMatPre{i-1}(TempCondition,1)+TransMatPre{i-1}(TempCondition,2)
                        Condition(i-1)=2;
                    elseif Temp<TransMatPre{i-1}(TempCondition,1)+TransMatPre{i-1}(TempCondition,2)+TransMatPre{i-1}(TempCondition,3)
                        Condition(i-1)=3;
                    else
                        Condition(i-1)=4;
                    end
                end
                %更新机器2的状态
                Temp=rand;
                if Condition(i)==4%看是不是故障修
                    if Temp<ProbCor(i)
                        Condition(i)=1;
                    end
                else
                    if Temp<ProbPre(i)
                        Condition(i)=1;
                    end
                end
            end
        else%上一个机器坏了
            if Condition(i)<ConTh(i)%2机器正常运转
                if Buf(i-1)==0
                    IsEmpty=1;
                end
                %更新buf和Num
                if Buf(i-1)>ProRate(i)%如果缓冲区的产品数量大于机器2的生产速率
                    Buf(i-1)=Buf(i-1)-ProRate(i);
                    Num(i)=Num(i)+ProRate(i);
                else%如果缓冲区的产品数量小于机器2的生产速率，则只能生产与缓冲区的产品数量相同数量的产品
                    Num(i)=Num(i)+Buf(i-1);
                    Buf(i-1)=0;
                end
                %更新维护费
                TotalCostOp=TotalCostOp+CostOp(i);
                %更新机器2的状态，考虑是否空运行
                if IsEmpty==0
                    TransMatPre{i}=TransMatPre{i}*TransMat{i}^t;
                else
                    TransMatPre{i}=TransMatPre{i}*TransMatIdle{i}^t;
                end 
                Temp=rand;
                TempCondition=Condition(i);
                if Temp<TransMatPre{i}(Condition(i),1)
                    Condition(i)=1;
                elseif Temp<TransMatPre{i}(Condition(i),1)+TransMatPre{i}(Condition(i),2)
                    Condition(i)=2;
                elseif Temp<TransMatPre{i}(Condition(i),1)+TransMatPre{i}(Condition(i),2)+TransMatPre{i}(Condition(i),3)
                    Condition(i)=3;
                else
                    Condition(i)=4;
                end
            else%上一个机器坏了,机器2也坏了
                %更新维修费
                if Condition(i)==4
                    TotalCostRe=TotalCostRe+CostCor(i);
                else
                    TotalCostRe=TotalCostRe+CostPre(i);
                end
                %更新机器2的状态
                Temp=rand;
                if Condition(i)==4
                    if Temp<ProbCor(i)
                        Condition(i)=1;
                    end
                else
                    if Temp<ProbPre(i)
                        Condition(i)=1;
                    end
                end
            end
        end
        TotalCostBuf=TotalCostBuf+CostBuf(i-1);%缓冲区的维护费
    end
    TotalNum=TotalNum+Num(Max);
end

Profit=TotalNum*UnitPrice-TotalCostRe-TotalCostOp-TotalCostBuf;
end