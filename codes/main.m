%%%%%%%%%%%%%%%%%%
% RAAD main code %
%%%%%%%%%%%%%%%%%%
clear
load('datasets\breast')
[O,nn,uu] = convert2O(breast); % convert ranker list to opinion matrix O
R = size(O,1);
N = size(O,2);

% Empirical disagreement probabilities
P2 = zeros(R); 
commonInstances = zeros(R); 
for i = 1:R
    for j = i+1:R
        commonInstances(i,j) = numel(find(O(i,:)~=0 & O(j,:)~=0));
        commonInstances(j,i) = commonInstances(i,j);
        if (commonInstances(i,j)~=0)
            P2(i,j) = numel(find(O(i,:)~=O(j,:) & O(i,:)~=0 & O(j,:)~=0))/commonInstances(i,j);
            P2(j,i) = P2(i,j);
        end
    end
end

% Estimate accuracies
predACCAD = fine_optimization(R, P2, 0.01); 
if (numel(find(predACCAD>0.5))<R/2) % Majority of labelers are more accurate than 0.5
    predACCAD = 1-predACCAD;
end
  
% Weighted Majority Voting based on estimated accuracies
tempAcc = repmat(predACCAD, 1, N);
tempAccNeg = repmat(1-predACCAD, 1, N);
O1 = O;
O1(O==2) = 0;
O2 = O;        
O2(O==1) = 0;
O2(O==2) = 1;
s1 = sum(O1.*tempAcc) + sum(O2.*tempAccNeg);
s2 = sum(O2.*tempAcc) + sum(O1.*tempAccNeg);
   
% Decide about orders
foundMat = zeros(nn);
pos = 0;
for i = 1:nn
    for j = i+1:nn
        pos = pos + 1;
        if (s1(pos) > s2(pos))
            foundMat(i,j) = s1(pos);
        end
        if (s2(pos) > s1(pos))
            foundMat(j,i) = s2(pos);
        end
    end
end
    
% Eliminate possible inconsistencies 
ADdag = zeros(size(foundMat));
ADdag(foundMat>0) = 1;
tempPerm = randperm(nn);
newFoundMat = foundMat(tempPerm,:);
newFoundMat = newFoundMat(:,tempPerm);        
newDag = ADdag(tempPerm,:);
newDag = newDag(:,tempPerm);        
if (~isdag(digraph(newDag)))
    newFoundMat = make_dag(newFoundMat); % greedy algorithm to eliminate inconsistencies
    newDag = zeros(size(newFoundMat));      
    newDag(newFoundMat>0) = 1;
end

% Generate final order 
ADOrder = toposort(digraph(newDag),'Order','stable');
ADOrder = tempPerm(ADOrder); % aggregated list with id of elements
ADOrdernames = uu(ADOrder); % aggregated list with original dataset label of elements
