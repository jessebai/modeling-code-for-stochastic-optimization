MaxTime=10000;
Ave=zeros(2,MaxTime);

for t=1:1400%����ʱ��
    Sum=0;
    for i=1:100%��������ʱ������д���
        Sum=ThreeMachineTwoBufferCorrect(t)+Sum;
        if mod(i,10)==0%ÿ10����һ��ƽ��ֵ
           Ave(1,t*10-10+ceil(i/10))=t;
           Ave(2,t*10-10+ceil(i/10))=Sum/10; 
           Sum=0;
        end
    end
end
% for t=1:10000%����ʱ��
%     for i=1:10
%         Ave(2,t*10-10+i)=ThreeMachineTwoBufferCorrect(t);
%         Ave(1,t*10-10+i)=t;
%     end
% end
B = Ave(:,randperm(size(Ave,2)));
save('data','B');
indata=B(1,:);
save('indata','indata');
outdata=B(2,:);
save('outdata','outdata');

