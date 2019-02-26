function [Profit] = TwoMOneB(Time)
%TwoMOneB 两个机器一个缓冲区在一定时间的理想状态下的收益

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

TransMatPre=cell(1,3);%空闲时的状态转移矩阵
TransMatPre{1}=diag([1,1,1,1]);
TransMatPre{2}=diag([1,1,1,1]);
TransMatPre{3}=diag([1,1,1,1]);
Buf=[0,0];

Condition=[1,1];%状态初始值
ConTh=[3,4];%状态阈值
TotalCostOp=0;%运行总维护费
TotalCostRe=0;%维修总费用
TotalCostBuf=0;%缓冲区运营费用
Num=0;%产品总数


for t=1:Time
    
    IsEmpty=[0,0];%Buf是否空
    IsFull=[0,0];%Buf是否满
    if Condition(1)<ConTh(1)%1机器正常运转
        if Condition(2)<ConTh(2)%2机器正常运转
            %更新缓冲区和产品
            Buf(1)=Buf(1)+ProRate(1)-ProRate(2);
            if Buf(1)>MaxBuf(1)
                Buf(1)=MaxBuf(1);
                Num=Num+ProRate(2);
            elseif Buf(1)<0
                Num=Num+ProRate(2)+Buf(1);
                Buf(1)=0;
            else
                Num=Num+ProRate(2);
            end
            %更新维护费
            TotalCostOp=TotalCostOp+CostOp(1)+CostOp(2);
            %更新机器1的状态
            TransMatPre{1}=TransMatPre{1}*TransMat{1}^t;
            temp=rand;
            if temp<TransMatPre{1}(Condition(1),1)
                Condition(1)=1;
            elseif temp<TransMatPre{1}(Condition(1),1)+TransMatPre{1}(Condition(1),2)
                Condition(1)=2;
            elseif temp<TransMatPre{1}(Condition(1),1)+TransMatPre{1}(Condition(1),2)+TransMatPre{1}(Condition(1),3)
                Condition(1)=3;
            else
                Condition(1)=4;
            end
            %更新机器2的状态
            TransMatPre{2}=TransMatPre{2}*TransMat{2}^t;
            temp=rand;
            if temp<TransMatPre{2}(Condition(2),1)
                Condition(2)=1;
            elseif temp<TransMatPre{2}(Condition(2),1)+TransMatPre{2}(Condition(2),2)
                Condition(2)=2;
            elseif temp<TransMatPre{2}(Condition(2),1)+TransMatPre{2}(Condition(2),2)+TransMatPre{2}(Condition(2),3)
                Condition(2)=3;
            else
                Condition(2)=4;
            end
        else%1好2坏
            if Buf(1)==MaxBuf(1)
                IsFull(1)=1;
            end
            Buf(1)=Buf(1)+ProRate(1);
            if Buf(1)>MaxBuf(1)
                Buf(1)=MaxBuf(1);
            end
            %更新维护费
                TotalCostOp=TotalCostOp+CostOp(1);
            %更新维修费
            if Condition(2)==4
                TotalCostRe=TotalCostRe+CostCor(2);
            else
                TotalCostRe=TotalCostRe+CostPre(2);
            end
            %更新机器1的状态
            if IsFull==0
                TransMatPre{1}=TransMatPre{1}*TransMat{1}^t;
            else
                TransMatPre{1}=TransMatPre{1}*TransMatIdle{1}^t;
            end
            temp=rand;
            if temp<TransMatPre{1}(Condition(1),1)
                Condition(1)=1;
            elseif temp<TransMatPre{1}(Condition(1),1)+TransMatPre{1}(Condition(1),2)
                Condition(1)=2;
            elseif temp<TransMatPre{1}(Condition(1),1)+TransMatPre{1}(Condition(1),2)+TransMatPre{1}(Condition(1),3)
                Condition(1)=3;
            else
                Condition(1)=4;
            end
            %更新机器2的状态
            temp=rand;
            if Condition(2)==4
                if temp<ProbCor(2)
                    Condition(2)=1;
                end
            else
                if temp<ProbPre(2)
                    Condition(2)=1;
                end
            end
        end
    else%机器1坏了
        if Condition(2)<ConTh(2)%2机器正常运转
            if Buf(1)==0
                IsEmpty=1;
            end
            %更新buf和Num
            if Buf(1)>=ProRate(2)
                Buf(1)=Buf(1)-ProRate(2);
                Num=Num+ProRate(2);
            else
                Num=Num+Buf(1);
                Buf(1)=0;
            end
            %更新维护费
            TotalCostOp=TotalCostOp+CostOp(2);
            %更新维修费
            if Condition(1)==4
                TotalCostRe=TotalCostRe+CostCor(1);
            else
                TotalCostRe=TotalCostRe+CostPre(1);
            end
            %更新机器2的状态
            if IsEmpty==0
                TransMatPre{2}=TransMatPre{2}*TransMat{2}^t;
            else
                TransMatPre{2}=TransMatPre{2}*TransMatIdle{2}^t;
            end 
            temp=rand;
            if temp<TransMatPre{2}(Condition(2),1)
                Condition(2)=1;
            elseif temp<TransMatPre{2}(Condition(2),1)+TransMatPre{2}(Condition(2),2)
                Condition(2)=2;
            elseif temp<TransMatPre{2}(Condition(2),1)+TransMatPre{2}(Condition(2),2)+TransMatPre{2}(Condition(2),3)
                Condition(2)=3;
            else
                Condition(2)=4;
            end
            %更新机器1的状态
            temp=rand;
            if Condition(1)==4
                if temp<ProbCor(1)
                    Condition(1)=1;
                end
            else
                if temp<ProbPre(1)
                    Condition(1)=1;
                end
            end
        else%1,2都坏了
            %更新维修费
            if Condition(1)==4
                TotalCostRe=TotalCostRe+CostCor(1);
            else
                TotalCostRe=TotalCostRe+CostPre(1);
            end
            if Condition(2)==4
                TotalCostRe=TotalCostRe+CostCor(2);
            else
                TotalCostRe=TotalCostRe+CostPre(2);
            end
            %更新机器1,2的状态
            temp=rand;
            if Condition(1)==4
                if temp<ProbCor(1)
                    Condition(1)=1;
                end
            else
                if temp<ProbPre(1)
                    Condition(1)=1;
                end
            end
            temp=rand;
            if Condition(2)==4
                if temp<ProbCor(2)
                    Condition(2)=1;
                end
            else
                if temp<ProbPre(2)
                    Condition(2)=1;
                end
            end
        end
    end
    TotalCostBuf=TotalCostBuf+CostBuf(1);
end

Profit=Num*UnitPrice-TotalCostRe-TotalCostOp-TotalCostBuf;
end
        


