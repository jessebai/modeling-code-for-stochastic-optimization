output=zeros(10000,2);
for i=1:10000
    output(i,1)=round(rand*10000);
    output(i,2)=singleMachine(output(i,1));
end
xlswrite( 'data.xls', output);