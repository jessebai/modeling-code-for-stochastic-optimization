MaxTime=10000;
Ave=zeros(2,MaxTime);

for t=1:1400%运行时间
    Sum=0;
    for i=1:100%单个运行时间的运行次数
        Sum=ThreeMachineTwoBufferCorrect(t)+Sum;
        if mod(i,10)==0%每10个求一次平均值
           Ave(1,t*10-10+ceil(i/10))=t;
           Ave(2,t*10-10+ceil(i/10))=Sum/10; 
           Sum=0;
        end
    end
end
% for t=1:10000%运行时间
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

