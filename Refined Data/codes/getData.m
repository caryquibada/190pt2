function [CO,AQ,TEMP,HUM]= getData(filename)

M=csvread(filename);

currday=M(1,1);
ctr=1;
tempco=[];
tempaq=[];
temptmp=[];
temphum=[];
for i=2:size(M(:,1))
    if M(i,7)~=0
        tempco=[tempco M(i,7)];
    end
    tempaq=[tempaq M(i,8)];
    temptmp=[temptmp M(i,9)];
    temphum=[temphum M(i,10)];
    if M(i,1)~=M(i-1,1) || i==size(M(:,1),1)
        CO(ctr)=mean(tempco);
        AQ(ctr)=mean(tempaq);
        TEMP(ctr)=mean(temptmp);
        HUM(ctr)=mean(temphum);
        tempco=[];
        tempaq=[];
        temptmp=[];
        temphum=[];
        ctr=ctr+1;
    end
end