function [Profit] = ThreeMachineTwoBufferTemp(Time)
%TwoMOneB ��������������������һ��ʱ�������״̬�µ�����
%���޸ı���ǰһ�εľ���������������

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

% %�����ڴ��㹻����������һ���ִ洢�ռ䣬��������ٶȡ�
% %��״̬ת�ƾ����10000�η�������ã���ʱֱ�ӵ���
% %�������������ʱֱ�Ӱ���һ����ע�͵�
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

TransMatPre=cell(1,3);%�����õ�״̬ת�ƾ���
TransMatPre{1}=diag([1,1,1,1]);
TransMatPre{2}=diag([1,1,1,1]);
TransMatPre{3}=diag([1,1,1,1]);
Buf=[0,0];

Condition=[1,1,1];%״̬��ʼֵ
ConTh=[3,4,3];%״̬��ֵ
TotalCostOp=0;%������ά����
TotalCostRe=0;%ά���ܷ���
TotalCostBuf=0;%��������Ӫ����

TotalNum=0;%������ܲ�Ʒ��

for t=1:Time
    
    IsEmpty=[0,0];%Buf�Ƿ��
    IsFull=[0,0];%Buf�Ƿ���
    
    Num=[0,0,0];%��Ʒ���������һ����������ѭ����һ����������������������ƣ����һ������������������������ߵ����
    
    if Condition(1)<ConTh(1)%1����������ת
        Num(1)=ProRate(1);
        %����ά����
        TotalCostOp=TotalCostOp+CostOp(1);
        %���»���1��״̬
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
        %����ά�޷�
        if Condition(1)==4%���ǲ��ǹ�����
            TotalCostRe=TotalCostRe+CostCor(1);
        else
            TotalCostRe=TotalCostRe+CostPre(1);
        end
        %���»���1��״̬
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
    
    
    

    Max=3;%���ٸ�����
    
    for i=2:Max%��һ����������һ�Σ��������Ѿ���������ѺͲ�Ʒ�����������һ�μ��㣬����һ����������һ̨�����Ļ��ѺͲ�Ʒ
        if Num(i-1)~=0%��һ�λ���������ת
            if Condition(i)<ConTh(i)%��һ�λ���������ת��2����������ת
                %���»������Ͳ�Ʒ
                Buf(i-1)=Buf(i-1)+Num(i-1)-ProRate(i);
                if Buf(i-1)>MaxBuf(i-1)
                    Buf(i-1)=MaxBuf(i-1);
                    Num(i)=ProRate(i);%���������������������ֵ����ȡ���ֵ��ͬʱ���¸öζ�Ӧ�������Ʒ��
                elseif Buf(i-1)<0
                    Num(i)=ProRate(i)+Buf(i-1);
                    Buf(i-1)=0;%��������������С��0����ȡ0��ͬʱ���¸öζ�Ӧ�������Ʒ��
                else
                    Num(i)=ProRate(i);%������������������¸öζ�Ӧ�������Ʒ��
                end
                %����ά����
                TotalCostOp=TotalCostOp+CostOp(i);
                %���»���2��״̬
                TransMatPre{i}=TransMatPre{i}*TransMat{i}^t;
                Temp=rand;
                TempCondition=Condition(i);%���µ�ǰ��״ֵ̬��ֹ���淢����ʵ����2�ڿ����У�Ҫ��һ��״̬���·�ʽ
                if Temp<TransMatPre{i}(Condition(i),1)
                    Condition(i)=1;
                elseif Temp<TransMatPre{i}(Condition(i),1)+TransMatPre{i}(Condition(i),2)
                    Condition(i)=2;
                elseif Temp<TransMatPre{i}(Condition(i),1)+TransMatPre{i}(Condition(i),2)+TransMatPre{i}(Condition(i),3)
                    Condition(i)=3;
                else
                    Condition(i)=4;
                end
            else%��һ�λ���������ת��2��������
                if Buf(i-1)==MaxBuf(i-1)
                    IsFull(i-1)=1;%����Ƿ�öλ���������
                end
                %���»����������������������������ֵ����ȡ���ֵ
                Buf(i-1)=Buf(i-1)+Num(i-1);
                if Buf(i-1)>MaxBuf(i-1)
                    Buf(i-1)=MaxBuf(i-1);
                end
                %����ά�޷�
                if Condition(i)==4
                    TotalCostRe=TotalCostRe+CostCor(i);
                else
                    TotalCostRe=TotalCostRe+CostPre(i);
                end
                
                %������������ˣ�����һ�������ǿ���״̬�����¸�����һ��������״̬
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
                %���»���2��״̬
                Temp=rand;
                if Condition(i)==4%���ǲ��ǹ�����
                    if Temp<ProbCor(i)
                        Condition(i)=1;
                    end
                else
                    if Temp<ProbPre(i)
                        Condition(i)=1;
                    end
                end
            end
        else%��һ����������
            if Condition(i)<ConTh(i)%2����������ת
                if Buf(i-1)==0
                    IsEmpty=1;
                end
                %����buf��Num
                if Buf(i-1)>ProRate(i)%����������Ĳ�Ʒ�������ڻ���2����������
                    Buf(i-1)=Buf(i-1)-ProRate(i);
                    Num(i)=Num(i)+ProRate(i);
                else%����������Ĳ�Ʒ����С�ڻ���2���������ʣ���ֻ�������뻺�����Ĳ�Ʒ������ͬ�����Ĳ�Ʒ
                    Num(i)=Num(i)+Buf(i-1);
                    Buf(i-1)=0;
                end
                %����ά����
                TotalCostOp=TotalCostOp+CostOp(i);
                %���»���2��״̬�������Ƿ������
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
            else%��һ����������,����2Ҳ����
                %����ά�޷�
                if Condition(i)==4
                    TotalCostRe=TotalCostRe+CostCor(i);
                else
                    TotalCostRe=TotalCostRe+CostPre(i);
                end
                %���»���2��״̬
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
        TotalCostBuf=TotalCostBuf+CostBuf(i-1);%��������ά����
    end
    TotalNum=TotalNum+Num(Max);
end

Profit=TotalNum*UnitPrice-TotalCostRe-TotalCostOp-TotalCostBuf;
end