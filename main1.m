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
%�����ڴ��㹻����������һ���ִ洢�ռ䣬��������ٶȡ�
%��״̬ת�ƾ����10000�η�������ã���ʱֱ�ӵ���
%�������������ʱֱ�Ӱ���һ����ע�͵�
TransMatPower=cell(1,3);
TransMatIdlePower=cell(1,3);
MaxTime=100000;
for j=1:3
    TransMatPower{j}=zeros(MaxTime*4,4);
    TransMatIdlePower{j}=zeros(MaxTime*4,4);
end

for j=1:3
    TransMatPower{j}(1:4,:)=diag([1,1,1,1]);
    TransMatIdlePower{j}(1:4,:)=diag([1,1,1,1]);
    for k=2:MaxTime
        TransMatPower{j}(k*4-3:k*4,:)=TransMatPower{j}(k*4-7:k*4-4,:)*TransMat{j};
        TransMatIdlePower{j}(k*4-3:k*4,:)=TransMatIdlePower{j}(k*4-7:k*4-4,:)*TransMatIdle{j};
    end
end

Ave=zeros(2,MaxTime);

for t=1:10000%����ʱ��
    Sum=0;
    for i=1:100%��������ʱ������д���
        Sum=ThreeMachineTwoBuffer(t,TransMatPower,TransMatIdlePower)+Sum;
        if mod(i,10)==0%ÿ10����һ��ƽ��ֵ
           Ave(1,t*10-10+ceil(i/10))=t;
           Ave(2,t*10-10+ceil(i/10))=Sum/10; 
           Sum=0;
        end
    end
end


% for t=1:10000%����ʱ��
%     for i=1:10
%         Ave(2,t*10-10+i)=ThreeMachineTwoBuffer(t,TransMatPower,TransMatIdlePower);
%         Ave(1,t*10-10+i)=t;
%     end
% end
B = Ave(:,randperm(size(Ave,2)));
save('data1','B');
indata1=B(1,:);
save('indata1','indata1');
outdata1=B(2,:);
save('outdata1','outdata1');