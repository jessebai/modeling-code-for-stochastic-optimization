function [Profit] = ThreeMachineTwoBufferCorrect(Time)
%��������������������һ��ʱ�������״̬�µ�����

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

Condition=[1,1,1];%״̬��ʼֵ
ConTh=[3,4,3];%״̬��ֵ
TotalCostOp=0;%������ά����
TotalCostRe=0;%ά���ܷ���
TotalCostBuf=0;%��������Ӫ����

TotalNum=0;%������ܲ�Ʒ��

for t=1:Time
    
    Num=[0,0,0];%��һ�����������뵽�����Ĳ�Ʒ������Ҳ�ǻ������뵽��һ���������Ĳ�Ʒ����
    
    if Buf(1)~=MaxBuf(1)&&Condition(1)<ConTh(1)%Buf1�����һ���1������ת
        Num(1)=min([MaxBuf(1)-Buf(1),ProRate(1)]);
        Condition(1)=conditionTransferCorrect(Condition(1),1,0);%״̬ת��
        %����ά����
        TotalCostOp=TotalCostOp+CostOp(1);
    elseif Buf(1)==MaxBuf(1)&&Condition(1)<ConTh(1)%Buf1���һ���1������ת�����У�
        Num(1)=0;
        Condition(1)=conditionTransferCorrect(Condition(1),1,1);

    elseif Condition(1)>=ConTh(1)
        Num(1)=0;
        %����ά�޷Ѻͻ���1��״̬
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
    
    if Buf(1)~=0&&Buf(2)~=MaxBuf(2)&&Condition(2)<ConTh(2)%���Buf1��Ϊ0��Buf2����,����2״̬����
        Num(2)=min([MaxBuf(2)-Buf(2),ProRate(2),Buf(1)]);
        Condition(2)=conditionTransferCorrect(Condition(2),2,0);%״̬ת��
        %����ά����
        TotalCostOp=TotalCostOp+CostOp(2);
    elseif (Buf(1)==0||Buf(2)==MaxBuf(2))&&Condition(2)<ConTh(2)%���Buf1Ϊ0��Buf2��,����2״̬����(����)
        Num(2)=0;
        Condition(2)=conditionTransferCorrect(Condition(2),2,1);%״̬ת��

    elseif Condition(2)>=ConTh(2)
        Num(2)=0;
        %����ά�޷Ѻͻ���2��״̬
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
    
    if Buf(2)~=0&&Condition(3)<ConTh(3)%���Buf2��Ϊ0,����3״̬����
        Num(3)=min([ProRate(3),Buf(2)]);
        Condition(3)=conditionTransferCorrect(Condition(3),3,0);%״̬ת��
        %����ά����
        TotalCostOp=TotalCostOp+CostOp(3);
    elseif Buf(2)==0&&Condition(3)<ConTh(3)%���Buf2Ϊ0,����3״̬����(����)
        Num(3)=0;
        Condition(3)=conditionTransferCorrect(Condition(3),3,1);%״̬ת��

    elseif Condition(3)>=ConTh(3)
        Num(3)=0;
        %����ά�޷Ѻͻ���3��״̬
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
    TotalCostBuf=TotalCostBuf+CostBuf(1)+CostBuf(2);%��������ά����
    Buf(1)=Buf(1)+Num(1)-Num(2);
    Buf(2)=Buf(2)+Num(2)-Num(3);
    TotalNum=TotalNum+Num(3);
end
Profit=TotalNum*UnitPrice-TotalCostRe-TotalCostOp-TotalCostBuf;
end
        