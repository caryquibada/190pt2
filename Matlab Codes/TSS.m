function [S, Time] = TSS(G)
[n m]=size(G.Nodes);
maxes=[];
deg=[];
for i=1:n
    deg(i)=G.Nodes.CO2PPM(i)*G.Nodes.Degree(i); %Degree multiplied by the PPM
end
G.Nodes.ModDegree=deg';
for i=1:n
    maxes(i)=G.Nodes.CO2PPM(i)/(G.Nodes.ModDegree(i)*(G.Nodes.ModDegree(i))); %To match the change of the PPM
end

G.Nodes.TSSMax=maxes';
S=[];
[n , ~]=size(G.Nodes);
start=tic;
ctr=1;
while prod(G.Nodes.Status)==0
    [a, b]=size(G.Nodes);
    if isempty(find(G.Nodes.CO2PPM==400 & G.Nodes.Status==0,1))==0%Case 1 If the no node is picked, pick the last applicable node
        caseof=1
        %Case 1
        vCandidates=find(G.Nodes.CO2PPM==400 & G.Nodes.Status==0,1);
        currV=vCandidates;
        N=neighbors(G, vCandidates);
        sizeN=length(N);
        for j=1:sizeN
            G.Nodes.CO2PPM(N(j))=max(G.Nodes.CO2PPM(N(j))-(G.Nodes.CO2PPM(currV)/G.Nodes.Degree(currV)),400);
        end
    else
        case2val=find(G.Nodes.ModDegree<=G.Nodes.CO2PPM & G.Nodes.Status ==0,1); %To replicate the past condition of deg<thrshld
        if isempty(case2val)==0
            %Case 2
            caseof=2
            currV=case2val;
            S=[S G.Nodes.Label(currV)];
            N=neighbors(G,currV);
            sizeN=length(N);
            for j=1:sizeN
               G.Nodes.CO2PPM(N(j))=max(G.Nodes.CO2PPM(N(j))-(G.Nodes.CO2PPM(currV)/G.Nodes.Degree(currV)),400);
            end
        else 
            %Case 3
            caseof=3
            maxV=max(G.Nodes.TSSMax);
            argmax=find(G.Nodes.TSSMax==maxV,1)
            currV=argmax;
        end
    end
    fprintf("Case: %g, CurrV: %g\n",caseof,currV);
    ctr=ctr+1;
    N=neighbors(G,currV);
    sizeN=length(N);
    for j=1:sizeN
        G.Nodes.ModDegree(N(j))=max(G.Nodes.ModDegree(N(j))-G.Nodes.CO2PPM(currV),400);
        if G.Nodes.CO2PPM(N(j))~=400 && G.Nodes.Status(N(j))==0
            G.Nodes.TSSMax(N(j))=G.Nodes.CO2PPM(i)/((G.Nodes.ModDegree(i)*(G.Nodes.ModDegree(i))));
        end
    end
    G.Nodes.ModDegree
    G.Nodes.CO2PPM
    G.Nodes.Status(currV)=1;
    G.Nodes.TSSMax(currV)=-inf;
    G.Nodes.CO2PPM(currV)=400;
end
Time=toc(start);
S=str2double(S);