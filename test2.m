n1=0;
n2=0;
for i1=1:6*6*4*4*4
    if(result1(i1,1)==result(i1,1)&&round(result1(i1,2),2)==round(result(i1,2),2)&&result1(i1,3)==result(i1,3)&&result1(i1,4)==result(i1,4))
        n1=n1+1;
    else
        n2=n2+1;
        index(n2)=i1;
    end
end