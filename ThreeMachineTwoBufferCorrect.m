function [Profit] = ThreeMachineTwoBufferCorrect(Time)
%三个机器两个缓冲区在一定时间的理想状态下的收益

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

Buf=[0,0];

Condition=[1,1,1];%状态初始值
ConTh=[3,4,3];%状态阈值
TotalCostOp=0;%运行总维护费
TotalCostRe=0;%维修总费用
TotalCostBuf=0;%缓冲区运营费用

TotalNum=0;%输出的总产品数

for t=1:Time
    
    Num=[0,0,0];%上一个缓冲区输入到机器的产品个数，也是机器输入到下一个缓冲区的产品个数
    
    if Buf(1)~=MaxBuf(1)&&Condition(1)<ConTh(1)%Buf1不满且机器1正常运转
        Num(1)=min([MaxBuf(1)-Buf(1),ProRate(1)]);
        Condition(1)=conditionTransferCorrect(Condition(1),1,0);%状态转移
        %更新维护费
        TotalCostOp=TotalCostOp+CostOp(1);
    elseif Buf(1)==MaxBuf(1)&&Condition(1)<ConTh(1)%Buf1满且机器1正常运转（空闲）
        Num(1)=0;
        Condition(1)=conditionTransferCorrect(Condition(1),1,1);

    elseif Condition(1)>=ConTh(1)
        Num(1)=0;
        %更新维修费和机器1的状态
        Temp=rand;
        if Condition(1)==4
            TotalCostRe=TotalCostRe+CostCor(1);
            if Temp<ProbCor(1)
                Condition(1)=1;
            end
        else
            TotalCostRe=TotalCostRe+CostPre(1);
            if Temp<ProbPre(1)
                Condition(1)=1;
            end
        end
    end
    
    if Buf(1)~=0&&Buf(2)~=MaxBuf(2)&&Condition(2)<ConTh(2)%如果Buf1不为0且Buf2不满,机器2状态正常
        Num(2)=min([MaxBuf(2)-Buf(2),ProRate(2),Buf(1)]);
        Condition(2)=conditionTransferCorrect(Condition(2),2,0);%状态转移
        %更新维护费
        TotalCostOp=TotalCostOp+CostOp(2);
    elseif (Buf(1)==0||Buf(2)==MaxBuf(2))&&Condition(2)<ConTh(2)%如果Buf1为0或Buf2满,机器2状态正常(空闲)
        Num(2)=0;
        Condition(2)=conditionTransferCorrect(Condition(2),2,1);%状态转移

    elseif Condition(2)>=ConTh(2)
        Num(2)=0;
        %更新维修费和机器2的状态
        Temp=rand;
        if Condition(2)==4
            TotalCostRe=TotalCostRe+CostCor(2);
            if Temp<ProbCor(2)
                Condition(2)=1;
            end
        else
            TotalCostRe=TotalCostRe+CostPre(2);
            if Temp<ProbPre(2)
                Condition(2)=1;
            end
        end
    end
    
    if Buf(2)~=0&&Condition(3)<ConTh(3)%如果Buf2不为0,机器3状态正常
        Num(3)=min([ProRate(3),Buf(2)]);
        Condition(3)=conditionTransferCorrect(Condition(3),3,0);%状态转移
        %更新维护费
        TotalCostOp=TotalCostOp+CostOp(3);
    elseif Buf(2)==0&&Condition(3)<ConTh(3)%如果Buf2为0,机器3状态正常(空闲)
        Num(3)=0;
        Condition(3)=conditionTransferCorrect(Condition(3),3,1);%状态转移

    elseif Condition(3)>=ConTh(3)
        Num(3)=0;
        %更新维修费和机器3的状态
        Temp=rand;
        if Condition(3)==4
            TotalCostRe=TotalCostRe+CostCor(3);
            if Temp<ProbCor(3)
                Condition(3)=1;
            end
        else
            TotalCostRe=TotalCostRe+CostPre(3);
            if Temp<ProbPre(3)
                Condition(3)=1;
            end
        end
    end
    TotalCostBuf=TotalCostBuf+CostBuf(1)+CostBuf(2);%缓冲区的维护费
    Buf(1)=Buf(1)+Num(1)-Num(2);
    Buf(2)=Buf(2)+Num(2)-Num(3);
    TotalNum=TotalNum+Num(3);
end
Profit=TotalNum*UnitPrice-TotalCostRe-TotalCostOp-TotalCostBuf;
end
        