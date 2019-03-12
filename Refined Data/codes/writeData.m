function writeData(day)
data=[];
temp=[];
for i=1:15
    daynum=int2str(i);
    [CO AQ TEMP HUM]=getData(strcat("DATA",daynum,".csv"));
    if i==1
        data=[i CO(day) AQ(day) TEMP(day) HUM(day)];
    elseif i<=15
        temp=[i CO(day) AQ(day) TEMP(day) HUM(day)];
        data=[data;temp];
    end
end
csvwrite(strcat("dayDATA",int2str(day),".csv"),data);
data