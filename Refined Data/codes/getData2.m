function getData2(filename)
ctr=1;
data=[];
temp=[];
tempco=[];
tempaq=[];
temptmp=[];
temphum=[];
M=csvread(filename);
for i=2:size(M,1)
    if M(i,8)~=0
        tempco=[tempco M(i,8)];
    end
    tempaq=[tempaq M(i,9)];
    temptmp=[temptmp M(i,10)];
    temphum=[temphum M(i,11)];
    if M(i,1)~=M(i-1,1) || i==size(M(:,1),1)
        if ctr==1
            data=[ctr mean(tempco) mean(tempaq) mean(temptmp) mean(temphum)];
        else
            temp=[ctr mean(tempco) mean(tempaq) mean(temptmp) mean(temphum)];
            data=[data;temp];
        end
        ctr=ctr+1;
        tempco=[];
        tempaq=[];
        temptmp=[];
        temphum=[];
    end
end
csvwrite("saturday.csv",data);